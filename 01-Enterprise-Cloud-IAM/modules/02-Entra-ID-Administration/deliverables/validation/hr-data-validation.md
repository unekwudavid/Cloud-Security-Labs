# HR Data Validation

## Purpose
Ensure HR source data is accurate, consistent, and suitable for automated provisioning into Microsoft Entra ID.

## Scope
Applies to the HR master register and any CSV exports used for provisioning (e.g., `employees.csv`, `entra-import.csv`).

## Mandatory Fields
- `EmployeeID` (format: MI-XXXX)
- `FirstName`
- `LastName`
- `UPN` or components to construct UPN (`FirstName`, `LastName`)
- `StartDate`
- `Department`

Records missing mandatory fields must be flagged and returned to HR.

## Format & Validation Rules
- `EmployeeID`: must follow `MI-` + four digits, unique across the register.
- `UPN`: lowercase, dot-separated (`firstname.lastname@daveshub.onmicrosoft.com`), no special characters except `.`; length limits observed by Entra ID.
- `DisplayName`: `Firstname Lastname`, title-cased.
- `StartDate`: ISO format `YYYY-MM-DD` and not a future date for provisioning (unless staged hires).
- `Department` and `JobTitle`: match approved taxonomy values.

## Duplicate Detection
- Check for identical `EmployeeID` values.
- Check for identical UPNs or `firstname.lastname` collisions; append numeric suffixes per naming policy if needed and approved.

## Data Quality Checks
- Trim whitespace from all text fields.
- Remove diacritics and normalize characters in name fields for UPN generation.
- Validate email domain matches tenant domain (`daveshub.onmicrosoft.com`) if UPNs are prepopulated.

## Mapping Rules (HR -> Entra Import)
- `EmployeeID` -> `employeeId`
- `FirstName` -> `givenName`
- `LastName` -> `surname`
- Construct `userPrincipalName` as `lower(firstname).lower(lastname)@daveshub.onmicrosoft.com` unless overridden
- `Department`, `JobTitle` -> `department`, `jobTitle`

## Pre-Import Validation Steps
1. Run automated validation script against `employees.csv` to produce an issues report.
2. Resolve all high-severity issues (missing required fields, duplicate EmployeeID/UPN).
3. Create `entra-import.csv` from validated data and run a dry-run (if supported) or staging import.

## Post-Import Reconciliation
- Reconcile created accounts against `employees.csv` by `employeeId` and UPN.
- Verify group and administrative unit assignments for a sample set.
- Capture import job logs and store with change request artifacts.

## Automation & Checks
- Implement linting script to enforce naming and format rules before provisioning.
- Include automated tests for UPN uniqueness and EmployeeID patterns.

## Exception Handling
- Records failing validation are exported to `deliverables/validation/failed-records.csv` and returned to HR with remediation notes.

## References
- `identity-provisioning-standard.md`
- `employee-naming-standard.md`
- `pilot-user-provisioning-plan.md`
- Change Request: `CHG-0001-Initial-User-Provisioning.md`
