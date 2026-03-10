#!/bin/bash
# Custom binary installer for Amfora (Gemini terminal browser)
# https://github.com/makeworld-the-better-one/amfora

set -e

LOG_PREFIX="Amfora - install:"
REPO="makeworld-the-better-one/amfora"
INSTALL_DIR="/usr/local/bin"
BINARY_NAME="amfora"

# --- Detect architecture ---

ARCH="$(uname -m)"

case "$ARCH" in
  x86_64)  ARCH="amd64" ;;
  aarch64) ARCH="arm64" ;;
  armv7*)  ARCH="arm7"  ;;
  *)
    echo "$LOG_PREFIX Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

# --- Resolve latest release tag ---

echo "$LOG_PREFIX Fetching latest release from GitHub..."
LATEST_TAG="$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" \
  | grep '"tag_name"' \
  | sed 's/.*"tag_name": *"\([^"]*\)".*/\1/')"

if [ -z "$LATEST_TAG" ]; then
  echo "$LOG_PREFIX Failed to resolve latest release tag."
  exit 1
fi

echo "$LOG_PREFIX Latest release: $LATEST_TAG"

# --- Download ---
# Amfora release assets follow the pattern: amfora_linux_amd64

ASSET_NAME="${BINARY_NAME}_linux_${ARCH}"
DOWNLOAD_URL="https://github.com/${REPO}/releases/download/${LATEST_TAG}/${ASSET_NAME}"

TMP_FILE="$(mktemp)"
echo "$LOG_PREFIX Downloading $DOWNLOAD_URL..."
curl -fsSL "$DOWNLOAD_URL" -o "$TMP_FILE"

# --- Install binary ---

echo "$LOG_PREFIX Installing binary to ${INSTALL_DIR}/${BINARY_NAME}..."
chmod +x "$TMP_FILE"
mv "$TMP_FILE" "${INSTALL_DIR}/${BINARY_NAME}"

echo "$LOG_PREFIX Binary installed: $(command -v "$BINARY_NAME") — $("$BINARY_NAME" --version 2>/dev/null || true)"

# --- Install desktop entry ---

DESKTOP_DIR="$HOME/.local/share/applications"
echo "$LOG_PREFIX Installing desktop entry to $DESKTOP_DIR..."
mkdir -p "$DESKTOP_DIR"
curl -fsSL \
  "https://raw.githubusercontent.com/${REPO}/master/amfora.desktop" \
  -o "$DESKTOP_DIR/amfora.desktop"
if command -v update-desktop-database > /dev/null 2>&1; then
  update-desktop-database "$DESKTOP_DIR"
  echo "$LOG_PREFIX Desktop database updated."
fi

echo "$LOG_PREFIX Done."
