@ECHO OFF
@setlocal DisableDelayedExpansion
REM --------------BEGINNING OF SCRIPT--------------
REM
REM This part is a version of https://superuser.com/a/852877 (thanks)
REM
REM  --> Check for permissions  
net session>nul 2>&1 
REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (    echo Requesting administrative privileges...    goto UACPrompt) else ( goto gotAdmin )  
:UACPrompt  
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"  
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"  
    "%temp%\getadmin.vbs"  
    exit /B
:gotAdmin
	REM cls
	REM echo Success: Administrative permissions confirmed.
	REM timeout 1
:P_start
set vers=v1.0.0
title HyperVDisableEnable %vers%
cls
for /f "tokens=6 delims=[]. " %%G in ('ver') do set winbuild=%%G
color 07
ECHO:==========================================================
ECHO:
ECHO: HyperVDisableEnable %vers%
ECHO:
ECHO: Windows Build: %winbuild%
ECHO:
ECHO: Status:
ECHO:-----------------------------
%bcdedit /enum | find /I "hypervisorlaunchtype"%
ECHO:-----------------------------
ECHO:
ECHO: 1. Disable
ECHO:
ECHO: 2. Enable
ECHO:
ECHO: 3. Readme
ECHO:
ECHO: 4. Exit
ECHO:
ECHO:===========================================================
ECHO:
choice /C:1234 /N /M ">Select an option with your Keyboard [1,2,3,4] : "
if errorlevel  4 goto:Exitnt
if errorlevel  3 goto:Readme
if errorlevel  2 goto:Enable
if errorlevel  1 goto:Disable
pause

:Exitnt
exit /b

:Exit
echo:
echo Press any key to close
pause >nul
exit /b

:Enable
cls
echo Enabling HyperV...
echo:
echo:
Bcdedit /set hypervisorlaunchtype auto
color 0A
ECHO:
echo:
echo:
ECHO:-----------------------------
bcdedit /enum | find /I "hypervisorlaunchtype"
ECHO:-----------------------------
echo:
echo:
goto Restart

:Disable
cls
echo Disabling HyperV...
echo:
echo:
Bcdedit /set hypervisorlaunchtype off
color 0A
ECHO:
echo:
echo:
ECHO:-----------------------------
bcdedit /enum | find /I "hypervisorlaunchtype"
ECHO:-----------------------------
echo:
echo:
goto Restart

:Readme
cls
ECHO:==========================================================
ECHO:
ECHO: HyperVDisableEnable %vers%
ECHO:
ECHO: Made by Bluewave2
ECHO:
ECHO: https://github.com/Bluewave2/HyperV-Disable-Enable
ECHO:----------------------------------------------------------
ECHO:                 -- Licenced GNU GPLv3 --
ECHO:
ECHO: A script made for easily disabling and enabling Hyper-V
ECHO: for usage of virtualization products without uninstalling
ECHO: features in Windows 10.
ECHO: Feel free to contribute on the Github page.
ECHO:
ECHO: 1. Open GitHub repository [link]
ECHO:
ECHO: 4. Main Menu
ECHO:
ECHO:===========================================================
ECHO:
choice /C:14 /N /M ">Select an option with your Keyboard [1,4] : "
if errorlevel  2 goto:P_start
if errorlevel  1 goto:OpenGitHub

:OpenGitHub
start "" https://github.com/Bluewave2/HyperV-Disable-Enable

:Restart
ECHO Operation complete, restart required to finish.
ECHO:
    set /p Input=Type y to confirm: 
    if %Input% == y (
        cls
        ECHO Restart initiated, Restarting in 10 seconds
        timeout 10
        shutdown /r /t 2 /soft /c "HyperVDisableEnable restart procedure"
        echo: Restarting in progress...
        echo:
        echo: Press any key to quickly abort.
        pause >nul
    )
    else (
        cls
        shutdown /a
        echo: You chose not to restart now. Restart later to apply changes.
		echo:
		echo: Thank you for using this script, have a nice day :)
        timeout 7
        goto:P_start
    )
REM --------------END OF SCRIPT--------------