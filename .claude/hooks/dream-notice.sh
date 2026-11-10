#!/usr/bin/env bash
# The dream's session-start line (~/.claude/dream/DREAM.md section 10). SessionStart, matcher startup:
# reads ~/.claude/dream/local/last-run.json and prints one systemMessage: what the last dream changed,
# its commit and how many items wait on Justin's list. A finished run (or a dry run) is shown once (its
# id goes in local/last-run.shown); a failed or stopped run is shown at every start until a run succeeds
# (a run that finds nothing new writes result nothing-new, which shows nothing) or the mode is off.
# A missing or broken file, or a machine without ~/.claude/dream/local/ (the Mac): nothing, exit 0.
# Tests: tests/dream-notice.test.sh
LOCAL="$HOME/.claude/dream/local"
F="$LOCAL/last-run.json"
[ -f "$F" ] || exit 0
command -v jq >/dev/null 2>&1 || exit 0
fields=$(jq -r 'if type == "object" then [(.run // "" | tostring), (.time // "" | tostring), (.result // "" | tostring),
  (.commit // "" | tostring), (.files // 0 | tostring), (.findings // 0 | tostring), (.list_open // 0 | tostring),
  (.push_pending // false | tostring), (.reason // "" | tostring | gsub("[\u001f\n]"; " ")), (.diff // "" | tostring),
  (.unreadable // [] | if type == "array" then length else 0 end | tostring)]
  | join("\u001f") else empty end' "$F" 2>/dev/null) || exit 0
[ -n "$fields" ] || exit 0
IFS=$'\x1f' read -r run time result commit files findings list push reason diff unreadable <<<"$fields"
[ -n "$run" ] || exit 0
when="${time:0:10} ${time:11:5}"
plural() { if [ "$1" = 1 ]; then printf '%s %s' "$1" "$2"; else printf '%s %ss' "$1" "$2"; fi; }
case "$result" in
  changed)
    m="Dream $when: changed $(plural "$files" file) from $(plural "$findings" finding) ($commit), $(plural "$list" item) on your list. Log: ~/.claude/dream/dream-log.md" ;;
  nothing-changed)
    m="Dream $when: read new work, changed no file ($commit), $(plural "$list" item) on your list. Log: ~/.claude/dream/dream-log.md" ;;
  dry-run)
    m="Dream $when (dry run): would change $(plural "$files" file) from $(plural "$findings" finding); nothing went live. Diff: $diff. To go live: ~/.claude/dream/bin/dream mode live" ;;
  failed | stopped)
    # switched off (dream mode off): no run is coming to try again, so the old failure is not shown (R1-12)
    [ "$(cat "$LOCAL/mode" 2>/dev/null)" = off ] && exit 0
    m="Dream $when FAILED: ${reason%.}. Nothing went live; the next run tries again. Log: ~/.claude/dream/dream-log.md; status: ~/.claude/dream/bin/dream status" ;;
  *) exit 0 ;;
esac
[ "$push" = true ] && m="$m The push is pending: the next sync.sh pushes it."
# sessions of an unknown transcript shape were not read (the reason already says so when they stopped the run)
case "$unreadable:$reason" in
  0:* | *"unknown transcript shape"*) ;;
  1:*) m="$m 1 session could not be read (unknown transcript shape); see the log and desktop.md." ;;
  *) m="$m $unreadable sessions could not be read (unknown transcript shape); see the log and desktop.md." ;;
esac
case "$result" in
  failed | stopped) ;;
  *)
    [ "$(cat "$LOCAL/last-run.shown" 2>/dev/null)" = "$run" ] && exit 0
    printf '%s\n' "$run" >"$LOCAL/last-run.shown" 2>/dev/null ;;
esac
jq -nc --arg m "$m" '{systemMessage: $m}' 2>/dev/null
exit 0
