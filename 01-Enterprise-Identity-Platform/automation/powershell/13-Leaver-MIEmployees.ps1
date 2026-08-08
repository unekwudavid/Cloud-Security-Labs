<#
.SYNOPSIS
Enterprise Identity Lifecycle - Leaver Workflow

.DESCRIPTION
Processes employee offboarding from Microsoft Entra ID.

AUTHOR
David Adama

VERSION
1.0
#>

param(

    [switch]$Live,

    [int]$Limit = 10

)

# ======================================================
# Load Modules
# ======================================================

$ModuleRoot = Join-Path $PSScriptRoot "..\modules"

Import-Module "$ModuleRoot\MI.Logging.psm1" -Force
Import-Module "$ModuleRoot\MI.Leavers.psm1" -Force
Import-Module "$ModuleRoot\MI.Groups.psm1" -Force
Import-Module "$ModuleRoot\MI.Licensing.psm1" -Force
Import-Module "$ModuleRoot\MI.RBAC_Automation.psm1" -Force
Import-Module "$ModuleRoot\MI.Reporting.psm1" -Force

# ======================================================
# Project Root
# ======================================================

$ProjectRoot = Split-Path -Parent (
    Split-Path -Parent $PSScriptRoot
)

# ======================================================
# HR Source File
# ======================================================

$CsvPath = Join-Path `
    $ProjectRoot `
    "HR\source\leaver-employees.csv"

$Employees = Import-Csv $CsvPath |
    Select-Object -First $Limit

# ======================================================
# Results Collection
# ======================================================

$LeaverResults = [System.Collections.Generic.List[object]]::new()

# ======================================================
# Banner
# ======================================================

# ======================================================
# Execution Mode
# ======================================================

if(-not $Live)
{
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Yellow
    Write-Host " PREVIEW MODE" -ForegroundColor Yellow
    Write-Host "========================================" -ForegroundColor Yellow

    Write-Host ""
    Write-Host "No changes will be applied."
}
else
{
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host " LIVE MODE" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
}

# ======================================================
# Employee Processing Loop
# ======================================================

foreach($Employee in $Employees)
{

    try
    {

        Write-Host ""
        Write-Host "Processing Employee: $($Employee.DisplayName)"
        Write-Host "--------------------------------------------"

        # =============================================
        # Current State
        # =============================================

        $CurrentState = Get-MILeaverCurrentState `
            -EmployeeId $Employee.EmployeeID

        # =============================================
        # Desired State
        # =============================================

        $DesiredState = Get-MIDesiredLeaverState `
            -Employee $Employee

        # =============================================
        # Compare
        # =============================================

        $Comparison = Compare-MILeaverState `
            -CurrentState $CurrentState `
            -DesiredState $DesiredState

        # =============================================
        # Build Execution Plan
        # =============================================

        $LeaverPlan = New-MILeaverPlan `
            -Comparison $Comparison

        Write-Host ""
        Write-Host "========================================"
        Write-Host " LEAVER PLAN"
        Write-Host "========================================"

        $LeaverPlan.Actions |
            Format-Table -AutoSize

        # =============================================
        # Result Object
        # =============================================

        $LeaverResult = [PSCustomObject]@{

            RunId = (New-Guid).Guid

            EmployeeId = $CurrentState.EmployeeId

            DisplayName = $CurrentState.DisplayName

            Department = $CurrentState.Department

            JobTitle = $CurrentState.JobTitle

            Country = $CurrentState.Country

            Timestamp = Get-Date

            Duration = $null

            Status = if($Live) { "Running" } else { "Preview" }

            PlannedActions = @(
                $LeaverPlan.Actions | ForEach-Object { $_.Action }
            )

            ActionsExecuted = @()

        }

       # =============================================
# Execute Leaver Plan
# =============================================

if (-not $Live)
{
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Yellow
    Write-Host " PREVIEW - NO ACTIONS EXECUTED" -ForegroundColor Yellow
    Write-Host "========================================" -ForegroundColor Yellow

    $ExecutionResult = Invoke-MILeaverPlan `
        -Plan $LeaverPlan `
        -ObjectId $CurrentState.ObjectId `
        -Preview
}
else
{
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host " EXECUTING LEAVER PLAN" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green

    $ExecutionResult = Invoke-MILeaverPlan `
        -Plan $LeaverPlan `
        -ObjectId $CurrentState.ObjectId
}
   
    # =============================================
# Process Execution Results
# =============================================

if ($ExecutionResult)
{
    $LeaverResult.ActionsExecuted = @(
        $ExecutionResult.Results |
        Where-Object { $_.Success } |
        ForEach-Object { $_.Action }
    )
}

# =============================================
# Determine Final Status
# =============================================

if (-not $Live)
{
    $LeaverResult.Status = "Preview"
}
elseif ($ExecutionResult.Failed -gt 0)
{
    $LeaverResult.Status = "Failed"
}
else
{
    $LeaverResult.Status = "Completed"
}    

        # =============================================
        # Complete Result
        # =============================================

        $LeaverResult.Duration =
            (Get-Date) - $LeaverResult.Timestamp

        $LeaverResults.Add($LeaverResult)

    }
    catch
    {

        Write-MILog $_.Exception.Message "ERROR"

        $LeaverResults.Add(

            [PSCustomObject]@{

                RunId = (New-Guid).Guid

                EmployeeId = $Employee.EmployeeID

                DisplayName = $Employee.DisplayName

                Department = $Employee.Department

                JobTitle = $Employee.JobTitle

                Country = $Employee.Country

                Timestamp = Get-Date

                Duration = $null

                Status = "Failed"

                ActionsExecuted = @()

            }

        )

    }

}

