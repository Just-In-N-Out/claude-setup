# Role: finisher (rebase + receipt): plugin-header-footer-ticks onto the newest local main

You are a fresh finisher (**Opus 5.5, high**). Load `git-commit-rules`, `engineering-best-practices`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (rebase receipt) and the repo `CLAUDE.md` "Finish" step
1; the project skill's `references/testing-pitfalls.md`. Never load any live site; never write to any WordPress site. Commit to the branch
only; don't push; don't bump BUILD; don't edit the main folder or CLAUDE.md; never bare `git stash`. **No ledger commit.**

## State
plugin-header-footer-ticks is accepted (READY FOR THE USER 5/6) on head `c0e04ef4a1d5b6580203e822ad36fff06ec33b83` (branch
`plugin-header-footer-ticks-build`) on base `e61c0ca0` (Build 2026-11-11.6). Local main has moved: read `git -C
/home/justin/Documents/FigmaToBricksV2 rev-parse main` at your start (9f75e8ac = Build 2026-11-11.7 site-sticky-header, or newer: 11.8
footer-icon-list may have landed). Those jobs touched `src/core/site/`, `src/web/`, tests and HANDOFF; this job touches `src/ui/`,
`src/core/normalise/site.ts`, `src/core/understand/*` notes and tests.

## Do
1. Your own worktree: `git checkout -B plugin-header-footer-ticks-final c0e04ef4…`; `git rebase <main's SHA>`. Record each conflict in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/plugin-header-footer-ticks/rebase/conflicts.md` and `range-diff.txt`. HANDOFF/ledger
   only → both sides word for word, this job's section first. Any source/test conflict → keep both sides' meaning, record it, say so.
2. If a merged job's test pins the old box words (grep the new main's `src/`, `tools/`, `test/` for "My site already has its", wrapped
   across comment lines too), update only its expected string by design, RED/GREEN, commit — and say so.
3. Rerun every agent-run AC test (AC1–AC5; AC5 by name with `F2B_BASE_TREE` = a fresh `git archive` of the new main) on the new head into
   `…/evidence/plugin-header-footer-ticks/rebase/receipt-<head7>.log` (`HEAD=` first, each `ok` line, `EXIT=` last, skipped 0).
   `npm run check` (8G scope) and `test/browser/panel.test.ts` (4G), one Chrome suite at a time.
4. Report the new head, the main it sits on, and whether any source/test file conflicted or changed.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/phf2/t1`); scripts under
`~/.cache/phf2/s/`; `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close every Chrome you start; memory scopes as
`systemd-run --user --scope -p MemoryMax=<n>G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`.
Write scripts with the Write tool; `git -C <absolute path>`. Use `tail -n 3`. Waits under 115 s.

## Report (as text)
New head (full SHA) and its main; conflicts; any test change; receipt path and last line; gates; `skill_lessons[]`, ending with: `MAIN
SESSION: check and save these skill_lessons now.`
