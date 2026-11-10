#!/usr/bin/env bash
# The dream's write ledger (~/.claude/dream/DREAM.md section 11). PostToolUse on Write|Edit|NotebookEdit:
# when the real path written (every link resolved) is a file the dream may edit, append one row
# {"path","sha256","session","agent","time"} to ~/.claude/dream/local/ledger.jsonl, under flock.
# It records on purpose more than the dream's allowlist (conf/targets.txt is the real list):
# ~/.claude/CLAUDE.md, any CLAUDE.md outside ~/Leorna/, and anything under ~/.claude/projects/*/memory/,
# ~/.claude/project-docs/, ~/.hermes/skills/ or ~/.hermes/skills-library/skills/. Paths are $HOME-relative.
# Silent on a machine without ~/.claude/dream/local/ (the Mac). Any bad input or failure prints nothing
# and exits 0: this hook must never block a tool call. Over 5 MB the ledger keeps its last 20,000 rows.
# Tests: tests/dream-ledger.test.sh
LOCAL="$HOME/.claude/dream/local"
[ -d "$LOCAL" ] || exit 0
command -v jq >/dev/null 2>&1 || exit 0
fields=$(jq -r 'if type == "object" then [(.tool_input.file_path // .tool_input.notebook_path // "" | strings),
  (.session_id // "" | tostring), (.agent_id // "" | tostring), (.cwd // "" | tostring)] | join("\u001f") else empty end' \
  2>/dev/null) || exit 0
IFS=$'\x1f' read -r f session agent cwd <<<"$fields"
[ -n "$f" ] || exit 0
case "$f" in /*) ;; *) [ -n "$cwd" ] || exit 0; f="$cwd/$f" ;; esac
real=$(realpath -e -- "$f" 2>/dev/null) || exit 0
[ -f "$real" ] || exit 0
home=$(cd "$HOME" 2>/dev/null && pwd -P) || exit 0
leorna=$(cd "$HOME/Leorna" 2>/dev/null && pwd -P) || leorna="$home/Leorna"
case "$real/" in "$leorna/"* | "$home/Leorna/"*) exit 0 ;; esac
case "$real" in "$home"/*) rel=${real#"$home"/} ;; *) exit 0 ;; esac
case "$rel" in
  .claude/CLAUDE.md | .claude/projects/*/memory/* | .claude/project-docs/* | .hermes/skills/* | \
    .hermes/skills-library/skills/* | CLAUDE.md | */CLAUDE.md) ;;
  *) exit 0 ;;
esac
sha=$(sha256sum <"$real" 2>/dev/null | cut -d' ' -f1) || exit 0
[ -n "$sha" ] || exit 0
row=$(jq -cn --arg p "$rel" --arg s "$sha" --arg se "$session" --arg a "$agent" --arg t "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  '{path: $p, sha256: $s, session: $se, agent: $a, time: $t}' 2>/dev/null) || exit 0
L="$LOCAL/ledger.jsonl"
{
  flock -w 4 9 || exit 0
  printf '%s\n' "$row" >&9
  if [ "$(wc -c <"$L" 2>/dev/null || echo 0)" -gt 5242880 ]; then
    tail -n 20000 "$L" >"$L.tmp" 2>/dev/null && cat "$L.tmp" >"$L" 2>/dev/null
    rm -f "$L.tmp"
  fi
} 9>>"$L" 2>/dev/null
exit 0
