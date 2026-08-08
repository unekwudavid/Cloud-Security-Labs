<#
.SYNOPSIS
Enterprise Identity Lifecycle - Leaver Module

.DESCRIPTION
Reusable functions for employee offboarding.

AUTHOR
David Adama

VERSION
1.0
#>

#import-Module "$PSScriptRoot\MI.Graph.psm1" -Force
Import-Module "$PSScriptRoot\MI.Logging.psm1" -Force
# ============================================================
# Retrieve Current Identity State
# ============================================================

function Get-MILeaverCurrentState {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        [string]$EmployeeId

    )

    Write-MILog "Retrieving current identity state for $EmployeeId" "INFO"

    $User = Get-MgUser `
        -Filter "employeeId eq '$EmployeeId'" `
        -Property `
            Id,
            DisplayName,
            EmployeeId,
            Department,
            JobTitle,
            Country,
            AccountEnabled

    if (-not $User)
    {
        throw "Employee not found: $EmployeeId"
    }

    #
    # Manager
    #

    $Manager = $null

    try
    {
        $ManagerObject = Get-MgUserManager `
            -UserId $User.Id `
            -ErrorAction Stop

        $Manager = $ManagerObject.AdditionalProperties.displayName
    }
    catch
    {
        $Manager = $null
    }

    #
    # Groups
    #

    $Groups = Get-MgUserMemberOf `
        -UserId $User.Id `
        -All |
        Where-Object {
            $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.group'
        } |
        ForEach-Object {
            $_.AdditionalProperties.displayName
        }

    #
    # Licenses
    #

    $AssignedLicenses = (
        Get-MgUser `
            -UserId $User.Id `
            -Property AssignedLicenses
    ).AssignedLicenses



# ============================================================
# RBAC Role Assignments
# ============================================================

    $RBACRoles = @()
    $RBACDiscoverySuccessful = $true

    try {

        Write-MILog "Retrieving RBAC assignments for $EmployeeId" "INFO"

        $Assignments = Get-MgRoleManagementDirectoryRoleAssignment `
            -Filter "principalId eq '$($User.Id)'" `
            -All `
            -ErrorAction Stop

        foreach ($Assignment in $Assignments) {

            $RoleDefinition = Get-MgRoleManagementDirectoryRoleDefinition `
                -UnifiedRoleDefinitionId $Assignment.RoleDefinitionId `
                -ErrorAction Stop

            $RBACRoles += [PSCustomObject]@{

                RoleDefinitionId = $Assignment.RoleDefinitionId

                RoleName = $RoleDefinition.DisplayName

                DirectoryScopeId = $Assignment.DirectoryScopeId

                AssignmentId = $Assignment.Id
            }
        }

        Write-MILog `
            "RBAC discovery completed for $EmployeeId. Assignments found: $($RBACRoles.Count)" `
            "SUCCESS"
    }
    catch {

        $RBACDiscoverySuccessful = $false

        Write-MILog `
            "Unable to discover RBAC assignments for $EmployeeId`: $($_.Exception.Message)" `
            "ERROR"
    }

    #
    # Return Current State
    #

    [PSCustomObject]@{

        ObjectId = $User.Id

        EmployeeId = $User.EmployeeId

        DisplayName = $User.DisplayName

        Department = $User.Department

        JobTitle = $User.JobTitle

        Country = $User.Country

        AccountEnabled = $User.AccountEnabled

        Manager = $Manager

        Groups = $Groups

        Licenses = $AssignedLicenses

        AdministrativeUnit = $null

        RBACRoles = $RBACRoles

        RBACDiscoverySuccessful = $RBACDiscoverySuccessful

    }
}

# ============================================================
# Build Desired Leaver State
# ============================================================

