# Identity Lifecycle Management

## Purpose

Identity Lifecycle Management ensures that user identities are created, modified, and removed in a secure, consistent, and auditable manner throughout their employment lifecycle.

---

# Joiner Process

## Business Scenario

A new employee joins Mustard Innovations.

### Process

1. Human Resources creates the employee record within the HR system.
2. The hiring manager submits an onboarding request.
3. IT validates the request and creates the user account in Microsoft Entra ID.
4. The user is assigned to the appropriate department and security groups.
5. Required Microsoft 365 licenses are assigned.
6. Multi-Factor Authentication is configured during first sign-in.
7. Access to approved applications is provisioned based on the employee's role.
8. The user's manager validates that all required resources have been provisioned.

### Approval

- Human Resources
- Hiring Manager
- IT Operations

### Target Completion

All accounts should be provisioned before the employee's first working day.

---

# Mover Process

## Business Scenario

An employee changes department, role, manager, or office location.

### Process

1. Human Resources updates the employee's record.
2. The employee's manager submits a role change request.
3. Existing access rights are reviewed.
4. New department security groups are assigned.
5. Obsolete permissions are removed.
6. Administrative roles are reviewed if applicable.
7. Conditional Access policies automatically apply based on new group membership.
8. Access review is completed within five business days.

### Approval

- Current Manager
- New Manager
- Human Resources
- IT Operations

### Target Completion

Role changes should be completed within one business day after approval.

---

# Leaver Process

## Business Scenario

An employee resigns or employment is terminated.

### Process

1. Human Resources notifies IT of the employee's departure.
2. The user's account is disabled immediately upon termination or at the end of the employee's final working day.
3. Active sessions are revoked.
4. Multi-Factor Authentication methods are invalidated.
5. Administrative privileges are removed immediately.
6. Licenses are reclaimed.
7. User mailbox and OneDrive are retained according to the organization's retention policy.
8. After the retention period expires, the account is permanently deleted.

### Approval

- Human Resources
- Employee Manager
- IT Operations

### Target Completion

Account access should be revoked within one hour of employment termination.

---

# Identity Reviews

Identity reviews are conducted quarterly to verify that users retain only the access required for their current job responsibilities. Access reviews include privileged roles, guest accounts, inactive accounts, and application assignments.

---

# Account Retention

| Account Type | Retention Period |
|--------------|-----------------|
| Active Employees | Until employment ends |
| Disabled Accounts | 30 Days |
| Former Employees | 90 Days (where business or legal requirements apply) |
| Guest Accounts | Reviewed every 90 Days |
| Service Accounts | Reviewed every 180 Days |

---

# Identity Governance Principles

- Every identity must have a verified business owner.
- Every privileged role must require documented business justification.
- Access must be reviewed on a scheduled basis.
- All identity lifecycle events must be logged and auditable.
- Access should be role-based rather than assigned directly to individual users whenever possible.
