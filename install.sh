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

echo "Setting up Firefox Glass Theme..."
FF_DIR="$HOME/.mozilla/firefox"
if [ -d "$FF_DIR" ]; then
    # Find the default profile folder (usually ends in .default-release or .default)
    PROFILE_PATH=$(find "$FF_DIR" -maxdepth 1 -type d -name "*.default-release" | head -n 1)
    if [ -z "$PROFILE_PATH" ]; then
        PROFILE_PATH=$(find "$FF_DIR" -maxdepth 1 -type d -name "*.default" | head -n 1)
    fi

    if [ -n "$PROFILE_PATH" ]; then
        echo "Found Firefox profile: $PROFILE_PATH"
        mkdir -p "$PROFILE_PATH/chrome"
        
        # Link userChrome.css
        if [ -L "$PROFILE_PATH/chrome/userChrome.css" ] || [ -f "$PROFILE_PATH/chrome/userChrome.css" ]; then
             echo "Backing up existing userChrome.css"
             mv "$PROFILE_PATH/chrome/userChrome.css" "$PROFILE_PATH/chrome/userChrome.css.bak"
        fi
        ln -s "$(pwd)/firefox/chrome/userChrome.css" "$PROFILE_PATH/chrome/userChrome.css"

        # Link user.js
        if [ -L "$PROFILE_PATH/user.js" ] || [ -f "$PROFILE_PATH/user.js" ]; then
             echo "Backing up existing user.js"
             mv "$PROFILE_PATH/user.js" "$PROFILE_PATH/user.js.bak"
        fi
        ln -s "$(pwd)/firefox/user.js" "$PROFILE_PATH/user.js"
        
        echo "Firefox theme installed."
    else
        echo "No default Firefox profile found. Skipping theme installation."
    fi
else
    echo "Firefox directory not found. Skipping theme installation."
fi

echo "Installation complete. Please restart Hyprland."
