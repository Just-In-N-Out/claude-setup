# Role: planner (Full): forms-wpforms — a scanned site's form pastes as a WPForms form

You are a fresh planner for FigmaToBricksV2 (**Fable 5.2, high**). Plan only: change no source or test, commit nothing, start no
agents. **Never load bdryswi.com**, B-Dry staging or any live site; no logins; never write to any WordPress site. Read-only on
`~/Downloads` (Justin's 2026-11-11 scan: read-only copy `~/.hermes/plans/figma-to-bricks/evidence/media-clickable/run/`). Plain `git`, each
command alone (no `git -C` the main folder from a worktree; no git piped into another command); scratch under `~/.cache/fwp-pl/`.

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
B-Dry's contact form (WPForms Pro: a two-box name `fieldset`, email, phone picker, 4 drop-downs, a text area, reCAPTCHA; on `/contact-us/` and
in a home pop-up) pastes today as a drawn form that sends nothing (`src/core/site/kinds.ts:2-3`, `convert.ts:43`). Justin, asked "Bricks Form
or WPForms?": **"wpform"**. Full pipeline. The Figma plugin makes a drawn form a Bricks Form today (CLAUDE.md "Forms"); its "Forms become:
Bricks form / WPForms" option was an open question — propose it with a ⭐ (both tools per the standard), naming what it needs (his WPForms
export file is in `reference/wpforms/`? read `reference/wpforms/README.md` and `need-a-repair-559.css`).

## The plan must settle
1. How a WPForms form gets onto his site without agents writing to it: a WPForms import file (WPForms → Tools → Import, its JSON shape from
   WPForms' own code — find a GPL copy or the export in `reference/wpforms/`; never from memory) built from the scanned form's fields, labels,
   placeholders, required marks, choices and its notification/confirmation defaults, that Justin imports himself; then the paste holds Bricks'
   WPForms element (shape from Bricks' GPL code `saqib6571/bricksbuilder` `includes/elements/wpforms.php`) pointing at that form — how the form
   id is known (he types it, the panel/`site:import` reads it from WordPress read-only, or a name match).
2. The look: the site's WPForms styling (its CSS classes and the scanned looks) so the pasted form looks as on the site; reCAPTCHA (his
   WPForms settings, not the paste); the phone picker.
3. What stays as today when a form isn't WPForms on the site (a plain HTML form, Elementor's own Form): say which tool it becomes, ⭐.
4. Proof: the import file accepted by WPForms' own import code (run its PHP-free parts or match its schema), the paste's element shape, the
   look within 2 px of the site in Chrome (Bricks 2.4.2 and 2.3.9 with WPForms' front-end CSS), fixture sites only; the live AC: Justin
   imports the file, pastes, sends a test message.

If you need to figure something out, research it first; if nothing is found, give your best-reasoned answer as a ⭐ ruling.
Read the project skill directly: `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (it isn't linked as a Skill).

## Also
Numbered ACs AC1, AC2… each with one named test (each name whole on one line; a line that isn't an AC's definition never starts with a list
marker followed by `AC<n>`), all marked **proposed**; one `(live)` AC: Justin's own paste on his site (B-Dry staging for the importer,
darksalmon for the plugin) where a Bricks pro's edit does what it should. Both tools covered where the job applies to both; pastes that the
job doesn't touch byte for byte as before; the importer still one to one with the site and Figma designs exact at the design width.

## Write
`~/.hermes/plans/figma-to-bricks/forms-wpforms.md` (the builder copies it to `docs/plans/<date>-forms-wpforms.md`): playback in 3 plain lines, questions at
the top with ⭐ answers (Justin answers with "go with recommended"), the design, the standard point by point, ACs, touched files, tasks in
milestones, overlaps and order, a Docs & records task. Evidence under `~/.hermes/plans/figma-to-bricks/evidence/forms-wpforms/planner/`.

## Report (as text)
The plan path; the questions with ⭐ answers; the ACs one line each; what you measured; `skill_lessons[]`, ending with: `MAIN SESSION: check
and save these skill_lessons now.`
