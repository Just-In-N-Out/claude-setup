# bdry-demo: one hand-built Bricks paste of B-Dry's home page, for the demo (Mini, time-boxed)

Planner: Fable 5.2 high, 2026-11-11. Time box for the whole job: 2 h to 2 h 30. Builder: about 75 minutes.
A demo deliverable, **not a plugin change**: nothing under `src/` changes, no BUILD bump, `dist/` stays main's.

## Questions (each answered with the ⭐ option; Justin's standing auto-go)

- **Q1 Route.** ⭐ A: start from the newest earlier hand-built paste and add what it lacks (a footer, the old site's
  picture addresses), then fix the biggest measured differences. B: build fresh from the saved page (300 elements by
  hand: doesn't fit 75 minutes). C: carry the site's own HTML in Code elements (exact, but shows as code in Bricks,
  not editable: not what he wants to show).
- **Q2 Two headers on staging.** The page on staging also draws the site's own Bricks header and footer templates.
  ⭐ A: the paste holds header, page and footer as he asked ("One paste"); his steps say to switch the page's own
  header and footer off for that page. B: leave header and footer out of the paste.
- **Q3 A picture whose old-site address can't be proven.** ⭐ A: it keeps staging's Media copy (it shows on staging
  too), and is named in `pictures.json`. B: stop.
- **Q4 The ☰ menu.** ⭐ A: stays out: the button is drawn and doesn't open (a follow-up; `reference/bricks/offcanvas.json`
  is there now). B: build it now (doesn't fit).
- **Q5 Where the files live.** ⭐ A: the scripts and a copy of the paste are committed on the builder's branch under
  `test/demo/bdry-home/` (no file name holds `.test.`, so no gate runs them); the hand-over files go to the evidence
  folder; merging the branch is optional and bumps nothing. B: evidence folder only.
- **Q6 How close is "one-to-one".** ⭐ A: every section's top and height within 4 px of the saved page at seven
  widths; at most 5 named leftovers, none over 24 px, listed for Justin. B: 2 px, no leftovers (not honest in 75 min).

## Playback

1. Justin wants a safety net for the demo to his manager: B-Dry's home page as one copy-paste for Bricks that looks
   like bdryswi.com on desktop, tablet, phone sideways and phone upright, made by hand, not by the importer.
2. One paste (header + page + footer), built from the saved copy of the page on this PC, pictures at bdryswi.com's
   own addresses, pasted into B-Dry staging (Bricks 2.4.2).
3. Done in 2–2.5 h: so it reuses the hand-built paste of 2026-10-29 and proves the look by measuring it against the
   saved page.

## The route, and why (evidence: `evidence/bdry-demo/planner/facts.md`)

- **Start file:** `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/v5/quote-button-hover/out/bdry-home-with-header-quote.json`
  — 271 elements, native (21 sections + Header, 47 headings, 21 buttons, a Slider (Nestable), an Accordion (Nestable),
  62 blocks; custom CSS on about a fifth). On today's main: `payloadProblems: []`, 0 placeholders, 0 CSS naming
  another id (`bdry-paste/check.ts`, run 2026-11-11). Its parts were already pasted on staging (v3, after-FAQ, header).
- **It lacks:** a footer (no earlier paste has one); pictures at the old site's addresses (they are staging Media
  ids now); `version` 2.4.2; a whole-page measurement at 7 widths (earlier checks covered parts: the after-FAQ
  sections matched at 1024, `v4/shots/compare-real-paste-1024.png`).
- **The saved page has everything to measure against:** `web-code-proof/planner/inputs/bdry-2026-10-29/` (`home.html`
  with `data-elementor-type` header, wp-page, footer and 5 pop-ups; `css1.css`, `css2.css`; 47 pictures at
  `bdryswi.com`, 13 at `i0.wp.com`). The 2026-11-04 captures hold the pictures' bytes (`images`), so both sides can
  be drawn with real pictures without asking the old site for anything.
- **Elementor's tablet starts at 1024, Bricks' at 991:** the start paste already carries its own tablet sections
  ("Services (tablet)", "Service cards (tablet, phone)"); the measurement at 1024 and 768 says whether they switch
  where the site does. A switch at 1024 goes in custom CSS `@media (max-width: 1024px)` on that element only.

## Rules for the builder (hard)

- Never load bdryswi.com, i0.wp.com, cdn.trustindex.io, B-Dry staging or any live site: the check's Chrome answers
  every request itself (127.0.0.1) or refuses it; only `fonts.googleapis.com` / `fonts.gstatic.com` may be reached
  (as `test/browser/fonts.ts` does). No logins, no WordPress writes, no `npm run capture|site|site:import|site:upload`.
