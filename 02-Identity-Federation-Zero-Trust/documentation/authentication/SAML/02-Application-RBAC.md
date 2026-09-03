# Application Role-Based Access Control

## 1. Objective

The MI Expense Portal implements application-level Role-Based Access Control (RBAC) using application roles issued by Microsoft Entra ID.

Authentication and authorization are treated as separate controls.

Authentication determines:

"Who is the user?"

Authorization determines:

"What is this user allowed to access?"

---

# 2. Defined Application Roles

The application defines four business roles:

| Role | Description |
|---|---|
| Employee | Standard employee access |
| Manager | Manager-level expense functionality |
| Finance | Finance-related expense functionality |
| Admin | Administrative functionality |

---

# 3. Role Assignment

Users are assigned application roles through the Microsoft Entra ID enterprise application.

The application does not independently determine the user's business role.

Instead:

Microsoft Entra ID
       |
       | Application Role Assignment
       v
SAML Assertion
       |
       | Role Claim
       v
MI Expense Portal
       |
       v
Authorization Middleware

This creates a centralized identity and authorization model.

---

# 4. Role Claim

Microsoft Entra ID returns the assigned application role using the SAML role claim:

http://schemas.microsoft.com/ws/2008/06/identity/claims/role

Example:

Employee

The `passport-saml` library exposes the resulting role through the authenticated SAML profile.

---

# 5. Authorization Middleware

The application implements reusable authorization middleware:

requireRole(requiredRole)

The middleware performs two checks.

### Authentication check

The application first verifies that a SAML-authenticated session exists.

If the user is not authenticated:

HTTP 401 Unauthorized

### Authorization check

The application then retrieves the roles from the federated SAML identity.

If the required role is not present:

HTTP 403 Forbidden

If the role is present:

The request is allowed to continue.

---

# 6. Protected Endpoints

The application exposes role-protected endpoints:

| Endpoint | Required Role |
|---|---|
| /authorization/employee | Employee |
| /authorization/manager | Manager |
| /authorization/finance | Finance |
| /authorization/admin | Admin |

---

# 7. Authorization Model

For example:

Employee user
    |
    +--> /authorization/employee → 200 OK
    |
    +--> /authorization/manager  → 403 Forbidden
    |
    +--> /authorization/finance  → 403 Forbidden
    |
    +--> /authorization/admin    → 403 Forbidden

This demonstrates least-privilege access.

A user receives access only to resources associated with their assigned role.

---

# 8. Security Principle Demonstrated

The implementation follows the principle:

"Authentication does not imply authorization."

Successfully authenticating with Microsoft Entra ID does not automatically grant access to every application resource.

Access is explicitly evaluated against the user's assigned application role.