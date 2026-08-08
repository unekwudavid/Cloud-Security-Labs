# Leaver Orchestration

This folder contains execution evidence for the enterprise Leaver workflow implemented by the PowerShell automation in the project.

## Purpose

The Leaver orchestration manages employee offboarding and access removal in a controlled, auditable sequence to reduce security risk and operational exposure.

## Workflow overview

The leaver flow typically includes:

- Current-state review for departing users
- Desired terminated-state comparison
- RBAC cleanup and privilege review
- Group and license removal
- Session revocation and access removal
- Account disablement
- Reporting and audit evidence

## Related automation

- `../automation/powershell/13-Leaver-MIEmployees.ps1`
- `../automation/modules/MI.Leavers.psm1`
- `../automation/modules/MI.RBAC_Automation.psm1`
- `../automation/modules/MI.Reporting.psm1`

## Execution gallery

The screenshots in this folder reflect sample Leaver workflow outputs and offboarding operations.

![Leaver 1](./Screenshot%20(111).png)

![Leaver 2](./Screenshot%20(117).png)

![Leaver 3](./Screenshot%20(118).png)

![Leaver 4](./Screenshot%20(119).png)

![Leaver 5](./Screenshot%20(124).png)

![Leaver 6](./Screenshot%20(127).png)

![Leaver 7](./Screenshot%20(128).png)

![Leaver 8](./Screenshot%20(130).png)

![Leaver 9](./Screenshot%20(131).png)

![Leaver 10](./Screenshot%20(133).png)

![Leaver 11](./Screenshot%20(134).png)

![Leaver 12](./Screenshot%20(135).png)

![Leaver 13](./Screenshot%20(136).png)

![Leaver 14](./Screenshot%20(137).png)

![Leaver 15](./Screenshot%20(139).png)

## Notes

These screenshots provide the operational evidence for the leaver process and reflect the business need to deprovision user access in a safe, governed, and audit-friendly way.
