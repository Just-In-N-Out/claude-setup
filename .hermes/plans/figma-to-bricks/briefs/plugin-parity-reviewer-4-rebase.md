# Role: reviewer (round 4, review of the REBASE RESOLUTION onto main; report only): plugin-parity

You are a fresh reviewer (**Opus 5.5, high**). Review only: change nothing, commit nothing, start no agents. Plain `git` in your own
worktree, each command alone (never `git -C` the main folder; no git piped into another command: `git archive -o <absolute path> <sha>`,
extract separately; scripts with the Write tool, run as `bash <file>`, no heredocs). Never load any live site (every Chrome that draws a site
capture or paste with `SITE_OFFLINE`); run any test that captures the B-Dry stand-in or draws Justin's scan only with no outside network
(`unshare -rn sh -c 'ip link set lo up && exec unshare --user --map-user=1000 --map-group=1000 <cmd>'`); never write to any WordPress site;
touch nothing under `~/Downloads`. P0–P2 only for bugs a real paste or normal use hits (a scenario and a measured number); edge cases are P3.
Keep it to about 40 minutes. Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (directly) with `references/testing-pitfalls.md`; read both
`repeat-mistakes.md` files first (`figma-to-bricks/references/`, `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/`). Keep the
standard at the top of the repo CLAUDE.md "Decisions the user made" in mind.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/plugin-parity/plan-approved.md` (AC1–AC18; AC18 live).
- Accepted head `d9144e8c39c0e023c3fda60fa283a56a78e14297` on base `7b7501bd082ae44a99985aac4d080c9b70b67c53` (a pre-rebase site-shared-styles
  commit): ac-check READY FOR THE USER, reviews clean. Rebased with `git rebase --onto fe29b65d 7b7501bd` onto main
  `fe29b65d94da2c6f4e1ecb881354b9e9b9842cef` (Build 2026-11-14.4; main now also holds the Figma-route bricks-icons job, site-fonts-match,
  site-no-div, bricks-icons-site, importer-app, site-shared-styles) as branch `plugin-parity-final`, head
  **`2fe8bb52fac3d49689f580c6a504070356147dd1`**: the job's 24 commits plus 8 test-only pin commits (706574fc, 2a8f3235, 7b064b00, 73f0ae81,
  d907ea51, 29a102fa, 65e9962f, 2fe8bb52).
- Finisher's records (a head start, not proof): `/home/justin/.hermes/plans/figma-to-bricks/evidence/plugin-parity/rebase/` (`conflicts.txt`,
  `range-diff.txt`, `pins.txt`, `pins/`, `compare.json`, `check-2fe8bb52.txt`, `receipt-2fe8bb5.log`). It says a failed edit once committed
  conflict markers in `src/core/emit/elements.ts` and was repaired by amend + cherry-picks: check no marker is left anywhere and the
  repaired commits equal their intended content.

## Check hardest
1. **The source resolution.** Make the resolution tree main and the accepted head would give (`git merge-tree --write-tree fe29b65d d9144e8c`
   with base `7b7501bd`; or compare `git diff 7b7501bd..d9144e8c` against `git diff fe29b65d..<last of the 24 rebased commits>`): every
   difference outside HANDOFF and the pins is a place both jobs met. Above all `src/core/understand/understand.ts` (order: main's `iconPlan`
   count, this job's Div→Block pass, main's inline-pictures pass and `planIcons`; `nameBoxes` last), `src/core/convert.ts` (`ConvertOptions`
   `icons?`/`asBefore?`, `ConvertResult` `icons`/`shared`), `src/core/understand/ir.ts`, `src/core/emit/elements.ts` and `emit/looks.ts`:
   with "Icons as: SVG" and pictures to WordPress, does a Figma design still give exactly main's Icons (same layers, same settings, never
   marked leaf, no shared look class writing an Icon's Width/Height/Fill), while this job's Blocks, labels, looks and sticky guard work as on
   the accepted head; does the panel's Icons count stay right.
2. **The pin changes:** each allowance is exact (by name or sum), the old oracle is kept with the switch off, the on-state goldens are made on
   this tree by `tools/plugin-parity-on-goldens.ts` and can't be regenerated silently by a test run; a one-byte mutant in a file no list
   allows and an on-state-only mutant fail them. `site-media-unchanged` failing with the same 308 misses on main and head: confirm on main.
3. **Combined behaviour:** on the new head, the bricks-icons tests (`test/unit/*icon*.test.ts`, the panel's icon tests, the icon browser
   tests if any; Chrome one suite at a time, 4G) and this job's AC tests that touch the same files, on an icons fixture: 0 px moved against
   main with this job's switch off, and the Icons identical with it on.

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/plugin-parity/review-4/review.json` (round 4, scope delta, `from` the accepted head's full
SHA `d9144e8c39c0e023c3fda60fa283a56a78e14297`, full SHA `head`, a `note` saying it reviews the rebase resolution), in review-3's format
(`evidence/plugin-parity/review-3/review.json`); self-check with
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
fe29b65d94da2c6f4e1ecb881354b9e9b9842cef /home/justin/.hermes/plans/figma-to-bricks/evidence/plugin-parity` and quote its last line; if it
asks for another scope, follow it and say so. Your worktree must be at `2fe8bb52` (`git checkout --detach 2fe8bb52fac3d49689f580c6a504070356147dd1`).

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/ppr4/t1`); scripts under `~/.cache/ppr4/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start by PID (a `user-data-dir=` pattern ends in
`/`; never `pkill -f` with a pattern in your own command line); before each Chrome suite check `/proc/loadavg`; memory scopes `systemd-run
--user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'` (B-Dry files
8G). An archive tree has no `node_modules/.bin` (a `tsc` wrapper first on PATH) and no repo (set `GIT_DIR`). Use `tail -n 3`. Foreground Bash
moves to the background after about 180 s: wait in bounded steps of 160 s or less from a script file. `cancelled 1` is a timeout.
SIGTERM/143/137/"Killed": check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first. Write
summaries as .txt/.json.

## Report (as text; only review.json is written)
Findings one line each (id, P0–P3, file:line, scenario, measured) or "none"; `verdict`; `ac_status`; `skill_lessons[{skill, lesson, evidence,
enforce}]` (never edit skills or memory; empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
