#!/usr/bin/env bash
# Acceptance tests for story review-loop (~/.hermes/plans/claude-setup/review-loop.md): the round referee
# review-check.sh, ac-check.sh --reviews, and the rule text that names them.
#   bash review-check.test.sh                    every offline test (ac1-ac10, ac12-ac16)
#   bash review-check.test.sh <test> [<test>…]   just those, numbered TAP: "ok 1 - <test>"
# ac11 and ac17 (regression runs of the existing suites) and the live ac18 (the Mac) run only when named.
# Everything under test comes from this file's own checkout (the review-loop worktree, or $HOME once
# merged), never from the live ~/.claude, ~/.hermes or the real global git config. Each test builds its
# fixtures in a fresh mktemp -d folder (under $TMPDIR) with HOME = a fake home, GIT_CONFIG_GLOBAL = a
# test file and GIT_CONFIG_NOSYSTEM=1. Nothing touches a real repo, the real global config or GitHub.
set -uo pipefail
HERE=$(cd "$(dirname "$0")" && pwd)
SRC=$(cd "$HERE/../../../../.." && pwd)     # the checkout root ($HOME-relative layout)
REAL_HOME=$HOME
# overrides inherited from a git hook or a Claude session would point the tests at real files: drop them
unset GIT_CONFIG_GLOBAL GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL GIT_COMMITTER_NAME \
  GIT_COMMITTER_EMAIL GIT_CONFIG_PARAMETERS GIT_CONFIG_COUNT SUBAGENT_LESSONS_STATE_DIR SUBAGENT_AC_STATE_DIR \
  SKILL_NUDGE_STATE_DIR

OFFLINE="ac1_referee_moves_on_when_clean ac2_referee_reviews_again_on_p0_to_p2
ac3_referee_counts_p2_without_scenario_as_p3 ac4_referee_asks_when_no_progress
ac5_referee_asks_on_repeat_without_new_fact ac6_referee_records_justins_answers ac7_referee_checks_head_coverage
ac8_referee_rejects_bad_records ac9_ac_check_refuses_unreviewed_head ac10_ac_check_accepts_reviewed_head
ac12_docs_name_the_review_loop ac13_codex_roles_name_the_review_loop ac14_feature_dispatch_under_limit
ac15_memory_note_retired ac16_scripts_portable_to_macos"

RC="$HERE/review-check.sh"
ACC="$HERE/ac-check.sh"
FD="$SRC/.hermes/skills/autonomous-ai-agents/feature-dispatch"
NOTE=.claude/projects/-home-justin/memory/review-loop-until-clean.md
SC='An agent commits a fix and the hook skips it'   # a real-use scenario (5+ words)

fail() { echo "FAIL: $*"; return 1; }
need() { [ -e "$1" ] || fail "missing $1 (not built yet)"; }
newroot() { # newroot: a fresh test folder $S, a fake home $H, its git config, and an evidence folder $E
  S=$(mktemp -d "${TMPDIR:-/tmp}/review-check-test.XXXXXX") && S=$(cd "$S" && pwd -P) || return 1
  H="$S/home" E="$S/evidence"; mkdir -p "$H" "$E"
  printf '[user]\n\tname = Test Personal\n\temail = test@example.test\n[init]\n\tdefaultBranch = main\n[advice]\n\tdetachedHead = false\n' >"$S/gitconfig"
}
ing() { HOME="$H" GIT_CONFIG_GLOBAL="$S/gitconfig" GIT_CONFIG_NOSYSTEM=1 "$@"; }
done_ok() { rm -rf "$S"; return 0; }        # remove the test folder on success (kept on failure)
fresh() { rm -rf "$E"; mkdir -p "$E"; }     # an empty evidence folder
srcgit() { # git for the checkout: the worktree, or $HOME's bare repo once merged
  if git -C "$SRC" rev-parse --git-dir >/dev/null 2>&1; then git -C "$SRC" "$@"
  else git --git-dir="$SRC/.claude-setup.git" --work-tree="$SRC" "$@"; fi
}

# ---- fixture repo: $R (its path has a space), main at $BASE, branch story at $C2 (HEAD) after $C1 ----
mkrepo() {
  R="$S/the repo"; mkdir -p "$R" && ing git init -q "$R" || return 1
  echo base >"$R/a.txt" && ing git -C "$R" add a.txt && ing git -C "$R" commit -q -m base || return 1
  BASE=$(ing git -C "$R" rev-parse HEAD) && ing git -C "$R" checkout -q -b story || return 1
  C1=$(cm b.txt one one) && C2=$(cm c.txt two two)
}
cm() { # cm <file> <line> <subject>: append the line to the file and commit it; prints the new sha
  printf '%s\n' "$2" >>"$R/$1" && ing git -C "$R" add -- "$1" && ing git -C "$R" commit -q -m "$3" \
    && ing git -C "$R" rev-parse HEAD
}
empty() { ing git -C "$R" commit -q --allow-empty -m "$1" && ing git -C "$R" rev-parse HEAD; }   # empty <subject>
head_() { ing git -C "$R" rev-parse HEAD; }

# ---- review records ----
finding() { # finding <id> <severity> [scenario, or NONE for no key] [repeats] [new_fact]: one finding's JSON
  jq -nc --arg id "$1" --arg sev "$2" --arg sc "${3-$SC}" --arg rp "${4-}" --arg nf "${5-}" \
    '{id: $id, severity: $sev, file_line: "lib/x.sh:\($id)", claim: "claim of \($id)"}
     + (if $sc == "NONE" then {} else {scenario: $sc} end)
     + (if $rp == "" then {} else {repeats: $rp} end)
     + (if $nf == "" then {} else {new_fact: $nf} end)'
}
rev() { # rev <n> <scope> <from> <head> [finding JSON]…: writes $E/review-<n>/review.json
  local n=$1 sc=$2 f=$3 h=$4; shift 4
  mkdir -p "$E/review-$n"
  { [ $# -gt 0 ] && printf '%s\n' "$@"; } | jq -s --argjson n "$n" --arg s "$sc" --arg f "$f" --arg h "$h" \
    '{round: $n, scope: $s, from: $f, head: $h, findings: .}' >"$E/review-$n/review.json"
}
edit() { # edit <n> <jq filter>: rewrite review-<n>/review.json through the filter
  jq "$2" "$E/review-$1/review.json" >"$S/edit.json" && mv "$S/edit.json" "$E/review-$1/review.json"
}
justin() { mkdir -p "$E/review-$1"; printf '%s\n' "$2" >"$E/review-$1/justin.json"; }   # justin <n> <json>

# ---- running the referee and ac-check.sh: $out (stdout), $err (stderr), $rc, $last (last non-empty stdout line) ----
lastline() { printf '%s\n' "$out" | awk 'NF { l = $0 } END { print l }'; }
referee() { out=$(ing bash "$RC" "$@" 2>"$S/err"); rc=$?; err=$(cat "$S/err"); last=$(lastline); }
judge() { referee --repo "$R" --base "${1:-$BASE}" "$E"; }   # judge [base]: the referee on $R and $E
accheck() { # accheck <base> [options]…: ac-check.sh on $R with $E's plan and reports
  local b=$1; shift
  out=$(ing bash "$ACC" --repo "$R" --base "$b" --plan "$E/plan.md" "$@" "$E/verifier/ac.json" "$E/auditor/ac.json" 2>"$S/err")
  rc=$?; err=$(cat "$S/err"); last=$(lastline)
}
want() { # want <exit code> <exact last line> <what>
  [ "$rc" = "$1" ] && [ "$last" = "$2" ] \
    || fail "$3: want exit $1 and last line [$2], got exit $rc and: $out${err:+ (stderr: $err)}" || return 1
  echo "# $3: $last"
}
has() { printf '%s\n' "$out" | grep -qxF -- "$1" || fail "$2: no line [$1] in: $out"; }   # has <exact line> <what>
# after round 1 the next review is a delta round in Mini but the whole story again in Full, so round 1's
# REVIEW AGAIN names both (later rounds name only the delta review)
again1() { local b=$1; echo "review again (Full: round 2 reviews the whole story from ${b:0:7}; Mini: $2)"; }   # again1 <base> <Mini's review>
fix1() { echo "REVIEW AGAIN: $1 P0-P2 finding(s) in review-1 at ${2:0:7}: fix them, then $(again1 "${3:-$BASE}" "review the fix commits")"; }   # fix1 <count> <head> [base]
bad2() { # bad2 <stderr ERE> <what>: exit 2, an error: line on stderr matching it, and no outcome line
  [ "$rc" = 2 ] || fail "$2: want exit 2, got $rc (out: $out; err: $err)" || return 1
  printf '%s\n' "$err" | grep -q '^error: ' || fail "$2: no error: line on stderr ($err)" || return 1
  printf '%s\n' "$err" | grep -qE -- "$1" || fail "$2: stderr lacks /$1/: $err" || return 1
  if printf '%s\n' "$out" | grep -qE '^(MOVE ON|REVIEW AGAIN|ASK JUSTIN|ALL ACCEPTED|READY FOR THE USER|NOT ACCEPTED)'; then
    fail "$2: printed an outcome: $out"; return 1
  fi
  echo "# exit 2, $2: $(printf '%s\n' "$err" | grep '^error: ' | head -n 1)"
}

# ---- ac-check fixture: a plan and two reports in $E (outside the repo, so the worktree stays clean) ----
acfix() { # acfix <head> <base> <AC>…: $E/plan.md and verifier/auditor reports proving each AC on <head>;
          # an AC written AC2:live is a (live) AC that both agents mark not_run
  local h=$1 b=$2 a ac d; shift 2
  { echo "# Plan"; for a in "$@"; do ac=${a%:live}
      if [ "$a" = "$ac" ]; then echo "- $ac: it works. Test: test_$ac"; else echo "- $ac (live): it works live. Test: test_$ac"; fi
    done; } >"$E/plan.md"
  for d in verifier auditor; do
    mkdir -p "$E/$d"
    for a in "$@"; do
      ac=${a%:live}
      if [ "$a" != "$ac" ]; then jq -nc --arg ac "$ac" '{ac: $ac, accepted: false, not_run: "live: needs the Mac"}'; continue; fi
      printf 'HEAD=%s\nok 1 - test_%s\nEXIT=0\n' "$h" "$ac" >"$E/$d/$ac.log"
      printf 'HEAD=%s\nnot ok 1 - test_%s\nEXIT=1\n' "$b" "$ac" >"$E/$d/$ac-base.log"
      printf '\211PNG\r\n\032\nIHDR' >"$E/$d/$ac.png"
      jq -nc --arg ac "$ac" '{ac: $ac, accepted: true, test: "test_\($ac)", log: "\($ac).log",
        base_log: "\($ac)-base.log", screenshot: "\($ac).png", evidence: "e"}'
    done | jq -s --arg h "$h" '{head: $h, ac_status: .}' >"$E/$d/ac.json"
  done
}
reject_ac1() { jq '.ac_status[0].accepted = false' "$E/auditor/ac.json" >"$S/a.json" && mv "$S/a.json" "$E/auditor/ac.json"; }

# ============================== the referee ==============================

ac1_referee_moves_on_when_clean() {
  local sz
  need "$RC" || return 1
  newroot; mkrepo || fail "fixture repo" || return 1
  rev 1 full "$BASE" "$C2"; judge
  want 0 "MOVE ON: review-1 at ${C2:0:7} is clean" "no findings, at HEAD" || return 1
  [ "$out" = "$last" ] || fail "no findings, but more lines than the outcome: $out" || return 1
  fresh; rev 1 full "$BASE" "$C2" "$(finding R1-1 P3)" "$(finding R1-2 P3 NONE)"; judge
  want 0 "MOVE ON: review-1 at ${C2:0:7} is clean" "only P3s, at HEAD" || return 1
  has "R1-1  P3  lib/x.sh:R1-1  claim of R1-1" "a P3" || return 1
  has "R1-2  P3  lib/x.sh:R1-2  claim of R1-2" "a P3 with no scenario stays P3" || return 1
  [ "$(printf '%s\n' "$out" | grep -c .)" = 3 ] || fail "want two finding lines and the outcome: $out" || return 1
  # a later round judges only itself: review-2 at HEAD with one P3, after review-1's P1 and P2
  fresh; rev 1 full "$BASE" "$C1" "$(finding R1-1 P2)" "$(finding R1-2 P1)"
  rev 2 delta "$C1" "$C2" "$(finding R2-1 P3)"; judge
  want 0 "MOVE ON: review-2 at ${C2:0:7} is clean" "review-2 clean after review-1's findings" || return 1
  has "R2-1  P3  lib/x.sh:R2-1  claim of R2-1" "review-2's P3" || return 1
  if printf '%s\n' "$out" | grep -q 'R1-'; then fail "printed review-1's findings: $out"; return 1; fi
  # records past 128 KiB, Linux's limit on one command-line argument, give the same outcome (R5-4)
  edit 1 '.findings[0].claim = ([range(0; 7000) | "a long claim "] | add)' && edit 2 '.findings[0].claim |= (. as $c | [range(0; 7000) | $c] | add)' \
    && sz=$(( $(cat "$E"/review-*/review.json | wc -c) )) && [ "$sz" -gt 140000 ] || fail "the long records: $sz bytes" || return 1
  judge; want 0 "MOVE ON: review-2 at ${C2:0:7} is clean" "records of $sz bytes" || return 1
  printf '%s\n' "$out" | grep -q '^R2-1  P3  lib/x\.sh:R2-1  claim of R2-1claim of R2-1' || fail "the long P3's line: $(printf '%s' "$out" | cut -c1-80)" || return 1
  done_ok
}

ac2_referee_reviews_again_on_p0_to_p2() {
  local sev
  need "$RC" || return 1
  newroot; mkrepo || fail "fixture repo" || return 1
  for sev in P0 P1 P2; do
    fresh; rev 1 full "$BASE" "$C2" "$(finding R1-1 "$sev")" "$(finding R1-2 P3)"; judge
    want 1 "REVIEW AGAIN: 1 P0-P2 finding(s) in review-1 at ${C2:0:7}: fix them, then review again (Full: round 2 reviews the whole story from ${BASE:0:7}; Mini: review the fix commits)" "one $sev and a P3" || return 1
    has "R1-1  $sev  lib/x.sh:R1-1  claim of R1-1" "the $sev" || return 1
    has "R1-2  P3  lib/x.sh:R1-2  claim of R1-2" "the P3 beside a $sev" || return 1
  done
  fresh; rev 1 full "$BASE" "$C2" "$(finding R1-1 P0)" "$(finding R1-2 P1)" "$(finding R1-3 P2)" "$(finding R1-4 P3)"; judge
  want 1 "$(fix1 3 "$C2")" "a P0, a P1, a P2 and a P3" || return 1
  # the message names the round's own head, not HEAD
  fresh; rev 1 full "$BASE" "$C1" "$(finding R1-1 P2)"; judge
  want 1 "REVIEW AGAIN: 1 P0-P2 finding(s) in review-1 at ${C1:0:7}: fix them, then review again (Full: round 2 reviews the whole story from ${BASE:0:7}; Mini: review the fix commits)" "a P2 at an older head" || return 1
  # Full's round 2 starts at --base (the story's base now), not at review-1's from
  fresh; rev 1 full "$BASE" "$C2" "$(finding R1-1 P2)"; judge "$C1"
  want 1 "REVIEW AGAIN: 1 P0-P2 finding(s) in review-1 at ${C2:0:7}: fix them, then review again (Full: round 2 reviews the whole story from ${C1:0:7}; Mini: review the fix commits)" "--base after review-1's from" || return 1
  # review-2 (and every later round) counts only its own findings, and names only the fix commits
  fresh; rev 1 full "$BASE" "$C1" "$(finding R1-1 P2)" "$(finding R1-2 P2)" "$(finding R1-3 P2)"
  rev 2 full "$BASE" "$C2" "$(finding R2-1 P1)"; judge
  want 1 "REVIEW AGAIN: 1 P0-P2 finding(s) in review-2 at ${C2:0:7}: fix them, then review the fix commits" "review-2's one P1 after review-1's three" || return 1
  # one line per finding, even when file_line or claim holds a tab or a newline
  fresh; rev 1 full "$BASE" "$C2" "$(jq -nc --arg sc "$SC" '{id: "R1-1", severity: "P2", file_line: "lib/a\tb.sh:3",
    claim: "two\nlines", scenario: $sc}')"; judge
  want 1 "$(fix1 1 "$C2")" "a claim with a newline" || return 1
  has "R1-1  P2  lib/a b.sh:3  two lines" "control characters print as spaces" || return 1
  [ "$(printf '%s\n' "$out" | grep -c .)" = 2 ] || fail "want one finding line and the outcome: $out" || return 1
  done_ok
}

