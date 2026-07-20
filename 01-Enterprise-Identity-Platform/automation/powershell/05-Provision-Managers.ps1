<#
.SYNOPSIS
Creates department manager accounts.

.DESCRIPTION
Provisions management identities before employee onboarding.

AUTHOR
David Adama

VERSION
1.0
#>

param(
    [switch]$Live,
    [int]$Limit = 8
)

Write-Host "===== 05-Provision-Managers.ps1 STARTED =====" -ForegroundColor Green


#==================================================
# Run Metadata
#==================================================

$RunId = (New-Guid).Guid
$StartTime = Get-Date

$ScriptDir   = Split-Path -Parent $PSCommandPath
$ProjectRoot = Split-Path -Parent (Split-Path -Parent $ScriptDir)

$ConfigPath = Join-Path $ProjectRoot "automation\configuration\tenant-config.psd1"
$CsvPath    = Join-Path $ProjectRoot "HR\managers\manager-employees.csv"
$ReportDir  = Join-Path $ProjectRoot "automation\reports"

if (!(Test-Path $ConfigPath)) {
    Write-Host "Configuration file not found." -ForegroundColor Red
    exit
}

if (!(Test-Path $CsvPath)) {
    Write-Host "Manager CSV not found." -ForegroundColor Red
    exit
}

$Config = Import-PowerShellDataFile $ConfigPath
$Employees = Import-Csv $CsvPath

Import-Module "$ProjectRoot\automation\modules\MI.Automation.psm1" -Force

. "$ProjectRoot\automation\constants\ProvisioningStatus.ps1"

$global:ProvisioningStatus = $ProvisioningStatus

$Results = [System.Collections.Generic.List[object]]::new()

#==================================================
# Graph Connection Check
#==================================================



try {

    $Context = Get-MgContext -ErrorAction Stop

    if (-not $Context.Account) {

        Write-Host "Not connected to Microsoft Graph." -ForegroundColor Red
        exit

    }

}
catch {

    Write-Host "Run Connect-MgGraph first." -ForegroundColor Red
    exit

}

#==================================================
# Preview Mode
#==================================================

if (-not $Live) {

    Write-Host ""
    Write-Host "======================================="
    Write-Host " PREVIEW MODE"
    Write-Host "======================================="
    Write-Host ""
    Write-Host "No manager accounts will be created."
    Write-Host "Run again using -Live"
    return

}

#==================================================
# Load Mappings
#==================================================

$Mappings = Get-MIGroupMappings `
    -Path (Join-Path $ProjectRoot "automation\configuration\GroupMappings.json")

$AUMappings = Get-MIAUMappings `
    -Path (Join-Path $ProjectRoot "automation\configuration\AdministrativeUnits.json")

#==================================================
# Provision Managers
#==================================================

foreach ($Employee in ($Employees | Select-Object -First $Limit))
{

    $Result = New-MIUser `
        -Employee $Employee `
        -Config $Config

    if ($Result.Status -eq $ProvisioningStatus.Created)
    {

        $RequiredGroups = Get-MIRequiredGroups `
            -Employee $Employee `
            -Mappings $Mappings

        Add-MIUserToGroups `
            -UserId $Result.ObjectId `
            -Groups $RequiredGroups

        $AdministrativeUnit = Get-MIAdministrativeUnit `
            -Employee $Employee `
            -Mappings $AUMappings

        if ($AdministrativeUnit)
        {

            Add-MIUserToAdministrativeUnit `
                -UserId $Result.ObjectId `
                -AdministrativeUnit $AdministrativeUnit

            $Result.AdministrativeUnit = $AdministrativeUnit
            $Result.AUAssigned = $true

        }

        $Result.DepartmentGroup = ($RequiredGroups | Where-Object {$_ -ne "All Company"}) -join ", "
        $Result.CompanyGroup = "All Company"

    }

    $Results.Add($Result)

}

#==================================================
# Report
#==================================================

$TimeStamp = Get-Date -Format "yyyyMMdd-HHmmss"

if (!(Test-Path $ReportDir))
{
    New-Item -ItemType Directory -Path $ReportDir -Force | Out-Null
}

$ReportPath = Join-Path $ReportDir "Manager-Provisioning-$TimeStamp.csv"

$Results | Export-Csv $ReportPath -NoTypeInformation

Write-Host ""
Write-Host "========================================"
Write-Host " Managers Provisioned"
Write-Host "========================================"

$Results |
Format-Table `
EmployeeID,
DisplayName,
Department,
Status -AutoSize

Write-Host ""
Write-Host "Report:"
Write-Host $ReportPath -ForegroundColor Green