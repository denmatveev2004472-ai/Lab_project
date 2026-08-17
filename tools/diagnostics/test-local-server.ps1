$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:8080/")

$html = @"
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Lab_project server test</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      max-width: 720px;
      margin: 80px auto;
      padding: 24px;
      background: #f5f7fb;
      color: #1f2937;
    }
    .card {
      background: white;
      border-radius: 12px;
      padding: 32px;
      box-shadow: 0 4px 20px rgba(0,0,0,.1);
    }
    h1 { color: #166534; }
    code {
      background: #e5e7eb;
      padding: 3px 6px;
      border-radius: 4px;
    }
  </style>
</head>
<body>
  <div class="card">
    <h1>Lab_project server is online</h1>
    <p>This page is served by the Windows PC.</p>
    <p>Project directory: <code>C:\Lab_project</code></p>
    <p>Test time: TEST_TIME</p>
  </div>
</body>
</html>
"@

$html = $html.Replace("TEST_TIME", (Get-Date -Format "yyyy-MM-dd HH:mm:ss"))
$bytes = [System.Text.Encoding]::UTF8.GetBytes($html)

try {
    $listener.Start()
    Write-Host ""
    Write-Host "Local test server is running: http://localhost:8080/" -ForegroundColor Green
    Write-Host "Keep this window open. Stop it later with Ctrl+C." -ForegroundColor Yellow
    Write-Host ""

    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $response = $context.Response
        $response.StatusCode = 200
        $response.ContentType = "text/html; charset=utf-8"
        $response.ContentLength64 = $bytes.Length
        $response.OutputStream.Write($bytes, 0, $bytes.Length)
        $response.OutputStream.Close()
    }
}
finally {
    if ($listener.IsListening) {
        $listener.Stop()
    }
    $listener.Close()
}
