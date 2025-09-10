eval "$(thefuck --alias)"
eval "$(direnv hook zsh)"
eval "$(ssh-agent)" > /dev/null

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
eval "$(pyenv init --path)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.iterm2_shell_integration.zsh ] && source ~/.iterm2_shell_integration.zsh