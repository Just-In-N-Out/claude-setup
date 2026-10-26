# Pills that cut or wrap their words (pill-clip, B6)

**Approved by Justin 2026-10-21** (P1A P2A P3A, all ⭐).

Planner: Hermes, 2026-10-21. Main at build `2026-10-21.7` (`aa19bae`). cta-label-wrap is in review at `2eda793`
(branch `worktree-cta-label-wrap`). Its finisher is now fixing F1–F3 in `adapt/layout.ts` and `least.ts`. **This batch
builds after cta-label-wrap merges.** Plan only: no copy, code or commit made.
Loaded: `figma-to-bricks` (PLANNER role: rules summary, then the parts of CLAUDE.md this needs) and `systematic-debugging`.

## Open questions (the plan is written as if each ⭐ was chosen)

**P1. A row of pills that no longer fits a laptop screen (the design file's service tags, 992–1700px):**
- **A ⭐ The pills wrap onto a second line, each pill whole, its words on one line**, as tablets already do. Each card
  gets about 56px taller where a row breaks.
- B. Keep one line of pills and let their words wrap inside them. The pills get taller (54–78px against 39 drawn), and
  single words still get cut.
- C. Make the pills' padding smaller first, and wrap only when that isn't enough.

**P2. The header's "Schedule Your Visit" pill on small laptops (992–1100px):**
- **A ⭐ The pill keeps its words on one line, and the menu links beside it may go onto 2 rows** (393px wide at 1024,
  72px tall). This is the same rule you picked for buttons in cta-label-wrap (W2A).
- B. Leave the header as it is: the pill's words go onto 2 lines (they fit inside its 56px height).

**P3. Build order (`layout.ts` is 283 lines, and the file limit is about 300):**
- **A ⭐ Build after layout-floors merges.** layout-floors splits `layout.ts` first, so this lands in the smaller file.
- B. Build right after cta-label-wrap and put the new laptop step in a new file. layout-floors then rebases on top of
  it.

## The request, played back

1. In the corpus "design" file at 1024px, about 10 pill labels are cut off. The lint lists Invisalign, Retainers,
   Fluoride, Nightguards, Curodont™, Bridges, Dentures and Frenectomy.
2. On the GRO homepage at 768px, the "Let's talk →" pill is 163×76. Figma draws it 60 tall: its arrow drops under its
   words.
3. Added by the main chat (cta-label-wrap review, F4): the design file's laptop pills still wrap. At 1200,
   "Schedule Your Visit" is on 2 lines and "Inlays and Onlays" and "Tooth Colored Fillings" are on 3. Words spill out
   of their pill at 992/1024/1200/1440 (20/19/10/4) on both main and the branch.
4. A pill should keep its words whole and on one line wherever there's room, and never cut them. This has to work for
   any design: no keying on names, words or sizes.

## Reproduced (corpus rendering: stand-in fonts, placeholder pictures)

Scratch copies: `~/.hermes/cache/scratch/pill-clip/{main,clw}` (`git archive` of `aa19bae` and `2eda793`, with
`node_modules` symlinked). Scripts in the same folder:
- `probe.ts`: converts and renders the way the corpus does, lints, and measures the parent chain;
- `row.ts`: measures a subtree;
- `inject.ts`: adds CSS, then lints and measures.

`npm run snap` gives inflated counts (21 cut at 1024), because it renders without the corpus's font stand-ins
(Mont → Montserrat). Use the corpus rendering or `npm run wraps` instead.

| design file, text-clipped | 1440 | 1200 | 1100 | 1024 | 992 |
|---|---|---|---|---|---|
| main `aa19bae` | 0 | 3 | 5 | 8 | 8 |
| cta-label-wrap `2eda793` | 0 | 3 | 5 | 8 | 8 |

- **The two builds give identical results.** cta-label-wrap fixes none of these items.
- `npm run wraps` on the branch, design file: 31 one-line texts on 2+ lines at 992. They include "schedule your visit",
  "suresmile aligner system" (3 lines), "tooth colored fillings" (3) and "inlays and onlays" (3).
- **GRO "Let's talk →" (`jvdcnf`):** the pill is 163×76 at 768 on both builds. Its label is on one line (107.5×16).
  The **arrow** falls to a second line. At 991/900 the pill is 179×60 and fine.

## Root cause (one cause, three symptoms)

A pill is drawn as a rounded frame that clips (Figma's default `clipsContent`), hugging its words and icon.

1. **`style/paint.ts:243`** writes `overflow: hidden` for any clipping box with a radius:
   `else if (n.clips && (radius || spills || placedInside(n)))`. On a pill the clip cuts nothing in Figma, because its
   words sit inside its padding.
   - In CSS, `overflow: hidden` makes the pill a scroll container. A flex item that's a scroll container gets
     `min-width: auto = 0`, so **the pill can shrink below its own words**. Chrome then wraps the words, or cuts a single
     word: `#brxe-wwphcb` "Invisalign" is 82.8px wide, scrollWidth 114, at 1024.
2. **On laptops a row of pills never wraps.**
   - The row (`ztilif`: four hug pills, 782 drawn) gets `flex-wrap: wrap` only from tablets down
     (`_flexWrap:tablet_portrait`, from the layout plan's `"wrap"` shape, `layout.ts:133`, written by `rows.ts:87`).
   - The laptop pass is fixed to `keep` (clw `layout.ts:206`: `tier === "fluid" ? "keep"`).
   - So between 992 and the design width all four pills shrink together into 433px (at 1024): the row's share at the
     narrowest laptop is 416px against about 775 of pills.
   - Because the plan gives each pill less than its one-line width there, cta-label-wrap's `label.oneLine` rightly
     writes no `nowrap` at `fluid`.
3. **cta-label-wrap won't hold a clipping pill on purpose** (its commit `b08fe35`).
   - `least.ts` `floored()` holds a button in a kept row only when no box between them clips: a clipping box's
     min-content is 0, so the hold would be fiction.
   - Every pill clips (cause 1), so every pill is shared as drawn.
   - GRO at 768: the 3-item row gives the pill 162.8px. It needs 182.5px (107.5 words + 16 gap + 15 arrow + 2×22
     padding). `label.oneLine` writes `white-space: normal` at tablet.
   - The pill's own row also has `flex-wrap: wrap` below the design width (`style/style.ts:150-152`: a hugging row of
     only texts wraps, meant for a heading set in pieces), so the arrow drops under the words.
   - **Header pill (F4):** `knlcug` "Schedule Your Visit" in `ztefyt` clips, so it's not floored. On laptops rows share
     as drawn, so it gets 202px at 992 and 232px at 1200 against the 258px its line needs. `style.ts:193-196` also
     deletes a held label's floor below the design width. That's a symptom of the same gap (nothing holds a pill on
     laptops), not a separate cause.
   - Even at 1728 (the design width) the design file's pills are squeezed: the 1440px Container cap means a 1728-wide
     design is never at its drawn width.

**What I ruled out:**
- **Fonts:** the counts are the same with the corpus stand-ins.
- **cta-label-wrap:** identical numbers, as above.
- **`overflow: clip` alone** (probe B): 1200 goes 3 → 0, but 1024 still has 4 and 992 has 6. The row itself then
  spills out of its card, which clips it.
- **Row wrap alone without `nowrap`:** multi-word labels still wrap inside their pills.

**What fixes it (CSS injected in Chrome, design file):**
- Probe D: pill `overflow: clip`, its words `nowrap`, and its row `flex-wrap: wrap` with a 17px row gap.
  - Result: **0 cut at 1728/1440/1200/1024/992**, all 35 pills 39px tall, as drawn.
  - The page gets taller where rows break: +187px at 1024.
- GRO at 768: pill `overflow: clip`, no `flex-wrap` on the pill, its words `nowrap`.
  - Result: the pill is **179×60** on one line. Its neighbours give up 7–10px.

## Fix (general, from structure)

1. **A pill clips without becoming a scroll container (style).**
   - Rule: a button-like label box (`labelBox(n)` with `painted` or `outlined`, from `normalise/label-box.ts`, the same
     family as cta-label-wrap's `buttonLike`) that clips **only for its radius** (no spill, no placed layer) gets
     `overflow: clip`, not `hidden`.
   - It looks identical: corners are still clipped. But its min-content is now its words and icon.
   - Every other box keeps `hidden`. Cards and photos are unchanged.
   - `style/behaviours.ts:54`: `clip` also gets the inset focus ring, as `hidden` does.
2. **A pill's own words and icon stay one piece.**
   - `style.ts:150-152` (a hugging row of words wraps below the design width) skips a button-like label box: its words
     plus arrow are one button, not a heading in pieces.
3. **CSS really holds a pill that clips this way.**
   - `least.ts` `floored()` counts only scroll-container overflow (`hidden`, `auto`, `scroll`) as cutting. `clip` and
     `clip visible` keep min-content.
   - So cta-label-wrap's kept-row share and `label.oneLine` now apply to pills too. That fixes GRO at 768: the pill gets
     its 182.5px and `nowrap` at tablet.
4. **On laptops a row of buttons that doesn't fit wraps (P1 A).**
   - The laptop pass (`layout.ts`) decides `"wrap"`, never `two`/`stack`, for a row whose items are all labels or
     button-like hugging boxes (the same test as the tablet `"wrap"`), when their one-line widths (`least`) don't fit
     the narrowest laptop's inner width.
   - Then each pill's room there is the row's whole line, and `label.oneLine` writes `nowrap` at `fluid`.
   - `rows.ts` writes it at `fluid` as custom CSS `flex-wrap: wrap; row-gap: <gap>`, so the design width stays exact:
     emit puts fluid custom CSS under `max-width: <design-1>`.
   - For a design wider than the 1440 Container (`shared/breakpoints.ts`), the content never reaches its drawn width,
     so the wrap goes on the desktop value itself.
5. **On laptops a floored button is held in a kept row (P2 A).**
   - The laptop pass may give a button its one-line width in a kept row, where `floored()` is now true. That's the
     header pill.
   - Its neighbours share the rest, within cta-label-wrap F1's limit (no neighbour below 200px), and the button is
     dropped first when they can't.
   - The header's menu links may then wrap at 992–1100.

No font gets smaller and no icon is hidden. The last resort stays as today: a pill wider than its whole row may wrap its
words, and nothing spills.

## Tasks (test first)

0. **Before any change** (the copy still equals main):
   - Run `npm run corpus`. Save the report and copies of the pastes.
   - Run `npm run wraps -- <file> 1728,1440,1200,1024,992,768,480,390` on the 5 corpus files and a scratch copy of the
     debug file.
   - Run `npm run snap -- <design file> .superpowers/sdd/pill-clip/shots/before 1440,1200,1024,992 --sides`.
   - Run `npm run snap -- corpus/files/gro-home.json …/before-gro 991,768 --sides`.
1. **Fixture `test/fixtures/clipped-pills.ts`** (generic words and sizes):
   - (a) a card holding a fill-width row of four clipping, outlined pills (radius 100, words and a 24px icon), some with
     one word and some with three;
   - (b) a 3-item row: a painted clipping pill with words and a "→" text, beside a fixed paragraph and a caption;
   - (c) a nav row: logo, a row of links, a clipping painted pill;
   - (d) a rounded clipping card holding a photo (it must keep `overflow: hidden`);
   - (e) a heading set in pieces (a hugging row of texts that still wraps).
2. **RED unit tests:**
   - `style-paint` / `convert-*`: (a)/(b)/(c) pills get `overflow: clip` and (d) keeps `hidden`; (b)'s pill gets no
     `wrap` and (e) still does.
   - `adapt-least`: `floored` is true through a `clip` pill.
   - `adapt-layout`: (a)'s row is `wrap` at `fluid` and each pill's fluid room is the row's line; (b)'s pill room at
     tablet ≥ its least; (c)'s pill holds at `fluid` and the links get the rest.
   - `adapt-label`: `nowrap` at `fluid` on (a) and (c), and at tablet on (b).
   - Prove each one fails on the main-at-start code.
3. `style/paint.ts` + `style/behaviours.ts` (fix 1), `style/style.ts` (fix 2). GREEN.
4. `adapt/least.ts` `floored` (fix 3). GREEN.
5. `adapt/layout.ts` laptop pass `wrap` + held button (fixes 4–5), and `adapt/rules/rows.ts` writing the `fluid` wrap.
   GREEN.
6. **Browser test `test/browser/clipped-pills.test.ts`:** render the fixture at 1600, 1200, 1024, 992, 768, 480 and
   390.
   - No pill's `scrollWidth` passes its `clientWidth` + 1.
   - Every pill is within 2px of its drawn height.
   - Every pill's words are on one line.
   - (d)'s photo is still clipped to its corners.
   - The design width is unchanged.
7. **Close:**
   - Run `npm run check`, `npm run test:browser` and `npm run corpus`, compared with the saved baseline.
   - Target: the design file's text-clipped count at 1200/1024/992 goes to 0, and no file or width gets worse.
   - Re-run `wraps` and expect the pill words gone from the lists.
   - Replay main against the branch and diff by element id. Measure the changed elements at every width: no circle
     turns into a pill, no card spills, the header has no overlap at 992.
   - Take the after shots.
8. **Docs & records** (below).

## Risks

- **Cards get taller** where a pill row breaks on laptops: about +56px a row, +187px on the design page at 1024. The
  section-height numbers move.
- **`overflow: clip`** changes how much a pill can shrink.
  - It's limited to button-like label boxes clipped only for their radius.
  - Safari supports it from 16 (2022).
  - Bricks' `_overflow` already receives `clip visible` from this code, but a plain `clip` value hasn't been through a
    paste round trip. **Paste check owed** (and `_cssCustom` is the fallback if Bricks drops it).
- **The header (P2 A):** menu links on 2 rows at 992–1100. cta-label-wrap F1's 200px floor must still hold.
- **Font drift:** with `nowrap` pills, a site font wider than Figma's makes a row wrap one pill earlier. It never cuts
  words.
- **Designs wider than 1440** get the wrap on desktop itself: the ≥ design-width view of such a design changes too.
  That's the intended fix, since the design is never drawn at its own width there.
- **Collision rules:** `rows.ts` is the only writer of `wrap` at `fluid`, and `label.oneLine` writes `white-space`.
  No overrides are needed. Checked: `space.ts` guards `fluid`.

## Files and pipeline parts touched

- **style:**
  - `src/core/style/paint.ts` (boxPaint overflow);
  - `src/core/style/style.ts` (lines 150–152, hug-row wrap; the file is 356 lines, see overlaps);
  - `src/core/style/behaviours.ts` (focus inset).
- **adapt:**
  - `src/core/adapt/least.ts` (`floored`);
  - `src/core/adapt/layout.ts` (laptop pass: `wrap`, held button);
  - `src/core/adapt/rules/rows.ts` (`fluid` wrap).
  - No change to `label.ts` or `unpin.ts` expected.
- **Tests:**
  - new: `test/fixtures/clipped-pills.ts`, `test/browser/clipped-pills.test.ts`;
  - changed: `test/unit/adapt-layout.test.ts`, `adapt-least.test.ts`, `adapt-label.test.ts`, a style unit test, and
    the golden `convert-sample.json` if it moves.
- No extract, normalise, understand or emit change.

## Overlaps

- **cta-label-wrap (in review; finisher fixing F1–F3 in `layout.ts`, `least.ts`):**
  - Same files: `layout.ts` and `least.ts`.
  - This plan builds on its `least`, `floored`, `label.oneLine` and the laptop pass, and needs its F1 rule (a held
    button never squeezes a neighbour below 200px) for fix 5.
  - **Build after it merges** and re-read `floored` and the kept-row share then.
- **layout-floors (B5, queued):**
  - Shares `adapt/layout.ts`, which it splits, and `adapt/least.ts` (its R5: `sidesAt` counts 2× outline at 0
    padding). It also edits `rules/unpin.ts` and `rules/space.ts`; this plan doesn't.
  - Its "inspo Industries pills strip on phones" item is the same family (pills in a row) on phones. No code is shared,
    but compare results.
  - P3 A: build after it.
- **test-cleanup (queued):** splits `style/style.ts` (picture code to `style/picture.ts`). The edit here is 2 lines at
  150–152. Rebase across it.
- **text-breaks, link-upload-fixes, frame-text-links, google-partial-fonts, text-link-followups:** no shared source
  file.

## Docs & records (last task)

- Plan copied to `docs/plans/<date>-pill-clip.md`.
- Ledger moved from `.superpowers/sdd/pill-clip/progress.md` to `docs/plans/<date>-pill-clip-ledger.md`.
- `docs/HANDOFF.md`: new section "Pills that cut or wrap their words", holding:
  - the cause, the fix and the rulings;
  - the corpus and wraps numbers before and after;
  - the paste check owed (next free number): the design page at 1024 and 1200 (service pills whole, on one line; the
    header pill on one line); GRO at 768 ("Let's talk →" on one line, about 60px tall); and `_overflow: clip` surviving
    the paste.
- `BUILD` bumped at the merge.
- Main `CLAUDE.md` "Start here" and "Where things stand" updated by the finisher. New rule under "Build general
  logic": a button's clip is `overflow: clip` (never a reason for it to shrink below its words), and a row of buttons
  that can't fit wraps on laptops too.
- `references/rules-summary.md` updated by the finisher (a rule changed).
- In `found-else.md`, at the merge, mark each item as
  `~~item~~ ✅ fixed in build <BUILD> (pill-clip)`. That covers both B6 lines and the "pill buttons wrap at laptop
  widths" line (F4).

## Other things found (not folded in)

- **Low (tools):** `npm run snap` renders without the corpus's font stand-ins, so its lint differs from `corpus`/`wraps`
  (design @1024: 21 cut against 8). That misleads "before/after" proofs. Belongs in test-cleanup.
- **Medium:** GRO at 1440, `#brxe-eixorr` "Client Name — Lifestyle": 4 texts cut, on main and the branch (corpus
  rendering). Not pills, not investigated.
- **Low:** GRO `#brxe-kcabyv` "04" is cut at 991–480, and `#brxe-qljtcd` "Contact" at 768, on both builds.

## Justin's answers (2026-10-21)
- P1A P2A P3A (all ⭐). Builds after layout-floors merges (which itself waits for cta-label-wrap). Also covers the cta-label-wrap review's F4 (laptop pills, W2A).

## Addendum (main chat, 2026-10-21 ~09:45, Justin: "fold")
More found items to investigate in this batch; write a short root cause + test for each before building, fix those that share the clip/shrink cause (general logic), list the rest as left:
- Medium: GRO @1440, #brxe-eixorr 'Client Name — Lifestyle': 4 texts cut, on main and cta-label-wrap (corpus rendering).
- Low: GRO #brxe-kcabyv '04' cut at 991–480, and #brxe-qljtcd 'Contact' at 768.
- Low: design file at 992: service pills (Dental Bonding, Invisalign, Veneers…) spill and clip in their boxes (cta-label-wrap finisher; same cause as P1).
- Low (pre-existing, cta-label-wrap reviewer): size.unpin judges a min-width floor against the 375px phone's 343px room, so a floor between ~289 and 344px spills on 320–360px phones (min-width beats max-width:100%); breakpoints.ts mobile_portrait contentMin 343, unpin.ts ctx.layout.room(n, t). Fix if it's the same floor path; else list it.
- Low (docs, card-link-words planner): CLAUDE.md's Buttons decision should say an arrow pill in a whole-card-linked card is a Div, not a Button (no nested links). Only if card-link-words hasn't already written it.
