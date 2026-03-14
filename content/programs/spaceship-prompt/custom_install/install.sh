#!/bin/bash
set -e
npm install -g spaceship-prompt || git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$HOME/.spaceship" && echo 'source "$HOME/.spaceship/spaceship.zsh"' >> ~/.zshrc
