$ErrorActionPreference = "Continue"

$reportDir = "C:\Lab_project\reports"
New-Item -ItemType Directory -Force -Path $reportDir | Out-Null

$stamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$reportFile = Join-Path $reportDir ("server-check_" + $stamp + ".txt")

function Write-Report {
    param([string]$Text)
    $Text | Tee-Object -FilePath $reportFile -Append
}

Write-Report "=== WINDOWS SERVER READINESS CHECK ==="
Write-Report ("Time: " + (Get-Date -Format "yyyy-MM-dd HH:mm:ss"))
Write-Report ""

Write-Report "=== SYSTEM ==="
$os = Get-CimInstance Win32_OperatingSystem
$computer = Get-CimInstance Win32_ComputerSystem
$freeC = [math]::Round((Get-PSDrive C).Free / 1GB, 2)
$ramGb = [math]::Round($computer.TotalPhysicalMemory / 1GB, 2)

Write-Report ("Computer: " + $env:COMPUTERNAME)
Write-Report ("Windows: " + $os.Caption)
Write-Report ("Windows version: " + $os.Version)
Write-Report ("RAM GB: " + $ramGb)
Write-Report ("Logical processors: " + $computer.NumberOfLogicalProcessors)
Write-Report ("Free space on C GB: " + $freeC)
Write-Report ""

Write-Report "=== LOCAL NETWORK ==="
Get-NetIPConfiguration | ForEach-Object {
    if ($_.IPv4Address) {
        Write-Report ("Adapter: " + $_.InterfaceAlias)
        Write-Report ("Local IPv4: " + $_.IPv4Address.IPAddress)
        Write-Report ("Gateway: " + $_.IPv4DefaultGateway.NextHop)
        Write-Report ("DNS: " + ($_.DNSServer.ServerAddresses -join ", "))
        Write-Report ""
    }
}

Write-Report "=== EXTERNAL IP ==="
try {
    $externalIP = (Invoke-RestMethod -Uri "https://api.ipify.org?format=json" -TimeoutSec 15).ip
    Write-Report ("External IPv4: " + $externalIP)

    if ($externalIP -match '^(10\.|192\.168\.|172\.(1[6-9]|2[0-9]|3[0-1])\.)') {
        Write-Report "Result: PRIVATE address. Direct public access is not available."
    }
    elseif ($externalIP -match '^100\.(6[4-9]|[7-9][0-9]|1[0-1][0-9]|12[0-7])\.') {
        Write-Report "Result: CGNAT range. No public IPv4."
    }
    else {
        Write-Report "Result: Address looks public."
        Write-Report "Next step: compare this address with WAN IP in the router."
    }
}
catch {
    Write-Report ("External IP lookup failed: " + $_.Exception.Message)
}
Write-Report ""

Write-Report "=== INTERNET TEST ==="
$httpsTest = Test-NetConnection -ComputerName "1.1.1.1" -Port 443 -WarningAction SilentlyContinue
Write-Report ("HTTPS access to 1.1.1.1:443: " + $httpsTest.TcpTestSucceeded)
Write-Report ""

Write-Report "=== NETWORK PROFILE ==="
Get-NetConnectionProfile | ForEach-Object {
    Write-Report ("Adapter: " + $_.InterfaceAlias + "; profile: " + $_.NetworkCategory)
}
Write-Report ""

Write-Report "=== SERVER PORTS ==="
foreach ($port in @(80,443,8000,5432)) {
    $listener = Get-NetTCPConnection -State Listen -LocalPort $port -ErrorAction SilentlyContinue
    if ($listener) {
        Write-Report ("Port " + $port + ": BUSY; PID: " + ($listener.OwningProcess -join ", "))
    }
    else {
        Write-Report ("Port " + $port + ": free")
    }
}
Write-Report ""

Write-Report "=== POWER PLAN ==="
powercfg /GETACTIVESCHEME | ForEach-Object {
    Write-Report $_
}
Write-Report ""

Write-Report "=== INSTALLED COMMANDS ==="
foreach ($commandName in @("docker","python","git","node","npm","psql")) {
    $commandPath = Get-Command $commandName -ErrorAction SilentlyContinue
    if ($commandPath) {
        Write-Report ($commandName + ": found at " + $commandPath.Source)
    }
    else {
        Write-Report ($commandName + ": not found")
    }
}
Write-Report ""

Write-Report "=== PROJECT FOLDERS ==="
Get-ChildItem "C:\Lab_project" -Force | ForEach-Object {
    Write-Report ($_.Mode + "  " + $_.Name)
}

Write-Report ""
Write-Report ("Report file: " + $reportFile)
Write-Host ("DONE. Report file: " + $reportFile) -ForegroundColor Green
