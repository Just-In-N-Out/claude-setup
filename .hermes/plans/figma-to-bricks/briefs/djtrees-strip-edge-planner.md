# Role: Mini-pipeline planner — djtrees-strip-edge (DJ Trees designer note 12, desktop)

You are a fresh `pipeline_planner` (Mini pipeline) for FigmaToBricksV2. You plan only: no product code, no tests
committed beyond the plan file, no BUILD bump, no merge, no push, never start other agents. Other agents work in
other copies of this repo at the same time: never touch the main folder `/home/justin/Documents/FigmaToBricksV2`
(read it only), never use bare `git stash`, never revert anything you didn't write.

## Your copy

You were started with `isolation: "worktree"`: your own copy at `main` = `origin/main` =
`1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e` (build 2026-10-31.2). Check `git rev-parse HEAD` first. Write the plan as
`docs/plans/2026-11-02-djtrees-strip-edge.md`, commit it on your copy's branch (plain `git commit -m`, no author
override, no AI/Co-Authored-By lines; `git diff --cached --name-only` must not list CLAUDE.md), and copy it to
`E/planner/plan.md`. Report your branch name and commit SHA.

## The request (Justin, 2026-11-02)

Item 12 of the UI designer's feedback on the DJ Trees Home page, **desktop** (Justin: "this is a desktop issue"). It
must be a general plugin rule for every design of this kind, never a patch for this file (repo CLAUDE.md "Build general
logic, never one-file fixes"; no keying on names, texts, colours or this file's pixel values).

Designer's note (image `E/inputs/designer-note-12.png`, SHA256 `b3015230…6cff`; open it). In a dark green rounded panel,
the services strip shows photo cards ("01 TREE REMOVAL", "02 TREE TRIMMING", "03 STUMP GRINDING", a fourth cut off),
then the back/on buttons and the bars under it. The cards stop short of the panel's right side, leaving a band of empty
green there (the designer marked it with a yellow line):
> "I just noticed one more little change on desktop. Let's make the cards go all the way to the right so that there's
> no spacing to the right."

## Context (repo CLAUDE.md and HANDOFF)

- HANDOFF "DJ Trees homepage carousels: back/on buttons and the lit bar" (djtrees-carousel, build 30.7–30.14;
  `strips.ts`, `arrows.ts` `controlsAfter`, `emit/arrows.ts`): "03 Services" holds a Carousel Track Figma scrolls
  sideways (unclipped, its six 360px cards past its edge). That section's **unconfirmed ruling**: "The track stays
  clipped at its own box: cards no longer show past the page's margin to the window's edge as drawn." The designer's
  note asks for the opposite on desktop; treat this as Justin's 2026-11-02 decision replacing that ruling, and record
  it (Docs & records).
- Sideways scrolling (CLAUDE.md, user 2026-10-08): "A frame Figma's prototype scrolls sideways … whose layers run past
  its edge, scrolls sideways on the site, gently snapping to its cards. Its layers keep their drawn size on every
  desktop and tablet width." Card arrows / controls must keep working (scroll positions, the lit bar, round at the ends,
  controls hidden where the strip doesn't scroll).
- Work out the general rule: a sideways strip whose cards Figma draws running past its own box (unclipped) shows them
  running on to the edge of the nearest clipping/painted ancestor (here the green panel; or the window when nothing
  clips), as drawn, instead of stopping at the track's box; the first card keeps its drawn start. Decide with ⭐
  answers: which edge it runs to (⭐ the nearest ancestor that clips or paints a background, else the window), whether
  the left side also runs out once scrolled (⭐ the strip scrolls within that same span, so scrolled cards pass the
  left edge too, starting position as drawn), how snapping and the "last card" end position behave so the last card can
  still reach its drawn place, tablets and phones (phones adapt as today: the phone slider copies), and what must not
  change (strips Figma clips, strips without cards past the edge, the controls' behaviour, other sections).

## Inputs (pinned)

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-strip-edge` (yours to write: `E/planner/`).
- Debug file (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-designer/figma-to-bricks-debug-djtrees-home.json`,
  SHA256 `1a6a27511c550bc07e885a145d2d0481988fc375693911540f75015cf49e557d`, build 2026-10-31.2, root
  "DJ Tree Service — Homepage | Evansville Final Content", 1440 wide (desktop only).
- Live page (public, read-only): `https://djtreeservice.staging.growithgro.com/home/?bricks_preview=1793635766`; read past
  LiteSpeed with `&f2b=<random>`; compare with `npm run replay` before blaming the converter. The strip's script runs
  only on the live page / Preview, not the editor.

## Skills

`engineering-best-practices` first, then `implementation-planning`, `systematic-debugging` and the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`. Read the repo `CLAUDE.md`. Mini mode:
read only the code and docs this touches.

## What to do

1. Reproduce on replay of the debug file at 1024, 1280, 1440 and 1920 (`npm run snap … --sides`) and on the live page:
   where the strip's right edge is vs the green panel's and Figma's. Read the section's Figma structure (track box,
   panel, clipping, padding). Find the decision that clips the track at its box (file:line).
2. Write a **short Mini plan** (`feature-dispatch/references/mini-pipeline.md` step 1): playback, cause with file:line,
   the general rule, variations and negative controls, touched files (about 1–3 source files; if more, say so in
   `summary`), tasks, a one-line Docs & records task (HANDOFF section, paste check **3cu**, the ruling it replaces),
   questions at the top with ⭐ answers. Numbered **AC1, AC2…**, each with one named test on a single plan line, marked
   **proposed**; `(live)` right after the id for an AC only Justin can check (the strip on the live page with code
   signatures regenerated), e.g. `- AC5 (proposed) (live): …`. Generic fixtures, not copies of this file, plus a
   replay check on the debug file and a browser test that the controls still move the strip. Gates: `npm run check`,
   `npm run corpus`.

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
