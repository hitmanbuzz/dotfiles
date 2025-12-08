#!/bin/bash

configs=(
    helix
    hypr
    waybar
    alacritty
    root-configs
    tmux
    fastfetch
)

# Stow all configs
stow -d config -t ~/.config "${configs[@]}"
