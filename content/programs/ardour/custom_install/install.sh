#!/bin/bash
set -e
git clone https://github.com/Ardour/ardour /tmp/ardour-build
cd /tmp/ardour-build
./waf configure
./waf build
sudo ./waf install
rm -rf /tmp/ardour-build
