# Role: planner (Full): native-widgets — rebuild widgets that paste as Code with Bricks' own elements where possible

You are a fresh planner for FigmaToBricksV2 (**Fable 5.2, high**). Plan only: change no source or test, commit nothing, start no
agents. **Never load bdryswi.com**, B-Dry staging or any live site; no logins; never write to any WordPress site. Read-only on
`~/Downloads` (Justin's 2026-11-11 scan: read-only copy `~/.hermes/plans/figma-to-bricks/evidence/media-clickable/run/`). Plain `git`, each
command alone (no `git -C` the main folder from a worktree; no git piped into another command); scratch under `~/.cache/nw-pl/`.

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
Point 4 of "where it still differs from hand-built": third-party widgets (the reviews carousel) and the site's own behaviour scripts (the ☰
menu's Services slide, the header spacer, list and card scripts on the plugin side) paste as Code elements that need Regenerate code
signatures and don't run in Bricks' editor. Full pipeline.

## The plan must settle
1. Inventory every Code element both tools make today (importer: panel-embed-code, site-reviews, site-menu-motion, site-motion; plugin: lists,
   card arrows, maps, header spacer, …), what each does, and which Bricks element or Interaction does the same natively (Slider Nestable,
   Accordion Nestable, Nav Nestable, Offcanvas, Interactions — samples in `reference/bricks/` or Bricks' GPL code; Justin's own copies are
   still owed for Nav, Tabs, Dropdown, a working Interaction: say where a researched sample stands in).
2. What must stay Code (a third-party widget whose content comes from its server, a searchable list): labelled and named in the notes.
3. Equal behaviour proven in Chrome on Bricks 2.4.2 and 2.3.9 CSS + JS where the renderer can run it.

## Also
Numbered ACs AC1, AC2… each with one named test (each name whole on one line; a line that isn't an AC's definition never starts with a list
marker followed by `AC<n>`), all marked **proposed**; one `(live)` AC: Justin's own paste on his site (B-Dry staging for the importer,
darksalmon for the plugin) where a Bricks pro's edit does what it should. Both tools covered where the job applies to both; pastes that the
job doesn't touch byte for byte as before; the importer still one to one with the site and Figma designs exact at the design width.

## Write
`~/.hermes/plans/figma-to-bricks/native-widgets.md` (the builder copies it to `docs/plans/<date>-native-widgets.md`): playback in 3 plain lines, questions at
the top with ⭐ answers (Justin answers with "go with recommended"), the design, the standard point by point, ACs, touched files, tasks in
milestones, overlaps and order, a Docs & records task. Evidence under `~/.hermes/plans/figma-to-bricks/evidence/native-widgets/planner/`.

## Report (as text)
The plan path; the questions with ⭐ answers; the ACs one line each; what you measured; `skill_lessons[]`, ending with: `MAIN SESSION: check
and save these skill_lessons now.`
