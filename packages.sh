#!/usr/bin/env bash
set -euo pipefail

echo "=== Installing packages ==="

echo ""
echo "--- DNF packages ---"
sudo dnf install -y \
    neovim \
    fastfetch \
    python3-pip \
    ripgrep \
    fd-find \
    gcc gcc-c++ make \
    nodejs \
    python3.12 \
    eza \
    bat \
    fzf \
    zoxide \
    direnv \
    tldr \
    tmux \
    git-delta \
    trash-cli \
    atuin \
    tmate \
    shellcheck \
    util-linux-core \
    cargo

echo ""
echo "--- Starship ---"
if ! command -v starship &>/dev/null; then
    curl -sS https://starship.rs/install.sh | sh
fi

echo ""
echo "--- Lazygit (COPR) ---"
if ! command -v lazygit &>/dev/null; then
    sudo dnf copr enable atim/lazygit -y
    sudo dnf install -y lazygit
fi

echo ""
echo "--- Nerd Font ---"
if ! fc-list | grep -qi "JetBrainsMono Nerd"; then
    mkdir -p ~/.local/share/fonts
    cd ~/.local/share/fonts
    curl -fLO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz
    tar xf JetBrainsMono.tar.xz
    rm JetBrainsMono.tar.xz
    fc-cache -fv
fi

echo ""
echo "--- Python tools ---"
pip install --user pyright ruff debugpy

echo ""
echo "--- Pokemon Color Scripts ---"
if ! command -v pokemon-colorscripts &>/dev/null; then
    git clone https://gitlab.com/phoneybadger/pokemon-colorscripts.git /tmp/pokemon-colorscripts
    cd /tmp/pokemon-colorscripts
    sudo ./install.sh
    cd -
    rm -rf /tmp/pokemon-colorscripts
fi

echo ""
echo "--- Yazi ---"
if ! command -v yazi &>/dev/null; then
    cargo install --locked yazi-build
    yazi-build
fi

echo ""
echo "=== All packages installed! Now run ./install.sh to link configs ==="
