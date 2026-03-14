#!/bin/bash
set -e
if command -v apt-get &>/dev/null; then
  curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
  sudo apt-get update
  sudo apt-get install -y vagrant
elif command -v dnf &>/dev/null; then
  sudo dnf config-manager addrepo --from-repofile=https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
  sudo dnf install -y vagrant
elif command -v zypper &>/dev/null; then
  sudo rpm --import https://rpm.releases.hashicorp.com/gpg
  sudo zypper addrepo https://rpm.releases.hashicorp.com/SLES/hashicorp.repo
  sudo zypper install -y vagrant
else
  echo "Please install Vagrant manually from https://developer.hashicorp.com/vagrant/install"
  exit 1
fi
