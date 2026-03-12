# Install Miniconda
MINICONDA_INSTALLER="/tmp/miniconda.sh"
curl -fsSL "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh" -o "$MINICONDA_INSTALLER"
chmod +x "$MINICONDA_INSTALLER"
bash "$MINICONDA_INSTALLER" -b -p "$HOME/miniconda3"
rm "$MINICONDA_INSTALLER"
"$HOME/miniconda3/bin/conda" init bash
echo "Miniconda installed. Restart your shell or run: source ~/.bashrc"
