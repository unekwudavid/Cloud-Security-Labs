<#
.SYNOPSIS
MI.Movers - Identity lifecycle automation.

.DESCRIPTION
Contains reusable functions for employee transfer,
promotion and department changes.

AUTHOR
David Adama

VERSION
1.0
#>

#current state
function Get-MICurrentUserState {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        [string]$EmployeeId

    )

    Write-MILog "Retrieving current identity state for $EmployeeId" "INFO"

    #
    # Locate user
    #

    $Users = Get-MgUser `
        -Filter "employeeId eq '$EmployeeId'" `
        -Property Id,DisplayName,Department,JobTitle,Country,EmployeeId

    if (-not $Users) {

        throw "Employee not found: $EmployeeId"

    }

    if ($Users.Count -gt 1) {

        throw "Multiple users found for EmployeeID: $EmployeeId"

    }

    $User = $Users | Select-Object -First 1

    # Resolve current administrative unit membership from directory AUs
    $AdministrativeUnit = $null
    $AdministrativeUnits = Get-MgDirectoryAdministrativeUnit -All

    foreach ($AU in $AdministrativeUnits) {

        $Members = Get-MgDirectoryAdministrativeUnitMember `
            -AdministrativeUnitId $AU.Id `
            -All

        if ($Members.Id -contains $User.Id) {
            $AdministrativeUnit = $AU.DisplayName
            break
        }

    }

    # Resolve current manager from Graph (best-effort)
    $Manager = $null
    try {
        $ManagerObject = Get-MgUserManager -UserId $User.Id -ErrorAction Stop
        if ($ManagerObject) {
            $Manager = $ManagerObject.AdditionalProperties.displayName
            if ([string]::IsNullOrWhiteSpace($Manager) -and $ManagerObject.DisplayName) {
                $Manager = $ManagerObject.DisplayName
            }
        }
    }
    catch {
        $Manager = $null
    }

    # Resolve current licenses (best-effort)
    $License = $null
    try {
        $LicenseDetails = Get-MgUserLicenseDetail -UserId $User.Id -ErrorAction Stop
        if ($LicenseDetails) {
            $License = @($LicenseDetails | ForEach-Object { $_.SkuPartNumber } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }) -join ', '
        }
    }
    catch {
        $License = $null
    }

    # Resolve current directory role membership (best-effort)
    $Role = $null
    try {
        $RoleMemberships = Get-MgUserMemberOf -UserId $User.Id -All -ErrorAction Stop
        if ($RoleMemberships) {
            $DirectoryRoles = $RoleMemberships |
                Where-Object { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.directoryRole' }

            if ($DirectoryRoles) {
                $Role = @($DirectoryRoles | ForEach-Object { $_.AdditionalProperties.displayName } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }) -join ', '
            }
        }
    }
    catch {
        $Role = $null
    }

    #
    # Return current state
    #

    [PSCustomObject]@{

        ObjectId = if ($User.Id) { ($User.Id -as [string]).Trim() } else { $null }

        EmployeeId = $User.EmployeeId

        DisplayName = $User.DisplayName

        Department = $User.Department

        JobTitle = $User.JobTitle

        Country = $User.Country

        AdministrativeUnit = $AdministrativeUnit

        Manager = $Manager

        License = $License

        Role = $Role

    }

}

#desired state
function Get-MIDesiredUserState {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        $Employee

    )

    [PSCustomObject]@{

        EmployeeId = $Employee.EmployeeID

        Department = if ($Employee.PSObject.Properties['NewDepartment']) {
            ($Employee.NewDepartment -as [string]).Trim()
        }
        else {
            ($Employee.Department -as [string]).Trim()
        }

        JobTitle = if ($Employee.PSObject.Properties['NewJobTitle']) {
            ($Employee.NewJobTitle -as [string]).Trim()
        }
        else {
            ($Employee.JobTitle -as [string]).Trim()
        }

        Country = if ($Employee.PSObject.Properties['NewCountry']) {
            ($Employee.NewCountry -as [string]).Trim()
        }
        else {
            ($Employee.Country -as [string]).Trim()
        }

        AdministrativeUnit = $null

        Manager = if ($Employee.PSObject.Properties['Manager']) {
            ($Employee.Manager -as [string]).Trim()
        }
        else {
            $null
        }

    }

}

#compare state
function Compare-MIUserState {

   param(

    $CurrentState,

    $DesiredState

)
    [PSCustomObject]@{

        DepartmentChanged =
            $CurrentState.Department -ne $DesiredState.Department

        JobTitleChanged =
        $CurrentState.JobTitle -ne $DesiredState.JobTitle
       
        CountryChanged =
            $CurrentState.Country -ne $DesiredState.Country

        AdministrativeUnitChanged =
            $CurrentState.AdministrativeUnit -ne $DesiredState.AdministrativeUnit

        ManagerChanged =
            $CurrentState.Manager -ne $DesiredState.Manager

             Current = $CurrentState

             Desired = $DesiredState

    }

}

