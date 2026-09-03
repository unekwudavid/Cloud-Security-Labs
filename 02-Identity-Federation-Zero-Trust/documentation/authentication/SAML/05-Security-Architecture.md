# Security Architecture

## 1. Identity Provider

Microsoft Entra ID acts as the centralized Identity Provider.

It is responsible for:

- User authentication
- Identity information
- Application assignment
- Application role assignment
- SAML assertion issuance

---

# 2. Service Provider

The MI Expense Portal acts as the SAML Service Provider.

The application is responsible for:

- Initiating SAML authentication
- Receiving the SAML assertion
- Validating the assertion
- Establishing an application session
- Enforcing application authorization

---

# 3. Trust Relationship

The trust relationship is established through:

- SAML Entity ID
- ACS URL
- Microsoft Entra ID SAML endpoint
- Entra ID signing certificate

The signing certificate allows the Service Provider to validate that the SAML assertion was issued by the trusted Identity Provider.

---

# 4. Zero Trust Principles

The implementation demonstrates several Zero Trust concepts.

### Verify Explicitly

The application does not trust an unauthenticated request.

Authentication is required before protected resources can be accessed.

### Least Privilege

Users receive only the application role required for their job function.

For example:

Employee ≠ Manager ≠ Finance ≠ Admin

### Assume Breach

Authentication alone does not provide unrestricted application access.

Every protected endpoint performs an authorization check.

---

# 5. Authentication vs Authorization

Authentication:

"Who are you?"

Implemented through:

Microsoft Entra ID + SAML 2.0

Authorization:

"What are you allowed to access?"

Implemented through:

Microsoft Entra ID Application Roles + application authorization middleware.

---

# 6. Security Boundary

The architecture establishes a clear security boundary:

Microsoft Entra ID
        |
        | Identity + Role
        v
SAML Assertion
        |
        v
MI Expense Portal
        |
        v
Authorization Middleware
        |
        v
Protected Resource

The application trusts the federated identity only after successful SAML validation and then independently evaluates authorization requirements.

---

# 7. Future Enhancements

Potential production enhancements include:

- HTTPS instead of localhost HTTP
- Secure and HttpOnly session cookies
- SameSite cookie configuration
- Persistent session store such as Redis
- Centralized audit logging
- Application role lifecycle management
- Conditional Access policies
- MFA
- Privileged Identity Management
- Automated provisioning/deprovisioning
- Automated authorization testing
- Monitoring and alerting