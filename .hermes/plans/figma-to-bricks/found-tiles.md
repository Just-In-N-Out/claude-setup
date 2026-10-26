# found-tiles — Round 3 tiles/rows edge cases (PLAN, not implemented)

Planner: Opus 5.5 medium, 2026-10-22. Base: main `b4ed333` (BUILD 2026-10-22.5), only main worktree, root debug JSON modified (left alone; copied to scratch).
Intended pipeline: builder/finisher Opus 5.5 medium; fresh reviewer + Agent Defect Loop verifier Opus xhigh.
Probes (read-only, scratch only): `~/.hermes/cache/scratch/found-tiles/` (`probe-geo.ts`, `probe-geo2.ts`, `probe-plan.ts`, `probe-heads.ts`, `probe-crumb.ts`, `scan-past.ts`, outputs `geo-main.json`, `geo2-main.json`, `crumb-main.json`). Copy any you reuse into the worktree's `.superpowers/sdd/found-tiles/`, because the scratch folder is pruned after 24 h.

## Skills
figma-to-bricks (+ rules-summary), engineering-best-practices, implementation-planning, systematic-debugging, frontend-ui-repair (**Agent Defect Loop**: a fresh independent verifier must come back clean before the merge). Builder: test-driven-development, mutation-testing-discipline; systematic-debugging on a surprise. Reviewer: requesting-code-review + code-review-practice. Finisher: receiving-code-review, git-commit-rules.

## Questions (recommended answers marked ⭐; dispatcher may take the ⭐ under the Round 3 grant)
**Q1. Item 1: how is a lone framed card past the edge marked?**
- A ⭐ normalise sets a typed flag `pastEdge: true` on the frame (and on the existing `~past` groups). compose.ts `join` reads the flag OR the id suffix. No wrapper Div, so the tree stays shallow.
- B Wrap it in a one-member `~past` group. This reuses the code as it is, but adds a Div per card.

**Q2. Item 6 (empty shape: the plan counts less width than its CSS keeps).** The cause is in `least.ts keeps()` (laptops) and `shapes.ts firmAt` (tablets). Those are exactly the functions found-layout item 5 (laptop fixed tiles, line 211) must change.
- A ⭐ Move item 6 to found-layout, folded into item 5's fix. Tiles hands over the reproduction fixture.
- B Tiles fixes it after layout merges, rebased.

**Q3. Item 8 (list head not recognised).** The literal claim does **not** reproduce. Real triggers exist, but they belong to list recognition and need a head-alignment design.
- A ⭐ Split it out as its own small list follow-up, held. Keep it OPEN with the corrected narrower wording.
- B Fix it in this batch: headOf tolerates trailing untitled action columns, and list.ts reserves their width in the head.

**Q4. Item 7 (242 tracked padding).**
- A ⭐ Keep 2 decimals only for a native **Button's** `_padding`. style.ts already computes `pr` to 0.01 and emit then rounds it away.
- B Keep 2 decimals for every `_padding`. This changes many pastes.
- C Defer.

**Q5. Items 156/168 (fractional floors).**
- A ⭐ Bounded RED gate. Ceil one-line label floors **only if** a generic Chrome fixture with real font widths shows a wrap with the rounded floor and none with ceil. Otherwise record "not reproduced, deferred".
- B Blanket ceil. Forbidden without RED proof.

Held, unchanged: W-B, ALONE, grid/widest-item least. Garamond stays UNVERIFIED with no stand-in and no narrowed expected set. No CLAUDE.md write attempts.

## Dispatcher answers / ownership — October22
Under Round3 autonomous grant: Q1A/Q2 superseded: tiles owns BOTH item203 empty shape AND laptop fixed tiles item211 (layout planner independently recommended consolidation here); Q3A list follow-up stays OPEN/deferred, Q4A Button-only decimal precision, Q5A causal RED first. Initial builder executes Tiles-A ONLY; Tiles-B approved/queued separately in same feature, exact expanded plan for item203+211 required before B source edits. No duplicated owners. Layout uses style.ts turnedLength and owns place.ts nudge helpers; tiles cannot change style/place.ts or sizing.ts fractional floors until layout integrated or explicit ownership clearance. W-B/ALONE unchanged.
Max6 builders/finishers per Justin; heavy capture slot initially gates, resource admission separate. Fresh Opus xhigh reviewer AND verifier needed. No merge/push/BUILD/cleanup while Garamond release hold unresolved; no substitutes/narrowing or historical waiver reuse. No CLAUDE writes.

