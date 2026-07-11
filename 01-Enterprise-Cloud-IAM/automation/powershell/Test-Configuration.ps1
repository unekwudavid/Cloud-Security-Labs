# Load configuration
$ScriptDir = Split-Path -Parent $PSCommandPath
$RepoRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $ScriptDir))
$ConfigPath = Join-Path $RepoRoot "01-Enterprise-Cloud-IAM\automation\config\tenant-config.psd1"

$Config = Import-PowerShellDataFile $ConfigPath

Write-Host ""
Write-Host "====================================="
Write-Host " Mustard Innovations Configuration"
Write-Host "====================================="
Write-Host ""

Write-Host "Company Name : $($Config.CompanyName)"
Write-Host "Tenant Domain: $($Config.TenantDomain)"
Write-Host "Tenant Prefix: $($Config.TenantShortName)"