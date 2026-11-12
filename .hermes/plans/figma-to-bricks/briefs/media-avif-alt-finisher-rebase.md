# Role: finisher (rebase + receipt): media-avif-alt onto the newest local main

You are a fresh finisher (**Opus 5.5, high**). Load `git-commit-rules`, `engineering-best-practices`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (rebase receipt) and the repo `CLAUDE.md` "Finish" step
1; the project skill's `references/testing-pitfalls.md`. Never load any live site; never write to any WordPress site. Commit to the branch
only; don't push; don't bump BUILD; don't edit the main folder or CLAUDE.md; never bare `git stash`. **No ledger commit.**

## State
media-avif-alt is accepted (READY FOR THE USER 15/17) on head `caf9291f681e1b6fed7862de125dddb40084da21` (branch
`media-avif-alt-fix1`) on base `02481763` (Build 2026-11-11.3). Local main has moved: read `git -C
/home/justin/Documents/FigmaToBricksV2 rev-parse main` at your start (9f75e8ac = Build 2026-11-11.7 site-sticky-header, or newer: 11.8
footer-icon-list may have landed). Those jobs touched `src/core/site/`, `src/web/`, tests and HANDOFF; this job touches `tools/lib/site-upload/`, `tools/site-upload.ts`, `tools/site-import.ts`, `test/fixtures/wp-standin.ts`, tests (many spawn `--as-served --no-ai-alt`) and HANDOFF;


## Do
1. Your own worktree: `git checkout -B media-avif-alt-final2 93e1afcf3aff45334972cfda1c70f3eabd67ed1c` (the head already rebased onto 20ce41a8; receipt-93e1afc.log passed there); `git rebase <main's SHA>`. Record each conflict in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/media-avif-alt/rebase/conflicts.md` and `range-diff.txt`. HANDOFF/ledger
   only → both sides word for word, this job's section first. Any source/test conflict → keep both sides' meaning, record it, say so.
2. Main's jobs since 02481763 (media-clickable, site-scroll-lock, site-menu-motion, site-sticky-header, maybe footer-icon-list) may have
   added `site:upload`/`site:import` spawns or pins: every spawn of the two tools in a test must pass `--as-served --no-ai-alt` unless it
   tests AVIF/AI; a byte-for-byte pin a merged job moved is compared without that job's addition, test-only, RED/GREEN, commit — and say so.
3. Rerun every agent-run AC test (AC1–AC15; story pins with `F2B_STORY_PINS=1` and `F2B_BASE_TREE` = a fresh `git archive` of the new main) on the new head into
   `…/evidence/media-avif-alt/rebase/receipt-<head7>.log` (`HEAD=` first, each `ok` line, `EXIT=` last, skipped 0).
   `npm run check` (8G scope) and the story's web files (`site-upload-avif`, `site-upload-ai-alt`, `site-upload-secrets`, `site-import-avif`, `site-upload-picture-chrome`, `media-avif-as-served`) plus `site-import-dry-run`, `site-import-yes` (4G); TMPDIR under 31 characters, one Chrome suite at a time.
4. Report the new head, the main it sits on, and whether any source/test file conflicted or changed.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/maf2/t1`); scripts under
`~/.cache/maf2/s/`; `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close every Chrome you start; memory scopes as
`systemd-run --user --scope -p MemoryMax=<n>G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`.
Write scripts with the Write tool; `git -C <absolute path>`. Use `tail -n 3`. Waits under 115 s.

## Report (as text)
New head (full SHA) and its main; conflicts; any test change; receipt path and last line; gates; `skill_lessons[]`, ending with: `MAIN
SESSION: check and save these skill_lessons now.`
