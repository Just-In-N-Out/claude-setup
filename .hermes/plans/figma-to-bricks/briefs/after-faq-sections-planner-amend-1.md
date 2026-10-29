# Brief: PLANNER (amend mode) for figma-to-bricks feature "after-faq-sections"

Amend the approved plan for Justin's mid-build decision and the fix rounds' changed expectations. Don't re-plan,
don't build, don't start agents. Be quick: read the existing plan first, then only what the amendment needs; finish
within about 20 steps.

## Step 0: your copy
You start in your own throwaway worktree (`isolation: worktree`, made from `main` at dea6296). The job's head is
`7a0bfe1` on branch `worktree-agent-ab41cba73cd7765ff` (fixer 2's worktree: never write or run commands there). In
**your own** worktree run `git merge --ff-only 7a0bfe1` and check `git rev-parse HEAD`. Edit the plan there and commit
it there (plain `git commit -m "after-faq-sections: plan amendment 1 (…)"`, no author override, no AI lines, never
CLAUDE.md), and leave the worktree in place. If any of this is refused, stop with the exact message.

## Where
- The plan: `docs/plans/2026-10-29-after-faq-sections.md` in your copy. The read-only approved copy:
  `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/plan-approved.md`. The approved AC7 amendment:
  `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/ac7-amendment-approved.md`.
- Also write a copy of the amended plan to
  `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/amendment-1/plan-amended.md`. Change no other file.

## Skills
Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (planner role) and `references/rules-summary.md`;
load `implementation-planning`. Then read the amendment rules in
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` ("When Justin decides something
mid-build…", lines 21–23) and follow them exactly.

## What to fold in
1. **Justin's A1 = A (2026-10-29, "Just go with whatever suggested")**: the AC7 amendment file's two changes (at 1024
   the gap above the band is measured from the FAQ section's bottom edge on both pages; step-card title line counts
   use the real page's titles laid out in Roboto 600 at the real card's width, with the heights and tops that follow
   shifted on the same basis), the v3 FAQ mascot as a named follow-up. Put them in AC7's own wording; its test name
   stays exactly the same; no tolerance changes.
2. **Reconcile test expectations changed in the fix rounds** (ac-verification.md line 21): for every AC whose test
   gained or changed cases in fixer 1 or fixer 2 (AC1 notes word for word, AC2 seams and gaps, AC3's pinned
   base-outcome variants, at least; see `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/fixer-1/` and
   `fixer-2/`, the ledger `.superpowers/sdd/2026-10-29-after-faq-sections/progress.md` and the test files), list what
   each test now asserts and make the AC's wording match it, in one amendment. Test names on each AC line stay exactly
   as they are. Record the fixers' rulings R9–R11 (not yet confirmed) in the plan's rulings section.

## Checks before you finish
- An **Amendments** list at the top: date, each decision, each changed AC line, where the pre-amendment text lives
  (`git show 7a0bfe1:docs/plans/2026-10-29-after-faq-sections.md`), and every earlier receipt that still encodes an old
  expectation. No Amendments line starts with an AC id.
- Run `ac-check.sh`'s `ac_start`, `bad_id` and `live` regexes
  (`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`) on the approved copy and the amended
  plan, and report the AC id lists (unchanged, AC1–AC12), the live set (unchanged: AC12) and that every test-name line
  is unchanged.

## Rules
The worktree guard refuses Bash it can't prove stays in your worktree (shell variables or loops around `node`/`git`/
`sed`, heredoc then node, `git -C`, the word git inside a grep pattern or a script's text, the word `source`
anywhere): write scripts with Write and run them as one plain command. Lessons: `skill_lessons[{skill, lesson,
evidence, enforce}]` (normally empty); never edit skills or memory.

## Return
`{status: amended|stopped, worktree, branch, last_commit, copy_path, amendments[], ac_ids_old[], ac_ids_new[],
live_old[], live_new[], test_lines_unchanged: true|false, stale_receipts[], skill_lessons[]}`. End with the line
`MAIN SESSION: check and save these skill_lessons now.`
