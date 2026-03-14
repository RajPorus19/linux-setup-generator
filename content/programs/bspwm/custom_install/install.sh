#!/bin/bash
set -e
git clone https://github.com/baskerville/bspwm /tmp/bspwm-build
cd /tmp/bspwm-build
make
sudo make install
rm -rf /tmp/bspwm-build
