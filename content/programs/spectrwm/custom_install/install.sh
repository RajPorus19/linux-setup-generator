#!/bin/bash
set -e
git clone https://github.com/conformal/spectrwm /tmp/spectrwm-build
cd /tmp/spectrwm-build
make
sudo make install
rm -rf /tmp/spectrwm-build
