<#
.SYNOPSIS
MI.Managers - manager assignment and mapping helpers.
.DESCRIPTION
Contains manager lookup and assignment logic for provisioning workflows.
#>

function Get-MIManagerMappings {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path
    )

    if (-not (Test-Path $Path)) {
        throw "Manager mapping file not found: $Path"
    }

    Get-Content $Path -Raw | ConvertFrom-Json
}

function Set-MIUserManager {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$UserId,

        [Parameter(Mandatory=$true)]
        $Employee,

        [Parameter(Mandatory=$true)]
        $Mappings
    )

    Write-MILog "Assigning manager for user $UserId" "INFO"

    $ManagerUPN = $Mappings.Departments.$($Employee.Department)
    if (-not $ManagerUPN) {
        Write-MILog "No manager configured for department '$($Employee.Department)'" "WARN"
        return [PSCustomObject]@{ Success = $false; Manager = "" }
    }

    try {
        $Manager = Get-MgUser -UserId $ManagerUPN -ErrorAction Stop

        try {
            $ExistingManager = Get-MgUserManager -UserId $UserId -ErrorAction Stop
            if ($ExistingManager) {
                Write-MILog "Manager already assigned for $($Employee.FirstName) $($Employee.LastName)." "INFO"
                return [PSCustomObject]@{ Success = $true; Manager = $ManagerUPN }
            }
        }
        catch {
            # No existing manager found.
        }

        $Body = @{ "@odata.id" = "https://graph.microsoft.com/v1.0/users/$($Manager.Id)" }
        Set-MgUserManagerByRef -UserId $UserId -BodyParameter $Body -ErrorAction Stop

        Write-MILog "Assigned manager '$ManagerUPN' to $($Employee.FirstName) $($Employee.LastName)." "SUCCESS"
        return [PSCustomObject]@{ Success = $true; Manager = $ManagerUPN }
    }
    catch {
        Write-MILog "Failed assigning manager: $($_.Exception.Message)" "ERROR"
        return [PSCustomObject]@{ Success = $false; Manager = "" }
    }
}

#update MI User Manager
function Update-MIUserManager {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        [string]$ObjectId,

        [Parameter(Mandatory)]
        [string]$ManagerUPN

    )

    Write-MILog "Reconciling manager assignment..." "INFO"

    try {

        $Manager = Get-MgUser `
            -Filter "userPrincipalName eq '$ManagerUPN'"

        if(-not $Manager){

            throw "Manager '$ManagerUPN' not found."

        }

        $CurrentManager = Get-MgUserManager `
            -UserId $ObjectId `
            -ErrorAction SilentlyContinue

        if($CurrentManager.Id -eq $Manager.Id){

            Write-MILog "Manager already correct." "INFO"

            return [PSCustomObject]@{

                Success = $true
                Status = "No Change"

            }

        }

        Set-MgUserManagerByRef `
            -UserId $ObjectId `
            -BodyParameter @{

                "@odata.id" = "https://graph.microsoft.com/v1.0/users/$($Manager.Id)"

            }

        Write-MILog "Manager updated." "SUCCESS"

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
Export-ModuleMember -Function Get-MIManagerMappings,Set-MIUserManager,Update-MIUserManager
