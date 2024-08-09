#!/bin/bash
set -e
sudo usermod -aG conda $LOGNAME
conda init zsh > /dev/null
echo "conda activate metric3d" >> ~/.zshrc
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
echo "export PYTHONPATH=${PWD}:\$PYTHONPATH" >> ~/.zshrc
. ~/.zshrc
# Install metric3d dependencies
pip install -r requirements_v2.txt

# Install dev dependencies
pip install -r requirements_dev.txt