# Pilot User Provisioning Plan

## Purpose
Plan to provision the initial pilot cohort of user accounts into Microsoft Entra ID using CSV bulk import and validate the end-to-end process.

## Scope
- Pilot cohort: up to 54 employees from HR master register
- Systems impacted: Microsoft Entra ID (users, groups, administrative units)
- Import method: CSV bulk import (pilot)

## Timeline
- Preparation and CSV generation: Day 0
- Test import to a staging tenant (if available): Day 1
- Pilot import to production tenant: Day 2
- Validation and reconciliation: Day 3

## Pre-Flight Checks
- Confirm HR source data completeness and EmployeeID uniqueness
- Validate UPNs conform to naming standard
- Ensure required Administrative Units and Security Groups exist
- Backup current tenant user state (export) and capture audit baseline

## Provisioning Steps
1. Generate `entra-import.csv` from HR source `employees.csv` following mapping rules.
2. Run CSV bulk import in pilot mode (dry-run) and review errors.
3. Execute final import and monitor job status.
4. Assign licenses, Administrative Units, and Security Groups as defined.

## Validation
- Reconcile imported accounts with HR master register (employeeId, UPN, displayName)
- Confirm group and administrative unit assignments for a sample set
- Verify sign-in success for a small subset (test accounts)
- Record import logs and job outputs for audit

## Rollback / Remediation
- Disable or delete incorrectly created accounts per rollback procedure
- Re-run corrected CSV import for failed records
- Notify HR and stakeholders of remediation outcomes

## Roles & Responsibilities
- HR: Provide and approve source CSV
- IAM Team: Prepare CSV, run import, assign groups/units
- IT Ops: License assignment and post-import operational support

## Acceptance Criteria
- 100% of pilot cohort accounts provisioned with correct EmployeeID and UPN
- No critical import errors remaining
- Validation checklist signed-off by IAM and HR leads

## References
- `identity-provisioning-standard.md`
- `employee-naming-standard.md`
- Change Request: `CHG-0001-Initial-User-Provisioning.md`
