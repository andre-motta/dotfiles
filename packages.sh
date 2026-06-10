#!/usr/bin/env bash
set -euo pipefail

OS="$(uname -s)"

echo "=== Installing packages (detected: $OS) ==="

if [[ "$OS" == "Darwin" ]]; then
    if ! command -v brew &>/dev/null; then
        echo "Homebrew not found. Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    echo ""
    echo "--- Brew packages ---"
    brew install \
        neovim \
        fastfetch \
        python@3 \
        ripgrep \
        fd \
        node \
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
        coreutils \
        rust \
        lazygit \
        yazi

    echo ""
    echo "--- Nerd Font ---"
    brew install --cask font-jetbrains-mono-nerd-font

elif [[ "$OS" == "Linux" ]]; then
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
    echo "--- Yazi ---"
    if ! command -v yazi &>/dev/null; then
        cargo install --locked yazi-build
        yazi-build
    fi
else
    echo "Unsupported OS: $OS"
    exit 1
fi

echo ""
echo "--- Starship ---"
if ! command -v starship &>/dev/null; then
    curl -sS https://starship.rs/install.sh | sh
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
echo "=== All packages installed! Now run ./install.sh to link configs ==="
