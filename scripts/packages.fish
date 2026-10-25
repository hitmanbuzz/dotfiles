#!/usr/bin/env fish

set arch_packages (cat (dirname (realpath (status filename)))/arch_packages.txt)
set aur_packages (cat (dirname (realpath (status filename)))/aur_packages.txt)

# function to set color for a text
function cecho --description 'Colored echo'
    set_color $argv[1]
    echo $argv[2..-1]
    set_color normal
end

# check if a package is installed
function is_installed
    pacman -Qi $argv[1] &>/dev/null; or yay -Qi $argv[1] &>/dev/null 2>&1
    return $status
end

function install_yay --description 'Install the yay AUR helper'
    if command -q yay
        echo (set_color green)"[✓]"(set_color normal)" yay is already installed"
        return 0
    end

    echo (set_color yellow)"[→]"(set_color normal)" Installing yay AUR helper..."

    sudo pacman -S --needed --noconfirm base-devel git; or return 1

    set -l orig_dir $PWD
    cd /tmp
    git clone https://aur.archlinux.org/yay-bin.git; or begin
        cd $orig_dir
        return 1
    end
    cd yay-bin
    makepkg -si --noconfirm; or begin
        cd $orig_dir
        rm -rf /tmp/yay-bin
        return 1
    end
    cd $orig_dir
    rm -rf /tmp/yay-bin

    echo (set_color green)"[✓]"(set_color normal)" yay installed successfully"
end

echo "=== Arch Linux Package Installer ==="
echo ""

set -l new_official 0
set -l new_aur 0

echo (set_color yellow)"[→]"(set_color normal)" Updating package database..."
sudo pacman -Sy

echo ""
echo (set_color blue)"=== Installing Official Repository Packages ==="(set_color normal)
for package in $arch_packages
    string match -qr '\S' -- $package; or continue
    if is_installed $package
        echo (set_color green)"[✓]"(set_color normal)" $package is already installed"
    else
        echo (set_color yellow)"[→]"(set_color normal)" Installing $package..."
        if sudo pacman -S --needed --noconfirm $package
            set new_official (math $new_official + 1)
        end
    end
end

echo ""
echo (set_color blue)"=== Installing yay AUR Helper ==="(set_color normal)
install_yay

echo ""
echo (set_color yellow)"[→]"(set_color normal)" Refreshing shell environment..."
source ~/.config/fish/config.fish

echo ""
echo (set_color blue)"=== Installing AUR Packages ==="(set_color normal)
for package in $aur_packages
    string match -qr '\S' -- $package; or continue
    if is_installed $package
        echo (set_color green)"[✓]"(set_color normal)" $package is already installed"
    else
        echo (set_color yellow)"[→]"(set_color normal)" Installing $package from AUR..."
        if yay -S --noconfirm $package
            set new_aur (math $new_aur + 1)
        end
    end
end

echo ""
echo (set_color green)"✓ Installation complete!"(set_color normal)
echo ""
echo "Installed packages summary:"
echo "  - Official packages: $new_official new (of "(count $arch_packages)" total)"
echo "  - AUR packages:      $new_aur new (of "(count $aur_packages)" total)"
