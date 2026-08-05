<#
.SYNOPSIS
Enterprise Identity Lifecycle - Mover Workflow

.DESCRIPTION
Processes employee transfers, promotions,
department changes and location changes.

AUTHOR
David Adama

VERSION
1.0
#>

param(

    [switch]$Live,

    [int]$Limit = 10

)
# ======================================================
# Load Modules
# ======================================================

$ModuleRoot = Join-Path $PSScriptRoot "..\modules"

# Project directory
$ProjectRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..")
$ProjectRoot = $ProjectRoot.Path

$CsvPath = Join-Path $ProjectRoot "HR\source\mover-employees.csv"

Import-Module "$ModuleRoot\MI.Logging.psm1" -Force
Import-Module "$ModuleRoot\MI.Movers.psm1" -Force
Import-Module "$ModuleRoot\MI.Groups.psm1" -Force
Import-Module "$ModuleRoot\MI.AdministrativeUnits.psm1" -Force
Import-Module "$ModuleRoot\MI.Managers.psm1" -Force
Import-Module "$ModuleRoot\MI.Licensing.psm1" -Force
Import-Module "$ModuleRoot\MI.RBAC_Automation.psm1" -Force
Import-Module "$ModuleRoot\MI.Reporting.psm1" 

# load group mappings
$Mappings = Get-MIGroupMappings `
    -Path (Join-Path $PSScriptRoot "..\configuration\GroupMappings.json")

# load administrative unit mappings
$AUMappings = Get-MIAUMappings `
    -Path (Join-Path $PSScriptRoot "..\configuration\AdministrativeUnits.json")   
    
# load RBACMapping
$RBACMappings = Get-Content `
(
Join-Path $PSScriptRoot `
"..\configuration\RBACMappings.json"
) |
ConvertFrom-Json  
#load manager mappings
$ManagerMappings = Get-MIManagerMappings `
    -Path (Join-Path $PSScriptRoot "..\configuration\ManagerMappings.json")
#load license mappings
$LicenseMappings = Get-MILicenseMappings `
    -Path (Join-Path $PSScriptRoot "..\configuration\LicenseMappings.json")

$Employees = Import-Csv $CsvPath |
    Select-Object -First $Limit

# Store move results
$MoveResults = [System.Collections.Generic.List[object]]::new()    

Write-Host ""
Write-Host "========================================"
Write-Host " ENTERPRISE MOVER WORKFLOW"
Write-Host "========================================"

if(-not $Live)
{
    Write-Host ""
    Write-Host "========================================"
    Write-Host " PREVIEW MODE"
    Write-Host "========================================"
    Write-Host ""
    Write-Host "No changes will be applied."
    Write-Host "Run again with -Live."
    Write-Host ""

    return
}

