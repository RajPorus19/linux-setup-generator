#!/bin/bash
set -e
echo "Installing FSearch via Flatpak..."
if command -v flatpak &>/dev/null; then
    flatpak install -y flathub io.github.cboxdoerfer.FSearch
else
    echo "Flatpak not found. Install flatpak first."
    exit 1
fi
