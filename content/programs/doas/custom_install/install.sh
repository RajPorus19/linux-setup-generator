#!/bin/bash
# Build opendoas from source on openSUSE
zypper install -y git make gcc pam-devel
git clone https://github.com/Duncaen/OpenDoas /tmp/opendoas-build
cd /tmp/opendoas-build
./configure --with-timestamp
make -j$(nproc)
sudo make install
rm -rf /tmp/opendoas-build
