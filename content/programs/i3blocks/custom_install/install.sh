#!/bin/bash
# Build i3blocks from source on Alpine
apk add --no-cache git make autoconf automake gcc
git clone https://github.com/vivien/i3blocks /tmp/i3blocks-build
cd /tmp/i3blocks-build
autoreconf -fi
./configure
make -j$(nproc)
sudo make install
rm -rf /tmp/i3blocks-build
