#!/usr/bin/env bash
# Tests for ../dream-notice.sh (story dream-pass, AC31). Every test uses its own fake $HOME.
#   bash ~/.claude/hooks/tests/dream-notice.test.sh            all tests, numbered TAP
#   bash ~/.claude/hooks/tests/dream-notice.test.sh <name>...  only those
set -uo pipefail
HOOK="$(cd "$(dirname "$0")/.." && pwd)/dream-notice.sh"
ROOT=$(mktemp -d "${TMPDIR:-/tmp}/dream-notice-test.XXXX")
trap 'rm -rf "$ROOT"' EXIT

problem() { echo "#  FAIL: $*"; bad=1; }
# stdin from a here-string, not a pipe: the hook never reads it, and a writer it outlives dies of SIGPIPE (rc=141 under load)
start() { out=$(HOME="$1" bash "$HOOK" 2>&1 <<<'{"hook_event_name":"SessionStart","source":"startup","session_id":"s"}'); rc=$?; }
msg() { jq -r '.systemMessage // empty' <<<"$out" 2>/dev/null; }
last_run() { printf '%s' "$2" >"$1/.claude/dream/local/last-run.json"; }

ac31_session_start_line_reports_the_last_dream() {
  bad=0
  local H="$ROOT/home"
  mkdir -p "$H/.claude/dream/local"
  # no file yet: nothing
  start "$H"
  [ "$rc" = 0 ] && [ -z "$out" ] || problem "missing file: rc=$rc out=$out"
  # a finished run: one line with what changed, the commit and the list, shown once
  last_run "$H" '{"run":"r1","time":"2026-11-10T05:00-05:00","mode":"live","result":"changed","commit":"a1b2c3d","files":3,"findings":5,"list_open":2,"push_pending":false,"reason":""}'
  start "$H"
  [ "$(msg)" = "Dream 2026-11-10 05:00: changed 3 files from 5 findings (a1b2c3d), 2 items on your list. Log: ~/.claude/dream/dream-log.md" ] \
    || problem "changed: [$out]"
  [ "$rc" = 0 ] || problem "rc=$rc"
  start "$H"
  [ -z "$out" ] || problem "shown twice: [$out]"
  # a failed run: shown at every start until a run succeeds
  last_run "$H" '{"run":"r2","time":"2026-11-10T17:00-05:00","mode":"live","result":"failed","commit":null,"files":0,"findings":0,"list_open":2,"push_pending":false,"reason":"sync.sh pull reported a CONFLICT"}'
  local i
  for i in 1 2 3; do
    start "$H"
    case "$(msg)" in "Dream 2026-11-10 17:00 FAILED: sync.sh pull reported a CONFLICT."*) ;; *) problem "failed, start $i: [$out]" ;; esac
  done
  last_run "$H" '{"run":"r3","time":"2026-11-11T05:00-05:00","mode":"live","result":"stopped","commit":null,"files":0,"findings":1,"list_open":2,"push_pending":false,"reason":"the checking agent said no"}'
  start "$H"; start "$H"
  case "$(msg)" in *"FAILED: the checking agent said no"*) ;; *) problem "stopped: [$out]" ;; esac
  last_run "$H" '{"run":"r4","time":"2026-11-11T17:00-05:00","mode":"live","result":"changed","commit":"bbbbbbb","files":1,"findings":1,"list_open":0,"push_pending":true,"reason":""}'
  start "$H"
  case "$(msg)" in "Dream 2026-11-11 17:00: changed 1 file from 1 finding (bbbbbbb), 0 items on your list."*"push"*) ;; *) problem "after a success: [$out]" ;; esac
  start "$H"
  [ -z "$out" ] || problem "the success shown twice"
  # a dry run says so and where the diff is
  last_run "$H" '{"run":"r5","time":"2026-11-12T05:00-05:00","mode":"dry-run","result":"dry-run","commit":null,"files":2,"findings":3,"list_open":0,"push_pending":false,"reason":"","diff":"/c/dream/r5/would-apply.diff"}'
  start "$H"
  case "$(msg)" in "Dream 2026-11-12 05:00 (dry run): would change 2 files from 3 findings; nothing went live. Diff: /c/dream/r5/would-apply.diff"*) ;; *) problem "dry run: [$out]" ;; esac
  # broken file, or no local/ folder (the Mac): nothing, exit 0
  printf '{"run": ' >"$H/.claude/dream/local/last-run.json"
  start "$H"
  [ "$rc" = 0 ] && [ -z "$out" ] || problem "broken file: rc=$rc out=$out"
  printf '[1,2]' >"$H/.claude/dream/local/last-run.json"
  start "$H"
  [ "$rc" = 0 ] && [ -z "$out" ] || problem "not an object: rc=$rc out=$out"
  local M="$ROOT/mac"
  mkdir -p "$M/.claude"
  start "$M"
  [ "$rc" = 0 ] && [ -z "$out" ] && [ ! -e "$M/.claude/dream" ] || problem "mac: rc=$rc out=$out"
  return "$bad"
}

