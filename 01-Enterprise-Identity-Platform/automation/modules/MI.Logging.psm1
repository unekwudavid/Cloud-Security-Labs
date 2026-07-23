<#
.SYNOPSIS
MI.Logging - logging utilities for MI automation.
.DESCRIPTION
Provides logging support used by all MI automation modules.
#>

function Write-MILog {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message,

        [Parameter()]
        [ValidateSet('INFO','WARN','ERROR','SUCCESS')]
        [string]$Level = 'INFO'
    )

    $LogDir = Join-Path $PSScriptRoot "..\logs"
    if (-not (Test-Path $LogDir)) {
        New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
    }

    $LogFile = Join-Path $LogDir "automation.log"
    $Time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $Entry = "[$Time] [$Level] $Message"

    Write-Host $Entry
    Add-Content -Path $LogFile -Value $Entry
}

Export-ModuleMember -Function Write-MILog
