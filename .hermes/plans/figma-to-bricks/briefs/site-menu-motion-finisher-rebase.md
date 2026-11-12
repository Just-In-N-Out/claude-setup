# Role: finisher (step 1: rebase + receipt): site-menu-motion onto Build 2026-11-11.5

You are a fresh finisher (**Opus 5.5, high**). Load `git-commit-rules`, `engineering-best-practices`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (rebase receipt) and the repo `CLAUDE.md`
"Finish" step 1; the project skill's `references/testing-pitfalls.md` (stack-move and rebase-delta lines). Never load any live
site; never write to any WordPress site; touch nothing under `~/Downloads`. Commit to the branch only; don't push; don't bump
BUILD; don't edit the main folder or CLAUDE.md; never bare `git stash`. **Don't add a ledger commit.**

## State
site-menu-motion is accepted (READY FOR THE USER 6/7) on head `4f0882b1f7c51b52c464e6eff878518b78ba502c` (branch
`site-menu-motion-build`) on base `02481763`. Local `main` is now `11f07742` (Build 2026-11-11.5): media-clickable (11.4:
`src/core/site/background.ts`, `convert.ts`, `test/browser/render.ts`) and site-scroll-lock (11.5: `src/core/site/classes.ts`,
`convert.ts`, `parts.ts` — its `classIdsOf` and `payloadOf` lines; pin tests; `test/fixtures/site-no-revert-main.json`).
This job edits `src/core/site/parts.ts` (one line adding the slide notes), `open-paste.ts`, `slide.ts`, capture readers.

## Do
1. In your own worktree: `git checkout -B site-menu-motion-final 4f0882b1…`; `git rebase 11f07742…`. Record each conflict.
   HANDOFF/ledger only → both sides word for word, this job's section first. Any source or test conflict → keep both sides'
   meaning, record it, and say so (it then takes the full path).
2. Rerun every agent-run AC's cited test (AC1–AC6, AC6's named-only receipt with
   `F2B_SITE_SLIDE_BDRY=/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu-motion/builder/bdry-capture.json` — its pinned
   sums are main's of 02481763; if site-scroll-lock's lock class moves them, say so and prove the paste minus the lock equals the
   pinned sum) on the new head into `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu-motion/rebase/receipt-<head7>.log`
   (`HEAD=` first, each test's own `ok` line, `EXIT=` last; skipped 0). Chrome tests under `systemd-run --user --scope -p
   MemoryMax=4G -p MemorySwapMax=0`.
3. `npm run check` (8G scope); `test/web/site-scroll-lock.test.ts`, `test/web/site-slide-proof.test.ts`, `site-cli`, `site-check-cli`,
   `site-slider-unchanged` (4G): two features that pass alone can break together (the lock's `no-scroll` lines vs the drawer).
4. Record `git range-diff 02481763..4f0882b1 11f07742..HEAD` and the conflicts in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu-motion/rebase/`. Report the new head and whether any source/test
   file conflicted.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/smf/t1`);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Close every Chrome **you** start (`pgrep -f
'[u]ser-data-dir=<path>'`). Write scripts with the Write tool, run as plain `bash <file>`; `git -C <absolute path>`. Use `tail -n 3`.
Waits under 115 s; long runs with `setsid --fork`, waiting on `^EXIT=`. SIGTERM/143/137/"Killed" may be earlyoom: check
`journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first.

## Report (as text)
New head (full SHA); conflicts (files, how resolved); the receipt path and last line; gates; `skill_lessons[]`, ending with:
`MAIN SESSION: check and save these skill_lessons now.`
