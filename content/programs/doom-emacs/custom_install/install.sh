#!/bin/bash
# Install Doom Emacs
if [ -d "$HOME/.config/emacs" ]; then
  echo "~/.config/emacs already exists, skipping Doom Emacs install"
else
  git clone --depth 1 https://github.com/doomemacs/doomemacs "$HOME/.config/emacs"
  "$HOME/.config/emacs/bin/doom" install --no-config --no-env --no-fonts
fi
