#!/bin/bash
set -e
git clone https://gitlab.com/jallbrit/cbonsai /tmp/cbonsai-build
cd /tmp/cbonsai-build
make
sudo make install
rm -rf /tmp/cbonsai-build
