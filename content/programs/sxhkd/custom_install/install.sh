#!/bin/bash
# Build sxhkd from source
git clone https://github.com/baskerville/sxhkd /tmp/sxhkd-build
cd /tmp/sxhkd-build
make -j$(nproc)
sudo make install
rm -rf /tmp/sxhkd-build
