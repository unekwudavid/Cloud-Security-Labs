# Dynamic Group Strategy

**Project:** Enterprise Identity Platform  
**Organization:** Mustard Innovations  
**Author:** David Adama  
**Sprint:** 3.4 – Dynamic Identity Governance  
**Status:** Design Approved

---

# Overview

This document defines the Dynamic Group strategy used within the Mustard Innovations Enterprise Identity Platform.

Rather than relying exclusively on manual group assignments during provisioning, Microsoft Entra ID Dynamic Membership Rules are used wherever group membership can be determined from user attributes.

This approach enables identity governance, reduces administrative effort, and ensures authorization remains synchronized with HR data throughout the employee lifecycle.

---

# Objectives

The Dynamic Group strategy was designed to achieve the following objectives:

- Reduce manual administration
- Support Joiner-Mover-Leaver (JML) processes
- Improve identity governance
- Enable Attribute-Based Access Control (ABAC)
- Minimize human error
- Ensure consistent authorization

---

# Identity Lifecycle

```
HR System
    │
    ▼
Employee Created
    │
    ▼
Provision User
    │
    ▼
Populate User Attributes
    │
    ▼
Department
Country
Job Title
Office
Employee Type
    │
    ▼
Microsoft Entra Dynamic Rule
    │
    ▼
Automatic Group Membership
```

---

# Dynamic Membership Attributes

Mustard Innovations uses the following Microsoft Entra user attributes for dynamic group membership.

| Attribute | Purpose |
|-----------|----------|
| Department | Department Security Groups |
| Country | Regional Administrative Groups |
| Job Title | Role-Based Access |
| Office Location | Regional Resources |
| Employee Type | Contractors vs Employees |

---

# Group Categories

## Department Groups

Examples:

- Engineering
- Finance
- HR
- Marketing
- Security
- Sales
- Operations
- Customer Support

Example Rule

```
(user.department -eq "Engineering")
```

---

## Country Groups

Examples

- Canada
- Nigeria
- United Kingdom

Example Rule

```
(user.country -eq "Canada")
```

---

## Executive Groups

Executives receive additional authorization.

Example Rule

```
(user.jobTitle -contains "Director")
```

---

# Static vs Dynamic Groups

| Static Groups | Dynamic Groups |
|--------------|----------------|
| Manual membership | Automatic membership |
| Requires administrator | Managed by Entra ID |
| Best for projects | Best for departments |
| Membership rarely changes | Membership changes frequently |
| Higher operational cost | Lower operational cost |

---

# Naming Convention

Department Dynamic Groups

```
DG-Engineering
DG-Finance
DG-HR
DG-Marketing
DG-Security
DG-Sales
DG-Operations
```

Country Dynamic Groups

```
DG-Canada
DG-Nigeria
DG-UnitedKingdom
```

Executive Groups

```
DG-Executives
```

---

# Benefits

The Dynamic Group strategy provides several operational benefits.

## Reduced Administration

No manual updates are required when employees change departments.

---

## Improved Governance

Access is determined using authoritative HR attributes.

---

## Automatic Joiner-Mover-Leaver Support

Department changes immediately update group membership.

---

## Reduced Human Error

Manual group assignment mistakes are minimized.

---

## Improved Compliance

Authorization policies remain consistent across the organization.

---

# Security Considerations

Dynamic groups should only use trusted identity attributes populated through approved HR provisioning processes.

Attributes should never be manually edited by end users.

Administrative approval is required before introducing new dynamic membership rules.

---

# Future Enhancements

Planned improvements include:

- Dynamic licensing
- Dynamic Administrative Units
- Access Packages
- Entitlement Management
- Lifecycle Workflows
- Privileged Identity Management integration

---

## Known Limitation

The Dynamic Group automation was successfully implemented using Microsoft Graph PowerShell and configuration-driven JSON files.

During testing, Microsoft Graph returned the following error:


This behavior is expected because Dynamic Membership is a Microsoft Entra ID Premium (P1/P2) feature.

The demonstration tenant uses Microsoft Entra ID Free, which does not support Dynamic Security Groups.

### Validation

Although the groups could not be created, the automation successfully:

- Loaded configuration from DynamicGroups.json
- Built Microsoft Graph requests
- Detected the licensing dependency
- Logged the error
- Continued processing remaining groups
- Generated a provisioning report

No code changes are required when deployed into a tenant licensed with Microsoft Entra ID Premium P1 or higher.

# Conclusion

Dynamic Groups form an essential component of the Mustard Innovations identity governance strategy.

By leveraging Microsoft Entra ID Dynamic Membership Rules, the organization reduces administrative effort while improving consistency, governance, and security throughout the identity lifecycle.