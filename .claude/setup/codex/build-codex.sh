#!/usr/bin/env bash
# Builds the Codex files that come from synced sources, so each has one source of truth:
#   ~/.codex/AGENTS.md                agents-header.md (pipeline model filled in) + ~/.claude/CLAUDE.md verbatim
#   ~/.codex/agents/pipeline-*.toml   their model lines, from pipeline-model.toml
# Edit the sources, never the outputs. sync.sh runs this on every sync and after a pull; the Codex
# session-start hook runs it when AGENTS.md is stale.
#   build-codex.sh           write whatever differs; silent when current
#   build-codex.sh --check   exit 0 when everything is current, 1 when not (no writes)
#   build-codex.sh --hash    print the CLAUDE.md git hash recorded in AGENTS.md (empty if none)
# Env: CODEX_HOME (default ~/.codex). Tests: codex-parity.test.sh (ac1, ac3, ac21).
set -euo pipefail
DIR=$(cd "$(dirname "$0")" && pwd)
CH=${CODEX_HOME:-$HOME/.codex}
HEADER="$DIR/agents-header.md"
SETTING="$DIR/pipeline-model.toml"
RULES=${CODEX_BUILD_RULES:-$HOME/.claude/CLAUDE.md}
OUT="$CH/AGENTS.md"
MARK='<!-- BEGIN ~/.claude/CLAUDE.md verbatim, git-hash '
if [ "${1:-}" = --hash ]; then
  sed -n "s|^$MARK\\([0-9a-f]*\\) -->\$|\\1|p" "$OUT" 2>/dev/null | head -1; exit 0
fi
setting() { sed -n "s/^$1 = \"\\(.*\\)\"\$/\\1/p" "$SETTING" | head -1; }
MODEL=$(setting model); EFFORT=$(setting model_reasoning_effort)
[ -n "$MODEL" ] && [ -n "$EFFORT" ] && [ -f "$HEADER" ] && [ -f "$RULES" ] \
  || { echo "build-codex: need $HEADER, $RULES and model + model_reasoning_effort in $SETTING" >&2; exit 2; }
agents_md() {
  sed -e "s/@PIPELINE_MODEL@/$MODEL/g" -e "s/@PIPELINE_EFFORT@/$EFFORT/g" "$HEADER"
  printf '\n%s%s -->\n\n' "$MARK" "$(git hash-object "$RULES")"
  cat "$RULES"
  printf '\n<!-- END ~/.claude/CLAUDE.md -->\n'
}
role() { sed -e "s/^model = \".*\"\$/model = \"$MODEL\"/" -e "s/^model_reasoning_effort = \".*\"\$/model_reasoning_effort = \"$EFFORT\"/" "$1"; }
write() { local tmp; tmp=$(mktemp "$1.XXXXXX"); cat >"$tmp"; mv -f "$tmp" "$1"; }
stale=0
agents_md | cmp -s - "$OUT" 2>/dev/null || stale=1
for f in "$CH"/agents/pipeline-*.toml; do [ -f "$f" ] || continue; role "$f" | cmp -s - "$f" || stale=1; done
case ${1:-} in
  --check) exit "$stale" ;;
  '') ;;
  *) echo "usage: build-codex.sh [--check|--hash]" >&2; exit 2 ;;
esac
[ "$stale" = 1 ] || exit 0
mkdir -p "$CH"
agents_md | cmp -s - "$OUT" 2>/dev/null || agents_md | write "$OUT"
for f in "$CH"/agents/pipeline-*.toml; do [ -f "$f" ] || continue; role "$f" | cmp -s - "$f" || role "$f" | write "$f"; done
