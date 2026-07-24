# This prints the prompt right away, so it needs to run ASAP.
# Hardcoded rather than `$(brew --prefix)` to avoid a subshell on every startup.
# NOTE: current powerlevel10k kegs install the theme under share/; older ones
# (<= 1.16.x) put it at the keg root, i.e. /opt/homebrew/opt/powerlevel10k/.
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# Once we're done, actually load the prompt
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# --- Prompt tweaks. Written by Claude (2026-06-30). ---
# NOTE: these must come *after* `source ~/.p10k.zsh`, not before the theme:
# ~/.p10k.zsh defines the *_PROMPT_ELEMENTS arrays itself, so setting them
# earlier would just get overwritten. Powerlevel10k is designed to honor
# POWERLEVEL9K_* overrides placed after it's sourced.
#
# Move `context` (user@host) off the top-right and onto the caret line. The
# `newline` element ends line 1, so everything after it -- context, then
# prompt_char -- renders together on line 2: "user@host ❯". It only shows over
# SSH/root anyway (~/.p10k.zsh blanks the DEFAULT/SUDO context classes).
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(${POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS:#context})
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs newline context prompt_char)

# Gray over plain SSH; bold red when it's also a sudo session.
typeset -g POWERLEVEL9K_CONTEXT_REMOTE_FOREGROUND=244
typeset -g POWERLEVEL9K_CONTEXT_REMOTE_SUDO_FOREGROUND=196
typeset -g POWERLEVEL9K_CONTEXT_REMOTE_SUDO_TEMPLATE='%B%n@%m'