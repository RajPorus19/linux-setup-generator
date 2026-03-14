#!/bin/bash
set -e
git clone https://github.com/MaartenBaert/ssr /tmp/ssr-build
mkdir -p /tmp/ssr-build/build && cd /tmp/ssr-build/build
cmake .. -DWITH_QT5=TRUE
make -j$(nproc)
sudo make install
rm -rf /tmp/ssr-build
