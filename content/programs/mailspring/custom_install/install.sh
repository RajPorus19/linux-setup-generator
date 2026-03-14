#!/bin/bash
set -e
LATEST="https://updates.getmailspring.com/download?platform=linuxDeb"
if command -v apt-get &>/dev/null; then
  curl -fSL "$LATEST" -o /tmp/mailspring.deb
  sudo dpkg -i /tmp/mailspring.deb
  rm /tmp/mailspring.deb
elif command -v dnf &>/dev/null || command -v zypper &>/dev/null; then
  LATEST_RPM="https://updates.getmailspring.com/download?platform=linuxRpm"
  curl -fSL "$LATEST_RPM" -o /tmp/mailspring.rpm
  if command -v dnf &>/dev/null; then sudo dnf install -y /tmp/mailspring.rpm; fi
  if command -v zypper &>/dev/null; then sudo zypper install -y /tmp/mailspring.rpm; fi
  rm /tmp/mailspring.rpm
else
  echo "Please install Mailspring manually from https://getmailspring.com/"
  exit 1
fi
