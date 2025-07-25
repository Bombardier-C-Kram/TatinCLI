# TatinCLI
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)



A command-line interface for the [Tatin](https://tatin.dev) package manager, allowing you to manage APL packages from your terminal.

## Overview

TatinCLI bridges the gap between Tatin's APL session commands and standard shell environments. Instead of working within the APL session, you can now manage your APL packages directly from your terminal.

### Before (APL Session):
```apl
]Tatin.InstallPackages APLPage
]Tatin.ListPackages
]Tatin.UnInstallPackages APLPage
```

### After (Terminal):
```bash
tatin install APLPage
tatin list
tatin uninstall APLPage
```

## Prerequisites

- **Dyalog APL**: Version 20.0 or later
- **DyalogScript**: Must be available in your PATH
- **Linux/macOS**: `curl` or `wget`, and `unzip`

## Installation

Use one of the installation methods below:

### Quick Install (Recommended)

#### Linux/macOS
```bash
# Download and run the installation script
curl -sSL https://raw.githubusercontent.com/Bombardier-C-Kram/TatinCLI/main/install.sh | bash
```

#### Windows
```powershell
# Download and run the PowerShell installation script
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Bombardier-C-Kram/TatinCLI/main/install.ps1" -OutFile "install.ps1"
.\install.ps1
```

### Alternative: Clone and Install

If you prefer to clone the repository directly (requires Git), you can do that as well.

### Installation Locations

- **Linux/macOS System-wide**: `/usr/local/lib/tatin-cli/` with symlink in `/usr/local/bin/`
- **Linux/macOS User-only**: `~/.local/lib/tatin-cli/` with symlink in `~/.local/bin/`
- **Windows System-wide**: `C:\Program Files\TatinCLI\` (added to system PATH)
- **Windows User-only**: `%LOCALAPPDATA%\TatinCLI\` (added to user PATH)

### Verify Installation

```bash
tatin version
```

> **Note**: After installation, you may need to restart your terminal or command prompt (Windows) to access the `tatin` command.

## Uninstallation

To remove TatinCLI from your system, navigate to the installation directory and run the uninstall script:

### Linux/macOS
```bash
# For system-wide installation
cd /usr/local/lib/tatin-cli/
sudo ./uninstall.sh

# For user-only installation
cd ~/.local/lib/tatin-cli/
./uninstall.sh
```

### Windows
```powershell
# For system-wide installation
cd "C:\Program Files\TatinCLI"
.\uninstall.bat

# For user-only installation
cd "$env:LOCALAPPDATA\TatinCLI"
.\uninstall.bat
```

> **Note**: On Windows, you may need to run the command prompt as Administrator for system-wide installations.

## Usage

### Basic Commands

| Command | Alias | Description | Example |
|---------|-------|-------------|---------|
| `install` | `i` | Install a package | `tatin install APLPage` |
| `uninstall` | `u` | Uninstall a package | `tatin uninstall APLPage` |
| `list` | `l` | List installed packages | `tatin list` |
| `search` | `s` | Search for packages | `tatin search JSON` |
| `update` | | Update all packages | `tatin update` |
| `info` | | Show package/version info | `tatin info APLPage` |
| `help` | | Show help message | `tatin help` |
| `version` | | Show version info | `tatin version` |

### Options

- `--target <path>`: Specify target directory (default: `./packages`)
- `--verbose`, `-v`: Enable verbose output for debugging
- `--help`, `-h`: Show help information

### Examples

```bash
# Basic package management
tatin install APLPage                    # Install APLPage to ./packages
tatin i JWTAPL --target ./libs          # Install JWTAPL to ./libs directory
tatin list --target ./packages          # List packages in ./packages
tatin uninstall APLPage                 # Remove APLPage

# Search and information
tatin search JSON                       # Search for JSON-related packages
tatin info APLPage                      # Show information about APLPage
tatin info                              # Show Tatin version information

# Maintenance
tatin update --verbose                  # Update all packages with verbose output
```

## Architecture

TatinCLI is built using:
- **DyalogScript**: The main executable wrapper
- **⎕SE.Tatin API**: Leverages Dyalog's built-in Tatin functionality
- **Command-line parsing**: Robust argument processing with options support

## TODO

- [x] Add support for Windows environments
- [ ] Add support for private registries configuration
- [ ] Create automated tests for all commands
- [ ] Implement parallel package installation
- [ ] Support for package rollback/downgrade
- [ ] Add shell completion scripts (bash/zsh)
- [ ] Create CI/CD integration

## Notes

- Package names can include version specifiers (e.g., `APLPage-1.0.0`)
- The update command checks for and installs newer versions of all packages
- Use `--verbose` to see detailed operation logs
- The default target directory is `./packages` relative to the current directory
- All operations respect Tatin's registry and dependency resolution

## Contributing

Contributions are welcome! This project is written in Dyalog APL.

## License

This project's license can be found [here](LICENSE.MD)