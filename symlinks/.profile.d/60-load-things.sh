# Install direnv's hook for future `cd`s. The current dir's env is already loaded
# above the instant prompt (see 00-p10k-instant-prompt.sh), so this hook produces
# no output on the first prompt and won't trip p10k's console-output warning.
eval "$(direnv hook zsh)"

# pyenv, with virtualenv integration. `pyenv init - zsh` handles PATH + shims +
# completion in one shot; virtualenv-init adds auto-activation of virtualenvs.
eval "$(pyenv init - zsh)"
eval "$(pyenv virtualenv-init -)"

# thefuck's `--alias` spawns Python (~230ms), so load it lazily on first use.
# NOTE: this lazy-loading wrapper was written by Claude (2026-06-30).
fuck() {
  unset -f fuck
  eval "$(thefuck --alias)"
  fuck "$@"
}

[ -f ~/.cargo/env ] && source ~/.cargo/env
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.iterm2_shell_integration.zsh ] && source ~/.iterm2_shell_integration.zsh
