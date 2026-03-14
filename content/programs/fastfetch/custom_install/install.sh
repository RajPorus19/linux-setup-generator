#!/bin/bash
set -e
git clone https://github.com/fastfetch-cli/fastfetch
cd fastfetch
mkdir -p build
cd build
cmake ..
cmake --build .
sudo cmake --install .
