#!/bin/bash
set -e
if command -v apt-get &>/dev/null; then
  sudo sed -i 's/main$/main contrib non-free non-free-firmware/' /etc/apt/sources.list
  sudo apt-get update
  sudo apt-get install -y steam-installer
else
  echo "Steam is not available for this distribution."
  exit 1
fi
