#!/bin/bash
set -e
if command -v apt-get &>/dev/null; then
  curl -fsSL https://typora.io/linux/public-key.asc | sudo gpg --dearmor -o /usr/share/keyrings/typora-keyring.gpg
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/typora-keyring.gpg] https://typora.io/linux ./" | sudo tee /etc/apt/sources.list.d/typora.list
  sudo apt-get update
  sudo apt-get install -y typora
else
  echo "Please install Typora manually from https://typora.io/releases/all"
  exit 1
fi
