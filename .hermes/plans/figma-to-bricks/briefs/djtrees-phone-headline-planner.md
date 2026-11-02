# Role: Mini-pipeline planner — djtrees-phone-headline (DJ Trees designer note 11, mobile)

You are a fresh `pipeline_planner` (Mini pipeline) for FigmaToBricksV2. You plan only: no product code, no tests
committed beyond the plan file, no BUILD bump, no merge, no push, never start other agents. Other agents work in
other copies of this repo at the same time: never touch the main folder `/home/justin/Documents/FigmaToBricksV2`
(read it only), never use bare `git stash`, never revert anything you didn't write.

## Your copy

You were started with `isolation: "worktree"`: your own copy at `main` = `origin/main` =
`1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e` (build 2026-10-31.2). Check `git rev-parse HEAD` first. Write the plan as
`docs/plans/2026-11-02-djtrees-phone-headline.md`, commit it on your copy's branch (plain `git commit -m`, no author
override, no AI/Co-Authored-By lines; `git diff --cached --name-only` must not list CLAUDE.md), and copy it to
`E/planner/plan.md`. Report your branch name and commit SHA.

## The request (Justin, 2026-11-02)

Item 11 of the UI designer's feedback on the DJ Trees Home page, **mobile**. It must be a general plugin rule for every
design of this kind, never a patch for this file (repo CLAUDE.md "Build general logic, never one-file fixes"; no keying
on names, texts, colours, fonts or this file's pixel values).

Designer's note (image `E/inputs/designer-note-11.png`, SHA256 `6fd7591b…99bf`; open it). On an iPhone, the closing
section ("GET STARTED" eyebrow over a tree photo) has a huge condensed all-caps heading "READY TO GET THE JOB DONE?"
filling four lines edge to edge, the lines almost touching each other, then a paragraph:
> "Can we make the font size of the header a little bit smaller and maybe add a little more spacing between each line
> on the header?"

("header" is the section's heading.)

## Context (repo CLAUDE.md and HANDOFF; don't reverse)

- Phones are generated from a desktop-only design; "Spacing: one capped, whole-pixel, monotone scale"; text: "whole-pixel
  type, balanced headings". The `fluid` tier (M2e): rules write type through `type.ramp` for type ≥28, emit folds it
  into `clamp(tablet, …vw, desktop)`. Read `src/core/adapt/rules/` (the type ramp rule) and `PageFacts` scales
  (`src/core/adapt/`), and the hero's phone heading treatment if separate.
- "The design breaks a rule … never recolour or resize, except Justin's two minimums" is about text that's too small;
  phone type scaling of large headings is the rulebook's normal job.
- Work out the general class: display headings (big, tight leading, often condensed caps) whose phone size comes out so
  large they fill the width in 3+ short lines, with Figma's tight line height (e.g. 0.9–1.0) kept as is; at that size
  the lines visually touch. Decide with ⭐ answers: how the phone size is chosen (⭐ a lower cap on the phone heading
  scale for the biggest headings, e.g. tied to the hero/section heading ratio in `PageFacts`, so the longest word still
  fits and the heading takes at most N lines), and how much line spacing is added on phones (⭐ a minimum line-height
  ratio for display headings at phone tiers, e.g. never below ~1.05, written only where the drawn one is lower), which
  headings it applies to (every heading at the top of the page's type scale, the hero's included? ⭐ answer and why),
  and what must not change (desktop at the design width, tablets if fine, body text, headings already comfortable,
  headings drawn as pictures, drawn phone designs).

## Inputs (pinned)

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-phone-headline` (yours to write: `E/planner/`).
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

1. Reproduce on replay of the debug file at 390, 478, 767 and 991 (`npm run snap …`) and on the live page: the
   heading's font size and line height per tier, how many lines, and the same for the page's other big headings
   (hero, section headings) so the rule is judged across the page. Find the rule that sets the phone size and the
   line height (file:line).
2. Write a **short Mini plan** (`feature-dispatch/references/mini-pipeline.md` step 1): playback, cause with file:line,
   the general rule (breakpoint styles only from `src/core/adapt/rules/` with a `decision` line, sizes from
   `PageFacts`, never multiplying numbers in the rule; a rule that overrides another comes after it and lists it in
   `overrides`), variations and negative controls, touched files (about 1–3 source files; if more, say so in
   `summary`), tasks, a one-line Docs & records task (HANDOFF section, paste check **3ct**), questions at the top with
   ⭐ answers. Numbered **AC1, AC2…**, each with one named test on a single plan line, marked **proposed**; `(live)`
   right after the id for an AC only Justin can check, e.g. `- AC5 (proposed) (live): …`. Generic fixtures, not copies
   of this file, plus a replay check on the debug file. Gates: `npm run check`, `npm run corpus` (type changes move
   every corpus page: report the phone-tier differences).

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