ac3_referee_counts_p2_without_scenario_as_p3() {
  local sc sev
  need "$RC" || return 1
  newroot; mkrepo || fail "fixture repo" || return 1
  for sc in NONE "" "   " "edge case" "see claim above" "an agent hits it"; do
    fresh; rev 1 full "$BASE" "$C2" "$(finding R1-1 P2 "$sc")"; judge
    want 0 "MOVE ON: review-1 at ${C2:0:7} is clean" "a P2 with scenario [$sc]" || return 1
    has "R1-1  P3 (no scenario)  lib/x.sh:R1-1  claim of R1-1" "a P2 with scenario [$sc]" || return 1
  done
  for sev in P0 P1; do
    fresh; rev 1 full "$BASE" "$C2" "$(finding R1-1 "$sev" "edge case")"; judge
    want 0 "MOVE ON: review-1 at ${C2:0:7} is clean" "a $sev with scenario [edge case]" || return 1
    has "R1-1  P3 (no scenario)  lib/x.sh:R1-1  claim of R1-1" "a $sev with scenario [edge case]" || return 1
  done
  # five words is enough, with any whitespace between them
  for sc in "an agent hits this bug" "$(printf 'an\tagent\nhits  this bug')"; do
    fresh; rev 1 full "$BASE" "$C2" "$(finding R1-1 P2 "$sc")"; judge
    want 1 "$(fix1 1 "$C2")" "a P2 with a five-word scenario" || return 1
    has "R1-1  P2  lib/x.sh:R1-1  claim of R1-1" "a P2 with a five-word scenario" || return 1
  done
  fresh; rev 1 full "$BASE" "$C2" "$(finding R1-1 P2 "edge case")" "$(finding R1-2 P2)"; judge
  want 1 "$(fix1 1 "$C2")" "a P2 with no scenario beside a real one" || return 1
  done_ok
}

ac4_referee_asks_when_no_progress() {
  local C3
  need "$RC" || return 1
  newroot; mkrepo || fail "fixture repo" || return 1
  rev 1 full "$BASE" "$C1" "$(finding R1-1 P2)"; rev 2 full "$BASE" "$C2" "$(finding R2-1 P2)"; judge
  want 3 "ASK JUSTIN: review-2: 1 P0-P2, no fewer than review-1's 1" "1 then 1" || return 1
  has "R2-1  P2  lib/x.sh:R2-1  claim of R2-1" "the finding line before ASK JUSTIN" || return 1
  fresh; rev 1 full "$BASE" "$C1" "$(finding R1-1 P2)" "$(finding R1-2 P1)"
  rev 2 full "$BASE" "$C2" "$(finding R2-1 P0)" "$(finding R2-2 P2)" "$(finding R2-3 P2)"; judge
  want 3 "ASK JUSTIN: review-2: 3 P0-P2, no fewer than review-1's 2" "2 then 3" || return 1
  fresh; rev 1 full "$BASE" "$C1" "$(finding R1-1 P2)" "$(finding R1-2 P1)"; rev 2 full "$BASE" "$C2" "$(finding R2-1 P2)"; judge
  want 1 "REVIEW AGAIN: 1 P0-P2 finding(s) in review-2 at ${C2:0:7}: fix them, then review the fix commits" "2 then 1" || return 1
  fresh; rev 1 full "$BASE" "$C1" "$(finding R1-1 P3)"; rev 2 delta "$C1" "$C2" "$(finding R2-1 P2)"; judge
  want 1 "REVIEW AGAIN: 1 P0-P2 finding(s) in review-2 at ${C2:0:7}: fix them, then review the fix commits" "0 then 1 (after a clean round)" || return 1
  # effective counts: a no-scenario P2 counts in neither round
  fresh; rev 1 full "$BASE" "$C1" "$(finding R1-1 P2)" "$(finding R1-2 P2 "edge case")"; rev 2 full "$BASE" "$C2" "$(finding R2-1 P2)"; judge
  want 3 "ASK JUSTIN: review-2: 1 P0-P2, no fewer than review-1's 1" "review-1's no-scenario P2 doesn't count" || return 1
  fresh; rev 1 full "$BASE" "$C1" "$(finding R1-1 P2)" "$(finding R1-2 P2)"
  rev 2 full "$BASE" "$C2" "$(finding R2-1 P2)" "$(finding R2-2 P2 "see claim above")"; judge
  want 1 "REVIEW AGAIN: 1 P0-P2 finding(s) in review-2 at ${C2:0:7}: fix them, then review the fix commits" "review-2's no-scenario P2 doesn't count" || return 1
  # only the round just before counts: 3 → 1 → 1 asks, 1 → 3 → 2 doesn't
  C3=$(cm d.txt three three)
  fresh; rev 1 full "$BASE" "$C1" "$(finding R1-1 P2)" "$(finding R1-2 P2)" "$(finding R1-3 P2)"
  rev 2 full "$BASE" "$C2" "$(finding R2-1 P2)"; rev 3 delta "$C2" "$C3" "$(finding R3-1 P2)"; judge
  want 3 "ASK JUSTIN: review-3: 1 P0-P2, no fewer than review-2's 1" "3, 1, then 1" || return 1
  fresh; rev 1 full "$BASE" "$C1" "$(finding R1-1 P2)"
  rev 2 full "$BASE" "$C2" "$(finding R2-1 P2)" "$(finding R2-2 P2)" "$(finding R2-3 P2)"
  rev 3 delta "$C2" "$C3" "$(finding R3-1 P2)" "$(finding R3-2 P2)"; judge
  want 1 "REVIEW AGAIN: 2 P0-P2 finding(s) in review-3 at ${C3:0:7}: fix them, then review the fix commits" "1, 3, then 2" || return 1
  done_ok
}

