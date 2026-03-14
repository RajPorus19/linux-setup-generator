#!/bin/bash
set -e
git clone https://github.com/clangen/musikcube /tmp/musikcube-build
cd /tmp/musikcube-build
cmake .
make -j$(nproc)
sudo make install
rm -rf /tmp/musikcube-build
