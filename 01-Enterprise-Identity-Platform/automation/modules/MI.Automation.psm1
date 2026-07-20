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

#this is the provisioning result object that will be returned after each user creation attempt
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

        AdministrativeUnit  = ""

        AUAssigned=$false

        ManagerAssigned=$false

        Manager = ""

        License = ""

        LicenseAssigned = $false

        LicenseStatus = ""

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

# administrative unit mapping function
function Get-MIAUMappings {

    param(
        [string]$Path
    )

    if (-not (Test-Path $Path)) {
        throw "Administrative Unit mapping file not found: $Path"
    }

    Get-Content $Path -Raw | ConvertFrom-Json

}

#get the administrative unit for a given employee based on their country
function Get-MIAdministrativeUnit {

    param(
        $Employee,
        $Mappings
    )

    if ($Mappings.Countries.$($Employee.Country)) {
        return $Mappings.Countries.$($Employee.Country)
    }

    return $null

}

#add a user to an administrative unit
function Add-MIUserToAdministrativeUnit {

    param(
        [string]$UserId,

        [string]$AdministrativeUnit
    )

    Write-MILog "Assigning Administrative Unit $AdministrativeUnit" "INFO"

    try {

        $AU = Get-MgDirectoryAdministrativeUnit `
            -Filter "displayName eq '$AdministrativeUnit'"

        if (-not $AU) {

            Write-MILog "Administrative Unit not found: $AdministrativeUnit" "WARN"
            return $false

        }

        $Body = @{
            "@odata.id" = "https://graph.microsoft.com/v1.0/directoryObjects/$UserId"
        }

        New-MgDirectoryAdministrativeUnitMemberByRef `
            -AdministrativeUnitId $AU.Id `
            -BodyParameter $Body

        Write-MILog "$AdministrativeUnit assigned successfully" "SUCCESS"

        return $true

    }
    catch {

        Write-MILog "Failed assigning Administrative Unit : $($_.Exception.Message)" "ERROR"

        return $false

    }

}
#get manager mappings from a JSON file
function Get-MIManagerMappings {

    param(
        [string]$Path
    )

    if (-not (Test-Path $Path)) {
        throw "Manager mapping file not found: $Path"
    }

    Get-Content $Path -Raw | ConvertFrom-Json

}

#set manager for a user based on employee data and mappings
function Set-MIUserManager {

    param(

        [string]$UserId,

        $Employee,

        $Mappings

    )

    Write-Host ""
    Write-Host "========================================"
    Write-Host " MANAGER ASSIGNMENT"
    Write-Host "========================================"

    $ManagerUPN = $Mappings.Departments.$($Employee.Department)

    if (-not $ManagerUPN) {

        Write-MILog "No manager configured for department '$($Employee.Department)'" "WARN"

        return [PSCustomObject]@{
            Success = $false
            Manager = ""
        }

    }

    Write-Host "Employee   : $($Employee.FirstName) $($Employee.LastName)"
    Write-Host "Department : $($Employee.Department)"
    Write-Host "Manager    : $ManagerUPN"

    try {

        # Retrieve manager account
        $Manager = Get-MgUser -UserId $ManagerUPN -ErrorAction Stop

        # Check whether a manager is already assigned
        try {

            $ExistingManager = Get-MgUserManager -UserId $UserId -ErrorAction Stop

            if ($ExistingManager) {

                Write-MILog "Manager already assigned for $($Employee.FirstName) $($Employee.LastName)." "INFO"

                return [PSCustomObject]@{
                    Success = $true
                    Manager = $ManagerUPN
                }

            }

        }
        catch {
            # No existing manager found. Continue.
        }

        $Body = @{
            "@odata.id" = "https://graph.microsoft.com/v1.0/users/$($Manager.Id)"
        }

        Set-MgUserManagerByRef `
            -UserId $UserId `
            -BodyParameter $Body `
            -ErrorAction Stop

        Write-MILog "Assigned manager '$ManagerUPN' to $($Employee.FirstName) $($Employee.LastName)." "SUCCESS"

        return [PSCustomObject]@{
            Success = $true
            Manager = $ManagerUPN
        }

    }
    catch {

        Write-MILog "Failed assigning manager: $($_.Exception.Message)" "ERROR"

        return [PSCustomObject]@{
            Success = $false
            Manager = ""
        }

    }

}

# ---------------------------------------------------------------------
# Load License Mappings
# ---------------------------------------------------------------------

function Get-MILicenseMappings {

    param(
        [string]$Path
    )

    if (-not (Test-Path $Path)) {

        throw "License mapping file not found: $Path"

    }

    Get-Content $Path -Raw | ConvertFrom-Json

}

# ---------------------------------------------------------------------
# Discover Available Microsoft 365 Licenses
# ---------------------------------------------------------------------

function Get-MITenantLicenses {

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

# ---------------------------------------------------------------------
# Determine Required License
# ---------------------------------------------------------------------

function Get-MIRequiredLicense {

    param(

        $Employee,

        $Mappings

    )

    if ($Mappings.Departments.$($Employee.Department)) {

        return $Mappings.Departments.$($Employee.Department)

    }

    return $null

}

# ---------------------------------------------------------------------
# Assign Microsoft 365 License
# ---------------------------------------------------------------------

function Set-MIUserLicense {

    param(

        [string]$UserId,

        [string]$SkuPartNumber

    )

    Write-MILog "Attempting license assignment..." "INFO"

    $Licenses = Get-MITenantLicenses

    if ($Licenses.Count -eq 0) {

        Write-MILog "License assignment skipped. No subscribed SKUs available." "WARN"

        return @{
            Success = $false
            Status  = "No subscribed licenses"
        }

    }

    $License = $Licenses | Where-Object {

        $_.SkuPartNumber -eq $SkuPartNumber

    }

    if (-not $License) {

        Write-MILog "Required SKU '$SkuPartNumber' not found." "WARN"

        return @{
            Success = $false
            Status  = "SKU not found"
        }

    }

    try {

        Set-MgUserLicense `
            -UserId $UserId `
            -AddLicenses @(
                @{
                    SkuId = $License.SkuId
                }
            ) `
            -RemoveLicenses @()

        Write-MILog "License assigned successfully." "SUCCESS"

        return @{
            Success = $true
            Status  = "Assigned"
        }

    }

    catch {

        Write-MILog "License assignment failed: $($_.Exception.Message)" "ERROR"

        return @{
            Success = $false
            Status  = $_.Exception.Message
        }

    }

}

#export functions to be able to use them outside of the module
Export-ModuleMember -Function @(
'Write-MILog',
'New-MIUser',
'Test-MIUserExists',

'Get-MIGroupMappings',
'Get-MIRequiredGroups',
'Add-MIUserToGroups',

'Get-MIAUMappings',
'Get-MIAdministrativeUnit',
'Add-MIUserToAdministrativeUnit',

'Get-MIManagerMappings',
'Set-MIUserManager',

'Get-MILicenseMappings',
'Get-MITenantLicenses',
'Get-MIRequiredLicense',
'Set-MIUserLicense'
)