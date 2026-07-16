# Automation Framework

## Overview

This directory contains the automation framework used to provision, manage, validate, and report on Microsoft Entra ID identities for the **Mustard Innovations Enterprise Cloud IAM Project**.

The framework is designed following enterprise automation principles, where each script performs a single responsibility and can be executed independently or as part of a provisioning pipeline.

Rather than relying on manual administration through the Microsoft Entra portal, the project automates identity lifecycle tasks using PowerShell and Microsoft Graph, while keeping configuration separate from business logic.

---

# Folder Structure

```text
automation/
│
├── config/
├── graph/
├── logs/
├── powershell/
├── terraform/
└── README.md
```

---

# Folder Description

## config/

Contains centralized configuration used by all automation scripts.

Example:

- Tenant information
- Company settings
- Administrative Unit mappings
- Security Group mappings
- Country mappings
- Default provisioning settings

Configuration is stored in:

```
tenant-config.psd1
```

---

## powershell/

Contains PowerShell scripts implementing the identity lifecycle.

Current execution order:

| Order | Script | Purpose |
|--------|---------|---------|
| 01 | Validate-HRData.ps1 | Validates HR source data |
| 02 | New-MIUsers.ps1 | Creates Microsoft Entra ID users |
| 03 | Set-AdministrativeUnits.ps1 | Assigns Administrative Units |
| 04 | Set-SecurityGroups.ps1 | Assigns Security Groups |
| 05 | Set-Managers.ps1 | Assigns managers |
| 06 | Export-ProvisioningReport.ps1 | Generates provisioning reports |

---

## graph/

Contains Microsoft Graph automation that extends or replaces PowerShell cmdlets where appropriate.

Examples include:

- User lifecycle management
- Reporting
- License management
- Identity Governance
- Access Reviews

---

## terraform/

Contains Infrastructure as Code (IaC) used to provision and manage Microsoft Entra resources.

Examples include:

- Administrative Units
- Groups
- Conditional Access
- Named Locations
- Role Assignments

---

## logs/

Stores execution logs generated during automation.

Examples:

- Validation logs
- Provisioning logs
- Error logs
- Audit exports

Logs are excluded from version control where appropriate.

---

# Automation Workflow

```text
HR Source Data
        │
        ▼
Validate HR Data
        │
        ▼
Generate Identity Attributes
        │
        ▼
Provision Users
        │
        ▼
Assign Administrative Units
        │
        ▼
Assign Security Groups
        │
        ▼
Assign Managers
        │
        ▼
Generate Reports
        │
        ▼
Review & Validation
```

---

# Design Principles

The automation framework follows these engineering principles:

- Single Responsibility Principle (one task per script)
- Centralized configuration
- Modular architecture
- Reusable components
- Repeatable execution
- Comprehensive logging
- Validation before provisioning
- Least privilege
- Enterprise naming standards

---

# Technologies

- PowerShell 7
- Microsoft Graph PowerShell SDK
- Microsoft Entra ID
- Terraform
- Git
- GitHub

---

# Future Enhancements

Planned improvements include:

- Microsoft Graph SDK authentication
- Bulk licensing
- Dynamic group assignment
- Access Reviews
- Privileged Identity Management (PIM)
- Identity Governance workflows
- CI/CD integration with GitHub Actions

---

# Related Documentation

- Project README
- Identity Provisioning Standard
- HR Master Register
- Pilot User Provisioning Plan
- Tenant Assessment Report
- See `../diagrams/exports/03-powershell-automation-architecture.png` for the automation architecture diagram