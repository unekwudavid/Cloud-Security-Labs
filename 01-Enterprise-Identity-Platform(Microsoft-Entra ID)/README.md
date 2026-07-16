# 01 – Enterprise Cloud IAM

> **Enterprise Identity & Access Management (IAM) implementation for Mustard Innovations using Microsoft Entra ID, Microsoft Graph, PowerShell, Zero Trust, RBAC, Conditional Access, Identity Governance, and Infrastructure as Code.**

---

# 📖 Project Overview

The **Enterprise Cloud IAM** project is the flagship implementation within my Cloud Security Portfolio.

It demonstrates how an enterprise Identity & Access Management (IAM) platform can be designed, automated, governed, and secured using Microsoft Entra ID and Microsoft 365.

Rather than being a collection of isolated labs, this project follows a realistic enterprise implementation roadmap—from identity foundation and automated provisioning through governance, Zero Trust, RBAC, Conditional Access, lifecycle management, and Infrastructure as Code.

The fictional organization, **Mustard Innovations**, operates across multiple countries and provides a realistic business environment for implementing enterprise identity solutions using Microsoft technologies.

---

# 🎯 Project Objectives

This project aims to demonstrate practical experience in:

- Enterprise Identity & Access Management (IAM)
- Microsoft Entra ID Administration
- Identity Governance
- Microsoft Graph Automation
- PowerShell Automation
- Zero Trust Architecture
- Role-Based Access Control (RBAC)
- Conditional Access
- Joiner-Mover-Leaver (JML) Automation
- Infrastructure as Code (Terraform)
- Cloud Security Best Practices

---

# 🚀 Project Roadmap

## ✅ Sprint 1 – Enterprise Foundation

- Tenant Assessment
- Enterprise Identity Standards
- Naming Conventions
- Administrative Units Design
- Security Groups
- HR Master Register
- Pilot Provisioning Plan
- Repository Structure

---

## ✅ Sprint 2 – Identity Provisioning Automation

Completed enterprise provisioning engine including:

- PowerShell 7
- Microsoft Graph SDK Authentication
- Configuration Management
- Modular Automation Framework
- Identity Generation Engine
- User Provisioning Engine
- Duplicate Detection
- Preview Mode
- Live Provisioning
- Automated Security Group Assignment
- Logging
- Reporting
- Metrics Dashboard

---

## 🚧 Sprint 3 – Identity Governance

Current focus:

- Administrative Unit Assignment
- Manager Assignment
- Microsoft 365 License Assignment
- Dynamic Group Membership
- Attribute Management
- Governance Automation

---

## ⏳ Sprint 4 – Role-Based Access Control (RBAC)

Implementation includes:

- Least Privilege Model
- Administrative Role Assignment
- Administrative Unit Scoped Roles
- Separation of Duties
- Role Assignment Automation
- RBAC Documentation

---

## ⏳ Sprint 5 – Zero Trust & Conditional Access

Implementation includes:

- Multi-Factor Authentication (MFA)
- Conditional Access Policies
- Block Legacy Authentication
- Country-based Access Controls
- Administrative Access Protection
- Device Compliance Policies
- Session Controls

---

## ⏳ Sprint 6 – Identity Lifecycle Management

Implementation includes:

- Joiner Workflow
- Mover Workflow
- Leaver Workflow
- Attribute Synchronization
- Group Membership Updates
- License Lifecycle
- Manager Updates

---

## ⏳ Sprint 7 – Identity Governance & Privileged Access

Implementation includes:

- Privileged Identity Management (PIM)
- Access Reviews
- Entitlement Management
- Access Packages
- Identity Governance Policies
- Approval Workflows

---

## ⏳ Sprint 8 – Infrastructure as Code

Implementation includes:

- Terraform
- Microsoft Graph API
- Azure CLI
- Automated Tenant Deployment
- Configuration as Code
- Reusable Infrastructure Modules

