# SAML Implementation Troubleshooting

## 1. Problem: SAML Authentication Succeeded but Role Was Missing

### Symptom

The application successfully authenticated the user through Microsoft Entra ID.

However, the SAML profile did not initially contain the expected role.

The application output showed:

req.user.roles: undefined

req.user.attributes.roles: undefined

The expected Employee role was not present.

### Investigation

The SAML assertion was inspected to determine whether Microsoft Entra ID was actually sending the role claim.

The initial assertion contained identity attributes such as:

- tenant ID
- object ID
- display name
- email
- given name
- surname

However, the role claim was missing.

### Root Cause

The application role assignment / SAML role configuration was not yet correctly established between the Microsoft Entra enterprise application and the application registration.

The user had administrative directory roles, but those roles were not equivalent to the application's Employee, Manager, Finance, or Admin application roles.

### Resolution

A separate application registration was configured for the application.

Application roles were defined and exposed to the enterprise application.

The user was then assigned the appropriate application role.

After signing out and authenticating again, the SAML assertion contained:

http://schemas.microsoft.com/ws/2008/06/identity/claims/role = Employee

### Result

The application successfully received:

req.user.roles: Employee

The role was also available through:

req.user.attributes

and the SAML role claim.

---

# 2. Problem: "Select a Role" Was Disabled

### Symptom

While assigning the user to the enterprise application, the role selection control was disabled.

### Investigation

The enterprise application was inspected to determine whether application roles had been defined and exposed by the corresponding application registration.

### Root Cause

The enterprise application did not have selectable application roles available for assignment.

Directory roles such as:

- Cloud Application Administrator
- Reports Reader

are Microsoft Entra directory roles.

They are not application roles for the MI Expense Portal.

### Resolution

The application registration was configured with application roles representing the application's business authorization model.

The enterprise application then exposed those roles for assignment.

The user could subsequently be assigned:

Employee

### Lesson Learned

Microsoft Entra directory roles and application roles serve different purposes.

Directory roles control administrative capabilities within Microsoft Entra ID.

Application roles control what a user can do inside a specific application.

---

# 3. Problem: Role Format Was Not Initially What the Middleware Expected

### Symptom

The middleware expected:

req.session.samlUser.roles

to behave like an array.

The SAML profile initially exposed:

roles: "Employee"

rather than:

roles: ["Employee"]

### Resolution

The SAML profile structure was inspected before finalizing the authorization middleware.

The implementation was adjusted to correctly consume the role representation returned by the SAML library.

### Lesson Learned

Federated identity attributes should never be assumed to have a particular data type.

The actual assertion/profile returned by the Identity Provider should be inspected and normalized before authorization logic is implemented.

---

# 4. Problem: Authentication and Authorization Were Initially Mixed

### Observation

The application had two authentication approaches:

- OAuth 2.0 / OpenID Connect using MSAL
- SAML using Passport

This created two separate authentication session representations.

### Resolution

The SAML implementation was isolated under:

/auth/saml

while authorization was implemented independently through:

/authorization

The SAML identity is stored in:

req.session.samlUser

The authorization middleware evaluates that federated identity.

### Lesson Learned

Authentication mechanisms should be clearly separated from authorization logic.

This allows the authorization layer to remain reusable even if the authentication mechanism changes.