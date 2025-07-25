#!/bin/bash

# TatinCLI Uninstallation Script
# This script removes TatinCLI from your system

set -e

SYSTEM_INSTALL_DIR="/usr/local/lib/tatin-cli"
SYSTEM_BIN_DIR="/usr/local/bin"
USER_INSTALL_DIR="$HOME/.local/lib/tatin-cli"
USER_BIN_DIR="$HOME/.local/bin"

echo "TatinCLI Uninstaller"
echo "==================="

# Check what's installed
FOUND_SYSTEM=0
FOUND_USER=0

if [[ -d "$SYSTEM_INSTALL_DIR" ]] || [[ -f "$SYSTEM_BIN_DIR/tatin" ]]; then
    FOUND_SYSTEM=1
    echo "Found system-wide installation"
fi

if [[ -d "$USER_INSTALL_DIR" ]] || [[ -f "$USER_BIN_DIR/tatin" ]]; then
    FOUND_USER=1
    echo "Found user installation"
fi

if [[ $FOUND_SYSTEM -eq 0 ]] && [[ $FOUND_USER -eq 0 ]]; then
    echo "No TatinCLI installation found"
    exit 0
fi

echo ""
echo "What would you like to uninstall?"
echo "1) System-wide installation (requires sudo)"
echo "2) User installation"
echo "3) Both"
echo "4) Cancel"
echo ""
read -p "Enter your choice (1-4): " choice

case $choice in
    1|3)
        if [[ $FOUND_SYSTEM -eq 1 ]]; then
            echo "Removing system-wide installation..."
            sudo rm -rf "$SYSTEM_INSTALL_DIR"
            sudo rm -f "$SYSTEM_BIN_DIR/tatin"
            echo "System-wide installation removed"
        else
            echo "No system-wide installation found"
        fi
        ;&
    2)
        if [[ $choice -eq 2 ]] || [[ $choice -eq 3 ]]; then
            if [[ $FOUND_USER -eq 1 ]]; then
                echo "Removing user installation..."
                rm -rf "$USER_INSTALL_DIR"
                rm -f "$USER_BIN_DIR/tatin"
                echo "User installation removed"
                echo ""
                echo "Note: You may want to manually remove $USER_BIN_DIR from your PATH"
                echo "if it was added during installation and you no longer need it."
            else
                echo "No user installation found"
            fi
        fi
        ;;
    4)
        echo "Uninstallation cancelled"
        exit 0
        ;;
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac

echo ""
echo "TatinCLI has been successfully uninstalled!"
