<#
.SYNOPSIS
Assigns Microsoft Entra directory roles to employees.

.DESCRIPTION
Reads HR data and RoleMappings.json,
determines the required role for each employee,
and assigns the corresponding Microsoft Entra directory role.

AUTHOR
David Adama

VERSION
1.0
#>

param(

    [switch]$Live,

    [int]$Limit = 10

)

# ============================================================
# Load Configuration
# ============================================================

$ScriptDir = Split-Path -Parent $PSCommandPath
$ProjectRoot = Split-Path -Parent (Split-Path -Parent $ScriptDir)

$CsvPath = Join-Path $ProjectRoot "HR\source\pilot-employees.csv"

$RoleMappingPath = Join-Path `
    $ProjectRoot `
    "automation\configuration\RoleMappings.json"

Import-Module `
    "$ProjectRoot\automation\modules\MI.Automation.psm1" `
    -Force

$Employees = Import-Csv $CsvPath

$RoleMappings = Get-MIRoleMappings `
    -Path $RoleMappingPath

$Results = [System.Collections.Generic.List[object]]::new()

# ============================================================
# Preview Mode
# ============================================================

if (-not $Live)
{
    Write-Host ""
    Write-Host "========================================"
    Write-Host " PREVIEW MODE"
    Write-Host "========================================"
    Write-Host ""
    Write-Host "No roles will be assigned."
    Write-Host "Run again using -Live."

    return
}

# ============================================================
# Process Employees
# ============================================================

foreach ($Employee in ($Employees | Select-Object -First $Limit))
{

    Write-MILog "Processing employee $($Employee.EmployeeID)" "INFO"

    $User = Get-MgUser `
        -Filter "employeeId eq '$($Employee.EmployeeID)'"

    if (!$User)
    {
        Write-MILog "User not found: $($Employee.EmployeeID)" "WARN"
        continue
    }

    #
    # Determine required role
    #

    $RoleName = Get-MIRequiredRole `
        -Employee $Employee `
        -Mappings $RoleMappings

    if (!$RoleName)
    {
        Write-MILog "No role mapping found." "WARN"
        continue
    }

    #
    # Assign role
    #

    $Assigned = Add-MIUserToRole `
        -UserId $User.Id `
        -RoleName $RoleName

    #
    # Store result
    #

    $Results.Add(

        [PSCustomObject]@{

            EmployeeID  = $Employee.EmployeeID
            DisplayName = $Employee.DisplayName
            Department  = $Employee.Department
            JobTitle    = $Employee.JobTitle
            Role        = $RoleName
            Status      = if($Assigned){"Assigned"}else{"Failed"}

        }

    )

}

# ============================================================
# Summary
# ============================================================

Write-Host ""
Write-Host "========================================"
Write-Host " RBAC ASSIGNMENT SUMMARY"
Write-Host "========================================"

$Results |
Format-Table `
EmployeeID,
DisplayName,
Department,
JobTitle,
Role,
Status -AutoSize

# ============================================================
# Export Report
# ============================================================

$TimeStamp = Get-Date -Format "yyyyMMdd-HHmmss"

$ReportPath = Join-Path `
    "$ProjectRoot\automation\reports" `
    "RBAC-$TimeStamp.csv"

$Results |
Export-Csv `
    $ReportPath `
    -NoTypeInformation

Write-Host ""
Write-Host "========================================"
Write-Host " Report Generated"
Write-Host "========================================"

Write-Host $ReportPath -ForegroundColor Green