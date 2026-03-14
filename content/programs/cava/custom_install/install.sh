#!/bin/bash
set -e
sudo apt-get install -y libfftw3-dev libasound2-dev libncursesw5-dev libpulse-dev libtool
git clone https://github.com/karlstav/cava
cd cava
./autogen.sh
./configure
make
sudo make install
