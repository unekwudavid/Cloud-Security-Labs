# Mustard Innovations
# Role-Based Access Control (RBAC) Strategy

**Project:** Enterprise Cloud Identity & Access Management  
**Organization:** Mustard Innovations  
**Platform:** Microsoft Entra ID  
**Author:** David Adama  
**Version:** 1.0  
**Date:** July 2026

---

# 1. Purpose

This document defines the Role-Based Access Control (RBAC) strategy for Mustard Innovations' Microsoft Entra ID environment.

The objective is to ensure administrative privileges are assigned according to business responsibilities while enforcing the Principle of Least Privilege, Separation of Duties, and Zero Trust security principles.

---

# 2. Objectives

The RBAC implementation aims to:

- Protect privileged identities
- Minimize excessive permissions
- Delegate administration appropriately
- Improve operational security
- Enable auditing and compliance
- Reduce insider risk
- Support future Identity Governance initiatives

---

# 3. Design Principles

The RBAC model follows the following security principles:

## Principle of Least Privilege

Users receive only the permissions required to perform their assigned responsibilities.

---

## Separation of Duties

Administrative responsibilities are divided across multiple privileged roles to prevent excessive access concentration.

Examples include:

- User lifecycle management
- Group administration
- License administration
- Security monitoring

No single administrator performs every privileged operation.

---

## Role-Based Administration

Administrative permissions are assigned based on business function rather than individual preference.

Roles are mapped to operational responsibilities.

---

## Named Administrative Accounts

Administrative roles are assigned only to dedicated administrator identities.

Normal employee accounts must never receive privileged administrative roles.

---

## Zero Trust

Every privileged action should assume:

- Explicit verification
- Least privilege
- Continuous monitoring

---

# 4. Administrative Role Model

Mustard Innovations uses built-in Microsoft Entra ID administrative roles.

| Role | Purpose |
|-------|----------|
| Global Administrator | Emergency break-glass administration |
| User Administrator | User lifecycle management |
| Groups Administrator | Group management |
| License Administrator | License assignment |
| Authentication Administrator | Authentication methods |
| Security Reader | Read-only security visibility |
| Reports Reader | Reporting and auditing |
| Helpdesk Administrator | Password reset support |

---

# 5. Administrative Assignment Strategy

Administrative permissions are delegated according to operational responsibilities.

| Business Function | Assigned Role |
|-------------------|--------------|
| Identity Engineering | User Administrator |
| HR Administration | Groups Administrator |
| Licensing Team | License Administrator |
| Security Operations | Security Reader |
| Executive Reporting | Reports Reader |

Global Administrator accounts remain restricted.

---

# 6. Scope

This implementation covers:

- Microsoft Entra ID
- Directory administration
- Identity lifecycle management
- Administrative Units
- Security Groups
- Dynamic Groups
- Microsoft Graph PowerShell automation

Application-specific RBAC is outside the scope of this phase.

---

# 7. Privileged Identity Protection

The following controls protect privileged accounts:

- Multi-Factor Authentication (MFA)
- Named administrative identities
- Separate administrator accounts
- Logging and auditing
- Microsoft Graph activity monitoring

Future improvements include:

- Privileged Identity Management (PIM)
- Just-In-Time (JIT) role activation
- Access Reviews
- Eligible role assignments

---

# 8. Role Assignment Process

Administrative roles are assigned through automation using Microsoft Graph PowerShell.

The process includes:

1. Read role mappings from configuration.
2. Locate target user.
3. Locate Microsoft Entra directory role.
4. Verify assignment.
5. Assign role.
6. Log outcome.
7. Generate provisioning report.

This ensures consistency, repeatability, and auditability.

---

# 9. Security Controls

The RBAC implementation enforces the following controls:

- Principle of Least Privilege
- Separation of Duties
- Administrative account segregation
- Audit logging
- Configuration-driven automation
- Repeatable deployment

---

# 10. Limitations

The current Microsoft Entra ID Free tenant limits several enterprise features.

The following capabilities require Microsoft Entra ID Premium P1/P2 licenses:

- Privileged Identity Management (PIM)
- Access Reviews
- Dynamic Group Membership
- Identity Governance workflows

These limitations have been documented throughout the project and are acknowledged within the implementation.

---

# 11. Future Enhancements

Future enterprise improvements include:

- Privileged Identity Management (PIM)
- Just-In-Time (JIT) administration
- Identity Governance
- Entitlement Management
- Access Reviews
- Administrative Unit scoped RBAC
- Conditional Access integration
- Automated compliance reporting

---

# 12. Conclusion

The RBAC strategy establishes a secure and scalable authorization model for Mustard Innovations by aligning administrative permissions with business responsibilities.

The design follows Microsoft security best practices while providing a strong foundation for future Identity Governance and Zero Trust initiatives.