# ruling R1-1: sessions the run could not read are named in its line (and a stop they caused is not doubled)
dream_unreadable_sessions_show_in_the_session_start_line() {
  bad=0
  local H="$ROOT/home-unread"
  mkdir -p "$H/.claude/dream/local"
  last_run "$H" '{"run":"u1","time":"2026-11-10T05:00-05:00","mode":"live","result":"changed","commit":"a1b2c3d","files":1,"findings":1,"list_open":0,"push_pending":false,"reason":"","unreadable":["s-bad"]}'
  start "$H"
  case "$(msg)" in "Dream 2026-11-10 05:00: changed 1 file from 1 finding (a1b2c3d)"*" 1 session could not be read (unknown transcript shape)"*) ;; *) problem "one unreadable: [$out]" ;; esac
  last_run "$H" '{"run":"u2","time":"2026-11-10T17:00-05:00","mode":"live","result":"stopped","commit":null,"files":0,"findings":1,"list_open":0,"push_pending":false,"reason":"the checking agent said no","unreadable":["a","b"]}'
  start "$H"
  case "$(msg)" in *"FAILED: the checking agent said no."*" 2 sessions could not be read"*) ;; *) problem "two unreadable: [$out]" ;; esac
  last_run "$H" '{"run":"u3","time":"2026-11-11T05:00-05:00","mode":"live","result":"failed","commit":null,"files":0,"findings":0,"list_open":0,"push_pending":false,"reason":"every session with new lines has an unknown transcript shape: x","unreadable":["a"]}'
  start "$H"
  case "$(msg)" in *"could not be read"*) problem "said twice: [$out]" ;; *"FAILED: every session with new lines has an unknown transcript shape"*) ;; *) problem "all unreadable: [$out]" ;; esac
  last_run "$H" '{"run":"u4","time":"2026-11-11T17:00-05:00","mode":"live","result":"changed","commit":"c","files":1,"findings":1,"list_open":0,"push_pending":false,"reason":""}'
  start "$H"
  case "$(msg)" in *"could not be read"*) problem "none unreadable: [$out]" ;; "Dream 2026-11-11 17:00: changed"*) ;; *) problem "old record: [$out]" ;; esac
  return "$bad"
}

# R1-12: while the dream is off a failure does not promise a next run; after a run that found nothing new it is gone
dream_a_failed_run_says_the_dream_is_off_and_clears_after_a_nothing_new_run() {
  bad=0
  local H="$ROOT/home-off"
  mkdir -p "$H/.claude/dream/local"
  last_run "$H" '{"run":"f1","time":"2026-11-10T05:00-05:00","mode":"live","result":"failed","commit":null,"files":0,"findings":0,"list_open":0,"push_pending":false,"reason":"GitHub unreachable"}'
  start "$H"
  case "$(msg)" in *"FAILED: GitHub unreachable."*) ;; *) problem "failed: [$out]" ;; esac
  printf 'off\n' >"$H/.claude/dream/local/mode"
  start "$H"
  case "$(msg)" in *"next run tries again"*) problem "mode off promises a run: [$out]" ;;
    *"FAILED: GitHub unreachable. Nothing went live; the dream is off, so no run tries again"*) ;; *) problem "mode off: [$out]" ;; esac
  printf 'live\n' >"$H/.claude/dream/local/mode"
  start "$H"
  case "$(msg)" in *"FAILED: GitHub unreachable. Nothing went live; the next run tries again."*) ;; *) problem "live again: [$out]" ;; esac
  last_run "$H" '{"run":"n1","time":"2026-11-10T17:00-05:00","mode":"live","result":"nothing-new","cleared":"f1","commit":null,"files":0,"findings":0,"list_open":0,"push_pending":false,"reason":""}'
  start "$H"
  [ "$rc" = 0 ] && [ -z "$out" ] || problem "nothing new: rc=$rc out=$out"
  return "$bad"
}

TESTS=(ac31_session_start_line_reports_the_last_dream dream_unreadable_sessions_show_in_the_session_start_line
  dream_a_failed_run_says_the_dream_is_off_and_clears_after_a_nothing_new_run)
sel=("$@")
[ ${#sel[@]} -gt 0 ] || sel=("${TESTS[@]}")
for t in "${sel[@]}"; do
  declare -F "$t" >/dev/null || { echo "Bail out! no test named $t"; exit 1; }
done
echo "1..${#sel[@]}"
n=0 failed=0
for t in "${sel[@]}"; do
  n=$((n + 1))
  if "$t"; then echo "ok $n - $t"; else echo "not ok $n - $t"; failed=$((failed + 1)); fi
done
echo "# passed $((n - failed)), failed $failed"
[ "$failed" = 0 ]
