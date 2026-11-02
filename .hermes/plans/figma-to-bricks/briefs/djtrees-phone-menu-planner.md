# Role: Mini-pipeline planner — djtrees-phone-menu (DJ Trees designer note 2, mobile)

You are a fresh `pipeline_planner` (Mini pipeline) for FigmaToBricksV2. You plan only: no product code, no tests
committed beyond the plan file, no BUILD bump, no merge, no push, never start other agents. Other agents work in
other copies of this repo at the same time (one is planning the emergency band's panel edge): never touch the main
folder `/home/justin/Documents/FigmaToBricksV2` (read it only), never use bare `git stash`, never revert anything you
didn't write.

## Your copy

You were started with `isolation: "worktree"`: your own copy at `main` = `origin/main` =
`1aef12fae0c3b5b1f63bbcc842c85c99ebcba14e` (build 2026-10-31.2). Check `git rev-parse HEAD` first. Write the plan as
`docs/plans/2026-11-02-djtrees-phone-menu.md`, commit it on your copy's branch (plain `git commit -m`, no author
override, no AI/Co-Authored-By lines; `git diff --cached --name-only` must not list CLAUDE.md), and copy it to
`E/planner/plan.md`. Report your branch name and commit SHA.

## The request (Justin, 2026-11-02)

Item 2 of the UI designer's feedback on the DJ Trees Home page, **mobile**. Justin: "Remember general rule": the fix
is a general plugin rule for every design whose desktop header/menu reaches phones, never a patch for this file (repo
CLAUDE.md "Build general logic, never one-file fixes").

Designer's note (image `E/inputs/designer-note-2.png`, SHA256 `2d840ed1…c8ee`; open it). On an iPhone the page shows
the logo (tree mark + "DJ Tree Service") centred and big over the hero photo, then every menu link stacked one per line
(HOME, ABOUT US, SERVICES, GALLERY, FAQ, CONTACT US) above the hero's words:
> "Can we work on the menu here? Instead of having all the words there, let's just have a hamburger and the logo.
> Let's make the logo a little smaller and have it to the left."

## What the project already decided (repo CLAUDE.md; don't reverse)

- Phone rule "Menu" (2026-10-01, kept 2026-10-06): a panel sliding in from the right over the dimmed page, links one
  per line (20px+, 48px lines), the header's button under them; the toggle stays on top and turns into the × that
  closes it. Interactions use native Bricks elements: **Nav (Nestable) with its own mobile menu**.
- This is milestone **M2d** (HANDOFF "M2d–M2e"), held because **no Nav (Nestable) sample exists**: "Bricks element shapes
  come from `reference/bricks/*.json` … never write native-element emitters from memory." Root has asked Justin to copy
  a Nav (Nestable) out of his Bricks now; when it arrives root will send you its path (it will become
  `reference/bricks/nav-nested.json` or similar). Don't invent its fields. Plan everything that doesn't depend on its
  exact shape (detection, which header/menu qualifies, the phone layout of logo + ☰, logo size and side, what happens
  to a drawn ☰ or a header CTA, tiers where the desktop menu stays), and make the emitter task say it is written
  against the sample. If the sample hasn't arrived when you finish, list it as the first open item.
- Related: header-bar (29.3) recognises a site's top bar; djtrees-landing (30.6) logo lockups; djtrees-header-links
  (30.4/30.5) menus inside the hero; djtrees-wide-hero (30.12) "a menu bar drawn over the hero is pinned above tablets;
  tablets and phones keep it in place (its menu wraps there until the phone menu is built)"; 31.1 centred sticky
  navigation. Read their HANDOFF sections and `src/core/understand/navigation-links.ts`.

## Inputs (pinned)

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-phone-menu` (yours to write: `E/planner/`).
- Debug file (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-designer/figma-to-bricks-debug-djtrees-home.json`,
  SHA256 `1a6a27511c550bc07e885a145d2d0481988fc375693911540f75015cf49e557d`, build 2026-10-31.2, root
  "DJ Tree Service — Homepage | Evansville Final Content", 1440 wide (desktop only; no drawn phone design).
- Live page (public, read-only): `https://djtreeservice.staging.growithgro.com/home/?bricks_preview=1793635766`; read past
  LiteSpeed with `&f2b=<random>`; compare with `npm run replay` before blaming the converter (the paste may be older).

## Skills

`engineering-best-practices` first, then `implementation-planning`, `systematic-debugging` and the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`. Read the repo `CLAUDE.md` and the
architecture spec's responsive/nav parts (`docs/specs/2026-10-06-v2-design.md`). Mini mode: read only what this touches.

## What to do

1. Reproduce on replay of the debug file at 390, 478, 767, 991 and 1024 (`npm run snap … --sides` or similar) and on
   the live page; say what the header does at each tier today and which code decides it (file:line).
2. Define the general rule: which headers get the phone menu (a logo + a row of menu links, drawn with or without
   auto layout, inside the hero or above it, with or without a CTA or phone line, with or without a drawn ☰), from
   which width the links go into the menu (the tier where they no longer fit on one line, read from the layout plan,
   or a fixed tier: give a ⭐ answer), the logo's phone size (a rule from the page scales, not a pixel taken from this
   file) and side (left, ☰ right), and the negative controls (footers, link rows that aren't a header, the header tick
   leaving the header out, drawn phone designs, a lone logo).
3. Write a **short Mini plan** (`feature-dispatch/references/mini-pipeline.md` step 1): playback, cause with file:line,
   the general rule, variations and negative controls, touched files, tasks, a one-line Docs & records task (HANDOFF
   section, paste check **3ck**, and the CLAUDE.md "Waiting on the user"/M2d lines it resolves), questions at the top
   with ⭐ answers. If this is clearly bigger than Mini (more than ~3 source files is likely here), say so in
   `summary`, recommend Full, and keep the plan as tight as the request allows: Justin chose the mini chain (one
   reviewer, one verification) for all of today's items. Numbered **AC1, AC2…**, each with one named test on a single
   plan line, marked **proposed**; `(live)` right after the id for an AC only Justin can check (the menu opening on a
   real phone in Bricks), e.g. `- AC6 (proposed) (live): …`. Generic fixtures, not copies of this file, plus a replay
   check on the debug file. Gates: `npm run check`, `npm run corpus`.

## Runtime

Node `/home/justin/.local/node-v22.23.3/bin/node` (its folder first in PATH for children). Chrome
`/home/justin/.cache/chrome-for-testing/chrome-f2b` (`CHROME_PATH`), headless, `--use-gl=disabled`, DISPLAY and
WAYLAND_DISPLAY cleared. Large temp files under a folder in E, not shared `/tmp`. Never change shared dependencies or
corpus config. Root handles setup sync.

## Return

`summary` (plain words), reproduced or not (replay and live, per width), cause file:line, plan path in your copy +
`E/planner/plan.md`, branch and commit SHA, AC list one line each (with any `(live)`), questions with ⭐ answers, what
waits on the Nav (Nestable) sample, before screenshots in `E/planner/`, `found_else`, and
`skill_lessons[{skill, lesson, evidence, enforce}]` (normally empty; `enforce` is `none` or a one-line check proposal).
Never edit skills or memory. End with `MAIN SESSION: check and save these skill_lessons now.`
