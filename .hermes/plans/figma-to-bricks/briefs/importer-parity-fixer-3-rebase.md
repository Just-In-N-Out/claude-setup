# Role: fixer (move onto main + the verifier's gate fix): importer-parity

You are a fresh fixer (**Opus 5.5, high**). Load `receiving-code-review`, `engineering-best-practices`, `test-driven-development`,
`git-commit-rules`; the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (directly) with
`references/testing-pitfalls.md` (the pin lines, the two shared-class lists line) and `references/live-site-reading.md`. Read both
`repeat-mistakes.md` files first. Keep to the standard at the top of the repo CLAUDE.md "Decisions the user made". **Never load any live site**
(every Chrome that draws a site capture or paste with `SITE_OFFLINE`); **run any test that captures the B-Dry stand-in or draws Justin's scan
only with no outside network** (`unshare -rn sh -c 'ip link set lo up && exec unshare --user --map-user=1000 --map-group=1000 <cmd>'`:
`captureSite`'s Node-side downloads aren't bounded by Chrome's rule yet; the stand-in names font files on growithgro1.wpcomstaging.com); never
write to any WordPress site; touch nothing under `~/Downloads` (Justin's scan copy: `evidence/media-clickable/run/`). Commit to your branch
only (plain `git commit -m`, no author override, no AI lines, never CLAUDE.md); don't push; don't bump BUILD; don't edit the main folder or
CLAUDE.md; never bare `git stash`. Plain `git` in your own worktree, each command alone (never `git -C` the main folder; no git piped into
another command; files only with Write/Edit, never heredocs; scripts run as `bash <file>`). **No ledger move.**

## State
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-parity/plan-approved.md` (AC1–AC22; AC22 live).
- Head `745578889c56baf81a58110770a5513b6c67c7d4` (branch `importer-parity-fix2`), built on base `7b7501bd082ae44a99985aac4d080c9b70b67c53`
  (a **pre-rebase** site-shared-styles commit). Review 3 MOVE ON; verifier 2 (`evidence/importer-parity/verifier-2/ac.json`): AC1–AC21 proven,
  verdict not clean on one gate (below).
- Local main is now `fe29b65d94da2c6f4e1ecb881354b9e9b9842cef` (Build 2026-11-14.4): site-shared-styles merged as rebased commits plus its later
  fixes, and bricks-icons-site (Icons from a site's own SVGs, `src/core/site/icons.ts`) and importer-app since. Files both changed include
  `src/core/site/{class-source,convert,kinds,parts,structure}.ts` and `src/core/snapshot/web.ts`.

## Do
1. **Move:** `git checkout -B importer-parity-final 74557888…`; `git rebase --onto fe29b65d… 7b7501bd082ae44a99985aac4d080c9b70b67c53` (only
   this job's 31 commits move). Record each conflict in `evidence/importer-parity/rebase/conflicts.txt` and `git range-diff` in
   `range-diff.txt`. Keep both sides' meaning in every conflict: main's shared classes, palette links and Icons (an Icon's class writes no
   Bricks control; `class-source.ts` `fromStates`) and this job's names, settings, Style: Primary and native elements (Divider, Accordion,
   Nav, Video, Form, Slider). Where this job's new settings meet main's shared-look classes, a shared class still has one writer per property
   and draws as the switch off (site-shared-styles' AC4 and AC7 tests). Record exactly what you resolved and how.
2. **The verifier's gate fix (P2, test-only), test first:** `test/web/site-page-bdry.test.ts` "no class of the saved page's pastes is a bare
   name" fails with `site-accordion` on the plain route (passes on base): `test/web/lib/class-names.ts` accepts `STEP_SHARED` (site-accordion,
   site-slider-<4>) only with `elementor`, while `test/unit/lib/site-parity-invariants.ts` `FIXED` already lists them. Make both read **one**
   exported list (in `test/unit/lib/` or `test/web/lib/`), accepted on both routes, with a unit test in `npm run check` that a class in one
   list only fails; check the `sharedNames` comparison too. RED on 74557888, GREEN after. Run `site-page-bdry` with
   `F2B_CODE_PROOF_BDRY`/`F2B_CODE_PROOF_CAPTURE` inside the no-network namespace.
3. **Pins:** main's story pins and its newer pins (`site-icons-pin`, site-shared-styles' AC12/AC13, `media-avif-untouched`,
   `site-import-figma-unchanged` with their named base archive 56b5076b and only main's `src/shared/build.ts` laid over it,
   `--test-concurrency=1`, `F2B_STORY_PINS=1`) and this job's AC19/AC20: a pin failing only because the jobs now meet is updated test-only the
   way the skill's pin lines say (old oracle kept with the switch off, an on-state golden made on this tree; a stray-file and a one-byte
   mutant in a file no list allows still fail), one commit per pin — say so.
4. **Receipt:** every agent-run AC test (AC1–AC21 by plan name, B-Dry-named ones inside the no-network namespace) on the new head into
   `evidence/importer-parity/rebase/receipt-<head7>.log` (`HEAD=` first, `ok` lines, `EXIT=` last, skipped 0); `npm run check` (8G); main's icon
   and shared-styles tests; Justin's scan through `npm run site` both routes drawn at 1440 and 390 against main's: every move named and
   explained by this job's ACs.
Stop at `ready-for-review`.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/ipf3/t1`); scripts under `~/.cache/ipf3/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start by PID (a `user-data-dir=` pattern ends in
`/`; sweep `user-data-dir=$TMPDIR/f2b-chrome-` after each Chrome step); before each Chrome suite check `/proc/loadavg`; one Chrome suite at a
time; memory scopes `systemd-run --user --scope -p MemoryMax=<n>G -p MemorySwapMax=0 /bin/bash -c 'export
PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'` (B-Dry files 8G). An archive tree has no `node_modules/.bin` (a `tsc` wrapper first on
PATH) and no repo (set `GIT_DIR`). Foreground Bash moves to the background after about 180 s: wait in bounded steps of 160 s or less from a
script file. Use `tail -n 3`. `cancelled 1` is a timeout. SIGTERM/143/137/"Killed": check earlyoom's log first. Write summaries as .txt/.json.

## Report (as text)
New head (full SHA) and its main; conflicts and how each was resolved; the gate fix RED/GREEN; any pin change; receipt path and last line;
gates; `skill_lessons[{skill, lesson, evidence, enforce}]` (never edit skills or memory; empty is normal), ending with: `MAIN SESSION: check and
save these skill_lessons now.`
