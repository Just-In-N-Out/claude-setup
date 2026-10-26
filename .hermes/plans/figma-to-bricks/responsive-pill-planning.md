# responsive-pill-planning — peer pill sides (F3) and wrapped-row least
## Dispatcher ruling under autonomous authorization — October 21, 2026
Proceed with bounded F3 peer-side equalization after fixed-tile-shrink merges. Accept recommended G1 parent-slot room interpretation for hug-button phone guards in a separate droppable commit, with corpus-wide ≤2px claims verified rather than assumed. Preserve all prior P1A/P2B/L1A decisions and exact plan/emit consistency. Choose wrapped-row option A: DEFER its least/minimum calculation change because it requires a new grid-body-text policy; no ALONE/grid reversal authorized. No blanket ceil. Preserve every numeric `least` result and grid/row-shape decisions; plan-view lookup additions are not permission to change minimum semantics. Freeze kinds/shapes/rows/unpin as read-only after fixed-tile. Re-measure new arrow-picture allocation issue separately after that release, not expand this build.

Planner: Hermes (Opus 5.5), 2026-10-21, autonomous round 4 (`briefs/autonomous-round4-planners.md` §responsive-pill-planning).
Source read: main `5e32aec` (build `2026-10-21.22`). Plan only: no worktree, source, test or commit made.
Routing: **in-between — Opus 5.5 medium builder/finisher, fresh Opus xhigh reviewer.**
Evidence (this planner, read-only probes against main .22): `~/.hermes/plans/figma-to-bricks/evidence/responsive-pill-planning/planner-main22/`
(`anc.ts`, `style.ts`, `dump.ts`, `chrome.ts`, outputs `anc-ugzebt.txt`, `anc-tixrqb.txt`, `pill-styles.txt`, `chrome-main22.txt`,
`source-commit.txt`, `input.sha256` of `evidence/pill-clip/inspo.json`). In `chrome-main22.txt` the `lines` column is the element's rounded height in px.

## Canonical findings owned (found-else.md)
- **:161** inspo alike pills in `ugzebt` have unequal side padding, fractional room guards included (layout-floors F3, approved **F3 A**: "alike pills in one row share one side padding, the smallest").
- **:167** the same, still open after pill-clip (27.5 / 27.52 / 28 and guards per content).
- **:150 / :165** `least.ts` sums a drawn-wrapping row's items as one line; the isolated fix was reverted in `6ad2841` because hydraulics grid columns changed at 768.
- **:156 / :168** fractional floor / blanket ceil. Explained below. **Not fixed, not owned for a code change.**

## Playback
1. Alike pills that sit in one row show different left/right padding at the same phone width, even though Figma draws them all the same.
2. A row that wraps (pills that drop to new lines) counts as wide as all its pills put together, which can make the rows and grids around it stack early or drop columns.
3. Fix 1 without changing the grid, ALONE, two-share or wrapped-parent rules. Plan fix 2 without repeating the experiment that was reverted.

## Root cause 1: peer sides (F3), reproduced on main .22

Generic mechanism (`src/core/adapt/sides.ts:68-75`, `phoneSide` :46-52, `layout.ts:65-78`):
- Each box's side is decided **alone**. `target()` caps it by its own planned width (`sideCap` when narrower than drawn). On upright phones `phoneSide(value, w, content)` yields toward 20 when `ceil(content)+4 + 2·side > w`. Nothing looks at the box's peers.
- For a **hug** box, `w = own(n, slot) = min(drawnW, slot)`. At its drawn width a hug box is exactly `content + 2·side`, so the 4px slack plus `ceil()` of a fractional glyph width makes the guard yield 0–2px **even when the row has plenty of room**. How much it yields depends on each label's fractional width, so peers come out different. This asymmetry is **created by the converter**, not drawn.
- Once the slot is narrower than one peer's drawn width, only that peer hits `sideCap`/`phoneSide`, and its sides drop while the others keep theirs.

