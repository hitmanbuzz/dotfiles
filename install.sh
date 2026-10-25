#!/usr/bin/env bash

set -e

echo "=== Arch Linux Ricing ==="
echo ""

if [ "$EUID" -eq 0 ]; then
    echo "Error: Please run this script as a normal user, not as root."
    echo "The script will ask for your sudo password when necessary."
    exit 1
fi

echo "[→] Installing fish shell..."
sudo pacman -S --needed --noconfirm fish

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

FISH_SCRIPT="$SCRIPT_DIR/scripts/setup.fish"

if [ -f "$FISH_SCRIPT" ]; then
    echo ""
    echo "[→] Handing over to Fish installer..."
    echo ""
    
    fish "$FISH_SCRIPT"
    
    if [ "$SHELL" != "$(which fish)" ]; then
        echo ""
        echo "[→] Changing default shell to fish..."
        chsh -s "$(which fish)"
    fi

else
    echo "Error: Could not find $FISH_SCRIPT"
    exit 1
fi

echo ""
