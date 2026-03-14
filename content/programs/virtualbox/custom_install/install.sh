#!/bin/bash
set -e
if command -v apt-get &>/dev/null; then
  curl -fsSL https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --dearmor -o /usr/share/keyrings/oracle-virtualbox-keyring.gpg
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-keyring.gpg] https://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
  sudo apt-get update
  sudo apt-get install -y virtualbox
elif command -v dnf &>/dev/null; then
  sudo dnf config-manager addrepo --from-repofile=https://download.virtualbox.org/virtualbox/rpm/fedora/virtualbox.repo
  sudo dnf install -y VirtualBox
else
  echo "Please install VirtualBox manually from https://www.virtualbox.org/wiki/Linux_Downloads"
  exit 1
fi
