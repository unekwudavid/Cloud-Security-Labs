@{
    CompanyName     = "Mustard Innovations"
    TenantDomain    = "daveshub.onmicrosoft.com"
    TenantShortName = "MI"
    EnvironmentName = "Production"

    # User Provisioning Defaults
    DefaultPassword      = "P@ssword123!"
    ForcePasswordChange  = $true
    AccountEnabled       = $true

    # Administrative Units
    AdminUnits = @(
        @{ Name = "MI-Nigeria"; Country = "Nigeria" }
        @{ Name = "MI-Canada"; Country = "Canada" }
        @{ Name = "MI-UnitedKingdom"; Country = "United Kingdom" }
    )

    # Security Groups
    SecurityGroups = @(
        @{ Name = "SG-IT"; Description = "IT Department" }
        @{ Name = "SG-Finance"; Description = "Finance Department" }
        @{ Name = "SG-HR"; Description = "Human Resources Department" }
        @{ Name = "SG-Engineering"; Description = "Engineering Department" }
        @{ Name = "SG-Sales"; Description = "Sales Department" }
        @{ Name = "SG-Marketing"; Description = "Marketing Department" }
        @{ Name = "All Company"; Description = "All Employees" }
    )

    # Country Usage Location Mapping
    Countries = @{
        "Nigeria"        = "NG"
        "Canada"         = "CA"
        "United Kingdom" = "GB"
        "United States"  = "US"
    }

    # Licensing
    Licenses = @(
        @{Sku="M365_BUSINESS_PREMIUM"; Count=54}
    )
}