## Independent review correction scope — October22
Review of18f3b5d found P1 newly admitted cover-photo/GROUP/fill/overlay cards collapse when their photo becomes absolute and height releases; P2 deterministic page1section6 corpus regression from exact fractional padding; P3 test sensitivity/affected-file records gaps. Assign test-first finisher, not release. Minimum additional `src/core/adapt/rules/compose.ts` height-release correction is permitted ONLY if essential to prevent the introduced collapse, preserving already-supported cards and checking actual ownership; no general redesign. Agent chooses verified technical repair, but silently narrowing approved supported cases, new fallback, or accepting/waiving corpus regression needs Justin's decision. Preserve original no-worse gate and tracking goal. No release until NEW fresh Opusxhigh review, fresh verifier, required gates and existing proof/permission holds. Correct ledger includes inspo9 more Buttons (40 total), font-unverified Aswatama noted; original raw review preserved evidence/found-tiles/reviewer-source-18f3b5d/. Tiles-B remains queued untouched.

## Per-item findings (exact found-else text → disposition)

| # | found-else line | Reproduced on b4ed333? | Root cause (file:line) | Disposition |
|---|---|---|---|---|
| 1 | 219 "A single framed card drawn past a section's edge (one frame) is never grouped by normalise/past-edge.ts (needs 2+ layers), so compose.stack never moves it into the column: stays absolute and cut at every width." | **Yes.** `pastOne`: `Next card` stays `position:absolute`, x208–528 at 320 and x630–976 at 768, past the section edge at every width. Control `pastLoose` (the same card as loose layers) joins the column ≤991 at x16/x36. | `past-edge.ts:24` `card.length < 2` skips it. `understand/compose.ts:66` recognises only the `~past` id. | **FIX (Tiles-A).** Accept a lone *frame* holding ≥2 children, with words AND a picture (`content`), narrower than 0.9×section. Real-file scan: 0 hits in the 5 corpus files and the root debug file. inspo has 1 lone frame past the edge (`Index 04 — Aswatama outlines` 177:400, 1 child, in the horizontal-scroll Selected-work section). The ≥2-children + picture rule excludes it, so layout's intentional scroll strip is not touched. |
| 2 | 220 "Composed card whose photo fills the card width, joining a wrapping section (≤767 flex-wrap)… overflows" | **No: already fixed.** 72cf28f (gro-composition-clipping F4, released 2026-10-22.1) writes `calc(100% - 2×gutter)`. `adapt-compose.test.ts` pins it, and `composition-clipping.test.ts` test 4 passes on main now. The B3 mutant went RED in that ledger. | — | **ALREADY FIXED.** Finisher closes line 220 citing 72cf28f and build .22.1. No code. |
| 3 | 216 "Auto-layout tile fixed both ways counted as an icon row's 'words' (88x88 '12' tile beside 24px icon) collapses to its label width…" | **Yes.** T216 is 88 at ≥992, then **19.3** wide at 991–479 and 18.3 at ≤390. Desktop is `_widthMin 88`. Tablet gets `_widthMin:0` and `_flexShrink:1`. | `rules/icons.ts:16` gives every non-picture item shrink 1 and widthMin 0. `unpin.ts:90` `besideIcon` then skips the tile hold. The F2 ruling of fixed-tile-shrink left it there on purpose; the re-review then found it collapses. | **FIX (Tiles-B).** A *shaped tile* (compactTile, its drawn height ≥1.5× its tallest words' line, or no words) keeps its size like an icon. Keep the control `Arrow line` (90×24 "Read more"), which must still wrap as row.icons' words. Accordion titles keep their line. |
| 4 | 229 "In a row hugging its items, a fixed auto-layout tile whose words render wider than its drawn width (40x40 'NEW' …) is fixed at 40 on tablets/phones; word spills 4.5px (2.1 phones)." | **Yes.** Desktop T229 is 46.8 wide (desktop CSS is a plain `_widthMin 40`, so it grows). ≤991 gets `_width:40` + `min(40px,100%)`: width 40, ink out 4.5px (2.1 at ≤390). | `unpin.ts:103-104`: in `beside` rows it writes a fixed `width` instead of keeping desktop's plain px floor. | **FIX (Tiles-B).** In `beside` rows (sized by their items, tile without a set width) write **nothing** at tablet: desktop's plain px floor already holds in intrinsic sizing (it solves F1) and grows with the words exactly as desktop does. The tablet tile hold and capped floor stay for every other tile. |
| 5 | 204 "Repairs breadcrumb row ('Home' > 'Services' > 152px fixed text) spills 1px at 320 with or without the fix." | **Yes**, root debug replay at 320. Crumb row `giexhc` has scrollWidth +1. The last span `oxxzfv` (`_widthMin 152`, words 152.7) is forced to 152 and wraps to 2 lines (h40). 340/360/375/390 are fine. | The plan's mobile_portrait room is the 375 sample (`unpin.ts:111-118` releases a non-button label floor only when the 375 room < floor). At 320 the real slot is ≈151.7. The button-only cap at `unpin.ts:119-121` does not cover labels, and `100%` would not help in a multi-item row. | **FIX (Tiles-B, unpin.ts).** A surviving one-line label floor whose smallest-phone slot (`ctx.layout.phone(n).slotMin`) is under the floor gets `widthMin: min(<floor>px, <phone(n).slot CSS>)` at mobile_portrait. That is exact at every phone width: one line at 375, a contained wrap at 320. Buttons keep their existing path. |
| 6 | 203 "Empty fixed box (drawn shape) in a kept row: layout plan shares less width (66.3px at tablet) than its CSS floor keeps (min(90px,100%))…" | **Yes** (65.5 now). Plan for T203: 82.5 fluid / 65.5 tablet / 90 / 90. CSS holds it at 90 everywhere (`_width 90`, `min(90px,100%)`). The labelled-tile control is held at 90 at tablet. | The IR role is `shape`, not `box`: `least.ts:161 keeps()` only counts `box` with no children, and `kinds.ts compactBox` requires `box`. So neither the laptop keeps() nor the tablet firmAt holds it. | **REAL, plan-only fix.** Recommended move to found-layout (Q2 A), same function as its item 5. CSS must stay unchanged: `adapt-fixed-tiles.test.ts:90-98` pins the shape's own floor. |
| 7 | 242 "emit/settings.ts len() rounds a tracked button's base right padding 27.52 → "28" on desktop while phone clamp keeps 27.52." Plus 156/168. | 242 by source: `style.ts:220-222` computes `pr` to 2 decimals, and `settings.ts:11,111` `sides(len)` rounds it. inspo `ugzebt` evidence is in responsive-pill-planning.md:30-36. 156/168: not reproduced (168 already says no fractional-only wrap was shown). The Repairs crumb wrap (item 5) is a room defect, not a rounding one: a ceil floor of 153 still overflows the 151.6 room. | — | **242 FIX (Tiles-A, Q4 A).** **156/168: RED gate first (Q5 A).** |
| 8 | 223 "List fixture with badge:true: column-titles row ('Head') not recognised as a list head (list part null) while records are" | **The literal claim is not reproduced**: `listPage({badge:true})` → `head:Head`. Reproduced variants: `{actions}` alone, `{badge,actions}`, and fixed-sizing badges (`fixBadges`) → no head. | `lists.ts:204`: the head must have exactly the record's column count (trailing action buttons have no title). `lists.ts:168` `pilled` requires `sizing.w==="hug"`, so fixed badges' words form a second look (`:207-208`) and the width check `:205` fails. | **SPLIT (Q3 A).** OPEN, reworded: "head not recognised when records carry untitled trailing action buttons, or fixed-width badges". List-area follow-up, not a tiles layout rule. |
| 9 | 212 "(possible, unverified) unpin.ts:106 min(Npx,100%) button floors at mobile_portrait may make a hugging row too narrow and wrap its label on phones" | **Not reproduced.** Five generic cases (`B212` minWidth 260, `B212b`, pills row, pill+long label, `P4` minWidth 300 nested in a 520 card; plus the earlier fixed-tile-shrink ledger probe) give one-line buttons at 991–320. cta.fullWidth sends phone buttons to 100% on their own line, so the floor never binds in a hugging row. | — | **KEEP UNVERIFIED** (not closed as fixed: it was never shown broken). Add a Chrome control test at 375/360/320 as a regression pin (no source change). |

## Ownership and sequencing (actual shared files)

**Tiles-A (independent; may build now in parallel with layout):**
- Source:
  - `src/core/normalise/past-edge.ts`
  - `src/core/normalise/scene.ts` (optional `pastEdge?: boolean`)
  - `src/core/understand/compose.ts` (line 66 only)
  - `src/core/emit/settings.ts` (Button `_padding` formatter only; the line ~111 call site)
- Tests:
  - `test/unit/past-edge.test.ts`
  - `test/unit/understand-compose.test.ts`
  - `test/unit/adapt-compose.test.ts` (append only)
  - new `test/unit/emit-button-padding.test.ts`
  - new `test/browser/past-edge-card.test.ts`
- No layout-owned file: `composition-clipping.test.ts` and `inferred-row-nudges.ts` are found-layout's and are NOT edited; Tiles-A proves itself in its own new browser file.

**Tiles-B (after found-layout merges; rebase on its diff):**
- Source:
  - `src/core/adapt/rules/icons.ts`
  - `src/core/adapt/rules/unpin.ts` (tile block :89-104, label floor :105-121)
  - `src/core/adapt/kinds.ts` (new `shapedTile` predicate)
- Tests:
  - `test/unit/adapt-fixed-tiles-review.test.ts`
  - `test/unit/adapt-fixed-tiles.test.ts`
  - `test/unit/adapt-icons.test.ts`
  - `test/unit/adapt-unpin.test.ts`
  - `test/fixtures/fixed-tiles.ts` (add `hugWordy`, `iconTile` cases)
  - `test/browser/fixed-tiles.test.ts` (shared with layout: layout first)
- Tests asserting old behaviour that the builder may edit (each replaced by a stronger new-behaviour assertion):
  - `adapt-fixed-tiles-review.test.ts:60-69` (F1 `_width` = drawn and capped floor at every tier, for beside rows)
  - `:79-86` (F2 `T _widthMin:tablet_portrait "0"`, for the shaped tile only; the "Arrow line" half stays)
  - `:155-158`, `:162-170` (`_width:tablet_portrait "88"`), `:186` control expects `width===56`, `:192-205` `_width:tablet_portrait "56"`
  - `test/browser/fixed-tiles.test.ts:159-171` `kept()` exact drawn width for hugging rows (keep it for fitting words; add the wordy case as ≥drawn and ≤desktop width)

**Overlaps:**
- found-layout: shapes.ts/least.ts/kinds.ts/unpin.ts for item 5 (laptop fixed tiles) plus item 6; `fixed-tiles.test.ts`, `layout-floors.test.ts`, fixed-tiles fixtures.
- found-gates: none written. It owns geometry.ts/lint wrapper/snap/width constants; tiles may *consume* the committed geometry helper only after gates merges, otherwise local probes in tiles-owned tests.
- found-contacts: none.

**Order:** gates (tooling) and Tiles-A in parallel now → found-layout → Tiles-B rebased onto layout. Stagger Chrome and corpus runs: the gates builder holds the heavy corpus slot now.

## Tasks

### Task 0: admission (builder)
- Run Step 1/2 of figma-to-bricks. Check disk (~8 GiB) and the live writers' diffs.
- Copy this plan to `docs/plans/2026-10-22-found-tiles.md`.
- Save the baseline: `npm run corpus` report-v2.json + the five `bricks.json` + HTML + loaded/expected font sets, in a capture slot coordinated with gates.
- Keep Garamond's non-comparability labelled.
- Snap before: `npm run snap -- <scratch debug copy> .superpowers/sdd/found-tiles/shots/before --sides` at `1300,1200,1100,1024,992,991,800,768,600,480,479,390,375,360,320` (one comma-separated arg).

### Tiles-A

**A1. Item 1 RED.**
- `past-edge.test.ts`: a lone frame (photo + caption) past the right edge gets `pastEdge` (Q1 A) and becomes flow at ≤991.
- Negatives, each unchanged:
  - a lone image
  - a lone vector
  - a lone frame holding only words (the inspo-like case)
  - a lone frame holding one child
  - a frame ≥0.9×section (art)
  - the marquee strip
  - opposite edges
- GREEN: `past-edge.ts` adds `single = card.length === 1 && card[0].kind === "frame" && card[0].children.length >= 2 && card[0].children.some(content-picture) && hasWords(card[0])`. Mark it, do not group it. compose.ts:66 accepts the flag.
- Browser `past-edge-card.test.ts`: at 991/768/600/480/479/390/375/360/320 the card sits inside the section, between the gutters, its photo inside the card, no sideways scroll. At 1440/1300/1200/1100/1024/992 its rects are identical to main (intentional desktop crop kept).
- Mutant: revert the `single` branch → RED.

**A2. Item 7 / 242.**
- Unit: a native Button with letter spacing whose trailing tracking is 0.48 and drawn sides 28 emits `_padding.right "27.52"`, and its phone clamp keeps 27.52.
- Controls:
  - an integer-padding Button is byte-identical
  - a box (non-Button) with fractional padding stays rounded
- GREEN: settings.ts uses `fine` for `_padding` only on Button elements.
- Corpus: payload diffs only on fractional Button paddings. List every changed element id.
- Residual: installed Bricks 2.3.9 accepting a decimal padding string is an owed paste/copy-back check.

**A3. Item 2:** run `node --test test/unit/adapt-compose.test.ts` + `test/browser/composition-clipping.test.ts` (read-only) to record the evidence for closing 220.

### Tiles-B (after layout)

**B1. Item 3 / 216.**
- RED, unit + browser: the `iconLine` 88×88 "12" tile stays 88×88 at 991–320. The "Read more" 90×24 control still shrinks and wraps beside its icon. An accordion title with a number tile keeps its line.
- GREEN: `shapedTile` in kinds.ts. icons.ts gives it `flexShrink:0`. unpin `besideIcon` excludes it.
- Mutant: drop the predicate → RED.

**B2. Item 4 / 229.**
- RED Chrome: the hugWordy 40×40 "NEW" tile's words stay inside it at 990–320 (the width it grows to never exceeds desktop's). Measure the real Chrome font width first.
- Keep F1's hugging cases one line at 990/768/600/480 and safe at 375/360/320.
- GREEN: no tile write for `beside` (desktop plain floor).
- Mutant: restore `width:held` → RED.

