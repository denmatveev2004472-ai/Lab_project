@echo off
chcp 65001 >nul
title HimBaza Launcher

set "PROJECT_DIR=%~dp0"
set "BACKEND_DIR=%PROJECT_DIR%backend"
set "FRONTEND_DIR=%PROJECT_DIR%frontend"
set "LAN_IP=192.168.3.56"

echo ============================================
echo   Zapusk HimBaza: backend + frontend
echo ============================================
echo.

if not exist "%BACKEND_DIR%\main.py" (
    echo ERROR: Ne naiden "%BACKEND_DIR%\main.py"
    pause
    exit /b 1
)

if not exist "%BACKEND_DIR%\.venv\Scripts\python.exe" (
    echo ERROR: Ne naiden "%BACKEND_DIR%\.venv\Scripts\python.exe"
    pause
    exit /b 1
)

if not exist "%FRONTEND_DIR%\package.json" (
    echo ERROR: Ne naiden "%FRONTEND_DIR%\package.json"
    pause
    exit /b 1
)

echo Zapusk backend...
start "HimBaza Backend" cmd /k "cd /d ""%BACKEND_DIR%"" && ""%BACKEND_DIR%\.venv\Scripts\python.exe"" -m uvicorn main:app --host 0.0.0.0 --port 8000 --reload"

timeout /t 2 /nobreak >nul

echo Zapusk frontend...
start "HimBaza Frontend" cmd /k "cd /d ""%FRONTEND_DIR%"" && npm.cmd run dev -- --host 0.0.0.0 --port 5173"

timeout /t 3 /nobreak >nul

echo.
echo ============================================
echo   Servera zapushcheny v otdelnyh oknah.
echo.
echo   Na etom PC:
echo     http://127.0.0.1:5173/
echo.
echo   V lokalnoy seti:
echo     http://%LAN_IP%:5173/
echo.
echo   API / Swagger:
echo     http://%LAN_IP%:8000/docs
echo ============================================
echo.
pause