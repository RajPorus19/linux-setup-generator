#!/bin/bash
# Build glow from source using Go
go install github.com/charmbracelet/glow@latest
sudo cp "$HOME/go/bin/glow" /usr/local/bin/glow
echo "glow installed to /usr/local/bin/glow"