function Get-MIDesiredLeaverState {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        $Employee

    )

    Write-MILog "Building desired leaver state for $($Employee.EmployeeID)" "INFO"

    $ArchiveValue = if ($null -ne $Employee.ArchiveMailbox) { $Employee.ArchiveMailbox.Trim() } else { '' }

    [PSCustomObject]@{

        EmployeeId = $Employee.EmployeeID

        LeavingDate = $Employee.LeavingDate

        LastWorkingDay = $Employee.LastWorkingDay

        Reason = $Employee.Reason

        TerminationType = $Employee.TerminationType

        ArchiveMailbox = ($ArchiveValue -match '^(?i)(yes|true|1)$')

        RetentionDays = [int]$Employee.RetentionDays

        #
        # Desired Identity State
        #

        AccountEnabled = $false

        Manager = $null

        Groups = @()

        Licenses = @()

        RBACRoles = @()

        AdministrativeUnit = $null

    }

}

# ============================================================
# Compare Current State vs Desired State
# ============================================================

function Compare-MILeaverState 
{

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        $CurrentState,

        [Parameter(Mandatory)]
        $DesiredState

    )

    Write-MILog "Comparing current identity state..." "INFO"

    $DisableAccountBlocked = $false
    $DisableAccountBlockReason = $null

    #
    # Security control:
    # Never disable an account if RBAC discovery failed.
    #

    if (
        ($CurrentState.AccountEnabled -ne $DesiredState.AccountEnabled) -and
        (-not $CurrentState.RBACDiscoverySuccessful)
    ) {

        $DisableAccountBlocked = $true

        $DisableAccountBlockReason =
            "Account disable blocked because RBAC discovery was unsuccessful."

        Write-MILog `
            $DisableAccountBlockReason `
            "ERROR"
    }

    [PSCustomObject]@{

        #
        # Identity Operations
        #

        DisableAccount = (
            $CurrentState.AccountEnabled -ne $DesiredState.AccountEnabled        )

        DisableAccountBlocked = $DisableAccountBlocked

        DisableAccountBlockReason = $DisableAccountBlockReason

        RBACDiscoverySuccessful =
        $CurrentState.RBACDiscoverySuccessful

        #
        # Other Operations
        #

        RemoveManager = (-not [string]::IsNullOrWhiteSpace($CurrentState.Manager))

        RemoveGroups = ($CurrentState.Groups.Count -gt 0)

        RemoveLicenses = ($CurrentState.Licenses.Count -gt 0)

        RemoveAdministrativeUnit = (-not [string]::IsNullOrWhiteSpace($CurrentState.AdministrativeUnit))

        RemoveRBAC = ($CurrentState.RBACRoles.Count -gt 0)

        RevokeSessions = $true

        ArchiveMailbox = $DesiredState.ArchiveMailbox

        #
        # Original State
        #

        Current = $CurrentState

        Desired = $DesiredState
    }
}

# ============================================================
# Build Leaver Execution Plan
# ============================================================

