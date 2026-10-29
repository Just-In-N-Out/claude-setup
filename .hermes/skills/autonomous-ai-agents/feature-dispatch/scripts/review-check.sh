#!/usr/bin/env bash
# review-check: the round referee for the review → fix loop (the review twin of ac-check.sh).
#
#   review-check.sh --repo <worktree> --base <base commit> <evidence folder>
#
# Reads <evidence>/review-1/review.json, review-2/…, numbered without gaps (format and the
# reviewer's duties: references/review-loop.md), and Justin's recorded answers
# <evidence>/review-<n>/justin.json, then judges the LATEST round:
#   - a P0-P2 whose scenario has fewer than 5 words counts as P3 (brake a);
#   - a finding Justin accepted, or one that repeats it, counts as ACCEPTED (it isn't fixed);
#   - P0-P2 left → REVIEW AGAIN, unless brake c (no fewer P0-P2 than the round before, when that
#     round had any) or brake d (a P0-P2 that repeats an earlier P0-P2 with no new_fact of 5+ words)
#     trips → ASK JUSTIN; justin.json "continue": true answers that round's ASK with REVIEW AGAIN;
#   - none left → MOVE ON when the round's head is HEAD, or HEAD is a pure rebase of it (the same
#     patches in the same order, no merges); otherwise REVIEW AGAIN for the unreviewed commits;
#   - after round 1, a REVIEW AGAIN names both next rounds: Full's round 2 reviews the whole story from
#     --base, Mini's is a delta round (this script can't tell Full from Mini);
#   - the latest full round's from not on --base's history → REVIEW AGAIN: run a full review from --base
#     (the delta rounds after it build on it, so no delta round clears it; only a full round from --base).
# --base is the commit the branch starts from now (git merge-base HEAD <integration branch>).
# Prints one line per finding of the latest round, then the outcome as the LAST line.
# Exit 0 MOVE ON, 1 REVIEW AGAIN, 3 ASK JUSTIN, 2 bad usage or input (an error: line on stderr).
# ac-check.sh --reviews runs it. Needs bash 3.2+, git 2.39+ (patch-id --verbatim), jq 1.6+. Tests: review-check.test.sh
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