**B3. Item 5 / 204.**
- RED: a generic crumb row (two short labels, two 14px icons, a long one-line label whose floor exceeds the 320 slot but not the 375 one).
  - At 320: row scrollWidth ≤ clientWidth and the label wraps contained.
  - At 375/360: it stays one line.
- Root debug replay: the crumb at 320 has sw 0.
- GREEN: unpin label-floor phone cap using `ctx.layout.phone(n)` slot/slotMin.
- Controls: buttons unchanged (`unpin.ts:121` path); labels whose slotMin ≥ floor get no write.

**B4. Item 9 / 212 pin:** Chrome control test (the B212/P4 cases from `probe-geo2.ts`), one-line buttons at 375/360/320.

**B5. Q5 RED gate (156/168):**
- Generic fixture: a one-line label beside a fill paragraph in a row that forces shrink. Set the declared words width to the measured Chrome width (with fraction ≥0.3).
- If the round-down floor wraps and ceil does not → ceil that label floor (`style/sizing.ts:92`, `style/place.ts:82`) and run the corpus no-worse check.
- Otherwise record "not reproduced" and change nothing.

**B6. Item 6:** only under Q2 B. Plan-only holds in `least.ts keeps()` (role `shape`) and `shapes.ts firmAt`; the CSS controls stay unchanged.

