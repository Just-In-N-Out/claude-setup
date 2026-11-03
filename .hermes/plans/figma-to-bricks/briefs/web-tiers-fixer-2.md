# Fixer brief: web-tiers, fix 2 (after the one review)

**Role:** fixer (fresh Opus 5.5, xhigh). Justin (2026-11-02): "focus on building and not too much of edge cases." Fix the
two real bugs the review found, test first, and stop. Never stop to ask; decide and record.

**Skills:** load `receiving-code-review`, `test-driven-development` and `engineering-best-practices` with the Skill tool;
read the project skill with Read: `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`,
`references/testing-pitfalls.md` (the shared Chrome lock line) and `references/live-site-reading.md` ("Mapping into the
Snapshot").

## Start

Your worktree starts at `main`. `git checkout --detach ecd7b89c7bfc9ccb1500af7ac5b1ac4dac76fd5a`, then
`git switch -c web-tiers-fix-2`. Base stays `89022ab`. Plan: `~/.hermes/plans/figma-to-bricks/evidence/web-tiers/plan-approved.md`.
Auditor report: `~/.hermes/plans/figma-to-bricks/evidence/web-tiers/auditor/ac.json` (finding F1) and its `gallery/`,
`logs/` folders; verifier 2 (clean otherwise): `…/web-tiers/verifier-2/`.

## Fix (verify on ecd7b89 first with the auditor's evidence `evidence/web-tiers/auditor/gallery/` and `logs/probe-copies-gallery-ecd7b89.log`, RED test, then the fix)

- **F1 (P2, makes AC8 false):** on the real Gallery capture (`evidence/website-importer-demo-1/hostinger/gallery/capture/`)
  the build makes a phone-only Slider of measured photos: `src/core/understand/phone.ts:51` checks only the row's own
  `src.measured`, but J1 reads the masonry box `w26` as layout NONE, so normalise infers rows (`box:w26~y0`) that carry
  no `measured` while their items do; `slider:box:w26~y0` then copies `w27`–`w29`. The live page shows those photos in
  its masonry columns (two columns at 623) with no slider. AC8 says no phone-only copy is made from a measured layer.
  Rule: skip a row whose items are measured, or any row inside a measured layer, for every phone copy (`copy:<purpose>`
  keys in `phone.ts`). Test: a capture whose box is layout NONE with inferred photo rows; no `copy:` or `slider:` key
  copies a measured layer; plus the real Gallery capture has no such key. Figma designs (no measured layers) unchanged.

**Known limit, not to fix:** the Gallery's inferred rows keep three columns on phones where the site shows 2 then 1 (F-P3-2);
it is already a follow-up.

## Rules

- Commit each fix (plain `git commit -m`, no author override, no AI lines, no CLAUDE.md staged). Don't push, don't bump
  `BUILD`, don't rebase, never bare `git stash`.
- Gates after the fixes, compared by test name with ecd7b89: both typechecks, `npm run check`,
  the files the fix touches (`test/unit/site-phone-copies.test.ts`, `site-*`, `adapt-site-tiers`), AC12's byte-identity receipt (the builder's
  script in `evidence/web-tiers/builder/`) and AC14's live test with `F2B_LIVE=1` (GET only). Don't re-run the whole test:web or test:browser suite.
- **Chrome:** every Chrome sequence under `flock ~/.cache/f2b-chrome.lock bash <steps.sh>` with a marker process
  `(exec -a 'node --test test/browser/wtiers-fix2.lock' node -e 'setTimeout(()=>{},7200e3)') &` killed at the end; back
  off if a foreign Chrome appears within 2 s. `CHROME_PATH` =
  `~/.hermes/plans/figma-to-bricks/evidence/web-capture/planner/scripts/chrome-cpu.sh`, Node
  `/home/justin/.local/node-v22.23.3/bin` first on PATH, `TMPDIR` short (`~/.cache/wtiers-fix2/tmp`). Write multi-step
  scripts with the Write tool and run `bash <file>`; git commands as separate plain calls.
- Never write to any WordPress site. Live reads only of the Hostinger site (`?f2b=`) and
  letsgro.ai, GET only; never bdryswi.com.
- Put any summary in your report, not in a separate summary file. Evidence under `evidence/web-tiers/fixer-2/`.

## Report

Branch, head SHA, commits; F1: fixed (test name, RED log, commit) or rejected (evidence); the follow-ups
written; gate tallies; then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; `enforce` `none` or a
one-line check proposal; empty is normal; never edit skills or memory), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
