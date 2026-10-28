#!/usr/bin/env bash
# Records real Codex hook payloads for the codex-parity tests (plan Task 2), through the probe home.
#   bash capture-payloads.sh [<fixtures dir>]   default: this checkout's .codex/hooks/tests/fixtures
# One tiny `codex exec` (gpt-6-luna at low, --dangerously-bypass-hook-trust) in a fake home with:
#   - a logging hook on every event: it saves stdin to <ts>-<Event>.json and writes
#     $HOME/hook-wrote-here (the fake home is outside the workspace root: proves hooks run unsandboxed);
#   - two SubagentStop loggers that block once each with a different word (how Codex merges two blocks);
#   - a capture_role agent file with model gpt-5.6-luna; an AGENTS.md holding a marker word.
# Writes the sanitized payloads (/FAKEHOME, /FAKEROOT, /CODEXHOME), the raw event stream and a
# findings.draft.txt with the mechanical answers to F1-F8; a person finishes findings.txt from it.
# Needs the probe home signed in (probe-lib.sh probe_ready). Never touches ~/.codex.
set -uo pipefail
HERE=$(cd "$(dirname "$0")" && pwd)
SRC=$(cd "$HERE/../../.." && pwd)
REAL_HOME=$HOME
ROOT=${CODEX_PARITY_TEST_ROOT:-$REAL_HOME/.cache/codex-parity-tests}
FIX=${1:-$SRC/.codex/hooks/tests/fixtures}
. "$HERE/probe-lib.sh"
CODEX_PROBE_MODEL=${CODEX_PROBE_MODEL:-gpt-6-luna}; PROBE_MODEL=$CODEX_PROBE_MODEL
CODEX_PROBE_EFFORT=${CODEX_PROBE_EFFORT:-low}; PROBE_EFFORT=$CODEX_PROBE_EFFORT

probe_ready || exit 1
mkdir -p "$ROOT" "$FIX"
S=$(mktemp -d "$ROOT/capture.XXXXXX"); H="$S/home"; OUT="$S/payloads"; RUN="$S/run"
mkdir -p "$H/.codex/agents" "$H/work" "$S/tmp" "$OUT" "$RUN"

cat >"$H/log-hook.sh" <<'EOF'
#!/usr/bin/env bash
# log-hook.sh <Event> [block-word]: save the payload; with a word, block a capture_role stop once
ev=$1; word=${2:-}; out=__OUT__
in=$(cat)
ts=$(perl -MTime::HiRes=time -e 'printf "%.6f", time')
if [ -n "$word" ]; then printf '%s' "$in" >"$out/$ts-$ev-$word.json"; else printf '%s' "$in" >"$out/$ts-$ev.json"; fi
: >"$HOME/hook-wrote-here"
[ -n "$word" ] || exit 0
[ "$(jq -r '.agent_type // empty' <<<"$in")" = capture_role ] || exit 0
[ "$(jq -r '.stop_hook_active // false' <<<"$in")" = false ] || exit 0
mkdir "$out/blocked-$word" 2>/dev/null || exit 0
jq -nc --arg w "$word" '{decision: "block", reason: ("Add the word " + $w + " to your final answer, then finish.")}'
EOF
sed -i.bak "s|__OUT__|\"$OUT\"|" "$H/log-hook.sh" && rm -f "$H/log-hook.sh.bak"
chmod +x "$H/log-hook.sh"

hook() { jq -nc --arg c "bash $H/log-hook.sh $1${2:+ $2}" '{type: "command", command: $c, timeout: 10}'; }
jq -n --argjson ss "$(hook SessionStart)" --argjson up "$(hook UserPromptSubmit)" \
  --argjson pre "$(hook PreToolUse)" --argjson post "$(hook PostToolUse)" \
  --argjson sst "$(hook SubagentStart)" --argjson ssa "$(hook SubagentStop BLOCKWORD-ALPHA)" \
  --argjson ssb "$(hook SubagentStop BLOCKWORD-BETA)" --argjson st "$(hook Stop)" \
  '{hooks: {SessionStart: [{hooks: [$ss]}], UserPromptSubmit: [{hooks: [$up]}], PreToolUse: [{hooks: [$pre]}],
    PostToolUse: [{hooks: [$post]}], SubagentStart: [{hooks: [$sst]}], SubagentStop: [{hooks: [$ssa, $ssb]}],
    Stop: [{hooks: [$st]}]}}' >"$H/.codex/hooks.json"
