# TatinWrapper
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)



A command-line interface for the [Tatin](https://tatin.dev) package manager, allowing you to manage APL packages from your terminal.

## Overview

TatinWrapper bridges the gap between Tatin's APL session commands and standard shell environments. Instead of working within the APL session, you can now manage your APL packages directly from your terminal.

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
- **Linux System**: Designed for Linux/Unix environments
- **DyalogScript**: Must be available in your PATH

## Installation

1. Clone or download this repository
2. Make the script executable:
   ```bash
   chmod +x tatin
   ```
3. Optionally, add the script to your PATH for system-wide access:
   ```bash
   sudo cp tatin /usr/local/bin/
   ```

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

TatinWrapper is built using:
- **DyalogScript**: The main executable wrapper
- **⎕SE.Tatin API**: Leverages Dyalog's built-in Tatin functionality
- **Command-line parsing**: Robust argument processing with options support

## Features

- ✅ **Full Tatin API Coverage**: Install, uninstall, list, search, update, and info commands
- ✅ **Flexible Target Directories**: Specify custom installation paths
- ✅ **Short Command Aliases**: Use `i`, `u`, `l`, `s` for common operations
- ✅ **Verbose Mode**: Debug and trace operations with `--verbose`
- ✅ **Package Version Support**: Handle version specifiers (e.g., `APLPage-1.0.0`)
- ✅ **Comprehensive Help**: Built-in help system with examples

## TODO

- [ ] Add support for Windows environments
- [ ] Add support for private registries configuration
- [ ] Create automated tests for all commands
- [ ] Implement parallel package installation
- [ ] Support for package rollback/downgrade
- [ ] Add shell completion scripts (bash/zsh)
- [ ] Create CI/CD integration
- [ ] Supprt aliases

## Notes

- Package names can include version specifiers (e.g., `APLPage-1.0.0`)
- The update command checks for and installs newer versions of all packages
- Use `--verbose` to see detailed operation logs
- The default target directory is `./packages` relative to the current directory
- All operations respect Tatin's registry and dependency resolution

## Contributing

Contributions are welcome! This project is written in Dyalog APL.

## License

This projects license can be found [here](LICENSE.MD)