- Start every Chrome through `test/browser/chrome.ts` with its own profile under `~/.cache/bdd/`; close it by the
  PIDs of that profile; never `pkill`. `TMPDIR=~/.cache/bdd/t1`. `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`.
- The paste is made only by `build-demo.ts` (start file in, edits as code, paste out): never hand-edit the JSON.
- Bricks shapes only from `reference/bricks/*.json` and `reference/bricks/README.md` ("Paste rules": a picture
  without an `id` is left alone on paste — `{url, external: true, filename}` as `test/browser/render.ts`
  `placeholder()` writes it; "Layout keys by element"; "Align self: stretch"; "Ids on paste"). Repo `CLAUDE.md`
  "Working in this repo" facts hold. Font weights single whole hundreds.
- No change under `src/`, `dist/`, `manifest.json`, `tools/`, existing tests; don't bump `BUILD`.
- Mini: if it can't fit, don't loop: stop at minute 75 and report the numbers (see "Stop rule").

## Acceptance criteria (all proposed)

Checks are scripts in `test/demo/bdry-home/` of the builder's worktree, run from the worktree root; each writes its
log to `~/.hermes/plans/figma-to-bricks/evidence/bdry-demo/checks/`. Paste = `evidence/bdry-demo/bdry-home-demo.json`.

- AC1 (proposed): the paste is one file whose root sections are the Header first, the page's sections, the Footer last; `payloadProblems` is `[]`; pasted into `https://bdry.staging.growithgro.com` it gets 0 placeholders; no custom CSS or script names another element's id; `version` is `2.4.2` and `sourceUrl` is staging's address.
  Check: `node test/demo/bdry-home/demo-paste-shape.ts`
- AC2 (proposed): every picture in the paste (Image elements, backgrounds, `url()` in custom CSS) is at an address the saved page itself names (bdryswi.com or its i0.wp.com copy) and carries no `id`; any picture kept on staging's Media is named in `pictures.json` with its reason, 3 at most.
  Check: `node test/demo/bdry-home/demo-pictures.ts`
