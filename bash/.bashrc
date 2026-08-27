# .bashrc

# Codex commands are non-interactive and should not load prompts or terminal UI.
if [[ ${CODEX_CI:-0} == 1 ]]; then
    return
fi

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

# Shared config (aliases, env, functions)
source "$HOME/git/dotfiles/shell/common.sh"

# Better history
export HISTSIZE=50000
export HISTFILESIZE=50000
export HISTCONTROL=ignoreboth:erasedups
shopt -s histappend

# fzf keybindings and completion (Ctrl+R for history, Ctrl+T for files)
eval "$(fzf --bash)"

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
            __notify_cmd "$elapsed" "$__cmd_name"
        fi
        unset __cmd_timer
        unset __cmd_name
    fi
}
trap '__cmd_timer_start' DEBUG

# Prompt and tools
eval "$(starship init bash)"
PROMPT_COMMAND="__cmd_timer_stop;${PROMPT_COMMAND}"

# atuin (better shell history) - after starship so it doesn't override prompt
eval "$(atuin init bash --disable-up-arrow)"

# zoxide (smart cd) - must be last
eval "$(zoxide init bash)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/alustosa/Downloads/gcloud/google-cloud-sdk/path.bash.inc' ]; then . '/home/alustosa/Downloads/gcloud/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/alustosa/Downloads/gcloud/google-cloud-sdk/completion.bash.inc' ]; then . '/home/alustosa/Downloads/gcloud/google-cloud-sdk/completion.bash.inc'; fi
