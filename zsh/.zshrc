# .zshrc

# Source global definitions
if [ -f /etc/zshrc ]; then
    . /etc/zshrc
fi

# Shared config (aliases, env, functions)
source "$HOME/git/dotfiles/shell/common.sh"

# Better history
export HISTSIZE=50000
export SAVEHIST=50000
export HISTFILE=~/.zsh_history
export HISTDUP=erase
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_ALL_DUPS

# fzf keybindings and completion (Ctrl+R for history, Ctrl+T for files)
eval "$(fzf --zsh)"

# direnv (auto-activate venvs)
eval "$(direnv hook zsh)"

# Long-running command notifications (notify after >30s)
__cmd_timer_preexec() {
    __cmd_timer=${__cmd_timer:-$SECONDS}
    __cmd_name="$1"
}
__cmd_timer_precmd() {
    if [ -n "$__cmd_timer" ]; then
        local elapsed=$(( SECONDS - __cmd_timer ))
        if [ $elapsed -ge 30 ]; then
            __notify_cmd "$elapsed" "$__cmd_name"
        fi
        unset __cmd_timer
        unset __cmd_name
    fi
}
autoload -Uz add-zsh-hook
add-zsh-hook preexec __cmd_timer_preexec
add-zsh-hook precmd __cmd_timer_precmd

# Prompt and tools
eval "$(starship init zsh)"

# atuin (better shell history) - after starship so it doesn't override prompt
eval "$(atuin init zsh --disable-up-arrow)"

# zoxide (smart cd) - must be last
eval "$(zoxide init zsh)"
