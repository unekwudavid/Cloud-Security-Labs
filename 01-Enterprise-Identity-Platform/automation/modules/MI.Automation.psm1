# =====================================================================
# MI.Automation.psm1
# Mustard Innovations Enterprise Cloud IAM Automation Module
# Version: 1.1
# =====================================================================

function Write-MILog {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Message,

        [ValidateSet('INFO','WARN','ERROR','SUCCESS')]
        [string]$Level='INFO'
    )

    $LogDir = Join-Path $PSScriptRoot "..\logs"

    if (!(Test-Path $LogDir)){
        New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
    }

    $LogFile = Join-Path $LogDir "automation.log"

    $Time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $Entry = "[$Time] [$Level] $Message"

    Write-Host $Entry

    Add-Content $LogFile $Entry
}

# ---------------------------------------------------------------------

function New-MIUserBody {

    param(
        $Employee,
        $Config
    )

    $DisplayName = "$($Employee.FirstName) $($Employee.LastName)"

    $UPN = "$($Employee.FirstName).$($Employee.LastName)".ToLower() +
            "@$($Config.TenantDomain)"

    $MailNickname = "$($Employee.FirstName).$($Employee.LastName)".ToLower()

    $UsageLocation = $Config.Countries[$Employee.Country]

    $Body = @{
        accountEnabled = $true

        displayName = $DisplayName

        mailNickname = $MailNickname

        userPrincipalName = $UPN

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

# ---------------------------------------------------------------------

function Test-MIUserExists {

    param(
        [string]$UserPrincipalName
    )

    try{

        $null = Get-MgUser -UserId $UserPrincipalName -ErrorAction Stop

        return $true

    }

    catch{

        return $false

    }

}

# ---------------------------------------------------------------------

function New-MIProvisioningResult {

    param(

        $Employee,

        $Identity,

        $Status,

        $Reason=$null,

        $ObjectId=$null

    )

    [PSCustomObject]@{

        Timestamp = Get-Date

        EmployeeID = $Employee.EmployeeID

        DisplayName = $Identity.DisplayName

        UserPrincipalName = $Identity.UPN

        Department = $Employee.Department

        Country = $Employee.Country

        Status = $Status

        DepartmentGroup=""

        CompanyGroup=""

        AUAssigned=$false

        ManagerAssigned=$false

        Reason=$Reason

        ObjectId=$ObjectId

        TemporaryPassword=$Identity.Password

    }

}

# ---------------------------------------------------------------------

function New-MIUser {

    param(

        $Employee,

        $Config

    )

    Write-MILog "Processing employee $($Employee.EmployeeID)" "INFO"

    $Identity = New-MIUserBody `
        -Employee $Employee `
        -Config $Config

    if(Test-MIUserExists $Identity.UPN){

        Write-MILog "User already exists: $($Identity.UPN)" "WARN"

        return New-MIProvisioningResult `
            -Employee $Employee `
            -Identity $Identity `
            -Status $ProvisioningStatus.Skipped `
            -Reason "User already exists"

    }

    try{

        Write-MILog "Creating user $($Identity.UPN)" "INFO"

        $User = New-MgUser `
            -BodyParameter $Identity.Body `
            -ErrorAction Stop

        Write-MILog "User created successfully." "SUCCESS"

        return New-MIProvisioningResult `
            -Employee $Employee `
            -Identity $Identity `
            -Status $ProvisioningStatus.Created `
            -ObjectId $User.Id

    }

    catch{

        Write-MILog $_.Exception.Message "ERROR"

        return New-MIProvisioningResult `
            -Employee $Employee `
            -Identity $Identity `
            -Status $ProvisioningStatus.Failed `
            -Reason $_.Exception.Message

    }

}

# ---------------------------------------------------------------------

function Get-MIGroupMappings {

    param(
        [string]$Path
    )

    if(!(Test-Path $Path)){

        throw "Group mapping file not found: $Path"

    }

    Get-Content $Path -Raw | ConvertFrom-Json

}

# ---------------------------------------------------------------------

function Get-MIRequiredGroups {

    param(

        $Employee,

        $Mappings

    )

    $Groups=@()

    if($Mappings.Departments){

        if($Mappings.Departments.PSObject.Properties.Name -contains $Employee.Department){

            $Groups += $Mappings.Departments.$($Employee.Department)

        }

    }

    if($Mappings.Regions){

        if($Mappings.Regions.PSObject.Properties.Name -contains $Employee.Country){

            $Groups += $Mappings.Regions.$($Employee.Country)

        }

    }

    if($Mappings.Default){

        $Groups += $Mappings.Default

    }

    $Groups | Sort-Object -Unique

}

# ---------------------------------------------------------------------

function Add-MIUserToGroups {

    param(

        [string]$UserId,

        [array]$Groups

    )

    Write-MILog "Starting group assignment..." "INFO"

    foreach($GroupName in $Groups){

        try{

            Write-MILog "Searching for group: $GroupName" "INFO"

            $Group = Get-MgGroup `
                -Filter "displayName eq '$GroupName'" `
                -ErrorAction Stop

            if(!$Group){

                Write-MILog "Group not found: $GroupName" "WARN"

                continue

            }

            $Body = @{

                "@odata.id"="https://graph.microsoft.com/v1.0/directoryObjects/$UserId"

            }

            New-MgGroupMemberByRef `
                -GroupId $Group.Id `
                -BodyParameter $Body `
                -ErrorAction Stop

            Write-MILog "$GroupName assigned successfully." "SUCCESS"

        }

        catch{

            Write-MILog "Failed assigning $GroupName : $($_.Exception.Message)" "ERROR"

        }

    }

    Write-MILog "Group assignment completed." "SUCCESS"

}

Export-ModuleMember -Function @(
'Write-MILog',
'New-MIUser',
'Test-MIUserExists',
'Get-MIGroupMappings',
'Get-MIRequiredGroups',
'Add-MIUserToGroups'
)