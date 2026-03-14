#!/bin/bash
set -e
git clone https://github.com/bartobri/no-more-secrets /tmp/nms-build
cd /tmp/nms-build
make
sudo make install
rm -rf /tmp/nms-build
