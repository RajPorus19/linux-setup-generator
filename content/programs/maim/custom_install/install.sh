#!/bin/bash
# Build maim from source on Alpine
apk add --no-cache git cmake make g++ libx11-dev libxfixes-dev libxrandr-dev imlib2-dev
git clone https://github.com/naelstrof/maim /tmp/maim-build
mkdir -p /tmp/maim-build/build && cd /tmp/maim-build/build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)
sudo make install
rm -rf /tmp/maim-build
