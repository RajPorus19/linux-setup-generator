#!/bin/bash
set -e
curl -fSL "https://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/latest/R/eclipse-java-latest-R-linux-gtk-x86_64.tar.gz&r=1" -o /tmp/eclipse.tar.gz
sudo tar -xzf /tmp/eclipse.tar.gz -C /opt
rm /tmp/eclipse.tar.gz
sudo ln -sf /opt/eclipse/eclipse /usr/local/bin/eclipse
echo "Eclipse installed. Run: eclipse"
