# Make SSH agent access survive tmux detach/reattach across SSH reconnects.
#
# The problem: a forwarded agent socket (/tmp/ssh-XXXX/agent.NNN) dies with
# its SSH connection, but long-lived tmux shells keep the stale path in
# SSH_AUTH_SOCK forever. The fix: everything points at one stable symlink,
# and the symlink is repointed at whichever real socket is currently live:
#   - Incoming SSH connection -> ~/.ssh/rc points it at the forwarded socket
#   - Local (non-SSH) shell   -> this file points it at the 1Password agent
# ~/.tmux.conf pins SSH_AUTH_SOCK to the symlink so new panes pick it up.

_ssh_auth_sock_link="$HOME/.ssh/ssh_auth_sock"
_1password_agent_sock="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

# Local shell (not SSH): the 1Password agent on this machine is the live one.
if [ -z "$SSH_TTY" ] && [ -z "$SSH_CONNECTION" ] && [ -S "$_1password_agent_sock" ]; then
  ln -sf "$_1password_agent_sock" "$_ssh_auth_sock_link"
fi

export SSH_AUTH_SOCK="$_ssh_auth_sock_link"
unset _ssh_auth_sock_link _1password_agent_sock
