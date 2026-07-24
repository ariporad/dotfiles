# This file needs to come near the end (specifically after 85-antigen) because oh-my-zsh has some
# alternative definitions for these aliases.
# DEBUGGING PRO TIP: zsh -v will print out every command that's run in the bootup process

export LESS="-FXRS"

alias ll="ls -lah"
alias pi="ping 8.8.8.8"

# Background Processes
# Apparently, fg is too much to type
alias z='fg %1'
alias zz='fg %2'
alias zzz='fg %3'
alias zzzz='fg %4'
alias zzzzz='fg %5'

# Git
if which hub > /dev/null; then
	alias git='hub' # https://hub.github.com/
fi

alias a="git add"
alias d="git diff" # Note: this is aliased to `dirs` by default
alias s="git status"
alias c="git commit -m"
alias cz="git cz"
alias cm="git commit"
alias co="git checkout"
alias dc="git diff --cached"
