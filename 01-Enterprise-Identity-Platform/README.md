# Enterprise Identity Platform

<p align="center">
  <img src="./screenshots/enterprise IAM cover page.png" alt="Enterprise Identity Platform cover" width="100%" />
</p>

## Project Overview

This platform demonstrates the design, automation, and operational execution of an enterprise-grade identity lifecycle environment built around Microsoft Entra ID, Microsoft Graph, and PowerShell-based orchestration.

It supports the full **Joiner – Mover – Leaver (JML)** lifecycle and reflects a realistic enterprise identity model for employee lifecycle management, security group handling, RBAC, license control, manager assignment, and administrative unit reconciliation.

---

## Business Context

The project simulates a fictional enterprise organization, **Mustard Innovations**, and implements identity processes that align with production expectations for:

- HR-driven provisioning
- Identity state comparisons
- Lifecycle automation
- Preview vs live execution
- Access reconciliation
- Security controls and RBAC governance
- Reporting and operational logging

---

## Objectives

- Automate employee identity lifecycle management in Microsoft Entra ID
- Implement Joiner, Mover, and Leaver orchestration
- Standardize identity state detection and desired-state comparison
- Automate group, role, license, and manager reconciliation
- Enforce least privilege and fail-closed security behavior
- Generate execution plans before making changes
- Support both preview and live execution modes
- Produce logs, reports, and operational evidence

---

## Technology Stack

- Microsoft Entra ID
- Microsoft Graph PowerShell SDK
- Microsoft Graph API
- PowerShell 7
- CSV HR data feeds
- JSON configuration files
- Git and GitHub

---

## Repository Structure

```text
01-Enterprise-Identity-Platform/
├── automation/
│   ├── configuration/
│   ├── constants/
│   ├── graph/
│   ├── logs/
│   ├── modules/
│   ├── powershell/
│   ├── reports/
│   └── terraform/
├── diagrams/
│   ├── exports/
│   └── source/
├── documentation/
│   ├── architecture/
│   ├── implementation/
│   ├── legacy/
│   └── operations/
├── HR/
│   ├── archive/
│   ├── employees/
│   ├── managers/
│   ├── offboarding/
│   ├── onboarding/
│   ├── processed/
│   ├── source/
│   └── templates/
├── modules/
│   ├── 01-Project-Foundation/
│   ├── 02-Identity-Provisioning/
│   ├── 03-Authentication-and-Identity-Protection/
│   ├── 04-RBAC/
│   ├── 05-Conditional-Access/
│   ├── 06-Identity-Governance/
│   ├── 07-Privileged-Identity-Management/
│   └── 10-Capstone/
├── policies/
├── reports/
├── screenshots/
│   ├── dynamic-groups/
│   ├── licenses/
│   ├── managers/
│   ├── provisioning/
│   └── rbac/
├── README.md
└── ...
```

---

## Current Project Status

| Area | Status |
|---|---|
| Foundation | ✅ Complete |
| HR Validation | ✅ Complete |
| Provisioning | ✅ Complete |
| License Assignment | ✅ Complete |
| Dynamic Groups | ✅ Complete |
| RBAC Assignment | ✅ Complete |
| Manager Assignment | ✅ Complete |
| Administrative Units | ✅ Complete |
| Joiner Lifecycle | ✅ Complete |
| Mover Lifecycle | ✅ Complete |
| Leaver Lifecycle | ✅ Complete |
| Security Hardening | ✅ Complete |

---

## Identity Lifecycle Workflows

### Joiner workflow

The Joiner workflow automates employee onboarding and provisioning into Microsoft Entra ID.

Typical actions include:

- HR validation
- User creation
- Group assignment
- License assignment
- Manager assignment
- Administrative Unit assignment
- RBAC assignment
- Reporting and validation

#### Joiner execution gallery (5 examples)

![Joiner 1](./screenshots/joiner%20orchestration/Screenshot%20(80).png)

![Joiner 2](./screenshots/joiner%20orchestration/Screenshot%20(81).png)

![Joiner 3](./screenshots/joiner%20orchestration/Screenshot%20(82).png)

![Joiner 4](./screenshots/joiner%20orchestration/Screenshot%20(83).png)

![Joiner 5](./screenshots/joiner%20orchestration/Screenshot%20(84).png)

---

### Mover workflow

The Mover workflow compares the employee's current state with the desired state and reconciles identity attributes, admin unit placement, group membership, role assignment, and manager updates.

Typical actions include:

- Department and role changes
- Manager updates
- Group reconciliation
- Administrative unit movement
- RBAC updates
- Reporting and validation

#### Mover execution gallery (5 examples)

![Mover 1](./screenshots/mover%20orchestration/Screenshot%20(100).png)

![Mover 2](./screenshots/mover%20orchestration/Screenshot%20(101).png)

![Mover 3](./screenshots/mover%20orchestration/Screenshot%20(103).png)

![Mover 4](./screenshots/mover%20orchestration/Screenshot%20(104).png)

![Mover 5](./screenshots/mover%20orchestration/Screenshot%20(105).png)

---

### Leaver workflow

The Leaver workflow evaluates the employee's current identity state against the desired terminated state and generates a prioritized execution plan.

For privileged identities, the workflow prioritizes RBAC cleanup before account disablement to avoid authorization conflicts and unsafe assumptions about privileged access.

Typical actions include:

- RBAC cleanup
- Account disablement
- Session revocation
- Group removal
- License removal
- Manager clearing
- Administrative Unit reconciliation
- Mailbox archival handling
- Reporting and audit trail

#### Leaver execution gallery (5 examples)

![Leaver 1](./screenshots/leaver%20orchestration/Screenshot%20(111).png)

![Leaver 2](./screenshots/leaver%20orchestration/Screenshot%20(117).png)

![Leaver 3](./screenshots/leaver%20orchestration/Screenshot%20(118).png)

![Leaver 4](./screenshots/leaver%20orchestration/Screenshot%20(119).png)

![Leaver 5](./screenshots/leaver%20orchestration/Screenshot%20(124).png)

---

## Automation Modules

| Module | Purpose |
|---|---|
| MI.Provisioning | Employee provisioning |
| MI.Groups | Group assignment and cleanup |
| MI.Managers | Manager reconciliation |
| MI.AdministrativeUnits | Administrative unit assignment |
| MI.Licensing | License assignment and removal |
| MI.RBAC_Automation | Role assignment reconciliation |
| MI.Reporting | Execution reporting |
| MI.Logging | Logging and operational traceability |

---

## Security Considerations

The platform includes security-first controls designed to reflect enterprise IAM operating principles.

### Privileged Identity Protection

During live Leaver testing, the orchestration engine encountered a privileged identity that retained a Microsoft Entra directory role.

The account-disable operation returned:

```text
403 Authorization_RequestDenied
---

## Executive Summary

This project reflects a realistic enterprise identity and access automation implementation using Microsoft Entra ID and PowerShell. It demonstrates the practical application of identity lifecycle management, governance, operational control, and enterprise-grade automation.

The solution is designed to show not only the technical implementation, but also the operational and security reasoning behind working with identity lifecycle workflows in a production-style environment.

---

## Final Status

The platform is operational and demonstrates a complete end-to-end identity lifecycle automation approach for:

- Joiner orchestration
- Mover orchestration
- Leaver orchestration
- RBAC and administrative unit reconciliation
- Reporting and execution evidence

This project is positioned as a concrete portfolio artifact showing hands-on identity engineering capability in a Microsoft Entra ecosystem.
