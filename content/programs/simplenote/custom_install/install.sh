#!/bin/bash
set -e
mkdir -p "$HOME/.local/bin"
curl -fSL "https://github.com/Automattic/simplenote-electron/releases/latest/download/Simplenote-linux-x86_64.AppImage" -o "$HOME/.local/bin/simplenote"
chmod +x "$HOME/.local/bin/simplenote"
echo "Simplenote installed to $HOME/.local/bin/simplenote"