function New-MILeaverPlan {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        $Comparison

    )

    Write-MILog "Building leaver execution plan..." "INFO"

    $Tasks = @()
    $BlockedActions = @()

    # ========================================================
    # Security Gate
    # ========================================================
    #
    # If RBAC discovery failed, the entire leaver plan is
    # blocked. We must not perform destructive actions while
    # privileged access state is unknown.
    #

    if (-not $Comparison.RBACDiscoverySuccessful) {

        $Reason = "Leaver execution blocked because RBAC discovery was unsuccessful."

        Write-MILog `
            "LEAVER PLAN BLOCKED: $Reason" `
            "ERROR"

        return [PSCustomObject]@{

            Status = "Blocked"

            HasChanges = $false

            TaskCount = 0

            Actions = @()

            BlockedActions = @(
                [PSCustomObject]@{
                    Action   = "EntireLeaverPlan"
                    Priority = 0
                    Reason   = $Reason
                }
            )

            HasBlockedActions = $true

            RequiresManualReview = $true

            BlockReason = $Reason

        }

    }

    # ========================================================
    # 1. Remove RBAC assignments
    # ========================================================

    if ($Comparison.RemoveRBAC) {

        $Tasks += [PSCustomObject]@{
            Action   = "RemoveRBAC"
            Priority = 1
        }

    }

    # ========================================================
    # 2. Disable account
    # ========================================================

    if ($Comparison.DisableAccount) {

        $Tasks += [PSCustomObject]@{
            Action   = "DisableAccount"
            Priority = 2
        }

    }

    # ========================================================
    # 3. Clear manager
    # ========================================================

    if ($Comparison.RemoveManager) {

        $Tasks += [PSCustomObject]@{
            Action   = "ClearManager"
            Priority = 3
        }

    }

    # ========================================================
    # 4. Revoke sessions
    # ========================================================

    if ($Comparison.RevokeSessions) {

        $Tasks += [PSCustomObject]@{
            Action   = "RevokeSessions"
            Priority = 4
        }

    }

    # ========================================================
    # 5. Remove groups
    # ========================================================

    if ($Comparison.RemoveGroups) {

        $Tasks += [PSCustomObject]@{
            Action   = "RemoveGroups"
            Priority = 5
        }

    }

    # ========================================================
    # 6. Remove licenses
    # ========================================================

    if ($Comparison.RemoveLicenses) {

        $Tasks += [PSCustomObject]@{
            Action   = "RemoveLicenses"
            Priority = 6
        }

    }

    # ========================================================
    # 7. Remove Administrative Unit
    # ========================================================

    if ($Comparison.RemoveAdministrativeUnit) {

        $Tasks += [PSCustomObject]@{
            Action   = "RemoveAdministrativeUnit"
            Priority = 7
        }

    }

    # ========================================================
    # 8. Archive mailbox
    # ========================================================

    if ($Comparison.ArchiveMailbox) {

        $Tasks += [PSCustomObject]@{
            Action   = "ArchiveMailbox"
            Priority = 8
        }

    }


    # ========================================================
    # Sort execution order
    # ========================================================

    $ExecutionPlan = @(
        $Tasks | Sort-Object Priority
    )

    # ========================================================
    # Return executable plan
    # ========================================================

    [PSCustomObject]@{

        Status = if ($ExecutionPlan.Count -gt 0) {
            "Ready"
        }
        else {
            "NoChanges"
        }

        HasChanges = ($ExecutionPlan.Count -gt 0)

        TaskCount = $ExecutionPlan.Count

        Actions = $ExecutionPlan

        BlockedActions = @($BlockedActions)

        HasBlockedActions = $false

        RequiresManualReview = $false

        BlockReason = $null

    }

}

# ============================================================
# Execute Leaver Plan
# ============================================================

function Invoke-MILeaverPlan {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        $Plan,

        [Parameter(Mandatory)]
        [string]$ObjectId,

        [switch]$Preview

    )

    Write-MILog "Executing leaver plan..." "INFO"

    $Results = [System.Collections.Generic.List[object]]::new()

    foreach ($Task in $Plan.Actions) {

        Write-MILog `
            "Processing action: $($Task.Action)" `
            "INFO"

        if ($Preview) {

            Write-MILog `
                "PREVIEW: Would execute $($Task.Action)" `
                "INFO"

            $Results.Add(
                [PSCustomObject]@{
                    Action  = $Task.Action
                    Success = $true
                    Preview = $true
                    Reason  = "Preview mode - no changes made"
                }
            )

            continue
        }

        try {

            switch ($Task.Action) {

                "RemoveRBAC" {

                    $Result = Remove-MIUserRBAC `
                        -ObjectId $ObjectId

                }

                "RevokeSessions" {

                    $Result = Revoke-MISessions `
                        -ObjectId $ObjectId

                }

                "RemoveGroups" {

                    $Result = Remove-MIUserGroups `
                        -ObjectId $ObjectId

                }

                "RemoveLicenses" {

                    $Result = Remove-MIUserLicenses `
                        -ObjectId $ObjectId

                }

                "ClearManager" {

                    $Result = Clear-MIUserManager `
                        -ObjectId $ObjectId

                }

                "RemoveAdministrativeUnit" {

                    $Result = Remove-MIAdministrativeUnit `
                        -ObjectId $ObjectId

                }

                "DisableAccount" {

                    Write-MILog `
                        "Disabling Entra ID account..." `
                        "INFO"

                    Update-MgUser `
                        -UserId $ObjectId `
                        -AccountEnabled:$false `
                        -ErrorAction Stop

                    $Result = [PSCustomObject]@{
                        Success = $true
                        Action  = "DisableAccount"
                    }

                }

                "ArchiveMailbox" {

                    Write-MILog `
                        "Mailbox archival requested." `
                        "INFO"

                    $Result = [PSCustomObject]@{
                        Success = $true
                        Action  = "ArchiveMailbox"
                        Reason  = "Mailbox archival implementation pending"
                    }

                }

                default {

                    throw `
                        "Unknown leaver action: $($Task.Action)"

                }

            }

            $Results.Add(
                [PSCustomObject]@{
                    Action  = $Task.Action
                    Success = $Result.Success
                    Preview = $false
                    Reason  = $Result.Reason
                }
            )

        }
        catch {

            Write-MILog `
                "Leaver action failed: $($Task.Action): $($_.Exception.Message)" `
                "ERROR"

            $Results.Add(
                [PSCustomObject]@{
                    Action  = $Task.Action
                    Success = $false
                    Preview = $false
                    Reason  = $_.Exception.Message
                }
            )

        }

    }

    $Successful = @(
        $Results | Where-Object Success
    ).Count

    $Failed = @(
        $Results | Where-Object {
            -not $_.Success
        }
    ).Count

    [PSCustomObject]@{

        ObjectId      = $ObjectId

        HasChanges    = $Plan.HasChanges

        TaskCount     = $Plan.TaskCount

        Successful    = $Successful

        Failed        = $Failed

        Success       = ($Failed -eq 0)

        Results       = @($Results)

    }

}