Real data (inspo `ugzebt`, three hug Buttons, drawn 28/28, sizes 223/188/256, words 163.16/127.52/193.94 + 0.48 trailing tracking):
- Plan at mobile_portrait: `udrbuj` `(223−168)/2 = 27.5`, `sfnqyg` `(188−132)/2 = 28`, `qhjfde` w = slot 230.9 < 256 → 20.
- Chrome on main .22 (`chrome-main22.txt`), padding L/R:
  - 390: 27.5/27.5, 28/27.52, 22.73/22.73.
  - 375: 27.5, 28/27.52, 20.
  - 360: 24.65, 28/27.52, 20.
  - 320: 20, 24.54, 20.
  - 1200–480: all 28.
- **Drawn vs converter asymmetry.** Figma draws L=R=28 for all three. The right side's 27.52 is the deliberate tracking compensation (`style.ts:220`: right − trailing letter-spacing 0.48). It is the same on every peer, and the visual right edge = 28. It is **not** peer inequality.
  - Separate small oddity, not owned: `emit/settings.ts:11 len()` rounds the base 27.52 → "28" while the phone clamp keeps 27.52px. That's a uniform 0.48px desktop difference on tracked buttons. Record it as a Low found-else item, not part of F3.
  - Positive drawn-uneven twins exist in the same file: arrow pills drawn 24/4 (`72:1047`, `91:1099`, …) must keep their drawn left≠right.
- **Second, separate cause on this real section (not owned):** at ≤768 the pills' real container is much narrower than the plan.
  - 375: plan 230.9, Chrome 143. 320: Chrome 88. 768: plan 499.8, Chrome 440.
  - Their row `iuyqtj` is [56px arrow image, content, 56px arrow image] kept on one line. `layout.ts:95-104` shares by drawn widths (×0.9054), but CSS keeps the arrows at `_width:56`. `keeps()` (least.ts:148) holds pictures on laptops only.
  - So on inspo the labels wrap to 2 lines at ≤390, and the CSS clamps are computed from the wrong slot.
  - F3 cannot fix this. It's the row-allocation area **fixed-tile-shrink** owns, but outside its compact-*box* predicate (these are images). New found-else item; re-measure after fixed-tile merges.

## Root cause 2: wrapped-row least (6ad2841), from the preserved evidence

- `least.ts:122`, `:141` and `reading :106` sum a row's items whenever `flow.mode === "row"`, even when `flow.wrap`. Main .22 confirms it:
  - inspo `ugzebt` least 690.6 (221.2+185.5+251.9+2×16) where the widest pill is ~252. It bubbles up to `mqgnkp` 690.6, `ookyfs` 738.6, `iuyqtj` 914.6 (`anc-ugzebt.txt`).
  - `tvmorh` least 1144.7 → strip `feuwkb` 1553.7 (`anc-tixrqb.txt`).
- Consumers of `least` (all in the plan): `shapes.decideRow` firmWidth and the buttons/half/ALONE checks, `sharesHold`, `gridColumns` firm, `laptopRow`, `content()` → L1A phone side guard, `rows.ts:69/:108` fill floors, `label.ts:26`, `unpin.ts:87` (buttonLike only, so unaffected).
- Reverted experiment, measured (`evidence/pill-clip/base-hydraulics-ir.json` vs `v3-hydraulics-ir.json`, `interim-probe` vs `v3-probe`):
  - 28 hydraulics "Scard chips/body" nodes' least dropped (e.g. 216→73, 287→255).
  - Grid `lampsl` (Bento): columns 2→3 at tablet and 1→2 on sideways phones. At 768 cells went 340→221px and three `words-per-line` **errors** were added (`olwycy` 10 words on 4 lines, `bluiyr` 11/5, `hfkvxb` 11/4). Page height 7493→7226.
  - Laptop rows `lugbjl`/`rnwkav` keep→wrap at fluid, though their own least/room were unchanged. **Unexplained here**; the builder must not assume a cause.
