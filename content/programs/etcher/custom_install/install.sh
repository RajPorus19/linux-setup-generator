#!/bin/bash
set -e
echo "Installing balenaEtcher via AppImage..."
LATEST_URL=$(curl -s https://api.github.com/repos/balena-io/etcher/releases/latest 2>/dev/null | grep browser_download_url | grep AppImage | grep x64 | cut -d '"' -f4 | head -1)
if [ -z "$LATEST_URL" ]; then
    echo "Could not find latest AppImage. Install via flatpak: flatpak install flathub io.balena.etcher"
    exit 1
fi
mkdir -p ~/Applications
curl -L -o ~/Applications/balenaEtcher.AppImage "$LATEST_URL"
chmod +x ~/Applications/balenaEtcher.AppImage
echo "balenaEtcher installed to ~/Applications/"
