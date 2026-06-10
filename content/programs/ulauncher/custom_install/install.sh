#!/bin/bash
set -e
echo "Installing Ulauncher..."
LATEST_DEB=$(curl -s https://api.github.com/repos/Ulauncher/Ulauncher/releases/latest 2>/dev/null | grep browser_download_url | grep .deb | head -1 | cut -d '"' -f4)
if [ -n "$LATEST_DEB" ]; then
    curl -L -o /tmp/ulauncher.deb "$LATEST_DEB"
    sudo dpkg -i /tmp/ulauncher.deb 2>/dev/null || sudo apt install -y /tmp/ulauncher.deb
    rm /tmp/ulauncher.deb
else
    echo "Could not download Ulauncher."
    exit 1
fi