- **Conclusion:** the summed least is a wrong *measurement*, but today it's the only thing keeping body-copy grid cards at 2 columns at 768. `GRID_MIN` (200) alone allows 221px cells. Correcting `least` exposes that gap. Closing it means adding an explicit reading-width rule to grid/row decisions, a **new grid policy**. Auto-go cannot grant that (brief; rules summary "No grid/ALONE/twoShare/wrapped-parent-minimum policy change"; layout-floors body reading floor is "padding only, not row/grid least", unconfirmed).

## Fractional floor / ceil (found-else :156/:168): explained, not changed
`unpin` floors round (279 vs least≈279.32). On the same path the label stays one line at tablet/375/360. At 320 the real 248px row genuinely can't fit it, and pill-clip's actual-parent cap already handles that. No same-path fractional-only wrap has been shown. **No blanket ceil.** This plan's own guard already uses `ceil(content)+4` and changes no floor rounding. Leave :156/:168 open as an unconfirmed hypothesis. Close only with a proof that wraps from rounding alone.

## Decisions for the parent (recorded, not implicit)
- **F3 — already approved (F3 A).** Implement it with peers defined narrowly (below).
- **G1 — an interpretation of L1A, parent must see ⭐ A.** For a **hug-width** box the phone guard's boundary is the slot the parent gives it, not `min(drawn, slot)`. The box only needs `ceil(content)+4+2·side ≤ slot`.
  - Fixed-width and fill boxes keep their own-width boundary unchanged.
  - Effect: tight hug buttons stop yielding 0.5–2px with room to spare, corpus-wide.
  - Separate commit, separately revertible. Record it as "My ruling, not yet confirmed".
  - B: keep the current boundary. Peers then all share the smallest yielded value (e.g. all 27.5).
- **W — wrapped least ⭐ A: stays deferred in this batch.** Record the diagnosis above as the documented reason.
  - B (needs Justin): correct the wrapped least everywhere **and** add an explicit grid/row cell reading floor, so hydraulics Bento stays 2 columns at 768. That needs its own plan and approval.
  - C: correct only the non-decision consumers (L1A `content`, rows.ts fill floors). Only if Task 0 finds a real affected node; none is shown today.
  - **No ALONE/grid constant, branch or column change in this batch.**

## Design (F3 + G1)
- **Peers** = ≥2 siblings among `layout.items(row)` of one flow row (wrapping or not) where:
  - every one is `buttonLike`;
  - same `role`;
  - equal drawn left and right (`src.flow.padding`) **and** equal styled left/right padding, so tracking compensation matches;
  - not items of a divided row (`dividedOf` already evens those).
  - Cards never qualify, so card sides and inner widths cannot shift grid/row decisions.
- **Shared value:** at each tier, each side of each peer shows `min` over the peers of `target()`. This happens inside `target()`, so the `sideTrail` write/skip cascade (P2B, P1A) stays one function. Vertical sides are never shared.
- **Peer widths before the peers are visited:** in `layout.visit`, after computing `give`, pre-set `room`/`width` (and the phone CSS slot) for **all** flow children, then recurse (idempotent, same values). This removes the "peer widths not yet known" blocker from layout-floors without a new engine.
- **CSS:**
  - When all peers get the same CSS slot `S` (wrap/stack/two shapes or drawn wrapping), emit one shared `clamp(20px, calc((S − maxNeed)/2), side)`. With G1-B, also `min(..)` with the constant `min_i (W_i − need_i)/2`.
  - When slots differ (a kept row), emit `min()` of the peers' clamps. A test has to show that case is reached, else drop the branch.
  - `ownCSS` stays the box width, plus a stored slot expression for hug boxes (G1).
- **`least` must not change.** `sidesWith(..., drawn=true)` gets no peers (the drawn view already passes content 0), so `least`/`content`/every grid, row and ALONE input stays byte-identical. `sidesAt` (plan view) changes only for peer pills and hug boxes (G1).

