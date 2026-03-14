#!/bin/bash
# Download and install Eclipse JDT Language Server
JDTLS_DIR="$HOME/.local/share/jdtls"
mkdir -p "$JDTLS_DIR"
LATEST_URL="https://download.eclipse.org/jdtls/milestones/1.38.0/jdt-language-server-1.38.0-202408011337.tar.gz"
curl -L "$LATEST_URL" -o /tmp/jdtls.tar.gz
tar -xzf /tmp/jdtls.tar.gz -C "$JDTLS_DIR"
rm /tmp/jdtls.tar.gz
echo "Eclipse JDT Language Server installed to $JDTLS_DIR"
echo "Configure your editor to use: $JDTLS_DIR/bin/jdtls"
