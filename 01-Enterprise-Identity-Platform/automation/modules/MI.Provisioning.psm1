<#
.SYNOPSIS
MI.Provisioning - core user provisioning helpers.
.DESCRIPTION
Contains helper functions for building user bodies, checking user existence, and provisioning users.
#>

function New-MIUserBody {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        $Employee,

        [Parameter(Mandatory=$true)]
        $Config
    )

    $DisplayName = "$($Employee.FirstName) $($Employee.LastName)"
    $UPN = "$($Employee.FirstName).$($Employee.LastName)".ToLower() + "@$($Config.TenantDomain)"
    $MailNickname = "$($Employee.FirstName).$($Employee.LastName)".ToLower()
    $UsageLocation = $Config.Countries[$Employee.Country]

    $Body = @{
        accountEnabled = $true
        displayName = $DisplayName
        mailNickname = $MailNickname
        userPrincipalName = $UPN
        employeeId = $Employee.EmployeeID
        usageLocation = $UsageLocation
        passwordProfile = @{
            password = $Config.DefaultPassword
            forceChangePasswordNextSignIn = $true
        }
    }

    [PSCustomObject]@{
        DisplayName = $DisplayName
        UPN = $UPN
        Password = $Config.DefaultPassword
        Body = $Body
    }
}

function Test-MIUserExists {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$UserPrincipalName
    )

    try {
        $null = Get-MgUser -UserId $UserPrincipalName -ErrorAction Stop
        return $true
    }
    catch {
        return $false
    }
}

function New-MIUser {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        $Employee,

        [Parameter(Mandatory=$true)]
        $Config
    )

    Write-MILog "Processing employee $($Employee.EmployeeID)" "INFO"

    $Identity = New-MIUserBody -Employee $Employee -Config $Config

    if (Test-MIUserExists $Identity.UPN) {
        Write-MILog "User already exists: $($Identity.UPN)" "WARN"

        return New-MIProvisioningResult -Employee $Employee -Identity $Identity -Status $ProvisioningStatus.Skipped -Reason "User already exists"
    }

    try {
        Write-MILog "Creating user $($Identity.UPN)" "INFO"
        $User = New-MgUser -BodyParameter $Identity.Body -ErrorAction Stop
        Write-MILog "User created successfully." "SUCCESS"

        return New-MIProvisioningResult -Employee $Employee -Identity $Identity -Status $ProvisioningStatus.Created -ObjectId $User.Id
    }
    catch {
        Write-MILog $_.Exception.Message "ERROR"

        return New-MIProvisioningResult -Employee $Employee -Identity $Identity -Status $ProvisioningStatus.Failed -Reason $_.Exception.Message
    }
}

#provisioning result object
function New-MIProvisioningResult {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        $Employee,

        [Parameter(Mandatory)]
        $Identity,

        [Parameter(Mandatory)]
        [string]$Status,

        [string]$Reason = "",

        [string]$ObjectId = $null

    )

    [PSCustomObject]@{

        EmployeeID = $Employee.EmployeeID

        DisplayName = $Identity.DisplayName

        UserPrincipalName = $Identity.UPN

        Department = $Employee.Department

        JobTitle = $Employee.JobTitle

        Country = $Employee.Country

        Status = $Status

        Reason = $Reason

        ObjectId = $ObjectId

        TemporaryPassword = $Identity.Password

        DepartmentGroup = $null

        CompanyGroup = $null

        AdministrativeUnit = $null

        AUAssigned = $false

        Manager = $null

        ManagerAssigned = $false

        License = $null

        LicenseAssigned = $false

        LicenseStatus = $null

    }

}

Export-ModuleMember -Function New-MIUserBody, Test-MIUserExists, New-MIUser, New-MIProvisioningResult
