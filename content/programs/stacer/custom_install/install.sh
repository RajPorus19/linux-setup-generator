#!/bin/bash
set -e
echo "Installing Stacer..."
LATEST_DEB=$(curl -s https://api.github.com/repos/oguzhaninan/Stacer/releases/latest 2>/dev/null | grep browser_download_url | grep amd64.deb | cut -d '"' -f4)
if [ -n "$LATEST_DEB" ]; then
    curl -L -o /tmp/stacer.deb "$LATEST_DEB"
    sudo apt install -y /tmp/stacer.deb 2>/dev/null || sudo dpkg -i /tmp/stacer.deb
    rm /tmp/stacer.deb
else
    echo "Could not download Stacer. Try AppImage instead."
    exit 1
fi
