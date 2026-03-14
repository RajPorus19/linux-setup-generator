#!/bin/bash
set -e
LATEST_URL=$(curl -s "https://api.github.com/repos/Eugeny/tabby/releases/latest" | grep -o '"browser_download_url": "[^"]*\.deb"' | cut -d'"' -f4 | head -1)
if command -v apt-get &>/dev/null; then
  curl -fSL "$LATEST_URL" -o /tmp/tabby.deb
  sudo dpkg -i /tmp/tabby.deb
  rm /tmp/tabby.deb
else
  echo "Please install Tabby from https://tabby.sh"
  exit 1
fi
