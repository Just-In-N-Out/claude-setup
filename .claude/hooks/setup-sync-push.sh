#!/usr/bin/env bash
# Pushes setup edits after a turn, in the background, so a turn never waits on the network.
# Tool-neutral: Codex runs it today (through ~/.codex/hooks/codex-hooks.sh); Claude Code can
# register the same script on Stop later. sync.sh's lock keeps it safe when another session
# syncs at the same moment: the worker waits and retries.
#   setup-sync-push.sh stop     start the detached worker and return at once, printing nothing
#   setup-sync-push.sh notes    print open problems (CONFLICT, secret found, failed, busy), or nothing
#   setup-sync-push.sh worker   (internal) if `sync.sh changed`, run sync.sh; retry while another
#                               sync holds the lock; record the outcome as flags
# State: ~/.claude/hooks/state/setup-sync-push/ (never synced). Always exits 0.
# Tests: ~/.claude/setup/codex/codex-parity.test.sh (ac14, ac16, ac20)
set -uo pipefail
SYNC=${SETUP_SYNC_SCRIPT:-$HOME/.claude/setup/sync.sh}
GD=${SETUP_SYNC_GIT_DIR:-$HOME/.claude-setup.git}
STATE=${SETUP_SYNC_PUSH_STATE:-$HOME/.claude/hooks/state/setup-sync-push}
TRIES=${SETUP_SYNC_PUSH_TRIES:-8}   # retries while another sync holds the lock
WAIT=${SETUP_SYNC_PUSH_WAIT:-15}    # seconds between them
self="$(cd "$(dirname "$0")" && pwd)/$(basename "$0")"

record() { # record <rc> <output> <tries>: one flag file per open problem
  local tail when; tail=$(printf '%s\n' "$2" | tail -n 15); when=$(date '+%F %T')
  if [ "$1" = 0 ]; then rm -f "$STATE"/*.flag; return 0; fi
  case $2 in
    *CONFLICT*) printf 'Setup sync CONFLICT (%s) while pushing edits:\n%s\nMerge both versions so both meanings survive (never drop the other machine'"'"'s edit), then run ~/.claude/setup/sync.sh. If you cannot merge safely, tell Justin first.\n' "$when" "$tail" >"$STATE/conflict.flag" ;;
    *"gitleaks found"*) printf 'Setup sync BLOCKED (%s): gitleaks found what looks like a secret; nothing was pushed.\n%s\nTell Justin; remove the secret, then run ~/.claude/setup/sync.sh.\n' "$when" "$tail" >"$STATE/blocked.flag" ;;
    *"another sync is running"*) printf 'Setup sync skipped (%s): another sync held the lock through %s tries. Run ~/.claude/setup/sync.sh when it has finished.\n' "$when" "$3" >"$STATE/busy.flag" ;;
    *) printf 'Setup sync FAILED (%s, exit %s):\n%s\nTell Justin; the edits are safe on this machine.\n' "$when" "$1" "$tail" >"$STATE/failed.flag" ;;
  esac
}

LOCK="$STATE/worker.lock"   # global on purpose: the EXIT trap runs after worker() has returned
worker() {
  local out rc tries
  mkdir -p "$STATE" || return 0
  if ! mkdir "$LOCK" 2>/dev/null; then
    if [ -n "$(find "$LOCK" -maxdepth 0 -mmin +15 2>/dev/null)" ]; then rm -rf "$LOCK"; mkdir "$LOCK" || return 0
    else : >"$STATE/rerun"; return 0; fi   # a worker is running: it goes round once more
  fi
  trap 'rm -rf "$LOCK"' EXIT
  while :; do
    rm -f "$STATE/rerun"
    if bash "$SYNC" changed >/dev/null 2>&1; then
      tries=0
      while :; do
        out=$(bash "$SYNC" 2>&1); rc=$?
        case $rc in 0) break ;; esac
        case $out in *"another sync is running"*) ;; *) break ;; esac
        [ "$tries" -lt "$TRIES" ] || break
        tries=$((tries + 1)); sleep "$WAIT"
      done
      record "$rc" "$out" "$tries"
      printf '%s rc=%s\n%s\n' "$(date '+%F %T')" "$rc" "$out" >>"$STATE/worker.log"
    fi
    [ -e "$STATE/rerun" ] || break
  done
  if [ "$(wc -c <"$STATE/worker.log" 2>/dev/null || echo 0)" -gt 1048576 ]; then   # keep the log small
    tail -n 200 "$STATE/worker.log" >"$STATE/worker.log.tmp" && mv -f "$STATE/worker.log.tmp" "$STATE/worker.log"
  fi
}

case ${1:-} in
  stop)
    cat >/dev/null 2>&1
    [ -d "$GD" ] && [ -f "$SYNC" ] && mkdir -p "$STATE" 2>/dev/null || exit 0
    # Detach the worker into its own session before returning: perl forks, the child calls setsid()
    # and only then lets the parent exit. A plain `perl -e setsid … &` lost the race when Codex killed
    # the hook's process group right after it returned (the worker died before setsid ran).
    perl -MPOSIX -e 'pipe(my $r, my $w) or exit 1; my $p = fork; exit 1 unless defined $p;
      if ($p) { close $w; my $x = <$r>; exit 0 } close $r; POSIX::setsid(); close $w; exec @ARGV or exit 127' \
      bash "$self" worker </dev/null >>"$STATE/worker.log" 2>&1
    ;;
  notes) for f in "$STATE"/*.flag; do [ -f "$f" ] && { cat "$f"; echo; }; done ;;
  worker) worker ;;
esac
exit 0
