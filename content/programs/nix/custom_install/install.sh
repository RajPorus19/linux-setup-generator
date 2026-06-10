#!/bin/bash
set -e
echo "Installing Nix package manager..."
curl -L https://nixos.org/nix/install | sh
echo "Nix installed. Restart your shell or run: . ~/.nix-profile/etc/profile.d/nix.sh"
