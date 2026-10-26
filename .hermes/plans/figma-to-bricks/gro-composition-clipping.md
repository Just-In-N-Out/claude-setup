# gro-composition-clipping — plan (PLANNER, round 4)

Base: main `5e32aec` (BUILD 2026-10-21.22). Planner only: no source/tests/worktree/commits. Model reassessment: **in-between, Opus 5.5 medium is right** (two small, independent generic fixes in two files outside the fixed-tile/responsive allowlists; the rest is deferral with evidence). Reviewer: Opus xhigh (in-between rule).

Evidence (read-only, reproducible): `~/.hermes/plans/figma-to-bricks/evidence/gro-composition-clipping/` — `main-5e32aec-gro.html` (replay of `corpus/files/gro-home.json` at main), `probe.ts` (real `runLint` text-clipped/overflow-x + target rects at 14 widths), `textprobe.ts`/`kids.ts` (ancestor chains), `simulate.py` (scratch CSS emulation of fix A), `geo-main.json`/`geo-sim.json`/`geo-sim2.json`, `MANIFEST.sha256`. Fix B emulation = sim.html + `@media (max-width:991px){#brxe-wxjdlj{height:auto!important}}`.

## 1. Playback
1. GRO's open clipping ledger items (found-else.md lines 110, 111, 166; same items repeated in the pill-clip builder "Fold" notes) are four claims: `eixorr` four texts cut @1440; `04` cut @991–480; footer `Contact` cut @768; the 992 "Good marketing…" paragraph squeezed past its section.
2. Decide for each: designer-intended off-edge composition, or a converter defect; fix only the generic defects, with no blanket overflow-visible, clip dropping, absolute stripping, carousel redesign or width/grid/ALONE policy change.

## 2. Dedupe ledger (one finding each)
| ID | Ledger lines | Element | Widths on main 5e32aec (real lint) | Verdict |
|---|---|---|---|---|
| G1 | 110, 166 (“eixorr”) | `eixorr` section “06 · Selected work — Afternoon (horizontal scroll, start)”, card `wxjdlj` | 1440, 1200, 992: 4 texts | **Intentional design** — defer |
| G2 | 111, 166 (“04”) | Services TOC row `cuggpy` → `tebrmk` “04” | 991, 900, 768, 767, 600, 480, 479 | **Converter defect A** — fix |
| G3 | 111, 166 (“Contact”) | Footer row `fjhbmi` → `leyjla`/`xkwbrv` | 768 (2 texts) ; also overflows 900 (sw852>828) unflagged | **Same defect A** — fix |
| G4 | 166 (“992 paragraph”) | Services intro row `awcvtv` → `ojecld` | 992 (1 text) | **Consequence of approved laptop policy** — defer with options |
| G5 (new) | — | `eixorr` card `wxjdlj` once it joins the flow | 390, 375, 360, 320: 3 texts (“Brand Strategy · Photography · Social”) | **Converter defect B** — fix |
| G6 (new, record only) | — | hero `pxflfh` turned “Vertical locator” `mntbim` | 480, 479 | Not owned (turn/rotation margins at mobile_landscape); record |
| G7 (new, record only) | — | `eixorr` Container+card 320px wide at viewport 320 (16px sideways) | 320 | Pre-existing phone floor (descendant `rcagtp` min-content); record for layout floors |

