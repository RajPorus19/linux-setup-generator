#!/bin/bash
set -e
echo "Installing Rust via rustup..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
echo "Rust installed. Restart your shell or run: source ~/.cargo/env"
