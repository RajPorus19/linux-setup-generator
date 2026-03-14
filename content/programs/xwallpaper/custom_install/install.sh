#!/bin/bash
set -e
git clone https://github.com/stoeckmann/xwallpaper /tmp/xwallpaper-build
cd /tmp/xwallpaper-build
./autogen.sh
./configure
make
sudo make install
rm -rf /tmp/xwallpaper-build
