#!/bin/bash
# Install Miniconda
curl -fsSL "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh" -o /tmp/miniconda.sh
chmod +x /tmp/miniconda.sh
bash /tmp/miniconda.sh -b -p "$HOME/miniconda3"
rm /tmp/miniconda.sh
"$HOME/miniconda3/bin/conda" init bash
echo "Miniconda installed. Restart your shell or run: source ~/.bashrc"
