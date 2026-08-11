# Application Identity Foundation

## Application

**Name:** MI Expense Portal

**Business Purpose:**  
Internal employee expense-management application for Mustard Innovations.

## Identity Model

The application is integrated with Microsoft Entra ID using an
application registration and service principal.

## Tenant Model

Single tenant.

## Application Object

The application object represents the global definition/configuration
of the application within its home tenant.

## Service Principal

The service principal represents the application's local identity
within the Mustard Innovations tenant.

## Security Considerations

- Single-tenant configuration used for internal enterprise application
- Application identity separated from human identities
- No secrets committed to source control
- Permissions will follow least-privilege principles
- Application access will later be governed using Conditional Access
  and enterprise application controls

## Validation

- [ ] Application registration created
- [ ] Client ID recorded securely
- [ ] Application object verified
- [ ] Enterprise application verified
- [ ] Service principal verified
- [ ] No credentials committed to repository