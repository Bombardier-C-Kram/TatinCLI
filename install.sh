#!/bin/bash

# TatinCLI Installation Script
# This script downloads and installs TatinCLI with all required components

set -e  # Exit on error

REPO_URL="https://github.com/Bombardier-C-Kram/TatinCLI"
ZIP_URL="https://github.com/Bombardier-C-Kram/TatinCLI/archive/refs/heads/main.zip"
INSTALL_DIR="/usr/local/lib/tatin-cli"
BIN_DIR="/usr/local/bin"
TEMP_DIR=$(mktemp -d)

echo "Installing TatinCLI..."

# Check if running as root for system-wide installation
if [[ $EUID -eq 0 ]]; then
    echo "Installing system-wide to $INSTALL_DIR"
else
    # Install to user directory if not root
    INSTALL_DIR="$HOME/.local/lib/tatin-cli"
    BIN_DIR="$HOME/.local/bin"
    echo "Installing to user directory: $INSTALL_DIR"
    
    # Create user bin directory if it doesn't exist
    mkdir -p "$BIN_DIR"
    
    # Add to PATH if not already there
    if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
        echo "Adding $BIN_DIR to PATH in ~/.bashrc"
        echo "export PATH=\"\$PATH:$BIN_DIR\"" >> ~/.bashrc
        echo "Please run 'source ~/.bashrc' or restart your terminal after installation"
    fi
fi

cleanup() {
    echo "Cleaning up temporary files..."
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

# Check prerequisites
echo "Checking prerequisites..."

if ! command -v dyalogscript &> /dev/null; then
    echo "Error: dyalogscript not found in PATH"
    echo "Please install Dyalog APL and ensure dyalogscript is available"
    exit 1
fi

if ! command -v curl &> /dev/null && ! command -v wget &> /dev/null; then
    echo "Error: Neither curl nor wget found in PATH"
    echo "Please install curl or wget to continue"
    exit 1
fi

if ! command -v unzip &> /dev/null; then
    echo "Error: unzip not found in PATH"
    echo "Please install unzip to continue"
    exit 1
fi

echo "Prerequisites check passed"

# Download the repository
echo "Downloading TatinCLI from $ZIP_URL..."
cd "$TEMP_DIR"

# Download ZIP file using curl or wget
if command -v curl &> /dev/null; then
    curl -L -o tatin-cli.zip "$ZIP_URL"
elif command -v wget &> /dev/null; then
    wget -O tatin-cli.zip "$ZIP_URL"
fi

# Extract the ZIP file
echo "Extracting files..."
unzip -q tatin-cli.zip

# The extracted folder will be named "TatinCLI-main"
SOURCE_DIR="$TEMP_DIR/TatinCLI-main"

# Check if extraction was successful
if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "Error: Failed to extract repository or unexpected directory structure"
    exit 1
fi

# Create installation directory
echo "Creating installation directory: $INSTALL_DIR"
mkdir -p "$INSTALL_DIR"
mkdir -p "$BIN_DIR"

# Copy files to installation directory
echo "Installing files..."
cp -r $SOURCE_DIR/* $INSTALL_DIR/

# Create wrapper script in bin directory
echo "Creating wrapper script..."
cat > "$BIN_DIR/tatin" << EOF
#!/bin/bash
# TatinCLI wrapper script
# Pass the installation directory to tatin
INSTALL_DIR="$INSTALL_DIR/" "$INSTALL_DIR/tatin" "\$@"
EOF

# Make executable
chmod +x "$BIN_DIR/tatin"
chmod +x "$INSTALL_DIR/tatin"

echo "Installation completed successfully!"
echo ""
echo "TatinCLI has been installed to: $INSTALL_DIR"
echo "Executable available at: $BIN_DIR/tatin"
echo ""
echo "Verify installation by running:"
echo "  tatin version"
echo ""

if [[ $EUID -ne 0 ]] && [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    echo "Note: $BIN_DIR has been added to your PATH in ~/.bashrc"
    echo "Please run 'source ~/.bashrc' or restart your terminal to use tatin command"
fi
