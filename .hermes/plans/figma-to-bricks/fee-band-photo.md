# fee-band-photo: the Fee Construction band's picture is too small (B-Dry Home paste)

Mini plan, 2026-10-29. Planner evidence: `~/.hermes/plans/figma-to-bricks/evidence/fee-band-photo/planner/`
(`live/live-measures.json` and `live/<site>-<width>.png` = both live bands measured in headless Chrome at 1920, 1440,
1366, 1024, 767, 390; `probe-live.ts` + `run-probe.sh` re-run it; `post-155.min.css` = staging's live CSS).

## Questions (⭐ = taken under Justin's "go with the recommended")

1. **Where does the file Justin pastes go?**
   - A ⭐ A new file `C:\Users\Admin\Downloads\bdry-home-with-header-v5.json` (header + whole Home, as he pastes now);
     the old `bdry-home-with-header.json` stays as it is.
   - B Overwrite `C:\Users\Admin\Downloads\bdry-home-with-header.json`.
   - C Evidence folder only; Justin is told the path.
2. **How do the three jobs (this one, `services-band-speed`, `sixty-years-marker`) land in one paste?**
   - A ⭐ One v5 built from v4: each job writes only its own edit module `bdry-paste/v5/edits/<job>.ts` (the element
     ids and keys it changes, checking their v4 values first); one `v5/scripts/build-v5.ts` applies every module that
     is there to v4 in name order, refuses two modules that touch the same element id, and joins the header. Each job
     landing re-runs it; the manifest lists which edits the file holds.
   - B One version per job in landing order (v5, v6, v7).
   - C Three separate pastes.
3. **The kicker sits 4px too close to the heading on phones (≤767).** Fix it here?
   - A ⭐ Yes: one key on the kicker, phones only (it's in this band and moves the picture 4px).
   - B No, leave it within the tolerance.

## Playback

In the B-Dry Home paste's navy "Fee Construction" band ("BDry Is Now Proudly Owned And Operated by Fee
Construction!"), the "Stronger Together" picture on the right is much smaller than on bdryswi.com. Make the band
(picture, columns, padding, height) match bdryswi.com at every width, phones included, in a new paste version built
from v4 + the header, as one file Justin pastes.

## Root cause (measured live on both sites, same widths)

**The plugin did not make this band.** It is the hand-built v1 band (`dchafl`), carried unchanged through v2–v4. No
plugin code changes.

1. **The picture is frozen at its 1440 size.** v4 `home-paste-v4.json` element `vyxzea` ("Stronger together", media
   103), `_cssCustom`: `#brxe-vyxzea { height: 330px; width: auto; }` above 1366px (live on staging as
   `#brxe-vqtlja { height: 330px; width: auto;}` in `post-155.min.css`; Bricks renamed the id). bdryswi.com sizes the
   picture as a share of its column: `.elementor-element-5e6ef80 img{width:90%}` (all widths), where the column is half
   of a box 60% of the window wide (`33effd6 {--content-width:60%}`, `1e03b75/0b18be4 {--width:50%}`, `@media
   (min-width:768px)`). The two agree only at 1440 (both 362×330). Live:

   | width | bdryswi picture | ours | bdryswi band | ours band |
   |---|---|---|---|---|
   | 1920 | **491×448** at x 1007 | **362×330** at x 1072 | 722 | 655 |
   | 1440 | 362×330 at x 760 | 362×330 at x 760 | 866 | 843 |
   | 1366 | 653×596 | 656×598 | 684 | 690 |
   | 1024 | 482×440 at y 84 (centred) | 485×442 at y 39 (top) | 617 | 595 |
   | 767 | 747×681 | 747×681 | 1041 | 1037 |
   | 390 | 370×337 | 370×337 | 946 | 902 |

   **Justin's two screenshots** are both at about 75% browser zoom (a ~2560px CSS window): ours 272×247 = 0.75 ×
   362×330; bdryswi 494×451 ≈ 0.75 × 664×606 (90% of (0.3×2560 − 30)); text-to-picture distance 606 ≈ 0.75 × 815
   (0.315W + 8.5 at W = 2560). Above 1440 the gap grows with every pixel of window.
2. **Band padding is fixed px, bdryswi's is a share of the width.** Ours: `ipqzie` `_padding` 29/43 (= 2%/3% of 1440),
   then 20/31 (≤991), 15/23 (≤767), 8/12 (≤478). bdryswi: `33effd6 {--padding-top:2%;--padding-bottom:3%}` at every
   width: 1920 → 38/58 (ours 29/43), 1024 → 21/31 (ours 29/43).
3. **Columns.** Ours grow from 0 (`ewxxsj`/`wwfgrm` `_flexGrow 1`, `_flexBasis 0px`), so at ≤1366, where the text
   column's padding is `0 0 0 15px` and the photo column's 10px all round, the photo column is 5px wider (1366: 671 vs
   676; bdryswi 673/673). The row doesn't stretch its columns (1024: text 523 tall, photo 462), so the photo column's
   `justify-content: center` (≤1366) does nothing and the picture sits at the top; bdryswi's columns are equal height
   (`--container-widget-align-self:stretch`), so its picture is centred beside the text from 768 to 1366.
4. **Kicker on phones.** bdryswi's kicker widget has margin-bottom −22px on an 18.2px line (≤767), so it counts as 0
   and the heading starts 20px below the kicker's top; ours (`wnfmya` `_margin.bottom -22`) counts −3.8, so the heading
   starts 16px below: 4px higher, picture 4px higher (767: heading 31 vs 35, picture 323 vs 327).

**Not to copy:** bdryswi's Roboto 600 face fails to load (memory note), so its kicker and heading use wider fallback
metrics: its heading is 3 lines at 1920/1024 and 4 at 390 where ours is 2/2/3, and its kicker wraps at 1440. Band
heights therefore differ by those lines; the ACs compare font-neutral measures (picture, columns, padding, gaps).

## The fix (paste data only; v4 and the header are never edited in place)

Edit module `bdry-paste/v5/edits/fee-band-photo.ts`, five elements of the `dchafl` band, each change asserting the v4
value first:

- **E1 `vyxzea` (picture)** `_cssCustom` becomes
  `#brxe-vyxzea {\n  width: 90%;\n  height: auto;\n}\n@media (max-width: 1366px) {\n#brxe-vyxzea {\n  width: 100%;\n}\n}`
  (bdryswi: 90% of the column above 1366, `width:1000px` capped at 100% from 768 to 1366, 100% below). The block's
  `_alignItems: center` keeps the 90% picture centred; `size: full` keeps Bricks' 1024×934 attributes, so the shape
  holds.
- **E2 `ipqzie` (Inner row)** delete `_padding`, `_padding:tablet_portrait`, `_padding:mobile_landscape`,
  `_padding:mobile_portrait`; add `_alignItems: "stretch"`; `_cssCustom` becomes
  `#brxe-ipqzie {\n  padding: 2% 0 3%;\n}\n@media (max-width: 1366px) {\n#brxe-ipqzie {\n  max-width: 100%;\n}\n}`.
  The padding goes in custom CSS, not the `_padding` control: no Bricks sample in `reference/bricks/` proves a `%`
  value in a spacing control, and the id rule outranks any Theme Style container padding. The percentages resolve
  against the section's width (the window), as bdryswi's do.
- **E3 `ewxxsj` (text column) and E4 `wwfgrm` (photo column)** `_flexGrow: "0"`, `_flexBasis: "50%"`, and add
  `_flexBasis:mobile_landscape: "auto"` (stacked columns must not read 50% as a height). The 20px gap then shrinks
  both equally, as bdryswi's `--width:50%` does. Everything else on them stays (their `_cssCustom`, `_width:mobile_landscape`).
- **E5 `wnfmya` (kicker)** add `_margin:mobile_landscape: {"bottom": "-18.2"}` (Q3 A).

No class is added or renamed; `globalClasses` are unchanged.

## Tasks

1. **Oracle.** Copy the planner's `probe-live.ts` and `run-probe.sh` into `bdry-paste/v5/fee-band-photo/scripts/`
   (new `out` path) and record bdryswi.com's band at 2560, 1920, 1440, 1366, 1024, 767, 390 (read only, `?f2b=`) into
   `v5/fee-band-photo/oracle/bdryswi-band.json`; add per width the kicker top, heading top, paragraph box, both column
   boxes and the band box. Check it against the Elementor formulas (picture width: W>1366 `0.9×((0.6W−20)/2−20)`;
   768–1366 `(W−20)/2−20`; ≤767 `W−20`; height × 934/1024; padding 2%/3% of W); stop and report if they disagree.
2. **Tests first** in `v5/fee-band-photo/test/` (reuse `v4/test/render-lib.ts`; a run script like
   `v4/scripts/run-tests.sh` with the proven CPU Chrome wrapper, Node 22.23.3, `F2B_REPO` = the worktree). Run them on a
   v4-only build and keep the failing log (AC1, AC2, AC5, AC6 must fail on v4 at the widths named in Root cause).
3. **Edit module + build.** Write `v5/edits/fee-band-photo.ts` (exports `{ job, ids, apply(home) }`). If
   `v5/scripts/build-v5.ts` doesn't exist yet, write it (Q2 A): v4 + every `v5/edits/*.ts` in name order (disjoint ids or
   stop), header-v1 joined exactly as today's file (proven: today's `bdry-home-with-header.json` content = header-v1
   content + v4 content; classes = header's, then v4's whose id the header lacks), writing `v5/home-paste-v5.json`,
   `v5/bdry-home-with-header-v5.json` and `v5/manifest.json`; `--only fee-band-photo` writes this job's check copy
   `v5/fee-band-photo/home-paste.json`. If it exists, use it unchanged. Never write in `v3/`, `v4/` or `header-v1/`.
