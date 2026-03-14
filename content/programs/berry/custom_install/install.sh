#!/bin/bash
set -e
git clone https://github.com/JLErvin/berry /tmp/berry-build
cd /tmp/berry-build
make
sudo make install
rm -rf /tmp/berry-build
