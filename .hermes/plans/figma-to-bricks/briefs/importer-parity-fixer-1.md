# Role: fixer (fix round 1, after review 1): importer-parity — R1-1, R1-2, R1-3, R1-4 (+ cheap R1-5, R1-6)

You are a fresh fixer (**Opus 5.5, high**). Load `receiving-code-review` (verify each finding first), `engineering-best-practices`,
`test-driven-development`, `mutation-testing-discipline`; the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
(directly; not linked) with `references/testing-pitfalls.md` and `references/live-site-reading.md`. Read both `repeat-mistakes.md` files first
(`figma-to-bricks/references/`, `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/`). Keep to the standard at the top of the
repo CLAUDE.md "Decisions the user made" (built like a skilled Bricks builder by hand). Never load bdryswi.com, B-Dry staging or any live site
(every Chrome that draws a site capture or paste launches with `SITE_OFFLINE` from `tools/lib/site-chrome.ts`; probes use local fixture
sites on 127.0.0.1 and libraries served locally); never write to any WordPress site; touch nothing under `~/Downloads` (Justin's scan copy:
`evidence/media-clickable/run/`). Commit to your branch only (plain `git commit -m`, no author override, no AI lines, never CLAUDE.md); don't
push; don't bump BUILD; don't edit the main folder or CLAUDE.md; never bare `git stash`. Plain `git` in your own worktree, each command alone
(never `git -C` the main folder; no git piped into another command; scripts with the Write tool, run as `bash <file>`, no heredocs).
Away rule (Justin is asleep, "go with recommended"): research first; if nothing is found, take your best-reasoned answer and record it as a
ruling in the ledger and HANDOFF (not yet confirmed).

## State
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-parity/plan-approved.md` (AC1–AC22; AC22 live).
- Review 1: `/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-parity/review-1/review.json` (read it in full; the reviewer's
  probes are described there). `git checkout -B importer-parity-fix1 da538e12b50bb845cc227ff9c5dc93dc8108a60b` (base `7b7501bd`).

## Fix, each test first (RED on da538e12, GREEN after, a one-line mutant killed)
- **R1-1** (`src/web/readers/libraries.ts:98`, read by `src/core/site/elementor-slider.ts:75-79`): a non-Elementor Swiper's capture keeps
  live `swiper.params`, which hold the breakpoint in force. Keep what the site wrote (`swiper.originalParams`, its `breakpoints` included)
  and write per view / gap by Bricks' tiers from it. Test with the real Swiper library served locally (mobile-first breakpoints
  `slidesPerView: 1`, 768: 2, 1024: 3): one slide at 390, as the site; a capture from before this fix (no originalParams) keeps today's
  behaviour or stays static, named — say which.
- **R1-2** (`elementor-slider.ts:81`): `slidesPerView: "auto"` → refused (stays static, named in the notes), like the plan's other refusals.
- **R1-3** (`src/core/site/video.ts:57`): a Vimeo frame's `h` goes into Bricks' `vimeoHash` (`reference/bricks/video-schema.json:294`);
  **R1-6** with it: YouTube `rel` → `youtubeRel`, and Vimeo `background=1` mapped to Bricks' own setting if `video-schema.json` / Bricks' GPL
  code has one, else the frame stays as it was before the job (a Code element with its exact address), named.
- **R1-4** (`src/core/site/form.ts:149`, ⭐): a Form's look goes into the Form's own controls (Field, Label, Submit button: background,
  border, radius, padding, typography, placeholder, gaps) read from `reference/bricks/` and Bricks' GPL `form.php` (memory
  `bricks-source-research`: `saqib6571/bricksbuilder`), never `:nth-child` position rules; what differs per field and has no control is
  keyed by the field's own type or its own id in the Form's settings, so deleting, adding or moving a field keeps every other field's look
  and a new field takes the shared field look. Test: the reviewer's three edits on `parity-form` (delete Phone, add a field at the end, move
  Message above Email) at Bricks 2.4.2 and 2.3.9, 1440 and 390 — every remaining field keeps its box and look within 0.5 px, the added field
  draws like its kind; and at rest the paste still draws as the site (AC17). HANDOFF: replace "reordering moves looks" with what now holds.
- **R1-5** (`test/web/site-controls.test.ts:66`, test-only): replace AC8's fixed 450 ms hover wait with waiting until the computed value is
  steady (transition end or two equal reads).
- R1-7…R1-10 stay follow-ups (already recorded).

## Gates
`npm run check` (8G); every AC1–AC21 test by its plan name on the head; switch off byte for byte the base (608 pastes); Figma replays and
`dist/ui.html` byte for byte; `site-parity-bdry` (8G) and the `site-*` web files you touch, one Chrome suite at a time (4G); story pins with
`F2B_STORY_PINS=1`. Ledger: a "Fixer 1" section; HANDOFF updated. Stop at `ready-for-next-review`.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/ipf1/t1`); scripts under `~/.cache/ipf1/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`** (without it browser tests skip and exit 0); close every Chrome you start
(`pgrep -f '[u]ser-data-dir=<path>'`); memory scopes `systemd-run --user --scope -p MemoryMax=<n>G -p MemorySwapMax=0 /bin/bash -c 'export
PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`; mutants always under a 4G cap. A git-archive tree has no repo (set `GIT_DIR` inside a
runner for tests reading `git show`) and no `dist/`. Use `tail -n 3`. Waits under 115 s; long runs with `setsid --fork`, waiting on `^EXIT=`.
SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to
process'` and `journalctl --user | grep -E 'oom-kill|OOM killer'` first and rerun alone under a cap.

## Report (as text)
Branch, head (full SHA); per finding: verified or pushed back, RED/GREEN, mutant; rulings; gates by name; `ac_status` per AC;
`skill_lessons[{skill, lesson, evidence, enforce}]` (never edit skills or memory; empty is normal), ending with: `MAIN SESSION: check and save
these skill_lessons now.`
