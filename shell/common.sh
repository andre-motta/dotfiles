# common.sh — shared config sourced by both .bashrc and .zshrc

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
PATH="$HOME/.cargo/bin:$PATH"
export PATH

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

# fzf theme
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8,fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc,marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {} 2>/dev/null || eza --icons --color=always {}'"
export FZF_ALT_C_OPTS="--preview 'eza --icons --tree --level=2 --color=always {}'"

# Long-running command notification helper
__notify_cmd() {
    local elapsed="$1" cmd="$2"
    if [[ "$(uname -s)" == "Darwin" ]]; then
        osascript -e "display notification \"$cmd\" with title \"Command finished (${elapsed}s)\"" 2>/dev/null
    else
        notify-send "Command finished (${elapsed}s)" "$cmd" --icon=utilities-terminal 2>/dev/null
    fi
}

# Random MOTD tip (loaded from external file)
__show_motd() {
    local tips_file="$HOME/git/dotfiles/bash/motd-tips.txt"
    if [ -f "$tips_file" ]; then
        local tip
        tip=$(grep -v '^#' "$tips_file" | grep -v '^$' | shuf -n 1 2>/dev/null || \
              grep -v '^#' "$tips_file" | grep -v '^$' | gshuf -n 1 2>/dev/null)
        [ -n "$tip" ] && echo "💡 $tip" && echo ""
    fi
}

# Pretty terminal (pokemon art + system stats side-by-side, 20% chance classic logo)
if (( RANDOM % 5 == 0 )); then
    fastfetch
else
    fastfetch --data "$(pokemon-colorscripts -r --no-title)"
fi
__show_motd
