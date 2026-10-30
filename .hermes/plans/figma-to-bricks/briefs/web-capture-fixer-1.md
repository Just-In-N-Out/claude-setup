# Fixer brief: web-capture, fix pass 1 (after review round 1)

**Role:** fixer (fresh Opus 5.5, xhigh). Justin is asleep under an away grant
(`~/.hermes/plans/figma-to-bricks/away-2026-10-29-website-importer.md`): never stop to ask; decide, and record rulings
(not yet confirmed) in the ledger and your report.

**Skills:** load `receiving-code-review`, `test-driven-development` and `engineering-best-practices` with the Skill
tool; read the project skill with Read: `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its
`references/live-site-reading.md`, `references/testing-pitfalls.md`, `references/core-constraints.md`.

## Start

Your agent worktree starts at `main` (`3ea33bb`). Bring it up to the reviewed head:
`git merge --ff-only c0f0529de3a27f9314565282706365a1c6a4a720` (branch `worktree-agent-abd9b14258d5e32f2`). If
`main` moved and that fails, cherry-pick `3ea33bb..c0f0529` onto your copy instead and say so. Approved plan:
`~/.hermes/plans/figma-to-bricks/evidence/web-capture/plan-approved.md`; ledger
`.superpowers/sdd/2026-10-29-web-capture/progress.md` in your copy.

## The findings

The referee's lines, verbatim: `~/.hermes/plans/figma-to-bricks/evidence/web-capture/review-1/referee.txt`; the record
`review-1/review.json`; the reviewer's probe sites and captures in `review-1/probe/`, live reads in `review-1/live/`.
Fix the 13 P0–P2 findings **R1-1 … R1-13** (R1-1 is P1). **Verify each first** (reproduce it with the reviewer's
probe or your own), then fix the valid ones test-first: a failing test that reproduces it, then the fix, built as
general logic (any site, never keyed on one). Push back with evidence on any that doesn't hold. The P3s (R1-14…R1-19)
are follow-ups: leave them unless a P2 fix naturally covers one, and say which. For R1-12, a bot-check page must not
pass the capture check; detect it generically (no site names). For R1-13, the AC14 coverage check must be able to
fail. For R1-11, keep the site's own font file bytes the plan, spec and J4 hand-over promise, or record why not.

## Rules

- Commit each fix (or close group) to your branch (plain `git commit -m`, no author override, no AI lines; no CLAUDE.md
  staged); batch ledger/record updates into the fix commits. Don't push, don't bump `BUILD`, don't edit CLAUDE.md,
  never bare `git stash`, don't rebase.
- **bdryswi.com serves a bot-check page to automated Chrome: don't load it**, and never try to hide automation. Live
  reads only of `https://darksalmon-badger-335429.hostingersite.com/` (add `?f2b=<random>`) and
  `https://www.letsgro.ai/`, GET only. Never write to any WordPress site.
- Re-run the gates after the fixes and compare by test name with base `3ea33bb` (the builder's receipts are in
  `evidence/web-capture/builder/gates/`): typecheck (both configs), `npm run check`, `npm run test:web` (`skipped 0`
  apart from AC14's env-gated test, which you run with `F2B_WEB_CAPTURES` on the two reachable sites), the story's
  browser tests, Figma replays byte-identical (the five real files, plain and `--site`), and re-capture the two
  reachable homes. **This machine (WSL):** `CHROME_PATH` =
  `~/.hermes/plans/figma-to-bricks/evidence/web-compare/planner/scripts/chrome-cpu.sh`; long gates as a script with
  `exec > <log> 2>&1` and `trap 'echo EXIT=$?' EXIT`, waiting for `EXIT=`; fix the receipts' wrong commit labels
  (R1-19's first half) as you re-take them.
- General logic only; `src/web/` stays out of `src/core|plugin|shared|ui` imports and bundles.

## Output

- `~/.hermes/plans/figma-to-bricks/evidence/web-capture/fixer-1/answers.md`: for each of R1-1…R1-13, **fixed** (test
  name, RED log, commit) or **rejected** (the evidence), plus any P3 a fix covered. Logs and receipts beside it.
- Report (`ready-for-next-review`): branch, head SHA, the commits, the answers one line each, the gate tallies, then
  `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; `enforce` `none` or a one-line check proposal;
  empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
