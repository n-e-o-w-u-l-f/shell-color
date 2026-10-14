@echo off
setlocal EnableExtensions DisableDelayedExpansion

set "SC_ROOT=%~dp0.."
set "SC_MODULE=%SC_ROOT%\ShellColor\ShellColor.psd1"
set "SC_BUILDER=%SC_ROOT%\cmd\Build-CmdPrompt.ps1"
set "SC_BRIDGE=%SC_ROOT%\cmd\ShellColor.CmdBridge.ps1"

if /I "%~1"=="--autorun" goto autorun
if /I "%~1"=="--refresh" goto refresh

if "%~1"=="" (
    powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%SC_BRIDGE%" -ModulePath "%SC_MODULE%" -Action "--help"
    goto done
)

powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%SC_BRIDGE%" -ModulePath "%SC_MODULE%" -Action "%~1" -Value "%~2"
if errorlevel 1 goto failed
call "%~f0" --refresh
goto done

:autorun
doskey shell-color=call "%~f0" $*
doskey cd=cd /d $* $T call "%~f0" --refresh
doskey chdir=chdir $* $T call "%~f0" --refresh
doskey pushd=pushd $* $T call "%~f0" --refresh
doskey popd=popd $T call "%~f0" --refresh
call "%~f0" --refresh
goto done

:refresh
set "SC_PROMPT="
for /f "usebackq delims=" %%P in (`powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%SC_BUILDER%" -ModulePath "%SC_MODULE%" -Location "%CD%"`) do set "SC_PROMPT=%%P"
if not defined SC_PROMPT goto failed
endlocal & set "PROMPT=%SC_PROMPT%"
exit /b 0

:failed
set "SC_EXIT=%ERRORLEVEL%"
if "%SC_EXIT%"=="0" set "SC_EXIT=1"
endlocal & exit /b %SC_EXIT%

:done
endlocal
exit /b 0