cat >"$H/.codex/agents/capture-role.toml" <<'EOF'
name = "capture_role"
description = "Payload capture role for the codex-parity tests. Spawn fresh with the task."
model = "gpt-5.6-luna"
model_reasoning_effort = "low"
developer_instructions = """
You are a tiny capture agent. Do exactly the task you are given, then reply in one line.
"""
EOF
printf '# Capture run\n\nMarker word: AGENTS-MARK-5521\n' >"$H/.codex/AGENTS.md"

PROMPT="Spawn one capture_role agent with the task: 'Run the shell command \`echo sub-ran\`, then reply DONE and the marker word from your global instructions.' Wait for it. Then run \`echo main-ran\` and reply with the agent's final answer word for word."

probe_begin "$H" || exit 1
trap probe_end EXIT
probe_exec "$H" "$H/work" "$RUN" "$PROMPT"; rc=$?
probe_end; trap - EXIT
echo "# codex exec exit $rc; raw run in $RUN"

# sanitize into the fixtures dir, numbered in arrival order
n=0
for f in $(ls "$OUT"/*.json 2>/dev/null | sort); do
  n=$((n + 1)); base=$(basename "$f" .json); name=${base#*-}
  sed -e "s|$H|/FAKEHOME|g" -e "s|$S|/FAKEROOT|g" -e "s|$PROBE|/CODEXHOME|g" "$f" \
    | jq . >"$FIX/recorded-$(printf '%02d' $n)-$name.json"
done
sed -e "s|$H|/FAKEHOME|g" -e "s|$S|/FAKEROOT|g" -e "s|$PROBE|/CODEXHOME|g" "$RUN/events.jsonl" >"$FIX/recorded-events.jsonl"
sed -e "s|$H|/FAKEHOME|g" -e "s|$S|/FAKEROOT|g" -e "s|$PROBE|/CODEXHOME|g" "$RUN/last.txt" >"$FIX/recorded-last.txt" 2>/dev/null

last=$(cat "$RUN/last.txt" 2>/dev/null)
{
  echo "Draft findings from capture-payloads.sh ($(date '+%F %T')); finish them by hand in findings.txt."
  echo "F1 SubagentStop for capture_role with last_assistant_message: $(cat "$OUT"/*-SubagentStop-BLOCKWORD-ALPHA.json 2>/dev/null | jq -rs 'map(select(.agent_type == "capture_role")) | map("active=\(.stop_hook_active) msg=\(.last_assistant_message|tostring|.[0:60])") | join(" | ")')"
  echo "F1/F2 final answer: $last"
  echo "F2 ALPHA in answer: $(grep -c BLOCKWORD-ALPHA <<<"$last")  BETA in answer: $(grep -c BLOCKWORD-BETA <<<"$last")"
  echo "F3 PostToolUse with agent_id: $(cat "$OUT"/*-PostToolUse.json 2>/dev/null | jq -rs 'map(select(.agent_id != null)) | length')"
  echo "F4 hook wrote outside the workspace: $([ -e "$H/hook-wrote-here" ] && echo yes || echo no)"
  echo "F5 marker in answer: $(grep -c AGENTS-MARK-5521 <<<"$last")"
  echo "F6 PreToolUse tool names: $(cat "$OUT"/*-PreToolUse.json 2>/dev/null | jq -rs 'map(.tool_name) | unique | join(", ")')"
  echo "F6 spawn tool_input keys: $(cat "$OUT"/*-PreToolUse.json 2>/dev/null | jq -rs 'map(select(.tool_name | test("spawn|Agent"))) | map(.tool_input | keys) | unique | tostring')"
  echo "F7 SubagentStart/Stop model: $(cat "$OUT"/*-Subagent*.json 2>/dev/null | jq -rs 'map("\(.hook_event_name)=\(.model)") | unique | join(", ")')"
  echo "F8 $(codex --version)"
} >"$FIX/findings.draft.txt"
cat "$FIX/findings.draft.txt"
echo "# payloads: $n file(s) in $FIX (recorded-*.json); scratch kept in $S"