4. **Green.** All tests pass on the build; shots per AC at every width (band crop, ours vs bdryswi side by side).
5. **Docs & records.** `v5/manifest.json` (inputs v4 + header-v1 sha256, the edit modules applied and the element
   ids/keys each changes, outputs sha256, test logs), the Downloads copy (Q1 A) with its sha256 equal to the evidence
   copy, and the B-Dry memory note's paste status as one proposed line for the main session (v5 = v4 + which edits,
   path, sha, live check owed); agents don't edit memory.

## Acceptance criteria (all proposed; tolerance ±2px unless named)

Widths W = 2560, 1920, 1440, 1366, 1024, 767, 390, rendered with the v4 renderer (render-lib) unless `(live)`.

- AC1 (proposed): the picture's rendered width and height equal bdryswi's (oracle) within ±2px at every W. Test: `fee-band-render.test.ts › picture size matches bdryswi at every width`
- AC2 (proposed): the picture's place matches bdryswi: x within ±2px; above 1366 its top is the photo column's top + 10; from 768 to 1366 it is centred in its column (top and bottom gaps differ ≤2px); at ≤767 its top − the paragraph's bottom equals bdryswi's. Test: `fee-band-render.test.ts › picture position matches bdryswi at every width`
- AC3 (proposed): the picture keeps its shape: rendered width/height within 0.5% of 1024/934, no `object-fit` crop, nothing of it clipped by an ancestor. Test: `fee-band-render.test.ts › picture keeps its shape`
- AC4 (proposed): the text column matches bdryswi: kicker, heading and paragraph left edges and the paragraph's width within ±2px at every W, paragraph font 22/20/16px as now, and at ≤767 the heading's top − the kicker's top equals bdryswi's 20px. Test: `fee-band-render.test.ts › text column matches bdryswi at every width`
- AC5 (proposed): the band's top padding (the text column's top − band top) and bottom padding (band bottom − the taller column's bottom) equal bdryswi's 2% and 3% of W within ±2px. Test: `fee-band-render.test.ts › band padding matches bdryswi at every width`
- AC6 (proposed): from 768 up the two columns are equal width (±1px) and equal height (stretched). Test: `fee-band-render.test.ts › columns split evenly and stretch`
- AC7 (proposed): nothing else in the paste changes: v5's home content equals v4's byte for byte except elements `vyxzea`, `ipqzie`, `ewxxsj`, `wwfgrm`, `wnfmya` (and ids owned by the other jobs' edit modules), those five differ only in the keys named in "The fix", `globalClasses` are unchanged, and the header part equals header-v1's. Test: `fee-band-paste.test.ts › only the band's five elements change`
- AC8 (proposed): every other top-level section keeps its rendered width and height (±0.5px) against v4 at every W. Test: `fee-band-render.test.ts › other sections keep their size`
- AC9 (proposed): the paste stays valid: the repo's `payloadProblems` finds nothing in the combined file, ids are unique, class names are unique and none is one of the site's own (`section`, `container`, `h1`–`h4`, `text1`, `cta-btn-orange`, `flip-box`, `flip-inner`, `flip-front`, `flip-back`, `circle`, `line`, `horizontal`, `text-blue`, `yellow-h2`), and `source`/`sourceUrl`/`version` are as in v4. Test: `fee-band-paste.test.ts › combined paste is valid`
- AC10 (proposed): one file holds the header and the whole Home: `bdry-home-with-header-v5.json` content = header-v1 content + `home-paste-v5.json` content, classes joined as today's file, and the Downloads copy has the same sha256. Test: `fee-band-paste.test.ts › combined file is the header plus the whole Home`
- AC11 (proposed) (live): after Justin pastes `bdry-home-with-header-v5.json` into an emptied homev2 and saves, the live band's picture and text column match bdryswi.com within ±3px at 1920, 1440, 1024 and 390 (read-only probe). Test: `probe-live.ts › live band matches bdryswi on staging`

## Touches

Evidence only (no repo source, no BUILD bump): `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/v5/`
(`edits/fee-band-photo.ts`, `scripts/build-v5.ts` if first, `fee-band-photo/{oracle,scripts,test,shots,checks}/`,
`home-paste-v5.json`, `bdry-home-with-header-v5.json`, `manifest.json`) and
`C:\Users\Admin\Downloads\bdry-home-with-header-v5.json`. Reads: v4, header-v1, the repo's renderer, Chrome harness and
`payloadProblems`.

**The other two jobs:** `services-band-speed` (the "Our Services" band) and `sixty-years-marker` (the "60 Years"
heading, `hvqbtl`/`yasfxe` live) touch other sections; this job owns only the five ids above. `build-v5.ts` refuses
overlapping ids, so all three land in one v5 in any order; whichever lands last leaves the full file.

## Docs & records

Task 5: `v5/manifest.json`, the Downloads copy with matching sha256, and the proposed B-Dry memory line (v5 status and
live check AC11 owed).
