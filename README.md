# Dotfiles

My terminal setup for Fedora + KDE Plasma.

## What's included

- **Bash** — aliases, modern CLI tools, history config
- **Neovim** — Python IDE (LSP, autocomplete, debugger, ruff formatting)
- **Starship** — powerline prompt with git, venv, command duration
- **Fastfetch** — system info on terminal open
- **tmux** — terminal multiplexer (Ctrl+a prefix, vim keys)
- **lazygit** — TUI git client
- **bat** — syntax-highlighted cat
- **eza** — modern ls with icons
- **delta** — side-by-side git diffs
- **atuin** — SQLite shell history
- **fzf** — fuzzy finder
- **zoxide** — smart cd
- **direnv** — auto venv activation
- **Konsole** — Catppuccin Mocha theme, JetBrainsMono Nerd Font

## Install

```bash
# 1. Clone
git clone https://github.com/andre-motta/dotfiles.git ~/git/dotfiles
cd ~/git/dotfiles

# 2. Install packages
./packages.sh

# 3. Link configs
./install.sh
```

## Updating

Edit configs in `~/git/dotfiles/`, changes apply immediately since everything is symlinked.
