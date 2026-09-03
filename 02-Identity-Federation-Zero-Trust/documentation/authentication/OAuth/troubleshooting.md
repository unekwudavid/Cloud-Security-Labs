Issue:
AADSTS7000215 — Invalid client secret

Impact:
Token acquisition failed after successful user authentication.

Investigation:
Verified:
- Tenant ID
- Client ID
- Redirect URI
- Environment variables
- MSAL configuration
- Client secret configuration

Root Cause:
The application was using an invalid client-secret credential.

Resolution:
Generated a new client secret and configured the secret VALUE rather than the Secret ID.

Result:
Token acquisition and authentication succeeded.