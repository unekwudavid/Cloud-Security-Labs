<#
.SYNOPSIS
Assigns managers to existing users.

.DESCRIPTION
Builds reporting relationships after all manager and employee
accounts have been provisioned.

AUTHOR
David Adama

VERSION
1.0
#>

param()

$ScriptDir = Split-Path -Parent $PSCommandPath
$ProjectRoot = Split-Path -Parent (Split-Path -Parent $ScriptDir)

Import-Module "$ProjectRoot\automation\modules\MI.Automation.psm1" -Force

$Employees = Import-Csv "$ProjectRoot\HR\source\pilot-employees.csv"

$Mappings = Get-Content `
"$ProjectRoot\automation\configuration\ManagerMappings.json" `
-Raw | ConvertFrom-Json

#check if the user is already assigned to a manager, if so skip the assignment

foreach ($Employee in $Employees)
{
    $ManagerUPN = $Mappings.Departments.$($Employee.Department)

    if (-not $ManagerUPN)
    {
        Write-MILog "No manager mapping for $($Employee.Department)" WARN
        continue
    }

    $User = Get-MgUser `
        -Filter "userPrincipalName eq '$($Employee.Email)'"

    $Manager = Get-MgUser `
        -Filter "userPrincipalName eq '$ManagerUPN'"

    if (-not $User)
    {
        Write-MILog "User not found: $($Employee.Email)" WARN
        continue
    }

    if (-not $Manager)
    {
        Write-MILog "Manager not found: $ManagerUPN" WARN
        continue
    }

    $Body = @{
        "@odata.id" =
        "https://graph.microsoft.com/v1.0/users/$($Manager.Id)"
    }

    Set-MgUserManagerByRef `
        -UserId $User.Id `
        -BodyParameter $Body

    Write-MILog `
        "Assigned $ManagerUPN to $($Employee.Email)" `
        SUCCESS
}