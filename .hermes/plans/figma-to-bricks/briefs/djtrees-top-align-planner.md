# Role: Mini-pipeline planner — djtrees-top-align (DJ Trees designer note 5, phones)

You are a fresh `pipeline_planner` (Mini pipeline) for FigmaToBricksV2. You plan only: no product code, no tests
committed beyond the plan file, no BUILD bump, no merge, no push, never start other agents. Other agents work in
other copies of this repo at the same time (panel edge, phone menu, centred phone buttons, side art): never touch the
main folder `/home/justin/Documents/FigmaToBricksV2` (read it only), never use bare `git stash`, never revert anything
you didn't write.

## Your copy

You were started with `isolation: "worktree"`: your own copy at `main` = `origin/main` =
`1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e` (build 2026-10-31.2). Check `git rev-parse HEAD` first. Write the plan as
`docs/plans/2026-11-02-djtrees-top-align.md`, commit it on your copy's branch (plain `git commit -m`, no author
override, no AI/Co-Authored-By lines; `git diff --cached --name-only` must not list CLAUDE.md), and copy it to
`E/planner/plan.md`. Report your branch name and commit SHA.

## The request (Justin, 2026-11-02)

Item 5 of the UI designer's feedback on the DJ Trees Home page; the screenshot is a phone width (check every tier).
It must be a general plugin rule for every design of this kind, never a patch for this file (repo CLAUDE.md "Build
general logic, never one-file fixes"; no keying on names, texts, colours or this file's pixel values).

Designer's note (image `E/inputs/designer-note-5.png`, SHA256 `6d708cd4…6355`; open it). Under a paragraph and a thin
divider line, four label/value items in two columns: "BASED IN / EVANSVILLE, IN", "COVERAGE / LICENSED & INSURED"
(value on two lines), "PROTECTION / WORKERS' COMP", "EMERGENCY / 24/7 SERVICE". In the first row the left item is
centred against the taller right one, so "BASED IN" sits lower than "COVERAGE" and there's extra space above it (the
designer drew a purple line there):
> "Let's top align the "Based in Evansville" and coverage part so that there's less space above "Based in Evansville,
> Indiana." Right now I think it's center aligned; let's just have them top aligned."

## Context (repo CLAUDE.md and HANDOFF; don't reverse)

- "Boxes drawn the same height stay the same height … Boxes drawn at different heights keep their own heights at the
  top (16.3). A hugging box stretched this way keeps its words at its top." Find why this row centres instead.
- djtrees-ruled-rows (30.16, HANDOFF "DJ Trees highlights and credentials"): this may be that credentials row (items
  divided by thin line layers, `divided.ts`, `row.reflow` hiding the lines once it wraps, sides evened out). Check.
- Rows on phones: three alike cards stay one row held sideways and stack upright; grids go two per row
  (`adapt/layout.ts` `gridColumns`, `decideRow`). Here items went two per row.
- Work out the general class: items in a row/grid whose cross-axis alignment is centre in Figma (or inherited), which
  is invisible on desktop because all items are one line tall, but shows once a value wraps on narrower screens and
  the items reach different heights. The designer's intent: items that start with a label/eyebrow line up at the top.
  Decide (⭐ answers) whether the rule is "once a row's items wrap to different heights, centred items with text tops
  align to the top" or narrower/wider, and what must not change: rows Figma deliberately centres where it shows on
  desktop (an icon beside a text, a button beside a heading, a logo row), buttons' own content, desktop at the design
  width, rows of different-height boxes that Figma draws centred on purpose.

## Inputs (pinned)

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-top-align` (yours to write: `E/planner/`).
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

1. Reproduce on replay of the debug file at 390, 478, 767, 991 and the design width (`npm run snap … --sides`) and on
   the live page. Read the row's Figma structure (auto layout, counter-axis alignment, item sizing, dividers). Find the
   first decision that leaves the items centred (Figma's own `counterAxisAlignItems`, an emitter default, a rule) with
   file:line evidence.
2. Write a **short Mini plan** (`feature-dispatch/references/mini-pipeline.md` step 1): playback, cause with file:line,
   the general rule (breakpoint styles only from `src/core/adapt/rules/`, widths/row shapes from the layout plan,
   a `decision` line; if desktop changes, say why), variations and negative controls, touched files (about 1–3 source
   files; if more or a design decision, say so in `summary`), tasks, a one-line Docs & records task (HANDOFF section,
   paste check **3cn**), questions at the top with ⭐ answers. Numbered **AC1, AC2…**, each with one named test on a
   single plan line, marked **proposed**; `(live)` right after the id for an AC only Justin can check, e.g.
   `- AC5 (proposed) (live): …`. Generic fixtures, not copies of this file, plus a replay check on the debug file.
   Gates: `npm run check`, `npm run corpus`.

## Runtime

Node `/home/justin/.local/node-v22.23.3/bin/node` (its folder first in PATH for children). Chrome
`/home/justin/.cache/chrome-for-testing/chrome-f2b` (`CHROME_PATH`), headless, `--use-gl=disabled`, DISPLAY and
WAYLAND_DISPLAY cleared. Large temp files under a folder in E, not shared `/tmp`. Never change shared dependencies or
corpus config. Root handles setup sync.

## Return

`summary` (plain words), reproduced or not (replay and live, per width), cause file:line, plan path in your copy +
`E/planner/plan.md`, branch and commit SHA, AC list one line each (with any `(live)`), questions with ⭐ answers,
before screenshots in `E/planner/`, `found_else`, and `skill_lessons[{skill, lesson, evidence, enforce}]` (normally
empty; `enforce` is `none` or a one-line check proposal). Never edit skills or memory. End with
`MAIN SESSION: check and save these skill_lessons now.`
