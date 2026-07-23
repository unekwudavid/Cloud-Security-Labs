# Lessons Learned

## Key Insights from Enterprise Identity Governance and Automation

- Maintain a clear separation between administrative scope and access control. Administrative Units should handle delegated administration while Dynamic Groups and RBAC manage resource access.
- Validating automation against Microsoft Graph early prevents later issues with policy scope, licensing requirements, and group membership rules.
- Microsoft Entra ID Premium (P1/P2) is a hard requirement for Dynamic Group creation; documenting this dependency avoids surprise platform limitations during deployment.
- Configuration-driven automation improves consistency, but it requires strong source data quality from HR and identity attributes.
- Good naming conventions and consistent group descriptions make dynamic membership rules easier to understand, audit, and troubleshoot.
- Build a reusable operational runbook for common tasks such as licensing review, manager assignment validation, and group membership diagnostics.
- Document troubleshooting steps for automation failures, including Graph API permissions, dynamic membership syntax, and license assignment errors.
- Keep screenshots and validation evidence aligned with documentation so stakeholders can verify implementation and understand the current state.

## Recommendations

- Continue capturing operational issues as they occur and update this file after each deployment or automation change.
- Use a structured change-management process for updates to dynamic membership rules, licensing policies, and administrative unit assignments.
- Add dedicated operational checks for license availability, delegated admin scope, and user attribute hygiene in the provisioning workflow.
- Regularly review the Automation Flow and Identity Lifecycle documents to ensure the implementation remains aligned with business processes.