---

## ⏳ Sprint 9 – Security Operations

Implementation includes:

- Microsoft Defender
- Microsoft Sentinel
- Identity Protection
- Sign-in Monitoring
- Audit Log Analysis
- Incident Response

---

# 🏗 Enterprise Architecture

The project follows a layered IAM architecture:

```
HR Data
      │
      ▼
Provisioning Engine
      │
      ▼
Microsoft Graph
      │
      ▼
Microsoft Entra ID
      │
      ├── Administrative Units
      ├── Security Groups
      ├── RBAC
      ├── Conditional Access
      ├── Identity Governance
      └── Microsoft 365 Licensing
```

---

# 📂 Project Structure

```
01-Enterprise-Identity-Platform(Microsoft-Entra ID)
│
├── automation/
├── documentation/
├── HR/
├── diagrams/
├── policies/
├── terraform/
├── screenshots/
├── scripts/
├── modules/
└── README.md
```

---

# 🧩 Key Capabilities

## Identity Provisioning

- HR-driven provisioning
- Automated identity generation
- Duplicate detection
- Microsoft Graph automation
- Security group assignment
- Reporting
- Logging

---

## Identity Governance

- Administrative Units
- Manager relationships
- License management
- Dynamic Groups
- Identity lifecycle

---

## Access Management

- Role-Based Access Control (RBAC)
- Least Privilege
- Separation of Duties
- Administrative Role Delegation

---

## Zero Trust

- Conditional Access
- MFA
- Device Compliance
- Session Controls
- Location-based Access
- Legacy Authentication Blocking

---

## Identity Lifecycle

- Joiners
- Movers
- Leavers
- Group updates
- License updates
- Attribute updates

---

## Automation

- Microsoft Graph PowerShell SDK
- PowerShell Modules
- Microsoft Graph API
- Terraform
- Configuration-driven automation

---

# 🛠 Technology Stack

- Microsoft Entra ID
- Microsoft 365
- Microsoft Graph PowerShell SDK
- Microsoft Graph API
- PowerShell 7
- Terraform
- Azure CLI
- GitHub
- Draw.io

---

# 📊 Current Status

| Sprint | Status |
|---------|--------|
| Sprint 1 – Enterprise Foundation | ✅ Complete |
| Sprint 2 – Identity Provisioning | ✅ Complete |
| Sprint 3 – Identity Governance | 🚧 In Progress |
| Sprint 4 – RBAC | ⏳ Planned |
| Sprint 5 – Conditional Access | ⏳ Planned |
| Sprint 6 – Identity Lifecycle | ⏳ Planned |
| Sprint 7 – Identity Governance | ⏳ Planned |
| Sprint 8 – Terraform | ⏳ Planned |
| Sprint 9 – Security Operations | ⏳ Planned |

---

# 🎯 Career Relevance

This project demonstrates practical skills relevant to roles such as:

- Identity & Access Management (IAM) Engineer
- Microsoft Entra ID Engineer
- Cloud Security Engineer
- Identity Governance Engineer
- Microsoft 365 Security Engineer
- Security Automation Engineer
- Cloud Infrastructure Engineer

---

# 📚 Key Artifacts

- `automation/modules/MI.Automation.psm1`
- `automation/powershell/02-New-MIUsers.ps1`
- `documentation/identity-design.md`
- `documentation/identity-lifecycle.md`
- `documentation/security-principles.md`
- `documentation/administrative-roles.md`

---

# 🌟 Project Vision

The goal of this project is to build a **portfolio-quality enterprise IAM platform** that mirrors real-world implementations found in modern organizations.

Each sprint introduces new enterprise capabilities while maintaining a strong focus on automation, governance, Zero Trust, security, documentation, and operational excellence.

By the final sprint, the project will represent a complete Identity & Access Management implementation suitable for demonstrating practical enterprise experience in Cloud Security and Identity Engineering.