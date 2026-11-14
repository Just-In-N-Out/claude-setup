# Role: reviewer (round 1, FULL review of the whole story; report only): importer-parity

You are a fresh reviewer who never saw the build (**Fable 5.2, high**). Review only: change nothing, commit nothing, start no agents. Plain
`git` in your own worktree, each command alone (never `git -C` the main folder; no git piped into another command: `git archive -o <file>`,
extract separately; scripts with the Write tool, no heredocs). Never load any live site; never write to any WordPress site; touch nothing under
`~/Downloads`. **Importer rule:** one review per job, P0–P2 only for bugs a real paste or normal use hits (a scenario and a measured number);
edge cases P3.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-parity/plan-approved.md` (AC1–AC22; AC22 live). The
  job: the importer's paste uses Bricks' own settings and elements like a Bricks pro would — named elements, settings before custom CSS
  (controls, Button Style), native Accordion, Slider, Video, Nav (Nestable), Form, lines; the switch off = base byte for byte; Figma
  untouched.
- Branch `importer-parity-build`, head `da538e12b50bb845cc227ff9c5dc93dc8108a60b`, base **site-shared-styles' head**
  `7b7501bd082ae44a99985aac4d080c9b70b67c53` (not merged): `git checkout --detach <head>`; review `git diff 7b7501bd...HEAD`. Builder's
  evidence: `~/.hermes/plans/figma-to-bricks/evidence/importer-parity/builder/` (a head start, not proof); HANDOFF's new top section lists the
  builder's rulings (1)–(10).
- Builder's rulings to judge, and found_else: a Slider's names left to Bricks; the job's notes last; Object fit a setting only on an Image; a
  state-changed border keeps its group as CSS; `open` kept by the capture and a flex/grid answer refuses the Accordion; a hidden sub-list
  pasted hidden; the form rules (groups directly in the form, every `button` a send control, a clipped label for an unlabelled field, no
  aria-label from a field); an ARIA list's open answers from `aria-expanded="true"`; a slider record with no captured settings stays static.
  A simple WPForms form pastes as a Bricks Form until forms-wpforms merges (Justin chose WPForms on 2026-11-13: say whether that is a real
  problem for a paste he'd make before forms-wpforms lands).
- Read the standard at the top of CLAUDE.md "Decisions the user made" (the main folder's): ask "would a Bricks pro find this logical and
  easy to change?" and report where not (the builder named: `display: contents` on a bare-link Nav's items Block and `li` wrappers; menu links
  as Blocks with tag `a` holding Rich Text; Form looks as custom CSS by `:nth-child` instead of the Form's Field/Label/Submit controls).

## Check hardest
1. Every native element against `reference/bricks/` samples or Bricks' GPL code (`saqib6571/bricksbuilder`; memory `bricks-source-research`):
   the Nav (Nestable) shape, the Form's field keys and its email action (the WordPress admin, never the old site's address), Video,
   Accordion (the content wrapper's `display:block`), Slider; a paste Bricks would refuse or rewrite is P1.
2. Looks stay true: B-Dry's saved page (both routes) and the fixtures at 1440 and 390 on Bricks 2.4.2 and 2.3.9, at rest, hovered, opened.
3. The Form: on a real B-Dry-shaped form, does a paste send mail anywhere but the admin; does reordering fields in Bricks break the looks
   in a way a normal edit hits (P2 with a measured case, else P3).
4. Switch off byte for byte the base; Figma replays and `dist/` byte for byte; every merged job's pins still hold.

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-parity/review-1/review.json` (round 1, **scope full**, from `7b7501bd`; full SHA
`head`), self-checked with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
7b7501bd082ae44a99985aac4d080c9b70b67c53 /home/justin/.hermes/plans/figma-to-bricks/evidence/importer-parity`. Load `requesting-code-review` and
`code-review-practice`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (read it directly; not linked)
with `references/testing-pitfalls.md`; read both `repeat-mistakes.md` files first.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/ipr1/t1`); scripts under `~/.cache/ipr1/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start; one Chrome suite at a time (B-Dry files 8G) under
`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`.
Use `tail -n 3`. Waits under 115 s in foreground poll chunks (never end your turn to wait). After SIGTERM/143/137/"Killed" check both
earlyoom's log and `journalctl --user | grep -E 'oom-kill|OOM killer'`.

## Report (as text; only review.json is written)
Findings one line each (id, P0–P3, file:line, scenario, measured) or "none"; each builder's ruling: holds or not; Bricks-pro notes;
`verdict`; `ac_status`; `skill_lessons[]`, ending with: `MAIN SESSION: check and save these skill_lessons now.`