ac5_referee_asks_on_repeat_without_new_fact() {
  local C3 nf
  need "$RC" || return 1
  newroot; mkrepo || fail "fixture repo" || return 1
  for nf in "" "still broken here"; do
    fresh; rev 1 full "$BASE" "$C1" "$(finding R1-1 P2)" "$(finding R1-2 P2)"
    rev 2 full "$BASE" "$C2" "$(finding R2-1 P2 "$SC" R1-2 "$nf")"; judge
    want 3 "ASK JUSTIN: review-2: repeats with no new fact: R2-1 repeats R1-2" "2 then 1, a repeat with new_fact [$nf]" || return 1
    has "R2-1  P2  lib/x.sh:R2-1  claim of R2-1  (repeats R1-2)" "the repeat's line names what it repeats" || return 1
  done
  fresh; rev 1 full "$BASE" "$C1" "$(finding R1-1 P2)" "$(finding R1-2 P2)"
  rev 2 full "$BASE" "$C2" "$(finding R2-1 P2 "$SC" R1-2 "the fix covers only the short form")"; judge
  want 1 "REVIEW AGAIN: 1 P0-P2 finding(s) in review-2 at ${C2:0:7}: fix them, then review the fix commits" "a repeat with a new fact" || return 1
  # repeating an earlier P3, or an earlier P2 with no scenario, isn't a stall
  fresh; rev 1 full "$BASE" "$C1" "$(finding R1-1 P2)" "$(finding R1-2 P2)" "$(finding R1-3 P3)"
  rev 2 full "$BASE" "$C2" "$(finding R2-1 P2 "$SC" R1-3)"; judge
  want 1 "REVIEW AGAIN: 1 P0-P2 finding(s) in review-2 at ${C2:0:7}: fix them, then review the fix commits" "repeats an earlier P3" || return 1
  fresh; rev 1 full "$BASE" "$C1" "$(finding R1-1 P2)" "$(finding R1-2 P2)" "$(finding R1-3 P2 "edge case")"
  rev 2 full "$BASE" "$C2" "$(finding R2-1 P2 "$SC" R1-3)"; judge
  want 1 "REVIEW AGAIN: 1 P0-P2 finding(s) in review-2 at ${C2:0:7}: fix them, then review the fix commits" "repeats an earlier no-scenario P2" || return 1
  # nor is a P3 (or a no-scenario P2) that repeats an earlier P2
  fresh; rev 1 full "$BASE" "$C1" "$(finding R1-1 P2)" "$(finding R1-2 P2)"
  rev 2 full "$BASE" "$C2" "$(finding R2-1 P3 "$SC" R1-1)" "$(finding R2-2 P2)"; judge
  want 1 "REVIEW AGAIN: 1 P0-P2 finding(s) in review-2 at ${C2:0:7}: fix them, then review the fix commits" "a P3 repeats an earlier P2" || return 1
  fresh; rev 1 full "$BASE" "$C1" "$(finding R1-1 P2)" "$(finding R1-2 P2)"
  rev 2 full "$BASE" "$C2" "$(finding R2-1 P2 "edge case" R1-1)" "$(finding R2-2 P2)"; judge
  want 1 "REVIEW AGAIN: 1 P0-P2 finding(s) in review-2 at ${C2:0:7}: fix them, then review the fix commits" "a no-scenario P2 repeats an earlier P2" || return 1
  # an older round counts too
  C3=$(cm d.txt three three)
  fresh; rev 1 full "$BASE" "$C1" "$(finding R1-1 P2)" "$(finding R1-2 P2)" "$(finding R1-3 P2)"
  rev 2 full "$BASE" "$C2" "$(finding R2-1 P2)" "$(finding R2-2 P2)"
  rev 3 delta "$C2" "$C3" "$(finding R3-1 P2 "$SC" R1-1)"; judge
  want 3 "ASK JUSTIN: review-3: repeats with no new fact: R3-1 repeats R1-1" "review-3 repeats review-1" || return 1
  # two stalls, and both brakes at once
  fresh; rev 1 full "$BASE" "$C1" "$(finding R1-1 P2)" "$(finding R1-2 P2)" "$(finding R1-3 P2)"
  rev 2 full "$BASE" "$C2" "$(finding R2-1 P2 "$SC" R1-1)" "$(finding R2-2 P1 "$SC" R1-2)"; judge
  want 3 "ASK JUSTIN: review-2: repeats with no new fact: R2-1 repeats R1-1, R2-2 repeats R1-2" "two repeats" || return 1
  fresh; rev 1 full "$BASE" "$C1" "$(finding R1-1 P2)"; rev 2 full "$BASE" "$C2" "$(finding R2-1 P2 "$SC" R1-1)"; judge
  want 3 "ASK JUSTIN: review-2: repeats with no new fact: R2-1 repeats R1-1; 1 P0-P2, no fewer than review-1's 1" "both brakes" || return 1
  done_ok
}

ac6_referee_records_justins_answers() {
  local C3 W='"words": "Those are known limits, go on."'
  need "$RC" || return 1
  newroot; mkrepo || fail "fixture repo" || return 1
  rev 1 full "$BASE" "$C2" "$(finding R1-1 P2)" "$(finding R1-2 P1)"; justin 1 "{$W, \"accept\": [\"R1-1\", \"R1-2\"]}"; judge
  want 0 "MOVE ON: review-1 at ${C2:0:7} is clean" "every P0-P2 accepted" || return 1
  has "R1-1  ACCEPTED  lib/x.sh:R1-1  claim of R1-1" "an accepted P2" || return 1
  has "R1-2  ACCEPTED  lib/x.sh:R1-2  claim of R1-2" "an accepted P1" || return 1
  justin 1 "{$W, \"accept\": [\"R1-1\"]}"; judge
  want 1 "$(fix1 1 "$C2")" "one of two accepted" || return 1
  # a later finding whose repeats chain reaches an accepted one is ACCEPTED: it neither counts nor stalls
  C3=$(cm d.txt three three)
  fresh; rev 1 full "$BASE" "$C1" "$(finding R1-1 P2)" "$(finding R1-2 P2)" "$(finding R1-3 P2)"; justin 1 "{$W, \"accept\": [\"R1-1\"]}"
  rev 2 full "$BASE" "$C2" "$(finding R2-1 P2 "$SC" R1-1)" "$(finding R2-2 P2)"; judge
  want 1 "REVIEW AGAIN: 1 P0-P2 finding(s) in review-2 at ${C2:0:7}: fix them, then review the fix commits" "a repeat of an accepted finding" || return 1
  has "R2-1  ACCEPTED  lib/x.sh:R2-1  claim of R2-1  (repeats R1-1)" "a repeat of an accepted finding" || return 1
  rev 3 delta "$C2" "$C3" "$(finding R3-1 P1 "$SC" R2-1)"; judge
  want 0 "MOVE ON: review-3 at ${C3:0:7} is clean" "a repeat of a repeat of an accepted finding" || return 1
  has "R3-1  ACCEPTED  lib/x.sh:R3-1  claim of R3-1  (repeats R2-1)" "a chain of repeats" || return 1
  # an accepted finding doesn't count for brake c either
  fresh; rev 1 full "$BASE" "$C1" "$(finding R1-1 P2)"; justin 1 "{$W, \"accept\": [\"R1-1\"]}"; rev 2 full "$BASE" "$C2" "$(finding R2-1 P2)"; judge
  want 1 "REVIEW AGAIN: 1 P0-P2 finding(s) in review-2 at ${C2:0:7}: fix them, then review the fix commits" "review-1's only P2 accepted" || return 1
  # "continue": true answers that round's ASK JUSTIN with REVIEW AGAIN, and only that round's
  fresh; rev 1 full "$BASE" "$C1" "$(finding R1-1 P2)"; rev 2 full "$BASE" "$C2" "$(finding R2-1 P2 "$SC" R1-1)"; judge
  [ "$rc" = 3 ] || fail "the fixture should ask first: exit $rc, $out" || return 1
  justin 2 '{"words": "Keep going.", "continue": true}'; judge
  want 1 "REVIEW AGAIN: 1 P0-P2 finding(s) in review-2 at ${C2:0:7}: fix them, then review the fix commits" "continue on the round that asked" || return 1
  fresh; rev 1 full "$BASE" "$C1" "$(finding R1-1 P2)"; justin 1 '{"words": "Keep going.", "continue": true}'
  rev 2 full "$BASE" "$C2" "$(finding R2-1 P2)"; judge
  want 3 "ASK JUSTIN: review-2: 1 P0-P2, no fewer than review-1's 1" "continue on an earlier round" || return 1
  # a bad answer exits 2
  fresh; rev 1 full "$BASE" "$C1" "$(finding R1-1 P2)"; rev 2 full "$BASE" "$C2" "$(finding R2-1 P2)"
  printf 'go on' >"$E/review-2/justin.json"; judge; bad2 'justin\.json is not JSON' "justin.json isn't JSON" || return 1
  justin 2 '{"accept": ["R2-1"]}'; judge; bad2 'justin\.json needs words' "justin.json without words" || return 1
  justin 2 '{"words": " ", "continue": true}'; judge; bad2 'justin\.json needs words' "justin.json with blank words" || return 1
  justin 2 "{$W, \"accept\": [\"R2-9\"]}"; judge; bad2 'accepts "R2-9", which review-2 doesn.t list' "accepts an id the round doesn't list" || return 1
  justin 2 "{$W, \"accept\": [\"R1-1\"]}"; judge; bad2 'accepts "R1-1", which review-2 doesn.t list' "accepts another round's id" || return 1
  justin 2 "{$W, \"accept\": \"R2-1\"}"; judge; bad2 'accept must be a list' "accept that isn't a list" || return 1
  justin 2 "{$W, \"accept\": null}"; judge; bad2 'accept must be a list' "accept null" || return 1
  # continue is true or false, and an answer records accept or continue: words alone would ask him again
  justin 2 '{"words": "Keep going.", "continue": "true"}'; judge
  bad2 'review-2/justin\.json: continue must be true or false' "continue as text" || return 1
  justin 2 '{"words": "Keep going.", "continue": null}'; judge; bad2 'continue must be true or false' "continue null" || return 1
  justin 2 "{$W}"; judge; bad2 'review-2/justin\.json needs accept .* or continue' "words alone" || return 1
  justin 2 '{}'; judge; bad2 'review-2/justin\.json needs words' "an empty answer" || return 1
  justin 2 'null'; judge; bad2 'review-2/justin\.json needs words' "a null answer" || return 1
  justin 2 '{"words": "No, stop here.", "continue": false}'; judge
  want 3 "ASK JUSTIN: review-2: 1 P0-P2, no fewer than review-1's 1" "continue false: a valid answer that changes nothing" || return 1
  rm "$E/review-2/justin.json"; justin 1 '{"continue": true}'; judge; bad2 'review-1/justin\.json needs words' "an earlier round's bad answer" || return 1
  done_ok
}

