# SAML Authentication and Authorization Testing

## 1. Test Objective

The objective of testing was to verify that:

1. Users can authenticate through Microsoft Entra ID.
2. SAML assertions are successfully validated.
3. Application roles are received from Microsoft Entra ID.
4. Role-based authorization is enforced.
5. Users cannot access endpoints outside their assigned role.

---

# 2. Test User

The test account was assigned:

Application Role: Employee

---

# 3. Authentication Test

### Test

Navigate to:

/auth/saml/login

### Expected Result

The user is redirected to Microsoft Entra ID.

After successful authentication, Microsoft Entra ID returns a SAML assertion to:

/auth/saml/callback

### Result

PASS

The application successfully authenticated the user.

---

# 4. SAML Role Claim Test

The SAML assertion was inspected.

Expected role:

Employee

Observed role:

Employee

Observed SAML claim:

http://schemas.microsoft.com/ws/2008/06/identity/claims/role

Result:

PASS

---

# 5. Authorization Tests

| Test | Expected | Actual | Result |
|---|---:|---:|---|
| Employee → /authorization/employee | 200 | 200 | PASS |
| Employee → /authorization/manager | 403 | 403 | PASS |
| Employee → /authorization/finance | 403 | 403 | PASS |
| Employee → /authorization/admin | 403 | 403 | PASS |

---

# 6. Security Validation

The testing confirms that successful authentication does not automatically provide access to protected application resources.

The Employee user was able to access only the Employee endpoint.

Attempts to access Manager, Finance, and Admin resources resulted in:

HTTP 403 Forbidden

This confirms that authorization is being enforced at the application layer.

---

# 7. Evidence

Screenshots should be captured for:

1. Microsoft Entra enterprise application configuration.
2. Application role definitions.
3. User assignment to the Employee role.
4. Successful SAML authentication.
5. SAML role claim showing Employee.
6. Employee endpoint returning HTTP 200.
7. Manager endpoint returning HTTP 403.
8. Finance endpoint returning HTTP 403.
9. Admin endpoint returning HTTP 403.

Sensitive values such as client secrets, certificates/private keys, access tokens and session cookies must not be included in screenshots.