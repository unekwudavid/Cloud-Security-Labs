# Security Groups

> **Project:** Enterprise Identity & Access Management  
> **Module:** 02 – Entra ID Administration  
> **Document:** Security Groups Design & Implementation  
> **Client:** Mustard Innovations  
> **Consultant:** David Adama  
> **Version:** 1.0  
> **Status:** Design Approved

---

# Objective

Design and implement Microsoft Entra ID Security Groups to support Role-Based Access Control (RBAC), application authorization, and departmental access management within Mustard Innovations.

The Security Group strategy follows enterprise IAM best practices by separating **administrative boundaries** from **authorization boundaries**.

---

# Design Principles

The Security Group strategy is based on the following principles:

- Least Privilege
- Role-Based Access Control (RBAC)
- Scalability
- Separation of Duties
- Regional Compliance
- Standardized Naming Convention

Administrative Units define **who administers identities**, while Security Groups define **what identities can access**.

---

# Naming Convention

Security Groups will use the following naming standards.

## Global Department Groups

Format:

SG-<Department>

Examples:

- SG-Engineering
- SG-HR
- SG-Finance
- SG-IT
- SG-Security
- SG-Marketing
- SG-Sales
- SG-CustomerSupport
- SG-Executive

These groups provide organization-wide authorization where access requirements are consistent across all locations.

---

## Regional Department Groups

Format:

SG-<CountryCode>-<Department>

Examples:

- SG-NG-Engineering
- SG-UK-Engineering
- SG-CA-Engineering

Regional Security Groups are used when access must be restricted based on country-specific regulations, regional infrastructure, or business policies.

---

# Group Strategy

Mustard Innovations adopts a hybrid Security Group strategy.

Global Security Groups will be used to provide common access to enterprise-wide applications.

Regional Security Groups will be used where regulatory requirements or regional business operations require location-specific authorization.

This approach balances simplicity, scalability, and compliance.

---

# Security Groups to be Created

## Global Groups

| Group Name | Purpose |
|------------|---------|
| SG-Executive | Executive leadership |
| SG-HR | Human Resources |
| SG-Finance | Finance Department |
| SG-Engineering | Engineering Department |
| SG-IT | Information Technology |
| SG-Security | Security Operations |
| SG-Sales | Sales Department |
| SG-Marketing | Marketing Department |
| SG-CustomerSupport | Customer Support |

---

## Regional Groups

| Group Name | Purpose |
|------------|---------|
| SG-NG-Engineering | Engineering staff located in Nigeria |
| SG-UK-Engineering | Engineering staff located in the United Kingdom |
| SG-CA-Engineering | Engineering staff located in Canada |

---

# Implementation Notes

The groups will initially be created without members.

Membership will be assigned after user accounts are provisioned during the User Lifecycle Management phase of the project.

---

# Validation Checklist

After implementation, verify that:

- All Security Groups are successfully created.
- Group names follow the approved naming convention.
- Group type is **Security**.
- Membership type is **Assigned**.
- No duplicate groups exist.
- Group descriptions accurately reflect their purpose.

---

# Evidence

![Security Groups](../Screenshots/07-Security-Groups-Created.png)

---

# Lessons Learned

This implementation demonstrates the importance of separating administrative management from resource authorization.

Administrative Units control administrative scope, while Security Groups provide access to enterprise resources.

This separation improves governance, simplifies administration, and supports future organizational growth.