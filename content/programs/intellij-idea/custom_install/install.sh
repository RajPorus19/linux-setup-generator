#!/bin/bash
set -e
curl -fSL "https://data.services.jetbrains.com/products/download?platform=linux&code=TBA" -o /tmp/jetbrains-toolbox.tar.gz
mkdir -p /tmp/jetbrains-toolbox
tar -xzf /tmp/jetbrains-toolbox.tar.gz -C /tmp/jetbrains-toolbox --strip-components=1
/tmp/jetbrains-toolbox/jetbrains-toolbox &
echo "JetBrains Toolbox launched. Use it to install IntelliJ IDEA."
rm -rf /tmp/jetbrains-toolbox.tar.gz /tmp/jetbrains-toolbox
