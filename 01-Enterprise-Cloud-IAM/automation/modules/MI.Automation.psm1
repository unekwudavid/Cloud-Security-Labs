
#logging function
function Write-MILog {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Message,

        [ValidateSet('INFO', 'WARN', 'ERROR', 'SUCCESS')]
        [string]$Level = 'INFO'
    )

    $LogDir = Join-Path $PSScriptRoot '..\logs'
    $LogPath = Join-Path $LogDir 'automation.log'

    if (-not (Test-Path $LogDir)) {
        New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
    }

    $Time = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $LogLine = "[$Time] [$Level] $Message"

    Write-Host $LogLine

    Add-Content -Path $LogPath -Value $LogLine -ErrorAction Stop
}

function New-MIUserBody {
    param(
        [Parameter(Mandatory)]
        $Employee,

        [Parameter(Mandatory)]
        $Config
    )

    $DisplayName = "$($Employee.FirstName) $($Employee.LastName)"
    $UPN = ("$($Employee.FirstName).$($Employee.LastName)".ToLower()) + "@{0}" -f $Config.TenantDomain
    $MailNickname = ("$($Employee.FirstName).$($Employee.LastName)".ToLower())

    $UsageLocation = $null
    if ($Config.Countries -and $Config.Countries.ContainsKey($Employee.Country)) {
        $UsageLocation = $Config.Countries[$Employee.Country]
    }

    $Password = if ($Config.DefaultPassword) { $Config.DefaultPassword } else { 'P@ssword123!' }

    $Body = @{
        accountEnabled = if ($Config.AccountEnabled -ne $null) { [bool]$Config.AccountEnabled } else { $true }
        displayName = $DisplayName
        mailNickname = $MailNickname
        userPrincipalName = $UPN
        passwordProfile = @{
            password = $Password
            forceChangePasswordNextSignIn = if ($Config.ForcePasswordChange -ne $null) { [bool]$Config.ForcePasswordChange } else { $true }
        }
        usageLocation = $UsageLocation
    }

    return [PSCustomObject]@{
        DisplayName = $DisplayName
        UPN = $UPN
        Password = $Password
        Body = $Body
    }
}

function Test-MIUserExists {
    param(
        [Parameter(Mandatory)]
        [string]$UserPrincipalName
    )

    try {
        $User = Get-MgUser -UserId $UserPrincipalName -ErrorAction Stop

        if ($null -ne $User -and $User.UserPrincipalName) {
            return $true
        }

        return $false
    }
    catch {
        $ErrorMessage = $_.Exception.Message

        if ($ErrorMessage -match 'not found|No match|ResourceNotFound|Request_ResourceNotFound') {
            return $false
        }

        if ($ErrorMessage -match 'Forbidden|Unauthorized|401|403|insufficient privileges|permission') {
            Write-MILog -Message "Insufficient Graph permissions while checking user existence for $UserPrincipalName. $ErrorMessage" -Level 'ERROR'
        }
        else {
            $Message = "Unable to verify user existence for {0}: {1}" -f $UserPrincipalName, $ErrorMessage
            Write-MILog -Message $Message -Level 'WARN'
        }

        return $false
    }
}

function New-MIUser {

    param(
        [Parameter(Mandatory)]
        $Employee,

        [Parameter(Mandatory)]
        $Config
    )

    Write-MILog -Message "Processing employee $($Employee.EmployeeID) for $($Employee.FirstName) $($Employee.LastName)" -Level "INFO"

    # Build the Microsoft Graph request body
    $Identity = New-MIUserBody `
        -Employee $Employee `
        -Config $Config

    # Check if the user already exists
    if (Test-MIUserExists -UserPrincipalName $Identity.UPN) {

        Write-MILog -Message "User already exists: $($Identity.UPN)" -Level "WARN"

        return New-MIProvisioningResult `
            -Employee $Employee `
            -Identity $Identity `
            -Status $ProvisioningStatus.Skipped `
            -Reason "User already exists"

    }

    try {

        Write-MILog -Message "Creating user: $($Identity.UPN)" -Level "INFO"

        # Create the user in Microsoft Entra ID
        $User = New-MgUser -BodyParameter $Identity.Body -ErrorAction Stop

        if (-not $User -or [string]::IsNullOrWhiteSpace($User.Id)) {
            throw "Microsoft Graph did not return a valid user object after creation."
        }

        Write-MILog -Message "User created successfully: $($Identity.UPN)" -Level "SUCCESS"

        return New-MIProvisioningResult `
            -Employee $Employee `
            -Identity $Identity `
            -Status $ProvisioningStatus.Created `
            -ObjectId $User.Id

    }
    catch {
        $ErrorMessage = $_.Exception.Message
        $ResponseBody = $null

        if ($_.ErrorDetails -and $_.ErrorDetails.Message) {
            $ResponseBody = $_.ErrorDetails.Message
        }

        if ($ResponseBody) {
            $DetailedMessage = "$ErrorMessage | $ResponseBody"
        }
        else {
            $DetailedMessage = $ErrorMessage
        }

        if ($DetailedMessage -match 'Forbidden|Unauthorized|401|403|permission|insufficient') {
            Write-MILog -Message "Insufficient Graph permissions while creating user $($Identity.UPN): $DetailedMessage" -Level 'ERROR'
        }
        else {
            Write-MILog -Message "Failed to create user $($Identity.UPN): $DetailedMessage" -Level 'ERROR'
        }

        return New-MIProvisioningResult `
            -Employee $Employee `
            -Identity $Identity `
            -Status $ProvisioningStatus.Failed `
            -Reason $DetailedMessage

    }

}

#standardized provisioning result object
function New-MIProvisioningResult {

    param(

        $Employee,

        $Identity,

        $Status,

        $Reason = $null,

        $ObjectId = $null

    )

    [PSCustomObject]@{
        Timestamp = Get-Date
        EmployeeID = $Employee.EmployeeID
        DisplayName = $Identity.DisplayName
        UserPrincipalName = $Identity.UPN
        Department = $Employee.Department
        Country = $Employee.Country
        Status = $Status
        Reason = $Reason
        ObjectId = $ObjectId
        TemporaryPassword = $Identity.Password
    }
}

Export-ModuleMember -Function Write-MILog, New-MIUserBody, Test-MIUserExists, New-MIUser, New-MIProvisioningResult