#!/bin/bash
set -e
git clone https://github.com/xorg62/tty-clock /tmp/tty-clock-build
cd /tmp/tty-clock-build
make
sudo make install
rm -rf /tmp/tty-clock-build
