# OAuth 2.0 / OpenID Connect Implementation

## Objective

Demonstrate secure authentication of enterprise users through
Microsoft Entra ID using OAuth 2.0 Authorization Code Flow and
OpenID Connect.

## Components

- Microsoft Entra ID
- MI Expense Portal
- MSAL Node
- Microsoft Graph
- Express.js

## Authentication Flow

User → Application → Entra ID → Authorization Code
→ MSAL → Tokens → Application Session

## OAuth 2.0

Used for delegated authorization and obtaining an access token
for Microsoft Graph.

## OpenID Connect

Used to establish the authenticated user's identity through
OIDC identity information and the ID token.

## Microsoft Graph

The application uses the delegated User.Read permission to
retrieve the authenticated user's `/me` resource.

## Security Considerations

- Credentials are handled by Microsoft Entra ID.
- Client secret is kept server-side.
- Access tokens are not exposed in source code.
- Graph permissions follow least-privilege principles.
- Redirect URI is explicitly registered.
- Authentication and API authorization are treated as separate concerns.

## Validation

- Entra authentication successful
- Authorization code successfully exchanged
- User session established
- Microsoft Graph `/me` request successful