# Build st from source
git clone https://git.suckless.org/st /tmp/st-build
cd /tmp/st-build
make -j$(nproc)
sudo make install
rm -rf /tmp/st-build