foreach($Employee in $Employees)
{
    try
{
# ======================================================
# Retrieve Current State
# ======================================================

$CurrentState = Get-MICurrentUserState `
    -EmployeeId $Employee.EmployeeID


# ======================================================
# Build Desired State
# ======================================================

$DesiredState = Get-MIDesiredUserState `
    -Employee $Employee

$DesiredState.AdministrativeUnit = Get-MIAdministrativeUnit `
    -Employee $DesiredState `
    -Mappings $AUMappings

# ======================================================
# move result object
# ======================================================
$MoveResult = [PSCustomObject]@{

    RunId = (New-Guid).Guid

    EmployeeId = $CurrentState.EmployeeId

    DisplayName = $CurrentState.DisplayName

    Timestamp = Get-Date

    Duration = $null

    # BEFORE

    DepartmentBefore = if ([string]::IsNullOrWhiteSpace($CurrentState.Department)) { $Employee.OldDepartment } else { $CurrentState.Department }
    JobTitleBefore   = if ([string]::IsNullOrWhiteSpace($CurrentState.JobTitle)) { $Employee.OldJobTitle } else { $CurrentState.JobTitle }
    CountryBefore    = if ([string]::IsNullOrWhiteSpace($CurrentState.Country)) { $Employee.OldCountry } else { $CurrentState.Country }

    # AFTER

    DepartmentAfter = $DesiredState.Department
    JobTitleAfter   = $DesiredState.JobTitle
    CountryAfter    = $DesiredState.Country

    # Manager

    ManagerBefore = $CurrentState.Manager
    ManagerAfter  = $DesiredState.Manager

    # Administrative Unit

    AUBefore = $CurrentState.AdministrativeUnit
    AUAfter  = $DesiredState.AdministrativeUnit

    # License

    LicenseBefore = $CurrentState.License
    LicenseAfter  = $DesiredState.License

    # RBAC

    RoleBefore = $CurrentState.Role
    RoleAfter  = $DesiredState.Role

    ActionsExecuted = @()

    Status = "Running"

}
# ======================================================
# Compare
# ======================================================

$Changes = Compare-MIUserState `
    -CurrentState $CurrentState `
    -DesiredState $DesiredState

# ======================================================
# Generate Move Plan
# ======================================================

$MovePlan = New-MIMovePlan `
    -Changes $Changes

Write-Host ""
Write-Host "========================================"
Write-Host " MOVE PLAN"
Write-Host "========================================"

Write-Host ""
Write-Host "Current vs Desired"
Write-Host "------------------"
Write-Host ("Department      : {0} -> {1}" -f $CurrentState.Department, $DesiredState.Department)
Write-Host ("Job Title       : {0} -> {1}" -f $CurrentState.JobTitle, $DesiredState.JobTitle)
Write-Host ("Country         : {0} -> {1}" -f $CurrentState.Country, $DesiredState.Country)
Write-Host ("Admin Unit      : {0} -> {1}" -f $CurrentState.AdministrativeUnit, $DesiredState.AdministrativeUnit)
Write-Host ("Manager         : {0} -> {1}" -f $CurrentState.Manager, $DesiredState.Manager)
Write-Host ("License         : {0} -> {1}" -f $CurrentState.License, $DesiredState.License)
Write-Host ("RBAC Role       : {0} -> {1}" -f $CurrentState.Role, $DesiredState.Role)
Write-Host ""

$MovePlan | Format-Table -AutoSize

foreach ($Task in $MovePlan.Tasks) {
    Write-Host ("Task {0} -> {1}" -f $Task.Action, $Task.Reason)
}

# ======================================================
# Execute Move Plan
# ======================================================

Write-Host ""
Write-Host "========================================"
Write-Host " EXECUTING MOVE PLAN"
Write-Host "========================================"

$ObjectId = $CurrentState.ObjectId

if ($ObjectId -is [System.Collections.IEnumerable] -and -not ($ObjectId -is [string])) {
    $ObjectIds = @($ObjectId)
    if ($ObjectIds.Count -eq 1) {
        $ObjectId = [string]$ObjectIds[0]
    }
    else {
        throw "Multiple object IDs found for employee '$($Employee.EmployeeID)': $($ObjectIds -join ', ')"
    }
}
else {
    $ObjectId = [string]$ObjectId
}

$ObjectId = $ObjectId.Trim()

if ($ObjectId -match '\s') {
    throw "Invalid object ID value for employee '$($Employee.EmployeeID)': '$ObjectId'"
}

if (-not [string]::IsNullOrWhiteSpace($ObjectId)) {
    foreach($Task in $MovePlan.Tasks)       
    {
      switch ($Task.Action)
    {

        "UpdateProfile" {

            $ActionResult = Update-MIUserProfile `
                -ObjectId $ObjectId `
                -DesiredState $DesiredState

            if (-not $ActionResult) {
                $ActionResult = [PSCustomObject]@{ Status = 'Completed'; Reason = '' }
            }

            $ReasonSuffix = if ($ActionResult.PSObject.Properties.Name -contains 'Reason' -and $ActionResult.Reason) {
                " : $($ActionResult.Reason)"
            }
            else {
                ""
            }

            $MoveResult.ActionsExecuted += (
                "Profile Updated - {0}{1}" -f $ActionResult.Status, $ReasonSuffix
            )

        }

    "UpdateGroups" {

        $DesiredGroups = Get-MIRequiredGroups `
            -Employee $DesiredState `
            -Mappings $Mappings

        $ActionResult = Update-MIUserGroups `
            -ObjectId $ObjectId `
            -DesiredGroups $DesiredGroups

        if (-not $ActionResult) {
            $ActionResult = [PSCustomObject]@{ Status = 'Completed'; Reason = '' }
        }

        $ReasonSuffix = if ($ActionResult.PSObject.Properties.Name -contains 'Reason' -and $ActionResult.Reason) {
            " : $($ActionResult.Reason)"
        }
        else {
            ""
        }

        $MoveResult.ActionsExecuted += (
            "Groups updated - {0}{1}" -f $ActionResult.Status, $ReasonSuffix
        )

    }

    "UpdateAdministrativeUnit" {

        $DesiredAU = Get-MIAdministrativeUnit `
            -Employee $DesiredState `
            -Mappings $AUMappings

        $ActionResult = Update-MIAdministrativeUnit `
            -ObjectId $ObjectId `
            -DesiredAdministrativeUnit $DesiredAU

        if (-not $ActionResult) {
            $ActionResult = [PSCustomObject]@{ Status = 'Completed'; Reason = '' }
        }

        $ReasonSuffix = if ($ActionResult.PSObject.Properties.Name -contains 'Reason' -and $ActionResult.Reason) {
            " : $($ActionResult.Reason)"
        }
        else {
            ""
        }

        $MoveResult.ActionsExecuted += (
            "Administrative Unit updated - {0}{1}" -f $ActionResult.Status, $ReasonSuffix
        )

    }

    "UpdateManager" {

        $DesiredDepartment = ($DesiredState.Department -as [string]).Trim()
        $Manager = $null

        foreach ($key in $ManagerMappings.Departments.PSObject.Properties.Name) {
            if ((($key -as [string]).Trim()).ToLower() -eq $DesiredDepartment.ToLower()) {
                $Manager = $ManagerMappings.Departments.$key
                break
            }
        }

        if ([string]::IsNullOrWhiteSpace($Manager)) {
            $ActionResult = [PSCustomObject]@{ Status = 'Skipped'; Reason = "No manager mapping found for department '$DesiredDepartment'." }
            $MoveResult.ActionsExecuted += ("Manager update - {0} : {1}" -f $ActionResult.Status, $ActionResult.Reason)
            continue
        }

        $ActionResult = Update-MIUserManager `
            -ObjectId $ObjectId `
            -ManagerUPN $Manager

        if (-not $ActionResult) {
            $ActionResult = [PSCustomObject]@{ Status = 'Completed'; Reason = '' }
        }

        $ReasonSuffix = if ($ActionResult.PSObject.Properties.Name -contains 'Reason' -and $ActionResult.Reason) {
            " : $($ActionResult.Reason)"
        }
        else {
            ""
        }

        $MoveResult.ActionsExecuted += (
            "Manager updated - {0}{1}" -f $ActionResult.Status, $ReasonSuffix
        )

    }

    "UpdateLicense" {

        $License = Get-MIRequiredLicense `
            -Employee $DesiredState `
            -Mappings $LicenseMappings

        $ActionResult = Update-MIUserLicense `
            -ObjectId $ObjectId `
            -SkuPartNumber $License

        if (-not $ActionResult) {
            $ActionResult = [PSCustomObject]@{ Status = 'Completed'; Reason = '' }
        }

        $ReasonSuffix = if ($ActionResult.PSObject.Properties.Name -contains 'Reason' -and $ActionResult.Reason) {
            " : $($ActionResult.Reason)"
        }
        else {
            ""
        }

        $MoveResult.ActionsExecuted += (
            "License updated - {0}{1}" -f $ActionResult.Status, $ReasonSuffix
        )

    }

    "UpdateRBAC" {

       $Role = Get-MIRequiredRBACRole `
    -Employee $DesiredState `
    -Mappings $RBACMappings

        $ActionResult = Update-MIUserRBAC `
            -ObjectId $ObjectId `
            -RoleName $Role

        if (-not $ActionResult) {
            $ActionResult = [PSCustomObject]@{ Status = 'Completed'; Reason = '' }
        }

        $ReasonSuffix = if ($ActionResult.PSObject.Properties.Name -contains 'Reason' -and $ActionResult.Reason) {
            " : $($ActionResult.Reason)"
        }
        else {
            ""
        }

        $MoveResult.ActionsExecuted += (
            "RBAC updated - {0}{1}" -f $ActionResult.Status, $ReasonSuffix
        )

    }
        }
    }
}
$MoveResult.Status = "Completed"

#move duration
$MoveResult.Duration =
(
Get-Date
) -
$MoveResult.Timestamp


#save move result
$MoveResults.Add($MoveResult)

    }
    catch
    {
        Write-MILog $_.Exception.Message "ERROR"

        $MoveResults.Add(
            [PSCustomObject]@{
                RunId             = (New-Guid).Guid
                EmployeeId        = $Employee.EmployeeID
                DisplayName       = "$($Employee.FirstName) $($Employee.LastName)"
                DepartmentBefore  = ""
                DepartmentAfter   = $Employee.Department
                JobTitleBefore    = ""
                JobTitleAfter     = $Employee.JobTitle
                CountryBefore     = ""
                CountryAfter      = $Employee.Country
                ManagerBefore     = ""
                ManagerAfter      = ""
                AUBefore          = ""
                AUAfter           = ""
                LicenseBefore     = ""
                LicenseAfter      = ""
                RoleBefore        = ""
                RoleAfter         = ""
                Status            = "Failed"
                Duration          = $null
                Timestamp         = Get-Date
            }
        )
    }
}




# ==========================================
# Export Move Report
# ==========================================

$ReportFolder = Join-Path $ProjectRoot "automation\reports\Moves"

if (Test-Path $ReportFolder)
{
    $reportItem = Get-Item $ReportFolder
    if (-not $reportItem.PSIsContainer)
    {
        Throw "Cannot create report directory '$ReportFolder' because a file already exists at that path. Rename or remove the file and rerun the script."
    }
}
else
{
    New-Item `
        -ItemType Directory `
        -Path $ReportFolder `
        -Force | Out-Null
}

$TimeStamp = Get-Date -Format "yyyyMMdd-HHmmss"

$ReportFile = Join-Path $ReportFolder "Move-$TimeStamp.csv"

Write-Host ""
Write-Host "ProjectRoot : $ProjectRoot"
Write-Host "ReportFolder: $ReportFolder"
Write-Host "ReportFile  : $ReportFile"
Write-Host ""

$MoveResults |
Select-Object `
RunId,
EmployeeId,
DisplayName,
DepartmentBefore,
DepartmentAfter,
JobTitleBefore,
JobTitleAfter,
CountryBefore,
CountryAfter,
ManagerBefore,
ManagerAfter,
AUBefore,
AUAfter,
LicenseBefore,
LicenseAfter,
RoleBefore,
RoleAfter,
Status,
Duration,
Timestamp |
Export-Csv `
$ReportFile `
-NoTypeInformation

if ($MoveResults.Count -eq 1)
{
    $MoveResult = $MoveResults[0]

    Write-Host ""
    Write-Host "=========================================================" -ForegroundColor Cyan
    Write-Host "           ENTERPRISE MOVER EXECUTION COMPLETE" -ForegroundColor Cyan
    Write-Host "=========================================================" -ForegroundColor Cyan

    Write-Host ""
    Write-Host "Employee        : $($MoveResult.DisplayName)"
    Write-Host "Employee ID     : $($MoveResult.EmployeeId)"

    Write-Host ""
    Write-Host "Identity Changes"
    Write-Host "---------------------------------------------------------"

    Write-Host ("Department      : {0}  ->  {1}" -f `
        $MoveResult.DepartmentBefore,
        $MoveResult.DepartmentAfter)

    Write-Host ("Job Title       : {0}  ->  {1}" -f `
        $MoveResult.JobTitleBefore,
        $MoveResult.JobTitleAfter)

    Write-Host ("Country         : {0}  ->  {1}" -f `
        $MoveResult.CountryBefore,
        $MoveResult.CountryAfter)

    Write-Host ("Manager         : {0}  ->  {1}" -f `
        $MoveResult.ManagerBefore,
        $MoveResult.ManagerAfter)

    Write-Host ("Admin Unit      : {0}  ->  {1}" -f `
        $MoveResult.AUBefore,
        $MoveResult.AUAfter)

    Write-Host ("License         : {0}  ->  {1}" -f `
        $MoveResult.LicenseBefore,
        $MoveResult.LicenseAfter)

    Write-Host ("RBAC Role       : {0}  ->  {1}" -f `
        $MoveResult.RoleBefore,
        $MoveResult.RoleAfter)

    Write-Host ""
    Write-Host "Actions Executed"
    Write-Host "---------------------------------------------------------"

    foreach($Action in $MoveResult.ActionsExecuted)
    {
        Write-Host "✔ $Action" -ForegroundColor Green
    }

    Write-Host ""
    Write-Host ("Status          : {0}" -f $MoveResult.Status)
    Write-Host ("Duration        : {0}" -f $MoveResult.Duration)
    Write-Host ("Report          : {0}" -f $ReportFile)

    Write-Host ""
    Write-Host "=========================================================" -ForegroundColor Cyan
}
else
{
    Write-Host ""
    Write-Host "=========================================================" -ForegroundColor Cyan
    Write-Host "           ENTERPRISE MOVER EXECUTION COMPLETE" -ForegroundColor Cyan
    Write-Host "=========================================================" -ForegroundColor Cyan

    $MoveResults |
    Select-Object `
        EmployeeId,
        DisplayName,
        DepartmentBefore,
        DepartmentAfter,
        JobTitleBefore,
        JobTitleAfter,
        Status |
    Format-Table -AutoSize

    Write-Host ""
    Write-Host "Report : $ReportFile" -ForegroundColor Green
}