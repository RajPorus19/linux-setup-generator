#!/bin/bash
set -e
echo "Installing Bitwarden..."
if command -v flatpak &>/dev/null; then
    flatpak install -y flathub com.bitwarden.desktop
elif command -v snap &>/dev/null; then
    sudo snap install bitwarden
else
    echo "Install flatpak or snap first."
    exit 1
fi
