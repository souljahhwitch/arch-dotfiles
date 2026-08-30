```bash
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
# Link helper
# ─────────────────────────────────────

link_config() {
    local source="$1"
    local target="$2"

    # Already correct
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

echo "  [INFO] Applying ~/.config..."
echo

for source in "$DOTFILES/config"/*; do
    [[ -d "$source" ]] || continue

    name="$(basename "$source")"
    target="$HOME/.config/$name"

    link_config "$source" "$target"
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

        link_config "$source" "$target"
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
    echo "  [SKIP ] gsettings not installed"
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
echo "  Restart your session for all"
echo "  applications to pick up changes."
echo
```

