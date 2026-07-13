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

#Execution mode.
param(

    [switch]$Live,

    [int]$Limit = 1

)

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

# Load shared automation helpers
Import-Module "$PSScriptRoot\..\modules\MI.Automation.psm1" -Force
. "$PSScriptRoot\..\constants\ProvisioningStatus.ps1"

# Create a list to store provisioning results
$Results = [System.Collections.Generic.List[object]]::new()

foreach ($Employee in $Employees) {

    $Result = New-MIUser `
        -Employee $Employee `
        -Config $Config

    $Results.Add($Result)

}

Write-Host ""
Write-Host "========================================="
Write-Host " Provisioning Summary"
Write-Host "========================================="

$Results | Format-Table -AutoSize

$TimeStamp = Get-Date -Format "yyyyMMdd-HHmmss"

$ReportPath = ".\reports\Provisioning-$TimeStamp.csv"

$Results | Export-Csv $ReportPath -NoTypeInformation
