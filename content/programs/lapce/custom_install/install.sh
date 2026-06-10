#!/bin/bash
set -e
echo "Installing Lapce..."
if command -v cargo &>/dev/null && command -v cargo-binstall &>/dev/null; then
    cargo binstall lapce -y
elif command -v flatpak &>/dev/null; then
    flatpak install -y flathub dev.lapce.lapce
else
    echo "Install cargo-binstall or flatpak first."
    exit 1
fi
