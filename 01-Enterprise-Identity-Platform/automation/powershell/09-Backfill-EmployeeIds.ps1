<#
.SYNOPSIS
Backfills Employee IDs for existing Microsoft Entra users.

.DESCRIPTION
Matches users from the HR source file to existing Entra users
using UserPrincipalName.

If EmployeeId is empty, it updates the account.

AUTHOR
David Adama

VERSION
1.0
#>

param(

    [switch]$Live,

    [int]$Limit = 999

)

$ScriptDir = Split-Path -Parent $PSCommandPath
$ProjectRoot = Split-Path -Parent (Split-Path -Parent $ScriptDir)

$CsvPath = Join-Path `
    $ProjectRoot `
    "HR\source\pilot-employees.csv"

$Employees = Import-Csv $CsvPath

$Results = @()

if (-not $Live)
{
    Write-Host ""
    Write-Host "======================================"
    Write-Host " PREVIEW MODE"
    Write-Host "======================================"
    Write-Host ""
    Write-Host "No Employee IDs will be updated."
    Write-Host "Run again using -Live."
    Write-Host ""

    return
}

foreach($Employee in ($Employees | Select-Object -First $Limit))
{

    $UPN = "$($Employee.FirstName).$($Employee.LastName)".ToLower() +
           "@daveshub.onmicrosoft.com"

    Write-Host ""
    Write-Host "Processing $UPN"

    $User = Get-MgUser `
        -Filter "userPrincipalName eq '$UPN'" `
        -Property Id,DisplayName,EmployeeId

    if(!$User)
    {
        Write-Host "User not found." -ForegroundColor Yellow

        $Results += [PSCustomObject]@{

            EmployeeID=$Employee.EmployeeID
            UserPrincipalName=$UPN
            Status="User Not Found"

        }

        continue
    }

    if($User.EmployeeId)
    {

        Write-Host "Already has EmployeeId ($($User.EmployeeId))" `
            -ForegroundColor Green

        $Results += [PSCustomObject]@{

            EmployeeID=$Employee.EmployeeID
            UserPrincipalName=$UPN
            Status="Already Assigned"

        }

        continue

    }

    Update-MgUser `
        -UserId $User.Id `
        -EmployeeId $Employee.EmployeeID

    Write-Host "EmployeeId assigned." `
        -ForegroundColor Cyan

    $Results += [PSCustomObject]@{

        EmployeeID=$Employee.EmployeeID
        UserPrincipalName=$UPN
        Status="Updated"

    }

}

Write-Host ""
Write-Host "========================================"
Write-Host " EMPLOYEE ID BACKFILL SUMMARY"
Write-Host "========================================"

$Results | Format-Table -AutoSize