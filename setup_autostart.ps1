$scriptPath = "C:\Users\denma\autopush.ps1"
Copy-Item ".\autopush.ps1" $scriptPath -Force

$trigger = New-ScheduledTaskTrigger -AtLogOn
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-WindowStyle Hidden -ExecutionPolicy Bypass -File $scriptPath"
Register-ScheduledTask -TaskName "LabProjectAutoPush" -Trigger $trigger -Action $action -RunLevel Highest -Force

Write-Host "Done! Task registered: LabProjectAutoPush"
