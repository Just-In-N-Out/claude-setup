#!/usr/bin/env bash
# Acceptance tests for story dream-trim (~/.hermes/plans/claude-setup/dream-trim.md): the one-time trim of four
# oversized instruction files into references/ files, and the tools that do it.
#   bash trim.test.sh                    every offline test (ac1-ac8 and the supporting fixture tests)
#   bash trim.test.sh <test> [<test>…]   just those, numbered TAP: "ok 1 - <test>"
# The tools and the map come from this file's own folder. The files they check come from TRIM_SRC (default: this
# file's own checkout, the dream-trim worktree or $HOME once merged): with a git checkout, the pass-1 and pass-2
# commits are found by subject and exported into a scratch folder; without one (a `git archive` export of the base),
# TRIM_SRC's tree is checked against itself, so a tree the trim never ran on fails. ac8 tests TRIM_SRC's own land.sh,
# mover and checker (a tree without them fails it).
# Fixtures, exports and the scratch setup repo of ac8 live under ${TRIM_TEST_ROOT:-$HOME/.cache/trim-tests}. Nothing
# here writes the live ~/.claude, ~/.hermes, a project folder, the real setup repo or its sync lock.
set -uo pipefail
HERE=$(cd "$(dirname "$0")" && pwd)
SRC=${TRIM_SRC:-$(cd "$HERE/../../.." && pwd)}
SRC=$(cd "$SRC" && pwd -P) || { echo "Bail out! TRIM_SRC is not a folder"; exit 1; }
REAL_HOME=$HOME
ROOT=${TRIM_TEST_ROOT:-$REAL_HOME/.cache/trim-tests}
mkdir -p "$ROOT"
# overrides inherited from a git hook or a Claude session would point git at real files: drop them
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL GIT_COMMITTER_NAME GIT_COMMITTER_EMAIL \
  GIT_CONFIG_PARAMETERS GIT_CONFIG_COUNT SETUP_SYNC_GIT_DIR SETUP_SYNC_URL SETUP_SYNC_PATH_COL

OFFLINE="checker_catches_loss_on_fixture mover_builds_fixture_and_stops_on_bad_anchor ac1_pass1_is_lossless
ac2_sizes_under_target ac3_headings_and_pointers_resolve ac4_existing_pins_still_pass ac5_checker_catches_loss
ac6_protected_lines_intact ac7_pass2_removals_accounted ac8_land_survives_next_sync"

CHECK="$HERE/trim-check.py"
MOVER="$HERE/move-to-references.py"
LAND="$HERE/land.sh"
MAP="$HERE/maps/dream-trim.json"
P1_SUBJECT='trim: pass 1, move to references (lossless)'
P2_SUBJECT='trim: pass 2, merge duplicates'
EVID=$REAL_HOME/.hermes/plans/claude-setup/evidence/dream-trim
PINS=${TRIM_BASE_PINS:-$EVID/base-pins.txt}
LEDGER=${TRIM_LEDGER:-$EVID/pass2-ledger.md}

fail() { echo "FAIL: $*"; return 1; }
need() { [ -e "$1" ] || fail "missing $1 (not built yet)"; }
newroot() { S=$(mktemp -d "$ROOT/t.XXXXXX") && S=$(cd "$S" && pwd -P) && echo "# test folder: $S"; }
done_ok() { rm -rf "$S"; return 0; }   # remove the test folder on success (kept on failure)
py() { PYTHONDONTWRITEBYTECODE=1 python3 -B "$@"; }
srcgit() { # git for TRIM_SRC: a worktree or clone whose top is TRIM_SRC itself, or $HOME's bare repo once merged
  local top
  top=$(git -C "$SRC" rev-parse --show-toplevel 2>/dev/null) && [ "$(cd "$top" && pwd -P)" = "$SRC" ] && { git -C "$SRC" "$@"; return; }
  [ -d "$SRC/.claude-setup.git" ] && { git --git-dir="$SRC/.claude-setup.git" --work-tree="$SRC" "$@"; return; }
  return 1
}
commit_by_subject() { srcgit log --format='%H%x09%s' 2>/dev/null | awk -F'\t' -v s="$1" '$2 == s { print $1; exit }'; }
export_tree() { mkdir -p "$2" && srcgit archive "$1" | tar -x -C "$2"; }
p1_trees() { # B = the tree before pass 1, P = the pass-1 tree; without a pass-1 commit both are TRIM_SRC itself
  local c
  c=$(commit_by_subject "$P1_SUBJECT")
  if [ -n "$c" ]; then
    B="$S/base" P="$S/p1"
    export_tree "$c^" "$B" && export_tree "$c" "$P" || fail "could not export $c and its parent" || return 1
    echo "# pass-1 commit $c, checked against its parent"
  else
    B="$SRC" P="$SRC"
    echo "# no '$P1_SUBJECT' commit in $SRC: its tree is checked against itself"
  fi
}

