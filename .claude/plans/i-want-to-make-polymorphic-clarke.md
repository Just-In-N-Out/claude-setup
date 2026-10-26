# Links to pages from arrows and "Learn more" words

## Context

The user (2026-10-19) wants hyperlinks set up automatically.
- **What triggers it:** whenever a design shows a hyperlink arrow icon, or words like "take me to …" / "Learn more".
- **Their example:** a dark card row, "Service 03 | Core Exchanges | ↗". Clicking it should open the page named after "the sentence before it" (`/core-exchanges/`).
- **Today:** only Figma's own prototype links (`SceneNode.link`) and the call/email links found by `normalise/contact-links.ts` become links. Every other arrow card pastes as a box that does nothing.

**The user's rulings (asked this session):**
1. **The whole card is the link** (Block/Div `tag:"a"`). The arrow only signals that it can be clicked.
2. **Figma's own links win, unchanged.** A Navigate to "Core Exchanges Final" still goes to `/core-exchanges-final/`, because `pageUrl` is untouched. Only things with no link of their own are linked.
3. **Only arrows, by reading the drawing.**
   - These count: → ↗ ↘ ›.
   - These never link: + × ✓ ↓ ← ↑ and up/down chevrons.
   - An icon whose drawing can't be read (no SVG) counts only when it is the only icon, at the right end.
4. **Arrow buttons link to the page their words name**, except actions.
   - "Dental Bonding →" goes to `/dental-bonding/`, and "Browse Inventory ↗" to `/inventory/`.
   - Action buttons never link: Submit, Send, Get directions, Schedule, Call, Open in Maps.
   - The panel lists every link it made.

**My rulings, to report at the end:**
- Leading go-verbs and fillers are dropped: "See our work" goes to `/work/`, "Explore our services" to `/services/`.
- A "Learn more" with no target words links to its card's title.
- Only "home", "home page" and "homepage" go to `/` ("Home Repairs" goes to `/home-repairs/`).
- The panel gets one note per link found.
- Inside a sideways strip, card arrows keep gliding the strip (the earlier ruling).
- A linked card keeps its title as a heading.

## Design

### 1. Data
In `src/core/normalise/scene.ts`, after `contact`:
```ts
export interface PageLink { url: string; words: string; from: "arrow" | "words" }
pageLink: PageLink | null // a page the plugin found from an arrow or go-words; the designer's link and contacts win
```
- It is set to `null` in `normalise.ts` `build()` and in `cut-node.ts`.
- `understand/node.ts:55` becomes `ir.link = linked ? null : n.link ?? n.contact ?? n.pageLink?.url ?? null;`.
- No other stage needs to change: emit already writes `settings.link` plus `tag:"a"` on a Div/Block (`emit/elements.ts:75-78`), and style gives a linked box `color:inherit; text-decoration:none` (`style/style.ts:146`). Phone copies spread the IR, so they keep the link.

### 2. Arrow-shape reader (pure)
- **`normalise/svg-paths.ts`** turns Figma's exported SVG into straight segments.
  - It handles path `MLHVCSQTAZ` (absolute and relative), `line`, `polyline`, `polygon`, `rect`, `circle` and `ellipse`.
  - It applies `<g>` and element transforms.
  - It skips `defs`, `mask`, `clipPath`, `filter`, `foreignObject` and gradients.
  - Curves are sampled into pieces.
- **`normalise/arrow-shape.ts`** exports `arrowShape(svg) → {arrow, angle} | other | unknown` (memoised), `glyphShape(chars)` and `pointsRight`.
  - Backdrop tiles and rings are dropped: an element or subpath whose box contains the rest.
  - Rounded tips collapse to a sharp point. Endpoints within 6% of the icon's size count as one point.
  - **A head:** two arms meeting at an angle of 35–140°, with a length ratio of at least 0.6. This rules out ✓.
  - The head must sit at the drawing's extreme end in the direction it points.
  - A shaft behind the head scores higher.
  - Equal heads pointing different ways (↔, ★, ▶) make the shape "other".
  - **Right-pointing** means within ±67.5° of right.
- **Figma bakes the layer's own turn and flip into its exported SVG** (verified: the hydraulics FAQ toggle and brainstorm's flipped akar arrow). So `SceneNode.rotation`/`flipX` are never applied again.
- v1 corpus files carry no SVG, so all their icons are "unknown".

### 3. Words (`normalise/page-words.ts`, data like `contacts.ts`)
- `labelWords(words) → {dest, go} | null`:
  - **Go-verbs dropped:** take me to, go to, learn/read/find out more about, explore, discover, view, see, browse, visit, check out.
  - **Fillers dropped** after a verb: our, the, all, your, my.
  - **Generic words** ("Learn more", "details", "case study") give `dest: null`, meaning "use the title".
  - **Blocked words return null:** submit, send, sign up, book, schedule, buy, download, get, let's, call/email (`callWords`/`mailWords`), open, next, previous, close, menu, search, play, start, request, join, and so on.
