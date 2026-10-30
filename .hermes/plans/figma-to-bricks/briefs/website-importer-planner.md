# Planner brief: website importer proposal (brainstorm, no build)

**Role:** planner (fresh Opus 5.5, xhigh). You write a **proposal**, not a build plan, and you never change the repo.
The main session only orchestrates; it already asked Justin five questions (answers below). You can't ask Justin
anything yourself: put every further question at the top of the proposal with your ⭐ recommendation.

**Skills to load:** `engineering-best-practices`, `implementation-planning` (Skill tool). Read the project skill
directly with Read: `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (it isn't linked into Claude
Code). Not a bug, so no `systematic-debugging`.

**Write only:**
- the proposal: `~/.hermes/plans/figma-to-bricks/website-importer-brainstorm.md`
- probes, notes and saved pages: `~/.hermes/plans/figma-to-bricks/evidence/website-importer/planner/`
Nothing in `~/Documents/FigmaToBricksV2` (read only: no edits, no commits, no `npm run build` writing `dist/`), no
WordPress writes, no clipboard changes. Live reads of public pages (bdryswi.com, other sites for comparison) and web
research are fine.

## Justin's request (full text)

`~/.hermes/plans/figma-to-bricks/briefs/website-importer-brainstorm-prompt.md`. Read it first: it lists what to read
(repo `CLAUDE.md`, `docs/specs/2026-10-06-v2-design.md`, the hand capture in
`~/.hermes/plans/figma-to-bricks/evidence/bdry-source/` and its lessons) and the seven things the proposal must cover.
Also read the memory notes `bdry-home-copy.md`, `plugin-first.md` and `corpus-paths-on-desktop.md` in
`~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/`, and skim the B-Dry fix plans in
`~/.hermes/plans/figma-to-bricks/` (`services-band-speed.md`, `quote-button-hover.md`, `hero-logo-size.md`,
`sixty-years-marker.md`, `fee-band-photo.md`) as the list of things a website import got wrong by hand.

## Justin's answers so far (2026-10-29), binding for the proposal

1. **Straight to Bricks.** Site → Bricks paste. No Figma redesign step; changes are made in Bricks afterwards. Keeping
   the site's animations, sliders and hovers matters more than editing in Figma.
2. **The old site's own layout at every width.** The importer measures the site at desktop, tablet and phone widths,
   and **one copy** of the content gets each width's own sizes; the plugin's phone rules only fill gaps. (Not the
   two-copy "drawn phone design" path, not desktop-only.)
3. **Command + panel.** Justin (or Claude) runs one command with the site's address, which writes a capture file.
   Justin drops that file on the plugin panel in Figma, which then does what it does today: pictures and fonts to
   WordPress, picture descriptions, Copy.
4. **Widgets: embed or rebuild.** Third-party widgets (reviews like Trustindex, chat, booking) go in with their original
   embed code in a Code element (Regenerate code signatures; some accounts must allow the new domain). Forms become
   the plugin's Bricks Form and maps the plugin's map. The panel lists each one.
5. **Page by page.** One page per import. The site's header and footer come out as their own pastes once, for Bricks'
   header/footer templates; later pages of the same site leave them out automatically.

Justin also asked, in his words, "how will the importer do all this? Are we copy-pasting the URL? Is it an
application?" The proposal needs a short plain-words **"What you'd do"** walkthrough near the top: what he types or
clicks at each step, what he sees, what he gets back.

## What the proposal must settle (beyond the prompt's seven points)

- **The Snapshot is Figma-shaped** (`src/core/snapshot/schema.ts`: frames with auto layout, text segments, image fills
  by hash). Say how a web page becomes those nodes (and what's lost or must be added to the schema): CSS flex/grid →
  auto layout/grid, absolute → constraints, wrappers folded, text runs, image fills plus the picture bytes the panel
  needs (it can't fetch the old site's files itself), hover and animation sources.
- **Answer 2 against the architecture:** only `src/core/adapt/rules/` writes breakpoint styles, from page scales and
  the layout plan. How do the site's measured per-width values reach Bricks without breaking that (a recorded fact in
  an earlier stage plus a rule that writes it, with `overrides`?), which tiers it maps to (Bricks 991/767/478 vs the
  site's own breakpoints, Elementor 1024/767), and what happens where the site and the plugin's rules disagree.
- **Answer 3 against the panel:** what the panel must gain to open a capture file instead of a Figma selection (the
  conversion, picture bytes, the debug-file path), and which of its features then work unchanged.
- Approach comparison (A importer / B website-to-Figma tool / C anything better): research the real tools available
  now (for example html.to.design, Builder.io's importer, anything Figma itself offers) instead of from memory, and
  say what each would keep and lose for Justin's answers.
- A **first version** small enough to build and prove on bdryswi.com's Home, with **numbered proposed acceptance
  criteria** (`- AC1 (proposed): …`, `(live)` right after the id for checks only Justin can do), one named test each,
  measured against the live site at 1920/1440/1024/767/390.
- A rough size: how many separate pipeline jobs (each one planner → builder → reviews → verifier → auditor), in what
  order, and which can run in parallel.
- Keep it general: any site Justin copies, not bdryswi.com. Name every place a rule could key on one site and say how
  it's avoided.

Feasibility probes are welcome where they decide a recommendation (for example: can headless Chrome read bdryswi.com's
Elementor header/footer templates, hovers and lazy images at 390?). On this machine use the Chrome wrapper from
`corpus-paths-on-desktop.md` (`CHROME_PATH=$HOME/.cache/chrome-for-testing/chrome-f2b`), keep probe scripts in your
evidence folder, and cite what each probe showed.

Write in plain words for Justin (short sentences, no jargon without a one-line explanation), with the technical detail
a future planner needs in clearly marked sections.

## Report back

- The proposal's path, its recommendation in three lines, its questions with ⭐ answers, and its proposed ACs one line
  each (marking `(live)` ones).
- `skill_lessons[{skill, lesson, evidence, enforce}]`: reusable lessons only (a gotcha, an approach that worked after
  one failed, a skill step that was wrong or missing); `enforce` is `none` or a one-line proposal for a check (its kind,
  what it checks, where it runs). An empty list is normal. Never edit skills or memory yourself.
- End the report with: `MAIN SESSION: check and save these skill_lessons now.`

## Amendment 1 (2026-10-29): Justin's final answers, chosen for the most faithful one-to-one copy

Justin: "The most important thing is that this implementation works so it can get every page and turn it into a
one-on-one copy", then "change the recommendation or the answers to … produce the best 1-1". He chose "Go": update the
proposal, then wave one starts, with milestone 2 straight after the first version (no "later").

Final answers to the proposal's questions:
1. **Scope:** A's order (layout first), but milestone 2 (hovers, entrance animations, sliders/accordions, forms, flip
   boxes, hotspots, pop-ups) is committed and built straight through after it: one job list, nothing optional.
2. **The plugin's Figma-only additions:** A, off (faithful copy; the invisible website rules stay).
3. **Widths where the site and Bricks switch differently:** **C, exact at every width**: the paste carries its own CSS
   for those ranges (e.g. bdryswi.com's 992–1024 tablet and 1025–1366 laptop layouts), no setup on the new site.
   Changed from A.
4. **Device-only copies:** A, keep both, each shown where the site shows it.
5. **Fonts that fail on the old site:** A, the real face (a failed font's fallback differs per visitor's machine, so
   there is no single fallback look to copy).
6. **Floating extras (chat, accessibility button, cookie bar, badges, floating call buttons):** **keep them, once per
   site with the footer part** so they show on every page as on the old site: third-party ones as their original
   embed code (as answer 4 of the first round), the site's own floating elements rebuilt. Listed in the panel. Changed
   from A.
7. **Ownership check:** A. 8. **Bricks Migration Engine:** A.

Further requirements for fidelity:
- **Prove more than bdryswi.com's Home:** the ACs must cover several pages of bdryswi.com and at least one site built
  with something other than Elementor (name candidates and how they are chosen without hardcoding).
- **Between measured widths**, follow the site's own stretchy sizes (%, vw, clamp, auto, fr, max-width) where the
  capture can read them, so in-between widths match too, not only the measured ones; add an AC for it.
- **Motion and hover timings** (duration, delay, easing, trigger, once/repeat) are read exactly from the site and
  compared by the compare tool (the B-Dry "animations too fast" class of bug); in the milestone 2 ACs.
- **Forms** become the plugin's Bricks Form styled to look like the old form, measured.

Update the proposal (record the answers, revise the recommendation, the jobs, the ACs and the size), then split wave
one into its jobs with one brief-ready section each (J0 compare tool, J1 capture core: goal, ACs, files, what it
hands to the next wave) so their planners can start from it. Report as before, with the revised ACs one line each.