# ---- a small made-up skill, its trimmed form and its map (fixture tests only) ----
fixture() { # fixture <dir>: base/ and head/ trees and map.json under <dir>
  local d=$1
  mkdir -p "$d/base/sk/references" "$d/head/sk/references"
  printf '%s\n' '# Tiny skill' '' '## Rules' '' '- keep one' '- **Move me one:** a long rule that moves whole.' \
    '  - its sub-bullet, also moving' '- keep two' '' '### Sub rules' '' '- **Move me two:** another rule.' \
    '- keep three (it stays, unlike - **Move me two:** above)' '' '## Notes' '' '- **Note parent:** stays.' '  - a note that moves to the old reference' \
    >"$d/base/sk/SKILL.md"
  printf '%s\n' '# Old reference' '' 'old line' >"$d/base/sk/references/old.md"
  printf '%s\n' '# Tiny skill' '' '## Rules' '' '- keep one' '- keep two' \
    '- **Moved rules** (move me one, move me two): load `references/tiny.md` → "Moved rules".' '' '### Sub rules' '' \
    '- keep three (it stays, unlike - **Move me two:** above)' '' '## Notes' '' '- **Note parent:** stays.' \
    '  - Old notes: load `references/old.md` → "Notes kept".' >"$d/head/sk/SKILL.md"
  printf '%s\n' '# Tiny skill: rules moved whole from SKILL.md' '' '## Moved rules' '' \
    '- **Move me one:** a long rule that moves whole.' '  - its sub-bullet, also moving' \
    '- **Move me two:** another rule.' >"$d/head/sk/references/tiny.md"
  # an existing references file only gains lines; the parent line is copied above its moved sub-bullet
  printf '%s\n' '# Old reference' '' 'old line' '' '## Notes kept' '' '- **Note parent:** stays.' \
    '  - a note that moves to the old reference' >"$d/head/sk/references/old.md"
  cat >"$d/map.json" <<'EOF'
{"name": "fixture", "files": [{"path": "sk/SKILL.md", "max_chars": 1000, "groups": [
  {"target": "sk/references/tiny.md", "header": "# Tiny skill: rules moved whole from SKILL.md",
   "heading": "## Moved rules",
   "lines": [{"anchor": "- **Move me one:**", "count": 2}, {"anchor": "- **Move me two:**"}],
   "pointer": "- **Moved rules** (move me one, move me two): load `references/tiny.md` → \"Moved rules\".",
   "pointer_after": "- keep two"},
  {"target": "sk/references/old.md", "heading": "## Notes kept",
   "parent": [{"anchor": "- **Note parent:**"}],
   "lines": [{"anchor": "- **Note parent:**", "offset": 1, "until_outdent": true}],
   "pointer": "  - Old notes: load `references/old.md` → \"Notes kept\"."}]}],
 "protect": {"sections": [{"file": "sk/SKILL.md", "heading": "## Notes"}]}}
EOF
}
# planted losses: copy the head tree, change one thing, the checker must exit 1 and name the line
expect_loss() { # expect_loss <label> <map> <base> <head copy> <text the output must name>
  local out rc
  out=$(py "$CHECK" pass1 --map "$2" --base "$3" --head "$4" 2>&1); rc=$?
  printf '%s\n' "$out" | head -n 4 | cut -c1-160 | sed 's/^/#     /'
  [ "$rc" = 1 ] || fail "$1: checker exit $rc, want 1" || return 1
  grep -qF -- "$5" <<<"$out" || fail "$1: the output does not name the line '$5'" || return 1
  echo "# $1: exit 1, names '${5:0:60}'"
}
plant() { # plant <file> drop|change <exact line>: drop that line, or change its 3rd character; fails if absent
  py - "$@" <<'EOF'
import sys
p, how, line = sys.argv[1:4]
t = open(p, encoding='utf-8', newline='').read().split('\n')
if line not in t:
    sys.exit(f"plant: no such line in {p}: {line[:60]!r}")
i = t.index(line)
if how == 'drop':
    del t[i]
else:
    k = min(2, len(line) - 1)
    t[i] = line[:k] + ('X' if line[k] != 'X' else 'Y') + line[k + 1:]
open(p, 'w', encoding='utf-8', newline='').write('\n'.join(t))
EOF
}

