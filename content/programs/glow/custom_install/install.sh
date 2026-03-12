# Build glow from source using Go
go install github.com/charmbracelet/glow@latest
sudo mv "$HOME/go/bin/glow" /usr/local/bin/glow 2>/dev/null || true
echo "glow installed. Make sure /usr/local/bin is in your PATH."
