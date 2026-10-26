#!/bin/bash
# Back up Hermes (+ Claude Code memory/skills) to iCloud Drive. Keeps the newest 3 of each.
# Silent on success; prints an error on failure (the cron job delivers that to WhatsApp).
set -uo pipefail

HERMES=/Users/justin/.hermes/hermes-agent/.hermes/bin/hermes
DEST="$HOME/Library/Mobile Documents/com~apple~CloudDocs/Hermes Backups"
KEEP=3
TS=$(date +%Y-%m-%d-%H%M%S)
LOG="$HOME/.hermes/logs/backup_to_icloud.log"

fail() { echo "Hermes backup FAILED: $1 (log: ~/.hermes/logs/backup_to_icloud.log)"; exit 1; }

mkdir -p "$DEST" || fail "cannot create $DEST"
{
  echo "=== $(date) ==="

  # 1) Full Hermes backup (skills, memory, config, .env, auth, sessions, cron). Prunes to newest $KEEP.
  "$HERMES" backup -o "$DEST/hermes-backup-$TS.zip" -k "$KEEP" || exit 11

  # 2) Claude Code: CLAUDE.md, settings, skills, plans, per-project memory (incl. Leorna).
  cd "$HOME/.claude" || exit 12
  ITEMS=()
  for p in CLAUDE.md settings.json skills plans projects/*/memory; do [ -e "$p" ] && ITEMS+=("$p"); done
  tar -czf "$DEST/claude-code-$TS.tar.gz" "${ITEMS[@]}" || exit 13
  ls -1t "$DEST"/claude-code-*.tar.gz 2>/dev/null | tail -n +$((KEEP + 1)) | while read -r f; do rm -f "$f"; done
  echo "ok"
} >>"$LOG" 2>&1
rc=$?

case $rc in
  0) exit 0 ;;
  11) fail "hermes backup step" ;;
  12) fail "~/.claude not found" ;;
  13) fail "Claude Code archive step" ;;
  *) fail "exit code $rc" ;;
esac
