#!/bin/bash
set -e
echo "Installing Slack via Snap..."
if command -v snap &>/dev/null; then
    sudo snap install slack --classic
elif command -v flatpak &>/dev/null; then
    flatpak install -y flathub com.slack.Slack
else
    echo "No snap or flatpak found. Install one first."
    exit 1
fi
