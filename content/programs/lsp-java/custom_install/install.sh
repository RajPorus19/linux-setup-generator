# Download and install Eclipse JDT Language Server
JDTLS_VERSION="1.26.0"
JDTLS_DIR="$HOME/.local/share/jdtls"
mkdir -p "$JDTLS_DIR"
curl -L "https://download.eclipse.org/jdtls/milestones/${JDTLS_VERSION}/jdt-language-server-${JDTLS_VERSION}-$(date +%Y%m%d%H%M).tar.gz" -o /tmp/jdtls.tar.gz 2>/dev/null || \
  curl -L "https://www.eclipse.org/downloads/download.php?file=/jdtls/milestones/${JDTLS_VERSION}/jdt-language-server-latest.tar.gz" -o /tmp/jdtls.tar.gz
tar -xzf /tmp/jdtls.tar.gz -C "$JDTLS_DIR"
rm /tmp/jdtls.tar.gz
echo "Eclipse JDT Language Server installed to $JDTLS_DIR"
