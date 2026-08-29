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

# ─────────────────────────────────────
# Clone or update repository
# ─────────────────────────────────────

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
# Apply configs
# ─────────────────────────────────────

mkdir -p "$CONFIG"

for source in "$DOTFILES"/*; do

    # Only process directories
    [ -d "$source" ] || continue

    name="$(basename "$source")"
    target="$CONFIG/$name"

    # Ignore Git/internal directories
    [ "$name" = ".git" ] && continue

    # Already correctly linked
    if [ -L "$target" ] && [ "$(readlink -f "$target")" = "$(readlink -f "$source")" ]; then
        echo "  [ OK  ] $name"
        continue
    fi

    # Existing config
    if [ -e "$target" ] || [ -L "$target" ]; then
        backup="$target.backup-$(date +%Y%m%d-%H%M%S)"

        echo "  [BACK ] $name"
        mv "$target" "$backup"
    fi

    ln -s "$source" "$target"

    echo "  [LINK ] $name"
done

echo
echo "  ──────────────────────────────────"
echo "  Dotfiles applied successfully."
echo "  ──────────────────────────────────"
echo