ac7_referee_checks_head_coverage() {
  local CE C3 C4 C5 M1 M2 NH O1 O2 L P A B0 B0N S1 S2 T0 K1 K2 K3 K4 TM Q4 Q4C G
  need "$RC" || return 1
  newroot; mkrepo || fail "fixture repo" || return 1
  # every referee run in this test makes its temporary files here, so notmp sees all of them
  mkdir -p "$S/tmp" && TMPDIR="$S/tmp" && export TMPDIR || fail "TMPDIR" || return 1
  ing git -C "$R" config color.ui always   # a colour setting must not change what the referee compares
  CE=$(empty records) && C3=$(printf 'x="a b"\n' >"$R/d.sh" && ing git -C "$R" add d.sh && ing git -C "$R" commit -q -m three && head_) \
    || fail "fixture commits" || return 1
  rev 1 full "$BASE" "$C3"; judge
  want 0 "MOVE ON: review-1 at ${C3:0:7} is clean" "HEAD is the reviewed head" || return 1
  C4=$(cm e.txt four four); judge
  want 1 "REVIEW AGAIN: 1 commit(s) after review-1's head ${C3:0:7} are unreviewed: review again (Full: round 2 reviews the whole story from ${BASE:0:7}; Mini: review ${C3:0:7}..${C4:0:7})" "a commit after the reviewed head" || return 1
  C5=$(empty notes); judge
  want 1 "REVIEW AGAIN: 2 commit(s) after review-1's head ${C3:0:7} are unreviewed: $(again1 "$BASE" "review ${C3:0:7}..${C5:0:7}")" "two commits after, one empty" || return 1
  ing git -C "$R" checkout -q -B work "$C2"; judge
  want 1 "REVIEW AGAIN: HEAD ${C2:0:7} is not review-1's head ${C3:0:7} or a pure rebase of it: review again (Full: round 2 reviews the whole story from ${BASE:0:7}; Mini: review what changed since ${C3:0:7})" "HEAD reset behind the reviewed head" || return 1
  # main moves on; the story is rebased onto it (--base is then the new merge-base)
  ing git -C "$R" checkout -q main && M1=$(cm m.txt m1 m1) || fail "main commit" || return 1
  ing git -C "$R" checkout -q -B work "$C3" && ing git -C "$R" rebase -q main >/dev/null 2>&1 || fail "rebase" || return 1
  NH=$(head_); judge "$M1"
  want 0 "MOVE ON: review-1 at ${C3:0:7} is clean, and HEAD ${NH:0:7} is a pure rebase of it" "git rebase onto a newer main" || return 1
  replay() { # replay <commit>…: branch work = main plus these commits, cherry-picked in order
    local c
    ing git -C "$R" checkout -q -B work main || return 1
    for c in "$@"; do ing git -C "$R" cherry-pick --allow-empty "$c" >/dev/null 2>&1 || return 1; done
  }
  again() { # again <what>: HEAD is not a pure rebase of the reviewed head
    judge "$M1"
    want 1 "REVIEW AGAIN: HEAD $(head_ | cut -c1-7) is not review-1's head ${C3:0:7} or a pure rebase of it: $(again1 "$M1" "review what changed since ${C3:0:7}")" "$1"
  }
  replay "$C1" "$C2" "$CE" "$C3" || fail "replay" || return 1; NH=$(head_); judge "$M1"
  want 0 "MOVE ON: review-1 at ${C3:0:7} is clean, and HEAD ${NH:0:7} is a pure rebase of it" "the same commits picked onto main" || return 1
  # patch-ids git can't compute are an error, not empty ids that compare equal: a git older than 2.39
  # (no patch-id --verbatim), or diff-tree failing on one commit of either side (a missing object)
  mkdir -p "$S/fakegit" && cat >"$S/fakegit/git" <<'SH' && chmod +x "$S/fakegit/git" || fail "fake git" || return 1
#!/bin/sh
[ -x "${REAL_GIT-}" ] && [ "$REAL_GIT" != "$0" ] || { echo "fake git: REAL_GIT is not the real git" >&2; exit 125; }
case " $* " in
  *" patch-id "*) if [ -n "${FAKE_OLD_GIT-}" ]; then
      printf '%s\n' 'error: unknown option `verbatim'"'" 'usage: git patch-id [--stable | --unstable]' >&2; exit 129
    fi ;;
  *" diff-tree "*" ${FAKE_BAD_COMMIT-none} "*) printf '%s\n' "fatal: bad object ${FAKE_BAD_COMMIT-}" 'fake git: a second line' >&2; exit 128 ;;
