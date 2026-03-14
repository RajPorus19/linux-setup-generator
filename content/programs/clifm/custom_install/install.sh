#!/bin/bash
set -e
git clone https://github.com/leo-arch/clifm /tmp/clifm-build
cd /tmp/clifm-build
sudo make install
rm -rf /tmp/clifm-build
