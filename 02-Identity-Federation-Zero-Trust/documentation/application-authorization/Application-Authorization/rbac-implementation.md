# Application Role-Based Access Control (RBAC)

## Project

**MI Expense Portal — Identity Federation & Zero Trust Platform**

## Objective

The MI Expense Portal implements application-level authorization using Microsoft Entra ID application roles and server-side Express middleware.

The objective is to ensure that an authenticated user can only access application functionality permitted by their assigned application role.

The application currently defines four roles:

- Employee
- Manager
- Finance
- Admin

Authorization is enforced by the application backend rather than relying solely on frontend controls.

---

# 1. Authentication vs Authorization

Authentication and authorization are treated as separate security controls.

## Authentication

Authentication answers:

> Who is the user?

The MI Expense Portal uses Microsoft Entra ID with the OAuth 2.0 Authorization Code flow and OpenID Connect.

After successful authentication, MSAL Node returns the authenticated account and ID-token claims.

The application stores the authenticated account and relevant token claims in the server-side session.

## Authorization

Authorization answers:

> What is the authenticated user allowed to access?

The application reads the `roles` claim from the Microsoft Entra ID token and compares it against the role required by each protected endpoint.

The authorization flow is:

```text
User
  |
  v
Microsoft Entra ID
  |
  | OAuth 2.0 / OpenID Connect
  v
Authentication
  |
  v
ID Token
  |
  | roles claim
  v
Express Session
  |
  v
requireRole()
  |
  +--------------------+
  |                    |
  | Role matches       | Role does not match
  v                    v
200 Allowed           403 Forbidden