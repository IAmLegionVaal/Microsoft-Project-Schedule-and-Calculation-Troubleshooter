#requires -Version 5.1
<# Created by Dewald Pretorius #>
param([string]$OutputPath)
if(-not $OutputPath){$OutputPath="$([Environment]::GetFolderPath('Desktop'))\Project_Schedule_Reports"};New-Item $OutputPath -ItemType Directory -Force|Out-Null
$proc=Get-Process WINPROJ -ErrorAction SilentlyContinue;$events=Get-WinEvent -FilterHashtable @{LogName='Application';StartTime=(Get-Date).AddDays(-7)} -ErrorAction SilentlyContinue|Where-Object Message -match 'WINPROJ|Microsoft Project|calculation|schedule'|Select-Object -First 50 TimeCreated,Id,ProviderName,Message
@('MICROSOFT PROJECT SCHEDULE AND CALCULATION TROUBLESHOOTER','Created by Dewald Pretorius',"Generated: $(Get-Date)","Running: $([bool]$proc)",'Events:',($events|Format-List|Out-String -Width 220),'Guidance: review calendars, task modes, constraints, dependencies, lag, deadlines, critical path, calculation mode, and baseline comparison.')|Set-Content (Join-Path $OutputPath 'Report.txt') -Encoding UTF8