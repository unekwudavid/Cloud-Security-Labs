# Tenant Assessment

> **Project:** Enterprise Identity & Access Management  
> **Module:** 02 – Entra ID Administration  
> **Document:** Tenant Assessment  
> **Client:** Mustard Innovations  
> **Consultant:** David Adama  
> **Version:** 1.0  
> **Status:** Approved
---

# Assessment Summary

This document records the initial state of the Microsoft Entra ID tenant before implementation begins for **Mustard Innovations**.

The purpose of this assessment is to establish a baseline configuration, identify available licensing capabilities, evaluate the current identity environment, and document the tenant's existing state before introducing enterprise Identity and Access Management (IAM) controls.

This assessment serves as the **"As-Is"** environment documentation and provides a reference point for all future configuration changes performed throughout this project.

---

# Project Scope

This assessment supports the implementation of a cloud-first Enterprise Identity and Access Management solution for **Mustard Innovations**.

The implementation will include:

- Enterprise identity administration
- Role-Based Access Control (RBAC)
- Administrative Units
- Microsoft Entra ID security features
- Identity Governance
- Privileged Identity Management (PIM)
- Microsoft Graph automation
- PowerShell automation
- Infrastructure as Code (Terraform)

---

# Tenant Information

| Property | Value |
|----------|-------|
| Tenant Name | daveHub |
| Primary Domain | davesHub.onmicrosoft.com |
| Tenant ID | 64a45ec0-a795-47d4-aa98-c9b01414e298 |
| Country/Region | Nigeria |
| Current License | Microsoft Entra ID Free |
| Premium Features | Microsoft Entra ID P2 Trial Available |

---

# Current State Assessment

## Users

The tenant currently contains **7 user accounts**.

Initial inspection indicates these accounts are primarily administrative and test identities created during tenant provisioning.

A detailed review of account ownership, administrative privileges, and user lifecycle management will be completed before introducing production identities for **Mustard Innovations**.

---

## Groups

The current tenant contains the following group configuration:

| Group Type | Count |
|------------|------:|
| Total Groups | 5 |
| Microsoft 365 Groups | 4 |
| Security Groups | 1 |
| Dynamic Groups | 0 |
| Cloud Groups | 5 |
| On-Premises Groups | 0 |

The tenant currently has a minimal group structure, providing a clean foundation for implementing enterprise security groups and role-based access controls.

---

## Administrative Roles

Administrative role assignments have not yet been reviewed.

A full assessment of privileged roles will be completed before implementing Role-Based Access Control (RBAC) and Privileged Identity Management (PIM).

---

## Enterprise Applications

No Enterprise Applications are currently configured within the tenant.

This provides a clean baseline for implementing enterprise application integrations during later phases of the project.

---

# Licensing Assessment

The tenant is currently operating under the **Microsoft Entra ID Free** license.

The tenant is also eligible for a **Microsoft Entra ID P2 Trial**, which provides access to advanced enterprise identity capabilities including:

- Privileged Identity Management (PIM)
- Identity Protection
- Access Reviews
- Entitlement Management
- Conditional Access (Advanced)
- Identity Governance

The trial will be activated later in the project when premium identity governance features are required, ensuring maximum utilization of the available trial period.

---

# Risks Identified

No immediate security risks were identified during the initial assessment.

The following implementation consideration was identified:

- The tenant currently operates on the Microsoft Entra ID Free license.
- Advanced identity governance capabilities require activation of the Microsoft Entra ID P2 trial before implementation.
- No enterprise applications currently exist, minimizing integration complexity during deployment.

---

# Recommendations

Based on the current assessment, the following recommendations are proposed:

1. Maintain the tenant in its current state until the enterprise identity structure has been implemented.
2. Implement Administrative Units aligned to Mustard Innovations' organizational model.
3. Deploy department-based Security Groups following approved naming conventions.
4. Configure Role-Based Access Control using the principle of least privilege.
5. Activate the Microsoft Entra ID P2 trial immediately before beginning Identity Governance and PIM implementation.
6. Manage infrastructure changes through PowerShell, Microsoft Graph, and Terraform wherever possible to ensure repeatability and Infrastructure as Code (IaC) adoption.

---

# Assessment Conclusion

The tenant provides a clean and well-suited foundation for implementing the **Mustard Innovations Enterprise Identity and Access Management environment**.

Existing tenant objects are minimal and do not present significant migration or remediation challenges.

The availability of the Microsoft Entra ID P2 trial enables the implementation of advanced identity governance capabilities later in the project without immediate licensing costs.

The environment has been assessed and is approved for implementation.

---

# Evidence

## Tenant Overview

![Tenant Overview](Screenshots/01-Tenant-Overview.png)

---

## License Overview

![License Overview](Screenshots/02-License-Overview.png)

---

## Users

![Users](Screenshots/03-Users.png)

---

## Groups

![Groups](Screenshots/04-Groups.png)

---

## Enterprise Applications

![Enterprise Applications](Screenshots/05-Enterprise-Applications.png)