checker_catches_loss_on_fixture() {
  newroot || return 1
  need "$CHECK" || return 1
  fixture "$S/f"
  local F="$S/f" out rc
  out=$(py "$CHECK" pass1 --map "$F/map.json" --base "$F/base" --head "$F/head" 2>&1); rc=$?
  printf '%s\n' "$out" | sed 's/^/#   /'
  [ "$rc" = 0 ] || fail "control: the hand-trimmed fixture is lossless, checker exit $rc" || return 1
  cp -a "$F/head" "$S/h1"; plant "$S/h1/sk/references/tiny.md" drop '- **Move me two:** another rule.' || return 1
  expect_loss "moved line dropped" "$F/map.json" "$F/base" "$S/h1" '- **Move me two:** another rule.' || return 1
  cp -a "$F/head" "$S/h2"; plant "$S/h2/sk/references/tiny.md" change '  - its sub-bullet, also moving' || return 1
  expect_loss "moved line changed by one character" "$F/map.json" "$F/base" "$S/h2" '  - its sub-bullet, also moving' || return 1
  cp -a "$F/head" "$S/h3"
  plant "$S/h3/sk/SKILL.md" drop '- **Moved rules** (move me one, move me two): load `references/tiny.md` → "Moved rules".' || return 1
  expect_loss "pointer removed" "$F/map.json" "$F/base" "$S/h3" '- **Moved rules** (move me one, move me two)' || return 1
  cp -a "$F/head" "$S/h4"; plant "$S/h4/sk/SKILL.md" drop '### Sub rules' || return 1
  expect_loss "heading removed" "$F/map.json" "$F/base" "$S/h4" '### Sub rules' || return 1
  cp -a "$F/head" "$S/h5"; plant "$S/h5/sk/SKILL.md" change '- keep two' || return 1
  expect_loss "kept line changed" "$F/map.json" "$F/base" "$S/h5" '- keep two' || return 1
  cp -a "$F/head" "$S/h6"; plant "$S/h6/sk/references/old.md" drop 'old line' || return 1
  expect_loss "existing references line dropped" "$F/map.json" "$F/base" "$S/h6" 'old line' || return 1
  cp -a "$F/head" "$S/h8"; plant "$S/h8/sk/references/old.md" drop '  - a note that moves to the old reference' || return 1
  expect_loss "moved line dropped from an existing file" "$F/map.json" "$F/base" "$S/h8" '  - a note that moves to the old reference' || return 1
  cp -a "$F/head" "$S/h7"; printf '%s\n' '- a made-up rule nobody wrote' >>"$S/h7/sk/references/tiny.md"
  expect_loss "new prose in a references file" "$F/map.json" "$F/base" "$S/h7" '- a made-up rule nobody wrote' || return 1
  cp -a "$F/head" "$S/h9"; sed -i.bak 's/^## Moved rules$/## Other rules/' "$S/h9/sk/references/tiny.md"
  expect_loss "group under the wrong heading" "$F/map.json" "$F/base" "$S/h9" '- **Move me one:** a long rule' || return 1
  cp -a "$F/head" "$S/h10"; printf '%s\n' '- **Move me two:** another rule.' >>"$S/h10/sk/SKILL.md"
  expect_loss "moved line also left behind" "$F/map.json" "$F/base" "$S/h10" '- **Move me two:** another rule.' || return 1
  cp -a "$F/head" "$S/h11"; rm "$S/h11/sk/references/tiny.md"
  expect_loss "references file missing" "$F/map.json" "$F/base" "$S/h11" 'sk/references/tiny.md: missing' || return 1
  cp -a "$F/head" "$S/h12"; sed -i.bak 's/^- \*\*Move me two:\*\* another rule\.$/& /' "$S/h12/sk/references/tiny.md"
  expect_loss "trailing space added" "$F/map.json" "$F/base" "$S/h12" '- **Move me two:** another rule.' || return 1
  # headings mode: the same fixture passes; a dropped heading, a pointer to a missing heading or file fails
  out=$(py "$CHECK" headings --map "$F/map.json" --base "$F/base" --head "$F/head" 2>&1); rc=$?
  [ "$rc" = 0 ] || { echo "#   $out"; fail "headings control: exit $rc"; return 1; }
  cp -a "$F/head" "$S/k1"; plant "$S/k1/sk/SKILL.md" drop '### Sub rules' || return 1
  expect_headings "heading dropped" "$F" "$S/k1" 'heading missing or changed: ### Sub rules' || return 1
  cp -a "$F/head" "$S/k2"; sed -i.bak 's/^## Notes kept$/## Notes/' "$S/k2/sk/references/old.md"
  expect_headings "pointer to a missing heading" "$F" "$S/k2" 'points at heading "Notes kept"' || return 1
  cp -a "$F/head" "$S/k3"; rm "$S/k3/sk/references/tiny.md"
  expect_headings "pointer to a missing file" "$F" "$S/k3" 'points at references/tiny.md, which does not exist' || return 1
  done_ok
}
expect_headings() { # expect_headings <label> <fixture dir> <head copy> <text the output must name>
  local out rc
  out=$(py "$CHECK" headings --map "$2/map.json" --base "$2/base" --head "$3" 2>&1); rc=$?
  printf '%s\n' "$out" | head -n 3 | cut -c1-160 | sed 's/^/#     /'
  [ "$rc" = 1 ] && grep -qF -- "$4" <<<"$out" || fail "headings $1: exit $rc, want 1 naming '$4'" || return 1
  echo "# headings $1: exit 1, names it"
}

