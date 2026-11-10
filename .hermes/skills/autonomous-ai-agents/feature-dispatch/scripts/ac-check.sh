#!/usr/bin/env bash
# ac-check: the orchestrator's one-command check that every acceptance
# criterion (AC) is really accepted, before a story's finish step.
#
#   ac-check.sh --repo <worktree> --base <base commit> --plan <approved plan> \
#     [--reviews <evidence folder>] [--rebase-receipt <log>] <verifier report> <auditor report>
#
# --base is the commit the branch started from (git merge-base HEAD <integration
# branch>). The verifier and the blind AC auditor each write a report in their
# OWN folder (<evidence>/verifier/ac.json, <evidence>/auditor/ac.json), and every
# receipt a report cites must be inside that same folder:
#   {"head": "<commit they checked>",
#    "ac_status": [{"ac": "AC1", "accepted": true,
#      "test": "<the test's name as the runner prints it>",
#      "log": "<the AC's check run on head>",
#      "base_log": "<the same check on the base commit, head's test files copied in>",
#        or "base_exempt": "<why it rightly passes on base too, in 3+ words>",
#      "screenshot": "<a PNG/JPEG/GIF/WebP; a terminal capture for a non-visual AC>",
#      "command": "<optional, not read here: the exact command the log came from>",
#      "evidence": "<one line>"},
#     {"ac": "AC2", "accepted": false, "not_run": "live: <why only the user can run it>"}]}
# Logs come from the run recipe in references/ac-verification.md: first line
# HEAD=<sha the check ran on>, last line EXIT=<code>, verbose runner output.
# Paths are absolute, ~/..., or relative to the report.
#
# An AC is ACCEPTED only when both reports prove it:
# - accepted is the boolean true, a test name is given, the report's head is HEAD;
# - the log ran on HEAD, ends EXIT=0, and shows the test's own pass line, with no
#   fail or skip line for it (go -v, TAP and spec node --test, pytest -v, jest);
# - the base_log ran on --base and shows the test failing there: its own fail
#   line, or a build/import failure of the new code (not a missing test file, a
#   missing package, a setup failure or exit 126/127); or base_exempt gives a reason;
# - the screenshot is a real image file (checked by its first bytes);
# - every receipt is inside the report's own folder and not hard-linked to the
#   other report's; an AC listed twice in one report fails.
# Uncommitted changes in the worktree fail everything. Every AC<n> the plan names
# counts (an AC2a-style id is an error). An AC whose plan line starts with its id
# followed by a "(live)" tag (also "(proposed) (live)", "(live, proposed)"; the
# planner's tag, approved by the user with the plan) is one only the user can
# check: proven by both → ACCEPTED; not_run by an agent and failed by neither →
# owed to the user; failed by either → NOT ACCEPTED. not_run excuses no other AC.
# --reviews <evidence folder> (the orchestrator's command; the verifier's and the auditor's
# self-checks leave it out) also runs review-check.sh, beside this script, on the review rounds
# <evidence>/review-<n>/ (references/review-loop.md). The head counts as reviewed only when it
# prints MOVE ON: the latest round is clean and its head is HEAD, or HEAD is a pure rebase of it.
# After the AC lines a "REVIEWS  CLEAN: …" or "REVIEWS  NOT ACCEPTED: <its last line>" line; a
# head no clean review covers is NOT ACCEPTED (exit 1); bad review records exit 2. Without
# --reviews nothing about reviews is checked or printed.
# --rebase-receipt <log> (after the finisher's rebase; references/ac-verification.md): the reports prove an
# earlier head RH (the verifier's head). They count for HEAD when HEAD is a pure rebase of RH (the patch-ids
# of RH's own commits equal those of --base..HEAD, in order, and --base..HEAD has no merge) and the receipt,
# outside both report folders, ran on HEAD (first line HEAD=<sha>), ends EXIT=0 and skips no test: then a
# "REBASE  ACCEPTED: …" line, and each AC is judged for RH (logs on RH, base logs on the base RH grew from)
# with its test also passing, and never failing, in the receipt. Otherwise "REBASE  NOT ACCEPTED: <why>" and
# the reports are judged against HEAD as without the option; "REBASE  NOT NEEDED" when they are for HEAD.
# The REBASE line comes after the AC lines. Without the option the output is the same bytes as before it.
# Exit 0: ALL ACCEPTED, or READY FOR THE USER (all proven except owed live ACs).
# Exit 1: NOT ACCEPTED (one line per AC says why). Exit 2: bad usage or input.
# Runs on macOS bash 3.2. Tests: ac-check.test.sh
set -uo pipefail

