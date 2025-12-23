#!/bin/sh
set -e

echo "FreeBSD detected"

### ----------------------------
### Install Dependencies
### ----------------------------

echo "Installing packages..."

doas pkg update
doas pkg install -y \
    hyprland \
    rofi \
    swaync \
    alacritty \
    grim \
    slurp \
    wl-clipboard \
    waybar \
    seatd

### ----------------------------
### Enable seatd
### ----------------------------

doas sysrc seatd_enable="YES"
doas service seatd start

### ----------------------------
### Wallpapers
### ----------------------------

echo "Setting up wallpapers..."
mkdir -p "$HOME/Pictures/wallpapers"
cp wallpapers/current_wallpaper.jpg \
   "$HOME/Pictures/wallpapers/current_wallpaper.jpg"

### ----------------------------
### Backup and Link Configs
### ----------------------------

CONFIGS="hypr rofi swaync kitty"
CONFIG_DIR="$HOME/.config"

echo "Backing up and linking configurations..."

for cfg in $CONFIGS; do
    TARGET="$CONFIG_DIR/$cfg"
    SOURCE="$(pwd)/.config/$cfg"

    if [ -d "$SOURCE" ]; then
        if [ -d "$TARGET" ] || [ -L "$TARGET" ]; then
            echo "Backing up $TARGET → ${TARGET}.bak"
            mv "$TARGET" "${TARGET}.bak"
        fi

        echo "Linking $SOURCE → $TARGET"
        ln -s "$SOURCE" "$TARGET"
    fi
done

### ----------------------------
### Firefox Glass Theme
### ----------------------------

echo "Setting up Firefox Glass Theme..."

FF_DIR="$HOME/.mozilla/firefox"

if [ -d "$FF_DIR" ]; then
    PROFILE_PATH=$(find "$FF_DIR" -maxdepth 1 -type d \
        \( -name "*.default-release" -o -name "*.default" \) | head -n 1)

    if [ -n "$PROFILE_PATH" ]; then
        echo "Found Firefox profile: $PROFILE_PATH"
        mkdir -p "$PROFILE_PATH/chrome"

        for file in userChrome.css userContent.css; do
            TARGET="$PROFILE_PATH/chrome/$file"
            SOURCE="$(pwd)/firefox/chrome/$file"

            if [ -e "$TARGET" ] || [ -L "$TARGET" ]; then
                echo "Backing up $TARGET"
                mv "$TARGET" "$TARGET.bak"
            fi

            ln -s "$SOURCE" "$TARGET"
        done

        TARGET="$PROFILE_PATH/user.js"
        SOURCE="$(pwd)/firefox/user.js"

        if [ -e "$TARGET" ] || [ -L "$TARGET" ]; then
            echo "Backing up user.js"
            mv "$TARGET" "$TARGET.bak"
        fi

        ln -s "$SOURCE" "$TARGET"

        echo "Firefox theme installed."
    else
        echo "No Firefox profile found."
    fi
else
    echo "Firefox not installed. Skipping."
fi

echo "Installation complete."
echo "Log into a TTY and start Hyprland with:"
echo "  exec Hyprland"
