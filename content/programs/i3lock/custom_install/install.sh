# Build i3lock from source on Alpine
apk add --no-cache git make autoconf automake gcc libx11-dev libxau-dev libxcb-dev xcb-util-image-dev pam-dev
git clone https://github.com/i3/i3lock /tmp/i3lock-build
cd /tmp/i3lock-build
autoreconf -fi
./configure
make -j$(nproc)
sudo make install
rm -rf /tmp/i3lock-build
