#!/bin/bash
set -e
echo "Installing OnlyOffice via Flatpak..."
if command -v flatpak &>/dev/null; then
    flatpak install -y flathub org.onlyoffice.desktopeditors
else
    echo "Flatpak not found. Install flatpak first."
    exit 1
fi
