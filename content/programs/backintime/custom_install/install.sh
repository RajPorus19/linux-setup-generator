#!/bin/bash
set -e
git clone https://github.com/bit-team/backintime /tmp/backintime-build
cd /tmp/backintime-build
./configure --no-fuse
sudo make install
rm -rf /tmp/backintime-build