esac
exec "$REAL_GIT" "$@"
SH
  fakegit() { # fakegit <command>…: with the fake git first on PATH (the real one found before PATH changes)
    local g; g=$(command -v git) || return 1
    PATH="$S/fakegit:$PATH" REAL_GIT=$g "$@"
  }
  notmp() { [ -z "$(ls -A "$S/tmp")" ] || fail "$1: the referee left files in its TMPDIR: $(ls -A "$S/tmp")"; }   # notmp <what>
  gitfailed() { # gitfailed <git's first stderr line> <what>: exit 2, and stderr is only the referee's error
                # line, naming git's first line (ac-check.sh reports the first error: line)
    local want="error: can't compute the patch-ids that compare HEAD $(head_ | cut -c1-7) with review-1's head ${C3:0:7} (git diff-tree | git patch-id --verbatim failed: $1)"
    bad2 "can't compute the patch-ids" "$2" || return 1
    [ "$err" = "$want" ] || fail "$2: want stderr to be just [$want], got [$err]" || return 1
    notmp "$2"
  }
  FAKE_OLD_GIT=1 fakegit judge "$M1"; gitfailed "error: unknown option \`verbatim'" "git patch-id fails" || return 1
  FAKE_BAD_COMMIT=$NH fakegit judge "$M1"; gitfailed "fatal: bad object $NH" "diff-tree fails on HEAD's side" || return 1
  FAKE_BAD_COMMIT=$C3 fakegit judge "$M1"; gitfailed "fatal: bad object $C3" "diff-tree fails on the reviewed side" || return 1
  fakegit judge "$M1"
  want 0 "MOVE ON: review-1 at ${C3:0:7} is clean, and HEAD ${NH:0:7} is a pure rebase of it" "control: the fake git, nothing failing" || return 1
  notmp "a pure rebase" || return 1
  # a TMPDIR that is a missing folder: the comparison doesn't need a temporary file, only keeping git's
  # message does, so the outcome is the same and stderr stays the one error: line
  TMPDIR="$S/gone dir" judge "$M1"
  want 0 "MOVE ON: review-1 at ${C3:0:7} is clean, and HEAD ${NH:0:7} is a pure rebase of it" "a pure rebase, TMPDIR a missing folder" || return 1
  [ -z "$err" ] || fail "a pure rebase, TMPDIR a missing folder: want no stderr, got [$err]" || return 1
  FAKE_OLD_GIT=1 TMPDIR="$S/gone dir" fakegit judge "$M1"
  gitfailed "git's message was lost (no temporary file in $S/gone dir)" "git patch-id fails, TMPDIR a missing folder" || return 1
  replay "$C1" "$C2" "$CE" || fail "replay" || return 1
  printf 'x="a  b"\n' >"$R/d.sh" && ing git -C "$R" add d.sh && ing git -C "$R" commit -q -m three || fail "commit" || return 1
  again "a patch changed only in whitespace" || return 1
  notmp "a patch changed only in whitespace" || return 1
  FAKE_OLD_GIT=1 fakegit judge "$M1"
  gitfailed "error: unknown option \`verbatim'" "a whitespace-changed patch, git patch-id failing" || return 1
  replay "$C1" || fail "replay" || return 1
  cm c.txt 'two!' two >/dev/null && ing git -C "$R" cherry-pick --allow-empty "$CE" "$C3" >/dev/null 2>&1 || fail "replay" || return 1
  again "a patch changed, same subject" || return 1
  replay "$C1" "$CE" "$C3" || fail "replay" || return 1;             again "a commit dropped" || return 1
  replay "$C1" "$C2" "$CE" "$C3" && cm f.txt five five >/dev/null || fail "replay" || return 1; again "a commit added" || return 1
  replay "$C2" "$C1" "$CE" "$C3" || fail "replay" || return 1;       again "two commits swapped" || return 1
  replay "$C1" "$C2" || fail "replay" || return 1
  empty other >/dev/null && ing git -C "$R" cherry-pick "$C3" >/dev/null 2>&1 || fail "replay" || return 1
  again "the empty commit's message changed" || return 1
  replay "$C1" "$C2" "$C3" || fail "replay" || return 1;             again "the empty commit dropped" || return 1
  # a merge of main instead of a rebase: the same patches, but a merge commit no review saw
  replay "$C1" "$C2" "$CE" "$C3" || fail "replay" || return 1
  ing git -C "$R" checkout -q main && M2=$(cm m.txt m2 m2) && ing git -C "$R" checkout -q work \
    && ing git -C "$R" merge -q --no-ff -m merge main >/dev/null 2>&1 || fail "merge" || return 1
  judge "$M2"
  want 1 "REVIEW AGAIN: HEAD $(head_ | cut -c1-7) is not review-1's head ${C3:0:7} or a pure rebase of it: $(again1 "$M2" "review what changed since ${C3:0:7}")" "a merge commit" || return 1
  # a clean delta round: HEAD a pure rebase of its head moves on
  fresh; rev 1 full "$BASE" "$C2" "$(finding R1-1 P2)"; rev 2 delta "$C2" "$C3"
  ing git -C "$R" checkout -q -B work "$C3" && ing git -C "$R" rebase -q main >/dev/null 2>&1 || fail "rebase" || return 1
  NH=$(head_); judge "$M2"
  want 0 "MOVE ON: review-2 at ${C3:0:7} is clean, and HEAD ${NH:0:7} is a pure rebase of it" "a clean delta round, rebased" || return 1
  # a reviewed head with no common history with HEAD
  ing git -C "$R" checkout -q --orphan lone && ing git -C "$R" rm -rq --cached . && O1=$(cm o.txt o1 o1) && O2=$(cm o.txt o2 o2) \
    && ing git -C "$R" checkout -q -f work || fail "orphan branch" || return 1
  fresh; rev 1 full "$BASE" "$C2"; rev 2 delta "$C2" "$O2"; judge "$M2"
  want 1 "REVIEW AGAIN: HEAD ${NH:0:7} is not review-2's head ${O2:0:7} or a pure rebase of it: review what changed since ${O2:0:7}" "a reviewed head on unrelated history" || return 1
  # a full round's from is --base or an older commit of it (above: the old base after a rebase moved --base
  # on); otherwise the round didn't review the whole story: run a full review from --base
  fresh; rev 1 full "$O1" "$O2"; judge "$M2"
  want 1 "REVIEW AGAIN: review-1's from ${O1:0:7} is not on --base ${M2:0:7}'s history: run a full review from ${M2:0:7}" "a full review on unrelated history" || return 1
  P=$(ing git -C "$R" rev-parse HEAD~1) || fail "HEAD~1" || return 1
  fresh; rev 1 full "$P" "$NH"; judge "$M2"
  want 1 "REVIEW AGAIN: review-1's from ${P:0:7} is not on --base ${M2:0:7}'s history: run a full review from ${M2:0:7}" "a full review from a commit inside the story, at HEAD" || return 1
  fresh; rev 1 full "$P" "$NH" "$(finding R1-1 P2)"; judge "$M2"
  want 1 "REVIEW AGAIN: 1 P0-P2 finding(s) in review-1 at ${NH:0:7}: fix them, then run a full review from ${M2:0:7} (review-1's from ${P:0:7} is not on its history)" "a full review from inside the story, a P2 left" || return 1
  # sync.sh rebases local main onto the other machine's push, rewriting an unpushed sync commit B0 that the
  # story was cut from: B0 is then on neither --base's history nor main's. The record is true, so not exit 2.
  R="$S/sync repo"; mkdir -p "$R" && ing git init -q "$R" && A=$(cm a.txt a pushed) && B0=$(cm n.md n1 "sync(desktop)") \
    && ing git -C "$R" checkout -q -b story && S1=$(cm s.sh one one) && S2=$(cm s.sh two two) \
    && ing git -C "$R" checkout -q -b mac "$A" && cm x.txt x "sync(mac)" >/dev/null \
    && ing git -C "$R" checkout -q main && ing git -C "$R" rebase -q mac >/dev/null 2>&1 && B0N=$(head_) \
    && ing git -C "$R" checkout -q story && L=$(ing git -C "$R" merge-base HEAD main) && [ "$L" = "$A" ] \
    || fail "sync fixture" || return 1
  fresh; rev 1 full "$B0" "$S1" "$(finding R1-1 P2)"; rev 2 full "$B0" "$S2"; judge "$L"
  want 1 "REVIEW AGAIN: review-2's from ${B0:0:7} is not on --base ${A:0:7}'s history: run a full review from ${A:0:7}" "a sync rebase rewrote the story's base" || return 1
  judge "$B0"; want 0 "MOVE ON: review-2 at ${S2:0:7} is clean" "control: the reviewer's self-check with the brief's base" || return 1
  edit 2 '.findings = [ {id: "R2-1", severity: "P2", file_line: "s.sh:1", claim: "c", scenario: "An agent runs it and it breaks"} ]'; judge "$L"
  want 3 "ASK JUSTIN: review-2: 1 P0-P2, no fewer than review-1's 1" "the base rule doesn't skip the brakes" || return 1
  justin 2 '{"words": "go on", "continue": true}'; judge "$L"
  want 1 "REVIEW AGAIN: 1 P0-P2 finding(s) in review-2 at ${S2:0:7}: fix them, then run a full review from ${A:0:7} (review-2's from ${B0:0:7} is not on its history)" "Justin's continue, from off --base's history" || return 1
  fresh; rev 1 full "$B0" "$S1" "$(finding R1-1 P2)"; rev 2 full "$B0" "$S2"; rev 3 full "$A" "$S2"; judge "$L"
  want 0 "MOVE ON: review-3 at ${S2:0:7} is clean" "then a full review from --base moves on" || return 1

  # ---- the base rule, as a table of record sequences ----
  # Every delta round builds on the latest full round (each starts at the round before's head), so the
  # rounds since that full round cover its from..head. That from must be --base or an older commit of it;
  # otherwise (a from inside the story, a base commit sync.sh rewrote, a from that is no longer a commit)
  # the answer is REVIEW AGAIN: run a full review from --base, however many clean delta rounds follow,
  # until a full round from --base is recorded. The brakes and Justin's answers still apply first.
  # recs <round spec>…: a fresh evidence folder, round k from the k-th spec "<scope> <from> <head> [<word>…]":
  # each P0-P3 word is one finding R<k>-<i> with a real-use scenario; continue or accept is Justin's answer
  # to that round ("continue": true, or accept: every finding the round lists)
  recs() {
    local spec k=0 i w sc f h fl ja jc
    fresh
    for spec in "$@"; do
      k=$((k + 1)) i=0 fl="" ja="" jc=""
      set -- $spec; sc=$1 f=$2 h=$3; shift 3
      while [ $# -gt 0 ]; do
        w=$1; shift
        case $w in
          continue) jc=1 ;;
          accept) ja=1 ;;
          *) i=$((i + 1)); fl="$fl$(finding "R$k-$i" "$w")"$'\n' ;;
        esac
      done
      mkdir -p "$E/review-$k" && printf '%s' "$fl" | jq -s --argjson n "$k" --arg s "$sc" --arg f "$f" --arg h "$h" \
        '{round: $n, scope: $s, from: $f, head: $h, findings: .}' >"$E/review-$k/review.json" || return 1
      if [ -n "$ja$jc" ]; then
        justin "$k" "$(jq -nc --arg k "$k" --argjson n "$i" --arg a "$ja" --arg c "$jc" '{words: "Justin says go on"}
          + (if $a == "" then {} else {accept: [range(1; $n + 1) | "R\($k)-\(.)"]} end)
          + (if $c == "" then {} else {continue: true} end)')" || return 1
      fi
    done
  }
  rows=0 rowsbad=0
  row() { # row <what> <base> <exit> <last line> <round spec>…: those rounds, then the referee on $R with that --base;
          # a row that fails is counted, and the table goes on (tablecheck fails the test)
    local what=$1 b=$2 x=$3 l=$4; shift 4
    rows=$((rows + 1))
    if recs "$@"; then judge "$b"; want "$x" "$l" "$what" && return 0
    else fail "$what: the records"; fi
    rowsbad=$((rowsbad + 1))
  }
  tablecheck() { [ "$rowsbad" = 0 ] || fail "$rowsbad of $rows rows of the base-rule table failed"; }
  offbase() { echo "REVIEW AGAIN: review-$1's from ${2:0:7} is not on --base ${3:0:7}'s history: run a full review from ${3:0:7}"; }   # offbase <k> <from> <base>
  fixfull() { # fixfull <count> <n> <head> <base> <k> <from>: P0-P2 left, and the latest full round's from is off --base
    echo "REVIEW AGAIN: $1 P0-P2 finding(s) in review-$2 at ${3:0:7}: fix them, then run a full review from ${4:0:7} (review-$5's from ${6:0:7} is not on its history)"
  }
  R="$S/table repo"; mkdir -p "$R" && ing git init -q "$R" && T0=$(cm a.txt base base) && ing git -C "$R" checkout -q -b story \
    && K1=$(cm s.sh k1 k1) && K2=$(cm s.sh k2 k2) && K3=$(cm s.sh k3 "fix R1-1") && K4=$(cm s.sh k4 "fix R2-1") \
    || fail "table fixture" || return 1
  G=$(printf '%040d' 0 | tr 0 e)   # a from that is no longer a commit (garbage-collected)
  # HEAD K4 (story: base T0, then K1 K2, fix commits K3 K4), --base T0
  row "full from --base, clean"                               "$T0" 0 "MOVE ON: review-1 at ${K4:0:7} is clean"            "full $T0 $K4"
  row "full from inside the story, clean"                     "$T0" 1 "$(offbase 1 "$K1" "$T0")"                           "full $K1 $K4"
  row "full from inside the story, a P2"                      "$T0" 1 "$(fixfull 1 1 "$K4" "$T0" 1 "$K1")"                 "full $K1 $K4 P2"
  row "full from --base, a P2; a clean delta"                 "$T0" 0 "MOVE ON: review-2 at ${K4:0:7} is clean"            "full $T0 $K2 P2" "delta $K2 $K4"
  row "full from --base, a P2; two clean deltas"              "$T0" 0 "MOVE ON: review-3 at ${K4:0:7} is clean"            "full $T0 $K2 P2" "delta $K2 $K3" "delta $K3 $K4"
  row "full from inside, a P2; a clean delta (R3-1)"          "$T0" 1 "$(offbase 1 "$K1" "$T0")"                           "full $K1 $K2 P2" "delta $K2 $K4"
  row "full from inside, a P2; two clean deltas"              "$T0" 1 "$(offbase 1 "$K1" "$T0")"                           "full $K1 $K2 P2" "delta $K2 $K3" "delta $K3 $K4"
  row "full from a commit that's gone, a P2; a clean delta"   "$T0" 1 "$(offbase 1 "$G" "$T0")"                            "full $G $K2 P2" "delta $K2 $K4"
  row "full from inside, a P2; a clean delta, then a commit"  "$T0" 1 "$(offbase 1 "$K1" "$T0")"                           "full $K1 $K2 P2" "delta $K2 $K3"
  row "control: full from --base; a clean delta, then a commit" "$T0" 1 "REVIEW AGAIN: 1 commit(s) after review-2's head ${K3:0:7} are unreviewed: review ${K3:0:7}..${K4:0:7}" "full $T0 $K2 P2" "delta $K2 $K3"
  row "full from inside, two P2s; a delta with one"           "$T0" 1 "$(fixfull 1 2 "$K4" "$T0" 1 "$K1")"                 "full $K1 $K2 P2 P2" "delta $K2 $K4 P2"
  row "full from inside, a P2; a delta with a P2 (brake c)"   "$T0" 3 "ASK JUSTIN: review-2: 1 P0-P2, no fewer than review-1's 1" "full $K1 $K2 P2" "delta $K2 $K4 P2"
  row "the same, and Justin's continue"                       "$T0" 1 "$(fixfull 1 2 "$K4" "$T0" 1 "$K1")"                 "full $K1 $K2 P2" "delta $K2 $K4 P2 continue"
  row "the same, and Justin accepts the P2"                   "$T0" 1 "$(offbase 1 "$K1" "$T0")"                           "full $K1 $K2 P2" "delta $K2 $K4 P2 accept"
  row "control: full from --base, Justin accepts the delta's P2" "$T0" 0 "MOVE ON: review-2 at ${K4:0:7} is clean"         "full $T0 $K2 P2" "delta $K2 $K4 P2 accept"
  row "full from inside; a clean delta; a full from --base"   "$T0" 0 "MOVE ON: review-3 at ${K4:0:7} is clean"            "full $K1 $K2 P2" "delta $K2 $K3" "full $T0 $K4"
  row "full from inside; a full from --base, a P2; a clean delta" "$T0" 0 "MOVE ON: review-3 at ${K4:0:7} is clean"        "full $K1 $K2 P2" "full $T0 $K3 P2" "delta $K3 $K4"
  row "full from --base; a full from inside, a P2; a clean delta" "$T0" 1 "$(offbase 2 "$K1" "$T0")"                       "full $T0 $K2 P2" "full $K1 $K3 P2" "delta $K3 $K4"
  # the finisher's rebase: main gets TM; the story's commits are picked onto it unchanged (HEAD Q4, --base TM)
  ing git -C "$R" checkout -q main && TM=$(cm m.txt tm tm) && ing git -C "$R" checkout -q -B work "$K4" \
    && ing git -C "$R" rebase -q main >/dev/null 2>&1 && Q4=$(head_) || fail "table rebase" || return 1
  row "rebased: full from the old base, clean"                "$TM" 0 "MOVE ON: review-1 at ${K4:0:7} is clean, and HEAD ${Q4:0:7} is a pure rebase of it" "full $T0 $K4"
  row "rebased: full from inside, clean"                      "$TM" 1 "$(offbase 1 "$K1" "$TM")"                           "full $K1 $K4"
  row "rebased: full from the old base, a P2; a clean delta"  "$TM" 0 "MOVE ON: review-2 at ${K4:0:7} is clean, and HEAD ${Q4:0:7} is a pure rebase of it" "full $T0 $K2 P2" "delta $K2 $K4"
  row "rebased: full from inside, a P2; a clean delta"        "$TM" 1 "$(offbase 1 "$K1" "$TM")"                           "full $K1 $K2 P2" "delta $K2 $K4"
  # a rebase that resolved a conflict changes a patch (HEAD Q4C); the next delta round reviews it (range-diff)
  printf 'k4 resolved\n' >>"$R/s.sh" && ing git -C "$R" commit -q -a --amend -m "fix R2-1" && Q4C=$(head_) \
    || fail "table conflict rebase" || return 1
  row "conflict rebase: full from the old base, a P2; a clean delta" "$TM" 1 "REVIEW AGAIN: HEAD ${Q4C:0:7} is not review-2's head ${K4:0:7} or a pure rebase of it: review what changed since ${K4:0:7}" "full $T0 $K2 P2" "delta $K2 $K4"
  row "conflict rebase: then a clean delta of the rebase"     "$TM" 0 "MOVE ON: review-3 at ${Q4C:0:7} is clean"           "full $T0 $K2 P2" "delta $K2 $K4" "delta $K4 $Q4C"
  row "conflict rebase: the same, full from inside"           "$TM" 1 "$(offbase 1 "$K1" "$TM")"                           "full $K1 $K2 P2" "delta $K2 $K4" "delta $K4 $Q4C"
  # the sync rewrite (sync repo above: the story S1 S2 was cut from B0; main is now A, sync(mac), B0N)
  R="$S/sync repo"
  row "sync: full from B0, a P2; a clean delta; --base B0 (the reviewer's self-check)" "$B0" 0 "MOVE ON: review-2 at ${S2:0:7} is clean" "full $B0 $S1 P2" "delta $S1 $S2"
  row "sync: the same with --base A, after the rewrite"       "$A" 1 "$(offbase 1 "$B0" "$A")"                             "full $B0 $S1 P2" "delta $S1 $S2"
  row "sync: the same with Justin's continue on a P2"         "$A" 1 "$(fixfull 1 2 "$S2" "$A" 1 "$B0")"                   "full $B0 $S1 P2" "delta $S1 $S2 P2 continue"
  row "sync: then a full round from A"                        "$A" 0 "MOVE ON: review-3 at ${S2:0:7} is clean"             "full $B0 $S1 P2" "delta $S1 $S2" "full $A $S2"

  # the finisher's git rebase main: B0's patch is on main already (B0N), so git drops B0: S1', S2' on B0N
  recs "full $B0 $S1 P2" "full $B0 $S2" && ing git -C "$R" rebase -q main >/dev/null 2>&1 && NH=$(head_) \
    && L=$(ing git -C "$R" merge-base HEAD main) && [ "$L" = "$B0N" ] || fail "finisher rebase" || return 1
  judge "$L"
  want 1 "REVIEW AGAIN: review-2's from ${B0:0:7} is not on --base ${B0N:0:7}'s history: run a full review from ${B0N:0:7}" "the same, after the finisher's rebase" || return 1
  rev 3 full "$B0N" "$NH"; judge "$L"
  want 0 "MOVE ON: review-3 at ${NH:0:7} is clean" "then a full review from the rebased --base moves on" || return 1
  row "sync, rebased: full from B0, a P2; a clean delta"      "$L" 1 "$(offbase 1 "$B0" "$B0N")"                           "full $B0 $S1 P2" "delta $S1 $S2"
  row "sync, rebased: then a full round from A (the rebase dropped B0)" "$L" 1 "REVIEW AGAIN: HEAD ${NH:0:7} is not review-3's head ${S2:0:7} or a pure rebase of it: review what changed since ${S2:0:7}" "full $B0 $S1 P2" "delta $S1 $S2" "full $A $S2"
  row "sync, rebased: then a clean delta of the rebase"       "$L" 0 "MOVE ON: review-4 at ${NH:0:7} is clean"             "full $B0 $S1 P2" "delta $S1 $S2" "full $A $S2" "delta $S2 $NH"
  row "sync, rebased: or a full round from B0N"               "$L" 0 "MOVE ON: review-3 at ${NH:0:7} is clean"             "full $B0 $S1 P2" "delta $S1 $S2" "full $B0N $NH"
  tablecheck || return 1
  notmp "every referee run in this test" || return 1
  done_ok
}

