#!/usr/bin/env bash
# Acceptance tests for story pipeline-token-diet (~/.hermes/plans/claude-setup/pipeline-token-diet.md): the
# pipeline's model routing and changed rules read the same in every file that states them.
#   bash pipeline-rules.test.sh                    the default run (routing_text_agrees)
#   bash pipeline-rules.test.sh <test> [<test>…]   just those, numbered TAP: "ok 1 - <test>"
# existing_suites_pass (the regression run of the other suites) runs only when named, with
# PIPELINE_RULES_BASE=<folder of base tallies> (one <suite>.ok per suite: the names of the tests that passed
# on the base, in either of two runs; ~/.hermes/plans/claude-setup/pipeline-token-diet.md task 0).
# Everything under test comes from this file's own checkout (the story worktree, or $HOME once merged),
# never from the live ~/.claude, ~/.hermes or ~/.codex. The Codex copy is built into a fresh mktemp -d
# folder (under $TMPDIR).
set -uo pipefail
HERE=$(cd "$(dirname "$0")" && pwd)
SRC=$(cd "$HERE/../../../../.." && pwd)     # the checkout root ($HOME-relative layout)

OFFLINE="routing_text_agrees"

FD=.hermes/skills/autonomous-ai-agents/feature-dispatch
SD=.hermes/skills/software-development
CLAUDE_MD=.claude/CLAUDE.md
# the routing sentence ("The chosen set" in the plan); every file that states the routing carries it word for word
ROUTING='planner Fable 5.2 high; builder Opus 5.5 xhigh; reviewer round 1 Fable 5.2 high, later rounds Opus 5.5 high; fixer Opus 5.5 high; verifier Opus 5.5 high; AC auditor Opus 5.5 xhigh; finisher Opus 5.5 high; pipeline main session Opus 5.5 high'
# every file of "Where the rules are stated" (the Codex copy is built from CLAUDE.md and checked apart)
RULE_FILES="$CLAUDE_MD
$FD/SKILL.md
$FD/references/mini-pipeline.md
$FD/references/model-routing.md
$FD/references/review-loop.md
$FD/references/ac-verification.md
$FD/references/main-chat-housekeeping.md
$FD/references/away-and-recovery.md
$FD/references/agent-defect-loop.md
$SD/leorna/SKILL.md
$SD/review-fix-cadence/SKILL.md
$SD/figma-to-bricks/SKILL.md
.claude/setup/codex/agents-header.md"
old_phrases() { # the older pairings and replaced rules, one a line: none may be left in any rule file
  cat <<'EOF'
once by each model
reviewers and verifier `model: "fable"`
every reviewer and the verifier
builder and fixers `model: "opus"`, `effort: "xhigh"`
builder and every fixer
a fresh Fable 5.2 every round
fresh Fable review of the fix commits
Fable 5.2 high reviews, Opus 5.5 xhigh fixes
Opus 5.5 xhigh FIXER
xhigh for builder, fixer and AC auditor
Fixers use the builder's model and effort
the verifier is Fable 5.2 high
Fable verifier
fresh Fable full review 2
Use a fresh Fable 5.2 high reviewer
model: Fable 5.2 high, a fresh agent
Sol 6.1 xhigh review, fixes, then Opus 5.5 xhigh review
Opus 5.5 at high effort for every role
not by lowering effort
you run verifier → auditor → `ac-check.sh` again on it
forces another verifier → auditor round
EOF
}

