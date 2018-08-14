####################################################################################################
# Antigen
####################################################################################################
source /usr/local/share/antigen/antigen.zsh

antigen use oh-my-zsh
antigen bundle lukechilds/zsh-nvm


####################################################################################################
# ZSH
####################################################################################################
DISABLE_AUTO_TITLE="true"
ENABLE_CORRECTION="true"

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions

# Use Vi mode
export KEYTIMEOUT=1
bindkey -v
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward


####################################################################################################
# Misc. ENV Vars
####################################################################################################

# Sane Defaults
export PORT=8080
export NODE_ENV=development

# Editors
export EDITOR='vim'
export GIT_EDITOR="vim"
export SCHOOLKIT_EDITOR="gvim"

# Fix Encoding Problems
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Default Options for Some Commands
export LESS="-FXRS"
export PGDATA="/usr/local/var/postgres"
export FZF_DEFAULT_COMMAND='ag --ignore node_modules -g "" --nocolor'
export NVM_AUTO_USE=true

# Other
export CASTBRIDGE_ANALYTICS=false


####################################################################################################
# Helpers
####################################################################################################

# Commonly used for `do_long_thing && beep`
function beep() { osascript -e 'beep' }

# Handy shortcut to edit the hosts file
function hosts() {
	sudo $EDITOR /private/etc/hosts
	dscacheutil -flushcache
	sudo killall -HUP mDNSResponder
}

# Generate a .gitignore
function gi() { curl -L -s https://www.gitignore.io/api/$@ ;}

# This has been somewhat replaced by fkill
function whosOnPort(){ lsof -n -i4TCP:$1 | grep LISTEN }

# Set the title of the terminal: http://superuser.com/a/599156
function settitle() { echo -ne "\033]0;"$*"\007" }

# Open files in Byword from the terminal
function byword() {
	touch "$1"
	open -a /Applications/Byword.app "$1"
}

function g() {
	cd "$@"
	ll
	printf "\n--------------------------------------------------------------------------------\n\n"
	[ -d '.git' ] && git status
	# direnv logs a bunch if .envrc exists, so we make another divider
	[ -f '.envrc' ] && printf "\n--------------------------------------------------------------------------------\n\n"
}

function ev() {
	vim ~/.zshrc
	. ~/.zshrc
}

# https://stackoverflow.com/a/3232082/1928484
function confirm() {
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure? [y/N]} " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        *)
            false
            ;;
    esac
}

# Always show the directory in the titlebar (This is for automatic time tracking)
# https://superuser.com/a/414953
function precmd() {
	echo -ne "\e]1;${PWD//$HOME/~}\a"
}

####################################################################################################
# $PATH
####################################################################################################

export PATH="/usr/local/bin:$PATH"
export PATH="$PATH:$HOME/.bin"
export PATH="$PATH:/usr/local/bin"
export PATH="$PATH:/usr/local/sbin"
export PATH="$PATH:./node_modules/.bin" # Use local node modules like an npm script
export PATH="$PATH:/Library/TeX/texbin"
export PATH="$PATH:/Users/ariporad/Library/Android/sdk/platform-tools" # I hate Android
export PATH="$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin" # Postgres.app
# We add `yarn global bin` later once we setup nvm

####################################################################################################
# Load all the things
####################################################################################################

eval $(thefuck --alias)
eval "$(direnv hook zsh)"
eval "$(ssh-agent)" > /dev/null
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/dev/schoolkit/index.sh ] && source ~/dev/schoolkit/index.sh
[ -f /Users/ariporad/.travis/travis.sh ] && source /Users/ariporad/.travis/travis.sh
test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh



####################################################################################################
# Prompt
####################################################################################################

antigen theme https://github.com/denysdovhan/spaceship-prompt spaceship
# $SPACESHIP_NODE_DEFAULT_VERSION gets set later, after we run antigen apply
export SPACESHIP_VI_MODE_SHOW=false


####################################################################################################
# Local Config
####################################################################################################

# https://unix.stackexchange.com/a/190864
[ -f .profile ] && source .profile


####################################################################################################
# Antigen (again)
####################################################################################################

antigen apply # actually setup the plugins

# Now add yarn global modules to $PATH. We can't do this until after antigen apply, because antigen
# sets up nvm, which sets up yarn.
export PATH="$PATH:`yarn global bin`"
# Also set the default node version. See above for why.
export SPACESHIP_NODE_DEFAULT_VERSION="$("$(nvm which default)" -v)"


####################################################################################################
# Misc. Aliases
####################################################################################################

# Editors
# Setup vvim (normal vim), mvim (MacVim), gvim (generic GUI), nvim (Neovim), and rvim (Neovim GUI)
alias vi="vim" # MWAAAAAA HAAAAA HAAAAA HAAAAA HAAAAAA
alias vim="/Applications/MacVim.app/Contents/MacOS/Vim"
alias vvim="vim"
alias rvim="vimr" # For consistency
alias gvim="mvim"

# Misc
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
alias git='hub' # https://hub.github.com/
alias a="git add"
alias d="git diff" # Note: this is aliased to `dirs` by default
alias s="git status"
alias c="git commit -m"
alias cz="git cz"
alias cm="git commit"
alias co="git checkout"
alias dc="git diff --cached"

