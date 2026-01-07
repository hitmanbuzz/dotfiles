#!/bin/bash

CONFIG_DIR="$HOME/.config"

configs=(
    helix
    hypr
    alacritty
    waybar
    kitty
    root-configs
    fontconfig
    tmux
    fastfetch
    swappy
    satty
)

# Make symlink for all configs
stow -d config -t "$CONFIG_DIR" "${configs[@]}"
echo "Config Symlink Done"

# For .bashrc
stow -d config -t "$HOME" bash
echo ".bashrc Symlink Done"

# For tmux-sessionizer & other tmux script
mkdir -p ~/.local/bin
chmod +x ./config/tmux-scripts/.local/bin/tmux-sessionizer

stow -d config -t "$HOME" tmux-scripts
echo "Tmux Script Symlink Done"

# source .bashrc (update)
source ~/.bashrc
echo "Sourcing bashrc Done"
