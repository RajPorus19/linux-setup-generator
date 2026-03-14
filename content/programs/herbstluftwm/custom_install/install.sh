#!/bin/bash
set -e
git clone https://github.com/herbstluftwm/herbstluftwm /tmp/hlwm
cd /tmp/hlwm
cmake -DCMAKE_INSTALL_PREFIX=/usr .
make
sudo make install
rm -rf /tmp/hlwm