## Touches (exact)
- **Owned source:**
  - `src/core/adapt/sides.ts` (peer group, shared target, phone CSS forms, G1 boundary);
  - `src/core/adapt/layout.ts` (child pre-pass, hug slot CSS map + accessor, only in `visit`/Layout interface);
  - `src/core/adapt/least.ts` (`view()` passes peers/slot to the plan view only; **no change** to `least`/`content`/`reading`/`button`/`floored`);
  - `src/core/adapt/rules/space.ts:64-73` (its SideView supplies peers/slot).
- **Not owned, read-only:**
  - `shapes.ts`, `kinds.ts`, `rows.ts`, `unpin.ts` (fixed-tile-shrink);
  - `facts.ts`, `divided.ts`, `emit/*`, `style/*`, `adapt/types.ts`;
  - GRO's files.
  - If a fix needs one of them, stop with RED and ask the parent.
- **Owned tests:** new `test/fixtures/peer-pills.ts`, `test/unit/adapt-peer-sides.test.ts`, `test/browser/peer-sides.test.ts`.
- **May edit only directly contradicted cases, with stronger assertions:**
  - `test/unit/adapt-sides*.test.ts` / `adapt-phone-sides*` / `adapt-layout-floors*`: search for exact-value assertions on hug-button phone sides (e.g. `27.5`, `clamp(20px` strings, `phoneSide(` at drawn width) before building and list each one in the ledger.
  - `test/browser/layout-floors.test.ts`: read-only regression gate.
  - `test/fixtures/clipped-pills.ts` and fixed-tiles fixtures: read-only controls.
- **Golden payload tests** that pin phone padding strings: the builder lists them after its RED run. The parent grants each exception by name.

## Sequencing and overlap
- **fixed-tile-shrink first.** It owns `kinds/shapes/rows/unpin`. `layout.ts`/`least.ts` are conditional there, so if its builder is granted `layout.ts`, this batch rebases on top and recomputes line references.
- This builder starts only after fixed-tile is merged and verified. Then reproduce RED and baselines on that exact main.
- No simultaneous builders on `layout.ts`/`least.ts`/`sides.ts`/`space.ts`. GRO also in sequence if it needs row allocation.
- Rebase shared HANDOFF/found-else/check numbers at integration. Do not duplicate fixed-tile's compact reservation. Re-measure the inspo arrow-row allocation after fixed-tile merges and record the outcome.

## Tasks (TDD; ledger `.superpowers/sdd/responsive-pill-planning/progress.md`)
0. **Baseline.**
   - On a clean copy run `check`, `corpus`, save the full report/pastes/HTML, and `snap --sides`: inspo 1200,992,768,600,480,390,375,360,320 plus hydraulics 768.
   - Write a **shape/column diagnostic script** (scratch, never committed into src): for every node in the five corpus files + debug copy + inspo, dump `least` (both modes), `row`, `columns`, `room` and `width` at all tiers. Re-run it at the close; every row/column/least must be identical.
   - Optional W-C probe: list nodes whose L1A `content` differs between summed and widest wrapped measure *and* whose phone side yields. Report only.
1. **RED — peer equality (plan).**
   - Fixture: three or four hug button-like pills, labels with varied fractional glyph widths, drawn sides 28, in a drawn-wrapping row inside a column whose phone slot lies between the shortest and longest need.
   - Assert: for every tier, left and right shown sides are equal across peers and equal the minimum of the individual targets.
2. **GREEN:** pre-pass in `layout.visit` + peer `target()`.
3. **RED/GREEN — CSS equality.** Peers' `_padding:mobile_portrait` left/right strings are identical (shared-slot form). A kept-row variant takes the `min()` form or is shown to be unreachable.
4. **RED/GREEN — G1** (separate commit):
   - Ample slot: the hug pill keeps its drawn side exactly at its drawn width (no 27.5).
   - Boundary at slot = `ceil(content)+4+2·side` −1 / 0 / +1.
   - Fixed-width and fill boxes byte-identical to baseline.
