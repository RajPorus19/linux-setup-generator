#!/bin/bash
set -e
echo "Installing Zoom via Flatpak..."
if command -v flatpak &>/dev/null; then
    flatpak install -y flathub us.zoom.Zoom
else
    echo "Flatpak not found. Install flatpak first."
    exit 1
fi
