#!/bin/bash
set -e
echo "Installing Zettlr via Flatpak..."
if command -v flatpak &>/dev/null; then
    flatpak install -y flathub com.zettlr.Zettlr
else
    echo "Flatpak not found. Install flatpak first."
    exit 1
fi
