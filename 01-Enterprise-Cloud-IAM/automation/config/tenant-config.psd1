@{
    CompanyName       = "Mustard Innovations"
    TenantDomain      = "daveshub.onmicrosoft.com"
    TenantShortName   = "MI"
    EnvironmentName   = "Production"
    
    # Administrative Units
    AdminUnits        = @(
        @{ Name = "MI-UK"; Country = "United Kingdom" }
        @{ Name = "MI-US"; Country = "United States" }
        @{ Name = "MI-EU"; Country = "European Union" }
    )
    
    # Security Groups
    SecurityGroups    = @(
        @{ Name = "SG-IT"; Description = "IT Department" }
        @{ Name = "SG-Finance"; Description = "Finance Department" }
        @{ Name = "SG-HR"; Description = "Human Resources Department" }
    )

    # Country Usage Location Mapping
    Countries         = @{
        "Nigeria"         = "NG"
        "Canada"          = "CA"
        "United Kingdom"  = "GB"
        "United States"   = "US"
    }
    
    # Licensing
    Licenses          = @(
        @{ Sku = "M365_BUSINESS_PREMIUM"; Count = 54 }
    )
}
