# PowerShell Automation

This folder contains PowerShell scripts that implement the identity lifecycle for the Mustard Innovations project.

## Purpose
Use these scripts to validate HR source data, provision users, assign Administrative Units and Security Groups, set managers, and generate reports.

## Typical workflow
1. `01-Validate-HRData.ps1` — Validate the HR CSV source data
2. `02-New-MIUsers.ps1` — Create Microsoft Entra ID users
3. `03-Set-AdministrativeUnits.ps1` — Assign Administrative Units
4. `04-Set-SecurityGroups.ps1` — Assign security groups
5. `05-Set-Managers.ps1` — Assign reporting relationships
6. `06-Export-ProvisioningReport.ps1` — Export a summary report

## How to run
Run the scripts from the repository root or by using the script path directly.
Make sure PowerShell respects the execution policy and the config file is available in `../config/`.

## Notes
- Scripts should use shared configuration and avoid hard-coded tenant values.
- Logs should be written to the `../logs/` folder.
- This folder may contain helper and reusable functions for automation tasks.

## Visual References
For automation and provisioning workflow diagrams, see:

- `../../diagrams/exports/03-powershell-automation-architecture.png` — PowerShell automation architecture
- `../../diagrams/exports/02-user-provisioning-workflow.png` — User provisioning workflow

Provisioning screenshots (capture outputs from sample runs) are available in the identity provisioning module screenshot folder:

- `../../modules/02-Identity-Provisioning/screenshots/provision-miemployees-01.png` — Example: single user provisioning run and summary
- `../../modules/02-Identity-Provisioning/screenshots/provision-miemployees-multiple.png` — Example: bulk provisioning run with mixed results
- `../../modules/02-Identity-Provisioning/screenshots/provision-managers-01.png` — Example: manager provisioning and report
- `../../modules/02-Identity-Provisioning/screenshots/provision-run-terminal-01.png` — Example: terminal output showing group & manager assignment

### Sample Provisioning Evidence

![Single user provisioning run](../../modules/02-Identity-Provisioning/screenshots/provision-miemployees-01.png)

![Bulk provisioning run](../../modules/02-Identity-Provisioning/screenshots/provision-miemployees-multiple.png)

![Manager provisioning report](../../modules/02-Identity-Provisioning/screenshots/provision-managers-01.png)

![Provisioning terminal output](../../modules/02-Identity-Provisioning/screenshots/provision-run-terminal-01.png)

If the image files are not present, add the screenshot PNGs to the `../../modules/02-Identity-Provisioning/screenshots/` folder using the filenames above.