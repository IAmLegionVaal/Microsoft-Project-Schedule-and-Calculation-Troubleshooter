#requires -Version 5.1
<# Created by Dewald Pretorius. #>
[CmdletBinding(SupportsShouldProcess=$true)]
param([ValidateSet('Diagnose','ResetOfficeCache','RepairOffice')][string]$Action='Diagnose',[string]$OutputPath=(Join-Path ([Environment]::GetFolderPath('Desktop')) 'Project_Schedule_Repair'))
$ErrorActionPreference='Stop';$cachePath="$env:LOCALAPPDATA\Microsoft\Office\16.0\OfficeFileCache"
New-Item -ItemType Directory -Path $OutputPath -Force|Out-Null;$stamp=Get-Date -Format yyyyMMdd_HHmmss;$log=Join-Path $OutputPath "Repair_$stamp.log";function Log($m){$l='{0:u} {1}'-f(Get-Date),$m;Write-Host $l;Add-Content $log $l}
[ordered]@{Action=$Action;ProjectRunning=[bool](Get-Process WINPROJ -ErrorAction SilentlyContinue);CacheExists=(Test-Path $cachePath)}|ConvertTo-Json|Set-Content (Join-Path $OutputPath "PreRepair_$stamp.json")
if($Action -eq 'Diagnose'){Log '[COMPLETE] Snapshot saved.';exit 0}
try{if($Action -eq 'ResetOfficeCache' -and $PSCmdlet.ShouldProcess($cachePath,'Back up and reset Office cache')){if(Get-Process WINPROJ -ErrorAction SilentlyContinue){throw 'Close Microsoft Project before resetting the cache.'};if(Test-Path $cachePath){$backup="$cachePath.backup-$stamp";Move-Item $cachePath $backup -Force;New-Item -ItemType Directory $cachePath -Force|Out-Null;Log "[BACKUP] $backup"}}
elseif($Action -eq 'RepairOffice'){$client=@("$env:ProgramFiles\Common Files\Microsoft Shared\ClickToRun\OfficeC2RClient.exe","${env:ProgramFiles(x86)}\Common Files\Microsoft Shared\ClickToRun\OfficeC2RClient.exe")|Where-Object{Test-Path $_}|Select-Object -First 1;if(-not $client){throw 'Office repair client was not found.'};if($PSCmdlet.ShouldProcess('Microsoft 365 Apps','Run Quick Repair')){$p=Start-Process $client -ArgumentList '/repair user displaylevel=true forceappshutdown=true' -Wait -PassThru;if($p.ExitCode -ne 0){throw "Office repair exited with code $($p.ExitCode)."}}}}catch{Log "[FAILED] $($_.Exception.Message)";exit 5};Log '[COMPLETE] Repair completed.';exit 0