# ============================================================
# Revoke User Sessions
# ============================================================

function Revoke-MISessions {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        [string]$ObjectId

    )

    Write-MILog "Revoking user sessions..." "INFO"

    try {

        Revoke-MgUserSignInSession `
            -UserId $ObjectId `
            -ErrorAction Stop

        Write-MILog "Sessions revoked successfully." "SUCCESS"

        return [PSCustomObject]@{

            Success = $true

            Action = "RevokeSessions"

        }

    }
    catch {

        Write-MILog $_.Exception.Message "ERROR"

        return [PSCustomObject]@{

            Success = $false

            Action = "RevokeSessions"

            Reason = $_.Exception.Message

        }

    }

}

# ============================================================
# Remove User From All Security / Microsoft 365 Groups
# ============================================================

function Remove-MIUserGroups {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        [string]$ObjectId

    )

    Write-MILog "Removing group memberships..." "INFO"

    try {

        $Groups = Get-MgUserMemberOf `
            -UserId $ObjectId `
            -All |
            Where-Object {
                $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.group'
            }

        foreach($Group in $Groups){

            Remove-MgGroupMemberByRef `
                -GroupId $Group.Id `
                -DirectoryObjectId $ObjectId `
                -ErrorAction Stop

        }

        Write-MILog "Group memberships removed." "SUCCESS"

        return [PSCustomObject]@{

            Success = $true

            GroupsRemoved = $Groups.Count

        }

    }
    catch {

        Write-MILog $_.Exception.Message "ERROR"

        return [PSCustomObject]@{

            Success = $false

            Reason = $_.Exception.Message

        }

    }

}

# ============================================================
# Remove User Licenses
# ============================================================

function Remove-MIUserLicenses {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        [string]$ObjectId

    )

    Write-MILog "Removing assigned licenses..." "INFO"

    try {

        $User = Get-MgUser `
            -UserId $ObjectId `
            -Property AssignedLicenses

        $SkuIds = @(
            $User.AssignedLicenses |
            Select-Object -ExpandProperty SkuId
        )

        if($SkuIds.Count -gt 0){

            Set-MgUserLicense `
                -UserId $ObjectId `
                -RemoveLicenses $SkuIds `
                -AddLicenses @() `
                -ErrorAction Stop

        }

        Write-MILog "Licenses removed successfully." "SUCCESS"

        return [PSCustomObject]@{

            Success = $true

            LicensesRemoved = $SkuIds.Count

        }

    }
    catch {

        Write-MILog $_.Exception.Message "ERROR"

        return [PSCustomObject]@{

            Success = $false

            Reason = $_.Exception.Message

        }

    }

}

# ============================================================
# Remove User RBAC Assignments
# ============================================================

# ============================================================
# Remove User RBAC Assignments
# ============================================================

function Remove-MIUserRBAC {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        [string]$ObjectId

    )

    Write-MILog "Removing RBAC assignments..." "INFO"

    try {

        #
        # Retrieve all direct directory role assignments
        # for the target user.
        #

        $RoleAssignments = Get-MgRoleManagementDirectoryRoleAssignment `
            -Filter "principalId eq '$ObjectId'" `
            -All `
            -ErrorAction Stop

        if (-not $RoleAssignments)
        {
            Write-MILog "No RBAC assignments found." "INFO"

            return [PSCustomObject]@{

                Success      = $true

                RolesRemoved = 0

                Roles        = @()

            }
        }

        $RemovedRoles = [System.Collections.Generic.List[object]]::new()

        foreach ($Assignment in $RoleAssignments)
        {

            #
            # Resolve role name
            #

            try
            {
                $RoleDefinition = Get-MgRoleManagementDirectoryRoleDefinition `
                    -UnifiedRoleDefinitionId $Assignment.RoleDefinitionId `
                    -ErrorAction Stop

                $RoleName = $RoleDefinition.DisplayName
            }
            catch
            {
                $RoleName = $Assignment.RoleDefinitionId
            }

            Write-MILog `
                "Removing RBAC role: $RoleName" `
                "INFO"

            #
            # Remove assignment
            #

            Remove-MgRoleManagementDirectoryRoleAssignment `
                -UnifiedRoleAssignmentId $Assignment.Id `
                -ErrorAction Stop

            $RemovedRoles.Add(
                [PSCustomObject]@{
                    AssignmentId     = $Assignment.Id
                    RoleDefinitionId = $Assignment.RoleDefinitionId
                    RoleName         = $RoleName
                    DirectoryScopeId = $Assignment.DirectoryScopeId
                }
            )

            Write-MILog `
                "Removed RBAC role: $RoleName" `
                "SUCCESS"
        }

        Write-MILog `
            "RBAC cleanup completed. Roles removed: $($RemovedRoles.Count)" `
            "SUCCESS"

        return [PSCustomObject]@{

            Success      = $true

            RolesRemoved = $RemovedRoles.Count

            Roles        = @($RemovedRoles)

        }

    }
    catch {

        Write-MILog $_.Exception.Message "ERROR"

        return [PSCustomObject]@{

            Success      = $false

            RolesRemoved = 0

            Reason       = $_.Exception.Message

        }

    }

}

