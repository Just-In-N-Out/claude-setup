# Fixer brief: web-compare, fix pass 3 (after review round 3)

**Role:** fixer (fresh Opus 5.5, xhigh). Justin is asleep under an away grant
(`~/.hermes/plans/figma-to-bricks/away-2026-10-29-website-importer.md`): never stop to ask; decide, and record rulings
(not yet confirmed) in the ledger and your report.

**Skills:** load `receiving-code-review`, `test-driven-development` and `engineering-best-practices` with the Skill
tool; read the project skill with Read: `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its
`references/testing-pitfalls.md` and `references/rendering-validation.md`.

## Start

`main` is at `61bb5fc` (build 29.3), so your agent worktree starts there, not on the story. Put your copy on the
reviewed head without rebasing: `git checkout --detach 334066da620bc1568faa81c2188467fae51a0cfe` then
`git switch -c web-compare-fix-3` (fix pass 2's branch is `web-compare-fix-2`). Fixers don't rebase: your commits go
on top of `334066d`, and the story's base stays `3ea33bb`. Approved plan:
`~/.hermes/plans/figma-to-bricks/evidence/web-compare/plan-approved.md`; the ledger is
`.superpowers/sdd/2026-10-29-web-compare/progress.md` in your copy.

## The finding

Round 3 (a delta review of fix pass 2) left one P2. The referee's lines, verbatim:
`~/.hermes/plans/figma-to-bricks/evidence/web-compare/review-3/referee.txt`; the record `review-3/review.json`; the
reviewer's probes and the word-by-word ground truth in `review-3/probes/`, `review-3/scripts/`, `review-3/logs/`.
Fix **R3-1** (repeats R2-4 with a new fact): a block whose own words sit on both sides of an inline-level box (the
plugin's mid-sentence `span.phone-number`, a headline-marker span, a highlighted middle word) pairs in the first pass
on partial ink, so the joined block is never used: false "narrower"/"lines" findings on same-look pages (J1, J2, J8)
and a missed 30px move of the number (J9). **Verify it first** with the reviewer's probes, fix it test-first as
general logic (both directions: the false findings go away and the real move is reported), and judge every remaining
finding against the ground truth, not section heights. R3-2 (the same move reported twice by a block and its joined
block) is P3 but lives in the same code: fix it too if your R3-1 fix naturally covers it, and say so. The other P3s
(R3-3…R3-5 and earlier rounds') stay follow-ups.

## Rules

- Commit each fix to your branch (plain `git commit -m`, no author override, no AI lines; no CLAUDE.md staged). Batch
  ledger/record updates into the fix commits. Don't push, don't bump `BUILD`, don't edit CLAUDE.md, never bare `git
  stash`, don't rebase.
- Re-run the gates after the fixes and compare by test name with the base `3ea33bb` (the builder's receipts are in
  `evidence/web-compare/builder/gates/`, fix passes 1–2 in `evidence/web-compare/fixer-1/` and `fixer-2/`): `npm run check`, `npm run test:web` (`skipped 0`), the story's browser tests,
  and renderer byte identity if you touch the renderer. **This machine (WSL):** `CHROME_PATH` =
  `~/.hermes/plans/figma-to-bricks/evidence/web-compare/planner/scripts/chrome-cpu.sh`; long gates as a script with
  `exec > <log> 2>&1` and `trap 'echo EXIT=$?' EXIT`, waiting for `EXIT=`. If a fix changes what the live noise floor
  would show, re-take it on the plugin-made Bricks site `https://darksalmon-badger-335429.hostingersite.com/` (add
  `?f2b=<random>`, read-only GETs). **Don't load bdryswi.com** (it serves a bot-check page to automated Chrome) and never
  try to hide automation.
- General logic only; `src/` stays untouched.

## Output

- `~/.hermes/plans/figma-to-bricks/evidence/web-compare/fixer-3/answers.md`: for R3-1 (and R3-2 if covered), **fixed** (test
  name, RED log, commit) or **rejected** (the evidence), plus any P3 a fix covered. Logs and receipts beside it.
- Report (`ready-for-next-review`): branch, head SHA, the commits, the answers one line each, the gate tallies, then
  `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; `enforce` `none` or a one-line check proposal;
  empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
