# Microsoft Project Schedule and Calculation Troubleshooter

Created by **Dewald Pretorius**.

The repository includes the original diagnostics and a guarded `Repair.ps1` helper.

Supported actions:

- `Diagnose`
- `ResetOfficeCache`
- `RepairOffice`

```powershell
.\Repair.ps1 -Action Diagnose
.\Repair.ps1 -Action ResetOfficeCache -WhatIf
.\Repair.ps1 -Action RepairOffice -Confirm
```

Close Microsoft Project before cache repair. Existing cache data is preserved as a timestamped backup. Source-reviewed for PowerShell 5.1; not runtime-tested against every Project or Office build.
