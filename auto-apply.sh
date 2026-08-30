#!/bin/bash

set -euo pipefail

DOTFILES="$HOME/arch-dotfiles"
BACKUP_DIR="$HOME/.dotfiles-backups/$(date +%Y%m%d-%H%M%S)"

echo
echo "╭─────────────────────────────╮"
echo "│        FELLA DOTFILES       │"
echo "╰─────────────────────────────╯"
echo
so
if [[ ! -d "$DOTFILES" ]]; then
    echo "  [ERR ] Dotfiles directory not found:"
    echo "        $DOTFILES"
    exit 1
fi

if [[ ! -d "$DOTFILES/config" ]]; then
    echo "  [ERR ] config/ directory not found."
    exit 1
fi

echo "  [INFO] Using $DOTFILES"
echo

# ─────────────────────────────────────
# Dependencies
# ─────────────────────────────────────

PACKAGES=(
    hyprland
    waybar
    dunst
    hyprpaper
    hypridle
    hyprlock
    hyprpolkitagent
    xdg-desktop-portal-hyprland

    kitty
    rofi
    fastfetch
    yazi

    wl-clipboard
    cliphist

    pipewire
    pipewire-pulse
    wireplumber

    ttf-cascadia-mono-nerd
    ttf-jetbrains-mono-nerd
)

echo "  [INFO] Installing packages..."
echo

sudo pacman -Syu --needed "${PACKAGES[@]}"

echo
echo "  [ OK  ] Packages installed"
echo

# ─────────────────────────────────────
# Backup
# ─────────────────────────────────────

mkdir -p "$BACKUP_DIR"

backup() {
    local target="$1"

    if [[ -e "$target" || -L "$target" ]]; then
        local relative="${target#$HOME/}"
        local backup="$BACKUP_DIR/$relative"

        mkdir -p "$(dirname "$backup")"

        echo "  [BACK ] $target"
        mv "$target" "$backup"
    fi
}

# ─────────────────────────────────────
# Apply config directories
# ─────────────────────────────────────

echo "  [INFO] Applying ~/.config..."
echo

mkdir -p "$HOME/.config"

for source in "$DOTFILES/config"/*; do
    [[ -d "$source" ]] || continue

    name="$(basename "$source")"
    target="$HOME/.config/$name"

    backup "$target"

    echo "  [COPY ] $name"

    cp -a "$source" "$target"
done

echo
echo "  [ OK  ] ~/.config applied"

# ─────────────────────────────────────
# Apply home files
# ─────────────────────────────────────

echo
echo "  [INFO] Applying home files..."
echo

if [[ -d "$DOTFILES/home" ]]; then
    for source in "$DOTFILES/home"/.[!.]* "$DOTFILES/home"/..?*; do
        [[ -e "$source" || -L "$source" ]] || continue

        name="$(basename "$source")"
        target="$HOME/$name"

        backup "$target"

        echo "  [COPY ] $name"

        cp -a "$source" "$target"
    done
fi

echo
echo "  [ OK  ] Home files applied"

# ─────────────────────────────────────
# GTK dark mode
# ─────────────────────────────────────

echo

if command -v gsettings >/dev/null 2>&1; then
    echo "  [GTK  ] Enabling dark mode..."

    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

    echo "  [ OK  ] GTK dark mode"
else
    echo "  [SKIP ] gsettings not found"
fi

# ─────────────────────────────────────
# Finish
# ─────────────────────────────────────

echo
echo "  ──────────────────────────────────"
echo "  Dotfiles applied successfully."
echo "  ──────────────────────────────────"
echo
echo "  Backups:"
echo "  $BACKUP_DIR"
echo
echo "  Configs were COPIED, not symlinked."
echo "  ──────────────────────────────────"
echo
