# Fixer brief: web-compare, fix pass 2 (after review round 2)

**Role:** fixer (fresh Opus 5.5, xhigh). Justin is asleep under an away grant
(`~/.hermes/plans/figma-to-bricks/away-2026-10-29-website-importer.md`): never stop to ask; decide, and record rulings
(not yet confirmed) in the ledger and your report.

**Skills:** load `receiving-code-review`, `test-driven-development` and `engineering-best-practices` with the Skill
tool; read the project skill with Read: `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its
`references/testing-pitfalls.md` and `references/rendering-validation.md`.

## Start

`main` has moved to `61bb5fc` (build 29.3, header-bar), so your agent worktree starts there, not on the story. Put
your copy on the reviewed head without rebasing: `git checkout --detach bb3e9adadf70db465fe1ceb50adb41a24dc7ad6b`
then `git switch -c web-compare-fix-2` (the story's branch is `worktree-agent-ad6f27f3bfce7695f`). Fixers don't
rebase: your commits go on top of `bb3e9ad`, and the story's base stays `3ea33bb`. Approved plan:
`~/.hermes/plans/figma-to-bricks/evidence/web-compare/plan-approved.md`; the ledger is
`.superpowers/sdd/2026-10-29-web-compare/progress.md` in your copy.

## The findings

Round 2 tripped the review brake (4 P2s again, no fewer than round 1); Justin's away instruction ("keep it rolling")
was taken as **continue** (`review-2/justin.json`). The referee's lines, verbatim, are in
`~/.hermes/plans/figma-to-bricks/evidence/web-compare/review-2/referee.txt`; the record is `review-2/review.json`,
with the reviewer's probes in `review-2/logs/`, `review-2/probes/`, `review-2/scripts/`. Fix the four P2s **R2-1 …
R2-4** (R2-2 repeats R1-3 with a new fact: the page-wide SVG sprite `<use>` case). **Verify each first** with the
reviewer's probe or your own; fix the valid ones test-first (a failing same-look/different-build or count-only test,
then the fix), as general logic. Push back with evidence on any that doesn't hold. The P3s (R2-5…R2-8, and round 1's
R1-5…R1-12) are follow-ups: leave them unless a P2 fix naturally covers one, and say which.

## Rules

- Commit each fix to your branch (plain `git commit -m`, no author override, no AI lines; no CLAUDE.md staged). Batch
  ledger/record updates into the fix commits. Don't push, don't bump `BUILD`, don't edit CLAUDE.md, never bare `git
  stash`, don't rebase.
- Re-run the gates after the fixes and compare by test name with the base `3ea33bb` (the builder's receipts are in
  `evidence/web-compare/builder/gates/`, fix pass 1's in `evidence/web-compare/fixer-1/gates/`): `npm run check`, `npm run test:web` (`skipped 0`), the story's browser tests,
  and renderer byte identity if you touch the renderer. **This machine (WSL):** `CHROME_PATH` =
  `~/.hermes/plans/figma-to-bricks/evidence/web-compare/planner/scripts/chrome-cpu.sh`; long gates as a script with
  `exec > <log> 2>&1` and `trap 'echo EXIT=$?' EXIT`, waiting for `EXIT=`. If a fix changes what the live noise floor
  would show, re-take it on the plugin-made Bricks site `https://darksalmon-badger-335429.hostingersite.com/` (add
  `?f2b=<random>`, read-only GETs). **Don't load bdryswi.com** (it serves a bot-check page to automated Chrome) and never
  try to hide automation.
- General logic only; `src/` stays untouched.

## Output

- `~/.hermes/plans/figma-to-bricks/evidence/web-compare/fixer-2/answers.md`: for each of R2-1…R2-4, **fixed** (test
  name, RED log, commit) or **rejected** (the evidence), plus any P3 a fix covered. Logs and receipts beside it.
- Report (`ready-for-next-review`): branch, head SHA, the commits, the answers one line each, the gate tallies, then
  `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; `enforce` `none` or a one-line check proposal;
  empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
