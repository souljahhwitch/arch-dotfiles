
# bash profile VVVV
# 
# if [[ "$(tty)" == "/dev/tty1" ]]; then
#    exec start-hyprland
# fi
 


#!/bin/bash

set -euo pipefail

DOTFILES="$HOME/arch-dotfiles"
BACKUP_DIR="$HOME/.dotfiles-backups/$(date +%Y%m%d-%H%M%S)"

echo
echo "╭─────────────────────────────╮"
echo "│        FELLA DOTFILES       │"
echo "╰─────────────────────────────╯"
echo

# ─────────────────────────────────────
# Check repository
# ─────────────────────────────────────

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
    hyprpicker
    hyprshot
    hyprpolkitagent
    xdg-desktop-portal-hyprland

    kitty
    rofi
    neovim
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

sudo pacman -S --needed "${PACKAGES[@]}"

echo
echo "  [ OK  ] Package installation complete"
echo

# ─────────────────────────────────────
# Verify packages
# ─────────────────────────────────────

echo "  [INFO] Verifying packages..."
echo

FAILED=0

for package in "${PACKAGES[@]}"; do
    if pacman -Q "$package" >/dev/null 2>&1; then
        echo "  [ OK  ] $package"
    else
        echo "  [ERR ] $package is not installed"
        FAILED=1
    fi
done

if [[ "$FAILED" -ne 0 ]]; then
    echo
    echo "  [ERR ] Package verification failed."
    echo "  [ERR ] Configs will NOT be modified."
    exit 1
fi

echo
echo "  [ OK  ] All packages verified"
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
# Symlink helper
# ─────────────────────────────────────

link_config() {
    local source="$1"
    local target="$2"

    # Already points to the correct source
    if [[ -L "$target" ]] &&
       [[ "$(readlink -f "$target")" == "$(readlink -f "$source")" ]]; then
        echo "  [ OK  ] $target"
        return
    fi

    backup "$target"

    mkdir -p "$(dirname "$target")"

    ln -s "$source" "$target"

    echo "  [LINK ] $target"
}

# ─────────────────────────────────────
# Apply ~/.config
# ─────────────────────────────────────

echo "  [INFO] Applying ~/.config symlinks..."
echo

mkdir -p "$HOME/.config"

for source in "$DOTFILES/config"/*; do
    [[ -d "$source" ]] || continue

    name="$(basename "$source")"
    target="$HOME/.config/$name"

    link_config "$source" "$target"
done

echo
echo "  [ OK  ] ~/.config symlinks applied"

# ─────────────────────────────────────
# Apply home files
# ─────────────────────────────────────

echo
echo "  [INFO] Applying home file symlinks..."
echo

if [[ -d "$DOTFILES/home" ]]; then
    for source in "$DOTFILES/home"/.[!.]* "$DOTFILES/home"/..?*; do
        [[ -e "$source" || -L "$source" ]] || continue

        name="$(basename "$source")"
        target="$HOME/$name"

        link_config "$source" "$target"
    done
fi

echo
echo "  [ OK  ] Home file symlinks applied"

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
echo "  All configs are now symlinked"
echo "  directly to the Git repository."
echo "  ──────────────────────────────────"
echo
