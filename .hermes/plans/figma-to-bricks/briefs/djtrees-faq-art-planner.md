# Role: Mini-pipeline planner — djtrees-faq-art (DJ Trees designer note 10, mobile)

You are a fresh `pipeline_planner` (Mini pipeline) for FigmaToBricksV2. You plan only: no product code, no tests
committed beyond the plan file, no BUILD bump, no merge, no push, never start other agents. Other agents work in
other copies of this repo at the same time: never touch the main folder `/home/justin/Documents/FigmaToBricksV2`
(read it only), never use bare `git stash`, never revert anything you didn't write.

## Your copy

You were started with `isolation: "worktree"`: your own copy at `main` = `origin/main` =
`1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e` (build 2026-10-31.2). Check `git rev-parse HEAD` first. Write the plan as
`docs/plans/2026-11-02-djtrees-faq-art.md`, commit it on your copy's branch (plain `git commit -m`, no author
override, no AI/Co-Authored-By lines; `git diff --cached --name-only` must not list CLAUDE.md), and copy it to
`E/planner/plan.md`. Report your branch name and commit SHA.

## The request (Justin, 2026-11-02)

Item 10 of the UI designer's feedback on the DJ Trees Home page, **mobile**. It must be a general plugin rule for every
design of this kind, never a patch for this file (repo CLAUDE.md "Build general logic, never one-file fixes"; no keying
on names, texts, colours or this file's pixel values).

Designer's note (image `E/inputs/designer-note-10.png`, SHA256 `18ca80a6…f1`; open it). On an iPhone, the FAQ section
("FREQUENTLY ASKED QUESTIONS / QUESTIONS? WE'VE GOT ANSWERS.", a short paragraph, then the accordion questions with +/−
toggles) has a large black tree silhouette drawn over the middle of the questions, covering the open answer's text and
two questions. The designer sketched a small tree in purple to the right of the heading:
> "On this section, can we make the tray [tree] smaller and add it to the right of the header?"

("header" is the section's heading.)

## Same rule as a sibling job: coordinate, don't duplicate

**djtrees-side-art** (designer note 4, running now) plans the same kind of change for another section: a decorative
drawing that on phones keeps its desktop size (there it leaves a tall empty gap above the words) should shrink and sit
beside the section's heading. Justin keeps every note as its own job, so this is separate, but there must be **one
general rule**, not two. Read its plan at
`/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-side-art/planner/plan.md` (it may appear while you work;
check again before you finish; its replay notes are in that folder). Your plan:
- says whether job 4's rule as planned already covers this FAQ case (art that overlaps the content, perhaps placed
  over the accordion rather than beside the intro; the section holds a native accordion);
- plans only what this case adds (detection of art lying over the words or the accordion, whatever keeps it off the
  questions), plus a test for the FAQ case, built on job 4's rule; name the shared function(s) and file(s);
- states the order: ⭐ this job's builder starts after djtrees-side-art merges into `main` (root branches it then), so
  it builds on that rule instead of a parallel copy. If job 4's plan doesn't exist when you finish, write the rule
  for both cases plainly and say so in `summary`.

Also note from CLAUDE.md: FAQ questions never hover; accordion items are native Bricks `accordion-nested`; "decorative
art cannot block taps" (djtrees-faq 30.4/30.5); "Stacking keeps Figma's layer order … page content never rises above its
section's level". Find why the tree lands over the questions on phones (file:line).

## Inputs (pinned)

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-faq-art` (yours to write: `E/planner/`).
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
   the live page. Read the FAQ section's Figma structure (where the tree sits on desktop, its box, constraints).
2. Write a **short Mini plan** (`feature-dispatch/references/mini-pipeline.md` step 1): playback, cause with file:line,
   the general rule (shared with job 4), variations and negative controls (art on the left, art beside a plain
   paragraph vs over a list/accordion, no room beside a long heading, photos that aren't decoration, desktop), touched
   files, tasks, a one-line Docs & records task (HANDOFF section, paste check **3cs**), questions at the top with ⭐
   answers. Numbered **AC1, AC2…**, each with one named test on a single plan line, marked **proposed**; `(live)` right
   after the id for an AC only Justin can check, e.g. `- AC5 (proposed) (live): …`. Generic fixtures, not copies of
   this file, plus a replay check on the debug file. Gates: `npm run check`, `npm run corpus`.

## Runtime

Node `/home/justin/.local/node-v22.23.3/bin/node` (its folder first in PATH for children). Chrome
`/home/justin/.cache/chrome-for-testing/chrome-f2b` (`CHROME_PATH`), headless, `--use-gl=disabled`, DISPLAY and
WAYLAND_DISPLAY cleared. Large temp files under a folder in E, not shared `/tmp`. Never change shared dependencies or
corpus config. Root handles setup sync.

## Return

`summary` (plain words), reproduced or not (replay and live, per width), cause file:line, plan path in your copy +
`E/planner/plan.md`, branch and commit SHA, AC list one line each (with any `(live)`), questions with ⭐ answers, how
it builds on djtrees-side-art and the build order, before screenshots in `E/planner/`, `found_else`, and
`skill_lessons[{skill, lesson, evidence, enforce}]` (normally empty; `enforce` is `none` or a one-line check
proposal). Never edit skills or memory. End with `MAIN SESSION: check and save these skill_lessons now.`
