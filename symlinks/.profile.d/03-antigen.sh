# Load antigen
source /opt/homebrew/share/antigen/antigen.zsh

# Load plugins
# Silence antigen because it complains if things are already installed
antigen use oh-my-zsh > /dev/null
antigen bundle zsh-users/zsh-syntax-highlighting > /dev/null
antigen bundle zsh-users/zsh-autosuggestions > /dev/null
antigen bundle zsh-users/zsh-completions > /dev/null