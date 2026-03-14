#!/bin/bash
set -e
curl -fSL "https://www.dropbox.com/download?plat=lnx.x86_64" -o /tmp/dropbox-linux-x86_64.tar.gz
tar -xzf /tmp/dropbox-linux-x86_64.tar.gz -C "$HOME"
rm /tmp/dropbox-linux-x86_64.tar.gz
"$HOME/.dropbox-dist/dropboxd" &
echo "Dropbox daemon started. Complete setup in the browser."
