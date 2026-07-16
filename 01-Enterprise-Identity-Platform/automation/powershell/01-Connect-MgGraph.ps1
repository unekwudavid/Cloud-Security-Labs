# Connect to Microsoft Graph

<#
.SYNOPSIS
Connects to Microsoft Graph for Microsoft Entra ID automation.
#>

try {
    Connect-MgGraph -Scopes "User.ReadWrite.All","Group.ReadWrite.All" -ErrorAction Stop
    Write-Host "Connected to Microsoft Graph successfully." -ForegroundColor Green
} catch {
    Write-Error "Failed to connect to Microsoft Graph: $_"
    exit 1
}
