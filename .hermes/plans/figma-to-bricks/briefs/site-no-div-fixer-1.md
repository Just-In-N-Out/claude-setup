# Role: fixer (fix round 1): site-no-div — rule N's folds that move the page, and the live check's words (R1-1, R1-2, R1-3)

You are a fresh fixer (**Opus 5.5, high**). Load `receiving-code-review` (verify each finding first), `engineering-best-practices`,
`test-driven-development`, `mutation-testing-discipline`, the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
(with `references/testing-pitfalls.md`, `references/live-site-reading.md` "Code-route paste traps"). Read both `repeat-mistakes.md` files
first. Never load bdryswi.com, B-Dry staging or any live site; never write to any WordPress site; touch nothing under `~/Downloads`
(Justin's 2026-11-11 scan: read-only copies `evidence/media-clickable/run/`, `evidence/site-menu-motion/builder/bdry-capture.json`). Commit
to your branch only; don't push; don't bump BUILD; don't edit the main folder or CLAUDE.md; never bare `git stash`. Plain `git` in your own
worktree, each command alone (never `git -C` the main folder).

## Findings (review 1: `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-no-div/review-1/review.json`; probe fixtures, scripts and logs in `review-1/probes/`)
- **R1-1, P2, `src/core/site/fold-boxes.ts:77`:** rule N folds a wrapper whose element sizes itself by a percentage of it (`width: 100%`,
  `height: 100%`); after the fold the percentage resolves against the wrapper's parent. Measured on two plain scratch sites: a button 162 →
  1299 px with the words beside it squeezed to 69 px; a fixed-height hero's inner box +270 px; 0 px with `native: false`. Smallest fix:
  N4 also refuses an element that declares a percentage size (width/height/min-/max-, flex-basis) wherever it shows. Take **R1-4 (P3,
  `fold-boxes.ts:79`)** with it if it is the same refusal shape: a wrapper around a `position: sticky` element must not fold.
- **R1-2, P2, `fold-boxes.ts:105` (via `merge`, `elementor-fold.ts:266`):** when wrapper and element both have a relative font size, the
  element's replaces the wrapper's and the factor is lost (`p {1em}` in a `div {1.25em}`: 20 → 16 px; the page below shifts 273–555 px at
  390–800). Fix: refuse the fold when both are relative (or multiply them exactly; refusing is the safe default — say which and why). Check
  whether the Elementor fold's `merge` has the same hole and whether this job reached it (if it is main's own, say so and fix only if this
  job's path reaches it).
- **R1-3, P2, `docs/HANDOFF.md:13568` (also line 73, the Counts line):** the live check says the Structure panel shows Text links and the ☰
  menu's links are Text links; on Justin's 2026-11-11 scan head makes 0 Text links on both routes (the menu's 12 links are Elementor heading
  widgets and paste as Headings). Make the check and the Counts line say what B-Dry really shows (count it on the scan with head). If AC14's
  own wording in the plan needs changing, don't edit the plan: write the exact replacement text in your report for a plan amendment.

## Do
1. Your own worktree: `git checkout -B site-no-div-fix1 ae288ac8559c353d5ddd81a30cbf412eccd0a2e4` (on main `56b5076b`).
2. Each finding: verify with the reviewer's probe first (`review-1/probes/`), RED test first (fixture shapes beside the repo's own — a flex row
   > plain div > `width: 100%` button; a fixed-height box > plain div > `height: 100%` box; nested relative font sizes; a sticky in a
   wrapper), GREEN, a mutant per new guard. Keep AC5's listed refusals and every count AC1–AC13 holds: rerun AC1–AC13 by name (named-only with
   their variables), `site-no-div-plain`, `site-no-div-bdry` (8G), and re-record AC11's pins only by their own tool if rule N's change moves
   them (say how many pastes moved and why).
3. Gates: `npm run check` (8G scope); `site-*` web files the fold reaches, one Chrome suite at a time (4G); Justin's scan base vs head
   paired by site path (the reviewer's `pvp.ts`): 0 moved. Record in the ledger and HANDOFF. Stop at `ready-for-next-review` with the head SHA.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/sdf1/t1`); scripts under `~/.cache/sdf1/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`** (without it browser tests skip and exit 0); close every Chrome you start;
one Chrome suite at a time, each under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export
PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'` (B-Dry 8G). Write scripts with the Write tool. Use `tail -n 3`. Waits under 115 s;
long runs with `setsid --fork`, waiting on `^EXIT=`. SIGTERM/143/137/"Killed" may be earlyoom: check first.

## Report (as text)
Branch, head; each finding verified, RED, GREEN, mutant; any AC14 replacement text; pins moved and why; gates; `skill_lessons[]`, ending
with: `MAIN SESSION: check and save these skill_lessons now.`
