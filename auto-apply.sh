#!/bin/bash

set -e

DOTFILES="$HOME/arch-dotfiles"

echo
echo "╭─────────────────────────────╮"
echo "│        FELLA DOTFILES       │"
echo "╰─────────────────────────────╯"
echo

# ─────────────────────────────────────
# Check repository
# ─────────────────────────────────────

if [ ! -d "$DOTFILES" ]; then
    echo "  [ERR ] Dotfiles directory not found:"
    echo "        $DOTFILES"
    exit 1
fi

echo "  [INFO] Using $DOTFILES"
echo

# ─────────────────────────────────────
# Helper
# ─────────────────────────────────────

link_file() {
    local source="$1"
    local target="$2"

    # Already linked correctly
    if [ -L "$target" ] && \
       [ "$(readlink -f "$target")" = "$(readlink -f "$source")" ]; then
        echo "  [ OK  ] $target"
        return
    fi

    # Existing file/directory/symlink
    if [ -e "$target" ] || [ -L "$target" ]; then
        local backup="${target}.backup-$(date +%Y%m%d-%H%M%S)"

        echo "  [BACK ] $target"
        mv "$target" "$backup"
    fi

    mkdir -p "$(dirname "$target")"

    ln -s "$source" "$target"

    echo "  [LINK ] $target"
}

# ─────────────────────────────────────
# ~/.config
# ─────────────────────────────────────

if [ -d "$DOTFILES/config" ]; then

    for source in "$DOTFILES/config"/*/; do
        [ -d "$source" ] || continue

        name="$(basename "$source")"

        link_file \
            "$source" \
            "$HOME/.config/$name"
    done

fi

# ─────────────────────────────────────
# Home files
# ─────────────────────────────────────

if [ -d "$DOTFILES/home" ]; then

    for source in "$DOTFILES/home"/.*; do
        [ -e "$source" ] || continue

        name="$(basename "$source")"

        [ "$name" = "." ] && continue
        [ "$name" = ".." ] && continue

        link_file \
            "$source" \
            "$HOME/$name"
    done

fi

# ─────────────────────────────────────
# Dark mode
# ─────────────────────────────────────

echo

if command -v gsettings >/dev/null 2>&1; then
    echo "  [GTK  ] Setting dark mode..."

    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

    echo "  [ OK  ] GTK dark mode"
else
    echo "  [SKIP ] gsettings not found"
fi

echo
echo "  ──────────────────────────────────"
echo "  Dotfiles applied successfully."
echo "  ──────────────────────────────────"
echo
