# Role: Mini-pipeline planner — djtrees-stack-gaps (DJ Trees designer note 9, mobile)

You are a fresh `pipeline_planner` (Mini pipeline) for FigmaToBricksV2. You plan only: no product code, no tests
committed beyond the plan file, no BUILD bump, no merge, no push, never start other agents. Other agents work in
other copies of this repo at the same time: never touch the main folder `/home/justin/Documents/FigmaToBricksV2`
(read it only), never use bare `git stash`, never revert anything you didn't write.

## Your copy

You were started with `isolation: "worktree"`: your own copy at `main` = `origin/main` =
`1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e` (build 2026-10-31.2). Check `git rev-parse HEAD` first. Write the plan as
`docs/plans/2026-11-02-djtrees-stack-gaps.md`, commit it on your copy's branch (plain `git commit -m`, no author
override, no AI/Co-Authored-By lines; `git diff --cached --name-only` must not list CLAUDE.md), and copy it to
`E/planner/plan.md`. Report your branch name and commit SHA.

## The request (Justin, 2026-11-02)

Item 9 of the UI designer's feedback on the DJ Trees Home page, **mobile**. It must be a general plugin rule for every
design of this kind, never a patch for this file (repo CLAUDE.md "Build general logic, never one-file fixes"; no keying
on names, texts, colours or this file's pixel values).

Designer's note (image `E/inputs/designer-note-9.png`, SHA256 `3a3daab2…2943`; open it). On an iPhone, under a section's
"OUR SERVICES" button, four points stack on a dark green band: a tiny label ("01 — AVAILABILITY", "02 — COVERAGE",
"03 — PROTECTION", "04 — CLIENTS") over a title ("24/7 EMERGENCY", "LICENSED & INSURED", "WORKERS' COMP",
"RESIDENTIAL & COMMERCIAL"), with large empty gaps between the points (the designer drew purple marks in each gap):
> "Let's reduce the spacing a little between each point here."

## Context (repo CLAUDE.md and HANDOFF)

- This is probably the credentials row under "08 Built for the big jobs" that djtrees-ruled-rows (30.16, HANDOFF "DJ
  Trees highlights and credentials"; `divided.ts`, `row.reflow`) handles: a desktop row divided by thin line layers,
  each item after a line padded off it. On phones the lines go and "the space becomes its gap" (CLAUDE.md "Section
  intro on phones"). Check whether the stacked gap is the drawn side padding turned into vertical space, the row's
  desktop gap, or something else, and why it is too big (file:line).
- Phone spacing rule: "one capped, whole-pixel, monotone scale: sections at most 64px top and bottom, gaps 48."
- Sibling jobs running now on the same family of rows: **djtrees-stack-lines** (note 6: a stacked divided row gets a
  thin across line between every point, replacing "loses the lines"), **djtrees-step-sides** (note 7: stacked steps
  start at the gutter, more space between a step's words and its line), **djtrees-top-align** (note 5). Your gap rule
  must agree with theirs. Read their plans if they exist when you plan:
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/<job>/planner/plan.md`; name any conflict as a question, or
  state your rule plainly so the later builder can reconcile on rebase. Check whether this row also gets note 6's
  across lines (then the gap is split around the line).
- Decide with ⭐ answers: how a stacked point gap is derived (⭐ from the drawn space between an item's words and its
  divider, not the full padding on both sides, stepped through the phone gap scale), which tiers (⭐ every tier where
  the row stacks one per line), and what must not change (desktop, rows still on one line, card grids, lists/FAQs).

## Inputs (pinned)

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-stack-gaps` (yours to write: `E/planner/`).
- Debug file (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-designer/figma-to-bricks-debug-djtrees-home.json`,
  SHA256 `1a6a27511c550bc07e885a145d2d0481988fc375693911540f75015cf49e557d`, build 2026-10-31.2, root
  "DJ Tree Service — Homepage | Evansville Final Content", 1440 wide (desktop only).
- Live page (public, read-only): `https://djtreeservice.staging.growithgro.com/home/?bricks_preview=1793635766`; read past
  LiteSpeed with `&f2b=<random>`; compare with `npm run replay` before blaming the converter.

## Skills

`engineering-best-practices` first, then `implementation-planning`, `systematic-debugging` and the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`. Read the repo `CLAUDE.md`. Mini mode:
read only the code and docs this touches.

## What to do

1. Reproduce on replay of the debug file at 390, 478, 767 and 991 (`npm run snap …`) and on the live page; measure the
   gap between points per tier. Read the row's Figma structure; find the first wrong decision (file:line).
2. Write a **short Mini plan** (`feature-dispatch/references/mini-pipeline.md` step 1): playback, cause with file:line,
   the general rule (breakpoint styles only from `src/core/adapt/rules/` with a `decision` line, sizes from
   `PageFacts`, row shapes from the layout plan), variations and negative controls, touched files (about 1–3 source
   files; if more, say so in `summary`), tasks, a one-line Docs & records task (HANDOFF section, paste check **3cr**),
   questions at the top with ⭐ answers. Numbered **AC1, AC2…**, each with one named test on a single plan line,
   marked **proposed**; `(live)` right after the id for an AC only Justin can check, e.g. `- AC5 (proposed) (live): …`.
   Generic fixtures, not copies of this file, plus a replay check on the debug file. Gates: `npm run check`,
   `npm run corpus`.

## Runtime

Node `/home/justin/.local/node-v22.23.3/bin/node` (its folder first in PATH for children). Chrome
`/home/justin/.cache/chrome-for-testing/chrome-f2b` (`CHROME_PATH`), headless, `--use-gl=disabled`, DISPLAY and
WAYLAND_DISPLAY cleared. Large temp files under a folder in E, not shared `/tmp`. Never change shared dependencies or
corpus config. Root handles setup sync.

## Return

`summary` (plain words), reproduced or not (replay and live, per width), cause file:line, plan path in your copy +
`E/planner/plan.md`, branch and commit SHA, AC list one line each (with any `(live)`), questions with ⭐ answers, how
your rule lines up with the sibling jobs, before screenshots in `E/planner/`, `found_else`, and
`skill_lessons[{skill, lesson, evidence, enforce}]` (normally empty; `enforce` is `none` or a one-line check
proposal). Never edit skills or memory. End with `MAIN SESSION: check and save these skill_lessons now.`
