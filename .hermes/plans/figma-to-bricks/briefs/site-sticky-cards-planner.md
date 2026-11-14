# Role: planner (Full): site-sticky-cards — stacking sticky cards pasted with Bricks' own Position: Sticky

You are a fresh planner for FigmaToBricksV2 (**Fable 5.2, high**). Plan only: change no source or test, commit nothing, start no
agents. **Never load bdryswi.com**, B-Dry staging or any live site; no logins; never write to any WordPress site. Read-only on
`~/Downloads` (Justin's 2026-11-11 scan: read-only copy `~/.hermes/plans/figma-to-bricks/evidence/media-clickable/run/`). Plain `git`, each
command alone (no `git -C` the main folder from a worktree; no git piped into another command); scratch under `~/.cache/ssc-pl/`.

Load `figma-to-bricks` (project skill), `engineering-best-practices`, `implementation-planning`. Read the repo's `CLAUDE.md` (main folder
`/home/justin/Documents/FigmaToBricksV2`), above all **the standard at the top of "Decisions the user made"** (Justin, 2026-11-13: every paste,
from the Figma plugin and the website importer alike, built like a skilled Bricks builder made it by hand, easy for a Bricks pro to change;
six points), and the memory note `/home/justin/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/bricks-pro-standard.md`. Your
plan says, point by point, how its output meets that standard. Bricks shapes only from `reference/bricks/` samples or Bricks' GPL code
(`saqib6571/bricksbuilder`, 2.2; see the memory note `bricks-source-research.md`), never from memory.

## Base and order
Build after the jobs in flight merge (they change the same code): site-no-div (branch `site-no-div-fix3`, being moved onto main),
site-shared-styles (`site-shared-styles-fix1`, head 7b7501bd: shared text/button/box/layout classes, `palette.json`), plugin-parity,
importer-parity and shared-palette (builders running: branches `plugin-parity-build`, `importer-parity-build`, `shared-palette-build`; plans
in `~/.hermes/plans/figma-to-bricks/evidence/<job>/plan-approved.md`). Base: main once those merged (now `7f54b0a5`, Build 2026-11-12.3). Read
those plans and heads; measure on the newest heads you can (a `git archive` under your scratch); name every shared file and what this job
assumes from each.

## What Justin asked (2026-11-13)
Research (`~/.hermes/plans/figma-to-bricks/evidence/bdry-pages-motion/report.md`, gap 1): on B-Dry's 7 service pages, 3–5 cards per page pin
to the top and stack on each other as you scroll (Elementor Pro Sticky: `sticky: "top"`, `sticky_parent: "yes"`, `sticky_offset` 2–217, desktop
and tablet; its script writes `position: fixed` plus a spacer copy). The importer pastes them as ordinary cards that scroll away. Justin: "yes"
to a job. Full pipeline.

## The plan must settle
1. The rule: with `--elementor`, `sticky: "top"` + `sticky_parent: "yes"` → Bricks' Position: Sticky with Top (2.2 `base.php` L488-523: `_position`,
   `_top`; a setting, no Code), at the widths `sticky_on` names; without `sticky_parent`, or `sticky: "bottom"`: as today, named in the notes;
   a non-Elementor site whose script pins a box: a follow-up (capture change). How the plugin side meets it (Figma's "Fix position when
   scrolling" / sticky frames — does the plugin carry them today? say so; both tools per the standard where it applies).
2. What can break it: the header's stay class (z-index 100) over cards pinned 2 px below the top; an `overflow: hidden`/`clip` box between a
   card and the page (site-scroll-lock's `overflow-x: clip` on html/body is fine for sticky — prove it); the Section/Container lift.
3. Proof in Chrome: whole-page paste scrolled 0, 400, 800, 1200 px at 1440 and 1024 (the cards' tops equal the site's at each), Bricks 2.4.2
   and 2.3.9; phones unaffected; a fixture site of the shape (no live site); `site:check` no row worse.

If you need to figure something out, research it first; if nothing is found, give your best-reasoned answer as a ⭐ ruling.
Read the project skill directly: `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (it isn't linked as a Skill).

## Also
Numbered ACs AC1, AC2… each with one named test (each name whole on one line; a line that isn't an AC's definition never starts with a list
marker followed by `AC<n>`), all marked **proposed**; one `(live)` AC: Justin's own paste on his site (B-Dry staging for the importer,
darksalmon for the plugin) where a Bricks pro's edit does what it should. Both tools covered where the job applies to both; pastes that the
job doesn't touch byte for byte as before; the importer still one to one with the site and Figma designs exact at the design width.

## Write
`~/.hermes/plans/figma-to-bricks/site-sticky-cards.md` (the builder copies it to `docs/plans/<date>-site-sticky-cards.md`): playback in 3 plain lines, questions at
the top with ⭐ answers (Justin answers with "go with recommended"), the design, the standard point by point, ACs, touched files, tasks in
milestones, overlaps and order, a Docs & records task. Evidence under `~/.hermes/plans/figma-to-bricks/evidence/site-sticky-cards/planner/`.

## Report (as text)
The plan path; the questions with ⭐ answers; the ACs one line each; what you measured; `skill_lessons[]`, ending with: `MAIN SESSION: check
and save these skill_lessons now.`