ac8_referee_rejects_bad_records() {
  local C3 M1 G
  need "$RC" || return 1
  newroot; mkrepo || fail "fixture repo" || return 1
  G=$(printf '%040d' 0 | tr 0 f)   # 40 hex digits, no commit in the repo
  rev 1 full "$BASE" "$C2"
  referee --base "$BASE" "$E";                         bad2 'usage' "no --repo" || return 1
  referee --repo "$R" "$E";                            bad2 'usage' "no --base" || return 1
  referee --repo "$R" --base "$BASE";                  bad2 'usage' "no evidence folder" || return 1
  referee --repo "$R" --base;                          bad2 'usage' "--base without a value" || return 1
  referee --repo "$R" --base "$BASE" "$E" "$E";        bad2 'usage' "two evidence folders" || return 1
  referee --repo "$R" --base "$BASE" --fast "$E";      bad2 'usage' "an unknown option" || return 1
  referee --repo "$R" --base "$BASE" "$S/none";        bad2 'no evidence folder' "a folder that doesn't exist" || return 1
  referee --repo "$H" --base "$BASE" "$E";             bad2 'not a git worktree' "--repo that isn't a repo" || return 1
  referee --repo "$R" --base nope "$E";                bad2 'is not a commit' "an unknown --base" || return 1
  referee --repo "$R" --base "$C2" "$E";               bad2 'older commit' "--base equal to HEAD" || return 1
  ing git -C "$R" checkout -q main && M1=$(cm m.txt m1 m1) && ing git -C "$R" checkout -q story || fail "main commit" || return 1
  referee --repo "$R" --base "$M1" "$E";               bad2 'older commit' "--base not under HEAD" || return 1
  fresh; judge;                                        bad2 'review-1/review\.json is missing' "no review records" || return 1
  rev 1 full "$BASE" "$C1"; rev 3 delta "$C1" "$C2"; judge
  bad2 "review-3/review\.json exists but review-2/review\.json doesn't" "a gap: review-1, review-3" || return 1
  fresh; mkdir -p "$E/review-1"; printf 'not json' >"$E/review-1/review.json"; judge; bad2 'review-1/review\.json is not JSON' "a file that isn't JSON" || return 1
  : >"$E/review-1/review.json"; judge;                bad2 'review-1/review\.json is not JSON' "an empty file" || return 1
  printf '[]' >"$E/review-1/review.json"; judge;      bad2 'not a JSON object' "a list" || return 1
  rev 2 full "$BASE" "$C2"; judge;                     bad2 '^error: review-1/review\.json is not a JSON object$' "an earlier round that's a list" || return 1
  rev 2 delta "$C1" "$C2"; judge;                      bad2 '^error: review-1/review\.json is not a JSON object$' "an earlier list before a delta round" || return 1
  bad() { fresh; rev 1 full "$BASE" "$C2" "$(finding R1-1 P2)" "$(finding R1-2 P3)"; edit 1 "$1"; judge; bad2 "$2" "$3"; }
  bad '.round = 2'                       'review-1: round is 2, want 1'             "round 2 in review-1" || return 1
  bad '.round = "1"'                     'review-1: round is "1", want 1'           "round as text" || return 1
  bad '.scope = "partial"'               'scope must be full or delta'              "scope partial" || return 1
  bad '.scope = "delta"'                 'review-1 must be a full review'           "review-1 as a delta" || return 1
  bad ".head = \"${C2:0:7}\""            'head must be a full 40-character sha'     "a short head" || return 1
  bad ".from = \"${BASE:0:7}\""          'from must be a full 40-character sha'     "a short from" || return 1
  bad ".head = \"$G\""                   "review-1's head ffffff. is not a commit"  "a head that isn't a commit" || return 1
  bad ".from = \"$G\""                   "review-1's from ffffff. is not a commit"  "a from that isn't a commit" || return 1
  bad ".from = \"$C2\""                  'is not an older commit of its head'       "a full review from its own head" || return 1
  bad ".from = \"$C2\" | .head = \"$C1\"" 'is not an older commit of its head'      "a full review from a later commit" || return 1
  bad '.findings = {}'                   'findings must be a list'                  "findings as an object" || return 1
  bad '.findings[0] = "R1-1"'            'a finding is not an object'               "a finding as text" || return 1
  bad '.findings[0].id = "R2-1"'         'finding id "R2-1" must start R1-'         "an id from another round" || return 1
  bad '.findings[0].id = "X1"'           'finding id "X1" must start R1-'           "an id without R<n>-" || return 1
  bad 'del(.findings[0].id)'             'finding id null must start R1-'           "no id" || return 1
  bad '.findings[1].id = "R1-1"'         'a finding id is listed twice'             "an id twice" || return 1
  bad '.findings[0].severity = "P4"'     'R1-1: severity must be P0, P1, P2 or P3'  "severity P4" || return 1
  bad '.findings[0].severity = "p2"'     'R1-1: severity must be P0, P1, P2 or P3'  "severity p2" || return 1
  bad '.findings[0].file_line = ""'      'R1-1: file_line and claim are required'   "an empty file_line" || return 1
  bad 'del(.findings[0].claim)'          'R1-1: file_line and claim are required'   "no claim" || return 1
  bad '.findings[0].scenario = 5'        'R1-1: scenario, repeats and new_fact are text' "a number scenario" || return 1
  bad '.findings[0].scenario = ["a"]'    'R1-1: scenario, repeats and new_fact are text' "a list scenario" || return 1
  bad '.findings[0].new_fact = {}'       'R1-1: scenario, repeats and new_fact are text' "an object new_fact" || return 1
  bad '.findings[0].repeats = 1'         'R1-1: scenario, repeats and new_fact are text' "a number repeats" || return 1
  bad '.findings[0].repeats = "R1-2"'    'R1-1: repeats "R1-2", which no earlier review lists' "repeats its own round" || return 1
  C3=$(cm d.txt three three)
  fresh; rev 1 full "$BASE" "$C1" "$(finding R1-1 P2)"; rev 2 delta "$C1" "$C3" "$(finding R2-1 P2 "$SC" R1-9)"; judge
  bad2 'review-2 R2-1: repeats "R1-9", which no earlier review lists' "repeats an id no round lists" || return 1
  fresh; rev 1 full "$BASE" "$C1"; rev 2 delta "$BASE" "$C3"; judge
  bad2 "review-2: a delta review starts at review-1's head, not ${BASE:0:7}" "a delta that doesn't start at the round before's head" || return 1
  fresh; rev 1 full "$BASE" "$C1" "$(finding R1-1 P9)"; rev 2 full "$BASE" "$C3"; judge
  bad2 'review-1 R1-1: severity must be P0, P1, P2 or P3' "an earlier round's bad record" || return 1
  # control: an earlier round's head and from may be gone (garbage-collected after a rebase)
  fresh; rev 1 full "$G" "$G"; edit 1 ".from = \"$(printf '%040d' 0 | tr 0 e)\""; rev 2 full "$BASE" "$C3"; judge
  want 0 "MOVE ON: review-2 at ${C3:0:7} is clean" "an earlier round's commits are gone" || return 1
  done_ok
}

# ============================== ac-check.sh --reviews ==============================