# The jq programs are read with read -d '' (it returns 1 at the end of input), never captured from a
# here-document inside a command substitution: bash 3.2 finds the end of a command substitution with
# no here-document logic, so a quote in the program would end it early.
# every rule a record breaks, one line each (the first one is reported)
IFS= read -r -d '' VALIDATE <<'JQ' || :
def str: type == "string" and test("[^[:space:]]");
def sha: type == "string" and test("^[0-9a-f]{40}$");
.rounds as $r | .justin as $j
| range(0; $r | length) as $i | $r[$i] as $x | ($i + 1) as $k | "review-\($k)" as $w
| ([ $r[0:$i][] | objects | .findings | arrays | .[] | objects | .id ]) as $earlier
| if ($x | type) != "object" then "\($w)/review.json is not a JSON object" else
  (if $x.round != $k then "\($w): round is \($x.round | tojson), want \($k)" else empty end),
  (if ($x.scope | IN("full", "delta") | not) then "\($w): scope must be full or delta" else empty end),
  (if $k == 1 and $x.scope != "full" then "review-1 must be a full review" else empty end),
  (if ($x.head | sha | not) then "\($w): head must be a full 40-character sha" else empty end),
  (if ($x.from | sha | not) then "\($w): from must be a full 40-character sha" else empty end),
  (if $k > 1 and $x.scope == "delta" and $x.from != ($r[$i - 1] | objects | .head)
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
  ($j[$i] | if . == null then empty
     elif type != "object" or (.words | str | not) then "\($w)/justin.json needs words: Justin's reply, verbatim"
     elif has("accept") and (.accept | type) != "array" then "\($w)/justin.json: accept must be a list of finding ids"
     elif has("continue") and (.continue | type) != "boolean" then "\($w)/justin.json: continue must be true or false"
     elif (has("accept") or has("continue")) | not
     then "\($w)/justin.json needs accept (the finding ids he accepts) or continue (true: keep going), or both"
     else (.accept // [])[] as $a
          | if ([ $x.findings[]? | select(.id? == $a) ] | length) == 0 then "\($w)/justin.json accepts \($a | tojson), which \($w) doesn't list" else empty end
     end)
  end
JQ
# the latest round's verdict: effective severities, its finding lines, and clean / again / ask
IFS= read -r -d '' JUDGE <<'JQ' || :
def words: [splits("[[:space:]]+") | select(length > 0)] | length;
def serious: . == "P0" or . == "P1" or . == "P2";
def oneline: tostring | gsub("[[:cntrl:]]+"; " ");
.rounds as $r | .justin as $j | ($r | length - 1) as $L
| (reduce range(0; $r | length) as $i ([];
     . as $acc | ($j[$i].accept // []) as $a
     | $acc + [ $r[$i].findings[]
                | select(.id as $id | any($a[]; . == $id)
                         or ((.repeats // "") as $p | $p != "" and any($acc[]; . == $p)))
                | .id ])) as $accepted
| [ $r[] | [ .findings[]
              | . + {eff: (if (.id as $id | any($accepted[]; . == $id)) then "ACCEPTED"
                           elif (.severity | serious) and ((.scenario // "") | words) < 5 then "P3 (no scenario)"
                           else .severity end)} ] ] as $e
| [ $e[$L][] | select(.eff | serious) ] as $now
| (if $L > 0 then [ $e[$L - 1][] | select(.eff | serious) ] | length else 0 end) as $prev
| [ $now[] | . as $f | select((.repeats // "") != "")
    | select(any($e[0:$L][][]; .id == $f.repeats and (.eff | serious)))
    | select(((.new_fact // "") | words) < 5) | "\(.id) repeats \(.repeats)" ] as $stalled
| { round: ($L + 1), now: ($now | length), prev: $prev, stalled: $stalled,
    lines: [ $e[$L][] | "\(.id | oneline)  \(.eff)  \(.file_line | oneline)  \(.claim | oneline)\(if (.repeats // "") != "" then "  (repeats \(.repeats | oneline))" else "" end)" ],
    outcome: (if ($now | length) == 0 then "clean"
              elif $j[$L].continue == true then "again"
              elif ($stalled | length) > 0 or ($prev > 0 and ($now | length) >= $prev) then "ask"
              else "again" end) }
JQ

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
  j=null   # no answer recorded (a justin.json file must be an object)
  if [[ -f $ev/review-$k/justin.json ]]; then
    j=$(jq -c . "$ev/review-$k/justin.json" 2>/dev/null) && [[ -n $j ]] || die "review-$k/justin.json is not JSON"
    [[ $j != null ]] || die "review-$k/justin.json needs words: Justin's reply, verbatim"
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
# The latest full round (review-<FK>, from FF) is the root of every delta round after it: each starts at
# the round before's head (VALIDATE), so together they cover FF..review-n's head. That covers the story
# only when FF is --base or an older commit of it (a rebase moves --base forward past it). Otherwise
# (a range recorded from inside the story, a base commit sync.sh's rebase rewrote, a from that is no
# longer a commit) the records are true but the story isn't covered: whatever the delta rounds after it
# say, the next review is a full one from --base.
FK=$(jq -r '[range(0; .rounds | length) as $i | select(.rounds[$i].scope == "full") | $i + 1] | last' <<<"$in")
FF=$(jq -r ".rounds[$((FK - 1))].from" <<<"$in")
offbase=0
git -C "$repo" merge-base --is-ancestor "$FF" "$BASESHA" 2>/dev/null || offbase=1

v=$(jq -c "$JUDGE" <<<"$in") || die "can't judge the review records"
jq -r '.lines[]' <<<"$v"
outcome=$(jq -r .outcome <<<"$v") now=$(jq -r .now <<<"$v")

# next <Mini's review>: what the next round reviews. After round 1 a Full story reviews the whole story
# again (rule b: rounds 1 and 2 are full), so the line names both; from round 2 on it is the delta review.
next() { if ((n == 1)); then echo "review again (Full: round 2 reviews the whole story from ${BASESHA:0:7}; Mini: $1)"; else echo "$1"; fi; }
pids() { # pids <from> <to>: a patch-id per non-merge commit, oldest first ("empty:<subject>" for no diff).
  # Plumbing diff-tree ignores colour, external-diff and textconv settings; --verbatim keeps whitespace
  # changes (a re-indented line is a different patch). Fails when any git step fails: an empty id
  # from an error would compare equal to an empty commit's. The caller sends git's stderr to a file.
  local c p
  git -C "$repo" rev-list --reverse --topo-order --no-merges "$1..$2" | while IFS= read -r c; do
    p=$(git -C "$repo" diff-tree -p --no-commit-id --full-index "$c" \
        | git -C "$repo" patch-id --verbatim | cut -d' ' -f1) || exit 1
    echo "${p:-empty:$(git -C "$repo" log -1 --format=%s "$c")}"
  done
}
case $outcome in
  clean)
    if ((offbase)); then
      echo "REVIEW AGAIN: review-$FK's from ${FF:0:7} is not on --base ${BASESHA:0:7}'s history: run a full review from ${BASESHA:0:7}"
      exit 1
    fi
    if [[ $RH == "$HEADSHA" ]]; then echo "MOVE ON: review-$n at ${RH:0:7} is clean"; exit 0; fi
    if git -C "$repo" merge-base --is-ancestor "$RH" "$HEADSHA" 2>/dev/null; then
      echo "REVIEW AGAIN: $(git -C "$repo" rev-list --count "$RH..$HEADSHA") commit(s) after review-$n's head ${RH:0:7} are unreviewed: $(next "review ${RH:0:7}..${HEADSHA:0:7}")"
      exit 1
    fi
    # a pure rebase: the reviewed commits' patches, in the same order, now on --base, with no merge
    if mb=$(git -C "$repo" merge-base "$RH" "$HEADSHA" 2>/dev/null) && [[ -n $mb ]]; then
      # git's stderr goes to a file, so its first line joins the one error: line ac-check.sh reports;
      # with no temporary file (TMPDIR a missing folder) the comparison still runs, and only git's message is lost
      nomsg="git printed no message"
      if gerr=$(mktemp "${TMPDIR:-/tmp}/review-check.XXXXXX" 2>/dev/null); then trap 'rm -f "$gerr"' EXIT
      else gerr=/dev/null nomsg="git's message was lost (no temporary file in ${TMPDIR:-/tmp})"; fi
      a=$(pids "$mb" "$RH" 2>"$gerr") && b=$(pids "$BASESHA" "$HEADSHA" 2>"$gerr") || {
        said=$(awk 'NF { print; exit }' "$gerr")
        die "can't compute the patch-ids that compare HEAD ${HEADSHA:0:7} with review-$n's head ${RH:0:7} (git diff-tree | git patch-id --verbatim failed: ${said:-$nomsg})"
      }
      if [[ -n $a && $a == "$b" && $(git -C "$repo" rev-list --count --merges "$BASESHA..$HEADSHA") == 0 ]]; then
        echo "MOVE ON: review-$n at ${RH:0:7} is clean, and HEAD ${HEADSHA:0:7} is a pure rebase of it"; exit 0
      fi
    fi
    echo "REVIEW AGAIN: HEAD ${HEADSHA:0:7} is not review-$n's head ${RH:0:7} or a pure rebase of it: $(next "review what changed since ${RH:0:7}")"
    exit 1 ;;
  again)
    if ((offbase)); then
      echo "REVIEW AGAIN: $now P0-P2 finding(s) in review-$n at ${RH:0:7}: fix them, then run a full review from ${BASESHA:0:7} (review-$FK's from ${FF:0:7} is not on its history)"
      exit 1
    fi
    echo "REVIEW AGAIN: $now P0-P2 finding(s) in review-$n at ${RH:0:7}: fix them, then $(next "review the fix commits")"; exit 1 ;;
  ask)
    why=$(jq -r '[ (if (.stalled | length) > 0 then "repeats with no new fact: \(.stalled | join(", "))" else empty end),
                   (if .prev > 0 and .now >= .prev then "\(.now) P0-P2, no fewer than review-\(.round - 1)'"'"'s \(.prev)" else empty end) ]
                 | join("; ")' <<<"$v")
    echo "ASK JUSTIN: review-$n: $why"; exit 3 ;;
esac
die "unknown outcome $outcome"
