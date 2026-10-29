# Brief: PLANNER (amend mode) for figma-to-bricks feature "header-bar"

Amend the approved plan for Justin's mid-build decisions. Don't re-plan, don't build, don't commit (the main session
commits the plan file), don't start agents. Be quick: read the existing plan first, then only what the amendment needs;
finish within about 20 steps.

## Where
- Worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/header-bar` (head `5ad18c1`). The plan:
  `docs/plans/2026-10-29-header-bar.md`. The read-only approved copy:
  `~/.hermes/plans/figma-to-bricks/evidence/header-bar/plan-approved.md`.
- Write the amended plan into the worktree's plan file, and a copy to
  `~/.hermes/plans/figma-to-bricks/evidence/header-bar/amendment-1/plan-amended.md`. Change no other file.

## Skills
Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (planner role) and `references/rules-summary.md`;
load `implementation-planning`. Then read the amendment rules in
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` ("When Justin decides something
mid-build…", lines 21–23) and follow them exactly.

## Justin's decisions to fold in
1. **2026-10-29, "Ship now, menu later"** (asked after review 2, when everything but the ☰ menu was built): AC14 (the
   B-Dry ☰ opens and closes the menu) and Tasks 7–9 (the Offcanvas + Toggle sample, renderer support, the menu) leave
   this job for a follow-up job `header-menu`, started when Justin's sample arrives. Until then the B-Dry ☰ is a
   picture that opens nothing. Move AC14's text and Tasks 7–9 into a "Deferred to the header-menu job" section in
   which no line starts with an AC id (e.g. "Was AC14: …"); keep the other AC ids as they are (AC15, AC16 keep their
   numbers). Q3's recorded answer becomes "A, then deferred by Justin".
2. **2026-10-29, H1 = A** (`~/.hermes/plans/figma-to-bricks/evidence/header-bar/justin-answers.md`): a design drawn
   wider than 1440 keeps its header inside the 1440 Container at every screen width; Q6 A's window edges apply only to
   designs drawn 1440 wide or narrower; a Figma wrapper's own max width still wins. Reflect it in AC4's wording (its
   test name stays the same) and in the fix description.
3. **Reconcile test expectations changed in the fix rounds** (the rule in ac-verification.md line 21): for every AC
   whose test gained or changed cases in fixer 1 or fixer 2 (AC1, AC2, AC4, AC6 at least; see
   `~/.hermes/plans/figma-to-bricks/evidence/header-bar/fixer-1/` and `fixer-2/`, the ledger
   `.superpowers/sdd/2026-10-29-header-bar/progress.md` and the test files), list what each test now asserts and make
   the AC's wording match it, in one amendment. Test names on each AC line must stay exactly as they are.

## Checks before you finish
- An **Amendments** list at the top: date, each decision, each changed AC line, where the pre-amendment text lives
  (`git show 5ad18c1:docs/plans/2026-10-29-header-bar.md`), and every earlier receipt that still encodes an old
  expectation. No Amendments line starts with an AC id.
- Run `ac-check.sh`'s `ac_start`, `bad_id` and `live` regexes
  (`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`) on the approved copy and the amended
  plan, and report: the old and new AC id lists (only AC14 gone), the live set (unchanged: AC16), and that every
  remaining AC's test-name line is unchanged.

## Rules
The worktree guard refuses Bash it can't prove stays in the worktree (shell variables or loops around `node`/`git`/
`sed`, heredoc then node, `git -C`, the word git inside a grep pattern or a script's text, the word `source`
anywhere): write scripts with Write and run them as one plain command. Lessons: `skill_lessons[{skill, lesson,
evidence, enforce}]` (normally empty); never edit skills or memory.

## Return
`{status: amended|stopped, plan_path, copy_path, amendments[], ac_ids_old[], ac_ids_new[], live_old[], live_new[],
test_lines_unchanged: true|false, stale_receipts[], skill_lessons[]}`. End with the line
`MAIN SESSION: check and save these skill_lessons now.`
