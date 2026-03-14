#!/bin/bash
set -e
TOR_VERSION="13.5.7"
TOR_ARCH="linux-x86_64"
curl -fSL "https://www.torproject.org/dist/torbrowser/${TOR_VERSION}/tor-browser-${TOR_ARCH}-${TOR_VERSION}.tar.xz" -o /tmp/tor-browser.tar.xz
tar -xJf /tmp/tor-browser.tar.xz -C "$HOME"
rm /tmp/tor-browser.tar.xz
echo "Tor Browser installed in $HOME/tor-browser. Run $HOME/tor-browser/start-tor-browser.desktop"
