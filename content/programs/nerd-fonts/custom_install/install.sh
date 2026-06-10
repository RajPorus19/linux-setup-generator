#!/bin/bash
set -e
echo "Installing Nerd Fonts (FiraCode)..."
mkdir -p ~/.local/share/fonts
cd /tmp
FONT="FiraCode"
curl -L -o "${FONT}.zip" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${FONT}.zip"
unzip -o "${FONT}.zip" -d ~/.local/share/fonts/
rm "${FONT}.zip"
fc-cache -fv
echo "FiraCode Nerd Font installed!"
