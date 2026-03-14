#!/bin/bash
set -e
git clone https://github.com/LemonBoy/bar /tmp/lemonbar-build
cd /tmp/lemonbar-build
make
sudo make install
rm -rf /tmp/lemonbar-build
