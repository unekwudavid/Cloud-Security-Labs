<#
.SYNOPSIS
MI.RBAC - Role-Based Access Control automation helpers.

.DESCRIPTION
Provides reusable functions for:

• Loading RBAC mappings
• Determining required directory roles
• Discovering/activating Microsoft Entra directory roles
• Assigning users to Microsoft Entra directory roles

AUTHOR
David Adama

VERSION
1.0
#>

# ============================================================
# Load Role Mappings
# ============================================================

function Get-MIRoleMappings {

    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    if (!(Test-Path $Path)) {

        throw "Role mapping file not found: $Path"

    }

    Get-Content $Path -Raw | ConvertFrom-Json

}

# ============================================================
# Determine Required Role
# ============================================================

function Get-MIRequiredRole {

    param(

        [Parameter(Mandatory)]
        $Employee,

        [Parameter(Mandatory)]
        $Mappings

    )

    #
    # Job Title takes precedence
    #

    if (
        $Mappings.JobTitles.PSObject.Properties.Name -contains $Employee.JobTitle
    ) {

        return $Mappings.JobTitles.$($Employee.JobTitle)

    }

    #
    # Department fallback
    #

    if (
        $Mappings.Departments.PSObject.Properties.Name -contains $Employee.Department
    ) {

        return $Mappings.Departments.$($Employee.Department)

    }

    #
    # Default role
    #

    return $Mappings.Default

}

# ============================================================
# Get Directory Role
# ============================================================

function Get-MIDirectoryRole {

    param(

        [Parameter(Mandatory)]
        [string]$RoleName

    )

    Write-MILog "Locating role '$RoleName'" "INFO"

    $Role = Get-MgDirectoryRole `
        -Filter "displayName eq '$RoleName'"

    if ($Role) {

        return $Role

    }

    Write-MILog "$RoleName not activated. Activating..." "INFO"

    $Template = Get-MgDirectoryRoleTemplate |
        Where-Object DisplayName -eq $RoleName

    if (!$Template) {

        throw "Directory role template not found: $RoleName"

    }

    New-MgDirectoryRole `
        -RoleTemplateId $Template.Id | Out-Null

    Start-Sleep -Seconds 2

    return Get-MgDirectoryRole `
        -Filter "displayName eq '$RoleName'"

}

# ============================================================
# Assign User To Directory Role
# ============================================================

function Add-MIUserToRole {

    param(

        [Parameter(Mandatory)]
        [string]$UserId,

        [Parameter(Mandatory)]
        [string]$RoleName

    )

    Write-MILog "Assigning role '$RoleName'" "INFO"

    try {

        $Role = Get-MIDirectoryRole -RoleName $RoleName

        if (-not $Role) {

            Write-MILog "Role not found: $RoleName" "ERROR"

            return $false

        }

        $Params = @{
            "@odata.id" = "https://graph.microsoft.com/v1.0/directoryObjects/$UserId"
        }

        New-MgDirectoryRoleMemberByRef `
            -DirectoryRoleId $Role.Id `
            -BodyParameter $Params `
            -ErrorAction Stop

        Write-MILog "$RoleName assigned successfully." "SUCCESS"

        return $true

    }
    catch {

        Write-MILog $_.Exception.Message "ERROR"

        return $false

    }

}

# ============================================================
# Export Functions
# ============================================================

Export-ModuleMember -Function @(
    'Get-MIRoleMappings',
    'Get-MIRequiredRole',
    'Get-MIDirectoryRole',
    'Add-MIUserToRole'
)