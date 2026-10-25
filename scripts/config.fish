#!/usr/bin/env fish

git config --global core.editor helix
git config --global init.defaultBranch main

fc-cache -fv
xdg-user-dirs-update

sudo systemctl enable --now bluetooth NetworkManager upower power-profiles-daemon
systemctl --user enable --now gamemoded
sudo usermod -aG gamemode $USER

echo ""

read -P "Setup SDDM Theme (y/n): " setup_sddm
switch (string lower -- $setup_sddm)
    case '' y yes
        chmod +x ../config/qylock/sddm.sh
        ../config/qylock/sddm.sh
    case '*'
        echo (set_color yellow)"Skipping SDDM Theme Setup" (set_color normal)
end

echo ""

read -P "Setup Cloudflare Warp (y/n): " setup_warp
switch (string lower -- $setup_warp)
    case '' y yes
        sudo systemctl start warp-svc.service
        sudo systemctl enable --now warp-svc.service
        sudo systemctl status warp-svc.service
        echo "Warp Service Started..."
        warp-cli registration new
        echo "warp-cli registration done"
    case '*'
        echo (set_color yellow)"Skipping Cloudflare Warp Setup" (set_color normal)
end

echo ""
