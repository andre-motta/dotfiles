#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
    local src="$1"
    local dst="$2"
    mkdir -p "$(dirname "$dst")"
    if [ -L "$dst" ]; then
        rm "$dst"
    elif [ -e "$dst" ]; then
        echo "  Backing up $dst → ${dst}.bak"
        mv "$dst" "${dst}.bak"
    fi
    ln -s "$src" "$dst"
    echo "  Linked $dst → $src"
}

echo "=== Installing dotfiles from $DOTFILES ==="

echo ""
echo "--- Bash ---"
link "$DOTFILES/bash/.bashrc" "$HOME/.bashrc"

echo ""
echo "--- Neovim ---"
link "$DOTFILES/nvim/.config/nvim" "$HOME/.config/nvim"

echo ""
echo "--- tmux ---"
link "$DOTFILES/tmux/.config/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"

echo ""
echo "--- Starship ---"
link "$DOTFILES/starship/.config/starship/starship.toml" "$HOME/.config/starship.toml"

echo ""
echo "--- Fastfetch ---"
link "$DOTFILES/fastfetch/.config/fastfetch/config.jsonc" "$HOME/.config/fastfetch/config.jsonc"

echo ""
echo "--- Konsole ---"
link "$DOTFILES/konsole/.local/share/konsole/Pretty.profile" "$HOME/.local/share/konsole/Pretty.profile"
link "$DOTFILES/konsole/.local/share/konsole/Catppuccin-Mocha.colorscheme" "$HOME/.local/share/konsole/Catppuccin-Mocha.colorscheme"

echo ""
echo "--- bat ---"
link "$DOTFILES/bat/.config/bat/config" "$HOME/.config/bat/config"

echo ""
echo "--- lazygit ---"
link "$DOTFILES/lazygit/.config/lazygit/config.yml" "$HOME/.config/lazygit/config.yml"

echo ""
echo "--- atuin ---"
link "$DOTFILES/atuin/.config/atuin/config.toml" "$HOME/.config/atuin/config.toml"

echo ""
echo "--- Git ---"
link "$DOTFILES/git/.gitconfig" "$HOME/.gitconfig"
link "$DOTFILES/git/.gitignore_global" "$HOME/.gitignore_global"

echo ""
echo "=== Done! Open a new terminal to see changes ==="
