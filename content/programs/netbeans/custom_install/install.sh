#!/bin/bash
set -e
NB_VERSION="21"
curl -fSL "https://downloads.apache.org/netbeans/netbeans/${NB_VERSION}/netbeans-${NB_VERSION}-bin.zip" -o /tmp/netbeans.zip
sudo unzip -q /tmp/netbeans.zip -d /opt
rm /tmp/netbeans.zip
sudo ln -sf /opt/netbeans/bin/netbeans /usr/local/bin/netbeans
echo "NetBeans installed. Run: netbeans"