- AC3 (proposed): desktop (Bricks' base, 992 and up): at 1440 and 1024 every section's top and height in the paste, drawn by the repo's renderer with Bricks 2.4.2's CSS, is within 4 px of the same section of the saved page served from this PC.
  Check: `node test/demo/bdry-home/demo-fit.ts 1440 1024`
- AC4 (proposed): tablet (991 and down): the same at 768.
  Check: `node test/demo/bdry-home/demo-fit.ts 768`
- AC5 (proposed): phone sideways (767 and down): the same at 767, 600 and 479.
  Check: `node test/demo/bdry-home/demo-fit.ts 767 600 479`
- AC6 (proposed): phone upright (478 and down): the same at 390.
  Check: `node test/demo/bdry-home/demo-fit.ts 390`
- AC7 (proposed): at all seven widths the pasted page never scrolls sideways (the document is no wider than the screen) and no section is empty (height 0) unless the saved page's is.
  Check: `node test/demo/bdry-home/demo-no-overflow.ts`
- AC8 (proposed): the hand-over set exists: one side-by-side picture per width (saved page left, paste right, 7 files) and one per section at 1440 in `evidence/bdry-demo/shots/`, `PASTE-STEPS.md` (Justin's numbered steps) and `gaps.json` (the named leftovers, 5 at most, none over 24 px, each with its section, width, pixels and one plain line).
  Check: `node test/demo/bdry-home/demo-handover.ts`
- AC9 (proposed): while the checks run, their Chrome sends no request to any host but 127.0.0.1, fonts.googleapis.com and fonts.gstatic.com (every other request is answered from this PC or refused, and the log of AC3–AC8's runs shows it).
  Check: `node test/demo/bdry-home/demo-offline.ts`
- AC10 (proposed): the plugin is untouched: `git diff --stat main...HEAD -- src dist manifest.json tools` is empty and `npm run check` passes as on main.
  Check: `node test/demo/bdry-home/demo-plugin-untouched.ts`
- AC11 (proposed) (live): Justin pastes the file into an empty page on B-Dry staging, saves, and the page looks like bdryswi.com's home on desktop, tablet, phone sideways and phone upright.
  Check: `Justin's paste on staging, by PASTE-STEPS.md`

**What `demo-fit` measures.** `sections.json` pairs the paste's root sections (by label) with the saved page's
(header, each top-level `.e-con.e-parent` of the wp-page by `data-id`, footer); two paste sections that stand for one
site section (a desktop one and its tablet copy) are one pair, measured by their joined visible box. Fails on any
pair over 4 px in top or height unless `gaps.json` names that section and width; fails when `gaps.json` holds more
than 5 entries or one over 24 px. Leaving tops: a top is compared after taking off the gap already counted above it
(so one tall section isn't counted again in every section below). The Reviews section is compared by top only (its
inside is another company's live widget; both sides draw a stand-in box of the saved page's height).

## Tasks (builder, about 75 minutes; skills: `figma-to-bricks`, `engineering-best-practices`, `test-driven-development`)

1. **Set up (5 min).** In the worktree: read this plan, `reference/bricks/README.md` "Paste rules", `bdry-paste/check.ts`,
   `bdry-paste/v4/test/render-lib.ts`, `web-code-proof/planner/probe/standin-probe.ts` (how the saved page was served).
   Copy the plan to `docs/plans/2026-11-11-bdry-demo.md`.
2. **The measuring rig first (15 min).** `test/demo/bdry-home/`: `serve.ts` (the saved page from files: scripts
   dropped, the two CSS bundles at their `_jb_static` addresses, pictures from the capture's bytes or a grey stand-in
   of the tag's size, the same answer for the same address on both sides, a log of every request and what answered
   it); `fit.ts` shared by the checks; `sections.json`. Run `demo-fit` on the **start file** at the seven widths and
   keep `checks/fit-start.log`: the checks fail first (no footer, staging pictures), and it names the worst gaps.
3. **Pictures and header facts (10 min).** `build-demo.ts`: each picture → the old site's address (`pictures.json`:
   file-name match first, then the same place in the page from `bdry-source/tree-1440.json`); `version`, `sourceUrl`;
   fonts as the saved CSS names them. This step makes AC1 and AC2 pass.
4. **The footer (15 min).** Built from the saved page's footer, native (Section, Container, Blocks, Heading, text,
   links with `{type: "external", url}`, Image), its stacking at 1024/767 as the site's CSS says.
5. **Fix the worst gaps first (20 min).** In the order desktop → phone upright → phone sideways → tablet, each fix an
   edit in `build-demo.ts`, re-measured. A Bricks setting where one exists, custom CSS on the element where not.
6. **Hand-over (10 min).** Shots, `PASTE-STEPS.md`, `gaps.json`, all ten checks run once more, `npm run check`,
   commit (`git diff --cached --name-only` shows no `CLAUDE.md`), report `ready-for-review` with head and the numbers.

**Stop rule.** At minute 75 stop fixing. Leftovers within the limit go in `gaps.json`. If more than 5 sections or
any over 24 px remain, don't hide it: report `ready-for-review` with the failing AC named and the table of numbers;
the session shows Justin and he decides (ship as is for the demo, or one more fix round).

**Review and check (about 40 min).** One review (real bugs only: a broken paste shape, a picture that won't show, a
check that can't fail, a request leaving the PC), then verifier and blind auditor as the Mini pipeline says. Docs and
records: one HANDOFF line is **not** needed (no plugin change); the session notes the file's place in its report.

## What stays out (one plain line each, for Justin)

- The ☰ menu button is drawn but doesn't open a menu.
- The site's pop-ups (5) and floating buttons (chat, call) aren't in the paste.
- The reviews strip is the reviews company's own live widget in a Code element: it shows once you press "Regenerate
  code signatures"; the check can't measure its inside.
- The hero slides and the FAQ are Bricks' own Slider and Accordion (they move and open), not the old site's scripts,
  so their timing and animation are Bricks'.
- Entrance and hover animations are only the ones the earlier paste already has; none are added.
- The header is part of the page (it scrolls away); it isn't a sticky site header template.
- Up to 5 small leftovers (24 px at most) may remain, each named in `gaps.json`.

## Justin's paste steps (the builder writes them out in `PASTE-STEPS.md`, one action a line)

1. On B-Dry staging: Pages → Add New → name it "Home demo" → Publish → Edit with Bricks.
2. In this PC's terminal the file is put on the clipboard for you (the session does it and reads it back through a
   UTF-8 file); or open `bdry-home-demo.json`, select all, copy.
3. In Bricks: click the empty canvas → Ctrl+V. → Save.
4. If you see two headers or two footers: gear icon (Settings) → Page settings → General → turn on "Disable header"
   and "Disable footer" → Save. *(names not verified against a sample: say what you see if they differ)*
5. Bricks → Settings → Custom code → Regenerate code signatures (the reviews strip is code).
6. LiteSpeed (or the host's cache) → Purge All.
7. Open the page; check desktop, then the builder's tablet, phone sideways and phone upright buttons (or narrow the
   window to 991, 767 and 478).

## Time

Plan 20 min · builder 75 min · review 15 min · verifier + auditor 25 min · hand-over 5 min ≈ 2 h 20.
