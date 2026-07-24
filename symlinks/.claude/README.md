# Shared Claude Code config

Deployed by zero.sh: everything under `.claude/` here is symlinked into
`~/.claude/`, and is **shared across all three `CLAUDE_CONFIG_DIR` homes**:

- `~/.claude` (global / default)
- `~/dev/reframe/.claude` (set via `~/dev/reframe/.envrc`)
- `~/dev/awaken/.claude` (set via `~/dev/awaken/.envrc`)

## What's shared, and how

The scripts live **once** here and are referenced by the stable `~/.claude/...`
path from every home, so there is a single source of truth for the logic:

| File | Symlinked to | Purpose |
|------|--------------|---------|
| `.claude/statusline.sh` | `~/.claude/statusline.sh` | Claude Code statusline. Resolves the per-home account email from `$CLAUDE_CONFIG_DIR/.claude.json` at runtime, so one script serves all three homes. Also shows "idle HH:MM" from the marker `bell.sh` writes. |
| `.claude/hooks/bell.sh` | `~/.claude/hooks/bell.sh` | Rings the terminal bell on `Stop`/`Notification` and records the idle time to `$TMPDIR/claude-idle-<sid>`. The tmux **tab name** is NOT set here — it comes from Claude Code's own pane title (see `tmux/.tmux.conf` `automatic-rename-format`), which is the only thing that works for Claude's *background* sessions (they have no `TMUX_PANE` for a hook to rename). |
| `.claude/settings.json` | `~/.claude/settings.json` | The **global** home's settings (tracked here). |

## The `statusLine` + `hooks` blocks are the shared contract

Claude Code `settings.json` is strict JSON — no comments or extra keys — so this
README is the annotation. The `statusLine` block and the `hooks` block (`Stop`
and `Notification`, pointing at `~/.claude/...`) must be **kept identical** in all
three homes:

- global: `.claude/settings.json` here (symlinked to `~/.claude/settings.json`)
- reframe: `~/dev/reframe/.claude/settings.json` (separate per-client file)
- awaken: `~/dev/awaken/.claude/settings.json` (separate per-client file)

The two client files stay separate because they hold client-specific settings
(model, theme, plugins, sandbox paths). Only those two blocks are duplicated;
everything executable is shared via the symlinks above.
