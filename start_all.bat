@echo off
chcp 65001 >nul
title HimBaza - Launcher

echo ============================================
echo   Zapusk HimBaza (backend + frontend)
echo ============================================
echo.

start "HimBaza Backend" cmd /k "cd /d ""%~dp0backend"" && call venv\Scripts\activate.bat && uvicorn main:app --host 0.0.0.0 --port 8000 --reload"

timeout /t 2 /nobreak >nul

start "HimBaza Frontend" cmd /k "cd /d ""%~dp0frontend"" && npm run dev -- --host"

timeout /t 3 /nobreak >nul

echo.
echo ============================================
echo   Servera zapushcheny v otdelnyh oknah.
echo.
echo   Na etom PC otkroi:
echo     http://localhost:5173
echo.
echo   Na telefone (ta zhe Wi-Fi set) otkroi:
echo     http://192.168.1.120:5173
echo.
echo   Esli IP izmenilsya, provery yego komandoy: ipconfig
echo ============================================
echo.
pause