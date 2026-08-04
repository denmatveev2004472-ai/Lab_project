@echo off
chcp 65001
cd /d "%~dp0"
echo Zapusk servera HimBaza...
C:\Users\denma\AppData\Local\Python\pythoncore-3.14-64\python.exe -m uvicorn main:app --host 0.0.0.0 --port 8000 --reload
pause