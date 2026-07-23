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

#Run metadata
$RunId = (New-Guid).Guid

$StartTime = Get-Date

#Script dir
$ScriptDir = Split-Path -Parent $PSCommandPath
$ProjectRoot = Split-Path -Parent (Split-Path -Parent $ScriptDir)
$RepoRoot = Split-Path -Parent $ProjectRoot
$ConfigPath = Join-Path $ProjectRoot "automation\configuration\tenant-config.psd1"
$CsvPath    = Join-Path $ProjectRoot "HR\source\pilot-employees.csv"
$ReportDir  = Join-Path $ProjectRoot "automation\reports"
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

# Source provisioning status constants into global scope so module functions can access them
. "$PSScriptRoot\..\constants\ProvisioningStatus.ps1"
$global:ProvisioningStatus = $ProvisioningStatus

# Create a list to store provisioning results
$Results = [System.Collections.Generic.List[object]]::new()

#check if connected to Microsoft Graph
try {
    $Context = Get-MgContext -ErrorAction Stop

    if (-not $Context -or -not $Context.TenantId -or -not $Context.Account) {
        Write-Host "ERROR: Microsoft Graph context is incomplete. Run Connect-MgGraph -TenantId <tenant-id> and sign in again." -ForegroundColor Red
        exit 1
    }

    Write-Host "Connected to Microsoft Graph as $($Context.Account) in tenant $($Context.TenantId)" -ForegroundColor Green
}
catch {
    Write-Host "ERROR: Not connected to Microsoft Graph. Run Connect-MgGraph first." -ForegroundColor Red
    exit 1
}

#preview mode
if (-not $Live) {

    Write-Host ""
    Write-Host "==============================================" -ForegroundColor Yellow
    Write-Host " PREVIEW MODE" -ForegroundColor Yellow
    Write-Host "==============================================" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "No users will be created."
    Write-Host "Run the script with -Live to provision users."
    Write-Host ""

    return

}
  #get group mappings 
$Mappings = Get-MIGroupMappings `
    -Path (Join-Path $PSScriptRoot "..\configuration\GroupMappings.json")

 #get manager mappings
 $ManagerMappings = Get-MIManagerMappings `
    -Path (Join-Path $PSScriptRoot "..\configuration\ManagerMappings.json")

  #get administrative unit mappings
$AUMappings = Get-MIAUMappings `
    -Path (Join-Path $PSScriptRoot "..\configuration\AdministrativeUnits.json")    

#get license mappings
$LicenseMappings = Get-MILicenseMappings `
    -Path (Join-Path $PSScriptRoot "..\configuration\LicenseMappings.json")   


foreach ($Employee in ($Employees | Select-Object -First $Limit)) {

    $Result = New-MIUser `
        -Employee $Employee `
        -Config $Config

    if ($Result.Status -eq $ProvisioningStatus.Created) {

        Write-Host ""
        Write-Host "========================================"
        Write-Host " GROUP ASSIGNMENT"
        Write-Host "========================================"

        $RequiredGroups = Get-MIRequiredGroups `
            -Employee $Employee `
            -Mappings $Mappings

        Write-Host "User ObjectId : $($Result.ObjectId)"
        Write-Host "Groups:"

        foreach($Group in $RequiredGroups){
            Write-Host " - $Group"
        }

        #add user to required groups
        Add-MIUserToGroups `
    -UserId $Result.ObjectId `
    -Groups $RequiredGroups

# Get the administrative unit for the employee based on the mappings
$AdministrativeUnit = Get-MIAdministrativeUnit `
    -Employee $Employee `
    -Mappings $AUMappings

    #if administrative unit is defined, add user to administrative unit
if ($AdministrativeUnit) {
 
    #add user to administrative unit
    Add-MIUserToAdministrativeUnit `
        -UserId $Result.ObjectId `
        -AdministrativeUnit $AdministrativeUnit

    $Result.AdministrativeUnit = $AdministrativeUnit
    $Result.AUAssigned = $true
}

# Assign manager
$ManagerAssigned = Set-MIUserManager `
    -UserId $Result.ObjectId `
    -Employee $Employee `
    -Mappings $ManagerMappings

$Result.ManagerAssigned = $ManagerAssigned

if ($ManagerAssigned) {
    $Result.Manager = $ManagerMappings.Departments.$($Employee.Department)
}

# ========================================
# LICENSE ASSIGNMENT
# ========================================

$RequiredLicense = Get-MIRequiredLicense `
    -Employee $Employee `
    -Mappings $LicenseMappings

if ($RequiredLicense) {

    Write-Host ""
    Write-Host "========================================"
    Write-Host " LICENSE ASSIGNMENT"
    Write-Host "========================================"

    Write-Host "Employee : $($Employee.FirstName) $($Employee.LastName)"
    Write-Host "License  : $RequiredLicense"

    $LicenseResult = Set-MIUserLicense `
        -UserId $Result.ObjectId `
        -SkuPartNumber $RequiredLicense

    $Result.License = $RequiredLicense
    $Result.LicenseAssigned = $LicenseResult.Success
    $Result.LicenseStatus = $LicenseResult.Status

}

        # Populate report fields
        $Result.DepartmentGroup = ($RequiredGroups | Where-Object {$_ -ne "All Company"}) -join ", "
        $Result.CompanyGroup = "All Company"

    }

    $Results.Add($Result)

}


# Provisioning Summary
$EndTime = Get-Date
$Duration = [math]::Round(($EndTime - $StartTime).TotalSeconds, 2)

$Created = ($Results | Where-Object Status -eq $ProvisioningStatus.Created).Count
$Skipped = ($Results | Where-Object Status -eq $ProvisioningStatus.Skipped).Count
$Failed = ($Results | Where-Object Status -eq $ProvisioningStatus.Failed).Count
$Total = $Results.Count


# Enterprise provisioning treats both Created and Skipped
# as successful processing outcomes.
#

$Successful = $Created + $Skipped

$SuccessRate = if ($Total -gt 0) {

    [math]::Round(($Successful / $Total) * 100,2)

}
else {

    0

}

Write-Host ""
Write-Host "========================================"
Write-Host " Provisioning Summary"
Write-Host "========================================"
Write-Host "Run ID.................. $RunId"
Write-Host "Total Records........... $Total"
Write-Host "Created................ $Created"
Write-Host "Skipped................ $Skipped"
Write-Host "Failed................. $Failed"
Write-Host "Duration............... $Duration sec"
Write-Host "Success Rate........... $SuccessRate%"
Write-Host "========================================"


#
$Results |
Sort-Object EmployeeID |
Format-Table `
EmployeeID,
DisplayName,
Department,
Status,
DepartmentGroup,
CompanyGroup,
Manager,
License,
LicenseStatus,
TemporaryPassword -AutoSize

$TimeStamp = Get-Date -Format "yyyyMMdd-HHmmss"
$ReportDir = Join-Path $RepoRoot "01-Enterprise-Cloud-IAM\automation\reports"

if (-not (Test-Path $ReportDir)) {
    New-Item -ItemType Directory -Path $ReportDir -Force | Out-Null
}

$ReportPath = Join-Path $ReportDir "Provisioning-$TimeStamp.csv"

$Results | Export-Csv $ReportPath -NoTypeInformation

Write-Host ""
Write-Host "========================================"
Write-Host " Report Generated"
Write-Host "========================================"
Write-Host $ReportPath -ForegroundColor Green
Write-Host "========================================"
