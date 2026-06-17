#!/usr/bin/bash 
# Download Nerd Font
# 1. Create the local user font directory if it doesn't exist
mkdir -p ~/.local/share/fonts

# 2. Download the ComicShannsMono zip archive from the official Nerd Fonts release
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/ComicShannsMono.zip

# 3. Unzip the fonts directly into your font folder
unzip ComicShannsMono.zip -d ~/.local/share/fonts/ComicShannsMono

# 4. Clean up the downloaded zip file
rm ComicShannsMono.zip

# 5. Clear and regenerate your system's font cache
fc-cache -fv

# Install oh-my-posh prompt
curl -s https://ohmyposh.dev/install.sh | bash -s

