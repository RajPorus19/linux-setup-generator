LOG_PREFIX="Doom Emacs - installing: "
echo "$LOG_PREFIX Cloning Doom Emacs"
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
echo "$LOG_PREFIX Installing Doom Emacs"
~/.config/emacs/bin/doom install
DOOM_INSTALL_STATUS=$?

if [ $DOOM_INSTALL_STATUS -ne 0 ]; then
    echo "$LOG_PREFIX Failed to install Doom Emacs"
    exit 1
fi

echo "$LOG_PREFIX Doom Emacs installed successfully"