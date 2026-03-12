# Install clipmenu from source (requires xclip or xsel and dmenu)
git clone https://github.com/cdown/clipmenu /tmp/clipmenu-build
cd /tmp/clipmenu-build
sudo make install
rm -rf /tmp/clipmenu-build