mover_builds_fixture_and_stops_on_bad_anchor() {
  newroot || return 1
  need "$MOVER" || return 1
  fixture "$S/f"
  local F="$S/f" out rc
  cp -a "$F/base" "$S/w"
  out=$(py "$MOVER" --map "$F/map.json" --root "$S/w" 2>&1); rc=$?
  printf '%s\n' "$out" | sed 's/^/#   /'
  [ "$rc" = 0 ] || fail "mover exit $rc on the fixture" || return 1
  diff -r "$F/head" "$S/w" >"$S/diff.txt" || { sed 's/^/#   /' "$S/diff.txt"; fail "the mover's tree differs from the hand-trimmed fixture"; return 1; }
  echo "# mover output equals the hand-trimmed fixture byte for byte"
  # rerun on the moved tree: its anchors are gone, so it stops and writes nothing
  cp -a "$S/w" "$S/w2"
  out=$(py "$MOVER" --map "$F/map.json" --root "$S/w2" 2>&1); rc=$?
  echo "#   $out"
  [ "$rc" = 2 ] && grep -qF 'anchor missing' <<<"$out" && grep -qF -- '- **Move me one:**' <<<"$out" \
    || fail "rerun on a moved tree: exit $rc, want 2 naming the missing anchor" || return 1
  diff -r "$S/w" "$S/w2" >/dev/null || fail "the refused rerun changed files" || return 1
  # an anchor matching two lines stops it too
  cp -a "$F/base" "$S/w3"; printf '%s\n' '- **Move me two:** a second line with the same start.' >>"$S/w3/sk/SKILL.md"
  cp -a "$S/w3" "$S/w3.before"
  out=$(py "$MOVER" --map "$F/map.json" --root "$S/w3" 2>&1); rc=$?
  echo "#   $out"
  [ "$rc" = 2 ] && grep -qF 'matches 2 lines' <<<"$out" || fail "duplicate anchor: exit $rc, want 2 'matches 2 lines'" || return 1
  diff -r "$S/w3.before" "$S/w3" >/dev/null || fail "the refused run changed files" || return 1
  # the result passes the checker
  py "$CHECK" pass1 --map "$F/map.json" --base "$F/base" --head "$S/w" || fail "checker refuses the mover's tree" || return 1
  done_ok
}

ac1_pass1_is_lossless() {
  newroot || return 1
  need "$CHECK" || return 1; need "$MAP" || return 1
  p1_trees || return 1
  py "$CHECK" pass1 --map "$MAP" --base "$B" --head "$P" 2>&1 | head -n 40 | cut -c1-200
  [ "${PIPESTATUS[0]}" = 0 ] || fail "the pass-1 tree is not a lossless move of its base" || return 1
  echo "# every moved line is byte for byte in its references/ file, in order; kept lines unchanged; only pointers added"
  done_ok
}

ac2_sizes_under_target() {
  newroot || return 1
  need "$CHECK" || return 1
  p1_trees || return 1
  # the targets are pinned here, not read from the map
  py "$CHECK" size --root "$P" \
    .hermes/skills/software-development/figma-to-bricks/SKILL.md=56000 \
    .hermes/skills/autonomous-ai-agents/feature-dispatch/SKILL.md=75000 \
    .hermes/skills/software-development/leorna/SKILL.md=52000 \
    .claude/project-docs/figma-to-bricks/CLAUDE.md=56000 || fail "a file is over its target" || return 1
  done_ok
}

ac3_headings_and_pointers_resolve() {
  newroot || return 1
  need "$CHECK" || return 1; need "$MAP" || return 1
  p1_trees || return 1
  py "$CHECK" headings --map "$MAP" --base "$B" --head "$P" 2>&1 | head -n 40 | cut -c1-200
  [ "${PIPESTATUS[0]}" = 0 ] || fail "pass 1: a heading or pointer does not resolve" || return 1
  echo "# pass 1: every ## and ### heading of the base is there; every pointer names a file and heading that exist"
  local c2
  c2=$(commit_by_subject "$P2_SUBJECT")
  if [ -n "$c2" ]; then
    export_tree "$c2" "$S/p2" || return 1
    py "$CHECK" headings --map "$MAP" --base "$B" --head "$S/p2" 2>&1 | head -n 40 | cut -c1-200
    [ "${PIPESTATUS[0]}" = 0 ] || fail "pass 2 ($c2): a heading or pointer does not resolve" || return 1
    echo "# pass 2 ($c2): the same holds"
  else
    echo "# no '$P2_SUBJECT' commit yet: pass 1 only"
  fi
  done_ok
}

