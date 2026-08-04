$folder = $PSScriptRoot

$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $folder
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true

$action = {
    Start-Sleep -Seconds 3
    Set-Location $Event.MessageData
    $status = git status --porcelain
    if ($status) {
        git add -A
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        git commit -m "auto: $timestamp"
        git push origin main
        Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Pushed changes"
    }
}

Register-ObjectEvent $watcher "Changed" -Action $action -MessageData $folder
Register-ObjectEvent $watcher "Created" -Action $action -MessageData $folder
Register-ObjectEvent $watcher "Deleted" -Action $action -MessageData $folder
Register-ObjectEvent $watcher "Renamed" -Action $action -MessageData $folder

Write-Host "Watching: $folder"
while ($true) { Start-Sleep -Seconds 1 }
