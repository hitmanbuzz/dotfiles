#!/bin/bash

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to check if package is installed
is_installed() {
    pacman -Qi "$1" &>/dev/null || yay -Qi "$1" &>/dev/null 2>&1
    return $?
}

# Function to install package if not already installed
install_package() {
    local package=$1
    if is_installed "$package"; then
        echo -e "${GREEN}[✓]${NC} $package is already installed"
    else
        echo -e "${YELLOW}[→]${NC} Installing $package..."
        sudo pacman -S --noconfirm "$package"
    fi
}

# Function to install yay
install_yay() {
    if command -v yay &>/dev/null; then
        echo -e "${GREEN}[✓]${NC} yay is already installed"
        return 0
    fi

    echo -e "${YELLOW}[→]${NC} Installing yay AUR helper..."
    
    # Install prerequisites
    sudo pacman -S --needed --noconfirm base-devel git
    
    # Clone and build yay
    cd /tmp
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin
    makepkg -si --noconfirm
    cd ~
    rm -rf /tmp/yay-bin
    
    echo -e "${GREEN}[✓]${NC} yay installed successfully"
}

echo "=== Arch Linux Package Installer ==="
echo ""

official_packages=(
    # FONTS
    "ttf-jetbrains-mono-nerd"
    "ttf-dejavu"
    "noto-fonts"
    "noto-fonts-cjk"
    "noto-fonts-emoji"

    # LSP
    "vscode-html-languageserver"
    "vscode-css-languageserver"
    "typescript-language-server"

    # Normal Packages
    "hyprpolkitagent"
    "polkit-gnome"
    "polkit-kde-agent"
    "ntfs-3g"
    "gnome-disk-utility"
    "pavucontrol"
    "tree"
    "starship"
    "fastfetch"
    "unzip"
    "git"
    "less"
    "firefox"
    "waybar"
    "stow"
    "tmux"
    "kitty"
    "gcc"
    "helix"
    "vlc"
    "thunar"
)

vlc_plugins=(
    "vlc-plugin-ffmpeg"      # Essential for most codecs
    "vlc-plugin-fluidsynth"
    "vlc-plugin-gme"
    "vlc-plugin-jack"
    "vlc-plugin-svg"
    "vlc-plugin-tag"
    "vlc-plugin-twolame"
    "vlc-plugin-vorbis"
    "vlc-plugin-x264"
    "vlc-plugin-x265"
)

# AUR packages (requires yay)
aur_packages=(
    "warp-cli"
)

# Update package database
echo -e "${YELLOW}[→]${NC} Updating package database..."
sudo pacman -Sy

# Install official packages
echo ""
echo -e "${BLUE}=== Installing Official Repository Packages ===${NC}"
for package in "${official_packages[@]}"; do
    install_package "$package"
done

# Install VLC plugins
echo ""
echo "Installing VLC plugins..."
for plugin in "${vlc_plugins[@]}"; do
    install_package "$plugin"
done

# Install yay
echo ""
echo -e "${BLUE}=== Installing yay AUR Helper ===${NC}"
install_yay

# Refresh shell environment
echo ""
echo -e "${YELLOW}[→]${NC} Refreshing shell environment..."
source ~/.bash_profile

# Install AUR packages
echo ""
echo -e "${BLUE}=== Installing AUR Packages ===${NC}"
for package in "${aur_packages[@]}"; do
    if is_installed "$package"; then
        echo -e "${GREEN}[✓]${NC} $package is already installed"
    else
        echo -e "${YELLOW}[→]${NC} Installing $package from AUR..."
        yay -S --noconfirm "$package"
    fi
done

echo ""
echo -e "${GREEN}✓ Installation complete!${NC}"
echo ""
echo "Installed packages summary:"
echo "  - Official packages: ${#official_packages[@]}"
echo "  - VLC plugins: ${#vlc_plugins[@]}"
echo "  - AUR packages: ${#aur_packages[@]}"
