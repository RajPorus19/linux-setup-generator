#!/bin/bash
set -e
echo "Installing Joplin..."
if command -v flatpak &>/dev/null; then
    flatpak install -y flathub net.cozic.joplin_desktop
elif command -v snap &>/dev/null; then
    sudo snap install joplin-desktop
else
    wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash
fi
