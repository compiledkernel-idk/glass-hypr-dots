# Glass Hypr Dots

![Preview](preview.png)

A minimal, glass-morphism themed Hyprland configuration. Designed for a clean, "No Bar" aesthetic where information is on-demand.

## Features
- **Window Manager:** Hyprland
- **Terminal:** Kitty
- **Launcher:** Rofi
- **Status Center:** SwayNC (Glass Theme)
- **Power Menu:** Custom Rofi Script
- **Style:** Glassy, transparent, deep shadows, and bouncy animations.

## Keybindings

| Key Combination | Action |
|-----------------|--------|
| `SUPER` + `Q` | Open Terminal |
| `SUPER` + `E` | Open File Manager |
| `SUPER` + `SPACE` | App Launcher (Rofi) |
| `SUPER` + `N` | Toggle Status Center (SwayNC) |
| `SUPER` + `ESC` | Open Power Menu |
| `PRINT` | Take Screenshot |
| `SUPER` + `C` | Close Active Window |
| `SUPER` + `V` | Toggle Floating Window |
| `SUPER` + `P` | Pseudo Tiling |
| `SUPER` + `J` | Toggle Split |
| `SUPER` + `Arrow Keys` | Move Focus |
| `SUPER` + `0-9` | Switch Workspace |
| `SUPER` + `SHIFT` + `0-9` | Move Window to Workspace |
| `SUPER` + `S` | Toggle Special Workspace |
| `SUPER` + `M` | Exit Hyprland |

## Installation

Clone the repository and run the installation script:

```bash
git clone https://github.com/compiledkernel-idk/glass-hypr-dots.git
cd glass-hypr-dots
./install.sh
```

## Structure
- `.config/hypr`: Hyprland configuration & scripts
- `.config/rofi`: Application launcher theme
- `.config/swaync`: Notification & Status Center configuration
- `wallpapers`: Included wallpapers

## Requirements
- `hyprland`
- `rofi`
- `swaync`
- `kitty`
- `grim`, `slurp`, `wl-clipboard` (for screenshots)
