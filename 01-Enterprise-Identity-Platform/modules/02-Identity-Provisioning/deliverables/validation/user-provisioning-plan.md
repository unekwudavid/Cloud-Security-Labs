# User Provisioning Plan

## Purpose
Define the operational plan for provisioning user identities into Microsoft Entra ID.

## Scope
Covers HR-sourced onboarding for employees during pilot and steady-state.

## Provisioning Workflow
- HR creates record
- IAM validation (data quality & approvals)
- Provisioning method: CSV bulk import (pilot)
- Administrative Unit assignment
- Security group assignment
- License assignment
- Access validation and reconciliation
- Operational handover to IT Ops

## Roles & Responsibilities
- HR: source data and submit changes
- IAM team: run provisioning and validation
- IT Ops: license assignment and troubleshooting

## Validation and Auditing
- Daily reconciliation of CSV import vs HR source
- UPN format and EmployeeID checks
- Audit logs retained per retention policy

## Rollback
- Failed imports are logged; revert created accounts and notify HR

## References
See `identity-provisioning-standard.md` for naming and lifecycle standards.

Provisioning evidence and captured sample runs are stored in the `../screenshots/` folder.

- `../screenshots/provisioning-screenshot-01.png`
- `../screenshots/provisioning-screenshot-02.png`
- `../screenshots/provisioning-screenshot-03.png`
- `../screenshots/provisioning-screenshot-04.png`
- `../screenshots/provisioning-screenshot-05.png`
- `../screenshots/provisioning-screenshot-06.png`
- `../screenshots/provisioning-screenshot-07.png`
- `../screenshots/provisioning-screenshot-08.png`
- `../screenshots/provisioning-screenshot-09.png`
