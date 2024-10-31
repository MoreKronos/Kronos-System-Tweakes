@echo off
title Kronos Preformance Tweaks

color 4
rem Check for administrative privileges
NET SESSION >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting administrative privileges...
    PowerShell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /B
)
color f
:load
echo ==================================
echo Welcome to Kronos Preformance Tweaks!
echo These Tweaks Are For Preformance Only.
echo ==================================
echo To tweak the system, type "tweak"
echo To revert tweaks, type "untweak"
set /p choice="Type here: "

rem Set the path to the scripts folder relative to the batch file location
set "scriptFolder=%~dp0scripts"
set "tweakScriptPath=%scriptFolder%\tweak.ps1"
set "untweakScriptPath=%scriptFolder%\untweak.ps1"

if /i "%choice%"=="tweak" (
    echo Applying system tweaks...
    powershell -ExecutionPolicy Bypass -File "%tweakScriptPath%"
	timeout /t 7 /nobreak > nul
    goto RestartPrompt
)

if /i "%choice%"=="untweak" (
    echo Reverting system tweaks...
    powershell -ExecutionPolicy Bypass -File "%untweakScriptPath%"
	timeout /t 7 /nobreak > nul
    goto RestartPrompt
)

echo Invalid option.
clear
timeout /t 3 /nobreak > nul
goto load

:RestartPrompt
echo.
set /p restart="Do you want to restart your computer now? (Y/N): "
if /i "%restart%"=="Y" (
    echo Restarting the computer...
    shutdown /r /t 0
) else (
    echo You can restart your computer later to apply the changes.
	timeout /t 3 /nobreak > nul
	exit
)

exit