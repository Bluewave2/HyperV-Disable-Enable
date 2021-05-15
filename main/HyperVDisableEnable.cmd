@ECHO OFF
@setlocal DisableDelayedExpansion
%1 %2
ver|find "5.">nul&& goto :Admin
mshta vbscript:createobject("shell.application").shellexecute("%~s0","goto :Admin","","runas",1)(window.close)&goto :eof
:Admin

goto check_Permissions

:check_Permissions
    echo Administrative permissions required. Detecting permissions...

    net session >nul 2>&1
    if %errorLevel% == 0 (
        cls
::        echo Success: Administrative permissions confirmed.
::        timeout 2
        goto P_start
    ) else (
        cls
        echo Failure: Current permissions inadequate. Please relaunch as Administrator
        pause >nul
    )

:P_start
set vers=v0.1
title HyperVDisableEnable %vers%
cls
for /f "tokens=6 delims=[]. " %%G in ('ver') do set winbuild=%%G
ECHO:==========================================================
ECHO:
ECHO: HyperVDisableEnable %vers%
ECHO:
ECHO: Windows Build: %winbuild%
ECHO:
ECHO: Auto means = ON
ECHO:-----------------------------
bcdedit /enum | find /I "hypervisorlaunchtype"
ECHO:-----------------------------
ECHO:
ECHO:2. Disable
ECHO:
ECHO:3. Enable
ECHO:
ECHO:5. Exit
ECHO:
ECHO:7. Readme
ECHO:
ECHO:===========================================================
ECHO:
choice /C:2357 /N /M ">Select an option with your Keyboard [2,3,5,7] : "
if errorlevel  4 goto:Readme
if errorlevel  3 goto:Exitnt
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
ECHO:-----------------------------
ECHO:
ECHO: A script made for easily disabling and enabling
ECHO: Hyper-V for usage of virtualization products
ECHO: without uninstalling features in Windows 10.
ECHO: Feel free to contribute on the Github page.
ECHO:
ECHO:5. Exit
ECHO:
ECHO:7. Main Menu
ECHO:
ECHO:===========================================================
ECHO:
choice /C:75 /N /M ">Select an option with your Keyboard [2,3,5] : "
if errorlevel  2 goto:Exitnt
if errorlevel  1 goto:P_start

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
        Echo: You chose not to restart now. Restart later to apply changes.
        timeout 7
        goto:P_start
    )
@REM :Restart
@REM ECHO Operation complete, restart required to finish.
@REM ECHO:
@REM     set /p Input=Type y to confirm:
@REM     if %Input% == y (
@REM         cls
@REM         ECHO Restart initiated, you have 10 seconds to abort
@REM         shutdown /r /t 10 /c "HyperVDisableEnable restart procedure"
@REM         set /p Input=Type a to abort:
@REM         if %Input% == a (
@REM             shutdown /a
@REM             ECHO Restart aborted.
@REM             ECHO:
@REM             ECHO You can manually restart your PC to apply the changes.
@REM             ECHO:
@REM             ECHO:
@REM             ECHO This program will now terminate.
@REM             ECHO Thank you for using this program and have a nice day :)
@REM             pause
@REM         )
@REM     )
@REM )