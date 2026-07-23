<#
.SYNOPSIS
Creates Microsoft Entra Dynamic Security Groups.

.DESCRIPTION
Reads DynamicGroups.json and creates dynamic security groups
using Microsoft Graph PowerShell.

AUTHOR
David Adama

VERSION
1.0
#>

param(
    [switch]$Live
)

Write-Host "===== 07-Create-DynamicGroups.ps1 STARTED =====" -ForegroundColor Green

$ScriptDir = Split-Path -Parent $PSCommandPath
$ProjectRoot = Split-Path -Parent (Split-Path -Parent $ScriptDir)

Import-Module "$ProjectRoot\automation\modules\MI.Automation.psm1" -Force

$ConfigPath = Join-Path $ProjectRoot "automation\configuration\DynamicGroups.json"

$DynamicGroups = Get-MIDynamicGroups `
    -Path $ConfigPath

if (-not $Live) {

    Write-Host ""
    Write-Host "========================================"
    Write-Host " PREVIEW MODE"
    Write-Host "========================================"
    Write-Host ""

    foreach ($Group in $DynamicGroups.Groups) {

        Write-Host $Group.DisplayName
        Write-Host "Rule : $($Group.MembershipRule)"
        Write-Host ""

    }

    return

}

$Results = @()

foreach ($Group in $DynamicGroups.Groups) {

    $Status = New-MIDynamicGroup `
        -Group $Group

    $Results += [PSCustomObject]@{

        DisplayName = $Group.DisplayName

        Rule = $Group.MembershipRule

        Status = $Status

    }

}

Write-Host ""
Write-Host "========================================"
Write-Host " Dynamic Group Summary"
Write-Host "========================================"

$Results | Format-Table -AutoSize

$ReportPath = Join-Path `
    "$ProjectRoot\automation\reports" `
    ("DynamicGroups-{0}.csv" -f (Get-Date -Format "yyyyMMdd-HHmmss"))

$Results | Export-Csv $ReportPath -NoTypeInformation

Write-Host ""
Write-Host "Report:"
Write-Host $ReportPath -ForegroundColor Green