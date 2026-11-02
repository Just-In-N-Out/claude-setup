# Role: Mini-pipeline planner — djtrees-stack-lines (DJ Trees designer note 6, phones)

You are a fresh `pipeline_planner` (Mini pipeline) for FigmaToBricksV2. You plan only: no product code, no tests
committed beyond the plan file, no BUILD bump, no merge, no push, never start other agents. Other agents work in
other copies of this repo at the same time (panel edge, phone menu, centred phone buttons, side art, top-aligned
label/value items — the last one may touch the same divided-row code): never touch the main folder
`/home/justin/Documents/FigmaToBricksV2` (read it only), never use bare `git stash`, never revert anything you didn't
write.

## Your copy

You were started with `isolation: "worktree"`: your own copy at `main` = `origin/main` =
`1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e` (build 2026-10-31.2). Check `git rev-parse HEAD` first. Write the plan as
`docs/plans/2026-11-02-djtrees-stack-lines.md`, commit it on your copy's branch (plain `git commit -m`, no author
override, no AI/Co-Authored-By lines; `git diff --cached --name-only` must not list CLAUDE.md), and copy it to
`E/planner/plan.md`. Report your branch name and commit SHA.

## The request (Justin, 2026-11-02)

Item 6 of the UI designer's feedback on the DJ Trees Home page, phones. It must be a general plugin rule for every
design of this kind, never a patch for this file (repo CLAUDE.md "Build general logic, never one-file fixes"; no keying
on names, texts, colours or this file's pixel values).

Designer's note (image `E/inputs/designer-note-6.png`, SHA256 `3232bbc0…5749`; open it). On an iPhone, a dark green
section lists numbered points stacked one under another: "01 LICENSED & INSURED", "02 WORKERS' COMPENSATION",
"03 SPECIALIZED EQUIPMENT", "04 RESIDENTIAL & COMMERCIAL", "05 FREE ESTIMATES", each with a short line of text. Between
03 and 04 there is one thin horizontal line (the designer circled it in purple); there is none between the others:
> "Let's have this kind of line between each point."

## Context (repo CLAUDE.md and HANDOFF; this request changes a standing phone rule)

- Phone rule today (CLAUDE.md "Section intro on phones"): "Stacked items' divider padding evens out; a row split by
  its items' own divider lines loses the lines once it wraps, goes two per row or stacks, its sides even out and the
  space becomes its gap." djtrees-ruled-rows (30.16, HANDOFF "DJ Trees highlights and credentials"; `divided.ts`,
  `row.reflow` hiding thin line layers once the row breaks) built this on this very page ("04b Why — highlights").
- Justin's request now replaces "loses the lines" for this case: when a divided row stacks (or wraps), its points are
  still separated by a line, now running across between them. Plan it as the general rule and record it as Justin's
  2026-11-02 decision (the Docs & records task names the CLAUDE.md line it changes). Find out where today's single
  line between 03 and 04 comes from (a line between two drawn rows of a grid? a leftover divider?) and why the others
  have none.
- Decide with ⭐ answers: whether the across line uses the drawn divider's colour, thickness and opacity (⭐ yes); its
  space above and below (⭐ the gap split evenly, from the drawn padding next to the dividers); whether it applies on
  every tier where the row stacks one per line (⭐ yes) and where it goes two per row (⭐ a line between rows, none
  between the two columns? or keep vertical between columns: pick and explain); no line above the first or below the
  last point; what must not change: desktop, rows that stay on one line (vertical dividers stay), rows without drawn
  dividers (never invent lines), lists/FAQs that already draw their own lines.

## Inputs (pinned)

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-stack-lines` (yours to write: `E/planner/`).
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
   the live page. Read the section's Figma structure (rows, the divider layers, horizontal vs vertical lines). Say
   which rule hides the lines (file:line) and why one line survives.
2. Write a **short Mini plan** (`feature-dispatch/references/mini-pipeline.md` step 1): playback, cause with file:line,
   the general rule (breakpoint styles only from `src/core/adapt/rules/` with a `decision` line; no element changes
   type after it is made; if an across line needs a new element or a border on the items, say which and why, and that
   it is made at the stage that knows it), variations and negative controls, touched files (about 1–3 source files;
   if more, say so in `summary`), tasks, a one-line Docs & records task (HANDOFF section, paste check **3co**, the
   CLAUDE.md phone-rule line it changes), questions at the top with ⭐ answers. Numbered **AC1, AC2…**, each with one
   named test on a single plan line, marked **proposed**; `(live)` right after the id for an AC only Justin can check,
   e.g. `- AC5 (proposed) (live): …`. Generic fixtures, not copies of this file, plus a replay check on the debug file.
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
