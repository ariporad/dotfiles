# Path to your oh-my-zsh installation.
export ZSH=/Users/ariporad/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="ariporad/ariporad"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# plugins=(git node npm brew osx)

# User configuration

export PORT=8080 # A sane default
export NODE_ENV=development
export EDITOR='vim'

# Fix Encoding
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

alias git='hub' # https://hub.github.com/
alias z='fg %1'
alias zz='fg %2'
alias zzz='fg %3'
alias zzzz='fg %4'
alias zzzzz='fg %5'


function ca() {
  git add .
  if [ -z "$1" ]; then # no args
    git commit -a
  else
    git commit -am $@
  fi
}

function beep() {
	osascript -e 'beep'
}

alias hosts='sudo nano /private/etc/hosts;dscacheutil -flushcache;sudo killall -HUP mDNSResponder'

function viminstall() {
  # Install vim plugins
  vim +PlugInstall +qall
}


source $ZSH/oh-my-zsh.sh

# Use Vi mode
export KEYTIMEOUT=1
bindkey -v
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward

# gitignore.io
function gi() { curl -L -s https://www.gitignore.io/api/$@ ;}

function whosOnPort(){
	lsof -n -i4TCP:$1 | grep LISTEN
}

# http://superuser.com/a/599156
function title() {
  echo -ne "\033]0;"$*"\007"
}

function git-authors(){
	git ls-tree -r -z --name-only HEAD -- $1 | xargs -0 -n1 git blame \
 --line-porcelain HEAD |grep "^author "|sort|uniq -c|sort -nr
}

# Force options for commands
alias pg="postgres -D /usr/local/var/postgres"
alias postgres="postgres -D /usr/local/var/postgres"
alias ll="ls -lah"

# Aliases
alias s="git status"
alias c="git commit -m"
alias cm="git commit"
alias a="git add"
alias d="git diff" # Note: oh-my-zsh aliases this to `dirs`, but I don't care.
alias dc="git diff --cached"

# Modify $PATH
export PATH=/usr/local/bin:$PATH
export PATH=$PATH:./node_modules/.bin # Put local node_modules in $PATH, just like in an npm script.
export PATH=$PATH:/usr/local/sbin
export PATH=$PATH:~/.bin

export GIT_EDITOR="vim"
export CASTBRIDGE_ANALYTICS=false

export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).

test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh


export PATH="$PATH:`yarn global bin`"

eval "$(direnv hook zsh)"

powerline-daemon -q
. /usr/local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh

eval "$(ssh-agent)" > /dev/null

# Local Config
# https://unix.stackexchange.com/a/190864
[ -f .profile ] && source .profile
