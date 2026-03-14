#!/bin/bash
set -e
if command -v apt-get &>/dev/null; then
  curl -fSL "https://discord.com/api/download?platform=linux&format=deb" -o /tmp/discord.deb
  sudo dpkg -i /tmp/discord.deb
  rm /tmp/discord.deb
elif command -v dnf &>/dev/null; then
  curl -fSL "https://discord.com/api/download?platform=linux&format=rpm" -o /tmp/discord.rpm
  sudo dnf install -y /tmp/discord.rpm
  rm /tmp/discord.rpm
elif command -v zypper &>/dev/null; then
  curl -fSL "https://discord.com/api/download?platform=linux&format=rpm" -o /tmp/discord.rpm
  sudo zypper install -y /tmp/discord.rpm
  rm /tmp/discord.rpm
else
  echo "Please download Discord manually from https://discord.com/download"
  exit 1
fi
