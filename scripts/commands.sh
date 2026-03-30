#!/bin/bash

git config --global core.editor "helix"
git config --global init.defaultBranch main
fc-cache -fv
xdg-user-dirs-update
systemctl --user enable --now orbit
orbit daemon

export WAYLAND_DISPLAY=wayland-1
export XDG_RUNTIME_DIR=/run/user/$(id -u)
