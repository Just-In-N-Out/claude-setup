#!/bin/bash
# Scheduled Hermes backup to an off-machine synced folder. Keeps the newest $KEEP of each archive.
# Silent on success; one line on failure (a no_agent cron job delivers stdout verbatim).
# Install: copy to $HERMES_HOME/scripts/, chmod +x, run once by hand, then schedule with
# cronjob_manage(action=create, schedule="every 3d", script="<name>.sh", no_agent=true, deliver="<platform>").
set -uo pipefail

HERMES=/ABSOLUTE/PATH/TO/hermes        # `command -v hermes`; the scheduler's PATH may lack it
DEST="$HOME/Library/Mobile Documents/com~apple~CloudDocs/Hermes Backups"   # iCloud Drive (macOS)
KEEP=3
TS=$(date +%Y-%m-%d-%H%M%S)
LOG="$HOME/.hermes/logs/scheduled_backup.log"

fail() { echo "Hermes backup FAILED: $1 (log: $LOG)"; exit 1; }

mkdir -p "$DEST" || fail "cannot create $DEST"
{
  echo "=== $(date) ==="

  # 1) Full Hermes backup; -k prunes hermes-backup-*.zip in DEST to the newest $KEEP.
  "$HERMES" backup -o "$DEST/hermes-backup-$TS.zip" -k "$KEEP" || exit 11

  # 2) Optional: state Hermes backup doesn't cover (Claude Code memory/skills/settings).
  if [ -d "$HOME/.claude" ]; then
    cd "$HOME/.claude" || exit 12
    ITEMS=()
    for p in CLAUDE.md settings.json skills plans projects/*/memory; do [ -e "$p" ] && ITEMS+=("$p"); done
    tar -czf "$DEST/claude-code-$TS.tar.gz" "${ITEMS[@]}" || exit 13
    ls -1t "$DEST"/claude-code-*.tar.gz 2>/dev/null | tail -n +$((KEEP + 1)) | while read -r f; do rm -f "$f"; done
  fi
  echo "ok"
} >>"$LOG" 2>&1
rc=$?

case $rc in
  0) exit 0 ;;
  11) fail "hermes backup step" ;;
  12) fail "~/.claude not readable" ;;
  13) fail "Claude Code archive step" ;;
  *) fail "exit code $rc" ;;
esac
