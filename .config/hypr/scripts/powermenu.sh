#!/bin/bash

# Options
shutdown=' Shutdown'
reboot=' Reboot'
lock=' Lock'
suspend=' Suspend'
logout='󰈆 Logout'

# Rofi Command
rofi_command="rofi -dmenu -i -p 'Power Menu' -theme-str 'window {width: 300px;} listview {lines: 5;}'"

# Variable passed to rofi
options="$lock\n$suspend\n$logout\n$reboot\n$shutdown"

chosen=\"$(echo -e "$options" | $rofi_command)"

case $chosen in
    $shutdown)
        systemctl poweroff
        ;;
    $reboot)
        systemctl reboot
        ;;
    $lock)
        # Add your lock screen command here, e.g., hyprlock or swaylock
        if command -v hyprlock &> /dev/null; then
            hyprlock
        elif command -v swaylock &> /dev/null; then
            swaylock
        else
            notify-send "Error" "No lock screen found"
        fi
        ;;
    $suspend)
        systemctl suspend
        ;;
    $logout)
        hyprctl dispatch exit
        ;;
esac