- `pageAddress(name)` gives `/slug/` (reusing `links.ts` `slug`); only home, home page and homepage give `/`.

### 4. The pass (`normalise/page-links.ts` `linkPages(pages)`)
It runs in `normalise()` right after `linkContacts` (`normalise.ts:223`). It walks `children` only (never hidden layers), in a fixed order.
- **Triggers:**
  - an icon (`kind:"vector" && icon`) whose shape is an arrow or unknown;
  - a one-glyph arrow text;
  - a text whose words are a go-phrase.
- **Label:** the nearest `labelBox` (`label-box.ts`) holding exactly one word text, with the trigger after the words.
  - With a label, the destination is the label's words (`labelWords`), or the title for "Learn more".
  - Without one, the trigger is a *free arrow*: it must start in the box's right half and end in its right quarter (as `arrows.ts:26`), and be the box's only arrow.
- **Card:** from the nearest ancestor holding other words, climb while the parent adds no texts. Take the first painted, outlined, shadowed or photo-filled box.
  - A free arrow links the card, or that ancestor if there is no card.
  - A label links the card when it holds nothing else that triggers a link, and otherwise links just itself.
- **Title** (`normalise/card-title.ts`):
  - **Candidates:** texts that are 2–60 characters with letters, at most 2 lines, and are not glyphs, placeholders, contacts or go-words.
  - **Ranking:** most prominent first (size, then weight), then the text before the arrow on a tie.
  - For labels, the title must be at least 1.25× the label's text size, or bold and at least as large.
  - If the top text ends in "?", nothing is linked.
- **Guards** (any one means no link):
  - **Page-level boxes:** the root, a section, the section frame's chain, a box at least 60% of the section frame's width, the box holding all of a section's words, or a full-width band (`page-frame.ts`, `content-box.ts` `spansFrame`).
  - **Existing links:** a `link`, `contact`, `pageLink` or run link on the box, inside it, or around it (`holdsLink`).
  - **Figma clicks:** `clicks` on the box or inside it (carousels, tabs, toggles).
  - **Forms:** a form field inside, or two fields in scope (`fieldText`, moved from `contact-links.ts` `field()` to `label-box.ts`).
  - **FAQs:** the structure of an FAQ list. `holdsText`, `smallIcon` and `questionRow` move from `understand/accordion.ts:13-27` to `normalise/faq-shape.ts`, which `accordion.ts` then imports.
  - **Sideways strips:** an ancestor with `scrollsX` (`scene.ts:90`), so strip arrows keep gliding.
  - **Menus:** in a row of three or more labels, an unknown icon counts only when every label has one at its right end. A nav "Services ⌄" stays unlinked.

### 5. Headings (`understand/headings.ts:40`)
- A linked box that isn't a Button and holds two or more word texts no longer hides its texts from headings, so the card's title stays an h3, as in the user's Staff card sample.
- A linked button's or one-label box's words still aren't headings.
- No designer link in the corpus holds two or more texts, so no existing outline changes.

### 6. Panel notes (`understand/page-links.ts` `notePageLinks`)
- Called after `assignHeadings`.
- It writes one de-duplicated note for each IR node whose link equals its source's `pageLink.url`, so only links that actually landed are named:
  `"Core Exchanges": linked to /core-exchanges/ (from its arrow); make sure that page exists on the site, or change the link in Bricks`.

## Tasks (test first; commit and `git push -u origin HEAD` after each)

