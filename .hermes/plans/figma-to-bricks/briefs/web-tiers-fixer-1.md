# Fixer brief: web-tiers, fix 1 (after the one review)

**Role:** fixer (fresh Opus 5.5, xhigh). Justin (2026-11-02): "focus on building and not too much of edge cases." Fix the
two real bugs the review found, test first, and stop. Never stop to ask; decide and record.

**Skills:** load `receiving-code-review`, `test-driven-development` and `engineering-best-practices` with the Skill tool;
read the project skill with Read: `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`,
`references/testing-pitfalls.md` (the shared Chrome lock line) and `references/live-site-reading.md` ("Mapping into the
Snapshot").

## Start

Your worktree starts at `main`. `git checkout --detach 8753722c9f9c39ab356e44443774c2f5ce8aa38e`, then
`git switch -c web-tiers-fix-1`. Base stays `89022ab`. Plan: `~/.hermes/plans/figma-to-bricks/evidence/web-tiers/plan-approved.md`.
Review: `~/.hermes/plans/figma-to-bricks/evidence/web-tiers/review-1/review.json` and `…/verifier/` (probes,
mutant and J0 reports in `review-1/probes/`, live captures in `verifier/live/`).

## Fix (verify on 8753722 first with the reviewer's probes `evidence/web-tiers/review-1/probes/`, RED test, then the fix)

- **R1-1 (P2) `src/core/adapt/site/view.ts:27`:** phones scroll sideways on the captured contact page (612px wide at
  390, 788 at 478, 472 at 320; base fits). `seen()` gives a layer the range's box but leaves its children at
  design-width coordinates, so `sizing.ts` `overflowsY` (:55, used at :261) thinks content runs past every moved box and
  `site.tiers` writes a fixed `_height` where the desktop writes `_heightMin` (21 of 278 elements on contact, 104 of
  615 on home); in a Bricks Block that wraps from 767 down the overflow becomes a second column. Rule: the view sees the
  children through the same range, so `overflowsY`, `labelRoom` and `addsNoWidth` compare like with like. Tests: a
  captured column whose y position differs between ranges keeps `_heightMin` (never `_height`) at every tier; the
  contact, home and gallery captures (`evidence/website-importer-demo-1/hostinger/*/capture/` or the reviewer's
  `verifier/live/`) fit the window at 320, 390, 478 and 767 (`scrollWidth`), and AC14's live numbers don't get worse.

**P3s R1-2 (768 header menu 18px too wide, J3) and R1-3 (phone slider copy past the window at 320, J8):** don't fix.
Write each as one line in `~/.hermes/plans/figma-to-bricks/evidence/web-tiers/follow-ups.md` and HANDOFF's web-tiers "Deferred".

## Rules

- Commit each fix (plain `git commit -m`, no author override, no AI lines, no CLAUDE.md staged). Don't push, don't bump
  `BUILD`, don't rebase, never bare `git stash`.
- Gates after the fixes, compared by test name with 8753722: both typechecks, `npm run check`,
  the files the fix touches (`test/unit/adapt-site-tiers.test.ts`, `site-*`), AC12's byte-identity receipt (the builder's
  script in `evidence/web-tiers/builder/`) and AC14's live test with `F2B_LIVE=1` (GET only). Don't re-run the whole test:web or test:browser suite.
- **Chrome:** every Chrome sequence under `flock ~/.cache/f2b-chrome.lock bash <steps.sh>` with a marker process
  `(exec -a 'node --test test/browser/wtiers-fix1.lock' node -e 'setTimeout(()=>{},7200e3)') &` killed at the end; back
  off if a foreign Chrome appears within 2 s. `CHROME_PATH` =
  `~/.hermes/plans/figma-to-bricks/evidence/web-capture/planner/scripts/chrome-cpu.sh`, Node
  `/home/justin/.local/node-v22.23.3/bin` first on PATH, `TMPDIR` short (`~/.cache/wtiers-fix1/tmp`). Write multi-step
  scripts with the Write tool and run `bash <file>`; git commands as separate plain calls.
- Never write to any WordPress site. Live reads only of the Hostinger site (`?f2b=`) and
  letsgro.ai, GET only; never bdryswi.com.
- Put any summary in your report, not in a separate summary file. Evidence under `evidence/web-tiers/fixer-1/`.

## Report

Branch, head SHA, commits; R1-1: fixed (test name, RED log, commit) or rejected (evidence); the follow-ups
written; gate tallies; then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; `enforce` `none` or a
one-line check proposal; empty is normal; never edit skills or memory), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
