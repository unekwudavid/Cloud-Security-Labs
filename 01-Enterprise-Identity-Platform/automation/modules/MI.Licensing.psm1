<#
.SYNOPSIS
MI.Licensing - license automation helpers.
.DESCRIPTION
Contains functions for tenant license discovery, required license resolution, and user license assignment.
#>

function Get-MILicenseMappings {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path
    )

    if (-not (Test-Path $Path)) {
        throw "License mapping file not found: $Path"
    }

    Get-Content $Path -Raw | ConvertFrom-Json
}

function Get-MITenantLicenses {
    [CmdletBinding()]
    param()

    Write-MILog "Discovering subscribed licenses..." "INFO"
    try {
        $Licenses = Get-MgSubscribedSku
        if (-not $Licenses) {
            Write-MILog "No subscribed licenses found in tenant." "WARN"
            return @()
        }
        Write-MILog "$($Licenses.Count) subscribed SKU(s) discovered." "SUCCESS"
        return $Licenses
    }
    catch {
        Write-MILog "Failed retrieving tenant licenses: $($_.Exception.Message)" "ERROR"
        return @()
    }
}

function Get-MIRequiredLicense {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        $Employee,

        [Parameter(Mandatory=$true)]
        $Mappings
    )

    if ($Mappings.Departments.$($Employee.Department)) {
        return $Mappings.Departments.$($Employee.Department)
    }

    return $null
}

function Set-MIUserLicense {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$UserId,

        [Parameter(Mandatory=$true)]
        [string]$SkuPartNumber
    )

    Write-MILog "Attempting license assignment..." "INFO"
    $Licenses = Get-MITenantLicenses

    if ($Licenses.Count -eq 0) {
        Write-MILog "License assignment skipped. No subscribed SKUs available." "WARN"
        return @{ Success = $false; Status = "No subscribed licenses" }
    }

    $License = $Licenses | Where-Object { $_.SkuPartNumber -eq $SkuPartNumber }
    if (-not $License) {
        Write-MILog "Required SKU '$SkuPartNumber' not found." "WARN"
        return @{ Success = $false; Status = "SKU not found" }
    }

    try {
        Set-MgUserLicense -UserId $UserId -AddLicenses @(@{ SkuId = $License.SkuId }) -RemoveLicenses @()
        Write-MILog "License assigned successfully." "SUCCESS"
        return @{ Success = $true; Status = "Assigned" }
    }
    catch {
        Write-MILog "License assignment failed: $($_.Exception.Message)" "ERROR"
        return @{ Success = $false; Status = $_.Exception.Message }
    }
}

#update user license
function Update-MIUserLicense {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        [string]$ObjectId,

        [Parameter(Mandatory)]
        [string]$SkuPartNumber

    )
    Write-MILog "Reconciling license assignment..." "INFO"
    try{

        $DesiredSku = Get-MgSubscribedSku |
            Where-Object SkuPartNumber -eq $SkuPartNumber

        if(!$DesiredSku){

            throw "SKU '$SkuPartNumber' not found."

        }

        $CurrentLicenses = (Get-MgUserLicenseDetail `
            -UserId $ObjectId).SkuId

        if($CurrentLicenses -contains $DesiredSku.SkuId){

            Write-MILog "Correct license already assigned." "INFO"

            return [PSCustomObject]@{

                Success = $true
                Status = "No Change"

            }

        }

        Set-MgUserLicense `
            -UserId $ObjectId `
            -AddLicenses @(
                @{
                    SkuId = $DesiredSku.SkuId
                }
            ) `
            -RemoveLicenses $CurrentLicenses

        Write-MILog "License updated." "SUCCESS"

        return [PSCustomObject]@{

            Success = $true
            Status = "Updated"

        }

    }

    catch{

        Write-MILog $_.Exception.Message "ERROR"

        return [PSCustomObject]@{

            Success = $false
            Status = "Failed"
            Reason = $_.Exception.Message

        }

    }

}

Export-ModuleMember -Function Get-MILicenseMappings,Get-MITenantLicenses,Get-MIRequiredLicense,Set-MIUserLicense,Update-MIUserLicense
