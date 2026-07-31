@echo off
REM Double-clique ce fichier pour recompiler Wargame Board et mettre a jour
REM l'exe dans dist\ -- pas besoin d'ouvrir PowerShell ni de taper de commande.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0build_and_deploy.ps1"
echo.
pause
