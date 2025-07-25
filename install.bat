@echo off
REM TatinCLI Installation Script for Windows
REM This script downloads and installs TatinCLI with all required components

setlocal enabledelayedexpansion

set "REPO_URL=https://github.com/Bombardier-C-Kram/TatinCLI"
set "INSTALL_DIR=%PROGRAMFILES%\TatinCLI"
set "USER_INSTALL_DIR=%LOCALAPPDATA%\TatinCLI"
set "TEMP_DIR=%TEMP%\tatin-install-%RANDOM%"

echo Installing TatinCLI...

REM Check if running as administrator
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Installing system-wide to "%INSTALL_DIR%"
    set "TARGET_DIR=%INSTALL_DIR%"
    set "SYSTEM_INSTALL=1"
) else (
    echo Installing to user directory: "%USER_INSTALL_DIR%"
    set "TARGET_DIR=%USER_INSTALL_DIR%"
    set "SYSTEM_INSTALL=0"
)

REM Check prerequisites
echo Checking prerequisites...

REM Check for Git
where git >nul 2>&1
if %errorLevel% neq 0 (
    echo Error: git not found in PATH
    echo Please install git to continue
    exit /b 1
)

REM Find Dyalog APL installation
set "DYALOG_SCRIPT="
set "DYALOG_VERSION="

REM Check common installation paths for different versions
for /d %%d in ("%PROGRAMFILES%\Dyalog\Dyalog APL-64*") do (
    if exist "%%d\scriptbin\dyalogscript.ps1" (
        set "DYALOG_SCRIPT=%%d\scriptbin\dyalogscript.ps1"
        for /f "tokens=4 delims=\" %%v in ("%%d") do set "DYALOG_VERSION=%%v"
        goto found_dyalog
    )
)

REM Check 32-bit installations
for /d %%d in ("%PROGRAMFILES%\Dyalog\Dyalog APL*") do (
    if exist "%%d\scriptbin\dyalogscript.ps1" (
        set "DYALOG_SCRIPT=%%d\scriptbin\dyalogscript.ps1"
        for /f "tokens=4 delims=\" %%v in ("%%d") do set "DYALOG_VERSION=%%v"
        goto found_dyalog
    )
)

REM Check Program Files (x86)
for /d %%d in ("%PROGRAMFILES(X86)%\Dyalog\Dyalog APL*") do (
    if exist "%%d\scriptbin\dyalogscript.ps1" (
        set "DYALOG_SCRIPT=%%d\scriptbin\dyalogscript.ps1"
        for /f "tokens=4 delims=\" %%v in ("%%d") do set "DYALOG_VERSION=%%v"
        goto found_dyalog
    )
)

echo Error: Dyalog APL installation not found
echo Please install Dyalog APL (version 20.0 or later) and try again
exit /b 1

:found_dyalog
echo Found Dyalog APL: %DYALOG_VERSION%
echo Using script: "%DYALOG_SCRIPT%"

echo Prerequisites check passed

REM Create temporary directory
mkdir "%TEMP_DIR%" 2>nul

REM Download the repository
echo Downloading TatinCLI from %REPO_URL%...
cd /d "%TEMP_DIR%"
git clone --depth 1 "%REPO_URL%" tatin-cli
if %errorLevel% neq 0 (
    echo Error: Failed to clone repository
    rmdir /s /q "%TEMP_DIR%" 2>nul
    exit /b 1
)

REM Create installation directory
echo Creating installation directory: "%TARGET_DIR%"
mkdir "%TARGET_DIR%" 2>nul

REM Copy files to installation directory
echo Installing files...
xcopy "%TEMP_DIR%\tatin-cli\APLSource" "%TARGET_DIR%\APLSource\" /E /I /Y >nul
copy "%TEMP_DIR%\tatin-cli\tatin" "%TARGET_DIR%\" >nul

REM Create batch wrapper script
echo Creating wrapper script...
(
echo @echo off
echo REM TatinCLI Wrapper - Auto-generated
echo cd /d "%TARGET_DIR%"
echo powershell -ExecutionPolicy Bypass -Command "& '%DYALOG_SCRIPT%' .\tatin %%*"
) > "%TARGET_DIR%\tatin.bat"

REM Add to PATH if system install
if %SYSTEM_INSTALL% == 1 (
    echo Adding to system PATH...
    setx PATH "%%PATH%%;%TARGET_DIR%" /M >nul 2>&1
    if %errorLevel% neq 0 (
        echo Warning: Failed to add to system PATH automatically
        echo Please manually add "%TARGET_DIR%" to your system PATH
    )
) else (
    echo Adding to user PATH...
    for /f "tokens=2*" %%a in ('reg query "HKCU\Environment" /v PATH 2^>nul') do set "USER_PATH=%%b"
    if not defined USER_PATH set "USER_PATH="
    
    REM Check if already in PATH
    echo !USER_PATH! | findstr /i "%TARGET_DIR%" >nul
    if %errorLevel% neq 0 (
        if "!USER_PATH!" == "" (
            setx PATH "%TARGET_DIR%" >nul
        ) else (
            setx PATH "!USER_PATH!;%TARGET_DIR%" >nul
        )
        echo Added to user PATH. Please restart your command prompt.
    ) else (
        echo Already in PATH.
    )
)

REM Cleanup
rmdir /s /q "%TEMP_DIR%" 2>nul

echo.
echo Installation completed successfully!
echo.
echo TatinCLI has been installed to: "%TARGET_DIR%"
echo.
echo Verify installation by opening a new command prompt and running:
echo   tatin version
echo.

if %SYSTEM_INSTALL% == 0 (
    echo Note: Please restart your command prompt to use the tatin command
)

pause
