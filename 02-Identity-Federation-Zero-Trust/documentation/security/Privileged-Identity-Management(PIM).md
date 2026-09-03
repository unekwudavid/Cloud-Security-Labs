# Privileged Identity Management (PIM)

## Project Module

Identity Federation & Zero Trust Platform — Project 2

## Objective

Implement Microsoft Entra Privileged Identity Management (PIM) to provide Just-In-Time (JIT) privileged access for administrative roles.

This demonstrates least privilege and temporary privilege elevation.

---

## Business Scenario

Mustard Innovations administrators should not permanently hold privileged roles.

Instead, administrators become **eligible** for privileged roles and activate them only when administrative work is required.

The privileged role implemented is:

**Security Administrator**

---

## Security Principle

> Permanent eligibility. Temporary privilege.

PIM minimizes the attack surface by reducing standing administrative permissions.

---

## PIM Policy Configuration

| Setting                     | Configuration          |
| --------------------------- | ---------------------- |
| Role                        | Security Administrator |
| Assignment Type             | Eligible               |
| Maximum Activation Duration | 2 Hours                |
| Require MFA                 | Enabled                |
| Require Justification       | Enabled                |
| Require Ticket              | Disabled               |
| Require Approval            | Disabled (Lab)         |

---

## Just-In-Time Workflow

Eligible User
↓
Activate Role
↓
MFA Challenge
↓
Provide Justification
↓
Temporary Security Administrator
↓
Role Expiration / Manual Deactivation
↓
Eligible Again

---

## Implementation Steps

### Role Policy

Configured Security Administrator activation requirements.

### Eligible Assignment

Assigned the administrator account as **Eligible**.

### Activation

Activated the role for a temporary administrative session.

### Validation

Verified the role status changed from Eligible → Active.

### Deactivation

Manually deactivated the role and confirmed the assignment returned to Eligible.

---

## Security Value

PIM mitigates:

* Standing privileged access.
* Privilege persistence.
* Administrative credential abuse.
* Insider privilege misuse.

Administrative permissions exist only during approved activation windows.

---

## Zero Trust Alignment

PIM implements:

* Least privilege.
* Just-In-Time elevation.
* Strong authentication before privilege.
* Time-bound administrative access.

---

## Evidence Captured

Screenshots collected:

* Security Administrator role settings.
* Eligible assignment.
* Activation request.
* Active privileged role.
* Deactivated role returning to Eligible.

---


### Why use Eligible instead of Active assignments?

Eligible assignments require administrators to activate privileged access when needed, reducing permanent administrative exposure.

### Why require MFA during activation?

Privileged access requires stronger verification than ordinary workforce authentication.

### Why require justification?

Administrative actions become auditable and tied to a business reason for activation.

### What is Just-In-Time access?

Temporary elevation of privileged permissions that automatically expire after the configured activation period.
