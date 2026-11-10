#!/usr/bin/env bash
# AC38 of story dream-pass: the setup repo's existing suites must give the same result on the
# story's head as on its base. Each suite's pass tally (lines starting "ok") and failing test
# names (lines starting "not ok" / "NOT OK") are compared with a baseline recorded on the base.
#
#   regression.sh --record <baseline.md> [--root <checkout>]   run on a base checkout, write the baseline
#   regression.sh <baseline.md> [--root <checkout>]            run on this checkout, compare, print one TAP line
#   regression.sh                                              does nothing (exit 0): a later story without
#                                                              a baseline never fails here
# <checkout> defaults to the checkout this file sits in. Run both in a git checkout (a clone or a
# worktree): some suites check what git tracks. Needs bash, jq and what each suite needs.
set -uo pipefail
HERE=$(cd "$(dirname "$0")" && pwd)
ROOT=$(cd "$HERE/../../.." && pwd)
mode=compare base=""
while (($#)); do
  case $1 in
    --record) mode=record; base=${2:-}; shift 2 || shift ;;
    --root) ROOT=$(cd "${2:?--root needs a path}" && pwd); shift 2 ;;
    -h|--help) sed -n '2,12p' "$0"; exit 0 ;;
    *) base=$1; shift ;;
  esac
done
if [[ -z $base ]]; then
  echo "regression.sh: no baseline given; nothing to compare (see --help)"
  exit 0
fi
TEST=regression_existing_suites_match_the_base_tally
if [[ $(git -C "$ROOT" rev-parse --is-inside-work-tree 2>/dev/null) != true ]]; then
  # a git archive copy fails suites that check what git tracks (harness-guards, cortexos-memory, review-check)
  echo "regression.sh: $ROOT is not a git checkout; use a clone or a worktree"
  [[ $mode == record ]] && exit 2
  echo "not ok 1 - $TEST"
  exit 1
fi
SUITES=(.claude/setup/sync.test.sh)
if [[ $mode == record ]]; then
  for s in "$ROOT"/.claude/hooks/tests/*.test.sh; do SUITES+=(".claude/hooks/tests/${s##*/}"); done
else
  [[ -f $base ]] || { echo "not ok 1 - $TEST"; echo "# no baseline at $base"; exit 1; }
  mapfile -t SUITES < <(sed -n '/^```json$/,/^```$/p' "$base" | sed '1d;$d' | jq -r '.suites[].suite')
fi
[[ $mode == record ]] && SUITES+=(.claude/setup/codex/codex-parity.test.sh
  .hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.test.sh
  .hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.test.sh)

tmp=$(mktemp -d "${TMPDIR:-/tmp}/dream-regression.XXXX")
trap 'rm -rf "$tmp"' EXIT
results="$tmp/results.jsonl"
: >"$results"
for s in "${SUITES[@]}"; do
  log="$tmp/$(echo "$s" | tr '/' '_').log"
  if [[ -f $ROOT/$s ]]; then
    (cd "$ROOT" && timeout 1800 bash "$s" </dev/null >"$log" 2>&1)
    rc=$?
  else
    echo "missing suite" >"$log"; rc=127
  fi
  pass=$(grep -cE '^ok( |$)' "$log")
  fails=$(grep -E '^(not ok|NOT OK)' "$log" | sed -E 's/^(not ok|NOT OK)( [0-9]+)? - //' | sort)
  jq -cn --arg suite "$s" --argjson pass "$pass" --argjson rc "$rc" --arg fails "$fails" \
    '{suite: $suite, pass: $pass, rc: $rc, failing: ($fails | split("\n") | map(select(. != "")))}' >>"$results"
  echo "# $s: rc=$rc, $pass passed, $(printf '%s' "$fails" | grep -c .) failing"
done

if [[ $mode == record ]]; then
  {
    echo "# dream-pass baseline (AC38)"
    echo
    echo "Recorded $(date -Is) on $(git -C "$ROOT" rev-parse HEAD 2>/dev/null || echo 'a non-git copy') by \`regression.sh --record\`."
    echo "Each suite's pass tally and failing test names; the head must match them exactly."
    echo
    echo "| Suite | Passed | Failing on the base |"
    echo "|---|---|---|"
    jq -r '"| `\(.suite)` | \(.pass) | \(if (.failing | length) == 0 then "none" else (.failing | join("; ")) end) |"' "$results"
    echo
    echo '```json'
    jq -s '{suites: .}' "$results"
    echo '```'
  } >"$base"
  echo "# baseline written to $base"
  exit 0
fi

want=$(sed -n '/^```json$/,/^```$/p' "$base" | sed '1d;$d' | jq -c '[.suites[] | {suite, pass, failing}]')
got=$(jq -sc '[.[] | {suite, pass, failing}]' "$results")
if [[ $want == "$got" ]]; then
  echo "ok 1 - $TEST"
  exit 0
fi
echo "not ok 1 - $TEST"
jq -rn --argjson w "$want" --argjson g "$got" '
  $w[] as $a | ($g[] | select(.suite == $a.suite)) as $b
  | select($a != $b)
  | "# \($a.suite): base \($a.pass) passed, failing \($a.failing); head \($b.pass) passed, failing \($b.failing)"'
exit 1
