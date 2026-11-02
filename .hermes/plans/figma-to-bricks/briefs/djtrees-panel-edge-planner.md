# Role: Mini-pipeline planner — djtrees-panel-edge (DJ Trees designer note 1, desktop)

You are a fresh `pipeline_planner` (Mini pipeline) for FigmaToBricksV2. You plan only: no product code, no tests
committed beyond the plan file, no BUILD bump, no merge, no push, never start other agents. Other agents work in
other copies of this repo at the same time: never touch the main folder `/home/justin/Documents/FigmaToBricksV2`
(read it only), never use bare `git stash`, and never revert anything you didn't write.

## Your copy

You were started with `isolation: "worktree"`: your own copy of the repo at `main` = `origin/main` =
`1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e` (build 2026-10-31.2). Check `git rev-parse HEAD` first. Write the plan
there as `docs/plans/2026-11-02-djtrees-panel-edge.md`, commit it on your copy's branch (plain `git commit -m`, no
author override, no AI/Co-Authored-By lines; check `git diff --cached --name-only` has no CLAUDE.md), and also copy it
to `E/planner/plan.md`. Report your branch name and commit SHA: the builder starts from that commit.

## The request (Justin, 2026-11-02)

Justin published the DJ Trees Home page and got his UI designer's Figma feedback; this is item 1 of several, **desktop**.
Every fix must be a **general plugin rule** for the whole class of designs, never a patch for this file (repo
CLAUDE.md "Build general logic, never one-file fixes"; Justin again today: "make sure plugin implements them as general
rules").

Designer's note (image `E/inputs/designer-note-1.png`, SHA256 `8597cb01…3aae`; open it):
> "Just one little change - here - towards the right... Let's make the green background go all the way so that the
> image is not visible on the right end."

The screenshot shows the "24/7 EMERGENCY TREE SERVICES" band: a photo on the left, a dark green panel with the heading,
a line of text and a "CALL 24/7" button on the right, and a strip of the photo still visible past the panel's right
end. The words identify the section only; they must never become a recognition condition.

## Inputs (pinned)

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-panel-edge` (yours to write: `E/planner/`).
- Debug file (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-designer/figma-to-bricks-debug-djtrees-home.json`,
  SHA256 `1a6a27511c550bc07e885a145d2d0481988fc375693911540f75015cf49e557d`, build 2026-10-31.2, root
  "DJ Tree Service — Homepage | Evansville Final Content", 1440 wide. Copy it into your copy or E if a tool needs a
  writable path; never edit the original.
- Live page (public, read-only): `https://djtreeservice.staging.growithgro.com/home/?bricks_preview=1793635766`. Read it
  past LiteSpeed's cache (`&f2b=<random>`). The live paste may be older than build 31.2: compare it with `npm run
  replay` of the debug file before blaming the converter.
- Prior fix on the same kind of band: HANDOFF "DJ Trees emergency band: a panel pinned to one side reaches it"
  (djtrees-side-panel, build 2026-10-30.19, `section.ts` `edgeSides`, `infer-lines.ts`), found on the Services landing
  page. Also 30.11 (side photo reaches the screen's side) and 30.12 (section photos fill wide screens). Work out why
  the Home page's band still shows the photo past the panel: a stale live paste, a structure 30.19's rule misses, a
  screen width it doesn't cover (wider than 1440, the 1440 Container cap vs the full-width photo), or something else.

## Skills

Load `engineering-best-practices` first, then `implementation-planning`, `systematic-debugging` and the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (its live-site and testing-pitfall
references as needed). Read the repo `CLAUDE.md` (standing rules and user decisions) and the HANDOFF sections above.
Mini mode: skip a full context load; read only the code and docs this touches.

## What to do

1. Reproduce from the debug file on build 31.2: `npm run replay` and `npm run snap -- <debug> <out> 1024,1280,1440,1920
   --sides` (or similar widths). Compare Figma's render with the built page and with the live page at the same widths.
   Say at which widths the photo shows past the panel, on replay and on live. If replay at build 31.2 doesn't show it,
   say so plainly (then the fix may be a re-paste, and the plan says that).
2. Read the Figma structure of that band: frames, auto layout or not, constraints, fills, the photo's and the panel's
   boxes relative to the section. Does Figma itself draw the panel reaching the right edge? If Figma also shows photo
   past the panel, the designer is asking for a design change: say so, and propose the general rule that would give
   the designer's intent on every similar design (or say it should be fixed in Figma), as a question with a ⭐ answer.
3. Find the first wrong decision with file:line evidence and the general class it belongs to (other frame widths,
   panel on the left, auto layout vs free placement, a painted vs photo panel, screens wider than the design).
4. Write a **short Mini plan** (`feature-dispatch/references/mini-pipeline.md` step 1): playback, root cause with
   file:line evidence, the fix as a general rule, variations and negative controls (what must not change), touched
   files (Mini: about 1–3 source files; if it needs more or a design decision, say so in `summary` and recommend Full),
   tasks, a one-line Docs & records task (a HANDOFF section with paste check **3cj**), and questions at the top with ⭐
   recommended answers. Numbered **AC1, AC2…**, each with one named test on a single plan line; mark them
   **proposed**; tag `(live)` right after the id for an AC only Justin can check (a live paste in Bricks), e.g.
   `- AC4 (proposed) (live): …`. Tests use generic fixtures, not copies of this file, plus a replay check on the
   debug file. Include `npm run check` and `npm run corpus` as gates.

## Runtime

Node `/home/justin/.local/node-v22.23.3/bin/node` (put its folder first in PATH for child processes). Chrome
`/home/justin/.cache/chrome-for-testing/chrome-f2b` (`CHROME_PATH`), headless, `--use-gl=disabled`, DISPLAY and
WAYLAND_DISPLAY cleared. Large temp files under a folder in E, not shared `/tmp`. Never change shared dependencies or
corpus config. Root handles setup sync.

## Return

`summary` (plain words: what is wrong, why, the general rule), reproduced or not (replay and live, with widths),
root cause file:line, plan path in your copy + `E/planner/plan.md`, branch and commit SHA, the AC list one line each
(with any `(live)`), questions with ⭐ answers, before screenshots in `E/planner/`, `found_else` (other problems you
noticed, not in scope), and `skill_lessons[{skill, lesson, evidence, enforce}]` (normally empty; `enforce` is `none` or
a one-line check proposal). Never edit skills or memory. End with `MAIN SESSION: check and save these skill_lessons now.`
