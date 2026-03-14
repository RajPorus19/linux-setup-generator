#!/bin/bash
set -e
LATEST_URL=$(curl -s "https://api.github.com/repos/vercel/hyper/releases/latest" | grep -o '"browser_download_url": "[^"]*\.deb"' | cut -d'"' -f4 | head -1)
if command -v apt-get &>/dev/null; then
  curl -fSL "$LATEST_URL" -o /tmp/hyper.deb
  sudo dpkg -i /tmp/hyper.deb
  rm /tmp/hyper.deb
else
  echo "Please install Hyper manually from https://hyper.is/#installation"
  exit 1
fi
