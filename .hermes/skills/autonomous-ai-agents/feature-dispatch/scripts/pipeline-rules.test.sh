#!/usr/bin/env bash
# Acceptance tests for story pipeline-token-diet (~/.hermes/plans/claude-setup/pipeline-token-diet.md): the
# pipeline's model routing and changed rules read the same in every file that states them.
#   bash pipeline-rules.test.sh                    the default run (routing_text_agrees)
#   bash pipeline-rules.test.sh <test> [<test>…]   just those, numbered TAP: "ok 1 - <test>"
# existing_suites_pass (the regression run of the other suites) runs only when named, with
# PIPELINE_RULES_BASE=<folder of base tallies> (one <suite>.ok per suite: the names of the tests that passed
# on the base, in either of two runs; ~/.hermes/plans/claude-setup/pipeline-token-diet.md task 0). It runs
# ac-check.test.sh, review-check.test.sh, codex-parity.test.sh, sync.test.sh and every hooks suite from this
# checkout (each suite keeps its own scratch rules: HARNESS_GUARDS_TEST_ROOT and the like), so give it the
# memory cap: systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 bash pipeline-rules.test.sh existing_suites_pass
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
FIGMA_DOCS=.claude/project-docs/figma-to-bricks/CLAUDE.md
scan_files() { # the rule files, then every project CLAUDE.md copy in .claude/project-docs/ (sync.sh keeps them
               # equal to the projects' own files): checks 5 and 7 read them all
  printf '%s\n' "$RULE_FILES"
  (cd "$SRC" && for f in .claude/project-docs/*/CLAUDE.md; do [ -f "$f" ] && printf '%s\n' "$f"; done)
}
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
→ `ac-check.sh` again on the new head
the AC receipts no longer match
two fresh Opus reviews
EOF
}
# where a pinned statement lives: the file of each key in prose() below
file_of() {
  case $1 in
    claude) echo "$CLAUDE_MD" ;;          fd) echo "$FD/SKILL.md" ;;
    mini) echo "$FD/references/mini-pipeline.md" ;;   loop) echo "$FD/references/review-loop.md" ;;
    acv) echo "$FD/references/ac-verification.md" ;;  house) echo "$FD/references/main-chat-housekeeping.md" ;;
    away) echo "$FD/references/away-and-recovery.md" ;;
    leorna) echo "$SD/leorna/SKILL.md" ;;  rfc) echo "$SD/review-fix-cadence/SKILL.md" ;;
    f2b) echo "$SD/figma-to-bricks/SKILL.md" ;;  header) echo ".claude/setup/codex/agents-header.md" ;;
    figma) echo "$FIGMA_DOCS" ;;   # wrapped text: its statements are compared flat (one space for each run)
    *) return 1 ;;
  esac
}
prose() { # <key>|<text>: every prose statement of a role's model or effort, and of the changed rules, outside the
          # routing sentence and the role tables, word for word (a wrong model, effort or rule in any of them fails)
  cat <<'EOF'
claude|The pipeline main session itself runs on Opus 5.5 high (step 1 checks it).
claude|past 300k with nothing running, asks once per quiet spell for a fresh session
claude|when that isn't Opus 5.5 high, ask in the same question for `/model opus` and `/effort high` before anything is dispatched
claude|report only; round 1 on Fable 5.2 high, every later round on Opus 5.5 high)
claude|(to the round-3 question, "fix" → `"continue": true`; "follow-up" → `"accept"` with those ids, and their lines go to `<evidence>/follow-ups.md`)
claude|so is, from round 3, a round with only P2 left (fix or follow-up?). No round cap, but the user is asked from round 3 before a P2-only round is fixed.
claude|if HEAD now differs from the head `ac-check.sh` accepted and the rebase resolved no conflict, the finisher also reruns every agent-run AC's test on the new head into a rebase receipt
claude|on a pure rebase of the accepted head it accepts the earlier reports, with no new verifier or auditor. Anything else (a rebase that resolved conflicts, a `REBASE  NOT ACCEPTED` line) takes the full path
claude|with no cap, but from round 3 a round with only P2 left asks the user: fix or follow-up.
claude|**After a pure rebase (user, 2026-11-10):** a rebase receipt, not a new verifier and auditor.
fd|Mini (Fable plan, Opus build, one full fresh Fable review, then the same loop of reviews of the fixes)
fd|The Fable planner does the architecture and design
fd|no round cap (from round 3 a round with only P2 left asks Justin: fix or follow-up?), each role on the role table (round 1 reviewed on Fable 5.2 high, later rounds on Opus 5.5 high, fixes on Opus 5.5 high)
fd|Fixers and the verifier run on Opus 5.5 high, the AC auditor on Opus 5.5 xhigh (Justin, 2026-11-10).
fd|(xhigh for builder and AC auditor; high for planner, every reviewer, fixer, verifier and finisher)
fd|  - model: Opus 5.5 high, a fresh agent. Board → `verifying`.
fd|dispatch round 1 of the review loop, a fresh **Fable 5.2 high full review**
fd|**REVIEW AGAIN** → an **Opus 5.5 high FIXER now**
fd|then the next fresh review, on Opus 5.5 high (Full: round 2 is full;
fd|to the round-3 question ("only P2 left from round 3 on") his "fix" is `"continue": true` and "follow-up" is `"accept"` with those ids
fd|From round 3 a round with only P2 left is ASK JUSTIN (fix or follow-up?).
fd|A pure rebase (the same patches in the same order, no merges: `ac-check.sh`'s test) needs no new verifier or auditor on any story since 2026-11-10
mini|1. **Planner (Fable 5.2 high).**
mini|2. **Builder (Opus 5.5 xhigh).**
mini|3. **Reviewer (fresh Fable 5.2 high).** Round 1 of the review loop
mini|**REVIEW AGAIN** → an Opus 5.5 high finisher fixes the listed P0–P2
mini|a fresh Opus 5.5 high delta reviewer (review only
mini|from round 3 (in Mini, the review of the second fix) a round with only P2 left asks too: his "fix" → `"continue": true`, "follow-up" → `"accept"`
mini|a pure rebase gets a rebase receipt and `ac-check.sh --rebase-receipt` (`ac-verification.md`), not a new verifier and auditor; a rebase that resolved conflicts takes the full path
mini|no round cap, but Justin is asked from round 3 when only P2 is left
mini|(usually a Fable high re-plan or the Full review order)
mini|each role runs on Full's model and effort
loop|- Round 1 is reviewed by a fresh Fable 5.2 high agent; every later round (Full's whole-story round 2, the delta rounds, a full round the referee asks for) by a fresh Opus 5.5 high agent
loop|"fix" → `{"words": "<his reply>", "continue": true}`, so REVIEW AGAIN
loop|"follow-up" → `{"words": "<his reply>", "accept": ["R3-1", "R3-2"]}`, so those count as ACCEPTED
loop|brake e (from round 3, only P2 left: the line ends `only P2 left from round 3 on (<ids>): fix or follow-up?`
loop|A pure rebase (the finisher's, no conflict resolved) needs no new review (`--reviews` counts it as covered) and no new verifier or auditor
acv|dispatch the **AC AUDITOR**: a fresh Opus 5.5 xhigh agent
acv|Then the orchestrator reruns step 4's command with `--rebase-receipt <evidence>/rebase/receipt-<head7>.log` before the two reports.
acv|so the two reports for the head they proved still count (2026-11-10): no new verifier or auditor.
acv|needs a new rebase receipt (step 5), or, when it resolved conflicts, a new review, verifier and auditor
acv|when the rebase resolved no conflict, the finisher writes a **rebase receipt**
house|a pipeline main session runs on Opus 5.5 high. At step 1 it says which model and effort it is on and, when they differ, asks for `/model opus` and `/effort high`
house|Past 300k tokens with no agent running, it asks once per quiet spell for a fresh session
away|(Fable 5.2 high or Opus 5.5 xhigh/high, SKILL.md's role table)
leorna|  - fresh Fable full review 1 → fresh Opus fixer → fresh Opus full review 2 → fresh Opus fixer → fresh Opus review of the fix commits → … until `review-check.sh` prints MOVE ON (`review-fix-cadence`; `feature-dispatch` references/review-loop.md) → fresh Opus verifier → blind Opus auditor → `ac-check.sh --reviews`;
rfc|**Fable plan → user go → Opus build → fresh Fable full review 1 → fresh Opus fixer → fresh Opus full review 2 → fresh Opus fixer → fresh Opus review of the fix commits → … until a review is clean (`review-check.sh`: MOVE ON) → fresh Opus verifier → blind Opus auditor → `ac-check.sh --reviews`
rfc|**Dispatch a scoped fresh Opus fix promptly
rfc|Round 1 is a fresh Fable 5.2 high reviewer; every later round a fresh Opus 5.5 high reviewer.
rfc|**Use a fresh Opus fixer for each `REVIEW AGAIN` list**
rfc|Returned actionable blockers advance to a fresh Opus fixer
rfc|  - (e) from round 3, a round with only P2 left (no P0 or P1) → ASK JUSTIN: fix (`"continue": true`) or follow-up (`"accept"`, and the lines go to `follow-ups.md`) (Justin, 2026-11-10).
rfc|No fixed round cap, but from round 3 Justin is asked before a P2-only round is fixed (e).
rfc|A pure rebase (no conflict) needs no new review and no new verifier: the finisher's rebase receipt and `ac-check.sh --rebase-receipt` carry the earlier reports
f2b|(its role table names each round's model and effort) and any explicit user override; do not hard-code a model
figma|Then two fresh full reviews, each on the model and effort the global routing gives its round (global CLAUDE.md "Agent models")
figma|If HEAD now differs from the head `ac-check.sh` accepted, global CLAUDE.md step 7 decides what runs before step 2
figma|a rebase receipt carries the earlier reports only when HEAD is a pure rebase of the accepted head. The ledger commit made here before the rebase is a patch that head lacks, so HEAD is not a pure rebase of it and the session takes step 7's full path on the new head: a fresh review of what the accepted head lacks, then verifier → auditor → `ac-check.sh`.
header|| The per-role Claude models and efforts, and the pipeline main session on Opus 5.5 high (`/model opus`, `/effort high`); "Sol 6.1 only as a substitute at a Claude limit" | Claude Code only.
EOF
}
wrong_pairs() { # wrong_pairs <file>…: each clause that pairs a later round, a delta review, a fixer, the verifier or
                # the main session with Fable or xhigh. Dated history is left out: *Why …* notes, *(Superseded …)*
                # notes and "supersedes the <date> table (…)". Clauses end at ; , ( ) | → and ". ".
  # A wrapped line (indented, not a list item or table row) is read with the line it continues.
  awk 'function check(l, at,   c, n, i) {
    gsub(/\*Why[^*]*\*/, "", l); gsub(/\*\(Superseded[^)]*\)\*/, "", l)
    gsub(/supersedes the [0-9-]+ table \([^)]*\)/, "", l)
    n = split(l, c, /[;,()|]|→|\. /)
    for (i = 1; i <= n; i++)
      if (c[i] ~ /[Ll]ater[ -]rounds?|[Dd]elta|round 2|[Ff]ixe[rs]|[Vv]erifier|main session/ && c[i] ~ /Fable|xhigh/)
        print at ": [" c[i] "]"
  }
  FNR == 1 { if (buf != "") check(buf, at); buf = "" }
  {
    if (buf != "" && $0 ~ /^[ \t]+[^ \t]/ && $0 !~ /^[ \t]*([-*] |[0-9]+\. |\|)/) { l = $0; sub(/^[ \t]+/, "", l); buf = buf " " l; next }
    if (buf != "") check(buf, at)
    buf = $0; at = FILENAME ":" FNR
  }
  END { if (buf != "") check(buf, at) }' "$@"
}
flat() { tr '\n\t' '  ' <"$1" | tr -s ' '; }   # flat <file>: the text on one line, each run of spaces one space

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
  for f in $RULE_FILES $FIGMA_DOCS; do need "$SRC/$f" || return 1; done
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
  # 5. no older pairing or replaced rule is left, in a rule file or a project's CLAUDE.md copy
  for f in $(scan_files); do   # read flat, so a phrase wrapped over two lines is still found
    t=$(flat "$SRC/$f")
    while IFS= read -r p; do
      case $t in *"$p"*) fail "$f still has the old [$p]"; bad=1 ;; esac
    done <<EOF
