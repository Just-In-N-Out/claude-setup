# Role: Mini-pipeline planner — djtrees-step-sides (DJ Trees designer note 7, phones)

You are a fresh `pipeline_planner` (Mini pipeline) for FigmaToBricksV2. You plan only: no product code, no tests
committed beyond the plan file, no BUILD bump, no merge, no push, never start other agents. Other agents work in
other copies of this repo at the same time: never touch the main folder `/home/justin/Documents/FigmaToBricksV2`
(read it only), never use bare `git stash`, never revert anything you didn't write.

## Your copy

You were started with `isolation: "worktree"`: your own copy at `main` = `origin/main` =
`1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e` (build 2026-10-31.2). Check `git rev-parse HEAD` first. Write the plan as
`docs/plans/2026-11-02-djtrees-step-sides.md`, commit it on your copy's branch (plain `git commit -m`, no author
override, no AI/Co-Authored-By lines; `git diff --cached --name-only` must not list CLAUDE.md), and copy it to
`E/planner/plan.md`. Report your branch name and commit SHA.

## The request (Justin, 2026-11-02)

Item 7 of the UI designer's feedback on the DJ Trees Home page, phones. It must be a general plugin rule for every
design of this kind, never a patch for this file (repo CLAUDE.md "Build general logic, never one-file fixes"; no keying
on names, texts, colours or this file's pixel values).

Designer's note (image `E/inputs/designer-note-7.png`, SHA256 `b400598c…26c8`; open it). On an iPhone, three process
steps stack: a big number ("01" dark green, "02" and "03" faint grey), a small caps title ("WALKTHROUGH & ESTIMATE",
"PLANNING & EXECUTION", "CLEANUP & COMPLETION") and a paragraph, with a thin horizontal line under each step's
paragraph. Step 1 starts at the page's left gutter; steps 2 and 3 are indented to the right and stop short on the
right (the designer marked the extra space at both sides in purple), and each paragraph's last line sits almost on the
line below it:
> "Let's fix the extra spacing to the left and right of each point. Let's have all the three numbers left aligned and
> add a little more space between the text and the line."

## Context (repo CLAUDE.md and HANDOFF)

- Phone rule: "Stacked items' divider padding evens out; a row split by its items' own divider lines loses the lines
  once it wraps, goes two per row or stacks, its sides even out and the space becomes its gap." djtrees-ruled-rows
  (30.16, HANDOFF "DJ Trees highlights and credentials"; `divided.ts`, `row.reflow`) evened the sides for rows divided
  by thin line layers and rows whose items draw their own outlines. Find why this row's steps 2 and 3 keep their
  side padding (a structure 30.16 doesn't count: padding inside a nested frame, dividers drawn as the items' own
  border on one side, a line under each step, auto layout vs free placement…) with file:line evidence.
- A sibling job running now, **djtrees-stack-lines** (designer note 6), plans "a stacked divided row gets a thin across
  line between every point" (replacing "loses the lines" for that case, Justin's 2026-11-02 decision). Your job and
  that one must give one consistent rule: the space between a stacked point's words and an across line (drawn or
  made) should be the same rule in both. If `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-stack-lines/planner/plan.md`
  exists when you plan, read it and align with it (name any conflict as a question); if not, state your rule plainly
  so the later of the two builders can reconcile on rebase. Another sibling job, **djtrees-top-align** (note 5), may
  touch the same divided-row code.
- Decide with ⭐ answers: the space between a step's last text line and the line under it (⭐ the same as the space
  above that step's number, i.e. the gap split evenly, never less than the phone gap scale's smallest step), whether
  the numbers/titles/text all start at the gutter on every tier where the row stacks (⭐ yes), and what must not
  change (desktop, rows still on one line, lines the design draws inside a card).

## Inputs (pinned)

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-step-sides` (yours to write: `E/planner/`).
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
   the live page; measure each step's left/right inset and the gap from its last text line to its line. Read the
   section's Figma structure and find the first wrong decision (file:line).
2. Write a **short Mini plan** (`feature-dispatch/references/mini-pipeline.md` step 1): playback, cause with file:line,
   the general rule (breakpoint styles only from `src/core/adapt/rules/` with a `decision` line, widths from the layout
   plan, sizes from `PageFacts`), variations and negative controls, touched files (about 1–3 source files; if more,
   say so in `summary`), tasks, a one-line Docs & records task (HANDOFF section, paste check **3cp**), questions at
   the top with ⭐ answers. Numbered **AC1, AC2…**, each with one named test on a single plan line, marked
   **proposed**; `(live)` right after the id for an AC only Justin can check, e.g. `- AC5 (proposed) (live): …`.
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
your rule lines up with djtrees-stack-lines, before screenshots in `E/planner/`, `found_else`, and
`skill_lessons[{skill, lesson, evidence, enforce}]` (normally empty; `enforce` is `none` or a one-line check
proposal). Never edit skills or memory. End with `MAIN SESSION: check and save these skill_lessons now.`
