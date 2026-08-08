# Joiner Orchestration

This folder contains execution evidence for the enterprise Joiner workflow implemented by the PowerShell automation in the project.

## Purpose

The Joiner orchestration provisions a new employee identity into Microsoft Entra ID and validates the onboarding state before the employee is made operational.

## Workflow overview

The joiner flow typically includes:

- HR validation
- User creation
- Employee ID backfill
- Manager assignment
- Group membership assignment
- Administrative Unit assignment
- Licensing checks
- Reporting and validation

## Related automation

- `../automation/powershell/10-Invoke-MIJoiner.ps1`
- `../automation/powershell/02-Validate-HRData.ps1`
- `../automation/powershell/03-Provision-MIEmployees.ps1`
- `../automation/powershell/09-Backfill-EmployeeIds.ps1`

## Execution gallery

The screenshots in this folder reflect sample Joiner workflow runs and validation outputs.

![Joiner 1](./Screenshot%20(80).png)

![Joiner 2](./Screenshot%20(81).png)

![Joiner 3](./Screenshot%20(82).png)

![Joiner 4](./Screenshot%20(83).png)

![Joiner 5](./Screenshot%20(84).png)

![Joiner 6](./Screenshot%20(86).png)

![Joiner 7](./Screenshot%20(87).png)

![Joiner 8](./Screenshot%20(88).png)

![Joiner 9](./Screenshot%20(94).png)

![Joiner 10](./Screenshot%20(96).png)

![Joiner 11](./Screenshot%20(98).png)

![Joiner 12](./Screenshot%20(123).png)

## Notes

These screenshots support the project portfolio by demonstrating the operational flow of identity onboarding, validation, and provisioning in a Microsoft Entra ID environment.