$(old_phrases)
EOF
  done
  [ $bad = 0 ] || return 1
  echo "# 5. none of the $(old_phrases | grep -c '^') old phrases is left in the $(printf '%s\n' "$RULE_FILES" | grep -c '^') rule files and the $(scan_files | grep -c '^project-docs/\|^\.claude/project-docs/') project CLAUDE.md copies"
  # 6. every other prose statement of a role's model or effort, and of the changed rules, word for word
  while IFS= read -r p; do
    f=$(file_of "${p%%|*}") || { fail "prose(): no file for the key [${p%%|*}]"; bad=1; continue; }
    if [ "$f" = "$FIGMA_DOCS" ]; then t=$(flat "$SRC/$f"); else t=$(cat "$SRC/$f"); fi
    holds "$f" "$t" "${p#*|}" || bad=1
  done <<EOF
$(prose)
EOF
  [ $bad = 0 ] || return 1
  echo "# 6. the $(prose | grep -c '^') prose statements of a role's model, effort or changed rule read as pinned"
  # 7. no clause anywhere else pairs a later round, a fixer, the verifier or the main session with Fable or xhigh
  p=$(cd "$SRC" && wrong_pairs $(scan_files))
  [ -z "$p" ] || { fail "a role paired with the wrong model or effort: $p"; return 1; }
  echo "# 7. no rule file or project CLAUDE.md copy pairs a later round, a fixer, the verifier or the main session with Fable or xhigh"
  # 8. the Codex copy, built from this checkout's CLAUDE.md and header
  S=$(mktemp -d "${TMPDIR:-/tmp}/pipeline-rules-test.XXXXXX") || { fail "mktemp"; return 1; }
  CODEX_HOME="$S/codex" CODEX_BUILD_RULES="$SRC/$CLAUDE_MD" bash "$SRC/.claude/setup/codex/build-codex.sh" \
    || { fail "build-codex.sh failed (test folder $S kept)"; return 1; }
  grep -qF -- "$ROUTING" "$S/codex/AGENTS.md" || { fail "the built AGENTS.md lacks the routing sentence (test folder $S kept)"; return 1; }
  while IFS= read -r p; do
    if grep -qF -- "$p" "$S/codex/AGENTS.md"; then fail "the built AGENTS.md still has the old [$p]"; bad=1; fi
  done <<EOF
