#!/bin/bash
DIR="$HOME/Pictures/Screenshots"
NAME="screenshot_$(date +%Y%m%d_%H%M%S).png"

mkdir -p "$DIR"

# Select area with slurp and screenshot with grim
# Save to file AND copy to clipboard
grim -g "$(slurp)" - | tee "$DIR/$NAME" | wl-copy

# Notify user
notify-send "Screenshot taken" "Saved to $DIR/$NAME and copied to clipboard." -i "$DIR/$NAME"
