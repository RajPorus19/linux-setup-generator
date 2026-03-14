#!/bin/bash
set -e
git clone https://github.com/Alexays/Waybar /tmp/waybar-build
cd /tmp/waybar-build
meson setup build
ninja -C build
sudo ninja -C build install
rm -rf /tmp/waybar-build
