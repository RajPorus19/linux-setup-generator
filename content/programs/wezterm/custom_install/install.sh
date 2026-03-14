#!/bin/bash
set -e
if command -v apt-get &>/dev/null; then
  curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
  echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
  sudo apt-get update
  sudo apt-get install -y wezterm
else
  echo "Please install WezTerm from https://wezfurlong.org/wezterm/installation.html"
  exit 1
fi
