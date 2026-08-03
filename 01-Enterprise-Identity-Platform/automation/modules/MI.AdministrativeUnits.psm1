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
#update MI user administrative unit
  function Update-MIAdministrativeUnit {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        [string]$ObjectId,

        [Parameter(Mandatory)]
        [string]$DesiredAdministrativeUnit

    )

    Write-MILog "Reconciling Administrative Unit membership..." "INFO"

    try {

        #
        # Get every Administrative Unit
        #

        $AdministrativeUnits = Get-MgDirectoryAdministrativeUnit -All

        #
        # Find current AU
        #

        $CurrentAU = $null

        foreach ($AU in $AdministrativeUnits) {

            $Members = Get-MgDirectoryAdministrativeUnitMember `
                -AdministrativeUnitId $AU.Id `
                -All

            if ($Members.Id -contains $ObjectId) {

                $CurrentAU = $AU
                break

            }

        }

        #
        # Remove from old AU
        #

        if ($CurrentAU) {

            if ($CurrentAU.DisplayName -ne $DesiredAdministrativeUnit) {

                Write-MILog "Removing from AU: $($CurrentAU.DisplayName)" "INFO"

                Remove-MgDirectoryAdministrativeUnitMemberByRef `
                    -AdministrativeUnitId $CurrentAU.Id `
                    -DirectoryObjectId $ObjectId `
                    -ErrorAction Stop

            }

            else {

                Write-MILog "User already in correct Administrative Unit." "INFO"

                return [PSCustomObject]@{

                    Success = $true
                    Status  = "No Change"

                }

            }

        }

        #
        # Locate destination AU
        #

        $DestinationAU = $AdministrativeUnits |
            Where-Object DisplayName -eq $DesiredAdministrativeUnit

        if (-not $DestinationAU) {

            throw "Administrative Unit '$DesiredAdministrativeUnit' not found."

        }

        #
        # Add user
        #

        Write-MILog "Adding user to AU: $DesiredAdministrativeUnit" "INFO"

        New-MgDirectoryAdministrativeUnitMemberByRef `
            -AdministrativeUnitId $DestinationAU.Id `
            -BodyParameter @{

                "@odata.id" = "https://graph.microsoft.com/v1.0/directoryObjects/$ObjectId"

            } `
            -ErrorAction Stop

        Write-MILog "Administrative Unit updated successfully." "SUCCESS"

        return [PSCustomObject]@{

            Success = $true
            Status  = "Updated"

        }

    }
    catch {

        Write-MILog $_.Exception.Message "ERROR"

        return [PSCustomObject]@{

            Success = $false
            Status  = "Failed"
            Reason  = $_.Exception.Message

        }

    }

}

Export-ModuleMember -Function Get-MIAUMappings,Get-MIAdministrativeUnit,Add-MIUserToAdministrativeUnit,Update-MIAdministrativeUnit