ac9_ac_check_refuses_unreviewed_head() {
  local C3 L
  need "$RC" && need "$ACC" || return 1
  newroot; mkrepo || fail "fixture repo" || return 1
  C3=$(cm d.txt three three)
  rev 1 full "$BASE" "$C2"; acfix "$C3" "$BASE" AC1; accheck "$BASE" --reviews "$E"
  L="REVIEW AGAIN: 1 commit(s) after review-1's head ${C2:0:7} are unreviewed: $(again1 "$BASE" "review ${C2:0:7}..${C3:0:7}")"
  want 1 "NOT ACCEPTED: the head ${C3:0:7} isn't covered by a clean review ($L)" "a commit after the clean review" || return 1
  has "AC1  ACCEPTED" "the AC itself is proven" && has "REVIEWS  NOT ACCEPTED: $L" "the reviews line" || return 1
  fresh; rev 1 full "$BASE" "$C3" "$(finding R1-1 P2)"; acfix "$C3" "$BASE" AC1; accheck "$BASE" --reviews "$E"
  L=$(fix1 1 "$C3")
  want 1 "NOT ACCEPTED: the head ${C3:0:7} isn't covered by a clean review ($L)" "the latest round says REVIEW AGAIN" || return 1
  has "REVIEWS  NOT ACCEPTED: $L" "the reviews line" || return 1
  fresh; rev 1 full "$BASE" "$C2" "$(finding R1-1 P2)"; rev 2 full "$BASE" "$C3" "$(finding R2-1 P2)"; acfix "$C3" "$BASE" AC1
  accheck "$BASE" --reviews "$E"; L="ASK JUSTIN: review-2: 1 P0-P2, no fewer than review-1's 1"
  want 1 "NOT ACCEPTED: the head ${C3:0:7} isn't covered by a clean review ($L)" "the latest round says ASK JUSTIN" || return 1
  has "REVIEWS  NOT ACCEPTED: $L" "the reviews line" || return 1
  # a full round from inside the story, then a clean delta round at HEAD: the story's first commit was never reviewed
  fresh; rev 1 full "$C1" "$C2" "$(finding R1-1 P2)"; rev 2 delta "$C2" "$C3"; acfix "$C3" "$BASE" AC1; accheck "$BASE" --reviews "$E"
  L="REVIEW AGAIN: review-1's from ${C1:0:7} is not on --base ${BASE:0:7}'s history: run a full review from ${BASE:0:7}"
  want 1 "NOT ACCEPTED: the head ${C3:0:7} isn't covered by a clean review ($L)" "a clean delta after a full round from inside the story" || return 1
  has "REVIEWS  NOT ACCEPTED: $L" "the reviews line" || return 1
  # an AC failing too: the last line counts the ACs and names the review
  fresh; rev 1 full "$BASE" "$C2"; acfix "$C3" "$BASE" AC1; reject_ac1; accheck "$BASE" --reviews "$E"
  want 1 "NOT ACCEPTED: 1 of 1 ACs on ${C3:0:7}; and the head isn't covered by a clean review" "an AC and the review both fail" || return 1
  has "REVIEWS  NOT ACCEPTED: REVIEW AGAIN: 1 commit(s) after review-1's head ${C2:0:7} are unreviewed: $(again1 "$BASE" "review ${C2:0:7}..${C3:0:7}")" "the reviews line" || return 1
  # only an AC failing: the old last line, after a clean reviews line
  fresh; rev 1 full "$BASE" "$C3"; acfix "$C3" "$BASE" AC1; reject_ac1; accheck "$BASE" --reviews "$E"
  want 1 "NOT ACCEPTED: 1 of 1 ACs on ${C3:0:7}" "only the AC fails" || return 1
  has "REVIEWS  CLEAN: review-1 at ${C3:0:7} is clean" "the reviews line" || return 1
  # missing or bad review records, an empty --reviews, or no referee beside ac-check.sh: exit 2
  fresh; acfix "$C3" "$BASE" AC1; accheck "$BASE" --reviews "$E"
  bad2 '^error: --reviews: no review records' "no review records" || return 1
  mkdir -p "$E/review-1"; printf 'not json' >"$E/review-1/review.json"; accheck "$BASE" --reviews "$E"
  bad2 '^error: --reviews: review-1/review\.json is not JSON' "a review record that isn't JSON" || return 1
  rev 1 full "$BASE" "$C3"; accheck "$BASE" --reviews ""
  bad2 '--reviews' "an empty --reviews" || return 1
  mkdir "$S/lone" && cp "$ACC" "$S/lone/ac-check.sh" || fail "copy" || return 1
  out=$(ing bash "$S/lone/ac-check.sh" --repo "$R" --base "$BASE" --plan "$E/plan.md" --reviews "$E" "$E/verifier/ac.json" "$E/auditor/ac.json" 2>"$S/err")
  rc=$?; err=$(cat "$S/err"); last=$(lastline)
  bad2 '^error: --reviews: .*review-check\.sh' "no review-check.sh beside ac-check.sh" || return 1
  done_ok
}

ac10_ac_check_accepts_reviewed_head() {
  local M1 NH
  need "$RC" && need "$ACC" || return 1
  newroot; mkrepo || fail "fixture repo" || return 1
  rev 1 full "$BASE" "$C2"; acfix "$C2" "$BASE" AC1; accheck "$BASE" --reviews "$E"
  want 0 "ALL ACCEPTED: 1 of 1 ACs on ${C2:0:7}" "a clean review at HEAD" || return 1
  [ "$out" = "$(printf 'AC1  ACCEPTED\nREVIEWS  CLEAN: review-1 at %s is clean\nALL ACCEPTED: 1 of 1 ACs on %s' "${C2:0:7}" "${C2:0:7}")" ] \
    || fail "want the AC line, the reviews line, then the last line: $out" || return 1
  fresh; rev 1 full "$BASE" "$C2"; acfix "$C2" "$BASE" AC1 AC2:live; accheck "$BASE" --reviews "$E"
  want 0 "READY FOR THE USER: 1 of 2 ACs proven on ${C2:0:7}; live ACs owed to the user: AC2" "a live AC owed" || return 1
  has "REVIEWS  CLEAN: review-1 at ${C2:0:7} is clean" "the reviews line" || return 1
  fresh; rev 1 full "$BASE" "$C1" "$(finding R1-1 P2)"; rev 2 delta "$C1" "$C2"; acfix "$C2" "$BASE" AC1; accheck "$BASE" --reviews "$E"
  want 0 "ALL ACCEPTED: 1 of 1 ACs on ${C2:0:7}" "a clean review-2 at HEAD" || return 1
  has "REVIEWS  CLEAN: review-2 at ${C2:0:7} is clean" "the reviews line" || return 1
  # a pure rebase of the reviewed head, with --base the new merge-base and both reports at the new head
  ing git -C "$R" checkout -q main && M1=$(cm m.txt m1 m1) && ing git -C "$R" checkout -q story \
    && ing git -C "$R" rebase -q main >/dev/null 2>&1 || fail "rebase" || return 1
  NH=$(head_)
  fresh; rev 1 full "$BASE" "$C2"; acfix "$NH" "$M1" AC1; accheck "$M1" --reviews "$E"
  want 0 "ALL ACCEPTED: 1 of 1 ACs on ${NH:0:7}" "a pure rebase of the reviewed head" || return 1
  has "REVIEWS  CLEAN: review-1 at ${C2:0:7} is clean, and HEAD ${NH:0:7} is a pure rebase of it" "the reviews line" || return 1
  # without --reviews nothing about reviews is printed
  accheck "$M1"
  want 0 "ALL ACCEPTED: 1 of 1 ACs on ${NH:0:7}" "the same reports without --reviews" || return 1
  if printf '%s\n' "$out" | grep -q '^REVIEWS'; then fail "a REVIEWS line without --reviews: $out"; return 1; fi
  done_ok
}

ac11_ac_check_existing_cases_pass() {
  local base t p n o_old o_new rc_old rc_new
  need "$RC" && need "$ACC" || return 1
  p=.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts
  base=${REVIEW_LOOP_BASE:-$(srcgit merge-base HEAD main)} || fail "no base commit" || return 1
  newroot; mkdir "$S/new" "$S/old" || return 1
  srcgit show "$base:$p/ac-check.test.sh" >"$S/new/ac-check.test.sh" && cp "$S/new/ac-check.test.sh" "$S/old/" \
    && srcgit show "$base:$p/ac-check.sh" >"$S/old/ac-check.sh" && cp "$ACC" "$RC" "$S/new/" || fail "base files from $base" || return 1
  for t in old new; do ing bash "$S/$t/ac-check.test.sh" >"$S/$t.log" 2>&1; done
  [ "$(tail -n 1 "$S/new.log")" = "all passed" ] || { tail -n 15 "$S/new.log"; fail "base ac-check.test.sh with the new ac-check.sh"; return 1; }
  grep '^ok ' "$S/old.log" | sort >"$S/old.ok"; grep '^ok ' "$S/new.log" | sort >"$S/new.ok"
  n=$(grep -c . "$S/old.ok")
  [ "$n" -gt 0 ] && cmp -s "$S/old.ok" "$S/new.ok" || fail "the ok labels differ from base: $(diff "$S/old.ok" "$S/new.ok")" || return 1
  echo "# base $base's ac-check.test.sh with the new ac-check.sh: all passed, the same $n ok labels"
  # five fixtures, without --reviews: the base and the new ac-check.sh print the same bytes and exit the same
  mkrepo || fail "fixture repo" || return 1
  same() { # same <what> <want exit> <args>…: run both scripts with these args; both exit <want exit>
    local what=$1 want=$2; shift 2
    o_old=$(ing bash "$S/old/ac-check.sh" "$@" 2>&1); rc_old=$?
    o_new=$(ing bash "$S/new/ac-check.sh" "$@" 2>&1); rc_new=$?
    [ "$o_old" = "$o_new" ] && [ "$rc_old" = "$rc_new" ] \
      || fail "$what: base exit $rc_old [$o_old], new exit $rc_new [$o_new]" || return 1
    [ "$rc_new" = "$want" ] || fail "$what: the fixture exits $rc_new, want $want: $o_new" || return 1
    echo "# $what: exit $rc_new, identical output ($(printf '%s\n' "$o_new" | awk 'NF { l = $0 } END { print l }'))"
  }
  acfix "$C2" "$BASE" AC1 AC2
  same "all accepted" 0 --repo "$R" --base "$BASE" --plan "$E/plan.md" "$E/verifier/ac.json" "$E/auditor/ac.json" || return 1
  reject_ac1
  same "one AC not accepted" 1 --repo "$R" --base "$BASE" --plan "$E/plan.md" "$E/verifier/ac.json" "$E/auditor/ac.json" || return 1
  fresh; acfix "$C2" "$BASE" AC1 AC2:live
  same "a live AC owed" 0 --repo "$R" --base "$BASE" --plan "$E/plan.md" "$E/verifier/ac.json" "$E/auditor/ac.json" || return 1
  echo dirty >"$R/scratch.txt"
  same "a dirty worktree" 1 --repo "$R" --base "$BASE" --plan "$E/plan.md" "$E/verifier/ac.json" "$E/auditor/ac.json" || return 1
  rm "$R/scratch.txt"
  same "a usage error" 2 --repo "$R" --base "$BASE" "$E/verifier/ac.json" "$E/auditor/ac.json" || return 1
  done_ok
}

# ============================== the rule text ==============================

ac12_docs_name_the_review_loop() {
  local f blk w sec
  step() { awk -v n="$1. **" '/^[0-9]+\. \*\*/ { s = (index($0, n) == 1) } /^## / { s = 0 } s' "$2"; }   # step <n> <file>
  names() { # names <text> <where> <phrase>…: every phrase appears in the text
    local t=$1 where=$2 w; shift 2
    for w in "$@"; do grep -qF -- "$w" <<<"$t" || fail "$where does not name [$w]" || return 1; done
  }
  lacks() { if grep -qF -- "$2" "$1"; then fail "${1#$SRC/} still says [$2]"; return 1; fi; }   # lacks <file> <phrase>
  f="$SRC/.claude/CLAUDE.md"; need "$f" || return 1
  blk=$(step 5 "$f"); [ -n "$blk" ] || fail "CLAUDE.md has no step 5" || return 1
  names "$blk" "CLAUDE.md step 5" review-check.sh 'REVIEW AGAIN' 'MOVE ON' 'ASK JUSTIN' P0 P1 P2 P3 scenario 'no fewer' \
    'new fact' 'round 3' 'No round cap' 'Mini: round 1 only' || return 1
  names "$(step 6 "$f")" "CLAUDE.md step 6" 'MOVE ON' '--reviews <evidence>' || return 1
  lacks "$f" 'a second fresh reviewer of the corrected code, then a fixer for its valid findings' || return 1
  echo "# CLAUDE.md steps 5 and 6"
  f="$SRC/.hermes/skills/software-development/review-fix-cadence/SKILL.md"; need "$f" || return 1
  sec=$(awk 'index($0, "## ") == 1 { s = (index($0, "## Loop until a review is clean") == 1) } s' "$f")
  [ -n "$sec" ] || fail "review-fix-cadence has no '## Loop until a review is clean' section" || return 1
  names "$sec" "review-fix-cadence's loop section" P0 P1 P2 P3 scenario 'no fewer' 'new fact' 'fix commits' review-check.sh 'MOVE ON' || return 1
  lacks "$f" 'looping fixer → verifier' || return 1
  echo "# review-fix-cadence"
  f="$FD/SKILL.md"; need "$f" || return 1
  names "$(cat "$f")" "feature-dispatch SKILL.md" references/review-loop.md review-check.sh || return 1
  lacks "$f" 'two in order' && lacks "$f" 'second fresh full review of the corrected candidate → fixer for its valid findings' || return 1
  # every fix gets a fresh review: no path that sends a fix straight to the verifier
  lacks "$f" 'Otherwise dispatch the verifier' && lacks "$f" 'New behavioral fixes still require fresh re-review' || return 1
  f="$FD/references/review-loop.md"; need "$f" || return 1
  names "$(cat "$f")" "references/review-loop.md" review.json justin.json repeats new_fact scenario follow-ups.md \
    'REVIEW AGAIN' 'MOVE ON' 'ASK JUSTIN' || return 1
  # a Full story's round 2 reviews the whole story, whatever round 1's REVIEW AGAIN was for (R5-1)
  names "$(cat "$f")" "references/review-loop.md" "(Full's round 2: full, \`from\` = \`--base\`)" || return 1
  names "$(cat "$FD/references/ac-verification.md")" "references/ac-verification.md" 'MOVE ON' --reviews || return 1
  f="$FD/references/mini-pipeline.md"
  names "$(cat "$f")" "references/mini-pipeline.md" review-check.sh 'MOVE ON' || return 1
  lacks "$f" 'one review instead of two' || return 1
  echo "# feature-dispatch SKILL.md, review-loop.md, ac-verification.md, mini-pipeline.md"
  f="$SRC/.hermes/skills/software-development/leorna/SKILL.md"; need "$f" || return 1
  names "$(cat "$f")" "leorna SKILL.md" review-check.sh || return 1
  lacks "$f" 'fresh Opus full review 2 of the corrected candidate → fresh Opus fixer for valid findings → fresh Opus verifier' || return 1
  echo "# leorna SKILL.md"
}

