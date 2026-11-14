# Role: finisher (rebase 2 + receipt): site-shared-styles onto the newest local main (after importer-app)

You are a fresh finisher (**Opus 5.5, high**). Load `git-commit-rules`, `engineering-best-practices`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (rebase receipt) and the repo `CLAUDE.md` "Finish" step
1; the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` (the
pin lines: "Re-pinning a merged job's…" and "When a later job breaks an earlier story's…"). Read both `repeat-mistakes.md` files first.
**Never load bdryswi.com** or any live site (every Chrome that draws a site capture or paste with `SITE_OFFLINE` from
`tools/lib/site-chrome.ts`); touch nothing under `~/Downloads` (Justin's scan copy: `evidence/media-clickable/run/`); never write to any
WordPress site. Commit to your branch only (plain `git commit -m`, no author override, no AI lines, never CLAUDE.md); don't push; don't bump
BUILD; don't edit the main folder or CLAUDE.md; never bare `git stash`. Plain `git` in your own worktree, each command alone (never `git -C`
the main folder; no git piped into another command; scripts with the Write tool, run as `bash <file>`, no heredocs). **No ledger move** (the
after-merge finisher does it).

## State
site-shared-styles' head **`f971b30691f6c00c0580793c99c8b415ba9bebe3`** (branch `site-shared-styles-rebased`, on main `392f67e2`) is reviewed
(review 4 MOVE ON) and verified (verifier 2: 14 of 15, AC15 live); its blind auditor 2 runs on that head right now (don't touch its
worktree). Local main is now **`6bca11764334673ec1fb077415a78209cdfd38a1`** (Build 2026-11-14.3, importer-app): 392f67e2 plus `docs/HANDOFF.md`,
importer-app's plan and ledger, `package.json` (one `importer` script line), `src/shared/build.ts`, `test/fixtures/importer-app.ts`,
`test/unit/media-avif-untouched.test.ts` (its pin allows that `package.json` line) and `tools/lib/site-upload/*`, `tools/site-upload.ts`, plus
the app's own new files. This job also edited `test/unit/media-avif-untouched.test.ts` (its LATER_JOBS list): expect a conflict there; keep
both sides' allowances exactly. Read `git rev-parse main` at your start.

## Do
1. Your own worktree: `git checkout -B site-shared-styles-final2 f971b30691f6c00c0580793c99c8b415ba9bebe3`; `git rebase <main's SHA>`. Record each conflict in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-shared-styles/rebase-2/conflicts.txt` and `git range-diff` in `range-diff.txt`.
   HANDOFF/ledger only → both sides word for word, this job's section first. **Any source/test conflict → keep both sides' meaning, record
   exactly what you resolved and how, and say so first in the report** (it then takes a fresh review and the full path).
2. Pins, both sides: run by name on the new head every pin bricks-icons-site added or changed (`site-icons-pin`, `media-avif-untouched`,
   `site-import-figma-unchanged` with their named base archive 56b5076b and only main's `src/shared/build.ts` laid over it,
   `--test-concurrency=1`, `F2B_STORY_PINS=1`) and this job's own pins (AC12, AC13 tests). A pin failing only because the other job's intended
   change now meets this one is updated **test-only** the way the skill's pin lines say (allow exactly `git diff --name-status <main>...HEAD --
   <the pinned paths>`; for a golden: rerun with the job's off-switch first, keep the old oracle with that switch off, add an on-state golden
   made on this tree; a stray-file and a one-byte mutant still fail), RED/GREEN, one commit per pin — and say so. Prove the combined pastes
   are right, not only re-pinned: with the shared-styles switch off, the icons fixture pastes byte for byte as main's; with it on, every Icon
   still draws (the icons look test `test/web/site-icons-look.test.ts`). If a pin fails the same way on main itself, say so and leave it.
3. Rerun every agent-run AC test (AC1–AC14 by their plan names in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-shared-styles/plan-approved.md`, every Chrome with `SITE_OFFLINE`, AC11 with the
   B-Dry stand-in and Justin's scan named, 8G) on the new head into
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-shared-styles/rebase-2/receipt-<head7>.log` (`HEAD=` first, each `ok` line,
   `EXIT=` last, skipped 0). Then `npm run check` (8G scope) and main's icon tests (`test/unit/site-icons*.test.ts`,
   `test/web/site-icons-look.test.ts`, `test/web/site-upload-icons.test.ts`) on the new head; Figma replays byte for byte main's.
4. Report the new head, the main it sits on, and whether any source/test file conflicted or changed.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/sssf2/t1`); scripts under `~/.cache/sssf2/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`** (without it browser tests skip and exit 0); close every Chrome you start by
PID (never `pkill -f` with a pattern in your own command line); before each Chrome suite check `/proc/loadavg` (above ~40: unit work first);
one Chrome suite at a time; memory scopes `systemd-run --user --scope -p MemoryMax=<n>G -p MemorySwapMax=0 /bin/bash -c 'export
PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`. An archive tree has no `node_modules/.bin` (a `tsc` wrapper first on PATH) and no repo
(set `GIT_DIR`). Use `tail -n 3`. Waits under 115 s; long runs with `setsid --fork`, waiting on `^EXIT=`. `cancelled 1` is a timeout.
SIGTERM/143/137/"Killed": check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first.
Write summaries as .txt/.json (your Write refuses .md).

## Report (as text)
New head (full SHA) and its main; conflicts; any test change; receipt path and last line; gates; `skill_lessons[{skill, lesson, evidence,
enforce}]` (never edit skills or memory; empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
