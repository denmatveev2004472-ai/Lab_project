# fix-appvue.ps1
$path = Join-Path (Get-Location) "frontend\src\App.vue"

if (-not (Test-Path $path)) {
    Write-Host "File not found: $path" -ForegroundColor Red
    exit 1
}

Write-Host "Target file: $path" -ForegroundColor Magenta

$backup = "$path.bak_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
Copy-Item $path $backup
Write-Host "Backup created: $backup" -ForegroundColor Green

$content = Get-Content -Path $path -Raw -Encoding UTF8
$changesMade = 0

function Apply-Replace {
    param($old, $new, $label)
    if ($script:content.Contains($old)) {
        $script:content = $script:content.Replace($old, $new)
        $script:changesMade++
        Write-Host "OK: $label" -ForegroundColor Cyan
    } else {
        Write-Host "NOT FOUND (skipped): $label" -ForegroundColor Yellow
    }
}

$oldBlock = @'
function toLocalDateTimeStr(dateObj) {
  const y = dateObj.getFullYear()
  const mo = String(dateObj.getMonth() + 1).padStart(2, '0')
  const d = String(dateObj.getDate()).padStart(2, '0')
  const h = String(dateObj.getHours()).padStart(2, '0')
  const mi = String(dateObj.getMinutes()).padStart(2, '0')
  const s = String(dateObj.getSeconds()).padStart(2, '0')
  return `${y}-${mo}-${d}T${h}:${mi}:${s}`
}
'@

$newBlock = @'
function toLocalDateTimeStr(dateObj) {
  const y = dateObj.getFullYear()
  const mo = String(dateObj.getMonth() + 1).padStart(2, '0')
  const d = String(dateObj.getDate()).padStart(2, '0')
  const h = String(dateObj.getHours()).padStart(2, '0')
  const mi = String(dateObj.getMinutes()).padStart(2, '0')
  const s = String(dateObj.getSeconds()).padStart(2, '0')
  return `${y}-${mo}-${d}T${h}:${mi}:${s}`
}

function toLocalDateStr(dateObj) {
  const y = dateObj.getFullYear()
  const mo = String(dateObj.getMonth() + 1).padStart(2, '0')
  const d = String(dateObj.getDate()).padStart(2, '0')
  return `${y}-${mo}-${d}`
}
'@

Apply-Replace -old $oldBlock -new $newBlock -label "Added toLocalDateStr function"

Apply-Replace -old "return d.toISOString().slice(0, 10)" `
              -new "return toLocalDateStr(d)" `
              -label "toDateStr -> toLocalDateStr"

Apply-Replace -old "dates.push(d.toISOString().slice(0, 10))" `
              -new "dates.push(toLocalDateStr(d))" `
              -label "openAdminStatusModal maint dates -> toLocalDateStr"

Apply-Replace -old "const dateStr = start.toISOString().slice(0, 10)" `
              -new "const dateStr = toLocalDateStr(start)" `
              -label "loadAllBookings dateStr -> toLocalDateStr"

Apply-Replace -old "date: start.toISOString().slice(0, 10)," `
              -new "date: toLocalDateStr(start)," `
              -label "loadCellBookings date -> toLocalDateStr"

Apply-Replace -old "duration, comments: ''" `
              -new "duration, startMinutes: start.getHours() * 60 + start.getMinutes(), comments: ''" `
              -label "loadAllBookings added startMinutes"

$oldLine = "Object.assign(bookingForm, { instrId: b.instrId, date: b.date, who: b.who, experiment: b.experiment, startMinutes: 540, duration: b.duration, comments: b.comments || '' })"
$newLine = "Object.assign(bookingForm, { instrId: b.instrId, date: b.date, who: b.who, experiment: b.experiment, startMinutes: b.startMinutes || 540, duration: b.duration, comments: b.comments || '' })"
Apply-Replace -old $oldLine -new $newLine -label "openEditBookingModal use saved startMinutes"

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($path, $content, $utf8NoBom)

Write-Host ""
Write-Host "Done. Changes applied: $changesMade of 7 expected." -ForegroundColor Green
if ($changesMade -lt 7) {
    Write-Host "Some blocks were not found - check manually." -ForegroundColor Yellow
}
Write-Host "Backup saved at: $backup" -ForegroundColor Green