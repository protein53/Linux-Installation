#!/usr/bin/bash 
# 1. Establish the user-space font repository directory
mkdir -p ~/.local/share/fonts/CodeNewRoman

# 2. Fetch the CodeNewRoman asset payload from the official upstream pipeline
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CodeNewRoman.zip

# 3. Extract the comprehensive true-type payloads directly into the font tree
unzip CodeNewRoman.zip -d ~/.local/share/fonts/CodeNewRoman

# 4. Strip the raw compressed archive wrapper away
rm CodeNewRoman.zip

# 5. Force the underlying Fontconfig subsystem to re-index its cache directories
fc-cache -fv

# Install oh-my-posh prompt
curl -s https://ohmyposh.dev/install.sh | bash -s

# 1. Download and execute the rust installer silently with default options (-y)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
cargo install --locked --bin jj jj-cli
curl -fsSL https://ollama.com/install.sh | sh
# herdr is a tmux replacement
curl -fsSL https://herdr.dev/install.sh | sh
herdr plugin install lmilojevicc/herdr-splits.nvim
