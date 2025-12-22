#!/bin/bash
set -e

# Detect Distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    echo "Cannot detect distribution."
    exit 1
fi

echo "Detected distribution: $DISTRO"

# Install Dependencies
case $DISTRO in
    arch|endeavouros|manjaro)
        sudo pacman -S --noconfirm hyprland rofi swaync kitty grim slurp wl-clipboard
        ;;
    fedora)
        sudo dnf install -y hyprland rofi swaync kitty grim slurp wl-clipboard
        ;;
    debian|ubuntu|pop)
        echo "Note: Hyprland availability on Debian/Ubuntu varies. Installing available tools..."
        sudo apt update
        sudo apt install -y rofi kitty grim slurp wl-clipboard
        # Check if user has hyprland manually installed or via non-standard repo
        if ! command -v hyprland &> /dev/null; then
             echo "Warning: Hyprland not found in standard repos. Please install it manually."
        fi
        ;;
    opensuse-tumbleweed|opensuse-leap)
        sudo zypper install -y hyprland rofi swaync kitty grim slurp wl-clipboard
        ;;
    gentoo)
        echo "Installing dependencies for Gentoo..."
        # Assuming standard repos or overlays are available
        sudo emerge --ask gui-wm/hyprland x11-misc/rofi gui-apps/swaync x11-terms/kitty gui-apps/grim gui-apps/slurp gui-libs/wl-clipboard
        ;;
    *)
        echo "Unsupported distribution for automatic dependency installation."
        echo "Please ensure hyprland, rofi, swaync, kitty, grim, slurp, and wl-clipboard are installed."
        ;;
esac

# Backup and Link Configs
CONFIGS=("hypr" "rofi" "swaync" "kitty")
CONFIG_DIR="$HOME/.config"

echo "Setting up wallpapers..."
mkdir -p "$HOME/Pictures/wallpapers"
cp wallpapers/current_wallpaper.jpg "$HOME/Pictures/wallpapers/current_wallpaper.jpg"

echo "Backing up and linking configurations..."

for cfg in "${CONFIGS[@]}"; do
    TARGET="$CONFIG_DIR/$cfg"
    SOURCE="$(pwd)/.config/$cfg"

    if [ -d "$SOURCE" ]; then
        if [ -d "$TARGET" ] || [ -L "$TARGET" ]; then
            echo "Backing up existing $TARGET to ${TARGET}.bak"
            mv "$TARGET" "${TARGET}.bak"
        fi
        
        echo "Linking $SOURCE to $TARGET"
        ln -s "$SOURCE" "$TARGET"
    fi
done

echo "Installation complete. Please restart Hyprland."
