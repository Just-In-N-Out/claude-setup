# Role: finisher (rebase + receipt): plugin-parity onto the newest local main

You are a fresh finisher (**Opus 5.5, high**). Load `git-commit-rules`, `engineering-best-practices`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (rebase receipt) and the repo `CLAUDE.md` "Finish" step
1; the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` (the
pin lines). Read both `repeat-mistakes.md` files first. Never load any live site; run any test that captures the B-Dry stand-in or draws
Justin's scan only with no outside network (`unshare -rn sh -c 'ip link set lo up && exec unshare --user --map-user=1000 --map-group=1000
<cmd>'`: Node-side downloads aren't bounded by Chrome's rule yet); never write to any WordPress site; touch nothing under `~/Downloads`.
Commit to your branch only (plain `git commit -m`, no author override, no AI lines, never CLAUDE.md); don't push; don't bump BUILD; don't
edit the main folder or CLAUDE.md; never bare `git stash`. Plain `git` in your own worktree, each command alone (never `git -C` the main
folder; no git piped into another command; files only with Write/Edit, never heredocs; scripts run as `bash <file>`). **No ledger move.**

## State
plugin-parity is accepted: `ac-check.sh` READY FOR THE USER (17 of 18, AC18 live) on head `d9144e8c39c0e023c3fda60fa283a56a78e14297` (branch
`plugin-parity-fix2`), built on base `7b7501bd082ae44a99985aac4d080c9b70b67c53` — a **pre-rebase** site-shared-styles commit (fixer 1). Local
main is now `fe29b65d94da2c6f4e1ecb881354b9e9b9842cef` (Build 2026-11-14.4): site-shared-styles merged there as rebased commits (different
SHAs, plus its later fixes), and bricks-icons-site and importer-app since. Files both this job (7b7501bd..d9144e8c) and main (7b7501bd..fe29b65d)
changed: `docs/HANDOFF.md`, `src/core/convert.ts`, `src/core/emit/{elements,payload,settings}.ts`, `src/core/style/types.ts`,
`src/core/understand/{ir,understand}.ts`, `tools/replay.ts`. Read `git rev-parse main` at your start.

## Do
1. Your own worktree: `git checkout -B plugin-parity-final d9144e8c…`; `git rebase --onto <main's SHA> 7b7501bd082ae44a99985aac4d080c9b70b67c53`
   (only this job's 24 commits move; site-shared-styles' own commits are already on main). Record each conflict in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/plugin-parity/rebase/conflicts.txt` and `git range-diff` in `range-diff.txt`.
   HANDOFF/ledger only → both sides word for word, this job's section first. **Any source/test conflict → keep both sides' meaning (main's
   site-route changes and icons, this job's Figma-route Blocks, labels, looks and sticky guard), record exactly what you resolved and how, and
   say so first in the report** (it then takes a fresh review and the full path).
2. Pins: main's story pins (`media-avif-untouched`, `site-import-figma-unchanged` with their named base archive 56b5076b and only main's
   `src/shared/build.ts` laid over it, `--test-concurrency=1`, `F2B_STORY_PINS=1`; `site-icons-pin`; site-shared-styles' AC12/AC13 pins) and
   this job's own (AC13–AC15): run them by name on the new head. A pin failing only because the two jobs now meet is updated test-only the way
   the skill's pin lines say (exact allowances, the old oracle kept with the switch off, an on-state golden made on this tree, a stray-file and
   a one-byte mutant in a file no list allows still fail), RED/GREEN, one commit per pin — and say so. A pin failing the same way on main: say
   so and leave it.
3. Rerun every agent-run AC test (AC1–AC17 by their plan names in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/plugin-parity/plan-approved.md`) on the new head into
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/plugin-parity/rebase/receipt-<head7>.log` (`HEAD=` first, each `ok` line, `EXIT=`
   last, skipped 0). Then `npm run check` (8G scope); site pastes of the repo's site fixtures byte for byte main's (this job must not move a
   site paste); Figma replays as the accepted head's.
4. Report the new head, the main it sits on, and whether any source/test file conflicted or changed.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/ppfr/t1`); scripts under `~/.cache/ppfr/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start by PID (a `user-data-dir=` pattern ends in
`/`); before each Chrome suite check `/proc/loadavg`; one Chrome suite at a time; memory scopes `systemd-run --user --scope -p MemoryMax=<n>G
-p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`. An archive tree has no `node_modules/.bin`
(a `tsc` wrapper first on PATH) and no repo (set `GIT_DIR` for tests reading `git show 2199895`). Foreground Bash moves to the background after
about 180 s: wait in bounded steps of 160 s or less from a script file. Use `tail -n 3`. `cancelled 1` is a timeout. SIGTERM/143/137/
"Killed": check earlyoom's log first. Write summaries as .txt/.json.

## Report (as text)
New head (full SHA) and its main; conflicts; any test change; receipt path and last line; gates; `skill_lessons[{skill, lesson, evidence,
enforce}]` (never edit skills or memory; empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
