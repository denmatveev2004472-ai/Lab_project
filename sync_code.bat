@echo off
chcp 1251 > nul
echo === Syncing backend ===
robocopy "C:\Users\denma\OneDrive\Рабочий стол\Lab_project\backend" "C:\lab-app\backend" *.py /XO /XF .env

echo === Syncing frontend source ===
robocopy "C:\Users\denma\OneDrive\Рабочий стол\Lab_project\frontend\src" "C:\lab-app\frontend\src" /E

echo === Building frontend ===
cd "C:\lab-app\frontend"
call npm run build

echo === Copying build to backend static ===
xcopy dist\* ..\backend\static\ /E /Y

echo === Done. Review changes before pushing: ===
cd "C:\lab-app"
git status

pause