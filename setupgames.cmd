@echo off
:: Self-elevate to Administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Run the PowerShell script in the same directory
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0SetupGames.ps1"
