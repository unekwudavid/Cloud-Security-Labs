# Mover Orchestration

This folder contains execution evidence for the enterprise Mover workflow implemented by the PowerShell automation in the project.

## Purpose

The Mover orchestration evaluates employee lifecycle changes such as department moves, role shifts, manager updates, administrative unit changes, and access reconciliation.

## Workflow overview

The mover flow typically includes:

- Current-state identity review
- Desired-state comparison
- Manager and team change assessment
- Administrative Unit reconciliation
- Group membership reconciliation
- RBAC and licensing evaluation
- Execution planning and validation

## Related automation

- `../automation/powershell/11-Move-MIEmployees.ps1`
- `../automation/powershell/12-Validate-MoverAdministrativeUnit.ps1`
- `../automation/modules/MI.Movers.psm1`
- `../automation/modules/MI.Managers.psm1`

## Execution gallery

The screenshots in this folder reflect sample Mover workflow operational output and reconciliation evidence.

![Mover 1](./Screenshot%20(99).png)

![Mover 2](./Screenshot%20(100).png)

![Mover 3](./Screenshot%20(101).png)

![Mover 4](./Screenshot%20(103).png)

![Mover 5](./Screenshot%20(104).png)

![Mover 6](./Screenshot%20(105).png)

![Mover 7](./Screenshot%20(106).png)

![Mover 8](./Screenshot%20(107).png)

![Mover 9](./Screenshot%20(108).png)

![Mover 10](./Screenshot%20(112).png)

![Mover 11](./Screenshot%20(114).png)

![Mover 12](./Screenshot%20(116).png)

## Notes

These screenshots demonstrate how the mover workflow supports access alignment and identity state correction during employee transitions inside the target enterprise environment.
