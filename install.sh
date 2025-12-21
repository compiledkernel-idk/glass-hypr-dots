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
        sudo pacman -S --noconfirm hyprland rofi waybar swaync kitty grim slurp wl-clipboard
        ;;
    fedora)
        sudo dnf install -y hyprland rofi waybar swaync kitty grim slurp wl-clipboard
        ;;
    debian|ubuntu|pop)
        echo "Note: Hyprland availability on Debian/Ubuntu varies. Installing available tools..."
        sudo apt update
        sudo apt install -y rofi waybar kitty grim slurp wl-clipboard
        # Check if user has hyprland manually installed or via non-standard repo
        if ! command -v hyprland &> /dev/null; then
             echo "Warning: Hyprland not found in standard repos. Please install it manually."
        fi
        ;;
    *)
        echo "Unsupported distribution for automatic dependency installation."
        echo "Please ensure hyprland, rofi, waybar, swaync, kitty, grim, slurp, and wl-clipboard are installed."
        ;;
esac

# Backup and Link Configs
CONFIGS=("hypr" "rofi" "waybar" "swaync" "kitty")
CONFIG_DIR="$HOME/.config"

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
