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

- `../../modules/02-Identity-Provisioning/screenshots/provisioning-screenshot-01.png`
- `../../modules/02-Identity-Provisioning/screenshots/provisioning-screenshot-02.png`
- `../../modules/02-Identity-Provisioning/screenshots/provisioning-screenshot-03.png`
- `../../modules/02-Identity-Provisioning/screenshots/provisioning-screenshot-04.png`
- `../../modules/02-Identity-Provisioning/screenshots/provisioning-screenshot-05.png`
- `../../modules/02-Identity-Provisioning/screenshots/provisioning-screenshot-06.png`
- `../../modules/02-Identity-Provisioning/screenshots/provisioning-screenshot-07.png`
- `../../modules/02-Identity-Provisioning/screenshots/provisioning-screenshot-08.png`
- `../../modules/02-Identity-Provisioning/screenshots/provisioning-screenshot-09.png`

### Sample Provisioning Evidence

![Provisioning screenshot 1](../../modules/02-Identity-Provisioning/screenshots/provisioning-screenshot-01.png)

![Provisioning screenshot 2](../../modules/02-Identity-Provisioning/screenshots/provisioning-screenshot-02.png)

![Provisioning screenshot 3](../../modules/02-Identity-Provisioning/screenshots/provisioning-screenshot-03.png)

![Provisioning screenshot 4](../../modules/02-Identity-Provisioning/screenshots/provisioning-screenshot-04.png)

If the image files are not present, add the screenshot PNGs to the `../../modules/02-Identity-Provisioning/screenshots/` folder using the renamed filenames above.