<#
.SYNOPSIS
Creates pilot users for the Mustard Innovations Enterprise Cloud IAM project.

.DESCRIPTION
Imports validated HR data, generates identity attributes,
and provisions users into Microsoft Entra ID.

AUTHOR
David Adama

VERSION
1.0
#>

# ============================================
# Load Configuration
# ============================================

$ScriptDir = Split-Path -Parent $PSCommandPath
$RepoRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $ScriptDir))
$ConfigPath = Join-Path $RepoRoot "01-Enterprise-Cloud-IAM\automation\config\tenant-config.psd1"
$AlternateConfigPath = Join-Path $RepoRoot "01-Enterprise-Cloud-IAM\automation\configuration\tenant-config.psd1"
$CsvPath = Join-Path $RepoRoot "01-Enterprise-Cloud-IAM\HR\source\pilot-employees.csv"

if (-not (Test-Path $ConfigPath) -and (Test-Path $AlternateConfigPath)) {
    $ConfigPath = $AlternateConfigPath
}

if (-not (Test-Path $ConfigPath)) {
    Write-Host "ERROR: Config file not found at $ConfigPath" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $CsvPath)) {
    Write-Host "ERROR: HR CSV file not found at $CsvPath" -ForegroundColor Red
    exit 1
}

$Config = Import-PowerShellDataFile $ConfigPath
$Employees = Import-Csv $CsvPath

if (-not $Config) {
    Write-Host "ERROR: Configuration failed to load from $ConfigPath" -ForegroundColor Red
    exit 1
}

if (-not $Config.TenantDomain) {
    Write-Host "ERROR: TenantDomain is not defined in configuration." -ForegroundColor Red
    exit 1
}

if (-not $Config.Countries) {
    Write-Host "ERROR: Countries mapping is missing from configuration." -ForegroundColor Red
    exit 1
}

#generate display name for each employee
function Get-DisplayName {

    param($Employee)

    return "$($Employee.FirstName) $($Employee.LastName)"

}

#generate UPN for each employee
function Get-UPN {

    param(
        $Employee,
        $TenantDomain
    )

    return (
        "$($Employee.FirstName).$($Employee.LastName)".ToLower() +
        "@$TenantDomain"
    )

}

#generate mail nickname for each employee
function Get-MailNickname {

    param($Employee)

    return (
        "$($Employee.FirstName).$($Employee.LastName)"
    ).ToLower()

}

#generate usage location for each employee based on country mapping in configuration
function Get-UsageLocation {

    param(
        $Employee,
        $Config
    )

    if (-not $Config.Countries) {
        Write-Warning "Countries mapping is not defined in configuration."
        return ""
    }

    if (-not $Config.Countries.ContainsKey($Employee.Country)) {
        Write-Warning "No usage location mapping found for country '$($Employee.Country)'."
        return ""
    }

    return $Config.Countries[$Employee.Country]

}

Write-Host ""
Write-Host "=============================================="
Write-Host " Mustard Innovations User Provisioning Preview"
Write-Host "=============================================="
Write-Host ""

foreach ($Employee in $Employees) {

    $DisplayName = Get-DisplayName $Employee
    $UPN = Get-UPN $Employee $Config.TenantDomain
    $MailNickname = Get-MailNickname $Employee
    $UsageLocation = Get-UsageLocation $Employee $Config

    Write-Host "----------------------------------------------"
    Write-Host "Employee ID      : $($Employee.EmployeeID)"
    Write-Host "Display Name     : $DisplayName"
    Write-Host "User Principal   : $UPN"
    Write-Host "Mail Nickname    : $MailNickname"
    Write-Host "Department       : $($Employee.Department)"
    Write-Host "Country          : $($Employee.Country)"
    Write-Host "Usage Location   : $UsageLocation"
    Write-Host "Status           : READY"
    Write-Host ""
}