5. **Controls** (each must stay byte-identical to baseline unless stated):
   - drawn-uneven 24/4 arrow pills keep left≠right;
   - a single pill;
   - Button vs painted-box mix (not grouped);
   - different drawn or styled sides, i.e. tracking mismatch (not grouped);
   - alike *cards* with equal sides (not grouped; sides/rows/columns unchanged);
   - divided row items (divided rule wins);
   - a vertical side never shared;
   - P2B: tablet squeeze persists on sideways phones and the portrait restore still works.
   - Also assert `least(n, tier, buttons?)` is byte-identical for every fixture node.
6. **Browser** `test/browser/peer-sides.test.ts`, at 1200, 992, 768, 600, 480, 390, 375, 360, 320 plus an integer sweep 320–478. Each check against actual rects:
   - computed peer paddings equal (≤0.01px);
   - each side ≥ min(drawn, 20);
   - label one line where its slot holds it;
   - no pill or page horizontal overflow;
   - peers inside their parent.
7. **Mutants** (each must fail ≥1 test, then restore):
   - (a) no peer min;
   - (b) group by role ignoring sides;
   - (c) peers in the drawn view (least golden fails);
   - (d) own-width hug boundary (G1 test fails);
   - (e) numeric shared but CSS per-pill;
   - (f) cards admitted as peers;
   - (g) **original regression:** reapply `6ad2841`'s reverted `along` widest-item least in scratch. The Task 0 shape diagnostic must go red on hydraulics `lampsl` cols 2→3 at tablet, which proves the grid gate catches the original regression. Restore immediately and verify hashes.
8. **Real files.**
   - Replay main vs branch: five corpus files + debug scratch copy + inspo. Diff payloads element by element. Changed elements = peer pills / hug buttons' phone padding only.
   - Chrome 17 widths including 375/360/320: no new lint identity, no height change beyond the measured pill rows, no circle/shape change.
   - Inspo `ugzebt`/`tixrqb` peers equal at every width. Say plainly that ≤480 label wraps remain from the arrow allocation.
   - `corpus`: same 17 worse-than-v1 identities, full report compare at .005/.02. Shape diagnostic: zero row/column/least deltas.
   - Snaps into `shots/after`; copy pairs to `~/.hermes/plans/figma-to-bricks/shots/responsive-pill-planning/`.
9. **Docs & records.**
   - Plan → `docs/plans/2026-10-21-responsive-pill-planning.md`; ledger → `docs/plans/…-ledger.md`.
   - `docs/HANDOFF.md` with the next free paste check (inspo pill sides at 390/375/360/320).
   - Finisher bumps `BUILD`. Main `CLAUDE.md` Start here / Where things stand via the permitted path, or a pending file in build order.
   - New rule: "alike button peers in one row share each side's smallest shown value (plan and CSS); hug boxes judge the phone guard against their slot (if G1 lands)". Update rules-summary only if it lands.
   - found-else:
     - close :161/:167 only after verified merge;
     - keep :150/:165 open with this diagnosis and the W-B question for Justin;
     - keep :156/:168 open/unconfirmed;
     - add new Lows: (i) inspo arrow-row plan/CSS allocation mismatch (plan 230.9 vs real 143 at 375); (ii) settings `len()` rounds tracked right padding 27.52→28 on desktop; (iii) unexplained `lugbjl`/`rnwkav` keep→wrap in the reverted experiment.

## Closure criteria
- F3 is fixed when, on the merged main:
  - generic peers are equal plan+CSS at every tier and every integer phone width;
  - inspo `ugzebt` peers measure equal at all 9 widths;
  - least/row/column diagnostic shows zero deltas;
  - corpus is no worse;
  - all mutants are killed.
- Wrapped least is **not** closed by this batch.

## Risks
- G1 changes many hug buttons' phone padding by ≤2px; measure every one.
- The pre-pass must give exactly the values `visit` writes later; assert equality.
- CSS `min()` strings get long; check the paste size delta.
