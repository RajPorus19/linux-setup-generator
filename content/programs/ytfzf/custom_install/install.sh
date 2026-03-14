#!/bin/bash
# Install ytfzf from source
git clone https://github.com/pystardust/ytfzf /tmp/ytfzf-build
cd /tmp/ytfzf-build
sudo make install
rm -rf /tmp/ytfzf-build
