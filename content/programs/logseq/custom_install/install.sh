#!/bin/bash
set -e
mkdir -p "$HOME/.local/bin"
LATEST_URL=$(curl -s "https://api.github.com/repos/logseq/logseq/releases/latest" | grep -o '"browser_download_url": "[^"]*linux-x64-[0-9.]*\.AppImage"' | cut -d'"' -f4 | head -1)
curl -fSL "$LATEST_URL" -o "$HOME/.local/bin/logseq"
chmod +x "$HOME/.local/bin/logseq"
echo "Logseq installed to $HOME/.local/bin/logseq"
