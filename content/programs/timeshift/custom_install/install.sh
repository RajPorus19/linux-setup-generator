#!/bin/bash
set -e
git clone https://github.com/linuxmint/timeshift /tmp/timeshift-build
cd /tmp/timeshift-build
make
sudo make install
rm -rf /tmp/timeshift-build
