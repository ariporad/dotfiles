#!/bin/bash
set -ev

shopt -s dotglob

# Install Brew Packages
brew bundle install

# Install Python properly

# Download a Font
mkdir -p ~/Downloads/Fonts
pushd ~/Downloads/Fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/SourceCodePro.zip
unzip *.zip
open *.ttf
popd

# Configure Some Settings
defaults write com.apple.Finder AppleShowAllFiles -bool YES
defaults write com.googlecode.iTerm2 LoadPrefsFromCustomFolder -bool YES
defaults write com.googlecode.iTerm2 PrefsCustomFolder "$HOME/.config/iterm2"
defaults write com.runningwithcrayons.Alfred-Preferences syncfolder "$HOME/.config/alfred"

# Symlink Config Files
#
# Mirror symlinks/ into $HOME. Two rules matter here:
#
#   * `ln -sfn`, not `ln -sf`. Without -n, re-running this over an existing
#     symlink-to-a-directory dereferences it and drops the new link *inside*
#     the target, e.g. ~/.vim/.vim -> .../symlinks/.vim.
#   * Descend into directories that already exist for real in $HOME instead of
#     replacing them. ~/.config and ~/.claude hold plenty of state that isn't
#     ours (gcloud, gh, 1Password, Claude's caches); only our own entries
#     inside them should become symlinks.
link_tree() {
    local src="$1" dst="$2" item name target

    for item in "$src"/*; do
        [ -e "$item" ] || continue  # empty dir: the glob stayed literal

        name="$(basename "$item")"
        target="$dst/$name"

        if [ -d "$item" ] && [ -d "$target" ] && [ ! -L "$target" ]; then
            link_tree "$item" "$target"
        elif ln -sfn "$item" "$target"; then
            echo "Created symlink: $target -> $item"
        else
            echo "Error: Failed to create symlink for '$item'" >&2
        fi
    done
}

link_tree "$(pwd)/symlinks" "$HOME"

vim +PlugInstall +qall
