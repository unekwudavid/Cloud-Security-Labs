# Enterprise Identity Platform
### Project 1 — Enterprise Cloud IAM
**Mustard Innovations (Fictional Enterprise)**

---

## Overview

This project demonstrates the design and implementation of an enterprise-grade Identity and Access Management (IAM) platform using Microsoft Entra ID and Microsoft Graph PowerShell.

The project simulates how a modern enterprise automates the complete employee identity lifecycle, beginning with user onboarding and progressing toward Joiner-Mover-Leaver (JML) automation.

The implementation follows Microsoft Identity best practices and Infrastructure-as-Code principles while emphasizing reusable PowerShell modules, automation, governance, and documentation.

---

# Objectives

- Automate Microsoft Entra ID user provisioning
- Automate security group assignment
- Automate Administrative Unit assignment
- Automate manager assignment
- Automate Microsoft 365 license assignment
- Automate Microsoft Entra RBAC assignment
- Implement Employee ID lifecycle management
- Build reusable PowerShell automation modules
- Prepare for enterprise Joiner-Mover-Leaver automation

---

# Technology Stack

- Microsoft Entra ID
- Microsoft Graph PowerShell SDK
- PowerShell 7
- Microsoft Graph API
- JSON Configuration Files
- CSV HR Feed
- Git
- GitHub

---

# Current Architecture

```
HR Feed
    │
    ▼
Provisioning Engine
    │
    ├──────────────► User Provisioning
    │
    ├──────────────► Group Assignment
    │
    ├──────────────► Administrative Units
    │
    ├──────────────► Manager Assignment
    │
    ├──────────────► License Assignment
    │
    ├──────────────► Directory Role Assignment
    │
    ├──────────────► EmployeeId Backfill
    │
    ▼
Reporting Engine
```

---

# Repository Structure

```
01-Enterprise-Identity-Platform/

automation/
│
├── configuration/
├── constants/
├── modules/
├── powershell/
└── reports/

HR/
└── source/

documentation/
architecture/
```

---

# Automation Modules

| Module | Purpose |
|---------|----------|
| MI.Provisioning | User provisioning |
| MI.Groups | Group management |
| MI.AdministrativeUnits | Administrative Units |
| MI.Managers | Manager assignment |
| MI.Licensing | License assignment |
| MI.RBAC | Directory Roles |
| MI.Reporting | Reporting |
| MI.Logging | Logging |

---

# Current Workflow

1. Validate HR Data
2. Provision User
3. Assign Groups
4. Assign Administrative Unit
5. Assign Manager
6. Assign License
7. Assign Directory Role
8. Backfill EmployeeId
9. Generate Reports

---

# Project Status

| Sprint | Status |
|---------|--------|
| Sprint 1 – Foundation | ✅ Complete |
| Sprint 2 – Provisioning | ✅ Complete |
| Sprint 3 – Governance | ✅ Complete |
| Sprint 4 – Enterprise Automation | ✅ Complete |
| Sprint 5 – Joiner-Mover-Leaver Automation | 🚧 In Progress |

---

# Key Deliverables

- Modular PowerShell automation framework
- Enterprise onboarding pipeline
- Automated licensing
- Automated RBAC
- Automated manager assignment
- Automated Administrative Units
- Enterprise reporting
- Reusable orchestration layer

---

# Next Milestone

Sprint 5 introduces enterprise Joiner-Mover-Leaver automation, where onboarding evolves into a complete identity lifecycle capable of processing employee hires, department changes, promotions, and offboarding.

---

Created by

**David Adama**