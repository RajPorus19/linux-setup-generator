#!/bin/bash
set -e
echo "Installing Heroic Games Launcher via Flatpak..."
if command -v flatpak &>/dev/null; then
    flatpak install -y flathub com.heroicgameslauncher.hgl
else
    echo "Flatpak not found. Install flatpak first."
    exit 1
fi
