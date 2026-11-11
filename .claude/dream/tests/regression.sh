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
# A setup or write failure is never a pass (V2C-1): --record writes no baseline and exits 2; a compare
# prints not ok and exits 1.
die() {
  if [[ $mode == record ]]; then echo "regression.sh: $*; no baseline written"; exit 2; fi
  echo "not ok 1 - $TEST"; echo "# $*"; exit 1
}
head_suites() {  # every suite --record runs on this checkout, in order
  echo .claude/setup/sync.test.sh
  for s in "$ROOT"/.claude/hooks/tests/*.test.sh; do [[ -e $s ]] && echo ".claude/hooks/tests/${s##*/}"; done
  printf '%s\n' .claude/setup/codex/codex-parity.test.sh \
    .hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.test.sh \
    .hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.test.sh
}
SUITES=()  # filled with while-read, not mapfile: macOS /bin/bash is 3.2
if [[ $mode == record ]]; then
  while IFS= read -r s; do SUITES+=("$s"); done < <(head_suites)
else
  [[ -f $base ]] || { echo "not ok 1 - $TEST"; echo "# no baseline at $base"; exit 1; }
  bjson=$(sed -n '/^```json$/,/^```$/p' "$base" | sed '1d;$d')
  printf '%s' "$bjson" | jq -e '.suites | type == "array"' >/dev/null 2>&1 \
    || die "the baseline $base holds no readable suites block"
  while IFS= read -r s; do [[ -n $s ]] && SUITES+=("$s"); done < <(printf '%s' "$bjson" | jq -r '.suites[].suite')
  ((${#SUITES[@]})) || die "the baseline lists no suites: nothing would be compared"
  zero=$(printf '%s' "$bjson" | jq -r '[.suites[] | select(.pass + (.failing | length) == 0) | .suite] | join(", ")')
  [[ -z $zero ]] || die "the baseline has suites with no tests: $zero"
  # every suite the head has that already existed on the base must be in the baseline (a suite the story
  # added is not); the base is the first full commit id in the baseline's text above its json block
  bsha=$(sed '/^```json$/,$d' "$base" | grep -oE '[0-9a-f]{40}' | head -n 1)
  [[ -n $bsha ]] || die "the baseline names no base commit"
  git -C "$ROOT" cat-file -e "$bsha^{commit}" 2>/dev/null || die "the baseline's base commit $bsha is not in $ROOT"
  left=""
  while IFS= read -r s; do
    git -C "$ROOT" cat-file -e "$bsha:$s" 2>/dev/null || continue
    printf '%s\n' "${SUITES[@]}" | grep -xF -- "$s" >/dev/null || left="${left:+$left, }$s"
  done < <(head_suites)
  [[ -z $left ]] || die "the baseline leaves out suites the base had: $left"
fi

tmp=$(mktemp -d "${TMPDIR:-/tmp}/dream-regression.XXXX" 2>/dev/null) && [[ -n $tmp && -d $tmp ]] \
  || die "could not make a temporary folder in ${TMPDIR:-/tmp}"
trap 'rm -rf "$tmp"' EXIT
results="$tmp/results.jsonl"
: >"$results" || die "could not write $results"
for s in "${SUITES[@]}"; do
  log="$tmp/$(echo "$s" | tr '/' '_').log"
  : >"$log" || die "could not write $log"
  if [[ -f $ROOT/$s ]]; then
    (cd "$ROOT" && timeout 1800 bash "$s" </dev/null >"$log" 2>&1)
    rc=$?
  else
    echo "missing suite" >"$log"; rc=127
  fi
  pass=$(grep -cE '^ok( |$)' "$log")
  fails=$(grep -E '^(not ok|NOT OK)' "$log" | sed -E 's/^(not ok|NOT OK)( [0-9]+)? - //' | sort)
  jq -cn --arg suite "$s" --argjson pass "$pass" --argjson rc "$rc" --arg fails "$fails" \
    '{suite: $suite, pass: $pass, rc: $rc, failing: ($fails | split("\n") | map(select(. != "")))}' >>"$results" \
    || die "could not write the tally of $s to $results"
  echo "# $s: rc=$rc, $pass passed, $(printf '%s' "$fails" | grep -c .) failing"
done

n=$(jq -s length "$results" 2>/dev/null)
[[ $n == "${#SUITES[@]}" ]] || die "only ${n:-0} of ${#SUITES[@]} suites were tallied"
if [[ $mode == record ]]; then
  # a suite that did not run (missing, or killed before its first line) or tallied 0 tests is no baseline
  zero=$(jq -rs '[.[] | select(.pass + (.failing | length) == 0) | .suite] | join(", ")' "$results")
  [[ -z $zero ]] || die "these suites did not run or tallied no tests: $zero"
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
  } >"$tmp/baseline.md" || die "could not write the baseline"
  cp "$tmp/baseline.md" "$base" || { rm -f "$base"; die "could not write $base"; }
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
