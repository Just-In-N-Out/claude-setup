# Role: reviewer (round 1, FULL review of the whole story; report only): site-shared-styles

You are a fresh reviewer who never saw the build (**Fable 5.2, high**). Review only: change nothing, commit nothing, start no agents. Plain
`git` in your own worktree, each command alone (never `git -C` the main folder; no git piped into another command: `git archive -o <file>`
then extract separately; write scripts with the Write tool, no heredocs). Never load bdryswi.com, B-Dry staging or any live site; never write
to any WordPress site; touch nothing under `~/Downloads` (Justin's scan copy: `evidence/media-clickable/run/`). **Importer rule (Justin,
2026-11-02):** one review per job, P0–P2 only for bugs a real site or normal use hits, each with a concrete scenario and a measured number;
edge cases are P3 (follow-ups).

## Inputs
- Approved plan (read-only, amendment 1): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-shared-styles/plan-approved.md` (AC1–AC15;
  AC15 live). The job (Justin: classes for text, buttons, sections and spacing; same-looking buttons share a class, different ones get their
  own; the Bricks palette; text becomes Rich Text): words that draw alike share a text class, alike buttons a button class, three-plus alike
  boxes a box and a layout class; every solid colour a palette colour (`palette.json`, `var(--color-…)` with the colour as fallback); words are
  Rich Text, a Heading or a Button's own words; switch off = byte for byte as before; Figma designs byte for byte.
- Branch `site-shared-styles-build`, head `e124dcdacdd9521246de4bf375424680a875535a`, base **site-no-div's head**
  `d915f7dc83e5edb14b7f6006e78714a92e9fac1c` (not merged yet; it sits on main 56b5076b): `git checkout --detach e124dcda…`; review
  `git diff d915f7dc...e124dcda` (15 commits).
- Builder's rulings beyond the plan (judge each): R2 values by what the element draws (100%/1.2em share their px size's class; a menu link
  with `inherited: {}` takes its own absolute values); R5 states (the own class drops state-only properties; the reduced-motion block moves
  with the states); other subjects' tests convert with `palette: false`; notes-pin adjustments; `colours.ts` = the planner's plus `seeThrough`;
  media-clickable's Background step inside `class-source.ts` `fromStates`; a site-no-div fix in `lift.ts` `plainParts` (a section root that is
  words stays words).

## Check hardest
1. Real pastes: Justin's scan and the B-Dry stand-in on both routes in Chrome on Bricks 2.4.2 and 2.3.9 at 1440 and 390, switch off vs on: any
   element that draws differently (size, weight, colour, hover, focus, line height); a shared class that out-weighs or is out-weighed by an
   element's own class or Bricks' control CSS (`.cls.brxe-<el>`); two elements that look alike at one width but not another sharing a class.
2. The palette: `palette.json` importable as Bricks' Colors (shape from `reference/bricks/`, the `id`/`raw`/`light` form), ids stable across two
   pages of one site, every `var(--color-…)` with its fallback, nothing colour-like (gradients, see-through, keyframes) wrongly linked; what
   happens when Justin pastes without importing the palette.
3. Every merged job still holds: scroll-lock, sticky header, menu motion, media-clickable's Background image settings (now via `fromStates`),
   footer one-name sides, site-native-structure's natives and labels, site-no-div's no-Div and rule N, site-fonts-match's page-named families
   (main has it at 6cd6154e; this branch doesn't yet — note where they will meet).
4. Test changes to other subjects (`palette: false` call sites, notes pins): no assertion weakened.

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-shared-styles/review-1/review.json` (round 1, **scope full**, from `d915f7dc`; full
SHA `head`), self-checked with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
d915f7dc83e5edb14b7f6006e78714a92e9fac1c /home/justin/.hermes/plans/figma-to-bricks/evidence/site-shared-styles`. Load `requesting-code-review` and
`code-review-practice`; read the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with
`references/testing-pitfalls.md` and `references/live-site-reading.md` "Code-route paste traps"; `reference/bricks/README.md`; read both
`repeat-mistakes.md` files first.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/ssr1/t1`); scripts under `~/.cache/ssr1/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`** (without it browser tests skip and exit 0); close every Chrome you start;
one Chrome suite at a time, each under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export
PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'` (B-Dry 8G). Use `tail -n 3`. Waits under 115 s in foreground poll chunks (never end
your turn to wait). SIGTERM/143/137/"Killed" may be earlyoom: check first.

## Report (as text; only review.json is written)
Findings one line each (id, P0–P3, file:line, scenario, measured) or "none"; each builder's ruling: holds or not; `verdict`; `ac_status`;
`skill_lessons[]`, ending with: `MAIN SESSION: check and save these skill_lessons now.`
