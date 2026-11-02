# Role: Mini-pipeline planner — djtrees-cta-center (DJ Trees designer note 3, mobile)

You are a fresh `pipeline_planner` (Mini pipeline) for FigmaToBricksV2. You plan only: no product code, no tests
committed beyond the plan file, no BUILD bump, no merge, no push, never start other agents. Other agents work in
other copies of this repo at the same time (the emergency band's panel edge; the phone menu): never touch the main
folder `/home/justin/Documents/FigmaToBricksV2` (read it only), never use bare `git stash`, never revert anything you
didn't write.

## Your copy

You were started with `isolation: "worktree"`: your own copy at `main` = `origin/main` =
`1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e` (build 2026-10-31.2). Check `git rev-parse HEAD` first. Write the plan as
`docs/plans/2026-11-02-djtrees-cta-center.md`, commit it on your copy's branch (plain `git commit -m`, no author
override, no AI/Co-Authored-By lines; `git diff --cached --name-only` must not list CLAUDE.md), and copy it to
`E/planner/plan.md`. Report your branch name and commit SHA.

## The request (Justin, 2026-11-02)

Item 3 of the UI designer's feedback on the DJ Trees Home page, **mobile**, about call-to-action buttons. It must be a
general plugin rule for every design, never a patch for this file (repo CLAUDE.md "Build general logic, never one-file
fixes"; Justin today: "make sure plugin implements them as general rules").

Designer's note (image `E/inputs/designer-note-3.png`, SHA256 `634a3eac…0544`; open it). Two full-width phone buttons:
a green "GET A FREE ESTIMATE →" (label, then an arrow at its right) and an outlined "📞 CALL (812) 430-8667" (a phone
icon, then the label); both have their content pushed to the left of the button:
> "On mobile, let's have the text on all the buttons center-aligned."

## Context (repo CLAUDE.md; don't reverse)

- "Every call-to-action button is full width on phones, cards included (not tags, floating layers, icon buttons)."
- CTA buttons (`understand/widgets.ts` `markCtas`, `IRNode.cta`, the `cta-motion` class): "Words on one line, Figma's
  width … above phones a button keeps Figma's width." Bricks Buttons carry their icon natively (`reference/bricks/`
  samples: `cta-button-interactions.json`, `hero-video-buttons.json`).
- Work out what "all the buttons" covers: every full-width phone button (CTAs, Bricks Buttons, a painted pill, a Div
  acting as a button with a linked text or an icon + label row, the hero's "Phone buttons" copies), on which tiers
  the button is full width (upright phones, sideways phones, tablets if any), and what must not change (buttons that
  keep Figma's width, tags/pills in rows, icon-only buttons, menu links, form send buttons if separate, desktop).
  Where an icon sits beside the label (before or after), the label + icon group is centred together, the icon keeping
  its side and gap. Give ⭐ answers for any choice (e.g. whether centring also applies wherever a button is stretched
  wider than its drawn content, not only on phones).

## Inputs (pinned)

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-cta-center` (yours to write: `E/planner/`).
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

1. Reproduce on replay of the debug file at 390, 478, 767 and 991 (`npm run snap …`) and on the live page: list every
   button on the page, how wide it is per tier and where its content sits, and which rule/emitter decides the
   alignment (file:line; e.g. the full-width phone rule in `src/core/adapt/rules/`, the button's justify/text-align
   settings in emit). Find the class of buttons that end up left-aligned when stretched.
2. Write a **short Mini plan** (`feature-dispatch/references/mini-pipeline.md` step 1): playback, cause with file:line,
   the general rule (which rule file writes it, per the architecture rules: only `src/core/adapt/rules/` writes
   breakpoint styles, a `decision` line, tiers going back to the designed value written explicitly), variations and
   negative controls, touched files (about 1–3 source files; if more or a design decision, say so in `summary`),
   tasks, a one-line Docs & records task (HANDOFF section, paste check **3cl**), questions at the top with ⭐ answers.
   Numbered **AC1, AC2…**, each with one named test on a single plan line, marked **proposed**; `(live)` right after
   the id for an AC only Justin can check (a live paste on a real phone), e.g. `- AC5 (proposed) (live): …`. Generic
   fixtures, not copies of this file, plus a replay check on the debug file. Gates: `npm run check`, `npm run corpus`.

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
