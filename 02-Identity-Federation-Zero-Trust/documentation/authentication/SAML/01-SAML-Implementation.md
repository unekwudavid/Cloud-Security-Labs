# SAML 2.0 Federation with Microsoft Entra ID

## 1. Objective

The objective of this implementation was to integrate the MI Expense Portal with Microsoft Entra ID using SAML 2.0 federation.

The implementation demonstrates how an enterprise application can delegate authentication to Microsoft Entra ID while consuming identity and authorization information from the resulting SAML assertion.

### Key objectives

- Implement SAML 2.0 authentication.
- Configure Microsoft Entra ID as the Identity Provider (IdP).
- Configure the MI Expense Portal as the Service Provider (SP).
- Validate SAML assertions using the Entra ID signing certificate.
- Consume user identity attributes from the SAML assertion.
- Consume application roles from the SAML assertion.
- Establish application-level role-based access control.

---

# 2. Architecture

The authentication flow follows this model:

User
  |
  v
MI Expense Portal
  |
  | SAML Authentication Request
  v
Microsoft Entra ID
  |
  | User Authentication
  | Application Role Assignment
  v
SAML Assertion
  |
  v
MI Expense Portal
  |
  | Validate Assertion
  | Extract Identity
  | Extract Role
  v
Application Authorization
  |
  +--> Employee
  +--> Manager
  +--> Finance
  +--> Admin

---

# 3. Technology Stack

| Component | Technology |
|---|---|
| Identity Provider | Microsoft Entra ID |
| Federation Protocol | SAML 2.0 |
| Application | MI Expense Portal |
| Runtime | Node.js |
| Web Framework | Express.js |
| Authentication Library | Passport.js |
| SAML Library | passport-saml |
| Session Management | express-session |
| Authorization Model | Application Roles / RBAC |
| Development Environment | localhost:3000 |

---

# 4. Microsoft Entra ID Configuration

A SAML enterprise application was configured in Microsoft Entra ID for the MI Expense Portal.

The application configuration included:

- Identifier (Entity ID)
- Reply URL / Assertion Consumer Service (ACS) URL
- Login URL
- Microsoft Entra ID SAML signing certificate
- Application roles
- User assignment

The application was configured so that Microsoft Entra ID acts as the Identity Provider.

---

# 5. Service Provider Configuration

The Node.js application consumes the Entra ID SAML configuration through environment variables.

Example:

SAML_ENTRY_POINT
SAML_ISSUER
SAML_CALLBACK_URL

The signing certificate is stored separately and loaded by the application at runtime.

The application configuration is implemented in:

config/samlConfig.js

---

# 6. SAML Configuration

The application uses `passport-saml` to implement the Service Provider.

The configuration contains:

- Entra ID SSO endpoint
- Service Provider issuer
- ACS callback URL
- Entra ID signing certificate
- SAML identifier format configuration

The signing certificate is loaded from:

config/entra-saml-cert.pem

The certificate is used to validate the SAML response received from Microsoft Entra ID.

---

# 7. Authentication Flow

The authentication process is:

### Step 1 — User initiates login

The user accesses:

/auth/saml/login

The application redirects the user to Microsoft Entra ID.

### Step 2 — Microsoft Entra ID authenticates the user

Microsoft Entra ID authenticates the user and determines which application roles have been assigned.

### Step 3 — Entra ID generates a SAML assertion

The SAML response contains identity attributes and the assigned application role.

Example role claim:

http://schemas.microsoft.com/ws/2008/06/identity/claims/role

Value:

Employee

### Step 4 — Assertion is returned to the application

Microsoft Entra ID sends the SAML response to:

/auth/saml/callback

### Step 5 — Application validates the assertion

`passport-saml` processes the assertion and validates it using the configured Entra ID signing certificate.

### Step 6 — User identity is stored in the session

The authenticated SAML identity is stored in:

req.session.samlUser

### Step 7 — Authorization middleware evaluates the role

The application reads the role from the federated identity and compares it with the role required by the endpoint.

---

# 8. SAML Assertion Validation

The application successfully received the following identity information from Microsoft Entra ID:

- Tenant ID
- Object ID
- Display name
- Given name
- Surname
- Email address
- Identity provider
- Authentication methods
- Application role

Example:

Role:

Employee

The SAML assertion contained:

http://schemas.microsoft.com/ws/2008/06/identity/claims/role = Employee

This confirmed that the application was successfully receiving authorization information from the Identity Provider.

---

# 9. Implementation Result

The final implementation successfully established:

Microsoft Entra ID
        ↓
SAML 2.0
        ↓
MI Expense Portal
        ↓
SAML Identity
        ↓
Application Role
        ↓
Authorization Middleware
        ↓
Protected Resource

The application successfully authenticated users and enforced role-based access based on the role received from Microsoft Entra ID.