#!/bin/bash
set -e
git clone https://git.suckless.org/dwm /tmp/dwm-build
cd /tmp/dwm-build
make
sudo make install
rm -rf /tmp/dwm-build
