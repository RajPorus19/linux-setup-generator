#!/bin/bash
set -e
# cool-retro-term requires Qt5
# On Void: xbps-install -S qt5-devel qt5-declarative-devel
# On Alpine: apk add qt5-qtbase-dev qt5-qtdeclarative-dev qt5-qtquickcontrols2-dev
git clone --depth=1 https://github.com/Swordfish90/cool-retro-term /tmp/cool-retro-term
cd /tmp/cool-retro-term
qmake
make -j$(nproc)
make install
rm -rf /tmp/cool-retro-term
