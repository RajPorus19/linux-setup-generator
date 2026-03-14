#!/bin/bash
set -e
if command -v apt-get &>/dev/null; then
  curl -fSL "https://release.gitkraken.com/linux/gitkraken-amd64.deb" -o /tmp/gitkraken.deb
  sudo dpkg -i /tmp/gitkraken.deb
  rm /tmp/gitkraken.deb
elif command -v dnf &>/dev/null || command -v zypper &>/dev/null; then
  curl -fSL "https://release.gitkraken.com/linux/gitkraken-amd64.rpm" -o /tmp/gitkraken.rpm
  if command -v dnf &>/dev/null; then sudo dnf install -y /tmp/gitkraken.rpm; fi
  if command -v zypper &>/dev/null; then sudo zypper install -y /tmp/gitkraken.rpm; fi
  rm /tmp/gitkraken.rpm
else
  echo "Please install GitKraken manually from https://www.gitkraken.com/download"
  exit 1
fi
