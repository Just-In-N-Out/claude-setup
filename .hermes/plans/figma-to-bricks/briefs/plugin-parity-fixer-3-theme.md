# Role: fixer (Justin's "Fix before merging": Theme Style beats shared button looks) + move onto the new main: plugin-parity

You are a fresh fixer (**Opus 5.5, high**). Load `receiving-code-review` (verify the finding first), `systematic-debugging` (prove the cause
from Bricks' own code before changing anything), `engineering-best-practices`, `test-driven-development`, `mutation-testing-discipline`,
`git-commit-rules`; read the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (directly) with
`references/testing-pitfalls.md`; read both `repeat-mistakes.md` files first. Keep to the standard at the top of the repo CLAUDE.md
"Decisions the user made" (a Bricks pro's build: shared classes, settings before custom CSS, looks stay true). Never load any live site; no
logins; never write to any WordPress site; touch nothing under `~/Downloads`. Commit to your branch only (plain `git commit -m`, no author
override, no AI or Co-Authored-By lines, never CLAUDE.md); don't push; don't bump BUILD; don't edit the main folder or CLAUDE.md; never bare
`git stash`. Plain `git` in your own worktree, each command alone; files only with Write/Edit, never heredocs; scripts run as `bash <file>`.
Before every `git add` / `rebase --continue` in a conflict, `git diff --check`. **Deadline:** merged by Monday 2026-11-16 09:00 on this
computer's clock; aim to be done in about 3 hours. No gold-plating.

## State
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/plugin-parity/plan-approved.md` (AC1–AC18; AC18 live).
- Accepted head `2fe8bb52fac3d49689f580c6a504070356147dd1` (branch `plugin-parity-final`) on main `fe29b65d`: ac-check READY 17/18.
- **Local main moved** to `e2fc35aaa6b7e3a662d0c3cce37ec636495a5405` (shared-palette merged, Build 2026-11-15.1: site colours, palette
  variables, `--colours`, the panel's "Colours already on the site", pins in `test/fixtures/later-jobs.ts`; it touched `src/core/convert.ts`,
  `src/plugin/convert.ts` and the panel).
- **Justin's ruling** (`evidence/plugin-parity/justin-theme-style.json`): fix before merging. The finding: auditor 3 finding 1
  (`evidence/plugin-parity/auditor-3/own-theme.log`, its probe in `auditor-3/`) and review 1 R1-1 (`review-1/review.json`): on a site whose
  Theme Style sets a Button look, Buttons this job moved onto a shared look class take the theme's background, colour, font size, padding and
  corners (Brainstorm 9/9 → 0/9, own page 7/7 → 4/7, services 30 of 46), where main kept the design's (each Button's own `#brxe-<id>` settings
  won). Review 1 read the selectors as `:root .bricks-button[class*="primary"]` (0,3,0) and `…:not(.outline)` (0,4,0) against the look's
  `.<look>.brxe-button` (0,2,0), **not checked against Bricks' source**.

## Do
1. **Move first:** `git checkout -B plugin-parity-fix3 2fe8bb52…`; `git rebase e2fc35aa…`. Record conflicts in
   `evidence/plugin-parity/fixer-3/conflicts.txt` (keep both sides' meaning: main's palette links on colours stay linked when this job moves
   a colour onto a look class). Pins that meet: test-only updates as the skill's pin lines describe (one commit each, exact allowances, the old
   oracle with the switch off, mutants). Gate the moved head before fixing.
2. **Prove the cause:** read how Bricks prints Theme Style button CSS and class/element control CSS, in Bricks 2.3.9 and 2.4.2 (the GPL Bricks
   code: memory note "Bricks source research", `reference/bricks/README.md`, the front-end CSS the test renderer loads). Name the exact theme
   selectors and their weights, and what the Button carries that they match (does `[class*="primary"]` match only Bricks' own `style`
   classes, or also a look class whose name holds "primary"? does a theme rule match every `.bricks-button`?). Write it to
   `fixer-3/cause.txt`.
3. **Fix, test first:** a Button on a shared look keeps the drawn look whatever a site's Theme Style sets for Buttons, as main's did, while
   still being one shared class you change once (the point of the job). Pick what a Bricks pro would do and Bricks allows, for example a look
   class printed so it outweighs the theme's button rules, not settings copied back onto every Button. Keep the same answer for the other
   kinds this job shares (texts, boxes) wherever a Theme Style targets them too (headings, text, links): test at least Buttons and Headings.
   - Test: extend AC8's cited test (unchanged name) with a Theme Style present: Bricks' own theme-style CSS for Buttons (primary, secondary,
     outline, sizes) and typography, made from Bricks' code, never invented. Every element keeps the same computed background, colour, font,
     padding and corners with looks as without, on the drawn set and the corpus files Brainstorm, own page, services and djtrees-home, at the
     design width and 390, Bricks 2.3.9 and 2.4.2. RED on the moved head, GREEN after; a one-line mutant (the old weight) killed.
   - Where a theme rule also beat main (hydraulics' font size 16 → 21 px on main too), say so in `fixer-3/notes.txt` and don't widen scope.
4. AC17's `styles.txt` and the HANDOFF section name the change in one line; follow-ups to `evidence/plugin-parity/follow-ups.md`.

## Gates
Both typechecks, `npm run check` (8G); every AC test by plan name on your head into `evidence/plugin-parity/fixer-3/receipt-<head7>.log`
(`HEAD=` first, `EXIT=` last); the pins by name with `F2B_PIN_BASE=1` and `F2B_STORY_PINS=1`; `npm run corpus`. Ledger: a "Fixer 3 (Theme
Style)" section. Stop at `ready-for-review`.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/ppf3/t1`); scripts under `~/.cache/ppf3/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start by PID (a `user-data-dir=` pattern ends in
`/`; never `pkill -f`/`pgrep -f` with a pattern in your own command line); before each Chrome suite check `/proc/loadavg`; one Chrome suite at
a time; memory scopes `systemd-run --user --scope -p MemoryMax=<n>G -p MemorySwapMax=0 …`. An archive tree has no `node_modules/.bin` (a `tsc`
wrapper first on PATH) and no repo (set `GIT_DIR`, `F2B_SERVICES_FILE`). Foreground Bash moves to the background after about 180 s: wait in
bounded steps of 160 s or less from a script file. Use `tail -n 3`. SIGTERM/143/137/"Killed": check
`journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first. Write summaries as .txt/.json.

## Report (as text)
New head (full SHA) and its main; conflicts; the proven cause (selectors, weights, versions); the fix and why a Bricks pro would build it so;
RED/GREEN, mutant; gates; `ac_status`; `skill_lessons[{skill, lesson, evidence, enforce}]` (never edit skills or memory; empty is normal),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