fail() { echo "FAIL: $*"; return 1; }
need() { [ -e "$1" ] || fail "missing $1 (not built yet)"; }
lines() { awk -v p="$2" 'index($0, p) == 1' "$SRC/$1"; }   # lines <file> <start>: the lines that start with the text
one() { # one <file> <start>: the one line that starts with the text (more or fewer is a failure)
  local l n
  l=$(lines "$1" "$2"); n=$(printf '%s' "$l" | grep -c '^')
  [ "$n" = 1 ] || { fail "$1: want one line starting [$2], found $n"; return 1; }
  printf '%s\n' "$l"
}
holds() { # holds <where> <text> <fragment>…: each fragment is in the text; names every one missing
  local w=$1 t=$2 f miss=""; shift 2
  for f in "$@"; do case $t in *"$f"*) ;; *) miss="$miss [$f]" ;; esac; done
  [ -z "$miss" ] || fail "$w lacks$miss"
}
lacks() { # lacks <where> <text> <fragment>…: no fragment is in the text
  local w=$1 t=$2 f hit=""; shift 2
  for f in "$@"; do case $t in *"$f"*) hit="$hit [$f]" ;; esac; done
  [ -z "$hit" ] || fail "$w still has$hit"
}
row() { # row <file> <row start> <must have>… [-- <must not have>…]: a table row's model and effort
  local f=$1 s=$2 r miss=() not=() mode=have x
  r=$(one "$f" "| $s") || { echo "$r"; return 1; }
  shift 2
  for x in "$@"; do
    if [ "$x" = -- ]; then mode=not; continue; fi
    if [ $mode = have ]; then miss+=("$x"); else not+=("$x"); fi
  done
  holds "$f, row [| $s]" "$r" "${miss[@]}" || return 1
  [ ${#not[@]} = 0 ] || lacks "$f, row [| $s]" "$r" "${not[@]}"
}

routing_text_agrees() {
  local f t bad=0 p S
  for f in $RULE_FILES; do need "$SRC/$f" || return 1; done
  # 1. the routing sentence, word for word, in every file that states the routing
  for f in $CLAUDE_MD $FD/SKILL.md $FD/references/mini-pipeline.md $SD/leorna/SKILL.md $SD/review-fix-cadence/SKILL.md; do
    grep -qF -- "$ROUTING" "$SRC/$f" || { fail "$f lacks the routing sentence [$ROUTING]"; bad=1; }
  done
  [ $bad = 0 ] || return 1
  echo "# 1. the routing sentence is in CLAUDE.md, SKILL.md, mini-pipeline.md, leorna and review-fix-cadence"
  # 2. the Agent tool's values in CLAUDE.md's pipeline paragraph
  t=$(one $CLAUDE_MD '**The pipeline.**') || { echo "$t"; return 1; }
  holds "CLAUDE.md's **The pipeline.** paragraph" "$t" \
    'planner and round-1 reviewer `model: "fable"`, `effort: "high"`' \
    'builder and AC auditor `model: "opus"`, `effort: "xhigh"`' \
    'later-round reviewers, fixers, verifier and finisher `model: "opus"`, `effort: "high"`' || return 1
  echo "# 2. CLAUDE.md's pipeline paragraph gives each role its model: and effort: values"
  # 3. the two role tables
  for f in $FD/SKILL.md $FD/references/mini-pipeline.md; do
    row "$f" Planner '**Fable 5.2**' '**high**' || return 1
    row "$f" Builder '**Opus 5.5**' '**xhigh**' || return 1
    row "$f" 'Reviewer, round 1' '**Fable 5.2**' '**high**' || return 1
    row "$f" 'Reviewer, later rounds' '**Opus 5.5**' '**high**' -- xhigh Fable || return 1
    row "$f" Fixer '**Opus 5.5**' '**high**' -- xhigh Fable || return 1
    row "$f" Verifier '**Opus 5.5**' '**high**' -- xhigh Fable || return 1
    row "$f" 'AC auditor' '**Opus 5.5**' '**xhigh**' || return 1
  done
  row $FD/SKILL.md Finisher '**Opus 5.5**' 'high' -- xhigh Fable || return 1
  echo "# 3. the role tables of SKILL.md and mini-pipeline.md give every role its model and effort"
  # 4. the changed rules are stated where they apply
  t=$(one $CLAUDE_MD '5. **Review → fix') || { echo "$t"; return 1; }
  holds "CLAUDE.md step 5" "$t" 'only P2' 'follow-up' || return 1
  t=$(one $CLAUDE_MD '7. **Finish:**') || { echo "$t"; return 1; }
  holds "CLAUDE.md step 7" "$t" '--rebase-receipt' 'pure rebase' || return 1
  t=$(one $CLAUDE_MD '- **Agent models') || { echo "$t"; return 1; }
  holds "CLAUDE.md's Agent models bullet" "$t" '2026-11-10' || return 1
  holds "CLAUDE.md" "$(cat "$SRC/$CLAUDE_MD")" '300k' || return 1
  holds "main-chat-housekeeping.md" "$(cat "$SRC/$FD/references/main-chat-housekeeping.md")" '300k' || return 1
  holds "review-loop.md" "$(cat "$SRC/$FD/references/review-loop.md")" 'only P2 left from round 3 on' 'follow-up' || return 1
  holds "ac-verification.md" "$(cat "$SRC/$FD/references/ac-verification.md")" '--rebase-receipt' 'REBASE  ACCEPTED' '"command"' || return 1
  holds "mini-pipeline.md" "$(cat "$SRC/$FD/references/mini-pipeline.md")" '--rebase-receipt' 'only P2' || return 1
  t=$(one $SD/review-fix-cadence/SKILL.md '  - (e)') || { echo "$t"; return 1; }
  holds "review-fix-cadence's brake (e)" "$t" 'only P2' || return 1
  echo "# 4. the round-3 question, the rebase receipt, the 2026-11-10 date and the 300k rule are stated"
  # 5. no older pairing or replaced rule is left
  while IFS= read -r p; do
    for f in $RULE_FILES; do
      if grep -qF -- "$p" "$SRC/$f"; then fail "$f still has the old [$p]"; bad=1; fi
    done
  done <<EOF
$(old_phrases)
EOF
  [ $bad = 0 ] || return 1
  echo "# 5. none of the $(old_phrases | grep -c '^') old phrases is left in the $(printf '%s\n' "$RULE_FILES" | grep -c '^') rule files"
  # 6. the Codex copy, built from this checkout's CLAUDE.md and header
  S=$(mktemp -d "${TMPDIR:-/tmp}/pipeline-rules-test.XXXXXX") || { fail "mktemp"; return 1; }
  CODEX_HOME="$S/codex" CODEX_BUILD_RULES="$SRC/$CLAUDE_MD" bash "$SRC/.claude/setup/codex/build-codex.sh" \
    || { fail "build-codex.sh failed (test folder $S kept)"; return 1; }
  grep -qF -- "$ROUTING" "$S/codex/AGENTS.md" || { fail "the built AGENTS.md lacks the routing sentence (test folder $S kept)"; return 1; }
  while IFS= read -r p; do
    if grep -qF -- "$p" "$S/codex/AGENTS.md"; then fail "the built AGENTS.md still has the old [$p]"; bad=1; fi
  done <<EOF
$(old_phrases)
EOF
  [ $bad = 0 ] || { echo "# test folder $S kept"; return 1; }
  echo "# 6. the Codex AGENTS.md built from this checkout has the routing sentence and none of the old phrases"
  rm -rf "$S"
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
