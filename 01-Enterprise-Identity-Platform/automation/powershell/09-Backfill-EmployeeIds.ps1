<#
.SYNOPSIS
Backfills Employee IDs for existing Microsoft Entra users.

.DESCRIPTION
Matches HR records to Microsoft Entra users using
UserPrincipalName and populates missing EmployeeId values.

AUTHOR
David Adama

VERSION
2.0
#>

param(

    [switch]$Live,

    [int]$Limit = 999

)

# ============================================================
# Load Required Modules
# ============================================================

$ModuleRoot = Join-Path $PSScriptRoot "..\modules"

Import-Module "$ModuleRoot\MI.Logging.psm1" -Force
Import-Module "$ModuleRoot\MI.Provisioning.psm1" -Force
Import-Module "$ModuleRoot\MI.Reporting.psm1" -Force

# ============================================================
# Run Metadata
# ============================================================

$RunId = (New-Guid).Guid
$StartTime = Get-Date

# ============================================================
# Project Paths
# ============================================================

$ScriptDir = Split-Path -Parent $PSCommandPath
$ProjectRoot = Split-Path -Parent (Split-Path -Parent $ScriptDir)

$CsvPath = Join-Path `
    $ProjectRoot `
    "HR\source\pilot-employees.csv"

if (!(Test-Path $CsvPath)) {

    throw "HR source file not found: $CsvPath"

}

$Employees = Import-Csv $CsvPath

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
    Write-Host "No Employee IDs will be updated."
    Write-Host "Run with -Live to execute."
    Write-Host ""

    return

}

# ============================================================
# Verify Graph Connection
# ============================================================

try {

    $Context = Get-MgContext -ErrorAction Stop

    if (-not $Context.Account) {

        throw "Not connected."

    }

}
catch {

    Write-Host "Connect to Microsoft Graph first." -ForegroundColor Red
    return

}

# ============================================================
# Begin Processing
# ============================================================

foreach($Employee in ($Employees | Select-Object -First $Limit))
{

    $UPN = "$($Employee.FirstName).$($Employee.LastName)".ToLower() +
           "@daveshub.onmicrosoft.com"

    Write-MILog "Processing $UPN" "INFO"

    try {

        $User = Get-MgUser `
            -Filter "userPrincipalName eq '$UPN'" `
            -Property Id,DisplayName,EmployeeId `
            -ErrorAction Stop

    }
    catch {

        Write-MILog $_.Exception.Message "ERROR"

        continue

    }

    if(!$User)
    {

        Write-MILog "User not found." "WARN"

        $Results.Add([PSCustomObject]@{

            EmployeeID = $Employee.EmployeeID
            UserPrincipalName = $UPN
            Status = "User Not Found"

        })

        continue

    }

    if($User.EmployeeId)
    {

        Write-MILog "EmployeeId already assigned." "INFO"

        $Results.Add([PSCustomObject]@{

            EmployeeID = $Employee.EmployeeID
            UserPrincipalName = $UPN
            Status = "Already Assigned"

        })

        continue

    }

    try {

        Update-MgUser `
            -UserId $User.Id `
            -EmployeeId $Employee.EmployeeID `
            -ErrorAction Stop

        Write-MILog "EmployeeId assigned successfully." "SUCCESS"

        $Results.Add([PSCustomObject]@{

            EmployeeID = $Employee.EmployeeID
            UserPrincipalName = $UPN
            Status = "Updated"

        })

    }
    catch {

        Write-MILog $_.Exception.Message "ERROR"

        $Results.Add([PSCustomObject]@{

            EmployeeID = $Employee.EmployeeID
            UserPrincipalName = $UPN
            Status = "Failed"

        })

    }

}

# ============================================================
# Summary
# ============================================================

$EndTime = Get-Date
$Duration = [math]::Round(($EndTime-$StartTime).TotalSeconds,2)

$Updated = ($Results | Where-Object Status -eq "Updated").Count
$Already = ($Results | Where-Object Status -eq "Already Assigned").Count
$Missing = ($Results | Where-Object Status -eq "User Not Found").Count
$Failed = ($Results | Where-Object Status -eq "Failed").Count

Write-Host ""
Write-Host "========================================"
Write-Host " EMPLOYEE ID BACKFILL SUMMARY"
Write-Host "========================================"
Write-Host "Run ID............... $RunId"
Write-Host "Updated.............. $Updated"
Write-Host "Already Assigned..... $Already"
Write-Host "User Not Found....... $Missing"
Write-Host "Failed............... $Failed"
Write-Host "Duration............. $Duration sec"
Write-Host "========================================"

$Results |
Sort-Object EmployeeID |
Format-Table -AutoSize

# ============================================================
# Export Report
# ============================================================

$TimeStamp = Get-Date -Format "yyyyMMdd-HHmmss"

$ReportDir = Join-Path `
    $ProjectRoot `
    "automation\reports"

if(!(Test-Path $ReportDir))
{

    New-Item `
        -ItemType Directory `
        -Path $ReportDir `
        -Force | Out-Null

}

$ReportPath = Join-Path `
    $ReportDir `
    "EmployeeIdBackfill-$TimeStamp.csv"

$Results | Export-Csv `
    $ReportPath `
    -NoTypeInformation

Write-Host ""
Write-Host "========================================"
Write-Host " Report Generated"
Write-Host "========================================"
Write-Host $ReportPath -ForegroundColor Green
Write-Host "========================================"