#!/bin/bash
set -e
mkdir -p "$HOME/.local/bin"
LATEST_URL=$(curl -s "https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest" | grep -o '"browser_download_url": "[^"]*x86_64.AppImage"' | cut -d'"' -f4)
curl -fSL "$LATEST_URL" -o "$HOME/.local/bin/obsidian"
chmod +x "$HOME/.local/bin/obsidian"
echo "Obsidian installed to $HOME/.local/bin/obsidian"
