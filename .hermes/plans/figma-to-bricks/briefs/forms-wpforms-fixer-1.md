# Role: fixer (fix round 1, after review 1): forms-wpforms — R1-1, R1-2 (+ cheap R1-3, R1-6, R1-7)

You are a fresh fixer (**Opus 5.5, high**). Load `receiving-code-review` (verify each finding first), `engineering-best-practices`,
`test-driven-development`, `mutation-testing-discipline`; the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
(directly; not linked) with `references/testing-pitfalls.md`; memory note `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/wpforms-source-reference.md`.
Read both `repeat-mistakes.md` files first. Never load any live site (every Chrome that draws a site capture or paste launches with
`SITE_OFFLINE`); never write to any WordPress site (only the job's stand-ins on 127.0.0.1); touch nothing under `~/Downloads` (a test that
clicks a download runs under a scratch HOME with `.cache/chrome-for-testing` and `.cache/chrome-libs` symlinked in; Justin's scan copy:
`~/.hermes/plans/figma-to-bricks/evidence/media-clickable/run/`). Commit to your branch only (plain `git commit -m`, no author override, no AI
lines, never CLAUDE.md); don't push; don't bump BUILD; don't edit the main folder or CLAUDE.md; never bare `git stash`. Plain `git` in your own
worktree, each command alone (never `git -C` the main folder; no git piped into another command; scripts with the Write tool, run as `bash
<file>`, no heredocs, no `python3 - <<`). Away rule: research first; else take your best-reasoned answer and record it as a ruling (not yet
confirmed) in the ledger and HANDOFF. **Machine load:** before each Chrome suite check `/proc/loadavg`; above ~40 run unit work first and
wait for it to drop.

## State
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/forms-wpforms/plan-approved.md` (AC1–AC18; AC17, AC18 live).
- Review 1: `/home/justin/.hermes/plans/figma-to-bricks/evidence/forms-wpforms/review-1/review.json` (read in full; probes
  `/home/justin/.cache/fwr1/s/bdry-fieldset.ts`, `probe-desc.ts`). `git checkout -B forms-wpforms-fix1 6512f7716a6c70513500725dc4a68c7ac9a324b1`
  (base importer-parity's `b232c9de`).

## Fix, each test first (RED on 6512f771, GREEN after, a one-line mutant killed)
- **R1-1 (`src/core/site/wpform-look.ts:190` `leftOf`, `wpform-css.ts`):** a property the scan holds under two names (B-Dry's fieldset:
  the winning shorthand `border: "0 none"` beside stale 1px/solid/rgb(209,213,219) longhands from a lower-weight theme rule) is compared by
  the cascade's winner; stale longhands are never written as the site's look. Test: a fixture with a theme `fieldset{border:1px solid …}`
  under WPForms' reset; on Justin's scan both routes the paste's fieldset draws `0px none` (form height 1006.39, first-name box 290.00).
  Then **R1-6** with it: the form class drops longhands that change nothing (`font-variant-*: inherit`, `border-image-*`); report B-Dry's form
  class size before and after.
- **R1-2 (`src/core/wpforms/file.ts:21`, `wpform-read.ts:197`):** the file's `form_desc` carries `shows.descriptionText` when the site shows
  a description (WPForms prints it only when non-empty, Lite 2.0.4 `src/Frontend/Classic.php:316-323`); a test on `wpformCode()`.
- **R1-3 (`fields.ts:30`):** with mixed choice values, every choice keeps a value (its own words where the site gave none).
- **R1-7:** HANDOFF names the real class shape; the plan copy in `docs/plans/` stays the approved plan, and the `--dry-run` ruling is
  written in HANDOFF's rulings.
- R1-4, R1-5: follow-ups (already recorded).

## Gates
`npm run check` (8G); every AC1–AC16 test by its plan name on the head; `F2B_PIN_BASE=1` pins (`site-wpform-unchanged`, `plugin-forms-option`)
— if a pin moves, say why (only the form class may); the web/browser form files one at a time (4G, a scratch HOME). Ledger: a "Fixer 1"
section; HANDOFF updated. Stop at `ready-for-next-review`.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/fwf1/t1`); scripts under `~/.cache/fwf1/s/`;
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close every Chrome you start by PID (never `pkill -f` with a pattern in your
own command line); memory scopes `systemd-run --user --scope -p MemoryMax=<n>G -p MemorySwapMax=0 /bin/bash -c 'export
PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`; mutants under 4G. `cancelled 1` in a test log is a timeout, not a result. Use
`tail -n 3`. Waits under 115 s. SIGTERM/143/137/"Killed": check earlyoom first. Write summaries as .txt/.json.

## Report (as text)
Branch, head (full SHA); per finding: verified or pushed back, RED/GREEN, mutant; rulings; gates by name; `ac_status` per AC;
`skill_lessons[{skill, lesson, evidence, enforce}]` (never edit skills or memory; empty is normal), ending with: `MAIN SESSION: check and save
these skill_lessons now.`
