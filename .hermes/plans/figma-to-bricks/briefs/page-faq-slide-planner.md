# Role: planner (Full): page-faq-slide — FAQs in the page slide like the site's, as Bricks' Accordion

You are a fresh planner for FigmaToBricksV2 (**Fable 5.2, high**). Plan only: change no source or test, commit nothing, start no
agents. **Never load bdryswi.com**, B-Dry staging or any live site; no logins; never write to any WordPress site. Read-only on
`~/Downloads` (Justin's 2026-11-11 scan: read-only copy `~/.hermes/plans/figma-to-bricks/evidence/media-clickable/run/`). Plain `git`, each
command alone (no `git -C` the main folder from a worktree; no git piped into another command); scratch under `~/.cache/pfs-pl/`.

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
Research (`~/.hermes/plans/figma-to-bricks/evidence/bdry-pages-motion/report.md`, gaps 2 and 4): the Sump Pump page's FAQ (Elementor's Nested
Accordion in the page: first answer open, one at a time, 400 ms slide) pastes as Blocks the browser opens with no slide, the first answer
closed and several open at once; the ElementsKit FAQ (home, Exterior Drainage) pastes as Bricks' Accordion at Bricks' 200 ms, not the site's
time. Justin: "yes" to a job. Full pipeline.

## The plan must settle
1. The rule: a `details` FAQ list in the page (not only inside an opened box) → Bricks' Accordion (Nestable) with `expandItem` (first open),
   `transition` (the site's ms), one at a time unless the site opens several (`independentToggle: true` only then); timing and state from
   Elementor's `n_accordion_animation_duration`, `default_state`, `max_items_expended` (already in the scan) and, for any site, a slide the
   capture records in the page (today only inside an opened box: `open-paste.ts:43-44` — what changes in the capture). The ElementsKit FAQ's
   slide time. Flex/grid answers sit inside the content wrapper, never as it (native-widgets' finding: Bricks' script sets the wrapper to
   `display: block`). The plugin's FAQ (Figma) side: does it already slide? say so.
2. Order: after importer-parity and native-widgets (same files: `plain-natives.ts`, `open-paste.ts`, `elementor-accordion.ts`); reuse
   native-widgets' Accordion builder.
3. Proof in Chrome on Bricks 2.4.2 and 2.3.9 JS + CSS: heights at 25/50/75 % of the slide equal the site's, first open, one at a time, Enter,
   reduced motion; a fixture site of each shape.

If you need to figure something out, research it first; if nothing is found, give your best-reasoned answer as a ⭐ ruling.
Read the project skill directly: `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (it isn't linked as a Skill).

## Also
Numbered ACs AC1, AC2… each with one named test (each name whole on one line; a line that isn't an AC's definition never starts with a list
marker followed by `AC<n>`), all marked **proposed**; one `(live)` AC: Justin's own paste on his site (B-Dry staging for the importer,
darksalmon for the plugin) where a Bricks pro's edit does what it should. Both tools covered where the job applies to both; pastes that the
job doesn't touch byte for byte as before; the importer still one to one with the site and Figma designs exact at the design width.

## Write
`~/.hermes/plans/figma-to-bricks/page-faq-slide.md` (the builder copies it to `docs/plans/<date>-page-faq-slide.md`): playback in 3 plain lines, questions at
the top with ⭐ answers (Justin answers with "go with recommended"), the design, the standard point by point, ACs, touched files, tasks in
milestones, overlaps and order, a Docs & records task. Evidence under `~/.hermes/plans/figma-to-bricks/evidence/page-faq-slide/planner/`.

## Report (as text)
The plan path; the questions with ⭐ answers; the ACs one line each; what you measured; `skill_lessons[]`, ending with: `MAIN SESSION: check
and save these skill_lessons now.`
