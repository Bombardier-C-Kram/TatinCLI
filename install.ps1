# TatinCLI Installation Script for Windows (PowerShell)
# This script downloads and installs TatinCLI with all required components

param(
    [switch]$UserOnly,
    [switch]$Help
)

if ($Help) {
    Write-Host @"
TatinCLI Installation Script

Usage: .\install.ps1 [options]

Options:
  -UserOnly    Install for current user only (doesn't require admin rights)
  -Help        Show this help message

Examples:
  .\install.ps1              # System-wide install (requires admin)
  .\install.ps1 -UserOnly    # User-only install
"@
    exit 0
}

$ErrorActionPreference = "Stop"

$RepoUrl = "https://github.com/Bombardier-C-Kram/TatinCLI"
$ZipUrl = "https://github.com/Bombardier-C-Kram/TatinCLI/archive/refs/heads/main.zip"
$SystemInstallDir = "$env:ProgramFiles\TatinCLI"
$UserInstallDir = "$env:LOCALAPPDATA\TatinCLI"
$TempDir = Join-Path $env:TEMP "tatin-install-$(Get-Random)"

Write-Host "Installing TatinCLI..." -ForegroundColor Green

# Determine installation type
$IsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

if ($UserOnly -or -not $IsAdmin) {
    $TargetDir = $UserInstallDir
    $SystemInstall = $false
    if (-not $UserOnly -and -not $IsAdmin) {
        Write-Host "Not running as administrator, installing for current user only" -ForegroundColor Yellow
    } else {
        Write-Host "Installing for current user: $TargetDir" -ForegroundColor Cyan
    }
} else {
    $TargetDir = $SystemInstallDir
    $SystemInstall = $true
    Write-Host "Installing system-wide: $TargetDir" -ForegroundColor Cyan
}

Write-Host "Checking prerequisites..." -ForegroundColor Yellow

# Find Dyalog APL installation
$DyalogScript = $null
$DyalogVersion = $null

$SearchPaths = @(
    "$env:ProgramFiles\Dyalog\Dyalog APL-64*",
    "$env:ProgramFiles\Dyalog\Dyalog APL*",
    "${env:ProgramFiles(x86)}\Dyalog\Dyalog APL*"
)

foreach ($SearchPath in $SearchPaths) {
    $DyalogDirs = Get-ChildItem -Path $SearchPath -Directory -ErrorAction SilentlyContinue | Sort-Object Name -Descending
    foreach ($Dir in $DyalogDirs) {
        $ScriptPath = Join-Path $Dir.FullName "scriptbin\dyalogscript.ps1"
        if (Test-Path $ScriptPath) {
            $DyalogScript = $ScriptPath
            $DyalogVersion = $Dir.Name
            break
        }
    }
    if ($DyalogScript) { break }
}

if (-not $DyalogScript) {
    Write-Error "Dyalog APL installation not found. Please install Dyalog APL (version 20.0 or later) and try again."
}

Write-Host "Found Dyalog APL: $DyalogVersion" -ForegroundColor Green
Write-Host "Using script: $DyalogScript" -ForegroundColor Green
Write-Host "Prerequisites check passed" -ForegroundColor Green

# Create temporary directory
New-Item -ItemType Directory -Path $TempDir -Force | Out-Null

try {
    # Download the repository ZIP file
    Write-Host "Downloading TatinCLI from $ZipUrl..." -ForegroundColor Yellow
    $ZipFile = Join-Path $TempDir "tatin-cli.zip"
    Invoke-WebRequest -Uri $ZipUrl -OutFile $ZipFile
    
    # Extract the ZIP file
    Write-Host "Extracting files..." -ForegroundColor Yellow
    Expand-Archive -Path $ZipFile -DestinationPath $TempDir -Force
    
    # The extracted folder will be named "TatinCLI-main"
    $SourceDir = Join-Path $TempDir "TatinCLI-main"

    # Create installation directory
    Write-Host "Creating installation directory: $TargetDir" -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null

    # Copy files to installation directory
    Write-Host "Installing files..." -ForegroundColor Yellow
    
    Copy-Item -Path "$SourceDir\*" -Destination "$TargetDir" -Recurse -Force
    # Create PowerShell wrapper script
    Write-Host "Creating wrapper script..." -ForegroundColor Yellow
    $WrapperContent = @"
@echo off
REM TatinCLI Wrapper - Auto-generated
cd /d "$TargetDir"
powershell -ExecutionPolicy Bypass -Command "& '$DyalogScript' .\tatin %*"
"@
    $WrapperContent | Out-File -FilePath "$TargetDir\tatin.bat" -Encoding ASCII

    # Add to PATH
    if ($SystemInstall) {
        Write-Host "Adding to system PATH..." -ForegroundColor Yellow
        $CurrentPath = [Environment]::GetEnvironmentVariable("PATH", "Machine")
        if ($CurrentPath -notlike "*$TargetDir*") {
            [Environment]::SetEnvironmentVariable("PATH", "$CurrentPath;$TargetDir", "Machine")
            Write-Host "Added to system PATH" -ForegroundColor Green
            Write-Host "System PATH now includes: $TargetDir" -ForegroundColor Green
        } else {
            Write-Host "Already in system PATH" -ForegroundColor Green
        }
    } else {
        Write-Host "Adding to user PATH..." -ForegroundColor Yellow
        $CurrentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
        if (-not $CurrentPath) { $CurrentPath = "" }
        
        if ($CurrentPath -notlike "*$TargetDir*") {
            if ($CurrentPath) {
                [Environment]::SetEnvironmentVariable("PATH", "$CurrentPath;$TargetDir", "User")
            } else {
                [Environment]::SetEnvironmentVariable("PATH", $TargetDir, "User")
            }
            Write-Host "Added to user PATH" -ForegroundColor Green
            Write-Host "User PATH now includes: $TargetDir" -ForegroundColor Green
        } else {
            Write-Host "Already in user PATH" -ForegroundColor Green
        }
    }

    # Verify the wrapper script was created
    $BatFile = Join-Path $TargetDir "tatin.bat"
    if (Test-Path $BatFile) {
        Write-Host "Wrapper script created successfully: $BatFile" -ForegroundColor Green
    } else {
        Write-Error "Failed to create wrapper script: $BatFile"
    }

} finally {
    # Cleanup
    Set-Location $env:TEMP
    Remove-Item -Path $TempDir -Recurse -Force -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "Installation completed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "TatinCLI has been installed to: $TargetDir" -ForegroundColor Cyan
Write-Host "Wrapper script location: $TargetDir\tatin.bat" -ForegroundColor Cyan
Write-Host ""
Write-Host "To verify installation:" -ForegroundColor Yellow
Write-Host "  1. Open a NEW command prompt or PowerShell window" -ForegroundColor White
Write-Host "  2. Run: tatin version" -ForegroundColor White
Write-Host ""
Write-Host "If 'tatin' is not recognized:" -ForegroundColor Yellow
Write-Host "  - Make sure you opened a NEW command prompt after installation" -ForegroundColor White
Write-Host "  - Check that $TargetDir is in your PATH" -ForegroundColor White
Write-Host "  - You can run directly: `"$TargetDir\tatin.bat`" version" -ForegroundColor White
Write-Host ""

if (-not $SystemInstall) {
    Write-Host "Note: You installed for current user only. Please restart your command prompt." -ForegroundColor Yellow
} else {
    Write-Host "Note: System-wide installation complete. Please restart your command prompt." -ForegroundColor Yellow
}
