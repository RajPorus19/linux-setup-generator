#!/bin/bash
set -e
if command -v apt-get &>/dev/null; then
  curl -fsS https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg | sudo tee /usr/share/keyrings/brave-browser-archive-keyring.gpg > /dev/null
  echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
  sudo apt-get update
  sudo apt-get install -y brave-browser
elif command -v dnf &>/dev/null; then
  sudo dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
  sudo dnf install -y brave-browser
elif command -v zypper &>/dev/null; then
  sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
  sudo zypper addrepo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
  sudo zypper install -y brave-browser
else
  echo "Please install Brave manually from https://brave.com/linux/"
  exit 1
fi
