#!/bin/bash
set -e

# Install build dependencies based on the distro
if command -v apt-get &>/dev/null; then
  sudo apt-get install -y git autoconf automake libtool gcc make \
    libfftw3-dev libasound2-dev libncursesw5-dev libpulse-dev
elif command -v zypper &>/dev/null; then
  sudo zypper install -y git autoconf automake libtool gcc make \
    fftw3-devel alsa-devel ncurses-devel pulseaudio-devel
elif command -v apk &>/dev/null; then
  sudo apk add --no-cache git autoconf automake libtool gcc make \
    fftw-dev alsa-lib-dev ncurses-dev pulseaudio-dev
fi

git clone https://github.com/karlstav/cava /tmp/cava-build
cd /tmp/cava-build
./autogen.sh
./configure
make -j$(nproc)
sudo make install
rm -rf /tmp/cava-build