#new move plan
function New-MIMovePlan {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        $Changes    

    )

    $Tasks = New-Object System.Collections.Generic.List[object]

    # Shared profile changes for department, job title, or country.
    if ($Changes.DepartmentChanged -or $Changes.JobTitleChanged -or $Changes.CountryChanged) {

        $Tasks.Add([PSCustomObject]@{
            Action   = "UpdateProfile"
            Property = "Profile"
            Priority = 1
            Reason   = "Department, job title, or country changed."
        })

    }

    # Groups should reconcile for department or country changes.
    if ($Changes.DepartmentChanged -or $Changes.CountryChanged) {

        $Tasks.Add([PSCustomObject]@{
            Action   = "UpdateGroups"
            Property = "Groups"
            Priority = 2
            Reason   = "Required group membership is derived from department or country changes."
        })

    }

    # Department changes may require manager reassignment.
    if ($Changes.DepartmentChanged) {

        $Tasks.Add([PSCustomObject]@{
            Action   = "UpdateManager"
            Property = "Department"
            Priority = 3
            Reason   = "Department change triggers manager reconciliation."
        })

    }

    # Administrative unit should reconcile when the observed AU state or country target changes.
    if ($Changes.AdministrativeUnitChanged -or $Changes.CountryChanged) {

        $Tasks.Add([PSCustomObject]@{
            Action   = "UpdateAdministrativeUnit"
            Property = "Country"
            Priority = 4
            Reason   = "Observed AU or target country requires administrative-unit reconciliation."
        })

    }

    # RBAC should reconcile once for department or job title changes.
    if ($Changes.DepartmentChanged -or $Changes.JobTitleChanged) {

        $Tasks.Add([PSCustomObject]@{
            Action   = "UpdateRBAC"
            Property = "RBAC"
            Priority = 5
            Reason   = "Department or job title changed so role assignment should be re-evaluated."
        })

    }

    #
    # Manager Change
    #

    if ($Changes.ManagerChanged) {

        $Tasks.Add([PSCustomObject]@{
            Action   = "UpdateManager"
            Property = "Manager"
            Priority = 1
            Reason   = "Manager field changed explicitly in the source data."
        })

    }

    #
    # License Change (optional)
    #

    if ($Changes.PSObject.Properties.Name -contains "LicenseChanged") {

        if ($Changes.LicenseChanged) {

            $Tasks.Add([PSCustomObject]@{
                Action   = "UpdateLicense"
                Property = "License"
                Priority = 5
                Reason   = "License entitlements changed in the desired state."
            })

        }

    }

    #
    # Sort execution order
    #

    $ExecutionPlan = $Tasks | Sort-Object Priority

    #
    # Return move plan
    #

    [PSCustomObject]@{

        HasChanges = ($ExecutionPlan.Count -gt 0)

        TaskCount  = $ExecutionPlan.Count

        Tasks      = $ExecutionPlan

    }

}
#update user profile
function Update-MIUserProfile {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        [string]$ObjectId,

        [Parameter(Mandatory)]
        $DesiredState

    )

    Write-MILog `
    "Updating profile for $ObjectId (Department, Job Title, Country)" `
    "INFO"

    try {

        $Body = @{

            department = $DesiredState.Department
            jobTitle   = $DesiredState.JobTitle
            country    = $DesiredState.Country

        }

        Update-MgUser `
            -UserId $ObjectId `
            -BodyParameter $Body `
            -ErrorAction Stop

        Write-MILog "User profile updated successfully." "SUCCESS"

        return [PSCustomObject]@{

            Success = $true
            Status  = "Updated"

        }

    }
    catch {

        Write-MILog $_.Exception.Message "ERROR"

        return [PSCustomObject]@{

            Success = $false
            Status  = "Failed"
            Reason  = $_.Exception.Message

        }

    }

}

#update user groups
function Update-MIUserGroups {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        [string]$ObjectId,

        [Parameter(Mandatory)]
        [array]$DesiredGroups

    )

    Write-MILog "Reconciling group memberships..." "INFO"

    try {

        #
        # Current memberships
        #

        $CurrentGroups = Get-MgUserMemberOf `
            -UserId $ObjectId `
            -All |
            Where-Object {$_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.group'} |
            ForEach-Object { $_.AdditionalProperties.displayName }

        #
        # Calculate differences
        #

        $GroupsToAdd = $DesiredGroups | Where-Object {

            $_ -notin $CurrentGroups

        }

        $GroupsToRemove = $CurrentGroups | Where-Object {

            $_ -notin $DesiredGroups

        }

        #
        # Add missing groups
        #

        foreach ($GroupName in $GroupsToAdd) {

            Write-MILog "Adding to $GroupName" "INFO"

            Add-MIUserToGroups `
                -UserId $ObjectId `
                -Groups @($GroupName)

        }

        #
        # Remove obsolete groups
        #

        foreach ($GroupName in $GroupsToRemove) {

            Write-MILog "Removing from $GroupName" "INFO"

            $Group = Get-MgGroup `
                -Filter "displayName eq '$GroupName'"

            if ($Group) {

                Remove-MgGroupMemberByRef `
                    -GroupId $Group.Id `
                    -DirectoryObjectId $ObjectId `
                    -ErrorAction Stop

            }

        }

        Write-MILog "Group reconciliation completed." "SUCCESS"

        return [PSCustomObject]@{

            Success = $true

            Added = $GroupsToAdd

            Removed = $GroupsToRemove

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
# Export functions
Export-ModuleMember -Function `
    Get-MICurrentUserState, `
    Get-MIDesiredUserState, `
    Compare-MIUserState, `
    New-MIMovePlan, `
    Update-MIUserProfile, `
    Update-MIUserGroups              