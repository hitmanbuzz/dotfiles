#!/bin/bash

mkdir ~/Pictures/Screenshot
git config --global core.editor "helix"
git config --global init.defaultBranch main
fc-cache -fv
xdg-user-dirs-update
sudo systemctl enable --now bluetooth NetworkManager upower power-profiles-daemon
systemctl --user enable --now gamemoded
sudo usermod -aG gamemode $USER

export WAYLAND_DISPLAY=wayland-1
export XDG_RUNTIME_DIR=/run/user/$(id -u)
