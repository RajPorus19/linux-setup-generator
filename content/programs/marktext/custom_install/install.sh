#!/bin/bash
set -e
mkdir -p "$HOME/.local/bin"
curl -fSL "https://github.com/marktext/marktext/releases/latest/download/marktext-x86_64.AppImage" -o "$HOME/.local/bin/marktext"
chmod +x "$HOME/.local/bin/marktext"
echo "Marktext installed to $HOME/.local/bin/marktext"
