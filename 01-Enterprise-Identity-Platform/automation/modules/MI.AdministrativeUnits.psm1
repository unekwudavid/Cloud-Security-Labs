<#
.SYNOPSIS
MI.AdministrativeUnits - administrative unit automation helpers.
.DESCRIPTION
Contains mapping and assignment helpers for administrative units.
#>

function Get-MIAUMappings {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path
    )

    if (-not (Test-Path $Path)) {
        throw "Administrative Unit mapping file not found: $Path"
    }

    Get-Content $Path -Raw | ConvertFrom-Json
}

function Get-MIAdministrativeUnit {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        $Employee,

        [Parameter(Mandatory=$true)]
        $Mappings
    )

    if ($Mappings.Countries.$($Employee.Country)) {
        return $Mappings.Countries.$($Employee.Country)
    }

    return $null
}

function Add-MIUserToAdministrativeUnit {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$UserId,

        [Parameter(Mandatory=$true)]
        [string]$AdministrativeUnit
    )

    Write-MILog "Assigning Administrative Unit $AdministrativeUnit" "INFO"

    try {
        $AU = Get-MgDirectoryAdministrativeUnit -Filter "displayName eq '$AdministrativeUnit'"
        if (-not $AU) {
            Write-MILog "Administrative Unit not found: $AdministrativeUnit" "WARN"
            return $false
        }

        $Body = @{ "@odata.id" = "https://graph.microsoft.com/v1.0/directoryObjects/$UserId" }
        New-MgDirectoryAdministrativeUnitMemberByRef -AdministrativeUnitId $AU.Id -BodyParameter $Body

        Write-MILog "$AdministrativeUnit assigned successfully" "SUCCESS"
        return $true
    }
    catch {
        Write-MILog "Failed assigning Administrative Unit : $($_.Exception.Message)" "ERROR"
        return $false
    }
}

Export-ModuleMember -Function Get-MIAUMappings, Get-MIAdministrativeUnit, Add-MIUserToAdministrativeUnit