usage() { echo "usage: ac-check.sh --repo <worktree> --base <base commit> --plan <approved plan> <verifier report> <auditor report>" >&2; exit 2; }
die() { echo "error: $*" >&2; exit 2; }
repo="" base="" plan="" reviews="" withrev=0 receipt="" withrec=0
while (($#)); do
  case $1 in
    --repo) (($# >= 2)) || usage; repo=$2; shift 2 ;;
    --base) (($# >= 2)) || usage; base=$2; shift 2 ;;
    --plan) (($# >= 2)) || usage; plan=$2; shift 2 ;;
    --reviews) (($# >= 2)) || usage; reviews=$2; withrev=1; shift 2 ;;
    --rebase-receipt) (($# >= 2)) || usage; receipt=$2; withrec=1; shift 2 ;;
    -*) usage ;;
    *) break ;;
  esac
done
(($# == 2)) && [[ -n $repo && -n $base && -n $plan ]] || usage
files=("$1" "$2") names=(verifier auditor) dirs=()

HEADSHA=$(git -C "$repo" rev-parse --verify -q HEAD 2>/dev/null) || die "$repo is not a git worktree"
[[ $(git -C "$repo" rev-parse --is-inside-work-tree 2>/dev/null) == true ]] || die "$repo is not a git worktree"
commit() { git -C "$repo" rev-parse --verify -q "$1^{commit}" 2>/dev/null; }
BASESHA=$(commit "$base") || die "--base $base is not a commit"
[[ $BASESHA != "$HEADSHA" ]] && git -C "$repo" merge-base --is-ancestor "$BASESHA" "$HEADSHA" 2>/dev/null \
  || die "--base must be an older commit of this branch than HEAD"
[[ -f $plan ]] || die "no plan at $plan"
inode() { ls -di "$1" 2>/dev/null | awk '{print $1}'; }
for i in 0 1; do
  jq -e '(.head | type == "string") and (.ac_status | type == "array")' "${files[$i]}" >/dev/null 2>&1 \
    || die "${files[$i]} is not an ac_status report (it needs head and ac_status[])"
  dirs[$i]=$(cd "$(dirname "${files[$i]}")" && pwd -P) || die "can't read the folder of ${files[$i]}"
done
case "${dirs[0]}/" in "${dirs[1]}/"*) die "the two reports must sit in separate folders, neither inside the other" ;; esac
case "${dirs[1]}/" in "${dirs[0]}/"*) die "the two reports must sit in separate folders, neither inside the other" ;; esac
[[ $(inode "${files[0]}") != "$(inode "${files[1]}")" ]] || die "the two reports are the same file"

ac_start='^[[:space:]]*([-*+]|[0-9]+\.|#+|\|)?[[:space:]]*(\[[ xX]\][[:space:]]*)?(\*\*)?'
bad_id=$(grep -oE "${ac_start}AC[0-9]+[A-Za-z_]+" "$plan" | grep -oE 'AC[0-9]+[A-Za-z_]+' | head -1)
[[ -z $bad_id ]] || die "the plan's AC ids must be AC<n> (found $bad_id)"
plan_acs=$(grep -E "${ac_start}AC[0-9]+([^A-Za-z0-9_]|\$)" "$plan" | sed -nE "s/${ac_start}(AC[0-9]+).*/\\4/p" | sort -u)
[[ -n $plan_acs ]] || die "the plan names no AC<n>"
tag='\([^)]*\)[[:space:]]*'
live=" $(sed -nE "s/^[[:space:]]*([-*+]|[0-9]+\.|#+|\|)?[[:space:]]*(\[[ xX]\][[:space:]]*)?(\*\*)?(AC[0-9]+)(\*\*)?:?[[:space:]]*($tag)*\(([^)]*,[[:space:]]*)?live([[:space:]]*,[^)]*)?\).*/\4/p" "$plan" | tr '\n' ' ')"

dirty=$(git -C "$repo" status --porcelain 2>/dev/null | head -3 | cut -c4- | tr '\n' ' ')
if [[ -n $dirty ]]; then
  echo "NOT ACCEPTED: the worktree has uncommitted changes (${dirty% }); commit them, or remove tool scratch, and verify again"
  exit 1
fi

# --reviews: is HEAD covered by a clean review? The referee's last line says (MOVE ON = covered).
covered=1 rlast=""
if ((withrev)); then
  rcheck="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)/review-check.sh"
  [[ -f $rcheck ]] || die "--reviews: no review-check.sh beside ac-check.sh ($rcheck)"
  rout=$(bash "$rcheck" --repo "$repo" --base "$base" "$reviews" 2>&1); rrc=$?
  rlast=$(awk 'NF { l = $0 } END { print l }' <<<"$rout")
  if ((rrc == 2)); then
    x=$(grep '^error: ' <<<"$rout" | head -1); x=${x#error: }
    die "--reviews: ${x:-$rlast}"
  fi
  [[ $rrc == 0 && $rlast == "MOVE ON"* ]] || covered=0
fi

exit_re='^EXIT=-?[0-9]+$'
skip_any_re='--- SKIP: |^[[:space:]]*ok [0-9]+ - .*# (SKIP|TODO)|^[[:space:]]*﹣ |^[[:space:]]*✔ .*# TODO|^# (skip|skipped|todo) [1-9]|ℹ (skipped|todo) [1-9]| SKIPPED|^[[:space:]]*○ '
build_re="\[build failed\]|: undefined: |does not provide an export named|error TS[0-9]+|SyntaxError|ImportError|ModuleNotFoundError|Cannot find (module|package) '[./]"
never_re="Could not find '|directory not found|\[setup failed\]|file or directory not found|No rule to make target|command not found|Cannot find (module|package) '[^./]"
esc() { printf '%s' "$1" | sed 's/[][\.*^$(){}?+|]/\\&/g'; }
# result lines naming test $1 (go -v, TAP and spec node --test, pytest -v, jest)
pass_re() { local t; t=$(esc "$1"); echo "--- PASS: $t( |\$)|^[[:space:]]*ok [0-9]+ - $t[[:space:]]*\$|✔ $t( \(|\$)|(::|^)$t PASSED|✓ (.* )?$t( \(|\$)"; }
fail_re() { local t; t=$(esc "$1"); echo "--- FAIL: $t(/| |\$)|^[[:space:]]*not ok [0-9]+ - $t([[:space:]]|\$)|✖ $t( \(|\$)|(::|^)$t FAILED|[✕×] (.* )?$t( \(|\$)"; }
# the test started (its crash or hang on base still counts as failing there)
start_re() { local t; t=$(esc "$1"); echo "=== RUN +$t( |\$)|^# Subtest: $t[[:space:]]*\$|▶ $t( \(|\$)"; }
resolve() { # resolve <path> <report folder>
  case $1 in
    /*) echo "$1" ;;
    "~/"*) echo "$HOME/${1#\~/}" ;;
    *) echo "$2/$1" ;;
  esac
}
inside() { # inside <file> <folder>: the file's real path is in the folder
  local real
  real=$(realpath "$1" 2>/dev/null) || return 1
  case $real in "$2"/*) return 0 ;; esac
  return 1
}
ran_on() { sed -n 's/^HEAD=//p' "$1" | head -1; }
last_line() { awk 'NF { l = $0 } END { print l }' "$1"; }
is_image() { # PNG, JPEG, GIF or WebP by its first bytes
  local m
  m=$(head -c 12 "$1" 2>/dev/null | od -An -tx1 | tr -d ' \n')
  case $m in 89504e47*|ffd8ff*|47494638*|52494646????????57454250*) return 0 ;; esac
  return 1
}

# --rebase-receipt: the reports prove an earlier head RH. They count for HEAD only when HEAD is a pure
# rebase of RH (review-check.sh's rule: the same patches in the same order, no merges) and the receipt
# is a run on HEAD that ends EXIT=0 with no skipped test; judge then wants each AC's test passing in it.
# OB is the base RH grew from: the reports' base logs ran there, not on --base.
pids() { # pids <from> <to>: a patch-id per non-merge commit, oldest first (as in review-check.sh)
  local c p
  git -C "$repo" rev-list --reverse --topo-order --no-merges "$1..$2" | while IFS= read -r c; do
    p=$(git -C "$repo" diff-tree -p --no-commit-id --full-index "$c" \
        | git -C "$repo" patch-id --verbatim | cut -d' ' -f1) || exit 1
    echo "${p:-empty:$(git -C "$repo" log -1 --format=%s "$c")}"
  done
}
RH="" OB="" rline=""
if ((withrec)); then
  [[ -f $receipt ]] || die "--rebase-receipt: no file at $receipt"
  rreal=$(realpath "$receipt" 2>/dev/null) || die "--rebase-receipt: can't read $receipt"
  for i in 0 1; do
    case $rreal in "${dirs[$i]}"/*) die "--rebase-receipt: the receipt must sit outside the two report folders" ;; esac
  done
  h0=$(jq -r '.head' "${files[0]}") c0="" rwhy=""
  ((${#h0} >= 7)) && c0=$(commit "$h0")
  if [[ -z $c0 ]]; then rwhy="the verifier's head ${h0:0:7} is not a commit in the worktree"
  elif [[ $c0 == "$HEADSHA" ]]; then rline="REBASE  NOT NEEDED: the verifier's report is for HEAD ${HEADSHA:0:7}"
  else
    mb=$(git -C "$repo" merge-base "$c0" "$HEADSHA" 2>/dev/null) || mb=""
    pa="" pb=""
    if [[ -n $mb ]]; then
      pa=$(pids "$mb" "$c0" 2>/dev/null) && pb=$(pids "$BASESHA" "$HEADSHA" 2>/dev/null) \
        || die "--rebase-receipt: can't compute the patch-ids that compare HEAD ${HEADSHA:0:7} with the reports' head ${c0:0:7} (git diff-tree | git patch-id --verbatim failed)"
    fi
    x=$(ran_on "$receipt") l=$(last_line "$receipt")
    if [[ -z $pa || $pa != "$pb" || $(git -C "$repo" rev-list --count --merges "$BASESHA..$HEADSHA") != 0 ]]; then
      rwhy="HEAD ${HEADSHA:0:7} is not a pure rebase of the reports' head ${c0:0:7}"
    elif [[ $x != "$HEADSHA" ]]; then y=${x:0:7}; rwhy="the receipt ran on ${y:-unknown}, not HEAD ${HEADSHA:0:7}"
    elif [[ $l != EXIT=0 ]]; then rwhy="the receipt's last line is not EXIT=0"
    elif grep -qE -- "$skip_any_re" "$receipt"; then rwhy="the receipt shows skipped tests (run only the ACs' tests)"
    else
      RH=$c0 OB=$mb
      rline="REBASE  ACCEPTED: HEAD ${HEADSHA:0:7} is a pure rebase of ${RH:0:7}, and the receipt ran on it"
    fi
  fi
  [[ -z $rwhy ]] || rline="REBASE  NOT ACCEPTED: $rwhy"
fi
WANT=${RH:-$HEADSHA} WBASE=${OB:-$BASESHA}   # the head the reports and their logs are for, and its base

# inodes of every receipt each report cites: a hard link across reports is a shared receipt
receipt_inodes() { # receipt_inodes <report index>
  local f=${files[$1]} dir=${dirs[$1]} p
  jq -r '.ac_status[] | .log, .base_log, .screenshot | select(. != null) | tostring' "$f" | while IFS= read -r p; do
    p=$(resolve "$p" "$dir"); [[ -f $p ]] && inode "$p"
  done | sort -u
}
shared=$(comm -12 <(receipt_inodes 0) <(receipt_inodes 1) | tr '\n' ' ')

# judge <report index> <ac>: prints why the AC isn't proven, one reason per
# line; returns 0 proven, 1 failed, 3 not run
judge() {
  local i=$1 ac=$2 f=${files[$1]} who=${names[$1]} dir=${dirs[$1]} e h n t p x l bad=0
  n=$(jq --arg ac "$ac" '[.ac_status[] | select((.ac | tostring) == $ac)] | length' "$f")
  ((n > 0)) || { echo "$who has no entry"; return 1; }
  ((n == 1)) || { echo "$who lists $ac twice"; return 1; }
  e=$(jq -c --arg ac "$ac" '.ac_status[] | select((.ac | tostring) == $ac)' "$f")
  get() { jq -r --arg k "$1" '.[$k] // "" | tostring' <<<"$e"; }
  if [[ $(jq -r '.accepted == true' <<<"$e") != true ]]; then
    x=$(get not_run)
    [[ -n ${x// /} ]] && { echo "$who did not run it ($x)"; return 3; }
    echo "$who did not accept it"; return 1
  fi

  h=$(jq -r '.head' "$f")
  if [[ -n $RH ]]; then
    ((${#h} >= 7)) && [[ $RH == "$h"* ]] || { echo "$who checked ${h:0:7}, not ${RH:0:7}, the head the rebase receipt carries"; bad=1; }
  else
    ((${#h} >= 7)) && [[ $HEADSHA == "$h"* ]] || { echo "$who checked ${h:0:7}, the worktree is at ${HEADSHA:0:7}"; bad=1; }
  fi
  t=$(get test)
  if [[ -z ${t// /} ]]; then echo "$who gives no test name"; bad=1
  elif [[ $t == *[[:cntrl:]]* ]]; then echo "$who gives a test name with control characters"; bad=1; t=""
  elif ! grep -qE -- "(^|[^A-Za-z0-9_])$(esc "$t")([^A-Za-z0-9_]|\$)" "$plan"; then
    echo "$who: $t isn't a test the approved plan names"; bad=1
  fi

  p=$(get log)
  [[ -n $p ]] && p=$(resolve "$p" "$dir")
  if [[ -z $p || ! -f $p ]]; then echo "$who log missing"; bad=1
  elif ! inside "$p" "$dir"; then echo "$who uses a receipt outside its own folder"; bad=1
  else
    x=$(ran_on "$p"); x=${x:0:7}
    [[ $(ran_on "$p") == "$WANT" ]] || { echo "$who log ran on ${x:-unknown}, not ${WANT:0:7}"; bad=1; }
    l=$(last_line "$p")
    if [[ ! $l =~ $exit_re ]]; then echo "$who log's last line is not EXIT="; bad=1
    elif [[ ${l#EXIT=} != 0 ]]; then echo "$who log exits ${l#EXIT=}"; bad=1; fi
    if [[ -n ${t// /} ]]; then
      if grep -qE -- "$(fail_re "$t")" "$p"; then echo "$who log shows $t failing"; bad=1
      elif grep -qE -- "$skip_any_re" "$p"; then echo "$who log shows skipped tests (run only the AC's test)"; bad=1
      elif ! grep -qE -- "$(pass_re "$t")" "$p"; then echo "$who log shows no pass line for $t"; bad=1; fi
    fi
  fi
  if [[ -n $RH && -n ${t// /} ]]; then   # the same test, run again on HEAD after the rebase
    if grep -qE -- "$(fail_re "$t")" "$receipt"; then echo "$who: the rebase receipt shows $t failing"; bad=1
    elif ! grep -qE -- "$(pass_re "$t")" "$receipt"; then echo "$who: the rebase receipt shows no pass line for $t"; bad=1; fi
  fi

  p=$(get base_log)
  if [[ -n $p ]]; then
    p=$(resolve "$p" "$dir")
    if [[ ! -f $p ]]; then echo "$who base_log missing"; bad=1
    elif ! inside "$p" "$dir"; then echo "$who uses a receipt outside its own folder"; bad=1
    else
      x=$(ran_on "$p")
      [[ -n $x && $(commit "$x") == "$WBASE" ]] || { echo "$who base_log didn't run on the base commit ${WBASE:0:7}"; bad=1; }
      l=$(last_line "$p")
      if [[ ! $l =~ $exit_re ]]; then echo "$who base_log's last line is not EXIT="; bad=1
      elif [[ -n ${t// /} ]] && grep -qE -- "$(pass_re "$t")" "$p"; then echo "$who: the test passes on the old code"; bad=1
      elif [[ -n ${t// /} ]] && grep -qE -- "$(fail_re "$t")" "$p"; then :
      elif grep -qE -- "$skip_any_re" "$p"; then echo "$who: the test didn't run on the old code (it was skipped)"; bad=1
      elif [[ ${l#EXIT=} == 126 || ${l#EXIT=} == 127 ]] || grep -qE -- "$never_re" "$p"; then
        echo "$who: the test didn't run on the old code"; bad=1
      elif [[ ${l#EXIT=} != 0 && -n ${t// /} ]] && grep -qE -- "$(start_re "$t")" "$p"; then :
      elif [[ ${l#EXIT=} != 0 ]] && grep -qE -- "$build_re" "$p"; then :
      elif [[ ${l#EXIT=} == 0 ]]; then echo "$who: the test passes on the old code"; bad=1
      else echo "$who: the test didn't run on the old code (no fail line for it, no build failure)"; bad=1
      fi
    fi
  else
    x=$(get base_exempt)
    if [[ -z ${x// /} ]]; then echo "$who has no base_log or base_exempt"; bad=1
    elif (($(wc -w <<<"$x") < 3)); then echo "$who base_exempt is not a reason"; bad=1; fi
  fi

  p=$(get screenshot)
  [[ -n $p ]] && p=$(resolve "$p" "$dir")
  if [[ -z $p || ! -f $p ]] || ! is_image "$p"; then echo "$who screenshot is not an image file in its folder"; bad=1
  elif ! inside "$p" "$dir"; then echo "$who uses a receipt outside its own folder"; bad=1; fi

  for p in "$(get log)" "$(get base_log)" "$(get screenshot)"; do
    [[ -n $p ]] || continue
    p=$(resolve "$p" "$dir")
    [[ -f $p && " $shared" == *" $(inode "$p") "* ]] && { echo "the two reports share a receipt file"; bad=1; break; }
  done
  return $bad
}

# every AC the plan names or either report lists, in number order
acs=$( { printf '%s\n' "$plan_acs"; for f in "${files[@]}"; do jq -r '.ac_status[] | .ac // empty | tostring' "$f"; done; } \
       | awk 'NF { n = $0; sub(/^AC/, "", n); printf "%s\t%s\n", (n ~ /^[0-9]+$/ ? sprintf("%09d", n) : n), $0 }' \
       | sort -u | cut -f2)

total=0 bad=0 proven=0 owed=()
while IFS= read -r ac; do
  [[ -n $ac ]] || continue
  total=$((total + 1)) why="" failed=0 notrun=0
  for i in 0 1; do
    r=$(judge "$i" "$ac"); rc=$?
    [[ -n $r ]] && why="$why${why:+; }${r//$'\n'/; }"
    case $rc in 0) ;; 3) notrun=1 ;; *) failed=1 ;; esac
  done
  if ((failed == 0 && notrun == 0)); then
    proven=$((proven + 1)); printf '%s  ACCEPTED\n' "$ac"
  elif ((failed == 0)) && [[ $live == *" $ac "* ]]; then
    owed+=("$ac"); printf '%s  NOT VERIFIED (live: the user checks it)\n' "$ac"
  else
    bad=$((bad + 1)); printf '%s  NOT ACCEPTED: %s\n' "$ac" "$why"
  fi
done <<<"$acs"

[[ -z $rline ]] || echo "$rline"
if ((withrev)); then
  if ((covered)); then echo "REVIEWS  CLEAN: ${rlast#MOVE ON: }"; else echo "REVIEWS  NOT ACCEPTED: $rlast"; fi
fi
unreviewed=""; ((covered)) || unreviewed="; and the head isn't covered by a clean review"
if ((bad)); then echo "NOT ACCEPTED: $bad of $total ACs on ${HEADSHA:0:7}$unreviewed"; exit 1; fi
if ((!covered)); then echo "NOT ACCEPTED: the head ${HEADSHA:0:7} isn't covered by a clean review ($rlast)"; exit 1; fi
if ((${#owed[@]})); then
  echo "READY FOR THE USER: $proven of $total ACs proven on ${HEADSHA:0:7}; live ACs owed to the user: ${owed[*]}"
  exit 0
fi
echo "ALL ACCEPTED: $total of $total ACs on ${HEADSHA:0:7}"
