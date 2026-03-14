#!/bin/bash
set -e
if command -v apt-get &>/dev/null; then
  curl -fsSL https://deb.opera.com/archive.key | sudo gpg --dearmor -o /usr/share/keyrings/opera-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/opera-archive-keyring.gpg arch=amd64] https://deb.opera.com/opera-stable/ stable non-free" | sudo tee /etc/apt/sources.list.d/opera-stable.list
  sudo apt-get update
  sudo apt-get install -y opera-stable
elif command -v dnf &>/dev/null; then
  sudo rpm --import https://rpm.opera.com/rpmrepo.key
  sudo tee /etc/yum.repos.d/opera.repo << 'REPOEOF'
[opera]
name=Opera packages
type=rpm-md
baseurl=https://rpm.opera.com/rpm
gpgcheck=1
gpgkey=https://rpm.opera.com/rpmrepo.key
enabled=1
REPOEOF
  sudo dnf install -y opera-stable
elif command -v zypper &>/dev/null; then
  sudo rpm --import https://rpm.opera.com/rpmrepo.key
  sudo zypper addrepo https://rpm.opera.com/rpm opera
  sudo zypper install -y opera-stable
else
  echo "Opera is not available for this distribution via package manager. Download from https://www.opera.com/download"
  exit 1
fi
