#!/bin/bash

set -e

REPO="https://github.com/souljahhwitch/arch-dotfiles.git"
DOTFILES="$HOME/arch-dotfiles"
CONFIG="$HOME/.config"

echo
echo "╭─────────────────────────────╮"
echo "│        FELLA DOTFILES       │"
echo "╰─────────────────────────────╯"
echo

if [ -d "$DOTFILES/.git" ]; then
    echo "  [GIT ] Updating dotfiles..."
    git -C "$DOTFILES" pull --ff-only
else
    if [ -e "$DOTFILES" ]; then
        echo "  [ERR ] $DOTFILES exists but is not a git repository."
        exit 1
    fi

    echo "  [GIT ] Downloading dotfiles..."
    git clone "$REPO" "$DOTFILES"
fi

echo

# ─────────────────────────────────────
# Helper
# ─────────────────────────────────────

link_file() {
    local source="$1"
    local target="$2"

    # Already the correct symlink
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

        # Ignore . and ..
        [ "$name" = "." ] && continue
        [ "$name" = ".." ] && continue

        link_file \
            "$source" \
            "$HOME/$name"
    done

fi

echo
echo "  ──────────────────────────────────"
echo "  Dotfiles applied successfully."
echo "  ──────────────────────────────────"
echo
