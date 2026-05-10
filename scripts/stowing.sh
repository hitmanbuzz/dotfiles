#!/bin/bash

CONFIG_DIR="$HOME/.config"

configs=(
    custom_scripts
    wlogout
    helix
    hypr
    alacritty
    waybar
    root-configs
    fontconfig
    tmux
    fastfetch
    rofi
    satty
)

# Make symlink for all configs
stow -d config -t "$CONFIG_DIR" "${configs[@]}"
echo "Config Symlink Done"

# For .bashrc
rm ~/.bashrc
echo "Removed default .bashrc file from home dir"
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
