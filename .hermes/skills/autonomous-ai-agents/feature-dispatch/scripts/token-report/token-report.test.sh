#!/usr/bin/env bash
# Acceptance test for the token report (story pipeline-token-diet, ~/.hermes/plans/claude-setup/pipeline-token-diet.md,
# the fourth criterion): scan.py, analyze.py and report.py on a hand-made transcript folder.
#   bash token-report.test.sh                    every test (token_report_fixture)
#   bash token-report.test.sh <test> [<test>…]   just those, numbered TAP: "ok 1 - <test>"
# The scripts come from this file's own folder. The fixture is built in a fresh mktemp -d folder (under
# $TMPDIR) and the scripts are pointed at it with --root, --out and --plans: nothing reads the real
# transcripts under ~/.claude/projects or the real plans under ~/.hermes/plans.
set -uo pipefail
HERE=$(cd "$(dirname "$0")" && pwd)

OFFLINE="token_report_fixture"

fail() { echo "FAIL: $*"; return 1; }
need() { [ -e "$1" ] || fail "missing $1 (not built yet)"; }
newroot() { S=$(mktemp -d "${TMPDIR:-/tmp}/token-report-test.XXXXXX") && S=$(cd "$S" && pwd -P); }
done_ok() { rm -rf "$S"; return 0; }        # remove the test folder on success (kept on failure)

# ---- transcript lines: one JSON object a line, the fields scan.py reads ----
user() { # user <ts> <text>: a prompt line
  jq -nc --arg ts "$1" --arg t "$2" '{type: "user", timestamp: $ts, message: {role: "user", content: $t}}'
}
reply() { # reply <ts> <message id> <model> <input> <cache write> <cache read> <output> [<1-hour part of the cache write>]
  jq -nc --arg ts "$1" --arg id "$2" --arg m "$3" --argjson i "$4" --argjson w "$5" --argjson r "$6" --argjson o "$7" --argjson h "${8:-0}" \
    '{type: "assistant", timestamp: $ts, message: {id: $id, model: $m, role: "assistant",
      content: [{type: "text", text: "reply"}],
      usage: {input_tokens: $i, cache_creation_input_tokens: $w, cache_read_input_tokens: $r, output_tokens: $o,
              cache_creation: {ephemeral_1h_input_tokens: $h}}}}'
}

# The fixture, worked out by hand (prices per million tokens, from analyze.py: Opus 5.5 input 4, cache write 5,
# 1-hour cache write 8, cache read 0.20, output 20; Fable 5.2 input 8, cache write 10, cache read 0.20, output 40):
#   main session  sess1.jsonl, Opus:  m1 in 10, write 1000 (all 1-hour), read 0,    out 50
#                                     m2 in 5,  write 200,               read 1000, out 30
#                 calls 2, in 15, write 1200, read 1000, out 80
#                 $ = (10*4 + 1000*8 + 50*20 + 5*4 + 200*5 + 1000*0.2 + 30*20) / 1e6 = 10860 / 1e6 = 0.011 (to 3 places, as analyze.py rounds each transcript)
#                 its last response's context: 5 + 200 + 1000 = 1205
#   builder agent agent-a1 (brief demo-story-builder.md), Opus:
#                                     b1 in 3, write 2000, read 0,    out 100
#                                     b2 in 2, write 300,  read 2000, out 400
#                 calls 2, in 5, write 2300, read 2000, out 500
#                 $ = (5*4 + 2300*5 + 2000*0.2 + 500*20) / 1e6 = 21920 / 1e6 = 0.022
#   reviewer agent agent-a2 (brief demo-story-reviewer-1.md), Fable: r1 is written on TWO lines with one message id
#                 (one line per content block, as Claude Code writes them; the first line's output count is the
#                 partial 10, the second the final 60), then r2:
#                                     r1 in 4, write 1500, read 0,    out 60
#                                     r2 in 1, write 100,  read 1500, out 40
#                 calls 2, in 5, write 1600, read 1500, out 100
#                 $ = (5*8 + 1600*10 + 1500*0.2 + 100*40) / 1e6 = 20340 / 1e6 = 0.020
#                 (r1 counted twice would give calls 3, in 9, write 3100, out 170)
fixture() {
  local P="$S/projects/-home-demo" A
  A="$P/sess1/subagents"; mkdir -p "$A" "$S/out" "$S/plans"
  { user 2026-11-10T10:00:00Z "Run the demo story"
    reply 2026-11-10T10:00:05Z m1 claude-opus-5-5 10 1000 0 50 1000
    reply 2026-11-10T10:30:00Z m2 claude-opus-5-5 5 200 1000 30
  } >"$P/sess1.jsonl"
  { user 2026-11-10T10:01:00Z "You are the BUILDER. Your brief is /home/demo/.hermes/plans/demo/briefs/demo-story-builder.md"
    reply 2026-11-10T10:01:05Z b1 claude-opus-5-5 3 2000 0 100
    reply 2026-11-10T10:02:00Z b2 claude-opus-5-5 2 300 2000 400
  } >"$A/agent-a1.jsonl"
  printf '%s\n' '{"agentType": "general-purpose", "model": "opus", "effort": "xhigh", "description": "demo builder"}' >"$A/agent-a1.meta.json"
  { user 2026-11-10T10:10:00Z "You are the REVIEWER. Your brief is /home/demo/.hermes/plans/demo/briefs/demo-story-reviewer-1.md"
    reply 2026-11-10T10:10:05Z r1 claude-fable-5-2 4 1500 0 10
    reply 2026-11-10T10:10:06Z r1 claude-fable-5-2 4 1500 0 60
    reply 2026-11-10T10:11:00Z r2 claude-fable-5-2 1 100 1500 40
  } >"$A/agent-a2.jsonl"
  printf '%s\n' '{"agentType": "general-purpose", "model": "fable", "effort": "high", "description": "demo reviewer"}' >"$A/agent-a2.meta.json"
}
py() { python3 -B "$HERE/$1" "${@:2}"; }   # py <script> <args>…: no __pycache__ next to the scripts

