# Role: finisher (rebase + receipt): shared-palette onto the newest local main

You are a fresh finisher (**Opus 5.5, high**). Load `git-commit-rules`, `engineering-best-practices`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (rebase receipt) and the repo `CLAUDE.md` "Finish" step
1; the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` (the
pin lines, both pin gates `F2B_PIN_BASE=1` and `F2B_STORY_PINS=1`, the browser files main added). Read both `repeat-mistakes.md` files first.
Never load any live site; run any test that captures the B-Dry stand-in or draws Justin's scan only with no outside network (`unshare -rn sh
-c 'ip link set lo up && exec unshare --user --map-user=1000 --map-group=1000 <cmd>'`; under a memory cap nest it inside `systemd-run`); never
write to any WordPress site; touch nothing under `~/Downloads`. Commit to your branch only (plain `git commit -m`, no author override, no AI
lines, never CLAUDE.md); don't push; don't bump BUILD; don't edit the main folder or CLAUDE.md; never bare `git stash`. Plain `git` in your
own worktree, each command alone (never `git -C` the main folder; no git piped into another command; files only with Write/Edit, never
heredocs; scripts run as `bash <file>`). **No ledger move.** Before every `git add` / `git rebase --continue` in a conflict, run `git diff
--check` on the resolved files: no conflict marker may be committed.

## State
- Approved plan (read-only, amended twice): `/home/justin/.hermes/plans/figma-to-bricks/evidence/shared-palette/plan-approved.md` (AC1–AC11;
  AC11 live). The job: one colour is one palette colour on a Bricks site, from both tools (the Figma plugin and the website importer).
- Accepted: `ac-check.sh` READY FOR THE USER (10/11, AC11 live) on head `f47a20d7814916a54617c2d048baf003f87b4991` (branch
  `shared-palette-fix4`), built on base `7b7501bd082ae44a99985aac4d080c9b70b67c53` — a **pre-rebase** site-shared-styles commit. Local main is
  now `fe29b65d94da2c6f4e1ecb881354b9e9b9842cef` (Build 2026-11-14.4): site-shared-styles merged as rebased commits plus its later fixes
  (palette.json, styles.txt, the `--color-<hex>` links), and bricks-icons-site, importer-app since. Files both this job (7b7501bd..f47a20d7)
  and main (7b7501bd..fe29b65d) changed: `docs/HANDOFF.md`, `reference/bricks/README.md`, `src/core/convert.ts`, `src/core/site/{convert,parts}.ts`,
  `src/plugin/{convert,main}.ts`, `src/shared/messages.ts`, `src/ui/main.ts`, `tools/lib/site-import/{after-scan,next}.ts`,
  `tools/lib/site-upload/flow.ts`, `tools/lib/site-write.ts`, `tools/replay.ts`, `tools/site-upload.ts`, `test/unit/plugin-convert.test.ts`,
  `test/unit/site-import-next.test.ts`. Read `git rev-parse main` at your start. plugin-parity (Figma route: Blocks, labels, looks) is being
  checked for merge in parallel and may land on main before you finish: if `main` moves while you work, finish on the main you started on and
  say so; the session decides.

## Do
1. Your own worktree: `git checkout -B shared-palette-final f47a20d7…`; `git rebase --onto <main's SHA> 7b7501bd082ae44a99985aac4d080c9b70b67c53`
   (only this job's 29 commits move). Record each conflict in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/shared-palette/rebase/conflicts.txt` and `git range-diff` in `range-diff.txt`.
   HANDOFF/ledger only → both sides word for word, this job's section first. **Any source/test conflict → keep both sides' meaning** (main's
   shared classes, palette.json and styles.txt writing, Icons, the importer app's commands; this job's one-colour-one-palette-colour ids and
   names on both routes), **record exactly what you resolved and how, and say so first in the report**. Where main's site-shared-styles
   already writes a palette for the importer (`--color-<hex>`, `palette.json` beside the pastes), the two must give one palette, one id per
   colour, one file: name any place they disagree, and which the approved plan's amended text says wins.
2. Pins: main's story pins (`media-avif-untouched`, `site-import-figma-unchanged` with their named base archive 56b5076b and only main's
   `src/shared/build.ts` laid over it, `--test-concurrency=1`, `F2B_STORY_PINS=1`; `site-icons-pin`, `icons-off-pin`; the `F2B_PIN_BASE=1`
   pins site-no-div-figma, site-shared-styles-figma, site-native-unchanged, site-no-div-names, site-shared-styles-off; site-shared-styles'
   AC12/AC13 pins) and this job's own: run them by name on the new head. A pin failing only because the jobs now meet is updated test-only the
   way the skill's pin lines say (exact allowances, the old oracle kept with the switch off, an on-state golden made on this tree, a stray-file
   and a one-byte mutant in a file no list allows still fail), RED/GREEN, one commit per pin — and say so. A pin failing the same way on main:
   say so and leave it.
3. Rerun every agent-run AC test (AC1–AC10 by their plan names) on the new head into
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/shared-palette/rebase/receipt-<head7>.log` (`HEAD=` first, each `ok` line, `EXIT=`
   last, skipped 0). Then `npm run check` (8G scope); each `test/browser` file main added since 7b7501bd on main's archive and on head; Figma
   replays and site pastes of the repo's fixtures against the accepted head's and main's: every difference named and explained.
4. Report the new head, the main it sits on, and whether any source/test file conflicted or changed.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/spfr/t1`); scripts under `~/.cache/spfr/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start by PID (a `user-data-dir=` pattern ends in
`/`); before each Chrome suite check `/proc/loadavg`; one Chrome suite at a time; memory scopes `systemd-run --user --scope -p MemoryMax=<n>G
-p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`. An archive tree has no `node_modules/.bin`
(a `tsc` wrapper first on PATH) and no repo (set `GIT_DIR` for tests reading `git show 2199895`). Foreground Bash moves to the background after
about 180 s: wait in bounded steps of 160 s or less from a script file. Use `tail -n 3`. `cancelled 1` is a timeout. SIGTERM/143/137/
"Killed": check earlyoom's log first. Write summaries as .txt/.json.

## Report (as text)
New head (full SHA) and its main; conflicts and how each was resolved; any test change; receipt path and last line; gates;
`skill_lessons[{skill, lesson, evidence, enforce}]` (never edit skills or memory; empty is normal), ending with: `MAIN SESSION: check and
save these skill_lessons now.`
