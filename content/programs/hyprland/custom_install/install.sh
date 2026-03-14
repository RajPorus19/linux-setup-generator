#!/bin/bash
set -e
git clone --recursive https://github.com/hyprwm/Hyprland /tmp/hyprland-build
cd /tmp/hyprland-build
make release
sudo make install
rm -rf /tmp/hyprland-build
