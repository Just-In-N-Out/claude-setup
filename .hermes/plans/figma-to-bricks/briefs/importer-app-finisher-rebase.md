# Role: finisher (rebase + receipt): importer-app onto the newest local main

You are a fresh finisher (**Opus 5.5, high**). Load `git-commit-rules`, `engineering-best-practices`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (rebase receipt) and the repo `CLAUDE.md` "Finish" step
1; the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` (the
pin lines). Read both `repeat-mistakes.md` files first. **Never load bdryswi.com** or any live site; no logins to any real site; never write
to any WordPress site; never call alttext.ai (only `test/fixtures/wp-standin.ts`, local fixtures, a local alttext stand-in, a made-up password
and key). **Touch nothing under `~/Downloads`:** every test that clicks a download runs Chrome under a scratch HOME (the tests'
`chromeAtHome()`; under a scratch HOME use a copy of the `chrome-f2b` wrapper with absolute paths as `CHROME_PATH`). Commit to your branch
only (plain `git commit -m`, no author override, no AI lines, never CLAUDE.md); don't push; don't bump BUILD; don't edit the main folder or
CLAUDE.md; never bare `git stash`. Plain `git` in your own worktree, each command alone (never `git -C` the main folder; no git piped into
another command; scripts with the Write tool, run as `bash <file>`, no heredocs). **No ledger move** (the after-merge finisher does it).

## State
importer-app is accepted: `ac-check.sh` READY FOR THE USER (19 of 20, AC20 live) on head `7ff5f664abec6005c5cd5b083c7bd2b06bf70c46` (branch
`importer-app-fix2`) on base `7f54b0a59f88f3ca4404b6f14bba3b5abea9dcd8`. Local main is now `392f67e2a6b52c40a64acaf7d344a50c934dee26` (Build
2026-11-14.2). Files both changed: `docs/HANDOFF.md`, `tools/lib/site-upload/flow.ts`, `tools/site-upload.ts` (main's bricks-icons-site added
SVG Icon uploads with `--svg`). Read `git rev-parse main` at your start (another merge may land first).

## Do
1. Your own worktree: `git checkout -B importer-app-final 7ff5f664abec6005c5cd5b083c7bd2b06bf70c46`; `git rebase <main's SHA>`. Record each
   conflict in `/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-app/rebase/conflicts.txt` and `git range-diff` in
   `range-diff.txt`. HANDOFF/ledger only → both sides word for word, this job's section first. **Any source/test conflict → keep both sides'
   meaning (main's `--svg` drawings upload and this job's app marks and progress lines both hold), record exactly what you resolved and how,
   and say so first in the report** (it then takes a fresh review and the full path).
2. Pins: main's story pins (`media-avif-untouched`, `site-import-figma-unchanged` with their named base archive 56b5076b and only main's
   `src/shared/build.ts` laid over it, `--test-concurrency=1`, `F2B_STORY_PINS=1`; `site-icons-pin`) and this job's own: run them by name on the
   new head. A pin failing only because of this job's files is updated test-only (allow exactly `git diff --name-status <main>...HEAD -- <the
   pinned paths>`; a stray-file and a one-byte mutant in a file no list allows still fail), RED/GREEN, one commit — and say so. A pin failing
   the same way on main itself: say so and leave it.
3. Rerun every agent-run AC test (AC1–AC19 by their plan names in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-app/plan-approved.md`) on the new head into
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-app/rebase/receipt-<head7>.log` (`HEAD=` first, each `ok` line, `EXIT=`
   last, skipped 0; AC4 and AC18 flake under load: rerun alone once and say so). Then `npm run check` (8G scope), main's
   `test/web/site-upload-icons.test.ts` and `test/unit/site-upload*.test.ts` on the new head; Figma replays byte for byte main's.
4. Report the new head, the main it sits on, and whether any source/test file conflicted or changed.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/iaf/t1`); scripts under `~/.cache/iaf/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`** (without it browser tests skip and exit 0); close every Chrome and app
process you start by PID (never `pkill -f` with a pattern in your own command line; a `user-data-dir=` pattern ends in `/`); before each Chrome
suite check `/proc/loadavg` (above ~40: unit work first); one Chrome suite at a time; memory scopes `systemd-run --user --scope -p
MemoryMax=<n>G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`. An archive tree has no
`node_modules/.bin` (a `tsc` wrapper first on PATH) and no repo (set `GIT_DIR`). Foreground Bash moves to the background after about 180 s:
wait in bounded steps of 160 s or less from a script file, and finish every step before reporting. Use `tail -n 3`. `cancelled 1` is a
timeout. SIGTERM/143/137/"Killed": check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'`
first. Write summaries as .txt/.json (your Write refuses .md).

## Report (as text)
New head (full SHA) and its main; conflicts; any test change; receipt path and last line; gates; `skill_lessons[{skill, lesson, evidence,
enforce}]` (never edit skills or memory; empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