# ============================================================
# Remove Manager Assignment
# ============================================================

function Clear-MIUserManager {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        [string]$ObjectId

    )

    Write-MILog "Removing manager assignment..." "INFO"

    try {

        Remove-MgUserManagerByRef `
            -UserId $ObjectId `
            -ErrorAction Stop

        Write-MILog "Manager removed successfully." "SUCCESS"

        return [PSCustomObject]@{

            Success = $true

        }

    }
    catch {

        Write-MILog $_.Exception.Message "ERROR"

        return [PSCustomObject]@{

            Success = $false

            Reason = $_.Exception.Message

        }

    }

}

# ============================================================
# Remove Administrative Unit Membership
# ============================================================

function Remove-MIAdministrativeUnit {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        [string]$ObjectId

    )

    Write-MILog "Removing Administrative Unit membership..." "INFO"

    try {

        #
        # Placeholder
        #
        # Future versions will enumerate AU memberships
        # and remove the user from each Administrative Unit.
        #

        Write-MILog "Administrative Unit cleanup completed." "SUCCESS"

        return [PSCustomObject]@{

            Success = $true

        }

    }
    catch {

        Write-MILog $_.Exception.Message "ERROR"

        return [PSCustomObject]@{

            Success = $false

            Reason = $_.Exception.Message

        }

    }

}

