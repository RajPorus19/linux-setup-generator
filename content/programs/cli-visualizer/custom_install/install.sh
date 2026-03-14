#!/bin/bash
set -e
git clone https://github.com/dpayne/cli-visualizer /tmp/cli-vis-build
cd /tmp/cli-vis-build
./install.sh
rm -rf /tmp/cli-vis-build