# ======================================================
# Export Leaver Report
# ======================================================

$ReportFolder = Join-Path `
    $ProjectRoot `
    "automation\reports\Leavers"

if(!(Test-Path $ReportFolder))
{
    New-Item `
        -ItemType Directory `
        -Path $ReportFolder `
        -Force | Out-Null
}

$TimeStamp = Get-Date -Format "yyyyMMdd-HHmmss"

$ReportFile = Join-Path `
    $ReportFolder `
    "Leaver-$TimeStamp.csv"

$LeaverResults |
Select-Object `
RunId,
EmployeeId,
DisplayName,
Department,
JobTitle,
Country,
Status,
Duration,
Timestamp,
@{
    Name = "PlannedActions"
    Expression = {
        $_.PlannedActions -join "; "
    }
},
@{
    Name = "ActionsExecuted"
    Expression = {
        $_.ActionsExecuted -join "; "
    }
} |
Export-Csv `
$ReportFile `
-NoTypeInformation

Write-MILog `
    "Leaver report exported to $ReportFile" `
    "SUCCESS"

# ======================================================
# Execution Metrics
# ======================================================

$CompletedCount =
(
    $LeaverResults |
    Where-Object Status -eq "Completed"
).Count

$FailedCount =
(
    $LeaverResults |
    Where-Object Status -eq "Failed"
).Count

$TotalProcessed =
$LeaverResults.Count

$ExecutionFinished = Get-Date

Write-MILog "Execution Metrics" "INFO"
Write-MILog "Processed : $TotalProcessed" "INFO"
Write-MILog "Completed : $CompletedCount" "INFO"
Write-MILog "Failed    : $FailedCount" "INFO"
Write-MILog "Completed at : $ExecutionFinished" "INFO"

# ======================================================
# Console Summary
# ======================================================

if ($LeaverResults.Count -eq 1)
{

    $LeaverResult = $LeaverResults[0]

    Write-Host ""
    Write-Host "=========================================================" -ForegroundColor Cyan
    Write-Host "           ENTERPRISE LEAVER EXECUTION COMPLETE" -ForegroundColor Cyan
    Write-Host "=========================================================" -ForegroundColor Cyan

    Write-Host ""

    Write-Host ("Employee        : {0}" -f $LeaverResult.DisplayName)
    Write-Host ("Employee ID     : {0}" -f $LeaverResult.EmployeeId)

    Write-Host ""

    Write-Host "Identity"
    Write-Host "---------------------------------------------------------"

    Write-Host ("Department      : {0}" -f $LeaverResult.Department)
    Write-Host ("Job Title       : {0}" -f $LeaverResult.JobTitle)
    Write-Host ("Country         : {0}" -f $LeaverResult.Country)

    Write-Host "Actions"
    Write-Host "---------------------------------------------------------"

if($LeaverResult.Status -eq "Preview")
{
    Write-Host "Planned Actions:" -ForegroundColor Yellow

    foreach($Action in $LeaverResult.PlannedActions)
    {
        Write-Host "• $Action" -ForegroundColor Yellow
    }

    if($LeaverResult.PlannedActions.Count -eq 0)
    {
        Write-Host "No actions are required." -ForegroundColor Green
    }
}
else
{
    Write-Host "Actions Executed:" -ForegroundColor Green

    foreach($Action in $LeaverResult.ActionsExecuted)
    {
        Write-Host "✔ $Action" -ForegroundColor Green
    }

    if($LeaverResult.ActionsExecuted.Count -eq 0)
    {
        Write-Host "No actions were executed." -ForegroundColor Yellow
    }
}
    Write-Host ""

    Write-Host ("Status          : {0}" -f $LeaverResult.Status)
    Write-Host ("Duration        : {0}" -f $LeaverResult.Duration)
    Write-Host ("Report          : {0}" -f $ReportFile)

    Write-Host ""
    Write-Host "=========================================================" -ForegroundColor Cyan

}
else
{

    Write-Host ""
    Write-Host "=========================================================" -ForegroundColor Cyan
    Write-Host "         ENTERPRISE LEAVER EXECUTION COMPLETE" -ForegroundColor Cyan
    Write-Host "=========================================================" -ForegroundColor Cyan

    $LeaverResults |
    Select-Object `
        EmployeeId,
        DisplayName,
        Department,
        JobTitle,
        Status,
        Duration |
    Format-Table -AutoSize

    Write-Host ""

    Write-Host ("Employees Processed : {0}" -f $TotalProcessed)
    Write-Host ("Completed          : {0}" -f $CompletedCount) -ForegroundColor Green
    Write-Host ("Failed             : {0}" -f $FailedCount) -ForegroundColor Red

    Write-Host ""
    Write-Host ("Report             : {0}" -f $ReportFile) -ForegroundColor Green

    Write-Host ""
    Write-Host "=========================================================" -ForegroundColor Cyan

}