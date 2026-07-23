<#
.SYNOPSIS
Enterprise Joiner Workflow Orchestrator.

.DESCRIPTION
Coordinates the complete employee onboarding workflow
for Mustard Innovations.

Workflow

1. Validate HR Data
2. Provision User
3. Assign Directory Roles
4. Backfill EmployeeId
5. Generate Reports

AUTHOR
David Adama

VERSION
2.0
#>
param(

    [switch]$Live,

    [int]$Limit = 10

)

#import created modules
Import-Module `
"$PSScriptRoot\..\modules\MI.Automation.psm1" `
-Force


#pipeline configuration for the joiner workflow
$Pipeline = @(

    @{
        Name = "HR Validation"
        Script = "02-Validate-HRData.ps1"
    }

    @{
        Name = "User Provisioning"
        Script = "03-Provision-MIEmployees.ps1"
    }

    @{
        Name = "Directory Role Assignment"
        Script = "08-Assign-Roles.ps1"
    }

    @{
        Name = "EmployeeId Backfill"
        Script = "09-Backfill-EmployeeIds.ps1"
    }

)


#joiner workflow
Write-Host ""
Write-Host "========================================"
Write-Host " ENTERPRISE JOINER WORKFLOW"
Write-Host "========================================"

$Stage = 1

foreach($Step in $Pipeline)
{

    Write-Host ""
    Write-Host "----------------------------------------"
    Write-Host "Stage $Stage/$($Pipeline.Count)"
    Write-Host $Step.Name
    Write-Host "----------------------------------------"

    $Path = Join-Path $PSScriptRoot $Step.Script

    if($Step.Script -eq "09-Backfill-EmployeeIds.ps1")
    {

        & $Path -Live:$Live

    }
    else
    {

        & $Path `
            -Live:$Live `
            -Limit $Limit

    }

    $Stage++

}

Write-Host ""
Write-Host "========================================"
Write-Host " JOINER WORKFLOW COMPLETE"
Write-Host "========================================"