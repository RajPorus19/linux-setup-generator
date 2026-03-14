#!/bin/bash
set -e
if command -v apt-get &>/dev/null; then
  curl -fsSL https://repo.vivaldi.com/archive/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/vivaldi-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/vivaldi-keyring.gpg arch=amd64] https://repo.vivaldi.com/archive/deb/ stable main" | sudo tee /etc/apt/sources.list.d/vivaldi.list
  sudo apt-get update
  sudo apt-get install -y vivaldi-stable
elif command -v dnf &>/dev/null; then
  sudo dnf config-manager addrepo --from-repofile=https://repo.vivaldi.com/archive/vivaldi-fedora.repo
  sudo dnf install -y vivaldi-stable
elif command -v zypper &>/dev/null; then
  sudo rpm --import https://repo.vivaldi.com/archive/linux_signing_key.pub
  sudo zypper addrepo https://repo.vivaldi.com/archive/rpm/ vivaldi
  sudo zypper install -y vivaldi-stable
else
  echo "Vivaldi is not available for this distribution. Download from https://vivaldi.com/download/"
  exit 1
fi
