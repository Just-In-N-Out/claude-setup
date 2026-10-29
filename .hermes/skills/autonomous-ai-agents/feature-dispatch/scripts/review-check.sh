#!/usr/bin/env bash
# review-check: the round referee for the review → fix loop (the review twin of ac-check.sh).
#
#   review-check.sh --repo <worktree> --base <base commit> <evidence folder>
#
# Reads <evidence>/review-1/review.json, review-2/…, numbered without gaps (format and the
# reviewer's duties: references/review-loop.md), and Justin's recorded answers
# <evidence>/review-<n>/justin.json, then judges the LATEST round.
# Exit 2: bad usage or input, with an error: line on stderr. Needs bash 3.2+, git, jq 1.6+.
# Tests: review-check.test.sh
set -uo pipefail

usage() { echo "error: usage: review-check.sh --repo <worktree> --base <base commit> <evidence folder>" >&2; exit 2; }
die() { echo "error: $*" >&2; exit 2; }
repo="" base=""
while (($#)); do
  case $1 in
    --repo) (($# >= 2)) || usage; repo=$2; shift 2 ;;
    --base) (($# >= 2)) || usage; base=$2; shift 2 ;;
    -*) usage ;;
    *) break ;;
  esac
done
(($# == 1)) && [[ -n $repo && -n $base ]] || usage
ev=$1
[[ -d $ev ]] || die "no evidence folder at $ev"
HEADSHA=$(git -C "$repo" rev-parse --verify -q HEAD 2>/dev/null) || die "$repo is not a git worktree"
commit() { git -C "$repo" rev-parse --verify -q "$1^{commit}" 2>/dev/null; }
BASESHA=$(commit "$base") || die "--base $base is not a commit"
[[ $BASESHA != "$HEADSHA" ]] && git -C "$repo" merge-base --is-ancestor "$BASESHA" "$HEADSHA" 2>/dev/null \
  || die "--base must be an older commit of this branch than HEAD"

# every rule a record breaks, one line each (the first one is reported)
VALIDATE=$(cat <<'JQ'
def str: type == "string" and test("[^[:space:]]");
def sha: type == "string" and test("^[0-9a-f]{40}$");
.rounds as $r | .justin as $j
| range(0; $r | length) as $i | $r[$i] as $x | ($i + 1) as $k | "review-\($k)" as $w
| ([ $r[0:$i][] | .findings[]? | .id? ]) as $earlier
| if ($x | type) != "object" then "\($w)/review.json is not a JSON object" else
  (if $x.round != $k then "\($w): round is \($x.round | tojson), want \($k)" else empty end),
  (if ($x.scope | IN("full", "delta") | not) then "\($w): scope must be full or delta" else empty end),
  (if $k == 1 and $x.scope != "full" then "review-1 must be a full review" else empty end),
  (if ($x.head | sha | not) then "\($w): head must be a full 40-character sha" else empty end),
  (if ($x.from | sha | not) then "\($w): from must be a full 40-character sha" else empty end),
  (if $k > 1 and $x.scope == "delta" and $x.from != $r[$i - 1].head
   then "\($w): a delta review starts at review-\($k - 1)'s head, not \($x.from | tostring | .[0:7])" else empty end),
  (if ($x.findings | type) != "array" then "\($w): findings must be a list" else
     ($x.findings[] | . as $f
      | if type != "object" then "\($w): a finding is not an object"
        elif ($f.id | type) != "string" or ($f.id | startswith("R\($k)-") | not) then "\($w): finding id \($f.id | tojson) must start R\($k)-"
        elif ($f.severity | IN("P0", "P1", "P2", "P3") | not) then "\($w) \($f.id): severity must be P0, P1, P2 or P3"
        elif ($f.file_line | str | not) or ($f.claim | str | not) then "\($w) \($f.id): file_line and claim are required"
        elif (($f.scenario // "") | type) != "string" or (($f.new_fact // "") | type) != "string" or (($f.repeats // "") | type) != "string"
        then "\($w) \($f.id): scenario, repeats and new_fact are text"
        elif ($f.repeats // "") != "" and ([ $earlier[] | select(. == $f.repeats) ] | length) == 0
        then "\($w) \($f.id): repeats \($f.repeats | tojson), which no earlier review lists"
        else empty end),
     (if ([ $x.findings[] | .id? ] | length) != ([ $x.findings[] | .id? ] | unique | length) then "\($w): a finding id is listed twice" else empty end)
   end),
  ($j[$i] | if . == {} then empty
     elif type != "object" or (.words | str | not) then "\($w)/justin.json needs words: Justin's reply, verbatim"
     elif ((.accept // []) | type) != "array" then "\($w)/justin.json: accept must be a list of finding ids"
     else (.accept // [])[] as $a
          | if ([ $x.findings[]? | select(.id? == $a) ] | length) == 0 then "\($w)/justin.json accepts \($a | tojson), which \($w) doesn't list" else empty end
     end)
  end
JQ
)

# the rounds: review-1 … review-<n>, with no gaps
n=0
while [[ -f $ev/review-$((n + 1))/review.json ]]; do n=$((n + 1)); done
((n > 0)) || die "no review records: $ev/review-1/review.json is missing"
for d in "$ev"/review-*; do
  k=${d##*/review-}
  [[ $k =~ ^[1-9][0-9]*$ ]] && ((k > n)) && [[ -f $d/review.json ]] \
    && die "review-$k/review.json exists but review-$((n + 1))/review.json doesn't"
done
rounds="[" justin="[" sep=""
for ((k = 1; k <= n; k++)); do
  r=$(jq -c . "$ev/review-$k/review.json" 2>/dev/null) && [[ -n $r ]] || die "review-$k/review.json is not JSON"
  j='{}'
  if [[ -f $ev/review-$k/justin.json ]]; then
    j=$(jq -c . "$ev/review-$k/justin.json" 2>/dev/null) && [[ -n $j ]] || die "review-$k/justin.json is not JSON"
  fi
  rounds="$rounds$sep$r" justin="$justin$sep$j" sep=,
done
in=$(jq -nc --argjson r "$rounds]" --argjson j "$justin]" '{rounds: $r, justin: $j}') || die "can't read the review records"
bad=$(jq -r "$VALIDATE" <<<"$in" 2>&1) || die "can't check the review records: $bad"
[[ -z $bad ]] || die "$(head -n 1 <<<"$bad")"
# only the latest round's commits must exist: older heads may be gone after a rebase
RH=$(jq -r ".rounds[$((n - 1))].head" <<<"$in") RF=$(jq -r ".rounds[$((n - 1))].from" <<<"$in")
[[ -n $(commit "$RH") ]] || die "review-$n's head ${RH:0:7} is not a commit in $repo"
[[ -n $(commit "$RF") ]] || die "review-$n's from ${RF:0:7} is not a commit in $repo"
if [[ $(jq -r ".rounds[$((n - 1))].scope" <<<"$in") == full ]]; then
  git -C "$repo" merge-base --is-ancestor "$RF" "$RH" 2>/dev/null && [[ $RF != "$RH" ]] \
    || die "review-$n is a full review, but its from ${RF:0:7} is not an older commit of its head ${RH:0:7}"
fi
die "not judged yet"
