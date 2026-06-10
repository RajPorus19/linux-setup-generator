#!/bin/bash
set -e
echo "Installing CPU-X via Flatpak..."
if command -v flatpak &>/dev/null; then
    flatpak install -y flathub io.github.thetumultuousunicornofdarkness.cpu-x
else
    echo "Install flatpak first."
    exit 1
fi
