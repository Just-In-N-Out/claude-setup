# Role: finisher (step 1: rebase onto site-scroll-lock's main): site-sticky-header

You are a fresh finisher (**Opus 5.5, high**). Load `git-commit-rules`, `engineering-best-practices`, `test-driven-development`;
read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and the repo `CLAUDE.md` "Finish" step
1; the project skill's `references/testing-pitfalls.md` (stack-move and rebase-delta lines). Never load any live site; never write
to any WordPress site; touch nothing under `~/Downloads`. Commit to the branch only; don't push; don't bump BUILD; don't edit the
main folder or CLAUDE.md; never bare `git stash`. **Don't add a ledger commit.**

## State
site-sticky-header is accepted (READY FOR THE USER 8/9) on head `c370ffa23f5157776d5c7bb710f6a4c9608b7cb6` (branch
`site-sticky-header-fix1`) on base `02481763`. Local `main` is now `11f07742` (Build 2026-11-11.5): media-clickable (11.4) and
**site-scroll-lock** (11.5), which edits the same two lines of `src/core/site/parts.ts`.

## Do
1. In your own worktree: `git checkout -B site-sticky-header-final c370ffa2…`; `git rebase 11f07742…`.
2. Resolve `parts.ts` by the plans' rule: the class-id name list **reset, lock, stay**; the root classes **lock, then stay (header
   only), then fonts**. **The trap:** sticky's `rootClasses(i)` helper sits OUTSIDE the conflict hunk — it must start with
   `lockClass(classId)`, or the lock is dropped from every part root (site-scroll-lock's AC1 fails). The proven merged file:
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-scroll-lock/builder/stack/parts.merged.ts` (compare). HANDOFF: both
   sections stay, this job's first. `test/fixtures/site-slider-base/site.code-page.sha256.json`: site-slider-unchanged compares
   **unlocked** pastes, and sticky's sums helper strips only the stay class — make the sums with the helper on the merged tree
   (it must strip the lock too, or keep main's lock-free rule: read both tests; whichever is right, prove per variant that the paste
   minus lock, stay class and note hashes to main's older sum). Keep both sides' meaning everywhere.
3. Tests on the new head (each under memory scopes): `npm run check` (8G); both jobs' Chrome files (`test/web/site-sticky-header.test.ts`,
   `test/web/site-scroll-lock.test.ts`), `site-cli`, `site-check-cli`, `site-slider-unchanged`, media-clickable's
   `test/browser/site-background-control.test.ts` (4G). Both jobs' unit files. Every site-sticky-header AC test by name.
4. Record conflicts and resolutions in `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-sticky-header/stack/` (`conflicts.md`,
   the resolved `parts.ts`, `git range-diff 02481763..c370ffa2 11f07742..HEAD`). Stop at `ready-for-review` with the new head.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/shs/t1`);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Close every Chrome **you** start (`pgrep -f
'[u]ser-data-dir=<path>'`). Write scripts with the Write tool, run as plain `bash <file>`; `git -C <absolute path>`. Use `tail -n 3`.
Waits under 115 s; long runs with `setsid --fork`, waiting on `^EXIT=`. SIGTERM/143/137/"Killed" may be earlyoom: check
`journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first.

## Report (as text)
New head (full SHA); conflicts and resolutions (the rootClasses line quoted); the sums decision with its proof; gates and both
jobs' tests; `skill_lessons[]`, ending with: `MAIN SESSION: check and save these skill_lessons now.`
