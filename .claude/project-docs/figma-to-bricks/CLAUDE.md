# Figma to Bricks v2: instructions for every agent

**Status and history:** `docs/HANDOFF.md` (newest first: every feature's section with its rulings, paste check and
follow-ups) and `docs/plans/<date>-<name>.md` with its `-ledger.md`. This file keeps only the current status and the
standing rules. **Don't add build narratives here:** a feature's details go in HANDOFF and its ledger. Only the build
line, one line per new feature, a new standing rule, a user decision or a gotcha every agent needs comes here.

## Status (2026-11-10)

- **Current build `2026-11-10.8`** (read `src/shared/build.ts`; another session may have bumped it). The latest
  features, each with its HANDOFF section:
  - **2026-11-10.8 control-weight (website importer):** on the code route an element its parent reads as an inline
    word at some widths (a link that is a word of its wrapper's line on small tablets, its own painted button
    elsewhere) carries those widths in its own class, at every depth the reading nests (a link's icon and label) and
    across two parents' moves, so Bricks' class control (printed as `.cls.brxe-<el>`) no longer out-weighs the
    parent's rule (the link was `inline-block` and the fixture's hero 28 px taller in the range); where the paste can't
    prove which child is which (a hidden child before it, words beside it, an element the paste doesn't hold) or the
    parent is hidden there, the parent's rule stays as before; pastes without the shape and Figma designs are byte for
    byte as before. Q1 A (Display in the class's Custom CSS for these elements) and Q2 A not yet confirmed. No paste
    check owed (no page of Justin's holds the shape).
  - **2026-11-10.7 panel-embed-code (website importer):** on both routes (the Figma panel's website route and `npm run
    site`) a pasted Code element runs only a widget's own code: the slot's own served markup, a frame's own markup, a
    frame a script made as it showed, or the one frame shown at the slot from the capture's code reading; a floating
    widget's code is pasted only when the file that drew it is a tag the old page served and it drew the box by itself
    (no other file, no code with no file, none of the page's own code on its stack: Justin's "Safe rule"), else it is
    listed with one sentence saying why; a box the site's own script draws through another host's file is rebuilt as
    the site's own only when it holds just the site's links or pictures; what a capture can't prove is an empty box of
    its size (a floating one listed), named; an older capture pastes nothing collected ("capture the page again with
    this build"); the code route's bytes and Figma designs are as before. Not yet confirmed: paste a self-drawing
    served file at all, or always list floating widgets; the "unproven, add it by hand" ruling. Paste check **3dv**
    (AC11, live).
  - **2026-11-10.6 staging-fit-cancels (website importer):** a website paste no longer cancels a declaration at a
    width range with `revert` (it rolled back the whole author origin, so a wrapper's rule at a narrower range turned a
    painted button into a plain underlined link with square corners): a value a range drops is written as bounded media
    runs; classes change only where main wrote such a `revert` (B-Dry's saved home stand-in: 0 left, 18 before); two
    uses stay, named: an Elementor accordion's open look and a slider's `<button>` arrows and dots; the live widget's
    inner box prints as a bounded block too; other pastes and Figma designs are byte for byte as before. Q1 A (only
    classes where a range drops a value change) and Q2 A not yet confirmed. The link a wrapper reads as an inline word at
    some widths painted `inline-block` there until Build 2026-11-10.8 (control-weight). Paste check **3du** (B-Dry's
    hero buttons on phones, after a re-capture).
  - **2026-11-10.5 site-media-upload (website importer):** `npm run site:upload -- <capture> <outDir> <https://site>`
    (`--dry-run`, `--svg`, `--elementor`, `--part`, `--basic-text`, `--user`, `--record`) uploads a scanned page's own
    pictures to that WordPress site's media library with the panel's uploader (each file once, as served, the old
    site's alt in Media; a dry run sends nothing; the password at a hidden prompt; a typed yes), writes media.json and
    the pastes showing the library's pictures; `npm run site … --media <media.json>` remakes them offline; without it
    pastes are byte for byte as before. A stop (Ctrl+C) loses no upload and a re-run uploads no file twice (HANDOFF
    names the rare exceptions); every printed line is scrubbed of anything password-shaped. Q1–Q12 not yet confirmed.
    Paste check **3dt** (AC15, AC16, live: re-capture bdryswi.com, dry run, upload to B-Dry staging, re-paste).
  - **2026-11-10.4 staging-fit-renderer (website importer checks):** the test renderer prints a class's control CSS
    with the element's `brxe` class on the site route and Bricks 2.4.2's front-end CSS, as Bricks prints the page
    (`--bricks 2.3.9` for the older); `site:check -- <capture> --whole` draws header, page and footer together, and a
    picture the capture holds no bytes of (another host's icon) stands in at its img tag's size; new `npm run site:live
    -- <capture> <page address> [--elementor] [--bricks …]` reads a published Bricks page (reads only: everything but
    GET/HEAD/OPTIONS is refused and its Chrome is ended by kill), maps it to the paste and measures it against the
    capture and the renderer's drawing, naming an element the page holds in another's place; pastes and Figma designs
    are byte for byte as before. Paste check **3ds** (AC5, live: `site:live` on B-Dry staging /homev2/ after the
    re-paste).
  - **2026-11-10.3 site-slider (website importer):** with `--elementor`, a captured Elementor carousel (Image Carousel,
    Nested Carousel, Pro's Slides and carousels; either key family) pastes as one Slider (Nestable) holding its own
    slides: the site's timing, loop or fade, pause under the mouse, arrows and dots where the site draws them, per view
    and gap by Bricks' tiers, a slide's own height kept; Bricks' own slider CSS survives the site reset; `site:check`
    holds a slider on its first slide; pastes without such a carousel, the plain route and Figma designs are byte for
    byte as before. Q4 A (tiers) and the `!important` slide height not yet confirmed. Paste check **3dr** (AC10, live:
    B-Dry's hero on staging /homev2/).
  - **2026-11-10.2 site-reviews (website importer):** a captured page's third-party widget whose loader draws it (a
    reviews carousel) pastes as one live Code element at its own place, holding only the slot's own served markup or
    the loader's own tag (never the page's other scripts), so its arrows and swipes work in Bricks once code signatures
    are regenerated; a tag alone counts only where the capture proves it draws the widget by itself, else the still
    copy stays, named; `site:check` stands in for a live widget; the capture hears the page as the server sent it;
    pastes without such a widget and Figma designs are byte for byte as before. The panel's website route pasted the
    whole collected snippet until Build 2026-11-10.7 (panel-embed-code). Paste check **3dq** (AC9, live: B-Dry's reviews on staging /homev2/
    after a re-capture).
  - **2026-11-10.1 site-faq (website importer):** with `--elementor`, a pasted Elementor or ElementsKit FAQ opens at
    load the answers the site opens at the design width (none, one or several; a narrower width that shows other
    answers no longer stops it), and its open look (colour, arrow) follows whichever item Bricks has open, at every
    width and above Bricks' own class controls; pastes without such a FAQ and Figma designs are byte for byte as
    before. Paste check **3dp** (AC8, live: B-Dry's FAQ on staging /homev2/ after a re-capture).
  - **2026-11-09.4 staging-fit-capture (website importer):** a capture reads a width range again when it loaded
    without the site's stylesheets, and stops with one plain line (widths and stylesheet named, no file written) when
    they never arrive; `npm run site`, `site:check`, `capture:check` and the panel refuse a capture holding such a
    range (Justin's 2026-11-09 bdryswi.com capture: 768–991) with "capture the page again"; clean captures and Figma
    designs convert byte for byte as before. Paste check **3do** (AC6, live: re-capture bdryswi.com, re-paste on
    staging, tablets).
  - **2026-11-09.3 elementor-footer-fit (website importer):** with `--elementor`, a widget whose measured box is
    stretched past its body plus inner margins at a captured width keeps its own elements, named (fold rule 9), so
    B-Dry's whole page (header, page, footer) is within 2 px at every width (footer 51.89 px at 1025 before); the plain
    route and Figma designs are byte for byte as before. Paste check **3dn** (AC6, live: B-Dry staging at 1025).
  - **2026-11-09.2 elementor-phone-fit (website importer):** with `--elementor`, a widget whose inner negative margin
    outgrows its body at a captured width keeps its own elements, named (fold rule 8), so B-Dry's page is within 1.02 px
    at every width (7.59 px on phones before); the plain route and Figma designs are byte for byte as before. Paste
    check **3dl** (AC6, live: B-Dry staging at 390).
  - **2026-11-09.1 site-motion (website importer):** the capture (format 3) keeps each `@keyframes` and each element's
    hover and focus looks with their trigger; the code-method paste carries the keyframes under the page's name, keeps
    hover, focus and transition looks, plays entrances once as they come into view through Bricks' own Interaction (an
    entrance that starts hidden takes a type Bricks hides on load; an element that plays one keeps a box; a drawing
    plays from load), and stands still for reduced motion with every entrance shown; older captures and Figma designs
    paste byte for byte as before. Paste check **3dj** (AC13, AC14, live).
  - **2026-11-08.2 capture-speed (website importer):** `npm run capture` reads up to 4 width ranges side by side in
    separate Chrome windows (`--windows <n>`), asks Chrome's matched styles once per element, asks the site for the page
    once per kind of visitor (public addresses), loads a failed page again in the same window and stops with one plain
    line when the connection stays down (a lost connection is seen in the page's own requests too), asks "I am human" at
    most once per kind, and prints `Took …`; the saved B-Dry home captures in 3.4–3.7 min (base 33–35 min), the same
    capture as before. Paste check **3dm** (AC11, live: bdryswi.com under 10 min).
  - **Older builds** (2026-11-08.1 back to 26.1): `~/.hermes/skills/software-development/figma-to-bricks/references/project-status-log.md` → "Older builds".
- **Paste checks owed:** HANDOFF "End-of-run check list" (3c onward); each feature's HANDOFF heading names its check.
  3bj, 3bl, 3bm and 3bq all empty Home and re-paste "Home Page Final" with the header/footer ticks as on the site: copy
  the FAQ answers Justin typed in Bricks first and type them back after. 3bt pastes `after-faq-sections.json` under
  the FAQ on B-Dry's staging /homev2/; 3bs pastes `header-paste.json` into B-Dry staging's Header template. Several
  older pages need a re-paste too (3ac).
- **Milestones:** M0–M4b of the design (`docs/specs/2026-10-06-v2-design.md`) are done. Next: the user's end-of-run
  check, then the sample-bound parts (M2d phone menu, Tabs, Dropdown, Offcanvas, pop-ups).
- **Corpus:** 17 results are worse than v1, all from Bricks' cap of every element at its parent's width (live-site
  looks, not regressions; HANDOFF "Bricks caps every element at its parent's width").
- **Queued CLAUDE.md edits:** `~/.hermes/plans/figma-to-bricks/*-claude-md-pending.md` hold edits finishers couldn't
  write here (builds 21.13 onward). Their history is already in HANDOFF; only standing rules from them belong here.

**The user's live site:** `darksalmon-badger-335429.hostingersite.com` (Hostinger, WordPress, Bricks 2.3.9; LiteSpeed
Cache, WP Mail SMTP, Yoast, WPForms Pro, AltText.ai). After a paste that holds code (lists, card arrows, maps, the
header spacer) the user runs Bricks → Settings → Custom code → **Regenerate code signatures**; after any CSS change,
**LiteSpeed → Purge All**. Read it past the cache with `?f2b=<random>`.

**Files the user works with:**
- `figma-to-bricks-debug-page-1.json` (repo root): "Hydraulic Cylinder Repairs Final" (build 2026-10-20.6, 1728
  wide). `git show 2199895:figma-to-bricks-debug-page-1.json` is "Services Page Final" (the parts inventory: 78 rows,
  search, 6 pills, a 560px scroll box). Ask for a new save when you need another page.
- `docs/data/reman-cylinders.csv`: the 78 cylinders, matching the designer's table row for row.
- `reference/wpforms/`: the WPForms notes and `need-a-repair-559.css`.
- The scratchpad of an older chat is gone or stale; never rely on it.

**Waiting on the user (don't guess these):**
- **Should headings keep Figma's case** when the site theme uppercases them?
- **WPForms:** whether the plugin gets a "Forms become: Bricks form / WPForms" option, and which starts selected. It
  needs their WPForms export file.
- **Rulings to confirm:** the list rules (HANDOFF "Searchable lists"), the form rulings, and every "not yet
  confirmed" ruling in each feature's HANDOFF section.
- **Bricks samples:** Nav (Nestable) for the phone menu (the right copy contains `nav-nested`; a researched sample,
  `reference/bricks/nav-nested.json` from Bricks' code and live sites, stands in until his own copy replaces it),
  Tabs, Dropdown, Offcanvas + Toggle, a working Interaction, a `popover` Div. Never write those emitters from memory.
- **M4b** (Figma Motion as CSS keyframes) is built against Figma's typings only: it needs the user's Motion test file.
- **"Home Page Final"** holds a whole Services page inside its own frame: waiting on Justin's Layers screenshot.

**Known open bugs and limits** (details in HANDOFF):
- **Lists:** card grids (cards in columns, with pills) aren't recognised as lists; deferred minors (the panel's empty
  list name, two lists with desktop + phone frames, the status after Remove, no large-CSV warning, tab-separated
  files).
- **Zooming in (150%+):** contact cards are cramped (at 768 too) and the menu breaks into a grid (needs the Nav
  sample).
- **Space frozen into a fixed-height box:** outside FAQs, a box drawn at a fixed height loses the space under its words
  once they wrap more and from 991px down; a badge pinned to the bottom of such a box lands on its words on phones.
- **Flip cards:** Safari may show a turned-away face's composited children (a `will-change` picture, a video, a CTA's
  fade-in); a divided row of flip cards keeps its lines on tablets and phones.
- **Photo hotspots:** any clipping ancestor can cut a hanging card; long labels may meet on narrow phones. Combining
  `pulse` with CTA/product animations and the generic class name's possible site collision remain follow-ups.
- **Section rhythm:** a drawing pinned beside a closing's buttons or to its top can land on full-width phone buttons or
  a wrapped heading from 478 down (base too; HANDOFF follow-ups).
- **Header tick:** GRO's and brainstorm's nav drawn inside the hero stays in the paste. A strip under a call bar that
  has a picture, four short items and a button is read by its words (two-word menus stay, one-word bands leave);
  Justin wants it read as the main header (follow-up).
- **Fonts:** fonts may load twice (needs a live paste proof); `localeCompare` may sort fonts differently under Figma's
  SES.

**How the user works (see memory too):**
- They answer with screenshots and short messages.
- They want plain, numbered steps naming exactly what is on their screen, one action at a time.
- They expect general fixes. Ask before a design decision with trade-offs (AskUserQuestion with previews worked well).
- They said "build straight through": run each milestone without stopping, and report rulings and deferred minors in
  plain words at the end.

v2 is a clean rewrite of v1 (`~/Desktop/figmaplugin`, read-only reference). The approved design is
`docs/specs/2026-10-06-v2-design.md`; read it before changing the architecture. v1 is the reference for **rules it
learned**, never for its code structure.

## Build general logic, never one-file fixes

This plugin converts **any** Figma file into Bricks, not only the design in front of you. It is used across many
different files by many different designers. Treat every request (a new feature, a bug report, "this section looks
wrong") as one example of a whole class of designs, and change the logic so the entire class converts correctly.

- **Every change goes into the plugin** (Justin, 2026-10-29: "every single change needs to be inside the plug-in, not
  just for copy-pasting purposes"). A fix found on one site's paste (the B-Dry copy of bdryswi.com) is also a general
  plugin change so every converted website gets it; a paste-only patch is at most a stop-gap beside the plugin job. A
  paste-only plan names the plugin code involved and the general rule, or says why the plugin can't be.
- **Prove it on the plugin first** (Justin, 2026-10-29): a problem seen on a hand-built paste becomes a plugin job only
  once a real plugin conversion shows it; until then it's recorded as a suspicion.
- **Fix the rule, not the instance.** When something converts wrong, work out why the logic produced that output and
  change the logic. Don't patch the result for the one file that showed the problem.
- **No hardcoding from the file under test.** Don't key behaviour on a specific layer name, node ID, text string, pixel
  value, colour, font or section order taken from the design you were shown. Detect patterns from structure and
  properties instead: auto layout, constraints, fills, sizes relative to the parent or frame, repetition, clipping.
  Layer names are a hint at most, never the only way a feature is recognised; many designers never rename layers.
- **Think about the variations before you write code.** Ask what other designs will reach this code path: other frame
  widths, deeper or shallower nesting, missing or extra layers, mixed auto layout and absolute positioning, groups
  instead of frames, other breakpoints, empty or very long text. Handle them, or fall back to safe output.
- **Don't regress other files.** Fixing one design must not break another. Run `npm run check` and add a test
  for the new pattern, built as a generic fixture rather than a copy of the user's file.
- **If a special case is truly unavoidable, say so first.** Explain why the request can't be generalised and ask
  before adding a targeted exception. The exception must detect a condition that could occur in any file, never
  a particular file.

## Architecture rules (from the design; don't break them)

- **Pipeline:** `extract → normalise → understand → style → adapt → emit`.
  - Only `src/plugin/extract/` calls `figma.*`.
  - Everything in `src/core/` is pure and runs in Node on a Snapshot (the debug file).
- **No stage edits an earlier stage's output.** No element changes type after it is made, and no content is converted
  twice. If a later stage needs something, the earlier stage that knows it must record it in its output.
- **CSS stays typed** (`{bp, state, part, decls, origin}`) until `emit` serialises it once.
  - Never regex or string-match CSS.
  - A value that has a Bricks control goes in that control's key; the rest goes in one `_cssCustom` per element.
- **Only `src/core/adapt/rules/` writes breakpoint styles.** Every declaration records which rule wrote it. Two rules
  writing the same node, breakpoint and property fail a test unless one lists the other in `overrides`.
- **Rules read sizes from the page scales** (`PageFacts`); they never multiply numbers themselves.
  - Each rule is one file in `src/core/adapt/rules/` with a `decision` line saying which user rule or spec line it
    carries out.
  - `RULES` (`rules/index.ts`) runs in order: a rule that overrides another must come after it.
  - A rule writes only what changes at a breakpoint, never the desktop value. The one exception is the `fluid` tier
    (below the design width, above tablets): emit folds its values into the desktop value as a `clamp()` exact at
    the design width, and puts its custom CSS in `@media (max-width: W−1px)`.
  - A tier that goes back to the designed value writes it explicitly: Bricks cascades tablet → sideways phones →
    upright phones, so writing nothing keeps the narrower tier's squeeze.
  - Widths at a tier come from the layout plan (`ctx.layout`, `src/core/adapt/layout.ts`): each layer's room and
    width, each row's shape and each grid's columns. Rules read it; they never estimate widths themselves.
  - A flip card is judged by its front (`ir.ts` `faceOf`, shared by `recognise.ts`, the layout plan, `adapt/least.ts`
    and `hero-pair.ts`): anything reading a layer's room or kind reads the front; its back adds nothing.
  - Shared behaviour goes in one purpose-named class the style stage makes and a rule fills: `text-balance`,
    `text-pretty` and `tap-area` are the plugin's own.
  - A design drawn for phones (selected beside the desktop one) runs only the rules marked `fits` (they keep a
    drawing whole around its width) and `shows` (the swap). The engine drops the desktop copy's phone-tier writes
    then. A new rule that only keeps shapes or lines whole sets `fits`. `ctx.design` says which design a rule is
    running on; `drawn.scale` runs only on the phone design.
  - Phone-only copies (sliders, the hero's buttons band, intro buttons) are made only at understand
    (`src/core/understand/phone.ts`, keys `copy:<purpose>:<key>`), never by a later stage. `phone.swap` shows them
    and hides their originals at `mobile_landscape`.
- **Breakpoints, media queries and gutters are defined only in `src/shared/breakpoints.ts`.**
- **Ids are deterministic** (a hash of the IR key). The same snapshot must give a byte-identical payload.
- **Keep files small and single-purpose.** If a module grows past roughly 300 lines, split it by responsibility.

## Working in this repo

- **A size change made after Figma must reach the layout plan as a planned width.** Shares and row shapes read
  drawn widths unless the earlier pass records growth (`IRNode.giveWay`, `grownAlong`, `plannedWidth`, `rowGapAt`).
  Counting grown words only in `least()` can make laptops wrap rows tablets keep (label-floor, GRO's hero).
- **Space drawn next to a part the site already has stays** (`designs.ts` `keepBeside`): leaving the header or footer
  out never takes the gap beside it.
- **Bricks prints a linked Image as its link** (`<a id class="brxe-image … tag"><img>`, `a.brxe-image{display:inline-block}`);
  `test/browser/render.ts` follows it since 2026-11-03 — browser receipts that measure a linkable picture run both
  picture modes.
- **Git, with a private GitHub copy** (user, 2026-10-19; this replaces the earlier "no git"):
  `github.com/Just-In-N-Out/FigmaToBricksV2`, branch `main`. The main folder stays on `main`, and it's the copy Figma
  loads (`manifest.json` → `dist/`).
  - **Never commit CLAUDE.md:** it's listed in `.git/info/exclude`. Check `git diff --cached --name-only` before every
    commit.
  - **Commits:** plain `git commit -m "…"`, with no `Co-Authored-By` or AI lines and no author override.
  - **Pushes go as Just-In-N-Out** through this repo's own credential helper (`.git/config`, a `gh auth token --user
    Just-In-N-Out` call). The Mac's active `gh` account is Justin-Leorna, used by other projects: never switch it, and
    don't change the remote or the helper.
  - **Not in git (rebuilt by tools):** `node_modules/`, `dist/`, `corpus/out|paste|compare/`, `corpus/report-v2.json`.
- **Every bug or feature runs the orchestrated pipeline** in the first section of the global `~/.claude/CLAUDE.md`
  (user, 2026-10-23): the session only orchestrates; fresh `general-purpose` agents with their role's model and effort (the
  global file's role table) plan, build, review, fix, verify and audit, and `ac-check.sh` decides when every AC is accepted. Never plan, build or review in
  the session itself (this replaces the single-session `superpowers:writing-plans` flow). This repo's specifics:
  - **Start:** in a terminal in the main folder, `claude -w <feature-name>` (`.claude/worktrees/<feature-name>` on
    branch `worktree-<feature-name>`, with what `.worktreeinclude` lists: this file, `node_modules/` and v1's corpus
    output). One session per feature, so no agent sees another's half-done work; two or three features at a time,
    touching different stages or rules, or merges get harder.
  - **Plan:** `docs/plans/<date>-<name>.md` (in git, not `~/.hermes/plans`), numbered AC1, AC2… with one test each
    (`implementation-planning`).
    **Standing auto-go** ("no stop between plan and run"): show the plan message (questions with ⭐ answers, proposed
    and `(live)` ACs) and dispatch the builder at once, taking the ⭐ answers, unless the user replies **stop** or
    changes something. Make the read-only copy first: `mkdir -p <evidence> && install -m 444 <plan>
    <evidence>/plan-approved.md`. Evidence goes in `~/.hermes/plans/figma-to-bricks/evidence/<name>/`.
  - **Build and review:** the builder keeps a ledger in `.superpowers/sdd/<plan>/progress.md` and runs `npm run
    corpus` before Task 1 and at the close. Then two fresh full reviews, each on the model and effort the global
    routing gives its round (global CLAUDE.md "Agent models"), with a fix pass after each (each fix test first), then
    the verifier, the blind AC auditor and `ac-check.sh`, looping until every AC is accepted (global CLAUDE.md steps
    5–6).
    **Review rounds are capped** (Justin, 2026-10-31: "I need this to be built fast"; memory `review-round-cap`):
    every AC is still met and accepted with no cap, but review → fix rounds stop after 3 in all (1–2 for major bugs,
    the rest for the main edge cases); what a later review would still find goes to `follow-ups.md` and HANDOFF
    "Deferred". This overrides the global "no round cap" for review rounds only. **Website importer, tightened
    (2026-11-02: "focus on building and not too much of edge cases"):** one review per job, reporting only bugs a
    real site or normal use hits; edge cases go straight to follow-ups; a second review only to check a major fix. The review diff is `git diff main...HEAD` in the copy, or `git diff <commit before the
    milestone>` on `main`.
  - **Rules for every agent in a copy:**
    - Run `npm run check` and `npm run corpus` there.
    - Commit to the branch after each passing task. The branch stays on the Mac: don't push it (merges are local).
    - Don't bump `BUILD`, and don't edit the main folder.
    - Don't edit the copy's CLAUDE.md: it's a snapshot from the start, deleted with the copy. Status notes go in
      `docs/HANDOFF.md` and the ledger, which are in git.
    - Never use bare `git stash`: the stash list is shared by every copy.
  - **Finish, once `ac-check.sh` says ALL ACCEPTED or READY FOR THE USER** (no need to wait for the user), as the
    global "Worktrees from `claude -w`" says:
    1. **Finisher agent, in the copy:** move the ledger to `docs/plans/<plan>-ledger.md`, commit everything, then
       `git rebase main`. On a conflict keep both sides' meaning; HANDOFF sections usually both stay. Run `npm run
       check` and `npm run corpus` again on the rebased branch: two features that pass alone can break together. It
       stops and reports the new HEAD. If HEAD now differs from the head `ac-check.sh` accepted, global CLAUDE.md
       step 7 decides what runs before step 2 (agents don't start agents): a rebase receipt carries the earlier
       reports only when HEAD is a pure rebase of the accepted head. The ledger commit made here before the rebase
       is a patch that head lacks, so HEAD is not a pure rebase of it and the session takes step 7's full path on
       the new head: a fresh review of what the accepted head lacks, then verifier → auditor → `ac-check.sh`.
    2. **Session: leave the copy.** Call the ExitWorktree tool with action `"keep"` (the user's standing permission).
       Claude Code refuses git commands and edits aimed at the main folder from inside a copy (`git -C …`
       included), so the merge runs from the main folder. If ExitWorktree finds no worktree session, EnterWorktree
       with `path` set to the main folder; only if both fail, give the user the one `!` merge command and say why.
       Then, in the main folder: `git merge --ff-only worktree-<feature-name>`. If it refuses, main moved (go back
       into the copy with EnterWorktree and its `path`, repeat from 1) or the main folder has uncommitted changes
       (stop and tell the user). Never force it.
    3. **Finisher agent, in the main folder:** bump `BUILD` (read it first), `npm run build` (Figma loads that `dist/`),
       commit "Build <BUILD>: <feature>" and `git push` (`main` only). Then update this file's **Status** (the build
       line, one line for the feature with its paste check) and add any new standing rule or user decision to the
       sections below; everything else goes in HANDOFF. If writing this file is refused, leave exactly those lines in
       `~/.hermes/plans/figma-to-bricks/<name>-claude-md-pending.md`.
    4. **Session:** check that `git log --oneline main` shows the feature's commits, then tell the user it's merged,
       with every ruling and deferred minor in plain words and any `(live)` ACs owed. When they close the session,
       Claude Code offers to delete the copy; the branch goes with `git branch -d`.
  - **A quick fix the user asks to do right here** (no pipeline, a session started without `-w`) is committed
    straight to `main`, by file, before the next merge.
- **Setup:** TypeScript + esbuild. Dev dependencies only: `typescript`, `esbuild`, and the type packages
  `@figma/plugin-typings` and `@types/node`. No runtime dependencies; the browser tools use Node built-ins and the
  system Chrome.
  - `npm run build` writes `dist/code.js` and `dist/ui.html`, which `manifest.json` loads.
  - `npm run watch` rebuilds while you work.
- **The panel** (`src/ui/`): DOM-free modules plus `main.ts`. Browser features (fetch, image decoding, canvas, Web
  Workers) go through `src/ui/env.ts`, so tests stand in for them (`test/fixtures/panel.ts`).
- **The website importer's helper:** the panel reaches the importer helper only at `http://127.0.0.1:47811` with its
  pairing code; Figma desktop runs with Chrome's LocalNetworkAccessChecks off (Figma in a browser can't reach it). The
  helper binds 127.0.0.1 only and never writes to a site.
- **The importer never hides that its Chrome is automated** (no `AutomationControlled` flag, no `navigator.webdriver`
  patch, no new user agent, no stealth script, nothing that clicks or types into a site's check): a person passes a
  person check in the visible window (web-human-check).
- **`npm run site:live` only reads a published page** (staging-fit-renderer): its Chrome refuses every request but
  GET/HEAD/OPTIONS, with Chrome's own report uploads off, and is ended by killing its process group, never asked to
  close (a closing page sends its goodbye POSTs); it stops at a login page and never signs in. A tool that loads a
  user's site keeps to this (`tools/lib/read-only.ts`).
- **One tool writes to WordPress: `npm run site:upload`** (Justin, 2026-11-10: a scanned page's pictures "upload
  to my Wordpress media library like how it is in the plugin", run "From the command line"). It only adds media
  items (never changes, moves or deletes one; never touches pages, posts or settings), only on the site whose
  address was typed, after reading that site and a typed `yes`; the Application Password is typed at its hidden
  prompt and never goes in an argument, a variable, a file, the paste or a log. Only Justin runs it, in his own
  terminal, against his own site. Agents never run it against his site or any live site, never ask for or hold his
  password, and test it only against `test/fixtures/wp-standin.ts`. Every other tool (capture, the helper, site,
  site:check, compare, replay) stays read-only; the helper still binds 127.0.0.1 only and never writes to a site.
- **The plugin's conversion** (`src/plugin/convert.ts`) must stay byte-identical to `npm run replay` for the same
  snapshot (`test/unit/plugin-convert.test.ts`).
- **Checks:** `npm run check` runs typecheck, build and the unit and rule tests. Tests use `node --test` on `.ts` files
  directly (Node 22 type stripping), so use only erasable TypeScript syntax: no `enum`, no `namespace`, no parameter
  properties.
- **Build number:** bump `BUILD` in `src/shared/build.ts` (`YYYY-MM-DD.N`) for every change the user will load in
  Figma. Read the current value first, because another session may have bumped it. In an agent's copy, leave it: the
  merge into `main` bumps it ("Finish", step 3).
- **Code Figma runs (`src/core`, `src/plugin`, `src/shared`) uses only the language's built-ins.** Figma's plugin
  sandbox has no `URL`, `URLSearchParams`, `TextDecoder`, `TextEncoder` or DOM. A web class inside a `try` fails
  quietly in Figma while Node tests pass (sandbox-urls). Use the pure stand-ins: `model/url.ts` for addresses,
  `plugin/extract/text.ts` `utf8` for bytes. `npm run typecheck` (`tsconfig.sandbox.json`) and
  `test/unit/sandbox-convert.test.ts` enforce it. When a live paste lacks what replay shows, diff the panel's copy
  (`pbpaste` right after Convert) with `npm run replay` first.
- **Figma's sandbox (SES) refuses to open the plugin** when `import` is followed by `(`, `//` or `/*`, or when `<!--`
  or `-->` appears anywhere, even in comments. `build.mjs` checks the bundle and fails on these; never end a comment
  line with the word "import".
- **Bricks swaps pasted pictures for its grey placeholder** unless the paste's `sourceUrl` is the site's own
  address (`bricksData.siteUrl`; read in Bricks 2.3.9's builder code, `reference/bricks/README.md` "Paste rules").
  Only `image`/`image-gallery`/`svg` elements whose image has an `id` are swapped. A paste with WordPress pictures
  must name that site (`siteAddress`).
- **A WordPress upload attached to no page owns the address `/<its file name>/`,** and since WP 6.4 that address
  redirects to the file. So the panel's uploads always end in `-image`/`-video`, and a link is never a picture or
  video file (`payloadProblems` refuses one). One attached to a page is at `/<page>/<name>/` instead.
- **A link never sits inside another link** (flip-cards, 28.1): the browser ends the outer link where the inner one
  starts. It is a test-only invariant (`emit-nested-links`: every fixture, the flip cards' linked shapes, every corpus
  page), never a paste refusal: a refusal broke pastes main made. Add every new link producer to that test.
- **WordPress's `font-families/<id>/font-faces` answers every face on the site,** whatever its family
  (`wp_font_face` isn't hierarchical, so the posts controller filters by no parent). Keep only the faces whose
  `parent` is the family (`site-fonts.ts`). A stand-in for WordPress answers as WordPress does, read from its code or
  a real answer, never from what the code expects.
- **A text's weight includes its imported typography class.** Resolve the element plus `_cssGlobalClasses` before
  saying a Figma weight is missing; never copy working class typography onto every element.
- **A usable same-family/slant variable face covers static uploads inside its range.** A dropped variable needs one
  existing usable variable spanning its whole range; isolated statics and partial overlaps don't count.
- **Font notes name the weights supplied, never promise the font the browser picks.** Keep Figma's family and
  weight; say "unknown" when no same-style source is confirmed. A Google stand-in answers like Google (HTTP 200 with
  a weight missing); a forced HTTP 400 retry test says it's failure injection.
- **Font weights in a paste are single whole hundreds.** Bricks copies every font weight it finds beside a Google font
  in the page, custom CSS included, into its one Google Fonts link (`bricks-google-fonts-css`). Google refuses the
  whole link (HTTP 400) for a range such as `100 900`, and every Google font Bricks loads on that page is lost
  (header, footer, Theme Style). Never write a weight range or a non-number weight in a paste.
- **Font weights the plugin uploads or reads are standard hundreds (100…900).** A file's in-between OS/2 weight
  (a Thin at 250) gives way to its style name.
- **Bricks' editor doesn't run a pasted Code element's script** (2026-10-22, read from the live page against the
  user's editor screenshot): the header spacer, lists and card arrows only work on the live page or Preview. The
  user's header template is being made sticky (HANDOFF check 3bi), so the editor shows the page below it too.
- **The user never tested v1's WordPress mode** (2026-10-07): v1 is no reference for uploads or the paste's media.
- **Bricks gives every Block `width: 100%`.** A layer that should size from `left` and `right` needs `_width: "auto"`;
  deleting `_width` isn't enough.
- **Bricks gives pasted elements new ids,** rewriting each id only inside its own element (`reference/bricks/README.md`
  "Ids on paste"). Never name another element's id in custom CSS or a script: a look that follows another element
  names it by a marker class (`trigger-<hash>`), and scripts find elements by class (test `emit-paste-ids`).
- **Bricks caps every element at its parent's width** (`[class*=brxe-]{max-width:100%}`): a moving row needs
  `max-width: none`, and every width taken from Figma's box grows by a text's trailing letter-spacing
  (`style/tracking.ts`).
- **Bricks wraps every Section, Container and Block from 767px down** (its front-end CSS): a row the layout plan keeps
  on one line there writes `_flexWrap: "nowrap"` (`row.reflow`); the renderer copies the wrap.
- **A website paste never cancels a declaration at a width range with `revert`** (staging-fit-cancels): `revert` rolls
  back the whole author origin, so it also beats the element's own class and controls. A value a range drops is
  written as bounded runs (`src/core/site/blocks.ts`); the only `revert`s left are the site-reset class's own, an
  accordion's open look and a slider's button parts (`test/fixtures/site-drops.ts` `excepted`;
  `test/unit/site-no-revert.test.ts` fails on any other). A job that changes what a site paste writes on purpose makes
  `test/fixtures/site-no-revert-main.json` again on its own tree (`node tools/site-no-revert-golden.ts .`).
- **Bricks writes text controls as given:** Flex basis numbers go out in px (`flex-basis: 323` is CSS the browser
  drops); `payloadProblems` refuses a bare one (`reference/bricks/README.md` "Text controls").
- **An empty global class is `settings: []`,** as Bricks keeps it; `{}` makes Bricks ask "Import classes" on every
  paste.
- **Bricks' Form prints labels only with `showLabels`** and the star only with `requiredAsterisk` (both off by
  default); its button Width setting doesn't reach the page, so custom CSS spans it.
- **Figma gives a plugin only a video's `videoHash`** (its SHA-1), never the file, and its PNG export draws no video
  frame, so a video fill has no poster. The site sends no CORS header on uploads, so videos are matched by name.
- **Every link kind** (an element's link or a text run's) goes through `emit/page-addresses.ts` and the panel's
  `ui/site-pages.ts` `relink`; addresses typed in Figma are never changed.
- **Layout keys depend on the element.** `_direction`, `_rowGap`, `_columnGap`, `_flexWrap` and the grid keys work only
  on section, container, block and div (`LAYOUT_ELEMENTS` in `emit/payload.ts`). Any other element's are
  `_flexDirection` and `_gap` (`reference/bricks/README.md` "Layout keys by element"). `payloadProblems` fails on the
  rest.
- **Never write Bricks' `_alignSelf: "stretch"`.** Bricks adds `width: 100%` to it, after the element's own width
  (`reference/bricks/README.md` "Align self: stretch"). A row whose items all fill its height, or whose boxes are drawn
  the same height, uses `_alignItems: "stretch"`; any other stretch goes in custom CSS (`emit/settings.ts`).
  `payloadProblems` fails on it.
- **Figma's switched copies pair layers by name.** They carry text into a same-named layer of the other variant (a
  description pushed into a title), so only the words an instance really changed count.
- **Bricks element shapes come from `reference/bricks/*.json`,** canonical samples the user copied out of their Bricks
  install. Write native-element emitters against those samples, never from memory. Re-capture them when Bricks is
  upgraded.
- **Test fixtures built from one column inside a section can surprise you.** A section's only child that spans it
  becomes the section's Container (or a band when painted), and its label disappears. Give such fixtures a sibling
  (a text above) when a test looks the box up by label. An auto-layout `column`/`row` fixture hugs its flowing
  children: a wrapper holding an absolute layer needs its own width and height, or it is only as wide as its words.
  Texts in the scene carry no fills (their colour is in the text data), so a "painted" check never counts plain words.
  A page column of only two parts reads as one section: give a fixture page three. `vector(name, opts)` ignores `fills`
  (spread it and set `fills` after); a hover becomes a hover copy (`overlay`) only for a change CSS can't draw, such
  as an icon's colour.
- **An element's own custom CSS never writes `display`** (icon-buttons, 2026-11-04): Bricks prints `#brxe-<id>{…}`
  after the control CSS, so it beats every tier `_display: none` a rule writes (phone.swap, compose.hide, the menu
  fold). Bricks' `.bricks-button` already gives a Button `inline-flex`, centring and gap.
- **Words elements hold a `<p>` since rich-text** (`div.brxe-text > p`): browser tests measure the inner `p`
  (`el.querySelector(':scope > p') || el`); `Range.selectNodeContents(el).getClientRects()` also returns the `p`'s own
  box (one line too many) and `el.firstChild` is the `p`, not the text node.
- **Rich Text HTML always goes through `emit/rich-text.ts` `asTyped`:** Bricks prints Rich Text through
  `parse_editor_content` (wptexturize + wpautop), so `asTyped` writes the designer's quotes, dashes, dots and `x` as
  numeric entities and breaks `<br><br>` with `<wbr>`; `test/browser/editor-content.ts` models it in the renderer. A
  saved edit in Bricks' rich editor may turn the entities back into plain characters.
- **`test/browser/render.ts` lacks Bricks' `.brxe-block{align-items:flex-start}`:** a browser receipt that depends on a
  Block being a block box injects that rule itself, or a dropped-`_display` mutant survives.
- **Shell quirk:** typing the escape text for U+2028/U+2029 in a shell command turns it into the raw character, which
  breaks regex literals. Write such escapes with `String.fromCharCode(92)` or edit the file with the Edit tool.

## Debugging a user's design

- **Ask for a debug file** (the panel's "Save debug file"): `figma-to-bricks-debug-*.json`. Check its `build` and root
  frame name first, because users re-save it from other pages and builds. v1 debug files load through
  `src/core/snapshot/upgrade-v1.ts`.
- **Inspect:** `node tools/inspect.ts <debug.json> [outDir]` prints what the file holds and writes Figma's pictures.
- **Replay (from M1):** `npm run replay -- <debug.json> <outDir>` writes `bricks.json`, the warnings and Figma's
  renders.
- **Browser check:** `npm run snap -- <debug.json> <outDir> [widths] [--sides] [--detail] [--placeholders]` renders the
  payload the way the user pastes it (pictures inside, vectors as their own SVG, photos as stand-ins). For each width
  (390, 768, 1024, 1440 and the design width) it prints each section's height against its Figma frame and the lint,
  and writes a shot. `--sides` writes Figma-vs-built pictures of every section at the design width.
  - It drives the system Chrome over CDP (`test/browser/chrome.ts`), so viewports are exact at any width. Browser
    tests drive a touch screen with `Page.touch` / `Page.tap`, never `Input.synthesizeTapGesture` (headless, it sends
    no mouse events).
  - `--site[=header,footer]` converts with the panel's ticks; `--header=<px>[,<phone px>]` adds a fixed stand-in site
    header.
- **Wrapped one-liners:** `npm run wraps -- <debug.json> [widths]` lists one-line Figma texts that wrap on the page.
  - The layout lint (`test/browser/lint.ts`) reports overflow, clipped or overlapping text, tiny type, distorted
    pictures and content missing on phones.
- **Corpus:** v1's three real debug files plus the hydraulics page and the GRO homepage (v2 files in `corpus/files/`;
  GRO is drawn entirely without auto layout, at 1440); paths in `corpus/corpus.json`. Never hardcode anything from
  these files.
  - `npm run corpus:baseline` records v1's numbers in `corpus/baseline.json`, with shots in `corpus/out/v1/`. v1
    can't read v2 files, so hydraulics and GRO have no v1 numbers.
  - `npm run corpus` runs v2 and prints lint errors and warnings per width. It fails when any width is worse than
    the baseline; until M2 is done, phones are expected to be worse than v1.
  - Re-record the baseline whenever the lint changes, so both sides are measured the same way.
- **Prove a new test catches the bug:** with the fix committed, `git checkout HEAD~1 -- <the fix's source files>`,
  check that the test fails, then `git checkout HEAD -- <those files>`.
- **Before saying it's fixed:** replay the user's file and look at it at every width, check the lint report, and run
  `npm run corpus` to make sure the other files didn't get worse.
- **Phone checks for the user:** put the paste file on their clipboard with `pbcopy < corpus/paste/<design>/bricks.json`.
  Then give one action at a time (paste into an empty page, Cmd+S, preview narrow), and say that the photos in replay
  files are grey stand-ins; real photos come from running the plugin in Figma.
- **The renderer only approximates Bricks.** The live page is the final judge. User screenshots are usually the Bricks
  editor, where clicks select elements, empty elements get a 90px minimum size, and stacking can differ from the
  front end. The editor may not draw some placehold.co stand-in photos (a different set on each load); check the
  saved page's preview before blaming the layout.

## Decisions the user made (don't reverse without asking)

- **Interactions use native Bricks elements** (2026-10-06, replaces v1's radio/`:has()` CSS approach).
  - Details: `~/.hermes/skills/software-development/figma-to-bricks/references/project-decisions.md` → "Interactions use native Bricks elements".
- **On tablets, a grid of cards stays on one row rather than leave one card alone below the others** (user,
  2026-10-16: "the third form goes into a new line. I need them all horizontal").
  - Details: `~/.hermes/skills/software-development/figma-to-bricks/references/project-decisions.md` → "A grid of cards stays on one row on tablets".
- **Other states of a component show the variant as designed.**
  - **Look comes from the variant:** fills, outlines, effects, corner radii, text colours and text styling.
  - **The instance keeps only its real content:** words and photos that differ from its own main component, layers it
    hides, padding and spacing.
  - **Colours changed on the instance for the page are not carried over,** even though Figma's prototype player and
    Figma's own switched copy carry them.
  - **Figma's switched copies** are used only for layout and for pairing layers.
- **Hover styles vs. states:** use CSS hover styles only where they draw the change exactly:
  - flat colours, outline colour, corner radii and shadows;
  - the text's weight, slant, spacing, case and underline, the same over the whole text.

  Anything else (a gradient, a photo, stacked paints, an icon's colour, a change of font or size) is built as states.
  Compare what shows: a colour by its value, a picture's placement to within a pixel.
- **Placed layers follow their Figma constraints** when the box isn't the design's width:
  - Center → `_left: calc(50% ± …px)`;
  - Right → `_right`;
  - Left & Right → `_left` + `_right` + `_width: auto`;
  - Scale → percentages.
  - **Figma's default Left on a layer in the right half** (2026-10-07, user): it stays against the right edge, keeping
    its distance to it, so it doesn't slide out when the box is narrower than designed. A layer deliberately pinned
    another way follows that constraint. At the design width nothing changes.
- **Stacking keeps Figma's layer order.**
  - Page content never rises above its section's level (z-index 1 at most).
  - A hovered component is contained with `isolation: isolate` and never gets a z-index, so a layer Figma paints above
    it stays above it.
  - Only floating layers go above the page: open dropdowns (50, lifting their ancestors while open), fixed layers (90),
    a sticky header (100) and pop-ups (9999).
- **Layout:** one Container per section, 1440px max with gutters 64 / 36 / 16. Bricks default breakpoints:
  tablet_portrait ≤991, mobile_landscape ≤767, mobile_portrait ≤478.
  - Details: `~/.hermes/skills/software-development/figma-to-bricks/references/project-decisions.md` → "Layout".
- **Faint outlines around pictures on a photo** (user, 2026-10-22: "a subtle white border outline around it … needs
  to be removed", then chose "Only over a photo" over "every faint photo frame" and "remove it in Figma"): a
  see-through box with a faint outline around a picture loses the outline only where it is drawn on a photo; boxes on
  plain backgrounds, filled cards and divider lines keep theirs, as drawn (`normalise/photo-frames.ts`).
- **Swapped cut-outs stay whole** (Justin, 2026-10-30: "I need this fix on all pages … It should be a plug-in fix"; he
  swaps the plugin's pictures in Bricks for his own cut-out photos of other shapes): a picture whose file has
  see-through parts and which Figma shows whole is `object-fit: contain`; solid or cropped photos keep `cover`
  (HANDOFF "Cut-outs stay whole when swapped").
- **Native Buttons by shape alone** (2026-10-06): a painted box around one short centred label becomes a Bricks Button,
  linked or not and whatever its name. Form fields (words starting at the left) and table cells (a rule on one side)
  aren't buttons. Tags and pills of the same shape may become Buttons; the user accepted that. A pill of words and one
  or two drawn SVG icons (one each side at most, beside the words, in its middle) is a Button too, its icons its
  ::before/::after from their Figma SVG (icon-buttons Q1 A, not yet confirmed; emit/button-icons.ts); inside a link it
  is a Button with no link (Q2 A). A pill under 44px whose own hover changes its icon or more than CSS draws stays a
  Div.
  - Details: `~/.hermes/skills/software-development/figma-to-bricks/references/project-decisions.md` → "Native Buttons by shape alone".
- **Every text is Rich Text except headings** (Justin, 2026-11-04, on the designer's "rich text for paragraphs": "I do
  not want it for paragraph i want it for everything"; chose in a question): Bricks Heading stays, with its tag; a text
  that is all one link is Rich Text inside a Block that carries the link in Link to (both designer notes hold); no
  Basic Text is emitted.
- **Pictures inside the paste (2026-10-07, v1's embed mode back):** the panel's "Pictures go: inside the copied JSON
  (for testing) / to WordPress" starts on "inside the JSON".
  - Inline, every picture (photos as chosen, shrunk to 2x the size they show at; icons as PNG or SVG) travels as data.
  - The choice reaches the conversion (`ConvertOptions.inlinePictures`): pictures are built as Divs with the picture as
    a CSS background (Bricks drops data from its Image element and background control), never swapped afterwards.
  - Each Div keeps the drawing's shape (`aspect-ratio`) and a picture's minimum width (`min(Wpx, 100%)`), and is pinned
    against the editor's 90px empty-box size.
- **Drawn phone designs** (user, 2026-10-08): designers sometimes draw the page twice, desktop and phone.
  - Details: `~/.hermes/skills/software-development/figma-to-bricks/references/project-decisions.md` → "Drawn phone designs".
- **Phones and tablets are generated from a desktop-only design** (designers draw desktop only). Desktop must stay
  exact at the design width; below it the page is fluid, and the rulebook (`src/core/adapt/rules/`) adapts it. The
  user calls the hero "the header". Phone rules (2026-10-01, kept on 2026-10-06):
  - Details: `~/.hermes/skills/software-development/figma-to-bricks/references/project-decisions.md` → "Phones and tablets are generated from a desktop-only design".
- **Typed line breaks** (user, 2026-10-21, L1A L2A): in a text box of fixed width (Figma's fixed or auto-height box),
  typed breaks that only copy Figma's own wrap go out as spaces, so the words wrap by the box on every screen, never
  by the screen's width. A text hugging its words keeps its breaks from the design width up and loses them below.
  Breaks that are the designer's (items like addresses and hours, a sentence a line, headings, a line the next word
  would have fitted on) stay. Only prose goes soft (finisher's ruling under the user's auto-go; `style/rag.ts`).
- **Free-floating designs on phones** (the user, 2026-10-07; designs drawn without auto layout):
  - Details: `~/.hermes/skills/software-development/figma-to-bricks/references/project-decisions.md` → "Free-floating designs on phones".
- **Website rules** (2026-10-02: HTML5 semantics, WCAG 2.2 AA, search and speed basics; the user means technical
  rules, not laws). The design stays as drawn except for the two label minimums below and the section rhythm
  (Layout):
  - Details: `~/.hermes/skills/software-development/figma-to-bricks/references/project-decisions.md` → "Website rules".
- **Open question for the user (not decided):** a hover component inside a link keeps its phone tap control, so on
  phones a tap shows the hover and the link doesn't open. Ask before changing it either way.
- **Picture descriptions in the panel** (user, 2026-10-07): a "Picture descriptions (N missing)" list after each
  conversion (photos and drawings, not icons or backgrounds), with Decorative and Show.
  - Save keeps them in the Figma file (document plugin data `f2b-alts`, by image for photos, by layer otherwise) and
    sends them to WordPress for pictures already there.
  - Bricks shows the media library's alt (verified on the live site), so the paste carries no `altText`.
- **AI picture descriptions with alttext.ai** (user, 2026-10-14):
  - Details: `~/.hermes/skills/software-development/figma-to-bricks/references/project-decisions.md` → "AI picture descriptions with alttext.ai".
- **Figma colours in Bricks** (user and their manager, 2026-10-14):
  - Details: `~/.hermes/skills/software-development/figma-to-bricks/references/project-decisions.md` → "Figma colours in Bricks".
- **Forms** (user, 2026-10-16: "make the contact form and the Yes/No interactive"): a drawn form becomes Bricks' Form.
  - Details: `~/.hermes/skills/software-development/figma-to-bricks/references/project-decisions.md` → "Forms".
- **Call and email links** (user, 2026-10-19: "whenever there's a call … button, the plugin will automatically use it
  as a hyperlink and will identify the phone number"):
  - Details: `~/.hermes/skills/software-development/figma-to-bricks/references/project-decisions.md` → "Call and email links".
- **A text that is all one link carries it in Link to** (the designer Niklas, through Justin, 2026-11-04; ⭐ answers
  not yet confirmed): email `mailto:`, phone `tel:`, a whole Figma link or page link go in the element's Link to
  (External URL), never as an `<a>` in its words; a link inside a sentence stays inline; headings too
  (`understand/text-link.ts`, `elementLink(ir)`).
- **Links to pages** (user, 2026-10-19: "whenever there's a hyperlink icon … or 'take me to this' … it will
  automatically implement the hyperlink … to that page", named after "the sentence before it"; build `2026-10-19.17`).
  The user chose, in questions:
  - Details: `~/.hermes/skills/software-development/figma-to-bricks/references/project-decisions.md` → "Links to pages".
- **Footer destinations** (Justin, 2026-11-04, option A): belonging to a footer column never supplies a destination;
  unauthored labels stay plain with one note per included affected Figma design. Source element/text/ancestor links,
  captured hrefs and existing independent contact/social/arrow/go-word rules keep their own policy; structural
  membership, headings and omission remain. Genuine page labels need a link in Figma or Bricks.
- **The site's own header and footer** (user, 2026-10-20: "if there is already a header and footer in bricks then the
  plugin will remove the header and footer"):
  - Details: `~/.hermes/skills/software-development/figma-to-bricks/references/project-decisions.md` → "The site's own header and footer".
- **Social icons link to the business's profiles in Yoast SEO** (Justin, 2026-10-30, chose "From Yoast" over a panel
  box or links set in Figma; build `2026-10-30.20`): the panel reads Yoast's Other profiles when connected and saves them
  in the file; small icons named after a network link to them. HANDOFF "Social icons link".
- **Fonts not on Google Fonts** (user, 2026-10-20: "the fonts will be put on WordPress automatically like a drag
  them"): files, a folder or a .zip dropped on the panel go to WordPress's own Font Library (`wp/v2/font-families`),
  chosen over Bricks Custom Fonts (admin-ajax only, not in REST) plus a helper plugin. It needs an Administrator's
  Application Password. Every paste carries `@font-face` rules for the design's families, after Google's.
- **Videos** (user, 2026-10-19: "just do what v1 did"): an address in the layer name (`Video: https://…`) or an Open
  link to a video makes Bricks' Video, muted and looping where it is a background behind words. Without one, the
  panel finds the file in WordPress Media by its exact name, or the user chooses it in the panel's Videos box.
- **Website captures** (Justin, 2026-11-02, on the capture plan, confirmed; HANDOFF "Capturing a live page"):
  - **A part's own fixed content stays in its part** (AC4, "Keep it in the Header"): a sticky header bar stays inside
    its part's root, marked `web.position: "fixed"`; every other fixed box (chat bubbles, plugin buttons, the site's
    own call button, cookie bars) goes to the footer part's floating extras.
  - **bdryswi.com's pages are a live check owed to him** (AC14/AC15, "Mark it mine, merge now"): its bot check stops
    every automated Chrome, so every sitemap page is captured and checked only once he allow-lists the capture; AC14
    covers the other corpus sites' homes.
  - **A pasted Code element runs only a widget's own code** (panel-embed-code; Justin, 2026-11-10, "Panel widget code
    go" and, for floating widgets, "Safe rule"): never a tracking tag, a tag manager, a loader, a shared library,
    another widget's script or a page script. A floating widget's code is pasted only when the file that drew it is a
    tag the old page served and it drew the box by itself; anything started by a starter script, a tag manager or the
    page's own script is listed with a plain note (add its install code by hand). Where a capture can't prove a
    widget's own code nothing is pasted to run. Both routes read `src/core/snapshot/embed-code.ts`.
- **The website importer copies the site's own code** (Justin, 2026-11-04: "I want a method that can help us get one
  to one, not relying on photos or images but actual code"; method review
  `~/.hermes/plans/figma-to-bricks/evidence/method-review/report.md`): a site's elements, classes and CSS rules go into
  Bricks as they are; the measured-box route through the Figma converter is retired for websites once the whole page
  passes.
- **Code-method class names start with the page's name** (Justin, 2026-11-07, "Never use bare names", then "Prefix
  every name"): `<page>__<name>`, only `site-reset-<4>`, `site-fonts`, `site-text`, `site-flat` keep theirs; a static
  slider keeps all its slides ("Keep all its slides").
- **A scanned page's pictures go to WordPress from the command line** (Justin, 2026-11-10, "From the command
  line", Full pipeline; ⭐ not yet confirmed, Q12 open, HANDOFF "A scanned page's pictures go to WordPress's media
  library"): its own command `site:upload` (Q1 A); the password at a hidden prompt each run, never saved (Q2 A); every
  picture the site's own markup shows, each file once, script-made ones and `data:` left (Q3 A); no file in the
  capture: its old address (Q4 A); SVG only with `--svg` (Q5 A); files as served, never re-encoded (Q6 A); the old
  site's first alt with words in Media, an alt in WordPress never changed by a re-run (Q7 A); no alttext.ai (Q8 A); a
  record per computer at `~/.config/figma-to-bricks/site-uploads.json` (Q9 A); https, the site read first, a typed yes
  (Q10 A); a stopped run keeps what went up, the next sends the rest (Q11 A).
- **Lists a visitor searches and filters** (user, 2026-10-19): "In the page" (the plugin pastes every row and a small
  script; no WordPress post type) and "Spreadsheet in the panel" (a CSV per list, kept in the Figma file).
  - **On tablets and phones** (user, 2026-10-19, screenshots at 990/766/477: "whenever there's a panel, it looks clean
    and nice on mobile, mobile landscape, and tablet"; build `2026-10-19.15`):
    - "One line per record" on tablets and phones held sideways, the titles over their columns, the search full width
      with the pills under it from the left;
    - "Compact card" on phones: no titles; the first column with the last at its right, the others under them with a
      dot between.
- **Photos as AVIF (when chosen):** never fall back silently to WebP or the original; stop and explain.
- **Phone slider:** `height: "auto"`, never Bricks' `autoHeight`; a hidden slider measures 0px.
- **Output style (2026-10-06): editable structure first.** `ExampleBricks` (repo root, one Bricks 2.3.9 copy per line)
  is the user's hand-built version of a real page, and the target for what v2 emits:
  - Bricks settings instead of custom CSS (v1 put custom CSS on 84% of its elements; the example on 7 of 151);
  - classes named by purpose (`section`, `container`, `h1`, `text`, `cta-…`), not by font;
  - native `button` (with its icon), `icon`, `divider`, `accordion-nested`, `slider-nested`, `carousel`, `video`;
  - a shallow tree. Custom CSS only where Bricks has no setting. Desktop looks like Figma but isn't pixel-pinned.
- **Phone sliders are copies (2026-10-06):** the desktop row hides on phones and a phone-only Slider Nestable holds
  copies of its items, as the user builds them by hand ("Card-Desktop" / "Card - Mobile").
- **Kept features:** WordPress upload (REST + Application Password), AVIF/WebP, Figma Motion, Google Fonts, text
  styles → global classes, debug file. **Deferred** (2026-10-06): tablet designs (a third drawn width), the audit
  list, masks, and v1's Figma timer loops that slide logos. Don't build these unless the user asks.
- **Unverified in Bricks:** anything not in `reference/bricks/`. Check it with a paste-and-copy-back round trip first:
  custom tags, `_attributes`, `_cssId`, `link.newTab`, `display: contents`, `%root%` in custom CSS, Block
  `tag: "nav"`, Image `altText`/`loading`, and `aria-*`/`fetchpriority`/`tabindex` attributes.
  - Also unverified:
    - `_flexDirection` and `_gap` on non-layout elements;
    - the Colors import of the panel's palette file;
    - a palette reference whose `raw` carries a fallback (`var(--x, #HEX)`).
