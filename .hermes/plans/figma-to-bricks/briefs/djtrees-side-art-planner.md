# Role: Mini-pipeline planner — djtrees-side-art (DJ Trees designer note 4, mobile)

You are a fresh `pipeline_planner` (Mini pipeline) for FigmaToBricksV2. You plan only: no product code, no tests
committed beyond the plan file, no BUILD bump, no merge, no push, never start other agents. Other agents work in
other copies of this repo at the same time (panel edge, phone menu, centred phone buttons): never touch the main
folder `/home/justin/Documents/FigmaToBricksV2` (read it only), never use bare `git stash`, never revert anything you
didn't write.

## Your copy

You were started with `isolation: "worktree"`: your own copy at `main` = `origin/main` =
`1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e` (build 2026-10-31.2). Check `git rev-parse HEAD` first. Write the plan as
`docs/plans/2026-11-02-djtrees-side-art.md`, commit it on your copy's branch (plain `git commit -m`, no author
override, no AI/Co-Authored-By lines; `git diff --cached --name-only` must not list CLAUDE.md), and copy it to
`E/planner/plan.md`. Report your branch name and commit SHA.

## The request (Justin, 2026-11-02)

Item 4 of the UI designer's feedback on the DJ Trees Home page, **mobile**. Justin: "remember general rule": a
general plugin rule for every design of this kind, never a patch for this file (repo CLAUDE.md "Build general logic,
never one-file fixes"; no keying on layer names, texts, colours or this file's pixel values).

Designer's note (image `E/inputs/designer-note-4.png`, SHA256 `9b065af0…9571`; open it). On an iPhone, the section
with the eyebrow "WHAT WE DO", the heading "MORE THAN TREE CARE." and a paragraph starts with a tall empty space (the
designer drew a purple line through it), while a large faint grey tree drawing sits at the top right; the words only
begin under the tree's height:
> "On this section, let's reduce the spacing on the top and maybe reduce the size of the tree and have it beside the
> header."

("header" here is the section's heading, not the site header.)

## Context (repo CLAUDE.md; don't reverse)

- Phones are generated from a desktop-only design; desktop stays exact at the design width.
- Free-floating designs on phones (2026-10-07): big outline words, heading pieces as pictures, landscape drawings
  shrink to the width at their edge, all-over patterns keep covering, "a sideways label beside a heading turns
  upright". Layers placed on a section (`composition.phone` held in HANDOFF M2d–M2e: "decorative shapes hidden" was
  never built). Section rhythm (28.5): sections drawn without auto layout or at a fixed height keep their own spacing;
  "Space frozen into a fixed-height box" is a known open bug (outside FAQs). Spacing: "sections at most 64px top and
  bottom" on phones. Find which of these the tree and the gap come from.
- Work out the general class: a decorative drawing (a vector or a see-through picture, no words, not a photo the
  content needs) placed beside a section's intro/heading on desktop, which on phones today either stacks above the
  words, keeps its desktop height as empty space, or pushes the words down. The designer's intent: the art shrinks
  and sits beside the heading (to its right, as on desktop), and the section's top space is the normal phone section
  space. Say what happens when there's no room beside the heading (very narrow phones, a long heading), when the art
  is on the left, when it is a photo rather than decoration, and what must not change (desktop, tablets if they're
  fine, art that is a background pattern, hero art, drawn phone designs). Give ⭐ answers for any choice (how small
  the art gets, e.g. matching the heading's height; behind the words faintly or beside them).

## Inputs (pinned)

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-side-art` (yours to write: `E/planner/`).
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
   the live page. Read the section's Figma structure (auto layout or free placement, the tree's box, constraints,
   fills, its place relative to the heading). Say where the empty space comes from (the tree's own height, a frozen
   section height, padding, a min-height) with file:line evidence for the first wrong decision.
2. Write a **short Mini plan** (`feature-dispatch/references/mini-pipeline.md` step 1): playback, cause with file:line,
   the general rule (rules write breakpoint styles only in `src/core/adapt/rules/`, read sizes from `PageFacts` and
   widths from the layout plan, a `decision` line), variations and negative controls, touched files (about 1–3 source
   files; if more or a design decision, say so in `summary`), tasks, a one-line Docs & records task (HANDOFF section,
   paste check **3cm**), questions at the top with ⭐ answers. Numbered **AC1, AC2…**, each with one named test on a
   single plan line, marked **proposed**; `(live)` right after the id for an AC only Justin can check, e.g.
   `- AC5 (proposed) (live): …`. Generic fixtures, not copies of this file, plus a replay check on the debug file.
   Gates: `npm run check`, `npm run corpus` (GRO, drawn without auto layout, is the corpus page most likely to move).

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
