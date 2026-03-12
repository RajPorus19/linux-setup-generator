# Install Tmux Plugin Manager
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ -d "$TPM_DIR" ]; then
  echo "tpm already installed at $TPM_DIR"
else
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
  echo "tpm installed. Press prefix + I inside tmux to install plugins."
fi
