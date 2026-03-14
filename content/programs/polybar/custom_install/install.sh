#!/bin/bash
set -e
git clone https://github.com/polybar/polybar /tmp/polybar-build
cd /tmp/polybar-build
mkdir build
cd build
cmake ..
make -j$(nproc)
sudo make install
rm -rf /tmp/polybar-build
