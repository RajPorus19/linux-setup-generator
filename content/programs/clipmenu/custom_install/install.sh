#!/bin/bash
# Install clipmenu from source
git clone https://github.com/cdown/clipmenu /tmp/clipmenu-build
cd /tmp/clipmenu-build
sudo make install
rm -rf /tmp/clipmenu-build
