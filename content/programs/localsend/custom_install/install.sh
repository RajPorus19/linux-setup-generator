#!/bin/bash
set -e
echo "Installing LocalSend via Flatpak..."
if command -v flatpak &>/dev/null; then
    flatpak install -y flathub org.localsend.localsend_app
else
    echo "Flatpak not found. Install flatpak first."
    exit 1
fi
