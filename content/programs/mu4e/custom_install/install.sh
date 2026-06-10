#!/bin/bash
set -e
# mu/mu4e — build from source (Arch AUR fallback)
git clone --depth=1 https://github.com/djcb/mu /tmp/mu
cd /tmp/mu
meson setup build && ninja -C build
ninja -C build install
rm -rf /tmp/mu
