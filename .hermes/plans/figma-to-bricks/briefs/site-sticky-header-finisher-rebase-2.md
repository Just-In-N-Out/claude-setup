# Role: finisher (rebase + receipt): site-sticky-header onto the newest local main

You are a fresh finisher (**Opus 5.5, high**). Load `git-commit-rules`, `engineering-best-practices`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (rebase receipt) and the repo `CLAUDE.md` "Finish"
step 1; the project skill's `references/testing-pitfalls.md` (stack-move, rebase-delta, sibling-class lines). Never load any live site;
never write to any WordPress site; touch nothing under `~/Downloads`. Commit to the branch only; don't push; don't bump BUILD; don't edit
the main folder or CLAUDE.md; never bare `git stash`. **No ledger commit.**

## State
site-sticky-header is accepted (READY FOR THE USER 8/9) on head `dac22907cfea2d79df9d27ef794e3521eb217e97` (branch
`site-sticky-header-final`) on base `11f07742` (Build 2026-11-11.5). Local `main` has moved: read `git -C
/home/justin/Documents/FigmaToBricksV2 rev-parse main` at your start (e61c0ca0 = Build 2026-11-11.6 site-menu-motion, or a newer
11.7 = footer-icon-list if it landed). site-menu-motion edited `src/core/site/parts.ts` (the `slideNotes` destructure and push, lines
~133–142), near this job's `rootClasses`/notes lines.

## Do
1. Your own worktree: `git checkout -B site-sticky-header-final3 dac22907…`; `git rebase <main's SHA>`. Record each conflict
   (`evidence/site-sticky-header/stack2/conflicts.md`, `range-diff.txt`). HANDOFF/ledger only → both sides word for word, this job's
   section first. A source/test conflict → keep both sides' meaning (every part root: lock first; header: lock, stay, fonts; the
   slide notes and the stay note both pushed), record it, and say so.
2. A pin that a merged feature moved by design (e.g. a byte-for-byte pin now holding the slide's marker or notes): change only the
   test to compare without the other job's addition, as site-scroll-lock's `unlockedParts` does, with RED/GREEN and a mutant; commit.
3. Rerun every agent-run AC test (AC1–AC8, by name; AC8's sums helper with `--base <main's SHA>` must show 8/8 equal to main's sums
   minus lock, class and note) on the new head into
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-sticky-header/rebase/receipt-<head7>.log` (`HEAD=` first, each `ok` line,
   `EXIT=` last; skipped 0; Chrome under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`, **one Chrome suite at a
   time**). `npm run check` (8G scope); `test/web/site-scroll-lock.test.ts` and `test/web/site-slide-proof.test.ts` too.
4. Report the new head and whether any source or test file conflicted or changed.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/shr2/t1`);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close every Chrome you start (`pgrep -f '[u]ser-data-dir=<path>'`);
write scripts with the Write tool, run as `bash <file>`; `git -C <absolute path>`. Use `tail -n 3`. Waits under 115 s.
SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to
process'` first.

## Report (as text)
New head (full SHA) and the main it sits on; conflicts; any test change; receipt path and last line; gates; `skill_lessons[]`, ending
with: `MAIN SESSION: check and save these skill_lessons now.`