0. **Setup.**
   - `git rebase main` (the branch is behind main's 19.13, with no commits of its own).
   - Run `npm run check` and `npm run corpus`, and record the numbers and heading outlines.
   - Write the plan doc `docs/plans/2026-10-19-page-links.md` (`superpowers:writing-plans`) and start the ledger `.superpowers/sdd/2026-10-19-page-links/progress.md`.
1. **Shape reader.**
   - Files: `svg-paths.ts`, `arrow-shape.ts`, generic SVG fixtures in `test/fixtures/icons.ts`, and `test/unit/normalise-arrow-shape.test.ts`.
   - Fixture shapes: stroked ↗, Lucide/Heroicons-style relative paths, › and chevron-down, a filled arrow, a circle arrow, a tile + arrow, ring + ×, +, ✓, ↔, ▶, ★, search, download, external-link, and turned/flipped copies.
   - **Acceptance:** a scratchpad probe classifies every icon in the page-1, hydraulics, GRO and brainstorm files. ↗ comes out as −45°, the chevron-down as 90°, FAQ +/× and the tiles as "other", and the flipped akar arrow as 0°.
2. **Words.** `page-words.ts` and `normalise-page-words.test.ts`.
   - "Explore our services" → `/services/`, "Browse Inventory" → `/inventory/`, "Learn More" → title.
   - "Submit", "Get directions", "Open in Maps", "Call us now" → no link.
   - "Home" → `/`, "Home Repairs" → `/home-repairs/`.
3. **Shared helpers, no change in behaviour.**
   - Create `faq-shape.ts`, and move `fieldText` to `label-box.ts`.
   - **Acceptance:** the corpus payloads are byte-identical before and after.
4. **The pass.**
   - Add `PageLink` to `scene.ts`, write `page-links.ts` (plus `card-title.ts`), and call it after `linkContacts`.
   - Generic fixtures go in `test/fixtures/page-links.ts`, tests in `normalise-page-links.test.ts`:
     - the card row links whole;
     - a corner arrow above the title;
     - left-half, two, chevron-down or × arrows don't link;
     - the designer's link wins;
     - a card holding a call link isn't linked whole;
     - "Learn more" in a card, and under a section heading;
     - arrow pills and pill grids;
     - menu rows;
     - FAQs (`faqPage`, `faqPage({plain:true})`);
     - strips (`stripPage`, `arrowStrip`);
     - forms;
     - Figma clicks;
     - sections and bands;
     - no title;
     - hidden layers;
     - deterministic output.
5. **Into the page.**
   - Changes: `node.ts:55`, the `headings.ts:40` rule, and `understand/page-links.ts`.
   - Tests in `understand-headings.test.ts` and `convert-page-links.test.ts`:
     - a Block/Div `tag:a` with the URL, whose title is still a heading;
     - a pill link;
     - nothing nested;
     - one panel note per link, none for designer links;
     - phone copies keep the link;
     - `payloadProblems` is empty;
     - the output is byte-identical across runs.
6. **Corpus and close.**
   - Add `test/unit/corpus-page-links.test.ts`. It checks that every `pageLink` lands, that nothing (accordion, form, strip or Button) sits inside one, and that designer links are unchanged.
   - Run `npm run corpus` (no width worse), and replay the corpus plus brainstorm against the check list below.
   - Run `npm run snap` on page-1 at 390/768/1024/1440/1728, then `npm run test:browser`.
   - Add a HANDOFF section and paste check 3o: click a card; check that Bricks keeps `tag:a` with a relative URL and that `text-basic` keeps its link.
7. **Review.** One fresh opus review of `git diff main...HEAD`, then one fix pass, test first. Prove the key tests catch the bug (`git checkout HEAD~1 -- <src>`). The ledger then moves to `docs/plans/2026-10-19-page-links-ledger.md`.

## Corpus check list (expected)

- **page-1:**
  - The 5 "Learn More ↗" keep their Navigate links, and their rows get nothing.
  - "Browse Inventory ↗" → `/inventory/`.
  - "Get Directions", "Open in Maps", nav "Services ⌄", the table and the stat tiles get nothing.
  - Call pills keep `tel:`.
- **hydraulics:**
  - The 5 bento cards link whole (`/core-exchanges/` and the others), keeping their h3 and hover.
  - "View Our Gallery ↗" → `/gallery/`.
  - The FAQ is still an Accordion.
- **gro:** "See our work" and "View all work" → `/work/`; "Explore Strategy" → `/strategy/`; "About GRO" → `/about-gro/`; "Case study" gets nothing.
- **design (v1):**
  - The menu rows → `/about-us/`, `/services/` and so on.
  - The service pills → their own slugs.
  - "View More" cards → their titles.
  - "Submit", "Schedule Your Visit", "Select One ▾" and the carousel arrows get nothing.
- **brainstorm:**
  - The "Selected work" strip arrows still glide.
  - "explore strategy" → `/strategy/`, "our team" → `/our-team/`.
  - "let's GRO" and the carousel arrows get nothing.

## Verification
- `npm run check` and `npm run test:browser` pass.
- `npm run corpus` is no worse at any width.
- Replays of the user's files match the check list.
- The panel notes name each link once.
- The same snapshot gives a byte-identical payload.

## Finish (CLAUDE.md "Several agents at once")
1. Commit, then `git rebase main`. On a conflict (other agents may touch `normalise.ts`, `node.ts`, `headings.ts`, `scene.ts` or HANDOFF), keep both sides.
2. Run `npm run check` and `npm run corpus` again.
3. `git -C /Users/justin/Documents/FigmaToBricksV2 merge --ff-only worktree-hyperlink`. If this session isn't allowed into the main folder, ask the user.
4. In main: read and bump `BUILD`, run `npm run build`, commit "Build <BUILD>: links to pages from arrows and Learn more", and `git push`. Commits are plain `git commit -m`, with no AI lines and CLAUDE.md never staged.
5. Update the main folder's CLAUDE.md: "Start here", "Where things stand", and a "Links to pages" decision with the 4 user rulings and my rulings.
6. Tell the user it's merged, with the rulings, deferred minors and the paste steps (regenerate signatures is not needed; LiteSpeed Purge All after the paste).
