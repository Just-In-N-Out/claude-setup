## Shared context for the four bdry animation features (2026-10-26)

**Why these features exist.** Justin is copying the home page of an old Elementor site (https://bdryswi.com/, a
basement-waterproofing company) into a new Bricks site (bdry.staging.growithgro.com) as a hand-built Bricks paste.
His standing instructions for such copies say, for animations:

> For each animation on the source page, first check whether the plugin already makes it. … Where it doesn't: add it
> to the plugin as a general feature, not a one-page patch. Run it through the pipeline … Follow the repo's CLAUDE.md:
> general logic for any design, and "Only Figma's animations". So the plan must say what in a Figma file turns the
> animation on (Figma Motion, a prototype animation, or a mark I approve), and ask me when the designer has to mark it.
> A Bricks shape not in `reference/bricks/` (for example an Interaction that plays when scrolled into view) needs a
> sample: ask me to set one up in Bricks and copy it to you, before the builder writes that code. After it's merged
> into `main`, build that animation in the page's paste exactly as the plugin emits it.

Four animations on that page are missing from the plugin; Justin chose (2026-10-26) "Plugin features first": he gets a
paste now with them standing still, and a second paste once each feature is merged. The four features, each planned
by its own planner in its own worktree at the same time: **slider-autoplay**, **headline-marker**, **flip-cards**,
**photo-hotspots**. Say in `overlaps` which files you expect to share with the other three, so the orchestrator can
order the builds.

**The feature is for any Figma file, not for bdryswi.com.** The plugin converts Figma designs; the Elementor page only
shows the behaviour Justin wants. Design the Figma-side trigger (what a designer draws or sets up in Figma that the
plugin recognises) from structure and Figma's own prototype/Motion data, never from layer names, texts or values of
this page (repo CLAUDE.md "Build general logic, never one-file fixes"). If no Figma mechanism can express it, propose a
mark and put it to Justin as a question.

**Source capture** (read-only, already taken): `~/.hermes/plans/figma-to-bricks/evidence/bdry-source/` (README there):
the page HTML with Elementor's inline CSS and popup templates, the Elementor tree with every widget's data-settings and
box at 1440/1024/767/390, and screenshots. Use it for the exact source behaviour (timings, easing, sizes); do not
re-fetch the site unless something is missing.

**Machine notes (Linux/WSL desktop, not the Mac):**
- The project skill is not linked into `~/.claude/skills`: read it with Read at
  `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its `references/rules-summary.md` first, then only
  the main-folder CLAUDE.md sections you need (the copy in your worktree is a snapshot of it). Claude Code memory for
  this project: `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/` (read `corpus-paths-on-desktop.md`:
  `npm run corpus` finds no files here, measure `corpus/files/*.json` directly; plan the builder's corpus checks that
  way).
- Chrome: `export CHROME_PATH=$HOME/.cache/chrome-for-testing/chrome-f2b` (a wrapper with its libraries). Browser tests
  without it are skipped silently.

**Planner rules.** PLANNER only: load, in order, the project skill (Read, above), `engineering-best-practices`,
`implementation-planning`, then any specialist skill your area needs. No code, tests, commits or site writes. Write the
plan to `docs/plans/2026-10-26-<feature>.md` inside your worktree (this repo's plans live in git; the builder commits
it), with: the open questions first (right after the title, each option lettered, the recommended one marked ⭐, each
under ~60 characters), then the playback, approach, numbered acceptance criteria **AC1, AC2…** each with its test by
name whole on one line (none were given, so mark them **proposed**; tag `(live)` right after the id only for what only
Justin can check in Bricks or on the live site, e.g. `- AC5 (proposed) (live): …`), tasks test-first, the parts of the
code it touches, risks, a `## Skills` section, and a final **Docs & records** task (plan, ledger
`.superpowers/sdd/<plan>/progress.md` → `docs/plans/<plan>-ledger.md`, `docs/HANDOFF.md` section with the next free
paste-check id, BUILD at the merge, the main folder's CLAUDE.md "Start here"/"Where things stand"/"Decisions" after the
merge). Write the plan as if the ⭐ answers were chosen. Evidence you gather goes in
`~/.hermes/plans/figma-to-bricks/evidence/<feature>/planner/`.

**Bricks shapes.** Native element keys come only from `reference/bricks/*.json` (and `ExampleBricks`) or Bricks'
official schemas the repo already uses (academy.bricksbuilder.io/schema-resolved/elements/<element>.json, as
`video-schema.json` and `form-schema.json`). Anything else is unverified: the plan must name the sample Justin has to
make in Bricks and copy back (plain, numbered steps naming what is on his screen, one action at a time), and the
builder must not write that code before the sample is in `reference/bricks/`. Custom CSS on an element names only its
own `#brxe-<id>` or classes (Bricks renames ids on paste). Code elements need Bricks' "Regenerate code signatures";
prefer CSS-only behaviour where it does the job.

**Report.** Answer in plain words. You can't ask Justin anything: put questions in `questions`. If you find any other
bug or problem, don't fix it: list it in `found_else` (one line each, evidence, severity) and in an "Other things
found" section of the plan. If you learn something reusable (a gotcha, an approach that worked after one failed, a
skill step that was wrong or missing), don't edit any skill or memory file: list it in
`skill_lessons[{skill, lesson, evidence}]` (an empty list is the normal answer). Return
`{name, plan_path, playback, summary, choices[], questions[{q, options[], recommended}], acs[], live_acs[], samples_needed[], risks[], touches[], overlaps, found_else[], skill_lessons[]}`
and end your report with `MAIN SESSION: check and save these skill_lessons now.`
