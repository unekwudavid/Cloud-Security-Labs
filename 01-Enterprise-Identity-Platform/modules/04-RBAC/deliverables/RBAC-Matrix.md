# Mustard Innovations RBAC Matrix

## Administrative Role Assignment Matrix

| Job Role | Entra Role | Scope | Justification |
|----------|------------|-------|---------------|
| Identity Administrator | Global Administrator | Tenant | Emergency administration only |
| IAM Engineer | User Administrator | Tenant | User lifecycle management |
| IAM Engineer | Groups Administrator | Tenant | Group administration |
| IT Support | Helpdesk Administrator | Tenant | Password resets |
| Security Analyst | Security Reader | Tenant | Read-only security visibility |
| Compliance Officer | Reports Reader | Tenant | Audit reporting |
| License Manager | License Administrator | Tenant | License management |

---

## Principles

- Least Privilege
- Separation of Duties
- Named Administrative Accounts
- MFA Required
- Administrative actions logged
- Future migration to PIM