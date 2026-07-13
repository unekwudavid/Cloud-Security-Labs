
#logging function
function Write-MILog {

    param(

        [string]$Message,

        [string]$Level = "INFO"

    )

    $Time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $LogLine = "[$Time] [$Level] $Message"

    Write-Host $LogLine

    Add-Content `
        -Path "$PSScriptRoot\..\logs\automation.log" `
        -Value $LogLine

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
        $User = New-MgUser -BodyParameter $Identity.Body

        Write-MILog -Message "User created successfully: $($Identity.UPN)" -Level "SUCCESS"

        return New-MIProvisioningResult `
            -Employee $Employee `
            -Identity $Identity `
            -Status $ProvisioningStatus.Created `
            -ObjectId $User.Id

    }
    catch {

        Write-MILog -Message "Failed to create user $($Identity.UPN): $($_.Exception.Message)" -Level "ERROR"

        return New-MIProvisioningResult `
            -Employee $Employee `
            -Identity $Identity `
            -Status $ProvisioningStatus.Failed `
            -Reason $_.Exception.Message

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