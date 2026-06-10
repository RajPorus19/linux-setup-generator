#!/bin/bash
set -e
# Yakuake is available on most distros via package manager
# Alpine: needs KDE frameworks
apk add yakuake 2>/dev/null || {
    echo "Yakuake not in Alpine repos — installing from source"
    apk add extra-cmake-modules qt5-qtbase-dev kconfig-dev karchive-dev
    git clone --depth=1 https://invent.kde.org/system/yakuake /tmp/yakuake
    cd /tmp/yakuake
    cmake -B build -DCMAKE_INSTALL_PREFIX=/usr
    cmake --build build -j$(nproc)
    cmake --install build
    rm -rf /tmp/yakuake
}
