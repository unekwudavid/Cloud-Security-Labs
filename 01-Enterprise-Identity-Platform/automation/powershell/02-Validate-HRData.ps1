<#
.SYNOPSIS
Validates the Mustard Innovations pilot HR dataset before user provisioning.

.DESCRIPTION
This script validates the pilot employee CSV file to ensure all required
fields are present and correctly populated before provisioning identities
into Microsoft Entra ID.

.AUTHOR
David Adama

.PROJECT
Mustard Innovations Enterprise Cloud IAM

.VERSION
1.0
#>

# ============================================
# Resolve Project Paths
# ============================================

$ScriptDir = Split-Path -Parent $PSCommandPath

# automation\powershell -> automation -> project root
$ProjectRoot = Split-Path -Parent (Split-Path -Parent $ScriptDir)

# Repository root
$RepoRoot = Split-Path -Parent $ProjectRoot

# ============================================
# Configuration
# ============================================

$ConfigPath = Join-Path `
    $ProjectRoot `
    "automation\configuration\tenant-config.psd1"

$CsvPath = Join-Path `
    $ProjectRoot `
    "HR\source\pilot-employees.csv"

$LogDirectory = Join-Path `
    $ProjectRoot `
    "automation\logs"

$LogPath = Join-Path `
    $LogDirectory `
    "validation-log.txt"

if (!(Test-Path $ConfigPath))
{
    throw "Configuration file not found: $ConfigPath"
}

$Config = Import-PowerShellDataFile $ConfigPath

$ValidDepartments = $Config.Departments
$ValidCountries   = $Config.Countries.Keys

if (!(Test-Path $LogDirectory))
{
    New-Item `
        -ItemType Directory `
        -Path $LogDirectory |
        Out-Null
}

Write-Host ""
Write-Host "Validating Employee ID format..."

foreach ($Employee in $Employees) {

    if ($Employee.EmployeeID -notmatch '^MI-\d{4}$') {

        $ValidationErrors += "Invalid EmployeeID format: $($Employee.EmployeeID)"
    }
}

# ============================================
# Check for Duplicate Employee IDs
# ============================================

Write-Host "Checking for duplicate Employee IDs..."

$DuplicateIDs = $Employees |
Group-Object EmployeeID |
Where-Object { $_.Count -gt 1 }

foreach ($Duplicate in $DuplicateIDs) {

    $ValidationErrors += "Duplicate EmployeeID found: $($Duplicate.Name)"
}

# ============================================
# Validate Departments
# ============================================

Write-Host "Validating Departments..."

foreach ($Employee in $Employees) {

    if ($Employee.Department -notin $ValidDepartments) {

        $ValidationErrors += "Employee $($Employee.EmployeeID): Invalid Department '$($Employee.Department)'"

    }

}

# ============================================
# Validate Countries
# ============================================

Write-Host "Validating Countries..."

foreach ($Employee in $Employees) {

    if ($Employee.Country -notin $ValidCountries) {

        $ValidationErrors += "Employee $($Employee.EmployeeID): Invalid Country '$($Employee.Country)'"

    }

}

# Build Employee ID List

$EmployeeIDs = $Employees.EmployeeID

# ============================================
# Validate Manager Assignments
# ============================================

Write-Host "Validating Manager Assignments..."

foreach ($Employee in $Employees) {

    if (![string]::IsNullOrWhiteSpace($Employee.ManagerEmployeeID)) {

        if ($Employee.ManagerEmployeeID -notin $EmployeeIDs) {

            $ValidationErrors += "Employee $($Employee.EmployeeID): Manager '$($Employee.ManagerEmployeeID)' does not exist"

        }

    }

}

# ============================================
# Validate Self Manager
# ============================================

Write-Host "Checking for Self-Manager Assignments..."

foreach ($Employee in $Employees) {

    if ($Employee.EmployeeID -eq $Employee.ManagerEmployeeID) {

        $ValidationErrors += "Employee $($Employee.EmployeeID): Cannot be their own manager"

    }

}

# ============================================
# Final Validation Result
# ============================================

if ($ValidationErrors.Count -gt 0) {

    Write-Host ""
    Write-Host "============================================="
    Write-Host " VALIDATION FAILED"
    Write-Host "=============================================" -ForegroundColor Red

    $ValidationErrors | Sort-Object | Get-Unique | ForEach-Object {
        Write-Host $_ -ForegroundColor Yellow
    }

    Write-Host ""
    Write-Host "Total Errors: $($ValidationErrors.Count)" -ForegroundColor Red

    exit
}

Write-Host ""
Write-Host "============================================="
Write-Host " ALL VALIDATIONS PASSED"-BackgroundColor Green -ForegroundColor Black
Write-Host "=============================================" -ForegroundColor Green