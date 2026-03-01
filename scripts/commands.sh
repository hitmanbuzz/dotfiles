#!/bin/bash

git config --global core.editor "helix"
git config --global init.defaultBranch main
fc-cache -fv
xdg-user-dirs-update
systemctl --user enable --now orbit
orbit daemon
