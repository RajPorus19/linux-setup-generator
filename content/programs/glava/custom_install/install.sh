#!/bin/bash
set -e
git clone https://github.com/jarcode-foss/glava /tmp/glava-build
cd /tmp/glava-build
make
sudo make install
rm -rf /tmp/glava-build
