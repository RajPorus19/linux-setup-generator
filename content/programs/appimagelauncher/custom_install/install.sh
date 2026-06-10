#!/bin/bash
set -e
echo "Installing AppImageLauncher..."
LATEST_DEB=$(curl -s https://api.github.com/repos/TheAssassin/AppImageLauncher/releases/latest 2>/dev/null | grep browser_download_url | grep bionic_amd64.deb | cut -d '"' -f4)
if [ -n "$LATEST_DEB" ]; then
    curl -L -o /tmp/appimagelauncher.deb "$LATEST_DEB"
    sudo dpkg -i /tmp/appimagelauncher.deb 2>/dev/null || sudo apt install -y /tmp/appimagelauncher.deb
    rm /tmp/appimagelauncher.deb
else
    echo "Could not download AppImageLauncher."
    exit 1
fi
