# Role: read-only auditor: structure-parity — does the Figma plugin build in Bricks everything the website importer will, and the other way round?

You are a fresh research agent (**Opus 5.5, high**). **Read only:** change no file in the repo, commit nothing, start no
agents, run **no tests and no Chrome** (the PC is at its agent limit; reading only). Never load any live site; never
write to any WordPress site; read-only on `~/Downloads`.

Load the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`. Read the repo's
`CLAUDE.md` (main folder `/home/justin/Documents/FigmaToBricksV2`, `main` at Build 2026-11-11.3).

## Justin's question (2026-11-11)
"can you double check that the figma plugin has everything that the website importer will have in regards to structure?
Similarly can you check the web importer has the figma plugin everything it has?" — "structure as in the way it was set
up in Bricks": the Structure panel tree (which Bricks element types, how they nest, how deep), Structure-panel labels,
classes (global classes, names, shared/purpose classes), colours (palette), Bricks settings/controls vs custom CSS, links
(Link to), pictures (Image with a media id, Background image setting), native interactive elements (Button, Slider,
Accordion, Offcanvas/Toggle, Nav, Tabs, Form, Video, Icon, Divider), sticky header, motion/interactions.

## The two converters
- **Figma plugin:** `src/core/` pipeline (extract → normalise → understand → style → adapt → emit), emitters in
  `src/core/emit/`, decisions in CLAUDE.md "Decisions the user made" and
  `~/.hermes/skills/software-development/figma-to-bricks/references/project-decisions.md`; target `ExampleBricks` (repo
  root). To see real output, read saved pastes (e.g. `corpus/paste/*/bricks.json` if present, or evidence folders) — don't
  run replay.
- **Website importer (code method):** `src/core/site/` on main, **plus what the jobs in flight will add** — read their
  approved plans and branches (`git -C … show <branch>:<path>`):
  - site-native-structure (branch `site-native-structure-stack6`; plan
    `~/.hermes/plans/figma-to-bricks/evidence/site-native-structure/plan-approved.md`)
  - site-no-div (`~/.hermes/plans/figma-to-bricks/site-no-div.md`), site-shared-styles
    (`…/site-shared-styles.md`), media-clickable (`…/media-clickable.md`, branch `media-clickable-build`),
    site-sticky-header, site-scroll-lock, site-menu-motion (`…/<job>.md`, branches `<job>-build`).
  Justin's newest importer paste: `~/Downloads/bdry-test/paste/` (`page.json`, `header.json`, `footer.json`, `notes.txt`).

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/structure-parity/report.md`:
1. A table per direction, one row per structure feature: **Figma plugin has it?** (file:line or paste evidence) /
   **Importer has it (main)?** / **Importer will have it (which job)?** / **Gap** — one of: same; missing in plugin;
   missing in importer and in no plan; differs (say how); not applicable (say why — e.g. a Figma file has no site
   script, a website has no Figma component variants).
2. Where both have a feature but build it differently in Bricks (e.g. text styles as global classes vs shared classes
   named `<page>__…`; palette naming; Rich Text rules; when a link becomes a Button; how pictures carry media ids;
   labels), say which is closer to Justin's "built in Bricks, not copied" and his ExampleBricks.
3. A short ranked list of real gaps worth a job (each one line: what, which side, why it matters to Justin), and
   anything already planned that would make the two sides diverge further.
Plain words; every claim with a file:line or a paste path.

## Report (as text)
The report's path; the gap list in short; then `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal;
never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
