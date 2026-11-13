# Role: finisher (rebase + receipt): site-no-div onto the newest local main

You are a fresh finisher (**Opus 5.5, high**). Load `git-commit-rules`, `engineering-best-practices`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (rebase receipt) and the repo `CLAUDE.md` "Finish" step
1; the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`. Read both
`repeat-mistakes.md` files first. **Never load bdryswi.com** or any live site (Google Fonts only as `site:check` does); touch nothing under `~/Downloads`; never write to any WordPress site. Commit to your branch only; don't push; don't
bump BUILD; don't edit the main folder or CLAUDE.md; never bare `git stash`. Plain `git` in your own worktree, each command alone (never
`git -C` the main folder). **No ledger move** (the after-merge finisher does it).

## State
site-no-div is accepted: `ac-check.sh` READY FOR THE USER (13 of 14, AC14 live) on head `828f7dc01af443ea5bc248fac1d1106e711cfdba` (branch
`site-no-div-fix3`) on base `56b5076b5c1d665abd5bad4bcc78861739cc01e9` (Build 2026-11-12.1). Local main has moved to `7f54b0a5` (Build 2026-11-12.3):
site-fonts-match (12.2) changed `src/core/site/` (fonts.ts, convert.ts `PrepareExtra` + `prepare`, parts.ts `prepare(…)` calls and imports,
`prepareBoxes(…, carried)`), `src/web/`, `test/web/lib/site-check.ts` (`checkParts`), pins, HANDOFF; bricks-icons (12.3) changed
`src/core/understand|style|emit`, `src/ui/`, `test/browser/render.ts`, `test/fixtures/later-jobs.ts` and the file pins `media-avif-untouched` /
`site-import-figma-unchanged`, HANDOFF. This job changes `src/core/site/` heavily (lift.ts rule S, fold-boxes.ts rule N, natives.ts, labels,
structure.ts, convert.ts, parts.ts), many tests and goldens. Read `git rev-parse main` at your start. Expect source conflicts in
`convert.ts`/`parts.ts` (keep both: this job's natives step AND site-fonts-match's `fonts`/`carried` arguments — the page-named family must
reach every element this job makes, lifted Sections and folded elements included) and in the file-pin allow-lists (`later-jobs.ts`: allow
exactly `git diff --name-status <main>...HEAD -- src tools`).

## Do
1. Your own worktree: `git checkout -B site-no-div-final 828f7dc01af443ea5bc248fac1d1106e711cfdba`; `git rebase <main's SHA>`. Record each conflict
   in `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-no-div/rebase/conflicts.md` and `git range-diff` in `range-diff.txt`.
   HANDOFF/ledger only → both sides word for word, this job's section first. Any source/test conflict → keep both sides' meaning, record
   exactly what you resolved and how, and say so in the report (it then takes a full review).
2. Main's merged jobs may have named-only pins that now fail with this job's files (e.g. `media-avif-untouched`, `site-import-figma-unchanged`
   compare files under `src/`; a byte-for-byte site pin and the panel's pins): run every merged job's named-only pin that reads `src/core`,
   `src/plugin`, `src/ui` or the renderer by name with its variables on the new head; one that fails only because of this job's files is
   updated test-only (allow exactly `git diff --name-status <main>...HEAD -- <the pinned paths>`, keep every other file pinned, a stray-file
   and a one-byte mutant still fail it), RED/GREEN, one commit — and say so.
3. Rerun every agent-run AC test (AC1–AC13 by their plan names in `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-no-div/plan-approved.md`,
   with the plan's variables; AC9 at 8G) on the new head into `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-no-div/rebase/receipt-<head7>.log`
   (`HEAD=` first, each `ok` line, `EXIT=` last, skipped 0). A golden or pin that a merged job moved is regenerated only by its own tool on
   the new tree (AC11's pins with `F2B_PIN_BASE=1` against an archive of the new main) — say how many moved and why. Then `npm run check` (8G
   scope); site-fonts-match's tests (`site-fonts*`, `capture-fonts`, `site-check-*`) and every `site-*` web file, one Chrome suite at a time
   (4G; B-Dry 8G); Justin's 2026-11-11 scan (`evidence/media-clickable/run/`) on both routes: 0 Divs, and the fonts class / page-named family on
   every top element (no plain carried name in a Typography control); Figma replays byte for byte main's.
4. Report the new head, the main it sits on, and whether any source/test file conflicted or changed.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/sdfr/t1`); scripts under `~/.cache/sdfr/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`** (without it browser tests skip and exit 0); close every Chrome you start;
memory scopes `systemd-run --user --scope -p MemoryMax=<n>G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`.
Write scripts with the Write tool. Use `tail -n 3`. Waits under 115 s; long runs with `setsid --fork`, waiting on `^EXIT=`. SIGTERM/143/137/
"Killed" may be earlyoom: check first.

## Report (as text)
New head (full SHA) and its main; conflicts; any test change; receipt path and last line; gates; `skill_lessons[]`, ending with: `MAIN
SESSION: check and save these skill_lessons now.`
