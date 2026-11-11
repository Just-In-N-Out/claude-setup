# Role: planner (Full): site-shared-styles — an importer paste whose looks live in shared classes and palette colours

You are a fresh planner for FigmaToBricksV2 (**Fable 5.2, high**). Plan only: change no source or test, commit nothing,
start no agents. **Never load bdryswi.com**, B-Dry staging or any live site; no logins; never write to any WordPress site.
Read-only on `~/Downloads`.

Load the skills `figma-to-bricks` (project skill), `engineering-best-practices`, `implementation-planning`. Read the repo's
`CLAUDE.md` (main folder `/home/justin/Documents/FigmaToBricksV2`): the decisions "Output style (2026-10-06): editable
structure first" (`ExampleBricks`: classes named by purpose — `section`, `container`, `h1`, `text`, `cta-…`), "Figma
colours in Bricks" and "text styles → global classes" (the Figma plugin already does both: reuse its code and its Bricks
shapes — palette, global classes — `reference/bricks/`; never from memory), "Code-method class names start with the
page's name", "Every text is Rich Text except headings" (Figma route), and the memory note
`/home/justin/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/importer-native-structure.md`.

## What Justin asked (2026-11-11)
"I want to implement logic for classes within text and other things. Like for instance, assign a text to a class so if i
change a font of this it should change everywhere it is on the page. If i change a background or color it should
implement the logic everywhere. … I want to make it easier to someone to come in after doing the paste and do changes as
they are linked to classes and styles and all."
His answers: **Full**; **its own job, built after site-no-div** (which turns every remaining Div into Block, Image,
Button, Icon, Heading or Text; planning now: `~/.hermes/plans/figma-to-bricks/site-no-div.md` once written; base job
site-native-structure, branch `site-native-structure-fix3` / `-stack6`); colours as **Bricks Color palette** colours
(variables) the classes use, so editing a palette colour changes every place; shared classes for **text styles,
buttons, sections & cards, spacing & layout**. On buttons: "it depends if it is the same button … i want some buttons to
have different styles" — buttons that look the same share one class; a button that looks different gets its own. And:
**"i want the text to be rich text"** — words on the importer route become Rich Text (headings stay Heading), as on the
Figma route.

## The plan must settle
1. **What shares a class:** how the paste finds "the same look" across elements on every scanned site (equal computed
   declarations per range and state, after the site's own classes; a tolerance or none?), how it names each shared class
   by purpose (`<page>__h1`, `<page>__text`, `<page>__button-primary`, `<page>__card`… — the page-name prefix decision),
   what stays on the element (its own position, a one-off size), and how the shared class meets the site's own copied
   classes today (`src/core/site/classes.ts`, controls at `.cls.brxe-el`; one look must never get two writers that fight).
2. **Text styles:** font family, size per range, weight, line height, letter spacing, case, colour → one class per text
   look, written in Bricks' typography controls (not custom CSS) where a control exists.
3. **Palette:** each colour the page uses (text, background, border, button) becomes a palette colour referenced by the
   classes; the palette paste/import shape Bricks accepts (the Figma route's palette file; "Unverified: the Colors import
   of the panel's palette file" — say how it's proven); colour names; a colour used once.
4. **Sections & cards, spacing & layout:** repeated backgrounds, paddings, corner radii, shadows, gaps and widths as
   classes; how many is too many (a class per pair of elements helps nobody).
5. **Rich Text:** words become Rich Text on the importer route (headings stay Heading, with their tag), what that does to
   inline links and spans; the `emit/rich-text.ts` `asTyped` rule.
6. **The look stays one-to-one** at every captured width (`site:check`, Bricks 2.4.2 and 2.3.9, header, page, footer);
   Figma designs byte for byte; and a test that proves "change it once, it changes everywhere": edit one class or palette
   colour in a paste and every element that had that look changes, none other.
7. Order and overlaps: built after site-no-div (name shared files and what this job assumes from it); media-clickable
   (Background image setting in a class), site-scroll-lock, site-sticky-header, site-menu-motion.
8. **Numbered ACs, AC1, AC2…, each with one named test** (each name whole on one line; a line that isn't an AC's
   definition never starts with a list marker followed by `AC<n>`), all marked **proposed**; one `(live)` AC: Justin
   re-pastes on B-Dry staging, changes the body text font in one class and one palette colour, and the whole page follows.

## Write
`~/.hermes/plans/figma-to-bricks/site-shared-styles.md` (the builder copies it to
`docs/plans/2026-11-11-site-shared-styles.md`): playback in 3 plain lines, questions at the top with ⭐ answers, the
grouping rule, the class and palette design, ACs, touched files, tasks in milestones, a Docs & records task. Evidence
under `~/.hermes/plans/figma-to-bricks/evidence/site-shared-styles/planner/`. Measure on Justin's capture
(`~/Downloads/bdry-test/bdryswi-com-home.f2b-capture.json`, read-only) how many shared classes and palette colours the
rule makes.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/sss/t1`);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close every Chrome you start (by the PIDs of its own
profile path; never `pkill -f`). One plain git command per call, `git -C <absolute path>`. Use `tail -n 3`. Waits under 115
s. SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E
'sending SIG[A-Z]* to process'` first.

## Report (as text)
The plan's path; the playback; the grouping rule; counts on Justin's capture; the ACs one line each (the live one named);
questions with ⭐; then `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
