#!/usr/bin/env bash
# Tests for ../dream-ledger.sh (story dream-pass, AC25). Every test uses its own fake $HOME.
#   bash ~/.claude/hooks/tests/dream-ledger.test.sh            all tests, numbered TAP
#   bash ~/.claude/hooks/tests/dream-ledger.test.sh <name>...  only those
set -uo pipefail
HOOK="$(cd "$(dirname "$0")/.." && pwd)/dream-ledger.sh"
ROOT=$(mktemp -d "${TMPDIR:-/tmp}/dream-ledger-test.XXXX")
trap 'rm -rf "$ROOT"' EXIT

problem() { echo "#  FAIL: $*"; bad=1; }

# fire <home> <json> -> hook stdout in $out, exit code in $rc
fire() {
  out=$(printf '%s' "$2" | HOME="$1" bash "$HOOK" 2>&1)
  rc=$?
}

# input <file_path> [session] [agent_id] [tool] [cwd]: the shape Claude Code sends (cwd always set)
input() { jq -nc --arg f "$1" --arg s "${2:-sess-1}" --arg a "${3:-}" --arg t "${4:-Write}" --arg c "${5:-/home/x/work}" \
  '{hook_event_name: "PostToolUse", tool_name: $t, session_id: $s, cwd: $c, tool_input: {file_path: $f}} + (if $a == "" then {} else {agent_id: $a} end)'; }

rows() { [ -f "$1/.claude/dream/local/ledger.jsonl" ] && cat "$1/.claude/dream/local/ledger.jsonl" || true; }

ac25_ledger_records_target_edits_through_links_and_fails_open() {
  bad=0
  local H="$ROOT/home"
  mkdir -p "$H/.claude/dream/local" "$H/.claude/projects/-Users-x-proj/memory" "$H/.claude/projects/-home-x-proj" \
    "$H/.hermes/skills-library/skills/libsk" "$H/.hermes/skills/sd/own" "$H/.claude/skills" "$H/work/proj/src" \
    "$H/Leorna/client" "$H/.claude/project-docs/proj"
  ln -s ../-Users-x-proj/memory "$H/.claude/projects/-home-x-proj/memory"
  ln -s "$H/.hermes/skills-library/skills/libsk" "$H/.claude/skills/libsk"
  echo "global" >"$H/.claude/CLAUDE.md"
  echo "lib skill" >"$H/.hermes/skills-library/skills/libsk/SKILL.md"
  echo "own skill" >"$H/.hermes/skills/sd/own/SKILL.md"
  echo "note" >"$H/.claude/projects/-Users-x-proj/memory/note.md"
  echo "project rules" >"$H/work/proj/CLAUDE.md"
  echo "copy" >"$H/.claude/project-docs/proj/CLAUDE.md"
  echo "code" >"$H/work/proj/src/a.js"
  echo "leorna rules" >"$H/Leorna/client/CLAUDE.md"
  # targets, directly and through links: one row each, with the real path
  local want=(".claude/CLAUDE.md" ".hermes/skills-library/skills/libsk/SKILL.md" ".hermes/skills/sd/own/SKILL.md"
    ".claude/projects/-Users-x-proj/memory/note.md" "work/proj/CLAUDE.md" ".claude/project-docs/proj/CLAUDE.md")
  local via=("$H/.claude/CLAUDE.md" "$H/.claude/skills/libsk/SKILL.md" "$H/.hermes/skills/sd/own/SKILL.md"
    "$H/.claude/projects/-home-x-proj/memory/note.md" "$H/work/proj/CLAUDE.md" "$H/.claude/project-docs/proj/CLAUDE.md")
  local i
  for i in "${!via[@]}"; do
    fire "$H" "$(input "${via[$i]}" "sess-$i" "agent-$i" Edit)"
    [ "$rc" = 0 ] && [ -z "$out" ] || problem "${via[$i]}: rc=$rc out=$out"
  done
  local got
  got=$(rows "$H" | jq -r '.path' | tr '\n' ' ')
  [ "$got" = "$(printf '%s ' "${want[@]}")" ] || problem "paths: got [$got]"
  [ "$(rows "$H" | jq -r .agent | tr '\n' ' ')" = "agent-0 agent-1 agent-2 agent-3 agent-4 agent-5 " ] || problem "agents"
  local r
  r=$(rows "$H" | sed -n 1p)
  jq -e --arg sha "$(sha256sum <"$H/.claude/CLAUDE.md" | cut -d' ' -f1)" \
    '.sha256 == $sha and .session == "sess-0" and .agent == "agent-0" and (.time | test("^20[0-9-]+T"))' <<<"$r" >/dev/null \
    || problem "first row: $r"
  [ "$(rows "$H" | jq -s 'map(keys) | unique')" = "$(jq -nc '[["agent","path","session","sha256","time"]]' | jq .)" ] \
    || problem "row keys"
  # the main session (no agent_id), and a path relative to its cwd: the fields stay in place
  fire "$H" "$(input .claude/CLAUDE.md main-sess "" Write "$H")"
  [ "$rc" = 0 ] && [ -z "$out" ] || problem "main session: rc=$rc out=$out"
  jq -e '.path == ".claude/CLAUDE.md" and .session == "main-sess" and .agent == ""' <<<"$(rows "$H" | tail -n 1)" >/dev/null \
    || problem "main-session row: $(rows "$H" | tail -n 1)"
  # any other path, Leorna's CLAUDE.md, a missing file: no row, no output, exit 0
  local n0
  n0=$(rows "$H" | wc -l)
  for f in "$H/work/proj/src/a.js" "$H/Leorna/client/CLAUDE.md" "$H/.claude/settings.json" "$H/nowhere/x.md"; do
    fire "$H" "$(input "$f")"
    [ "$rc" = 0 ] && [ -z "$out" ] || problem "$f: rc=$rc out=$out"
  done
  # bad input
  for j in 'not json' '' '{}' '{"tool_input": {}}' '{"tool_input": {"file_path": 7}}'; do
    fire "$H" "$j"
    [ "$rc" = 0 ] && [ -z "$out" ] || problem "bad input [$j]: rc=$rc out=$out"
  done
  [ "$(rows "$H" | wc -l)" = "$n0" ] || problem "rows were added for non-targets or bad input"
  # a machine without ~/.claude/dream/local/ (the Mac): silent, nothing written
  local M="$ROOT/mac"
  mkdir -p "$M/.claude"
  echo "global" >"$M/.claude/CLAUDE.md"
  fire "$M" "$(input "$M/.claude/CLAUDE.md")"
  [ "$rc" = 0 ] && [ -z "$out" ] && [ ! -e "$M/.claude/dream" ] || problem "mac: rc=$rc out=$out"
  return "$bad"
}

TESTS=(ac25_ledger_records_target_edits_through_links_and_fails_open)
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