$(old_phrases)
EOF
  while IFS= read -r p; do
    case $p in claude\|*) holds "the built AGENTS.md" "$(cat "$S/codex/AGENTS.md")" "${p#*|}" || bad=1 ;; esac
  done <<EOF
$(prose)
EOF
  [ $bad = 0 ] || { echo "# test folder $S kept"; return 1; }
  echo "# 8. the Codex AGENTS.md built from this checkout has the routing sentence, CLAUDE.md's pinned statements and none of the old phrases"
  rm -rf "$S"
}

# ---- the regression run: every existing suite passes on head as it did on the base, test by test ----
oknames() { sed -nE 's/^ok( [0-9]+)? +- (.*)$/\2/p' "$@" | LC_ALL=C sort -u; }   # the tests a log shows passing
last_of() { awk 'NF { l = $0 } END { print l }' "$1"; }
as_on_base() { # as_on_base <suite> <path>: every test in the base's <suite>.ok is ok on head; a suite that misses
               # one is run once more alone, and a test counts when either run passes it (the base took two runs too)
  local name=$1 path=$2 base="$PIPELINE_RULES_BASE/$1.ok" miss
  need "$base" || return 1
  bash "$SRC/$path" >"$S/$name.1.log" 2>&1
  miss=$(LC_ALL=C comm -23 "$base" <(oknames "$S/$name.1.log"))
  if [ -n "$miss" ]; then
    echo "# $name: $(printf '%s\n' "$miss" | grep -c '^') base test(s) not ok on the first run; running it once more alone"
    bash "$SRC/$path" >"$S/$name.2.log" 2>&1
    miss=$(LC_ALL=C comm -23 "$base" <(oknames "$S/$name.1.log" "$S/$name.2.log"))
  fi
  [ -z "$miss" ] || { fail "$name: tests that pass on the base fail on head: $(printf '%s\n' "$miss" | tr '\n' ';') (logs in $S)"; return 1; }
  echo "# $name: all $(grep -c '^' "$base") tests that pass on the base pass on head ($(last_of "$S/$name.1.log"))"
}

