#!/bin/bash
set -e
LATEST_URL="https://dbeaver.io/files/dbeaver-ce-latest-linux.gtk.x86_64.tar.gz"
curl -fSL "$LATEST_URL" -o /tmp/dbeaver.tar.gz
sudo tar -xzf /tmp/dbeaver.tar.gz -C /opt
rm /tmp/dbeaver.tar.gz
sudo ln -sf /opt/dbeaver/dbeaver /usr/local/bin/dbeaver
echo "DBeaver installed. Run: dbeaver"
