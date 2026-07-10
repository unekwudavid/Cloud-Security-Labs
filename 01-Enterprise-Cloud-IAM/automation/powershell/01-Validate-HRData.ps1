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