#!/bin/bash
set -e
if command -v apt-get &>/dev/null; then
  curl -fsSL https://updates.signal.org/desktop/apt/keys.asc | sudo gpg --dearmor -o /usr/share/keyrings/signal-desktop-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main" | sudo tee /etc/apt/sources.list.d/signal-xenial.list
  sudo apt-get update
  sudo apt-get install -y signal-desktop
elif command -v dnf &>/dev/null; then
  echo "Signal Desktop is not in Fedora repos. Download from https://signal.org/download/"
  exit 1
else
  echo "Signal Desktop is not available for this distribution. Download from https://signal.org/download/"
  exit 1
fi
