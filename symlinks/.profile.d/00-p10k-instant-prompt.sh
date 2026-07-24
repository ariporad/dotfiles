# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

# Load direnv's env for the current dir *above* the instant-prompt preamble, so
# its "direnv: loading ..." output prints above the prompt instead of tripping
# p10k's "console output during zsh initialization" warning. The direnv hook (for
# later `cd`s) is installed after instant prompt in 60-load-things.sh. Absolute
# path because homebrew isn't on PATH this early (01-homebrew.sh runs later).
# https://github.com/romkatv/powerlevel10k/issues/702
# NOTE: written by Claude (2026-06-30).
[[ -x /opt/homebrew/bin/direnv ]] && eval "$(/opt/homebrew/bin/direnv export zsh)"

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi