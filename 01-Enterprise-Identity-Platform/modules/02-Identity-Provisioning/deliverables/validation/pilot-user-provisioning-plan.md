# Pilot User Provisioning Plan

**Project:** Enterprise Identity & Access Management Implementation

**Client:** Mustard Innovations

**Consultant:** David Adama

**Document Version:** 1.0

**Status:** Approved for Pilot Deployment

**Date:** 08 July 2026

---

# Purpose

This document defines the pilot user provisioning strategy for the initial deployment of Microsoft Entra ID identities within Mustard Innovations.

The objective is to validate the identity provisioning process, security group assignments, administrative unit assignments, and organizational standards before onboarding the entire workforce.

---

# Pilot Objectives

The pilot deployment will validate that:

- User accounts are provisioned successfully.
- User Principal Names (UPNs) follow organizational standards.
- Administrative Units are assigned correctly.
- Security Groups are assigned according to department and region.
- Managers are assigned correctly.
- User attributes synchronize correctly across Microsoft Entra ID.
- Provisioning logs are generated successfully.
- The provisioning process is repeatable and fully automated.

---

# Pilot Scope

The pilot will provision **10 users** representing multiple departments and geographic locations.

### Countries

- Nigeria
- Canada
- United Kingdom

### Departments

- Engineering
- Human Resources
- Finance
- Sales
- Security Operations

---

# Pilot Users

| Employee ID | Name | Department | Country | Administrative Unit |
|-------------|------|------------|----------|---------------------|
| MI-0001 | Sarah Johnson | HR | Nigeria | MI-Nigeria |
| MI-0002 | David Wilson | Engineering | Nigeria | MI-Nigeria |
| MI-0003 | Emily Brown | Finance | Canada | MI-Canada |
| MI-0004 | Michael Scott | Sales | United Kingdom | MI-UnitedKingdom |
| MI-0005 | Olivia Smith | Security Operations | Canada | MI-Canada |
| MI-0006 | Daniel Moore | Engineering | United Kingdom | MI-UnitedKingdom |
| MI-0007 | Grace Taylor | HR | Canada | MI-Canada |
| MI-0008 | John Davis | Finance | Nigeria | MI-Nigeria |
| MI-0009 | Sophia Clark | Sales | Canada | MI-Canada |
| MI-0010 | James White | Engineering | Nigeria | MI-Nigeria |

---

# Provisioning Workflow

The pilot provisioning process will follow the sequence below.

1. Validate HR data.
2. Verify required attributes.
3. Generate User Principal Names.
4. Create Microsoft Entra ID users.
5. Assign Administrative Units.
6. Assign Security Groups.
7. Assign Managers.
8. Generate validation report.
9. Generate provisioning log.
10. Obtain business approval.

---

# Naming Standards

## Employee ID

```
MI-XXXX
```

Example

```
MI-0001
```

---

## User Principal Name

```
firstname.lastname@daveshub.onmicrosoft.com
```

Example

```
sarah.johnson@daveshub.onmicrosoft.com
```

---

## Administrative Units

```
MI-Nigeria

MI-Canada

MI-UnitedKingdom
```

---

## Security Groups

Department Groups

```
SG-Engineering

SG-Finance

SG-HR

SG-Sales

SG-SecurityOps
```

Regional Department Groups

```
SG-NG-Engineering

SG-NG-HR

SG-CA-Finance

SG-UK-Sales
```

---

# Validation Checklist

Each pilot account must be verified for:

- Correct Display Name
- Correct User Principal Name
- Correct Employee ID
- Correct Department
- Correct Country
- Correct Job Title
- Correct Administrative Unit
- Correct Security Group Membership
- Correct Manager Assignment
- Successful Sign-in
- MFA Readiness
- Audit Log Generation

---

# Success Criteria

The pilot deployment will be considered successful if:

- 100% of users are provisioned successfully.
- No duplicate accounts are created.
- No provisioning errors occur.
- All Administrative Units are assigned correctly.
- All Security Groups are assigned correctly.
- Microsoft Entra audit logs record all provisioning activities.
- User attributes match HR records.

---

# Risks

| Risk | Mitigation |
|------|------------|
| Incorrect HR data | Validate HR records before provisioning |
| Duplicate identities | Verify Employee ID uniqueness |
| Incorrect group assignments | Automate group mapping |
| Naming conflicts | Enforce organizational naming standards |
| Manual provisioning errors | Use PowerShell automation |

---

# Rollback Plan

If the pilot deployment fails:

1. Disable newly created user accounts.
2. Remove incorrect group memberships.
3. Remove Administrative Unit assignments.
4. Correct HR source data.
5. Re-run provisioning automation.
6. Revalidate all pilot accounts.

---

# Deliverables

Upon completion, the following artifacts will be produced:

- HR Validation Report
- Provisioning Log
- User Creation Report
- Security Group Assignment Report
- Administrative Unit Assignment Report
- Pilot Validation Report

---

# Approval

| Role | Name | Status |
|------|------|--------|
| IAM Consultant | David Adama | Approved |
| Project Sponsor | Mustard Innovations | Pending |
| IT Operations | Mustard Innovations | Pending |
| Security Team | Mustard Innovations | Pending |

---

# Version History

| Version | Date | Author | Description |
|----------|------|--------|-------------|
| 1.0 | 08 July 2026 | David Adama | Initial pilot provisioning plan |