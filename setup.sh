#!/bin/bash
set -ev

shopt -s dotglob

# Install Everything
brew bundle install

# Configure Some Settings
defaults write com.apple.Finder AppleShowAllFiles -bool YES
defaults write com.googlecode.iTerm2 LoadPrefsFromCustomFolder -bool YES
defaults write com.googlecode.iTerm2 PrefsCustomFolder "$HOME/.config/iterm2"
defaults write com.runningwithcrayons.Alfred-Preferences syncfolder "$HOME/.config/alfred"

# Symlink Config Files
pushd symlinks > /dev/null
for item in *; do
    if [[ "$item" == "*" && ! -e "$item" ]]; then
        echo "No files found in symlinks directory"
        break
    fi
    basename=$(basename "$item")
    source="$(pwd)/$basename"
    target="$HOME/$basename"

    if ln -sf "$source" "$target"; then
        echo "Created symlink: $target -> $source"
    else
        echo "Error: Failed to create symlink for '$basename'" >&2
    fi
done
popd > /dev/null

vim +PlugInstall +qall
