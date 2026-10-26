#!/bin/bash
# Merge lock for a repo's main folder, so only one agent merges into main at a time.
#   merge_lock.sh acquire <repo> <owner>   wait (up to 20 min) for the lock, then take it
#   merge_lock.sh release <repo> <owner>   release it (only if <owner> holds it)
#   merge_lock.sh status  <repo>           show who holds it
# Exit codes: 0 ok · 2 stale lock (held > 60 min; a person must decide) · 3 repo busy
# (a merge/rebase is in progress or main isn't checked out) · 4 timed out · 5 not the owner.
set -u
cmd="${1:-}"; repo="${2:-}"; owner="${3:-}"
[ -n "$cmd" ] && [ -d "$repo/.git" ] || { echo "usage: $0 acquire|release|status <repo> [owner]"; exit 64; }
git_dir="$(git -C "$repo" rev-parse --absolute-git-dir)"
lock="$git_dir/hermes-merge.lock"

holder() { cat "$lock/owner" 2>/dev/null || echo "unknown"; }
age_min() { echo $(( ( $(date +%s) - $(stat -f %m "$lock" 2>/dev/null || date +%s) ) / 60 )); }

busy() {  # another merge, rebase or commit running in the main folder?
  for f in MERGE_HEAD rebase-merge rebase-apply CHERRY_PICK_HEAD index.lock; do
    [ -e "$git_dir/$f" ] && { echo "BUSY: $f present in $git_dir (another merge/rebase/commit is running)"; return 0; }
  done
  b="$(git -C "$repo" branch --show-current)"
  [ "$b" = "main" ] || { echo "BUSY: main folder is on '$b', not main"; return 0; }
  return 1
}

case "$cmd" in
  acquire)
    [ -n "$owner" ] || { echo "owner required"; exit 64; }
    for i in $(seq 1 40); do
      if mkdir "$lock" 2>/dev/null; then
        printf '%s since %s (pid %s)\n' "$owner" "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$$" > "$lock/owner"
        if busy; then rm -rf "$lock"; exit 3; fi
        echo "LOCKED by $owner"; exit 0
      fi
      a="$(age_min)"
      if [ "$a" -ge 60 ]; then echo "STALE: lock held by $(holder) for ${a} min; ask Justin before removing $lock"; exit 2; fi
      [ "$i" = 1 ] && echo "waiting: lock held by $(holder) (${a} min)"
      sleep 30
    done
    echo "TIMEOUT: still held by $(holder) after 20 min"; exit 4 ;;
  release)
    if [ -d "$lock" ] && grep -q "^$owner since" "$lock/owner" 2>/dev/null; then rm -rf "$lock"; echo "released"; exit 0; fi
    [ -d "$lock" ] || { echo "not locked"; exit 0; }
    echo "NOT OWNER: held by $(holder)"; exit 5 ;;
  status)
    if [ -d "$lock" ]; then echo "held by $(holder) ($(age_min) min)"; else echo "free"; fi
    busy || true ;;
  *) echo "unknown command $cmd"; exit 64 ;;
esac
