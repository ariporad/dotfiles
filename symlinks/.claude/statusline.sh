#!/usr/bin/env bash
# Claude Code statusline. Reads the hook JSON on stdin (see
# https://code.claude.com/docs/en/statusline). Shared across all three
# CLAUDE_CONFIG_DIR homes — the per-home account email is resolved from
# $CLAUDE_CONFIG_DIR at runtime, so one script serves every home.
#
# Layout (usage + account domain right-aligned via $COLUMNS when there's room):
#   Opus (high) / 34% (60k/1M) /  branch …… 5h 24% / 7d 41% / x.com
#
# Everything comes from stdin except the git branch (computed) and the email
# (read from .claude.json). Every field degrades cleanly when absent.

input=$(cat)
jqr() { jq -r "$1" <<<"$input" 2>/dev/null; }

# --- ANSI helpers (24-bit truecolor; passthrough is enabled in tmux) ---
esc=$'\033'
rst="${esc}[0m"; bold="${esc}[1m"; dim="${esc}[2m"
fg()  { printf '%s[38;2;%sm' "$esc" "$1"; }        # $1 = "R;G;B"
BLUE="95;143;255"; MAGENTA="215;135;255"; GREY="128;128;128"; ORANGE="255;175;95"
GREEN="135;215;95"; YELLOW="255;215;95"; RED="255;95;95"; CYAN="95;215;215"
GRAYTXT="165;165;165"   # readable gray for parentheticals (dim is too faint)
sep="${dim}${esc}[38;2;${GREY}m / ${rst}"

# green < 50 < yellow < 80 < red, keyed on a percentage
pct_color() { local p=${1%%.*}; p=${p:-0}
  if   [ "$p" -lt 50 ]; then printf '%s' "$GREEN"
  elif [ "$p" -lt 80 ]; then printf '%s' "$YELLOW"
  else printf '%s' "$RED"; fi; }

# 1000000->1M  200000->200k  60500->60k
fmt_tokens() { local t=${1:-0}
  if   [ "$t" -ge 1000000 ]; then printf '%sM' "$((t/1000000))"
  elif [ "$t" -ge 1000 ];    then printf '%sk' "$((t/1000))"
  else printf '%s' "$t"; fi; }

