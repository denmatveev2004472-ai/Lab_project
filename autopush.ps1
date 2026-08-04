# autopush.ps1 — run from project folder, keep window open
Set-Location $PWD
$folder = (Get-Location).Path
Write-Host "Watching: $folder"
Write-Host "Press Ctrl+C to stop."

while ($true) {
    Start-Sleep -Seconds 5
    $status = & git -C $folder status --porcelain 2>$null
    if ($status) {
        & git -C $folder add -A
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        & git -C $folder commit -m "auto: $timestamp"
        & git -C $folder push origin main
        Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Pushed changes"
    }
}