ac4_existing_pins_still_pass() {
  newroot || return 1
  [ -f "$PINS" ] || fail "no base tally at $PINS (plan Task 0)" || return 1
  local name path
  mkdir -p "$S/tmp"
  for s in harness-guards:.claude/hooks/tests/harness-guards.test.sh \
           review-check:.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.test.sh \
           codex-parity:.claude/setup/codex/codex-parity.test.sh; do
    name=${s%%:*} path=${s#*:}
    need "$SRC/$path" || return 1
    (cd "$SRC" && TMPDIR="$S/tmp" HARNESS_GUARDS_TEST_ROOT="$S/hg" CODEX_PARITY_TEST_ROOT="$S/cp" bash "$path") >"$S/$name.log" 2>&1
    echo "# $name.test.sh on $SRC: $(grep -E '^# passed [0-9]+, failed [0-9]+$' "$S/$name.log" | tail -n 1 | sed 's/^# //')"
    grep -E '^(ok|not ok) [0-9]+ - ' "$S/$name.log" | sed -E "s/^(ok|not ok) [0-9]+ - (.*)$/$name\t\2\t\1/" >>"$S/head-pins.txt"
  done
  awk -F'\t' 'NR == FNR { head[$1 FS $2] = $3; next }
    /^#/ || $3 != "ok" { next }
    { k = $1 FS $2; if (head[k] == "ok") n++; else { printf "FAIL: %s %s passed on the base, %s here\n", $1, $2, (k in head ? head[k] : "did not run"); bad = 1 } }
    END { printf "# %d tests that passed on the base pass here\n", n; exit bad }' "$S/head-pins.txt" "$PINS" || return 1
  done_ok
}

plant_case() { # plant_case <base> <copy> <main file> drop|change|pointer|heading: plant one loss in <copy>; prints the
  # first 60 characters of the line the checker must name. drop/change hit the first moved line of the file's first
  # group in its references/ file; pointer drops that group's pointer; heading drops the main file's first "## " line.
  py - "$MAP" "$@" <<'EOF'
import json, os, sys
mp, base, copy, f, case = sys.argv[1:6]
e = next(x for x in json.load(open(mp, encoding='utf-8'))['files'] if x['path'] == f)
g = e['groups'][0]
rd = lambda p: open(p, encoding='utf-8', newline='').read().split('\n')
def wr(p, t):
    with open(p, 'w', encoding='utf-8', newline='') as fh:
        fh.write('\n'.join(t))
b = rd(os.path.join(base, f))
s = g['lines'][0]
moved = b[[k for k, l in enumerate(b) if l.startswith(s['anchor'])][0] + int(s.get('offset', 0))]
if case in ('drop', 'change'):
    p = os.path.join(copy, g['target'])
    t = rd(p)
    j = t.index(moved)
    named = moved
    if case == 'drop':
        del t[j]
    else:
        t[j] = moved[:2] + ('X' if moved[2] != 'X' else 'Y') + moved[3:]
else:
    p = os.path.join(copy, f)
    t = rd(p)
    named = g['pointer'] if case == 'pointer' else next(l for l in t if l.startswith('## '))
    t.remove(named)
wr(p, t)
print(named[:60])
EOF
}

ac5_checker_catches_loss() {
  newroot || return 1
  need "$CHECK" || return 1; need "$MAP" || return 1
  local c f k named out rc
  c=$(commit_by_subject "$P1_SUBJECT")
  [ -n "$c" ] || fail "no '$P1_SUBJECT' commit to copy" || return 1
  export_tree "$c^" "$S/base" && export_tree "$c" "$S/p1" || return 1
  echo "# copies of pass-1 commit $c and its parent"
  out=$(py "$CHECK" pass1 --map "$MAP" --base "$S/base" --head "$S/p1" 2>&1); rc=$?
  [ "$rc" = 0 ] || { printf '%s\n' "$out" | head -n 5; fail "control: the unchanged copy fails the check (exit $rc)"; return 1; }
  echo "# control: the unchanged copy passes (exit 0)"
  k=0
  for f in .hermes/skills/software-development/figma-to-bricks/SKILL.md \
           .hermes/skills/autonomous-ai-agents/feature-dispatch/SKILL.md \
           .hermes/skills/software-development/leorna/SKILL.md .claude/project-docs/figma-to-bricks/CLAUDE.md; do
    for case in drop change pointer heading; do
      k=$((k + 1))
      cp -a "$S/p1" "$S/c$k"
      named=$(plant_case "$S/base" "$S/c$k" "$f" "$case") || fail "could not plant '$case' in $f" || return 1
      expect_loss "${f##*/skills/} $case" "$MAP" "$S/base" "$S/c$k" "$named" || return 1
      rm -rf "$S/c$k"
    done
  done
  echo "# $k planted losses, each refused with exit 1 and its line named"
  done_ok
}

p2_trees() { # P1 = the pass-1 tree, P2 = the pass-2 tree; both commits must exist
  local c1 c2
  c1=$(commit_by_subject "$P1_SUBJECT"); c2=$(commit_by_subject "$P2_SUBJECT")
  [ -n "$c1" ] && [ -n "$c2" ] || fail "need both the '$P1_SUBJECT' and the '$P2_SUBJECT' commits in $SRC" || return 1
  P1="$S/p1" P2="$S/p2"
  export_tree "$c1" "$P1" && export_tree "$c2" "$P2" || return 1
  echo "# pass 1 $c1, pass 2 $c2"
}

ac6_protected_lines_intact() {
  newroot || return 1
  need "$CHECK" || return 1; need "$MAP" || return 1
  p2_trees || return 1
  py "$CHECK" protect --map "$MAP" --root "$P1" --out "$S/protected.tsv" || fail "could not list the protected lines" || return 1
  local n h
  n=$(grep -vc '^#' "$S/protected.tsv")
  cut -f4 "$S/protected.tsv" >"$S/protected-text.txt"   # a file, not a pipe into grep -q (pipefail + early exit)
  [ "$n" -ge 100 ] || fail "only $n protected lines: the list is too short to be the plan's" || return 1
  # the plan's sections are in the list (pinned here, not read from the map)
  for h in '## Hard rules (details live in memory)' '7. **"make a PR"** (push + open, never merge).' \
           '   9. Offer **post** for the ClickUp evidence.' '## Merge policy per project' '## Skills every agent loads' \
           '### Phase 3b: Fresh review, then finish' '## Step 4: Merge into main (from the main folder)' \
           '## Working in this repo'; do
    grep -qF -- "$h" "$S/protected-text.txt" || fail "the protected list lacks '$h'" || return 1
  done
  # lines outside those sections that only a rule word plus a safety word protects ("never", "don't", "refuses")
  for h in '- Never use bare `git stash`: every copy shares the stash list.' \
           '- **goal:** `PLANNER for <project> feature "<name>". Write a plan Justin will approve;' \
           '  - `git branch -d` refuses a branch that has an `origin/` upstream'; do
    grep -qF -- "${h:0:80}" "$S/protected-text.txt" || fail "the protected list lacks '$h'" || return 1
  done
  py "$CHECK" protect --map "$MAP" --root "$P1" --check "$P2" 2>&1 | head -n 20 | cut -c1-200
  [ "${PIPESTATUS[0]}" = 0 ] || fail "a protected line is missing or changed after pass 2" || return 1
  echo "# all $n protected lines of pass 1 are in the same file after pass 2, byte for byte"
  # control: the check must refuse a pass-2 tree that lost one protected line
  cp -a "$P2" "$S/bad"
  h=$(awk -F'\t' '!/^#/ && $1 ~ /leorna/ { print $4; exit }' "$S/protected.tsv")
  py - "$S/bad/.hermes/skills/software-development/leorna/SKILL.md" "$h" <<'EOF'
import sys
p, pre = sys.argv[1:3]
t = open(p, encoding='utf-8', newline='').read().split('\n')
t.pop(next(i for i, l in enumerate(t) if l.startswith(pre)))
open(p, 'w', encoding='utf-8', newline='').write('\n'.join(t))
EOF
  py "$CHECK" protect --map "$MAP" --root "$P1" --check "$S/bad" >"$S/bad.out" 2>&1 && fail "control: a dropped protected line passed" && return 1
  grep -qF -- "$h" "$S/bad.out" || fail "control: the refusal does not name the dropped line" || return 1
  echo "# control: a copy missing '${h:0:50}' is refused"
  done_ok
}

ac7_pass2_removals_accounted() {
  newroot || return 1
  need "$CHECK" || return 1; need "$MAP" || return 1
  [ -f "$LEDGER" ] || fail "no pass-2 ledger at $LEDGER" || return 1
  p2_trees || return 1
  py "$CHECK" pass2 --map "$MAP" --base "$P1" --head "$P2" --ledger "$LEDGER" 2>&1 | head -n 30 | cut -c1-200
  [ "${PIPESTATUS[0]}" = 0 ] || fail "a pass-2 removal has no ledger row, or its kept line is gone" || return 1
  # control: a ledger missing its first row must fail
  awk 'BEGIN { skip = 0 } /^\|/ && /[0-9a-f]{40}/ && !done { done = 1; next } { print }' "$LEDGER" >"$S/short-ledger.md"
  py "$CHECK" pass2 --map "$MAP" --base "$P1" --head "$P2" --ledger "$S/short-ledger.md" >"$S/short.out" 2>&1 \
    && fail "control: a ledger missing a row passed" && return 1
  grep -q '^FAIL .*no ledger row' "$S/short.out" || fail "control: the refusal does not say which line has no row" || return 1
  echo "# control: the ledger without its first row is refused: $(grep -m1 '^FAIL' "$S/short.out" | cut -c1-120)"
  # control: a row whose kept line is not in the pass-2 tree must fail
  py - "$LEDGER" "$S/bad-kept.md" <<'EOF2'
import re, sys
t = open(sys.argv[1], encoding='utf-8').read().split('\n')
i = next(k for k, l in enumerate(t) if l.startswith('|') and re.search(r'[0-9a-f]{40}', l))
shas = re.findall(r'[0-9a-f]{40}', t[i])
t[i] = t[i].replace(shas[-1], '0' * 40)  # the kept sha1 (the last one on the row)
open(sys.argv[2], 'w', encoding='utf-8').write('\n'.join(t))
EOF2
  py "$CHECK" pass2 --map "$MAP" --base "$P1" --head "$P2" --ledger "$S/bad-kept.md" >"$S/bad-kept.out" 2>&1 \
    && fail "control: a ledger row naming a missing kept line passed" && return 1
  grep -q '^FAIL .*names a kept line' "$S/bad-kept.out" || fail "control: the refusal does not name the missing kept line" || return 1
  echo "# control: a row whose kept line is not after pass 2 is refused"
  done_ok
}

ac8_land_survives_next_sync() {
  newroot || return 1
  local T="$SRC/.claude/setup/trim"   # the landing tools under test are TRIM_SRC's own
  need "$T/land.sh" || return 1; need "$T/trim-check.py" || return 1; need "$T/move-to-references.py" || return 1
  local H="$S/home" GD="$S/home/.claude-setup.git" PROJ="$S/home/Documents/Proj" WT="$S/wt" COPY out rc p1 m0
  COPY="$H/.claude/project-docs/proj/CLAUDE.md"
  printf '[user]\n\tname = Test Personal\n\temail = test@example.test\n[init]\n\tdefaultBranch = main\n[core]\n\thooksPath = /dev/null\n[advice]\n\tdetachedHead = false\n' >"$S/gitconfig"
  in_h() { env -u CODEX_HOME HOME="$H" GIT_CONFIG_GLOBAL="$S/gitconfig" GIT_CONFIG_NOSYSTEM=1 TMPDIR="$S/tmp" \
    SETUP_SYNC_URL="$S/no-remote.git" SETUP_SYNC_PATH_COL=3 "$@"; }
  g() { in_h git -c core.quotePath=false --git-dir="$GD" --work-tree="$H" "$@"; }
  mkdir -p "$S/tmp" "$H/.claude/setup" "$H/.claude/project-docs/proj" "$PROJ"
  for f in sync.sh manifest.txt exclude.txt gitleaks.toml; do cp "$SRC/.claude/setup/$f" "$H/.claude/setup/" || return 1; done
  printf '# name\tmac_path\tdesktop_path\tmemory\tclaude_md\nproj\t%s\t%s\t-\tyes\n' "$PROJ" "$PROJ" >"$H/.claude/setup/projects.tsv"
  printf '%s\n' '# Proj: instructions' '' '## Status' '' '- **Current build `1.2`**' '  - **1.2 newest:** stays.' \
    '  - **1.1 older:** moves.' '    its wrapped second line.' '  - **1.0 oldest:** moves.' \
    '- **Paste checks owed:** none.' '' '## Decisions' '' '- **Keep it simple** (user, 2026-11-01): stays.' >"$PROJ/CLAUDE.md"
  cp "$PROJ/CLAUDE.md" "$COPY"
  (cd "$H" && in_h bash .claude/setup/sync.sh init) >"$S/init.log" 2>&1 || { cat "$S/init.log"; fail "sync.sh init"; return 1; }
  g add -A -- .claude/setup .claude/project-docs && g commit -q -m 'base' || fail "base commit" || return 1
  # the trim branch: a tool commit, then pass 1 made by the mover
  g worktree add -q -b trim-test "$WT" main >/dev/null 2>&1 || fail "feature worktree" || return 1
  mkdir -p "$WT/.claude/setup/trim/maps"
  cp "$T/trim-check.py" "$T/move-to-references.py" "$T/land.sh" "$WT/.claude/setup/trim/"
  cat >"$WT/.claude/setup/trim/maps/ac8.json" <<'EOF'
{"name": "ac8", "files": [{"path": ".claude/project-docs/proj/CLAUDE.md", "max_chars": 1000, "groups": [
  {"target": ".hermes/skills/x/sk/references/proj-status-log.md", "header": "# Proj: older Status entries",
   "heading": "## Older builds", "parent": [{"anchor": "- **Current build"}],
   "lines": [{"anchor": "  - **1.1 older:**", "until_outdent": true}],
   "pointer": "  - **Older builds:** `~/.hermes/skills/x/sk/references/proj-status-log.md` → \"Older builds\"."}]}]}
EOF
  in_h git -C "$WT" add -A .claude/setup/trim && in_h git -C "$WT" commit -q -m 'trim: tools' || fail "tool commit" || return 1
  py "$T/move-to-references.py" --map "$WT/.claude/setup/trim/maps/ac8.json" --root "$WT" >/dev/null || fail "mover on the branch" || return 1
  in_h git -C "$WT" add -A .claude .hermes && in_h git -C "$WT" commit -q -m "$P1_SUBJECT" || fail "pass-1 commit" || return 1
  p1=$(in_h git -C "$WT" rev-parse HEAD)
  # meanwhile a sync moves main: a session changed a kept line of the project file, and copy_in copied it
  sed -i.bak 's/^- \*\*Paste checks owed:\*\* none\.$/- **Paste checks owed:** 3x./' "$PROJ/CLAUDE.md" && rm -f "$PROJ/CLAUDE.md.bak"
  cp "$PROJ/CLAUDE.md" "$COPY"
  g add -A -- .claude/project-docs && g commit -q -m 'sync(test): 1 file(s)' || fail "moving main" || return 1
  m0=$(g rev-parse main)
  # control: an edit to the project file that no sync has picked up yet stops the landing, and nothing changes
  printf '%s\n' '- **Unsynced:** a line a session just wrote.' >>"$PROJ/CLAUDE.md"
  cp "$PROJ/CLAUDE.md" "$S/proj-edited"
  out=$(cd "$H" && in_h bash "$T/land.sh" "$p1" --map .claude/setup/trim/maps/ac8.json --suites none 2>&1); rc=$?
  printf '%s\n' "$out" | tail -n 2 | sed 's/^/#   /'
  [ "$rc" = 1 ] && [ "$(g rev-parse main)" = "$m0" ] && cmp -s "$S/proj-edited" "$PROJ/CLAUDE.md" \
    || fail "control: land.sh exit $rc over an unsynced project edit, want 1 with main and the file unchanged" || return 1
  [ ! -e "$GD/setup-sync.lock" ] || fail "control: the lock was left behind" || return 1
  echo "# control: an unsynced edit to the project file stops the landing (exit 1), main and the file unchanged"
  sed -i.bak '/^- \*\*Unsynced:\*\*/d' "$PROJ/CLAUDE.md" && rm -f "$PROJ/CLAUDE.md.bak"
  cmp -s "$PROJ/CLAUDE.md" "$COPY" || fail "could not undo the control edit" || return 1
  # control: a sync holds the lock, so land.sh stops before merging and leaves that sync's lock alone
  mkdir "$GD/setup-sync.lock"
  out=$(cd "$H" && in_h bash "$T/land.sh" "$p1" --map .claude/setup/trim/maps/ac8.json --suites none 2>&1); rc=$?
  printf '%s\n' "$out" | tail -n 1 | sed 's/^/#   /'
  [ "$rc" = 1 ] && grep -qF 'another sync is running' <<<"$out" && [ "$(g rev-parse main)" = "$m0" ] && [ -d "$GD/setup-sync.lock" ] \
    || fail "control: land.sh exit $rc while a sync held the lock, want 1 with main unchanged and the lock kept" || return 1
  rmdir "$GD/setup-sync.lock"
  echo "# control: while a sync holds the lock, land.sh stops (exit 1), main unchanged, that sync's lock kept"
  # control, on a copy of this home: a session writes the project file while main is merged (a post-merge hook
  # stands in for it); land.sh lands main but must not overwrite that edit
  local H2="$S/home2"
  cp -a "$H" "$H2" && sed -i.bak "s|$H/|$H2/|g" "$H2/.claude/setup/projects.tsv" && rm -f "$H2/.claude/setup/projects.tsv.bak"
  mkdir -p "$S/race-hooks"
  printf '#!/bin/sh\necho "- **Race:** a session wrote this during the merge." >>"%s/Documents/Proj/CLAUDE.md"\n' "$H2" \
    >"$S/race-hooks/post-merge" && chmod +x "$S/race-hooks/post-merge"
  in_h git --git-dir="$H2/.claude-setup.git" config core.hooksPath "$S/race-hooks"
  out=$(cd "$H2" && env -u CODEX_HOME HOME="$H2" GIT_CONFIG_GLOBAL="$S/gitconfig" GIT_CONFIG_NOSYSTEM=1 TMPDIR="$S/tmp" \
    SETUP_SYNC_PATH_COL=3 bash "$T/land.sh" "$p1" --map .claude/setup/trim/maps/ac8.json --suites none 2>&1); rc=$?
  printf '%s\n' "$out" | tail -n 1 | cut -c1-160 | sed 's/^/#   /'
  [ "$rc" = 1 ] && grep -qF 'changed while landing' <<<"$out" \
    && grep -qxF -- '- **Race:** a session wrote this during the merge.' "$H2/Documents/Proj/CLAUDE.md" \
    && [ "$(in_h git --git-dir="$H2/.claude-setup.git" log -1 --format=%s main)" = "$P1_SUBJECT" ] \
    || fail "control: land.sh exit $rc over an edit made during the merge, want 1 with the edit kept" || return 1
  [ ! -e "$H2/.claude-setup.git/setup-sync.lock" ] || fail "control: the lock was left behind" || return 1
  echo "# control: an edit made to the project file during the merge is left as it is (exit 1, lock released)"
  # land
  out=$(cd "$H" && in_h bash "$T/land.sh" "$p1" --map .claude/setup/trim/maps/ac8.json --suites none 2>&1); rc=$?
  printf '%s\n' "$out" | sed 's/^/#   /'
  [ "$rc" = 0 ] || fail "land.sh exit $rc" || return 1
  [ "$(g log -3 --format=%s main | tr '\n' '|')" = "$P1_SUBJECT|trim: tools|sync(test): 1 file(s)|" ] \
    || fail "main is not sync → tools → pass 1: $(g log -3 --format=%s main | tr '\n' '|')" || return 1
  g show "main:.claude/project-docs/proj/CLAUDE.md" >"$S/main-copy" && cmp -s "$S/main-copy" "$COPY" || fail "the copy in \$HOME is not main's" || return 1
  grep -qxF -- '- **Paste checks owed:** 3x.' "$COPY" || fail "pass 1 was not made again on the newer main" || return 1
  ! grep -qF '1.1 older' "$COPY" && grep -qF 'proj-status-log.md` → "Older builds"' "$COPY" \
    && grep -qF '  - **1.1 older:** moves.' "$H/.hermes/skills/x/sk/references/proj-status-log.md" \
    || fail "the copy is not trimmed" || return 1
  cmp -s "$PROJ/CLAUDE.md" "$COPY" || fail "the project's own CLAUDE.md is not the trimmed copy" || return 1
  echo "# landed: main = sync → tools → pass 1 made again on it; the project's own CLAUDE.md equals the trimmed copy"
  # the next sync
  out=$(cd "$H" && in_h bash .claude/setup/sync.sh status 2>&1); rc=$?
  printf '%s\n' "$out" | sed 's/^/#   /'
  [ "$rc" = 0 ] || fail "sync.sh status exit $rc" || return 1
  g show "main:.claude/project-docs/proj/CLAUDE.md" >"$S/main-copy" && cmp -s "$S/main-copy" "$COPY" || fail "the sync put the old text back in the copy" || return 1
  out=$(g diff --cached --name-only) || fail "git diff --cached failed" || return 1
  ! grep -qxF .claude/project-docs/proj/CLAUDE.md <<<"$out" || fail "the sync staged a change to the copy" || return 1
  cmp -s "$PROJ/CLAUDE.md" "$COPY" || fail "after the sync the project file and the copy differ" || return 1
  [ ! -e "$GD/setup-sync.lock" ] || fail "the lock was left behind" || return 1
  [ "$(g worktree list | wc -l | tr -d ' ')" = 2 ] || fail "land.sh left a scratch worktree: $(g worktree list)" || return 1
  echo "# after sync.sh status: the copy is still the trimmed one and nothing is staged for it; lock released"
  g worktree remove --force "$WT" >/dev/null 2>&1
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
