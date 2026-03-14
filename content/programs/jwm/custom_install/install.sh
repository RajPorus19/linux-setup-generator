#!/bin/bash
set -e
git clone https://github.com/joewing/jwm /tmp/jwm-build
cd /tmp/jwm-build
./autogen.sh
./configure
make
sudo make install
rm -rf /tmp/jwm-build
