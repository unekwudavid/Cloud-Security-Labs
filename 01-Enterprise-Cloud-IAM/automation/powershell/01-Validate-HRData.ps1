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

# ================================
# Configuration
# ================================

# ============================================
# Organizational Standards
# ============================================

# Load configuration
$Config = Import-PowerShellDataFile ".\automation\config\tenant-config.psd1"

$ValidDepartments = $Config.Departments
$ValidCountries = $Config.Countries.Keys

# Resolve paths relative to the script location (repository root is 3 levels up)
$ScriptDir = Split-Path -Parent $PSCommandPath
$RepoRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $ScriptDir))
$CsvPath = Join-Path $RepoRoot "01-Enterprise-Cloud-IAM\HR\source\pilot-employees.csv"
$LogPath = Join-Path $RepoRoot "01-Enterprise-Cloud-IAM\automation\logs\validation-log.txt"

Write-Host "====================================="
Write-Host " Mustard Innovations IAM Validation"
Write-Host "====================================="
Write-Host ""

# check if the HR dataset exists
if (-not (Test-Path $CsvPath)) {
    Write-Host "ERROR: HR file not found." -ForegroundColor Red
    Write-Host "Expected path: $CsvPath" -ForegroundColor Red
    exit
}

Write-Host "HR dataset located successfully." -ForegroundColor Green

#import the HR dataset
$Employees = Import-Csv $CsvPath

Write-Host "$($Employees.Count) employee records loaded." -ForegroundColor Green

# ============================================
# Validate Mandatory Fields
# ============================================

Write-Host ""
Write-Host "Validating mandatory fields..."

$ValidationErrors = @()

foreach ($Employee in $Employees) {

    if ([string]::IsNullOrWhiteSpace($Employee.EmployeeID)) {
        $ValidationErrors += "Missing EmployeeID"
    }

    if ([string]::IsNullOrWhiteSpace($Employee.FirstName)) {
        $ValidationErrors += "Employee $($Employee.EmployeeID): Missing FirstName"
    }

    if ([string]::IsNullOrWhiteSpace($Employee.LastName)) {
        $ValidationErrors += "Employee $($Employee.EmployeeID): Missing LastName"
    }

    if ([string]::IsNullOrWhiteSpace($Employee.Department)) {
        $ValidationErrors += "Employee $($Employee.EmployeeID): Missing Department"
    }

    if ([string]::IsNullOrWhiteSpace($Employee.Country)) {
        $ValidationErrors += "Employee $($Employee.EmployeeID): Missing Country"
    }
}

# ============================================
# Validate Employee ID Format
# ============================================

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