existing_suites_pass() {
  local f name
  [ -n "${PIPELINE_RULES_BASE:-}" ] && [ -d "$PIPELINE_RULES_BASE" ] \
    || { fail "set PIPELINE_RULES_BASE to the folder of base tallies (<suite>.ok files; the plan's task 0)"; return 1; }
  S=$(mktemp -d "${TMPDIR:-/tmp}/pipeline-rules-test.XXXXXX") || { fail "mktemp"; return 1; }
  # the gate scripts' own suites: all passed, 17 tests, and the 15 tests of the base's OFFLINE list among them
  bash "$SRC/$FD/scripts/ac-check.test.sh" >"$S/ac-check.log" 2>&1
  [ "$(last_of "$S/ac-check.log")" = "all passed" ] || { fail "ac-check.test.sh: $(last_of "$S/ac-check.log") (log $S/ac-check.log)"; return 1; }
  as_on_base ac-check "$FD/scripts/ac-check.test.sh" || return 1
  bash "$SRC/$FD/scripts/review-check.test.sh" >"$S/review-check.log" 2>&1
  [ "$(last_of "$S/review-check.log")" = "# passed 17, failed 0" ] \
    || { fail "review-check.test.sh: want [# passed 17, failed 0], got [$(last_of "$S/review-check.log")] (log $S/review-check.log)"; return 1; }
  need "$PIPELINE_RULES_BASE/review-check.ok" || return 1
  [ "$(grep -c '^' "$PIPELINE_RULES_BASE/review-check.ok")" = 15 ] || { fail "the base's review-check.ok should name its 15 tests"; return 1; }
  f=$(LC_ALL=C comm -23 "$PIPELINE_RULES_BASE/review-check.ok" <(oknames "$S/review-check.log"))
  [ -z "$f" ] || { fail "review-check.test.sh: base tests missing or failing on head: $(printf '%s\n' "$f" | tr '\n' ';')"; return 1; }
  echo "# review-check.test.sh: # passed 17, failed 0, the base's 15 tests among them"
  # the other suites, test by test against the base (some fail on the base too: those are not counted)
  as_on_base codex-parity .claude/setup/codex/codex-parity.test.sh || return 1
  as_on_base sync .claude/setup/sync.test.sh || return 1
  for f in "$SRC"/.claude/hooks/tests/*.test.sh; do
    name=$(basename "$f" .test.sh)
    as_on_base "$name" ".claude/hooks/tests/$name.test.sh" || return 1
  done
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