### Validation (every task)
- Font-sensitive geometry: every newly changed browser load asserts `fontStatus(...requestedFontFamilies(opts))` expected/loaded before measuring. Fixture-only fonts are stated as such.
- Widths: 1300/1200/1100/1024/992/991/800/768/600/480/479/390/375/360/320. For each changed row, compare its last item's right edge, pictures, shape ratios and page scrollWidth with main.
- Keep main's output at every tier where main had no defect. Desktop exactness: rects identical at the design width.
- `npm run check`, `npm run test:browser` (rerun flakes), corpus: `cmp` pastes, diff lint and the Worse-than-v1 list, report fields, loaded/expected font sets.
- Changed-element ids are listed. Snap after. Shots go to `~/.hermes/plans/figma-to-bricks/shots/found-tiles/`.
- Garamond is reported unverified and non-comparable, never green.
- Rebase, merge lock, rebased same-base proof. Take the next free paste-check number at the merge.

### Docs & records (finisher)
- Plan copy goes to `docs/plans/2026-10-22-found-tiles.md`, ledger to `docs/plans/found-tiles-ledger.md`, and HANDOFF gets the owed paste check.
- BUILD is bumped by the finisher only.
- Exact CLAUDE.md "Start here"/"Where things stand" edits go to `found-tiles-claude-md-pending.md` (apply after the older pending files, in build order). No write attempt. Keep the existing pending files.
- Canonical found-else: close only the verified merged rows (219, 204, 216, 229, 242 as fixed; 220 as already fixed in .22.1). 212 stays unverified with its control pinned. 223 is reworded and stays OPEN. 203 moves to its owner. 156/168 per the B5 outcome.

## Found else (not absorbed)
- (low) `least.ts:157-162 keeps()` misses role `shape`, although its comment says "an empty box keeps its set width": a classification drift that also affects laptops. It belongs to the owner of item 6.
- (low, test fidelity) The `delta D2` test in `adapt-fixed-tiles-review.test.ts:226-250` relabels records as `head` because the fixture's real head is not recognised with fixed badges and actions. It does not test a recognised head.
- (info) inspo's lone frame `Index 04 — Aswatama outlines` (177:400) past the edge of the horizontal-scroll Selected-work section: found-layout item 4's area. Tiles' rule deliberately excludes it.