token_report_fixture() {
  local out want
  need "$HERE/scan.py" && need "$HERE/analyze.py" && need "$HERE/report.py" && need "$HERE/extras.py" || return 1
  newroot && fixture || fail "fixture" || return 1
  out=$(py scan.py --root "$S/projects" --out "$S/out" --since 2000-01-01 2>&1) || fail "scan.py: $out" || return 1
  echo "# $out"
  out=$(py analyze.py --out "$S/out" 2>&1) || fail "analyze.py: $out" || return 1
  echo "# $out"
  [ "$out" = "agents 2 mains 1 stories 1" ] || fail "analyze.py: want [agents 2 mains 1 stories 1], got [$out]" || return 1
  out=$(py report.py --out "$S/out" --plans "$S/plans" tokens 2>&1) || fail "report.py tokens: $out" || return 1
  printf '%s\n' "$out" | sed 's/^/# /'
  want=$(printf '%s\n' \
    "== tokens per role: transcripts, API calls, input, cache write, cache read, output tokens, API \$ ==" \
    "builder   n=1 calls=2 in=5 cw=2300 cr=2000 out=500 usd=0.022" \
    "reviewer  n=1 calls=2 in=5 cw=1600 cr=1500 out=100 usd=0.020" \
    "main      n=1 calls=2 in=15 cw=1200 cr=1000 out=80 usd=0.011")
  [ "$out" = "$want" ] || fail "report.py tokens: want [$want], got [$out]" || return 1
  printf '%s\n' "$out" | grep -qF "reviewer  n=1 calls=2 in=5 cw=1600 " \
    || fail "the reviewer's message r1, written on two lines, is not counted once" || return 1
  out=$(py report.py context "$S/projects/-home-demo/sess1.jsonl" 2>&1) || fail "report.py context: $out" || return 1
  [ "$out" = 1205 ] || fail "report.py context: want 1205 (the main session's last response: 5 + 200 + 1000), got [$out]" || return 1
  echo "# context of the main session's last response: $out"
  out=$(py report.py context "$S/projects/-home-demo/sess1/subagents/agent-a2.jsonl" 2>&1) || fail "report.py context: $out" || return 1
  [ "$out" = 1601 ] || fail "report.py context: want 1601 (the reviewer's last response: 1 + 100 + 1500), got [$out]" || return 1
  out=$(py report.py --out "$S/out" --plans "$S/plans" stories roles 2>&1) || fail "report.py stories roles: $out" || return 1
  printf '%s\n' "$out" | grep -qF "== complete stories" || fail "report.py stories: no table: $out" || return 1
  done_ok
}

n=0; failed=0
run() {
  local t=$1 out rc
  n=$((n + 1))
  if [ "$(type -t "$t")" != function ]; then echo "not ok $n - $t"; echo "# no such test"; failed=$((failed + 1)); return; fi
  out=$( ( "$t" ) 2>&1 ); rc=$?
  printf '%s\n' "$out" | sed 's/^/#  /'
  if [ $rc -eq 0 ]; then echo "ok $n - $t"; else echo "not ok $n - $t"; failed=$((failed + 1)); fi
}
if [ $# -gt 0 ]; then for t in "$@"; do run "$t"; done; else for t in $OFFLINE; do run "$t"; done; fi
echo "# passed $((n - failed)), failed $failed"
[ "$failed" -eq 0 ]
