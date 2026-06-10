#!/bin/bash
set -e
echo "Installing Ventoy..."
LATEST=$(curl -s https://api.github.com/repos/ventoy/Ventoy/releases/latest 2>/dev/null | grep tag_name | cut -d '"' -f4)
VERSION=${LATEST:-v1.0.99}
TARBALL="ventoy-${VERSION}-linux.tar.gz"
URL="https://github.com/ventoy/Ventoy/releases/download/${VERSION}/${TARBALL}"

cd /tmp
curl -L -o "$TARBALL" "$URL"
tar xzf "$TARBALL"
echo "Ventoy extracted to /tmp/ventoy-${VERSION}/"
echo "Run: cd /tmp/ventoy-${VERSION} && sudo ./Ventoy2Disk.sh -i /dev/sdX"