# Path collapse, p10k-style but progressive: abbreviate the leftmost $1 non-last
# segments to one char each (keeping a leading dot). k=0 is the full path; larger
# k collapses more (~/dev/reframe/sandbox/ari/cytokine -> ~/d/r/s/a/cytokine).
CWD_DISPLAY=""   # set later from stdin
path_at() {
  local k="$1" p="$CWD_DISPLAY"
  local IFS='/'; local -a parts=(); read -ra parts <<<"$p"
  local -a out=(); local n=${#parts[@]} i seg abbr=0
  for i in "${!parts[@]}"; do
    seg="${parts[$i]}"
    if [ "$i" -eq $((n-1)) ] || [ -z "$seg" ]; then
      out+=("$seg")
    elif [ "$abbr" -lt "$k" ]; then
      if [[ "$seg" == .* ]]; then out+=(".${seg:1:1}"); else out+=("${seg:0:1}"); fi
      abbr=$((abbr+1))
    else
      out+=("$seg")
    fi
  done
  local IFS='/'; printf '%s' "${out[*]}"
}
# count of collapsible (non-last, non-empty) segments
path_maxk() {
  local IFS='/'; local -a parts=(); read -ra parts <<<"$CWD_DISPLAY"
  local n=${#parts[@]} i c=0
  for i in "${!parts[@]}"; do
    [ "$i" -eq $((n-1)) ] && break
    [ -n "${parts[$i]}" ] && c=$((c+1))
  done
  printf '%s' "$c"
}

# visible width of a string, ignoring SGR color escapes and OSC-8 hyperlinks
vislen() {
  local c
  c=$(printf '%s' "$1" | sed "s/${esc}]8;;[^${esc}]*${esc}\\\\//g; s/${esc}\[[0-9;]*m//g")
  printf '%s' "${#c}"
}

# OSC-8 hyperlink: clickable in iTerm2 (and other OSC-8 terminals); degrades to
# just the visible text elsewhere.  osc8_link <url> <text>
osc8_link() { printf '%b' "${esc}]8;;$1${esc}\\\\$2${esc}]8;;${esc}\\\\"; }

# TCP reachability with a hard 0.1s cap per probe, so a dropped port never stalls
# the line (at most two probes run, host then localhost: ~0.2s worst case).
reachable() {
  local h="$1" p="$2"
  { [ -n "$h" ] && [ -n "$p" ]; } || return 1
  curl --max-time 0.1 "http://$h:$p" >/dev/null 2>&1 || return 1
}

# Left order: path / branch / model / context.
# Path is kept swappable so it can be collapsed only as much as needed to fit.

# --- path ---
# Actual cwd (used for git). In a worktree, the *displayed* path is the original
# project instead, so the worktree name isn't repeated in path + branch + tag.
cwd_raw=$(jqr '.cwd // .workspace.current_dir // empty')
wt_name=$(jqr '.worktree.name // .workspace.git_worktree // empty')   # "" unless in a worktree
disp="$cwd_raw"
if [ -n "$wt_name" ]; then
  disp=$(jqr '.worktree.original_cwd // empty')
  if [ -z "$disp" ] && [ -n "$cwd_raw" ]; then                        # derive main repo root
    common=$(git -C "$cwd_raw" rev-parse --git-common-dir 2>/dev/null)
    case "$common" in /*) ;; ?*) common="$cwd_raw/$common" ;; esac
    [ -n "$common" ] && disp=$(cd "$(dirname "$common")" 2>/dev/null && pwd)
  fi
  [ -z "$disp" ] && disp="$cwd_raw"
fi
CWD_DISPLAY="$disp"
[ -n "$CWD_DISPLAY" ] && { tilde='~'; CWD_DISPLAY="${CWD_DISPLAY/#$HOME/$tilde}"; }
path_seg() { [ -n "$CWD_DISPLAY" ] && printf '%s' "$(fg "$BLUE")$(path_at "$1")${rst}"; }

# --- everything after the path (collapse-independent): branch, model, ctx ---
POST=""; add_p() { [ -n "$POST" ] && POST+="$sep"; POST+="$1"; }

# branch (computed; omit outside a repo). Color reflects working-tree state:
# green = clean, yellow = dirty. In a worktree, suffix the branch with "%" — plus
# " (<dir>)" when the worktree dir name doesn't match the branch.
if [ -n "$cwd_raw" ]; then
  branch=$(git -C "$cwd_raw" rev-parse --abbrev-ref HEAD 2>/dev/null)
  wt_mark=""; wt_tag=""
  if [ -n "$wt_name" ]; then
    wt_mark="$(fg "$GRAYTXT")%${rst}"
    if [ "$branch" != "$wt_name" ] && [ "${branch#worktree-}" != "$wt_name" ]; then
      wt_tag=" $(fg "$GRAYTXT")($wt_name)${rst}"
    fi
  fi
  if [ -n "$branch" ] && [ "$branch" != "HEAD" ]; then
    if [ -z "$(git -C "$cwd_raw" status --porcelain 2>/dev/null)" ]; then
      bcol="$GREEN"    # clean
    else
      bcol="$YELLOW"   # dirty
    fi
    add_p "$(fg "$bcol")$branch${rst}$wt_mark$wt_tag"
  elif [ -n "$wt_mark" ]; then
    # worktree but detached/no branch: the mark plus the dir name
    add_p "$wt_mark$(fg "$GRAYTXT")$wt_name${rst}"
  fi
fi

# model (orange) + effort. Strip any "1M"/"(1M context)"/"[1m]" from the display
# name — the context window is already shown in the context denominator.
model=$(jqr '.model.display_name // empty')
if [ -n "$model" ]; then
  model=$(printf '%s' "$model" | sed -E 's/[[:space:]]*\((1M|1m)[^)]*\)//g; s/[[:space:]]*\[1[Mm]\]//g; s/[[:space:]]+1[Mm]([[:space:]]|$)/\1/g')
  # effort as a single letter: low/medium/high -> l/m/h, xhigh -> x. "max" would
  # collide with "medium" on its first letter, so it stays spelled out.
  effort=$(jqr '.effort.level // empty')
  case "$effort" in
    max) eff="max" ;;
    x*)  eff="x" ;;
    ?*)  eff="${effort:0:1}" ;;
    *)   eff="" ;;
  esac
  m="$(fg "$ORANGE")${model}${rst}"
  [ -n "$eff" ] && m+=" $(fg "$GRAYTXT")($eff)${rst}"
  add_p "$m"
fi

# context: 34% (60k/1M), % colored by fill
pct=$(jqr '.context_window.used_percentage // empty')
used=$(jqr '.context_window.total_input_tokens // empty')
size=$(jqr '.context_window.context_window_size // empty')
if [ -n "$pct" ]; then
  ctx="$(fg "$(pct_color "$pct")")${pct%%.*}%${rst}"
  [ -n "$used" ] && [ -n "$size" ] && ctx+=" $(fg "$GRAYTXT")($(fmt_tokens "$used")/$(fmt_tokens "$size"))${rst}"
  add_p "$ctx"
fi

# .envrc/.env for the dev-server link: PORT/HOST usually live in one of those
# rather than in this script's environment. Source them from the repo/worktree
# root and then from the cwd (so the more specific dir wins), .envrc before .env
# within each dir. All of it runs in a subshell and only PORT/HOST come back, so
# a project file can't clobber this script's own variables.
env_files=()
add_env_files() {
  [ -n "$1" ] || return 0
  [ -f "$1/.envrc" ] && env_files+=("$1/.envrc")
  [ -f "$1/.env" ] && env_files+=("$1/.env")
  return 0
}
if [ -n "$cwd_raw" ]; then
  gitroot=$(git -C "$cwd_raw" rev-parse --show-toplevel 2>/dev/null)
  [ "$gitroot" = "$cwd_raw" ] && gitroot=""
  add_env_files "$gitroot"
  add_env_files "$cwd_raw"
fi
if [ "${#env_files[@]}" -gt 0 ]; then
  eval "$(
    # direnv stdlib stubs, so a .envrc sets what it can instead of dying on the
    # first unknown command. Anything else it calls fails harmlessly (no set -e).
    dotenv() { [ -n "$1" ] && . "$1"; }
    dotenv_if_exists() { [ -n "$1" ] && [ -f "$1" ] && . "$1"; }
    source_env() { :; }; source_env_if_exists() { :; }; source_up() { :; }
    source_up_if_exists() { :; }; use() { :; }; layout() { :; }
    watch_file() { :; }; PATH_add() { :; }; path_add() { :; }; log_status() { :; }
    set -a
    for f in "${env_files[@]}"; do . "$f" >/dev/null 2>&1; done
    set +a
    printf 'PORT=%q\nHOST=%q\n' "${PORT:-}" "${HOST:-}"
  )"
fi

# dev-server link (after context). If $host:$PORT is reachable show it; else fall
# back to localhost:$PORT; else nothing. Rendered as an OSC-8 link (iTerm2).
#
# $HOST comes from a .envrc/.env above when a project sets one, and wins. Absent
# that, fall back to $HOSTNAME: zsh sets HOST but doesn't export it, so it never
# reaches this bash script, while bash populates HOSTNAME itself. Both use :- so
# the HOST='' the block above emits for "unset" counts as absent.
if [ -n "${PORT:-}" ]; then
  target=""
  # lowercased for display (DNS is case-insensitive, so the probe is unaffected).
  # tr, not ${host,,} — this runs under macOS's bash 3.2, where that's a syntax error.
  host=$(printf '%s' "${HOST:-${HOSTNAME:-}}" | tr '[:upper:]' '[:lower:]')
  if [ -n "$host" ] && reachable "$host" "$PORT"; then
    target="$host:$PORT"
  elif reachable "localhost" "$PORT"; then
    target="localhost:$PORT"
  fi
  [ -n "$target" ] && add_p "$(fg "$CYAN")$(osc8_link "http://$target" "$target")${rst}"
fi

# assemble the full left string for a given path-collapse level k
assemble_left() {
  local ps; ps=$(path_seg "$1"); local out="$ps"
  if [ -n "$out" ] && [ -n "$POST" ]; then out+="$sep$POST"
  elif [ -z "$out" ]; then out="$POST"; fi
  printf '%s' "$out"
}

# ------------------------------------------------------------------ RIGHT
R=""; add_r() { [ -n "$R" ] && R+="$sep"; R+="$1"; }

# Idle-since time: written by the bell hook on Stop/Notification (see bell.sh).
sid=$(jqr '.session_id // empty')
idlef="${TMPDIR:-/tmp}/claude-idle-$sid"
if [ -n "$sid" ] && [ -f "$idlef" ]; then
  it=$(cat "$idlef" 2>/dev/null)
  it12=$(date -r "$it" '+%l:%M%p' 2>/dev/null | sed 's/^ *//; s/AM/am/; s/PM/pm/')
  [ -n "$it12" ] && add_r "$(fg "$GRAYTXT")idle${rst} $it12"
fi

# Overall usage: 5h + 7d (Pro/Max only, after first API response)
u5=$(jqr '.rate_limits.five_hour.used_percentage // empty')
u7=$(jqr '.rate_limits.seven_day.used_percentage // empty')
[ -n "$u5" ] && add_r "$(fg "$GRAYTXT")5h${rst} $(fg "$(pct_color "$u5")")${u5%%.*}%${rst}"
[ -n "$u7" ] && add_r "$(fg "$GRAYTXT")7d${rst} $(fg "$(pct_color "$u7")")${u7%%.*}%${rst}"

# Signed-in account — not in stdin; read from this home's .claude.json. Only the
# domain is shown (ariporad.com, reframe.systems): that's what tells the homes
# apart. ${email#*@} leaves a value with no "@" untouched, which is the sane
# fallback if the field is ever something other than an address.
if [ -n "${CLAUDE_CONFIG_DIR:-}" ] && [ -f "$CLAUDE_CONFIG_DIR/.claude.json" ]; then
  cj="$CLAUDE_CONFIG_DIR/.claude.json"
else
  cj="$HOME/.claude.json"
fi
email=$(jq -r '.oauthAccount.emailAddress // empty' "$cj" 2>/dev/null)
[ -n "$email" ] && add_r "$(fg "$GRAYTXT")${email#*@}${rst}"

# ------------------------------------------------------------------ RENDER
# Claude insets the status line by ~2 cells on each side, so the usable width is
# COLUMNS-4 — right-align within that so the email tail isn't clipped.
cols=${COLUMNS:-0}
if [ "$cols" -gt 6 ]; then cols=$((cols - 4)); else cols=0; fi
rvis=$(vislen "$R")

# Choose the least-collapsed path that still fits (full path when there's room).
maxk=$(path_maxk); k=0; L=$(assemble_left 0)
if [ "$cols" -gt 0 ]; then
  while [ "$k" -le "$maxk" ]; do
    L=$(assemble_left "$k")
    if [ -z "$R" ]; then
      [ "$(vislen "$L")" -le "$cols" ] && break
    else
      [ $(( cols - $(vislen "$L") - rvis )) -ge 2 ] && break
    fi
    k=$((k+1))
  done
  [ "$k" -gt "$maxk" ] && L=$(assemble_left "$maxk")
fi

if [ -z "$R" ]; then
  printf '%s' "$L"
else
  gap=$(( cols - $(vislen "$L") - rvis ))
  if [ "$cols" -gt 0 ] && [ "$gap" -ge 2 ]; then
    printf '%s%*s%s' "$L" "$gap" "" "$R"          # right-align the tail
  else
    printf '%s%s%s' "$L" "$sep" "$R"              # too narrow: flow inline
  fi
fi
