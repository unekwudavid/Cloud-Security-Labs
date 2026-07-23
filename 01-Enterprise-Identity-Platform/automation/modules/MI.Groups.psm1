<#
.SYNOPSIS
MI.Groups - group and dynamic membership automation helpers.
.DESCRIPTION
Handles group mapping, membership assignment, and dynamic group provisioning.
#>

function Get-MIGroupMappings {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path
    )

    if (-not (Test-Path $Path)) {
        throw "Group mapping file not found: $Path"
    }

    Get-Content $Path -Raw | ConvertFrom-Json
}

function Get-MIRequiredGroups {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        $Employee,

        [Parameter(Mandatory=$true)]
        $Mappings
    )

    $Groups = @()

    if ($Mappings.Departments) {
        if ($Mappings.Departments.PSObject.Properties.Name -contains $Employee.Department) {
            $Groups += $Mappings.Departments.$($Employee.Department)
        }
    }

    if ($Mappings.Regions) {
        if ($Mappings.Regions.PSObject.Properties.Name -contains $Employee.Country) {
            $Groups += $Mappings.Regions.$($Employee.Country)
        }
    }

    if ($Mappings.Default) {
        $Groups += $Mappings.Default
    }

    $Groups | Sort-Object -Unique
}

function Add-MIUserToGroups {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$UserId,

        [Parameter(Mandatory=$true)]
        [array]$Groups
    )

    Write-MILog "Starting group assignment..." "INFO"
    foreach ($GroupName in $Groups) {
        try {
            Write-MILog "Searching for group: $GroupName" "INFO"
            $Group = Get-MgGroup -Filter "displayName eq '$GroupName'" -ErrorAction Stop

            if (-not $Group) {
                Write-MILog "Group not found: $GroupName" "WARN"
                continue
            }

            $Body = @{ "@odata.id" = "https://graph.microsoft.com/v1.0/directoryObjects/$UserId" }
            New-MgGroupMemberByRef -GroupId $Group.Id -BodyParameter $Body -ErrorAction Stop
            Write-MILog "$GroupName assigned successfully." "SUCCESS"
        }
        catch {
            Write-MILog "Failed assigning $GroupName : $($_.Exception.Message)" "ERROR"
        }
    }

    Write-MILog "Group assignment completed." "SUCCESS"
}

function Get-MIDynamicGroups {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path
    )

    if (-not (Test-Path $Path)) {
        throw "Dynamic Group configuration not found: $Path"
    }

    Get-Content $Path -Raw | ConvertFrom-Json
}

function New-MIDynamicGroup {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        $Group
    )

    Write-MILog "Processing Dynamic Group: $($Group.DisplayName)" "INFO"

    try {
        $Existing = Get-MgGroup -Filter "displayName eq '$($Group.DisplayName)'"
        if ($Existing) {
            Write-MILog "$($Group.DisplayName) already exists." "WARN"
            return "Exists"
        }

        $Body = @{
            displayName = $Group.DisplayName
            description = $Group.Description
            mailEnabled = $false
            mailNickname = ($Group.DisplayName -replace '[^a-zA-Z0-9]', '')
            securityEnabled = $true
            groupTypes = @('DynamicMembership')
            membershipRule = $Group.MembershipRule
            membershipRuleProcessingState = 'On'
        }

        New-MgGroup -BodyParameter $Body -ErrorAction Stop
        Write-MILog "$($Group.DisplayName) created successfully." "SUCCESS"
        return "Created"
    }
    catch {
        Write-MILog "Failed creating $($Group.DisplayName): $($_.Exception.Message)" "ERROR"
        return "Failed: $($_.Exception.Message)"
    }
}

Export-ModuleMember -Function Get-MIGroupMappings, Get-MIRequiredGroups, Add-MIUserToGroups, Get-MIDynamicGroups, New-MIDynamicGroup
