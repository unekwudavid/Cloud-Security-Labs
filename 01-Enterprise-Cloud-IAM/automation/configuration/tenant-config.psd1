@{

    # ============================================
    # Organization Information
    # ============================================

    CompanyName = "Mustard Innovations"

    TenantDomain = "daveshub.onmicrosoft.com"

    TenantShortName = "MI"

    # ============================================
    # Default Account Settings
    # ============================================

    DefaultPassword = "P@ssword123!"

    ForcePasswordChange = $true

    AccountEnabled = $true

    # ============================================
    # Country Mapping
    # ============================================

    Countries = @{

        Nigeria = "NG"

        Canada = "CA"

        "United Kingdom" = "GB"

    }

    # ============================================
    # Supported Departments
    # ============================================

    Departments = @(

        "Engineering",

        "Finance",

        "HR",

        "Sales",

        "Security Operations"

    )

    # ============================================
    # Administrative Units
    # ============================================

    AdministrativeUnits = @{

        Nigeria = "MI-Nigeria"

        Canada = "MI-Canada"

        "United Kingdom" = "MI-UnitedKingdom"

    }

    # ============================================
    # Security Groups
    # ============================================

    SecurityGroups = @{

        Engineering = "SG-Engineering"

        Finance = "SG-Finance"

        HR = "SG-HR"

        Sales = "SG-Sales"

        "Security Operations" = "SG-SecurityOps"

    }

}