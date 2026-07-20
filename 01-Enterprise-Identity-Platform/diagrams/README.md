# Enterprise Identity Platform Diagrams

## Overview

This folder contains the architecture and design diagrams used throughout the **Enterprise Identity Platform (Microsoft Entra ID)** project.

The diagrams document the logical design, identity architecture, automation workflows, governance model, and security controls implemented during the project. They serve as visual documentation to complement the implementation, PowerShell automation, and technical documentation found throughout the repository.

---

## Purpose

These diagrams were created to:

- Visualize enterprise identity architecture
- Document Microsoft Entra ID design decisions
- Explain IAM workflows
- Demonstrate enterprise security practices
- Support implementation documentation
- Provide portfolio-ready architectural evidence

---

## Folder Structure

```
diagrams/
│
├── README.md
│
├── source/
│   ├── Identity-Architecture.mmd
│   ├── Provisioning-Workflow.mmd
│   ├── RBAC-Architecture.mmd
│   ├── Conditional-Access-Flow.mmd
│   ├── Joiner-Mover-Leaver.mmd
│   ├── Administrative-Units.mmd
│   ├── Identity-Governance.mmd
│   └── Authentication-Flow.mmd
│
└── exports/
    ├── png/
    ├── svg/
    └── pdf/
```

---

## Diagram List

| Diagram | Description |
|----------|-------------|
| Enterprise Identity Architecture | High-level Microsoft Entra ID architecture |
| User Provisioning Workflow | HR-driven provisioning process using Microsoft Graph |
| Administrative Unit Design | Enterprise administrative boundaries |
| Security Group Structure | Departmental and organizational group hierarchy |
| Role-Based Access Control (RBAC) | Administrative role assignment model |
| Authentication Flow | User authentication and access process |
| Conditional Access Architecture | Policy evaluation and access decisions |
| Identity Governance | Identity lifecycle and governance processes |
| Joiner-Mover-Leaver (JML) | End-to-end identity lifecycle workflow |

---

## Technologies

The diagrams were created using:

- Mermaid
- draw.io (diagrams.net)
- Microsoft Entra ID
- Microsoft Graph
- Visual Studio Code

---

## Export Formats

Whenever possible, each diagram is maintained in multiple formats:

- Mermaid source (.mmd)
- PNG
- SVG
- PDF

This allows the diagrams to be easily updated while also providing high-quality exports for documentation and presentations.

---

## Relationship to the Project

These diagrams directly support the implementation found in:

- `/automation`
- `/documentation`
- `/modules`
- `/policies`

Together they provide a complete architectural view of the Enterprise Identity Platform implementation.

---

## Future Diagrams

Additional diagrams will be added as new project modules are completed, including:

- Privileged Identity Management (PIM)
- Identity Governance
- Access Reviews
- Entitlement Management
- Dynamic Groups
- Identity Protection
- Zero Trust Architecture
- Hybrid Identity Architecture

---

**Project:** Enterprise Identity Platform (Microsoft Entra ID)

**Author:** David Adama