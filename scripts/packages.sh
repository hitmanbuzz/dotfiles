#!/bin/bash


# Official Arch Package
official_packages=(
    # WAYLE (bar)
    "gtk4"
    "gtk4-layer-shell"
    "gtksourceview5"
    "libpulse"
    "fftw"
    "libpipewire"
    "systemd-libs"
    "bluez"
    "bluez-utils"
    "networkmanager"
    "upower"
    "power-profiles-daemon"
    "pipewire"
    "wireplumber"
    "pipewire-pulse"

    # Game
    "steam"
    "lutris"
    "wine"
    "gamemode"
    "lib32-gamemode"

    # FONTS
    "font-manager"
    "ttf-liberation"
    "ttf-jetbrains-mono-nerd"
    "ttf-dejavu"
    "noto-fonts"
    "noto-fonts-cjk"
    "noto-fonts-emoji"
    "inter-font"
    "ttf-font-awesome"
    "ttf-noto-nerd"

    # --- Programming ---
    "cmake"
    "ninja"
    "tmux"
    "helix"

    # LSP
    "python-lsp-server"
    "vscode-html-languageserver"
    "vscode-css-languageserver"
    "typescript-language-server"
    "tailwindcss-language-server"
    "lua-language-server"
    "gopls"
    "clang"
    "nmap"

    # Language
    "luajit"
    "go"
    "gcc"

    # Container
    "docker"
    "docker-compose"

    # DB
    "postgresql"
    "sqlite"
    "dbeaver"
    # --- End ---


    # Hyprland
    "hyprland"
    "hyprpolkitagent"
    # "waybar" # (using wayle instead of waybar)
    "rofi"

    # Notifications
    "swaybg"
    "dunst"

    # Terminal
    "alacritty"

    # Screenshots
    "slurp"
    "satty"
    "grim"
    "wl-clipboard"

    # BTRFS Snapshots (I don't use currently)
    "snapper"
    "snap-pac"

    # Other
    "obs-studio"
    "obsidian"
    "brightnessctl"
    "libreoffice-still"
    "inetutils"
    "kate"
    "bash-completion"
    "qbittorrent"
    "gimp"
    "fzf"
    "fd"
    "gvfs"
    "libmtp"
    "gvfs-mtp"
    "android-udev"
    "btop"
    "gvfs-afc"
    "thunar-volman"
    "tumbler"
    "ffmpegthumbnailer"
    "udisks2"
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
    "stow"
    "vlc"
    "thunar"
    "xdg-user-dirs"
    "man-db"
    "man-pages"
    "gparted"
    "xorg-xhost"
    "xorg-xauth"
    "xdg-desktop-portal-hyprland"
    "xdg-desktop-portal"
    "yt-dlp"
    "libxres"
    "unrar"
)

# AUR packages (requires yay)
aur_packages=(
    # "warp-cli" # optional
    "wlogout"
    "helium-browser-bin"
    "wayle-bin"
    "proton-cachyos-slr"
)

vlc_plugins=(
    "vlc-plugin-ffmpeg"      # Essential for most codecs
    "vlc-plugin-dbus"
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

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

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

install_yay() {
    if command -v yay &>/dev/null; then
        echo -e "${GREEN}[✓]${NC} yay is already installed"
        return 0
    fi

    echo -e "${YELLOW}[→]${NC} Installing yay AUR helper..."
    
    sudo pacman -S --needed --noconfirm base-devel git
    
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
