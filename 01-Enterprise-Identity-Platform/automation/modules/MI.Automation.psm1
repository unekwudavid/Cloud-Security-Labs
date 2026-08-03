<#
.SYNOPSIS
MI.Automation - wrapper module for MI automation submodules.
.DESCRIPTION
Loads and exports functions from the MI.* automation modules, providing a single import point for enterprise automation scripts.
#>

$moduleRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$moduleFiles = @(
    'MI.Logging.psm1',
    'MI.Provisioning.psm1',
    'MI.Movers.psm1',
    'MI.Groups.psm1',
    'MI.AdministrativeUnits.psm1',
    'MI.Managers.psm1',
    'MI.RBAC_Automation.psm1',
    'MI.Licensing.psm1',
    'MI.Reporting.psm1'
)

foreach ($file in $moduleFiles) {
    $path = Join-Path $moduleRoot $file
    if (-not (Test-Path $path)) {
        throw "Required MI automation module not found: $path"
    }
    Import-Module -Name $path -Force
}