ac13_codex_roles_name_the_review_loop() {
  local f n=0 w
  f="$SRC/.codex/agents/pipeline-reviewer.toml"; need "$f" || return 1
  for w in review.json review-loop.md P0 P3 scenario repeats verdict ac_status 'never edit' 'skill_lessons[{skill, lesson, evidence, enforce}]'; do
    grep -qF -- "$w" "$f" || fail "pipeline-reviewer.toml does not name [$w]" || return 1
  done
  f="$SRC/.codex/agents/pipeline-fixer.toml"; need "$f" || return 1
  grep -qE 'P0(-|–)P2' "$f" || fail "pipeline-fixer.toml does not name P0-P2" || return 1
  grep -qF ready-for-next-review "$f" || fail "pipeline-fixer.toml does not name ready-for-next-review" || return 1
  for f in "$SRC"/.codex/agents/pipeline-*.toml; do
    n=$((n + 1))
    python3 -c 'import sys, tomllib; tomllib.load(open(sys.argv[1], "rb"))' "$f" || fail "${f#$SRC/} doesn't parse as TOML" || return 1
    grep -qF 'MAIN SESSION: check and save these skill_lessons now.' "$f" && grep -qF 'Never spawn' "$f" \
      || fail "${f#$SRC/} lost its last-line or Never spawn rule" || return 1
  done
  [ "$n" = 7 ] || fail "want seven pipeline-*.toml, found $n" || return 1
  echo "# the reviewer and fixer roles name the loop; all $n roles parse"
}

ac14_feature_dispatch_under_limit() {
  local f n ptr
  f="$FD/SKILL.md"; need "$f" || return 1
  n=$(python3 -c 'import sys; print(len(open(sys.argv[1], encoding="utf-8").read()))' "$f")
  [ "$n" -lt 100000 ] || fail "feature-dispatch SKILL.md is $n characters (limit 100,000)" || return 1
  after() { awk -v h="$1" 'f && NF { print; exit } index($0, h) == 1 { f = 1 }' "$f"; }   # after <heading>: its next non-empty line
  ptr=$(after '## Phase 5: Live check')
  grep -qF 'references/live-check.md' <<<"$ptr" || fail "## Phase 5: Live check is not followed by a pointer to references/live-check.md: [$ptr]" || return 1
  ptr=$(after '## Stop, pause and notification controls')
  grep -qF 'references/stop-controls.md' <<<"$ptr" || fail "## Stop, pause and notification controls is not followed by a pointer to references/stop-controls.md: [$ptr]" || return 1
  need "$FD/references/live-check.md" && need "$FD/references/stop-controls.md" || return 1
  grep -qF 'goal: `CHECKER (read only)' "$FD/references/live-check.md" && grep -qF 'output_schema:' "$FD/references/live-check.md" \
    && grep -qF '🔎' "$FD/references/live-check.md" || fail "live-check.md lacks the CHECKER goal, output_schema or the 🔎 line" || return 1
  grep -qF 'Separate work from delivery' "$FD/references/stop-controls.md" && grep -qF 'Acknowledge once' "$FD/references/stop-controls.md" \
    || fail "stop-controls.md lacks the moved stop items" || return 1
  for ptr in 'goal: `CHECKER (read only)' 'Separate work from delivery' 'Acknowledge once'; do
    if grep -qF -- "$ptr" "$f"; then fail "SKILL.md still holds the moved text [$ptr]"; return 1; fi
  done
  grep -qF '**Out of steps:**' "$f" && grep -qF '**Needs a decision:**' "$f" || fail "SKILL.md lost the general Out of steps / Needs a decision bullets" || return 1
  echo "# feature-dispatch SKILL.md is $n characters; the live-check and stop-controls text lives in references/"
}

ac15_memory_note_retired() {
  local hits rc
  if [ -e "$SRC/$NOTE" ]; then fail "$NOTE is still in the checkout"; return 1; fi
  if [ -n "$(srcgit ls-files -- "$NOTE")" ]; then fail "$NOTE is still tracked"; return 1; fi
  hits=$(cd "$SRC" && srcgit grep -l -F review-loop-until-clean -- ':(glob)**/MEMORY.md'); rc=$?
  [ "$rc" = 1 ] || fail "a tracked MEMORY.md still names the note (git grep exit $rc): $hits" || return 1
  echo "# the note is gone and no tracked MEMORY.md names it"
}

ac16_scripts_portable_to_macos() {
  local f re hit
  need "$RC" && need "$ACC" || return 1
  for f in "$RC" "$ACC" "$HERE/review-check.test.sh"; do bash -n "$f" || fail "${f##*/}: bash -n fails" || return 1; done
  # the patterns are built in pieces, so this file never holds them itself
  re='map''file|read''array|declare -''A|local -''n|[$][{][A-Za-z_][A-Za-z0-9_]*([[][^]]*[]])?[,^]|[[][[] -''v |[|]''&|''&''>>'
  re="$re|sed -""i|grep -[A-Za-z]*""P|readlink -""f|date -""d|stat -""c"
  for f in "$RC" "$ACC" "$HERE/review-check.test.sh"; do
    hit=$(grep -nE -- "$re" "$f") && { fail "${f##*/} uses a bash 4+ or GNU-only form: $hit"; return 1; }
  done
  # bash 3.2 finds the end of a command substitution by matching quotes and parens, with no
  # here-document logic: a here-document opened inside one (a <<< here-string is fine) can end it early
  re='[$][(]([^)]*[^<])?<''<[^<]'
  for f in "$RC" "$ACC" "$HERE/review-check.test.sh"; do
    hit=$(grep -nE -- "$re" "$f") && { fail "${f##*/} opens a here-document inside a command substitution: $hit"; return 1; }
  done
  for f in "$RC" "$HERE/review-check.test.sh"; do
    hit=$(grep -nE -- '(hea''d|tai''l) -[0-9]' "$f") && { fail "${f##*/} uses a head/tail short form: $hit"; return 1; }
  done
  re='(^|[^A-Za-z0-9_.-])(tri''m|ltri''m|rtri''m|pic''k|ab''s|toarra''y|have_decnu''m)([^A-Za-z0-9_]|$)'
  for f in "$RC" "$ACC" "$HERE/review-check.test.sh"; do
    hit=$(grep -nE -- "$re" "$f") && { fail "${f##*/} uses a jq 1.7+ builtin: $hit"; return 1; }
  done
  echo "# bash -n passes; no bash 4+, GNU-only or jq 1.7+ forms in the three scripts"
}

# ============================== regression and live ==============================

ac17_existing_suites_pass() {
  local f
  newroot
  suite() { # suite <label> <script> [env…]: run it, keep the log, require exit 0 and its own pass line
    local label=$1 script=$2; shift 2
    env "$@" bash "$script" >"$S/$label.log" 2>&1 || { tail -n 15 "$S/$label.log"; fail "$label failed"; return 1; }
    echo "# $label: $(grep -E '^(all passed|passed [0-9]+, failed 0|# passed [0-9]+, failed 0)' "$S/$label.log" | tail -n 1)"
  }
  for f in setup-sync-pull skill-review-nudge subagent-ac-gate subagent-handback-gate subagent-lessons-gate; do
    suite "$f" "$SRC/.claude/hooks/tests/$f.test.sh" || return 1
  done
  suite harness-guards "$SRC/.claude/hooks/tests/harness-guards.test.sh" || return 1
  suite sync "$SRC/.claude/setup/sync.test.sh" || return 1
  suite ac-check "$HERE/ac-check.test.sh" || return 1
  suite codex-parity "$SRC/.claude/setup/codex/codex-parity.test.sh" || return 1
  suite review-check "$HERE/review-check.test.sh" || return 1
  # again with the git hooks active: a copy of the real ~/.gitconfig plus core.hooksPath = the checkout's githooks
  if [ -f "$REAL_HOME/.gitconfig" ]; then cp "$REAL_HOME/.gitconfig" "$S/live-gitconfig"; else : >"$S/live-gitconfig"; fi
  git config -f "$S/live-gitconfig" core.hooksPath "$SRC/.claude/githooks"
  for f in setup-sync-pull skill-review-nudge subagent-ac-gate subagent-handback-gate subagent-lessons-gate; do
    suite "hooks-on-$f" "$SRC/.claude/hooks/tests/$f.test.sh" GIT_CONFIG_GLOBAL="$S/live-gitconfig" || return 1
  done
  suite hooks-on-ac-check "$HERE/ac-check.test.sh" GIT_CONFIG_GLOBAL="$S/live-gitconfig" || return 1
  suite hooks-on-harness-guards "$SRC/.claude/hooks/tests/harness-guards.test.sh" GIT_CONFIG_GLOBAL="$S/live-gitconfig" || return 1
  suite hooks-on-review-check "$HERE/review-check.test.sh" GIT_CONFIG_GLOBAL="$S/live-gitconfig" || return 1
  done_ok
}

ac18_mac_suites_live() {
  local t
  [ "$(uname -s)" = Darwin ] || fail "live: needs the Mac, after ~/.claude/setup/sync.sh pull" || return 1
  echo "# /bin/bash $(/bin/bash -c 'echo "$BASH_VERSION"'); $(env PATH="/bin:/usr/bin:$PATH" sh -c 'command -v jq; jq --version' | tr '\n' ' ')"
  for t in review-check ac-check; do
    env PATH="/bin:/usr/bin:$PATH" /bin/bash "$HERE/$t.test.sh" >"${TMPDIR:-/tmp}/$t-mac.log" 2>&1 \
      || { tail -n 15 "${TMPDIR:-/tmp}/$t-mac.log"; fail "live: $t.test.sh failed under /bin/bash"; return 1; }
    echo "# $t.test.sh: $(grep -E '^(all passed|# passed [0-9]+, failed 0)' "${TMPDIR:-/tmp}/$t-mac.log" | tail -n 1)"
  done
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
