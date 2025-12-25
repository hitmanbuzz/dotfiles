#!/bin/bash

CONFIG_DIR="$HOME/.config"

configs=(
    helix
    hypr
    waybar
    kitty
    root-configs
    tmux
    fastfetch
)

# Make symlink for all configs
stow -d config -t "$CONFIG_DIR" "${configs[@]}"
echo "Config Symlink Done"

stow -d config -t "$HOME" bash
echo ".bashrc Symlink Done"

source ~/.bashrc
echo "Sourcing bashrc Done"
