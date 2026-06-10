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

# Git worktrees
alias gwl="git worktree list"
alias gwa="git worktree add"
alias gwr="git worktree remove"

# tmux sessionizer (fzf-pick a project → tmux session)
alias ts="$HOME/git/dotfiles/bash/tmux-sessionizer.sh"

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

# Long-running command notifications (notify after >30s)
__cmd_timer_start() {
    __cmd_timer=${__cmd_timer:-$SECONDS}
    __cmd_name="${BASH_COMMAND}"
}
__cmd_timer_stop() {
    if [ -n "$__cmd_timer" ]; then
        local elapsed=$(( SECONDS - __cmd_timer ))
        if [ $elapsed -ge 30 ]; then
            if [[ "$(uname -s)" == "Darwin" ]]; then
                osascript -e "display notification \"$__cmd_name\" with title \"Command finished (${elapsed}s)\"" 2>/dev/null
            else
                notify-send "Command finished (${elapsed}s)" "$__cmd_name" --icon=utilities-terminal 2>/dev/null
            fi
        fi
        unset __cmd_timer
        unset __cmd_name
    fi
}
trap '__cmd_timer_start' DEBUG

# Random MOTD tip (loaded from external file)
__show_motd() {
    local tips_file="$HOME/git/dotfiles/bash/motd-tips.txt"
    if [ -f "$tips_file" ]; then
        local tip
        tip=$(grep -v '^#' "$tips_file" | grep -v '^$' | shuf -n 1)
        [ -n "$tip" ] && echo "💡 $tip" && echo ""
    fi
}

# Pretty terminal (pokemon art + system stats side-by-side, 20% chance classic Fedora logo)
if (( RANDOM % 5 == 0 )); then
    fastfetch
else
    fastfetch --data "$(pokemon-colorscripts -r --no-title)"
fi
__show_motd
eval "$(starship init bash)"
PROMPT_COMMAND="__cmd_timer_stop;${PROMPT_COMMAND}"

# atuin (better shell history) - after starship so it doesn't override prompt
eval "$(atuin init bash --disable-up-arrow)"

# zoxide (smart cd) - must be last
eval "$(zoxide init bash)"
