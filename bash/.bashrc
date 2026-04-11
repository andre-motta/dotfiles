# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
PATH="$HOME/.cargo/bin:$PATH"
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

# Local env vars (not in dotfiles repo)
[ -f ~/.env_local ] && source ~/.env_local

# Use neovim as default editor
export EDITOR=nvim
alias vim="nvim"
alias vi="nvim"

# Modern CLI replacements
alias ls="eza --icons --group-directories-first"
alias ll="eza --icons --group-directories-first -la"
alias la="eza --icons --group-directories-first -la"
alias lt="eza --icons --group-directories-first --tree --level=2"
alias ltr="eza --icons --group-directories-first -la --sort=modified"
alias cat="bat --paging=never --style=plain"
alias catn="bat --paging=never"

# yazi file manager (cd to directory on quit)
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# Git aliases
alias gs="git status"
alias gd="git diff"
alias gl="git log --oneline -20"
alias gp="git push"
alias ga="git add"
alias gc="git commit -s"
alias lg="lazygit"

# Safe delete (moves to trash instead of permanent delete)
alias rm="trash-put"
alias rmm="/usr/bin/rm"

# Better history
export HISTSIZE=50000
export HISTFILESIZE=50000
export HISTCONTROL=ignoreboth:erasedups
shopt -s histappend

# fzf keybindings and completion (Ctrl+R for history, Ctrl+T for files)
eval "$(fzf --bash)"
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8,fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc,marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {} 2>/dev/null || eza --icons --color=always {}'"
export FZF_ALT_C_OPTS="--preview 'eza --icons --tree --level=2 --color=always {}'"

# direnv (auto-activate venvs)
eval "$(direnv hook bash)"

# Pretty terminal
fastfetch
eval "$(starship init bash)"

# atuin (better shell history) - after starship so it doesn't override prompt
eval "$(atuin init bash --disable-up-arrow)"

# zoxide (smart cd) - must be last
eval "$(zoxide init bash)"
