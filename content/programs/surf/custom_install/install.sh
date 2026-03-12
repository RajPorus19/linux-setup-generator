# Build surf from source
git clone https://git.suckless.org/surf /tmp/surf-build
cd /tmp/surf-build
make -j$(nproc)
sudo make install
rm -rf /tmp/surf-build