## 3. Root causes (file:line evidence)
**G1 intentional.** Figma: section `clips`, 1440×900; card frame drawn 1300→1648 (absolute, right −208) in a frame the designer named “horizontal scroll, start”. Figma itself crops it at 1440; section heights match Figma exactly (snap diff 0 at 1440/1200/992). Below the design width `compose.stack` (`adapt/rules/compose.ts:57–79`, user 2026-10-07 “next card of a sideways gallery comes after the section's content”) already moves it into the column from 991. Making a real sideways scroller is carousel redesign (out of scope). The lint finding is a true “cut” but matches the drawing; leave lint unchanged (no marker exists to tell it the clip is drawn; adding one = new paste output). Record as intentional, not fixed.

**Defect A (G2, G3): an inferred row's sideways nudge is a share of the whole row, while its items and gaps stay px.** `src/core/style/place.ts:110–124` `nudgeStyle`: row main nudge → `share(g.main)` = nudge / parent inner width (comment at :111 claims it “narrows with the parent instead of pushing it wider” — false whenever the row also holds fixed items/gaps). Row width needed = F + Σshare·W, with F = drawn item widths + gaps. Overflow = F − (1−Σshare)·W > 0 for every W below the design width.
- TOC `cuggpy` (inferred row, drawn 1319, 8 items 360px + 7×12 gap ⇒ F≈444; shares 21.87/22.05/22.12% ⇒ Σ66.04%): overflow 446−0.3396W ⇒ measured scrollWidth 1150@1200, 1011@992, 1045@991, 898@768, 734@480 (exact match). Cut once “04” crosses the section edge.
- Footer `fjhbmi` (inferred row, drawn 1184, gap 133 ⇒ F=394+4×133=926; shares 18.45/1.69/1.69%): with the tablet stepped gap 72 → content 671 + 21.83%·696 = 823 > 696 ⇒ “Contact” at 762–859 @768 (exact). 900: 852>828 (unflagged). Not the min-widths themselves (they sum 383 ≤ 696) and not gap stepping alone (671 ≤ 696): it is the row-share margin.
- Not seen by the planner: `least.ts`/`layout.ts`/`shapes.ts` never read nudges (search: no `nudge` there), so the row decision believes the row fits; the CSS then overflows. Fixing the CSS makes it match the plan; no planner change.

**Defect B (G5): a placed box brought into the flow keeps its drawn fixed height.** `adapt/rules/compose.ts:26–43` `layerStyle` returns only `{position:relative, width:auto}` for a box; `size.unpin` (`unpin.ts:56–61`) deliberately skips placed layers (“height belongs to the composition, M2c”). So `wxjdlj` keeps `_height:525` from 991 down; on upright phones its inner row `gmsyqw` stacks (`_direction:mobile_portrait: column`) and the image grows by aspect ratio, content > 525, and Bricks Blocks wrap (rules: “Blocks wrap ≤767px”) sends the last row into a second column at x=362 (scrollWidth 692 @390), clipped by the section. Generic: any placed card with flowing content that compose.stack moves into the column.

**G4 deferred (policy-limited, not designer intent).** `awcvtv` row = H2 picture `bhbqub` 824px fixed + prose. On laptops pictures keep their set width by approved policy: `least.ts:146–151` `keeps`, `shapes.ts:73–77` (“Laptop P1A: only whole labels reflow here, never cards/twoShare/ALONE”), `:98` “Pictures keep their floors”; picture's `_widthMin:tablet_portrait:0`/aspect-ratio start at 991 (`size.unpin`). At 992 prose gets min-content 120px and overflows 89px. Correct fix needs a laptop ruling (Justin): **(a)** keep (current) ⭐ for this batch; **(b)** let an outlined-words picture shrink by aspect ratio on laptops beside prose (`min-width:0` + aspect at base) — corpus-wide laptop change, overlaps fixed-tile's `sizing.ts`/`least.ts` floors; **(c)** laptop row stacks/wraps when picture floor + prose reading floor > room — touches `shapes.ts laptopRow`, reverses P1A scope. Neither (b) nor (c) is auto-approvable here.

## 4. Fix
**Task A — free-space share for inferred row nudges** (`src/core/style/place.ts` only). For a flowing item in an **inferred, non-wrapping row** with numeric `g.main > 0`:
`margin-left: max(0px, calc((100% - Fpx) * s))`, where F = Σ drawn widths of the parent's flowing (non-placed) items + drawn gap×(n−1) (+ their numeric turn margins), D = inner − F, s = g.main / D (rounded 4 dp).
- Exact at the design width (W=inner ⇒ g.main, independent of F rounding); shrinks to 0 before items/gaps must; never negative.
- Unchanged: `auto` nudges, negative nudges (keep current share — they hang), column nudges/`slides()`, cross nudges, wrapping rows, D ≤ 0 (fallback to current share), turned items' own margins.
- Typed CSS string like the existing `slides()` form (`place.ts:122`); no breakpoint writes (base style; `rows.ts:83` stacked-nudge resets and `space.ts` unaffected). Conservative at tiers with stepped gaps (F uses drawn gap): footer columns pack left at 991–768 instead of spreading (emulated: Contact 616–715 @768, row 696=696). Per-tier spread with stepped gaps (adapt/rules/space.ts) deliberately deferred — space.ts is responsive-pill's file.
- Emulation on real GRO (`geo-sim.json`): `04` clean 991→479, Contact clean @768, TOC fits at 1200 (1077), 1440 rects byte-identical to main for all measured ids; phones: TOC 2-per-row items no longer get 63–79px left offsets at 390–320 (now 0).

**Task B — release a composed box's drawn height** (`src/core/adapt/rules/compose.ts` `layerStyle` only). For a box (not picture/text) that has flowing children and a numeric base `height`: add `height: "auto"` at the tier where it joins (and nothing else). Empty/decoration boxes and pictures/texts unchanged; `order`/`hide` paths unchanged; no unpin change. Emulation (`geo-sim2.json`): G5 clean at 390/375/360/320; 768/600/480 unchanged; G1 at ≥992 untouched (still placed).

## 5. TDD (builder; `test-driven-development`)
Fixtures generic, built with test builders (no GRO names/ids/texts/pixels): `test/fixtures/inferred-row-nudges.ts` (new).
1. **RED unit** `test/unit/nudge-free-share.test.ts` (new): (i) “index” row: 4 short labels + 4 fixed pictures spread across a 1320 frame without auto layout ⇒ every numeric nudge style is `max(0px, calc((100% - Fpx) * s))` and evaluates to the drawn nudge at the inner width (compute in test with a tiny evaluator of the emitted string at W, or assert F and s); (ii) “footer” row: logo + 4 column frames, wide gap; (iii) varied: uneven nudges, one fill child, hug texts — sum of margins + F == inner at design width ± 0.5. Controls: nav bar with `auto` nudge unchanged (`style-layout.test.ts:155–164` Home `auto`, CTA `{}`), negative nudge unchanged, column nudges and `slides()` unchanged, wrapping row unchanged, D≤0 fallback.
2. **Existing test that pins the old outcome:** `test/unit/style-layout.test.ts:163` (`"3.04%"`, “34px of the row's 1120px inner width”) — builder may update **only this assertion** to the new form with stronger exactness (value at 1120 = 34px). Also search `test/` for other `%"` row-margin expectations (`grep -rn 'left: "[0-9.]*%"' test`) and list each in the ledger before editing.
3. **RED browser** `test/browser/composition-clipping.test.ts` (new, own file — don't extend layout-floors/designs): render fixtures (i)(ii) at 1440 (design: every item rect within ±1px of drawn), 1200, 992, 991, 900, 768, 767, 600, 480, 479, 390, 375, 360, 320 and an integer sweep 320–478: row `scrollWidth ≤ clientWidth+1`, every text rect inside the clipping section, `runLint` text-clipped/overflow-x empty for the fixture. Same-fixture mutant: old `share()` path ⇒ must fail at 991/768/480.
4. **RED unit** extend `test/unit/adapt-compose.test.ts` (twin of `:54–71` “next card past the section's edge”): card frame with photo + caption + a two-text row ⇒ `_height:tablet_portrait === "auto"`; controls: placed empty painted rect/vector joining keeps its existing output; picture/text join outputs unchanged (`:25–52` stay green unedited).
5. **RED browser** (same new file): that card at 390/375/360/320 + sweep: card `scrollWidth ≤ clientWidth+1`, all its texts in one column inside the section; 768/480 heights ≥ drawn content. Mutant: drop `height:"auto"` ⇒ fails at 390.
6. Meaningful mutants (record RED/GREEN in ledger): A1 old share; A2 F without gaps (must fail exactness or overflow at 768 footer twin); A3 no `max(0px…)` (negative margins at 320 ⇒ fail); B1 no height release; B2 release applied to empty boxes (control must fail).
7. GREEN, then `npm run check`.

## 6. Proof / gates
- Before Task 1 (copy == main): `npm run snap -- corpus/files/gro-home.json .superpowers/sdd/gro-composition-clipping/shots/before 1440,1200,992,991,768,600,480,390,375,360,320 --sides` (comma list; assert every PNG exists); after: same into `shots/after`. Copy services TOC, footer and selected-work section pairs (desktop 1440 + 768 + 390) to `~/.hermes/plans/figma-to-bricks/shots/gro-composition-clipping/`.
- Run `node <evidence>/probe.ts <copy> <replay html> …` on main and branch replays: closure = G2 0 cuts at 991–479, G3 0 at 768 and footer sw≤cw at 900/768, G5 0 at 390/375/360/320; G1 still exactly 4 @1440/1200/992 (documented intentional); G4 unchanged (deferred); G6/G7 unchanged; 1440 rects of every GRO element within ±1px of main.
- Corpus: save `corpus/report-v2.json` + `corpus/out/v2/*/bricks.json` before Task 1; at close diff per element id (row nudges appear in other files — expect changes only in `_margin.left` of inferred-row items and `_height:tablet_portrait` of composed boxes; any other key diff stops the build). Measure changed elements' rects at every corpus width and 375/360/320 (phone margins change). No worse lint/heights; same 17 v1 identities; label fonts loaded sets.
- Merge gates: `npm run check`, `npm run test:browser`, `npm run corpus` on the rebased branch.

## 7. Touches / ownership / sequencing
- **Source (owned):** `src/core/style/place.ts` (nudgeStyle only), `src/core/adapt/rules/compose.ts` (layerStyle only).
- **Tests (owned):** new `test/fixtures/inferred-row-nudges.ts`, `test/unit/nudge-free-share.test.ts`, `test/browser/composition-clipping.test.ts`; edit `test/unit/adapt-compose.test.ts` (add cases only); `test/unit/style-layout.test.ts:163` single assertion as above. Read-only gates: `test/browser/layout-floors.test.ts`, `designs.test.ts`, `strips.test.ts`, `adapt-compose.test.ts:1–93` existing cases, `past-edge.test.ts`.
- **Not touched:** `least.ts`, `layout.ts`, `shapes.ts`, `sides.ts`, `kinds.ts`, `sizing.ts`, `unpin.ts`, `rows.ts`, `space.ts`, `adapt/types.ts`, lint, paint/picture (hero), site-media/site-pages (media), normalise contacts/card-title/page-words/page-links (phone), renderer font helper.
- **fixed-tile-shrink** (owns kinds/shapes/unpin/rows, sizing reading, its own fixtures): no source or test overlap with this plan; shared output only (GRO/hydraulics pastes, footer column widths at tablets via row allocation). **Dependency declared:** build fixed-tile first per parent; GRO builder starts from main after fixed-tile's verified merge (or, if parent runs parallel, must rebase onto it and regenerate same-base before/after + probe before merge). No duplicate of its row allocation/unpin fix.
- **responsive-pill-planning** (sides/layout/least/space): no overlap; space.ts deliberately not touched (per-tier nudge spread deferred to avoid it). Any later per-tier nudge ramp must sequence after responsive.
- Max one of these three touching GRO corpus evidence at merge time; finisher re-runs probe on final main.

## 8. Risks
- Footer columns pack left on tablets (no spread) — conservative, no clipping; flag in report as deferred minor.
- Phone TOC/footer items lose leftover %-margins at ≤478 (they were offsets of 63–80px, likely contributing to GRO "hole" warnings) — measure, don't assume improvement.
- Other corpus files' inferred rows shift slightly at 992–1439 (margins shrink earlier). Exact at design width by construction; measure.
- G1 stays an error-level lint finding at ≥992; documented intentional, not a regression.

## 9. Docs & records (final task)
- Plan → `docs/plans/2026-10-21-gro-composition-clipping.md`; ledger → `docs/plans/2026-10-21-gro-composition-clipping-ledger.md`.
- `docs/HANDOFF.md`: section with G1–G7 verdicts, next free paste check (after 3av; renumber at merge if taken) — paste check: GRO page @1440 card peek unchanged, @768 footer Contact fully visible, @991–480 TOC “04” visible, @390 selected-work card single column.
- BUILD bump at merge; finisher updates main `CLAUDE.md` “Start here”/“Where things stand” (pending file if denied, after older pending in build order).
- New CLAUDE rule (Where things stand / layout): “Inferred row nudges are shares of the row's free space (exact at design width, 0 before items shrink); a placed box composed into the flow lets go of its drawn height.”
- found-else.md: strike G2/G3 (lines 111, 166 parts) and add G5 fixed after verified merge only; keep G1 (intentional, deferred: real sideways scroller = carousel decision), G4 (laptop picture-floor ruling a/b/c owed to Justin), add G6, G7 as open records.
- rules-summary.md: add the nudge/compose-height rule only if CLAUDE.md gains it.
