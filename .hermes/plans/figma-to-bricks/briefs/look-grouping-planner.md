# Role: planner (Full): look-grouping — the same button (heading, card…) shares one class, in both tools

You are a fresh planner for FigmaToBricksV2 (**Fable 5.2, high**). Plan only: change no source or test, commit nothing, start no
agents. **Never load bdryswi.com**, B-Dry staging or any live site; no logins; never write to any WordPress site. Read-only on
`~/Downloads` (Justin's 2026-11-11 scan: read-only copy `~/.hermes/plans/figma-to-bricks/evidence/media-clickable/run/`). Plain `git`, each
command alone (no `git -C` the main folder from a worktree; no git piped into another command); scratch under `~/.cache/lg-pl/`.

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
assumes from ea## What Justin asked (2026-11-13)
Grouping today is by exact look: two buttons that look almost the same get two classes, and a Bricks pro has to merge them by hand. Justin:
"well if it is the same button like call me all call me buttons should change it should identify them by name i think is the best". So: every
copy of the same button shares one class, and editing that class changes them all. The taken rule (my recommendation, played back to him):
1. **"The same" by identity, strongest signal first:** Figma plugin — instances of the same main component (and the same text style /
   component variant); importer — the site's own class names on the element (e.g. Elementor's widget classes and the site's custom classes,
   with the same widget settings); both tools — the same words and the same link (`tel:`/`mailto:`/the same page). Layer names are a hint
   at most (CLAUDE.md "Build general logic"); words alone never join two different-looking roles (a "Call us" in the header bar and a "Call
   us" text link in the footer are not the same button unless the other signals agree — the plan says exactly when).
2. **One shared class holds everything the group has in common** (named by purpose: `bd-button-call`, with short-class-names' prefix rule);
   a copy that differs keeps only the differing values on its own class, so nothing moves (exact wins); different-looking buttons of
   another identity get their own class.
3. The same for headings, cards and other repeated parts (a card component, the same site class on boxes).
Full pipeline. Overlaps: site-shared-styles (look-based grouping, `src/core/site/share.ts`, `looks.ts`), plugin-parity (its look classes S1–S5),
short-class-names (names), clean-values (≤0.5 px snapping) — say who owns what and the order.

## The plan must settle
1. The identity signals per tool and how they combine (component key, site class sets, words+link), measured on Justin's scan, the B-Dry
   stand-in and the plugin corpus: groups by look today vs by identity, the shared class count, the per-element tweaks left.
2. The "change it once, all copies change" test in Chrome on Bricks 2.4.2 and 2.3.9 (edit the group's class: every copy changes, nothing
   else), and the 0.5 px guard at every width / tier with the switch on and off.

px.

## Also
Numbered ACs AC1, AC2… each with one named test (each name whole on one line; a line that isn't an AC's definition never starts with a list
marker followed by `AC<n>`), all marked **proposed**; one `(live)` AC: Justin's own paste on his site (B-Dry staging for the importer,
darksalmon for the plugin) where a Bricks pro's edit does what it should. Both tools covered where the job applies to both; pastes that the
job doesn't touch byte for byte as before; the importer still one to one with the site and Figma designs exact at the design width.

## Write
`~/.hermes/plans/figma-to-bricks/look-grouping.md` (the builder copies it to `docs/plans/<date>-look-grouping.md`): playback in 3 plain lines, questions at
the top with ⭐ answers (Justin answers with "go with recommended"), the design, the standard point by point, ACs, touched files, tasks in
milestones, overlaps and order, a Docs & records task. Evidence under `~/.hermes/plans/figma-to-bricks/evidence/look-grouping/planner/`.

## Report (as text)
The plan path; the questions with ⭐ answers; the ACs one line each; what you measured; `skill_lessons[]`, ending with: `MAIN SESSION: check
and save these skill_lessons now.`
