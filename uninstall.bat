@echo off
REM TatinCLI Uninstallation Script for Windows

setlocal enabledelayedexpansion

set "SYSTEM_INSTALL_DIR=%PROGRAMFILES%\TatinCLI"
set "USER_INSTALL_DIR=%LOCALAPPDATA%\TatinCLI"

echo TatinCLI Uninstaller
echo ===================

REM Check what's installed
set "FOUND_SYSTEM=0"
set "FOUND_USER=0"

if exist "%SYSTEM_INSTALL_DIR%" (
    set "FOUND_SYSTEM=1"
    echo Found system-wide installation
)

if exist "%USER_INSTALL_DIR%" (
    set "FOUND_USER=1"
    echo Found user installation
)

if %FOUND_SYSTEM% == 0 if %FOUND_USER% == 0 (
    echo No TatinCLI installation found
    pause
    exit /b 0
)

echo.
echo What would you like to uninstall?
echo 1^) System-wide installation ^(requires Administrator^)
echo 2^) User installation
echo 3^) Both
echo 4^) Cancel
echo.
set /p choice="Enter your choice (1-4): "

if "%choice%" == "1" goto uninstall_system
if "%choice%" == "2" goto uninstall_user
if "%choice%" == "3" goto uninstall_both
if "%choice%" == "4" goto cancel
echo Invalid choice
pause
exit /b 1

:uninstall_system
if %FOUND_SYSTEM% == 1 (
    echo Removing system-wide installation...
    rmdir /s /q "%SYSTEM_INSTALL_DIR%" 2>nul
    
    REM Remove from system PATH
    echo Removing from system PATH...
    for /f "tokens=2*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v PATH 2^>nul') do (
        set "SYS_PATH=%%b"
        set "NEW_PATH=!SYS_PATH:%SYSTEM_INSTALL_DIR%;=!"
        set "NEW_PATH=!NEW_PATH:;%SYSTEM_INSTALL_DIR%=!"
        set "NEW_PATH=!NEW_PATH:%SYSTEM_INSTALL_DIR%=!"
        if not "!NEW_PATH!" == "!SYS_PATH!" (
            setx PATH "!NEW_PATH!" /M >nul 2>&1
        )
    )
    echo System-wide installation removed
) else (
    echo No system-wide installation found
)
goto end

:uninstall_user
if %FOUND_USER% == 1 (
    echo Removing user installation...
    rmdir /s /q "%USER_INSTALL_DIR%" 2>nul
    
    REM Remove from user PATH
    echo Removing from user PATH...
    for /f "tokens=2*" %%a in ('reg query "HKCU\Environment" /v PATH 2^>nul') do (
        set "USER_PATH=%%b"
        set "NEW_PATH=!USER_PATH:%USER_INSTALL_DIR%;=!"
        set "NEW_PATH=!NEW_PATH:;%USER_INSTALL_DIR%=!"
        set "NEW_PATH=!NEW_PATH:%USER_INSTALL_DIR%=!"
        if not "!NEW_PATH!" == "!USER_PATH!" (
            setx PATH "!NEW_PATH!" >nul 2>&1
        )
    )
    echo User installation removed
) else (
    echo No user installation found
)
goto end

:uninstall_both
call :uninstall_system
call :uninstall_user
goto end

:cancel
echo Uninstallation cancelled
pause
exit /b 0

:end
echo.
echo TatinCLI has been successfully uninstalled!
echo Please restart your command prompt for PATH changes to take effect.
pause
