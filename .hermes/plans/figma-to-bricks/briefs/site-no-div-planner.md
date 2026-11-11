# Role: planner (Full): site-no-div — an importer paste with no Div: built like a person built it in Bricks

You are a fresh planner for FigmaToBricksV2 (**Fable 5.2, high**). Plan only: change no source or test, commit nothing,
start no agents. **Never load bdryswi.com**, B-Dry staging or any live site; no logins; never write to any WordPress site.
Read-only on `~/Downloads`.

Load the skills `figma-to-bricks` (project skill), `engineering-best-practices`, `implementation-planning`. Read the
repo's `CLAUDE.md` (main folder `/home/justin/Documents/FigmaToBricksV2`, `main` at Build 2026-11-11.3), the memory note
`/home/justin/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/importer-native-structure.md`, the decisions
"The website importer copies the site's own code", "Code-method class names start with the page's name" and "Output
style (2026-10-06): editable structure first" (`ExampleBricks`), and `reference/bricks/` (README + samples: element
shapes only from these, never from memory).

## What Justin asked (2026-11-11, with a screenshot of Bricks' Structure panel of his bdryswi.com paste)
"I do not want to see "Div" anymore. If there is a button, it should be a button, if it is a photo media it should show
photo media, it should have containers, blocks, the look of it should be as if it was built with bricks not copied!!!!!"
The screenshot (Build 2026-11-11.3 paste): Div > Block > Block/Block/Block > Div > Div > Div …, an Offcanvas, Div > Block
> Div > Div > Slider (Nestable) > Block > Block > Block > Div > Div … — most boxes are Divs nested deep.
His answers: a **new Full job on top of site-native-structure** (that job merges first); a wrapper box with no button,
picture or words of its own becomes a **Block** (styled so it looks exactly like the site; Block's own defaults reset
where needed).

## The base you build on
`site-native-structure` (not merged yet; branch `site-native-structure-fix3`, head `138799bb`, being moved onto main as
`site-native-structure-stack6`): the Elementor fold (`src/core/site/elementor-fold.ts`, `elementor-place.ts`,
`elementor-button.ts`, `labels.ts`, …) makes Section/Container at the top, Buttons and linked Images alone where fold
rule 10 proves their place, and keeps the rest as labelled Divs or "page code". Read its plan
(`~/.hermes/plans/figma-to-bricks/evidence/site-native-structure/plan-approved.md`) and follow-ups (`…/follow-ups.md`:
R1-2 "535 Divs of 1024 elements", the boxed buttons `ef454b9`, `58a7a74`, `ba89ea2`, "kept as page code" widgets). Read
code with `git -C /home/justin/Documents/FigmaToBricksV2 show site-native-structure-fix3:<path>`. Justin's newest paste
and notes: `~/Downloads/bdry-test/paste/` (`page.json`, `header.json`, `footer.json`, `notes.txt`: "kept as page code:
…", "not folded: … its holder pads").

## The plan must settle
1. **Count today's Divs by cause** on the paste made by site-native-structure's head from Justin's capture
   (`~/Downloads/bdry-test/bdryswi-com-home.f2b-capture.json`; also the plain route and a non-Elementor fixture site):
   wrappers, "kept as page code" widgets (logo, icon, spacer, button, nested-accordion), unfolded holders, picture boxes,
   text holders, slider internals… — a table.
2. **The mapping, for every scanned site** (not B-Dry only; Elementor and plain HTML): which Bricks element each kind
   becomes (Section/Container/Block, Heading, Text/Rich Text, Button, Image, Icon, Video, List?, Nav?, Slider…), with the
   Bricks defaults each brings (`.brxe-block` flex column `width:100%`, Container max-width, Image `<img>`/link shape,
   Button `.bricks-button` inline-flex; Bricks caps every element at its parent's width; Section/Container/Block wrap
   from 767 down; layout keys by element; no `_alignSelf: stretch`) and how the paste undoes what would change the look.
   Where Bricks has no native element for a thing (a site's own SVG drawing, a script-made widget kept as code), say what
   it becomes instead of a Div (⭐ recommend; the Code element only where code must run) — the target is zero Divs, and
   every Div left is named in the notes with why.
3. **The look stays one-to-one**: measured against the capture at every captured width by `site:check` (header, page,
   footer, Bricks 2.4.2 and 2.3.9), with the tolerance site-native-structure uses; the B-Dry stand-in whole page.
4. **Editable like a Bricks build**: Bricks controls instead of custom CSS where a control exists (typography, spacing,
   background, border), classes named `<page>__<name>` (decision), a shallow tree (collapse wrappers that add nothing).
   Say how far this job goes and what is a later job.
5. Overlaps: site-native-structure (base), media-clickable (pictures as their own Image items — running now, planning),
   site-menu-motion (the menu's sub-list), site-sticky-header (the header). Name shared files and an order.
6. **Numbered ACs, AC1, AC2…, each with one named test** (each name whole on one line; a line that isn't an AC's
   definition never starts with a list marker followed by `AC<n>`), all marked **proposed**: at least — zero Divs on the
   B-Dry stand-in paste and on a plain-HTML fixture site (or every one left named), each kind's element type, the look
   within tolerance at every width, Figma designs byte for byte; one `(live)` AC: Justin re-pastes on B-Dry staging and
   the Structure panel shows Section/Container/Block, Heading, Text, Button, Image with no Div.

## Write
`~/.hermes/plans/figma-to-bricks/site-no-div.md` (the builder copies it to `docs/plans/2026-11-11-site-no-div.md`):
playback in 3 plain lines, questions at the top with ⭐ answers (Justin's standing auto-go runs the builder on them once
site-native-structure has merged), the Div table, the mapping, ACs, touched files, tasks (sized; split into milestones if
large), a Docs & records task. Evidence under `~/.hermes/plans/figma-to-bricks/evidence/site-no-div/planner/`.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/snd/t1`);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close every Chrome you start (by the PIDs of its own
profile path; never `pkill -f`). One plain git command per call, `git -C <absolute path>`; to run code from the
site-native-structure branch, `git archive` it into a scratch tree under `~/.cache/snd/` (symlink the main folder's
`node_modules`). Use `tail -n 3`. Waits under 115 s. SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u
earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first.

## Report (as text)
The plan's path; the playback; the Div table in short; the mapping in short; the ACs one line each (the live one named);
questions with ⭐; then `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
