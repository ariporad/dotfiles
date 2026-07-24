#!/usr/bin/env bash
# On Stop / Notification (Claude finished a turn or needs input):
#   1. ring the terminal bell, and
#   2. record the time it went idle to ${TMPDIR}/claude-idle-<sid> so the
#      statusline can show it.
# The tmux tab name comes from Claude Code's own pane title (see .tmux.conf's
# automatic-rename-format), so this hook does nothing with tmux.
input=$(cat)
event=$(jq -r '.hook_event_name // empty' <<<"$input" 2>/dev/null)
case "$event" in
  Stop|Notification)
    jq -nc '{terminalSequence:([7]|implode)}'   # BEL
    sid=$(jq -r '.session_id // empty' <<<"$input" 2>/dev/null)
    [ -n "$sid" ] && date +%s > "${TMPDIR:-/tmp}/claude-idle-$sid" 2>/dev/null
    ;;
esac
exit 0
