# Role: fixer (fix round 2, after the verifier): importer-parity — AC13 (slider arrows draw nothing) and the site-shared-styles-off pin

You are a fresh fixer (**Opus 5.5, high**). Load `receiving-code-review` (verify each finding first), `engineering-best-practices`,
`test-driven-development`, `mutation-testing-discipline`; the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
(directly; not linked) with `references/testing-pitfalls.md` and `references/live-site-reading.md`. Read both `repeat-mistakes.md` files first
(`figma-to-bricks/references/`, `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/`). Keep to the standard at the top of the
repo CLAUDE.md "Decisions the user made". Never load bdryswi.com, B-Dry staging or any live site (every Chrome that draws a site capture or
paste launches with `SITE_OFFLINE` from `tools/lib/site-chrome.ts`; local fixture sites and libraries on 127.0.0.1 only); never write to any
WordPress site; touch nothing under `~/Downloads` (Justin's scan copy: `evidence/media-clickable/run/`). Commit to your branch only (plain
`git commit -m`, no author override, no AI lines, never CLAUDE.md); don't push; don't bump BUILD; don't edit the main folder or CLAUDE.md;
never bare `git stash`. Plain `git` in your own worktree, each command alone (never `git -C` the main folder; no git piped into another
command; scripts with the Write tool, run as `bash <file>`, no heredocs). Away rule: research first; else take your best-reasoned answer and
record it as a ruling (not yet confirmed) in the ledger and HANDOFF.

## State
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-parity/plan-approved.md` (AC1–AC22; AC22 live).
- Verifier: `/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-parity/verifier/ac.json` (read its AC13 row and
  `support/probe-slider-arrows.log`, `pictures/parity-natives/sliders-page-{1440,390}-site-paste.png`). `git checkout -B importer-parity-fix2
  b232c9de85de12d4e7ccfdd4ec1dbb7f58421bda` (base `7b7501bd`).

## Fix, each test first (RED on b232c9de, GREEN after, a one-line mutant killed)
- **AC13 (P1, false AC):** a pasted Splide slider's arrows draw as empty boxes; on the site a 40×40 chevron shows. `src/core/site/slider-look.ts`
  `drawing()` spreads the svg's captured declarations (`...own`) after `size(attrs.width)`, so the svg's bare `width: 40; height: 40` reach
  the `::before` rule and the browser drops them (0×0 on Bricks 2.4.2 and 2.3.9). Pass `own.width`/`own.height` through the same px sizing
  (any bare non-zero number gets px), so the chevron draws at the site's size. Also look at the Swiper chevron (16 px in the paste vs the site's
  44 px icon-font glyph): fix it if it is the same cause, else name it in HANDOFF. **Extend AC13's cited test under its unchanged name**
  ("a Swiper or Splide slider outside Elementor is a Bricks Slider that draws and moves as the site's") so it fails on b232c9de: compare each
  arrow's drawn `::before`/`::after` and svg size, site vs paste (a visible one 0×0 in the paste fails). Prove the cited test by name: passes
  on your head, fails on b232c9de on that new assertion, fails on a mutant restoring the old spread order.
- **Pin `site-shared-styles-off`** (passes on base, fails on head: "pastes that differ from Milestone 1's head's"): this job's changed pastes
  break an earlier story's pin. Read the pin, confirm the differences are exactly this job's intended changes (settings, natives, names), and
  update its expected set the way the pin's own instructions say (a golden made on this job's tree), test-only; say why in HANDOFF.
- Justin's B-Dry pastes must stay drawn as on base (the verifier measured 0 px moved): check base vs your head at 1440 and 390, both routes.

## Gates
`npm run check` (8G); every AC1–AC21 test by its plan name on your head (Chrome suites one at a time; before each check `/proc/loadavg`,
above ~40 unit work first); `F2B_PIN_BASE=1` pins (`site-parity-off`, `site-parity-figma`) and `site-shared-styles-off`. Ledger: a "Fixer 2"
section; HANDOFF updated. Stop at `ready-for-next-review`.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/ipf2/t1`); scripts under `~/.cache/ipf2/s/`;
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close every Chrome you start by PID (never `pkill -f` with a pattern in your
own command line); memory scopes `systemd-run --user --scope -p MemoryMax=<n>G -p MemorySwapMax=0 /bin/bash -c 'export
PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'` (B-Dry files 8G); mutants under 4G. An archive tree has no `node_modules/.bin`
(put a `tsc` wrapper first on PATH) and no repo (set `GIT_DIR` for tests reading `git show`). Use `tail -n 3`. Waits under 115 s; long runs
with `setsid --fork`, waiting on `^EXIT=`. `cancelled 1` is a timeout. SIGTERM/143/137/"Killed": check `journalctl -u earlyoom --since "-30
min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first. Write summaries as .txt/.json.

## Report (as text)
Branch, head (full SHA); per item: verified or pushed back, RED/GREEN, mutant; rulings; gates by name; `ac_status` per AC;
`skill_lessons[{skill, lesson, evidence, enforce}]` (never edit skills or memory; empty is normal), ending with: `MAIN SESSION: check and save
these skill_lessons now.`
