<#
.SYNOPSIS
Validate administrative-unit reconciliation in the mover workflow.

.DESCRIPTION
A lightweight diagnostic helper that loads the current employee state,
resolves the desired AU from the configured country mapping, and prints
both sides of the mover comparison for a targeted employee.
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$EmployeeId
)

$ModuleRoot = Join-Path $PSScriptRoot "..\modules"
$ProjectRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..")
$ProjectRoot = $ProjectRoot.Path

Import-Module "$ModuleRoot\MI.Logging.psm1" -Force
Import-Module "$ModuleRoot\MI.Movers.psm1" -Force
Import-Module "$ModuleRoot\MI.AdministrativeUnits.psm1" -Force

$AUMappings = Get-MIAUMappings -Path (Join-Path $PSScriptRoot "..\configuration\AdministrativeUnits.json")
$CsvPath = Join-Path $ProjectRoot "HR\source\mover-employees.csv"

$Employee = Import-Csv $CsvPath | Where-Object { $_.EmployeeID -eq $EmployeeId } | Select-Object -First 1

if (-not $Employee) {
    throw "Employee '$EmployeeId' was not found in $CsvPath"
}

$CurrentState = Get-MICurrentUserState -EmployeeId $EmployeeId
$DesiredState = Get-MIDesiredUserState -Employee $Employee
$DesiredState.AdministrativeUnit = Get-MIAdministrativeUnit -Employee $DesiredState -Mappings $AUMappings
$Changes = Compare-MIUserState -CurrentState $CurrentState -DesiredState $DesiredState

Write-Host ""
Write-Host "========================================"
Write-Host " MOVER AU VALIDATION"
Write-Host "========================================"
Write-Host ""
Write-Host ("EmployeeId         : {0}" -f $CurrentState.EmployeeId)
Write-Host ("DisplayName        : {0}" -f $CurrentState.DisplayName)
Write-Host ("Current AU         : {0}" -f $CurrentState.AdministrativeUnit)
Write-Host ("Desired AU         : {0}" -f $DesiredState.AdministrativeUnit)
Write-Host ("Country changed    : {0}" -f $Changes.CountryChanged)
Write-Host ("AU changed         : {0}" -f $Changes.AdministrativeUnitChanged)

$MovePlanTask = if ($Changes.AdministrativeUnitChanged -or $Changes.CountryChanged) {
    'UpdateAdministrativeUnit'
}
else {
    'None'
}

Write-Host ("Move plan task     : {0}" -f $MovePlanTask)
Write-Host ""
