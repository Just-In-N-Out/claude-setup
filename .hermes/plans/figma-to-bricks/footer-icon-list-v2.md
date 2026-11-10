# footer-icon-list: a box side the site writes by two names keeps the site's winner (website importer, bug)

Planner: Opus 5.5 high, 2026-11-10. Base: `main` `7eeca437ea100c821bcfb82cdbbe516a023ff097` (Build 2026-11-10.4).
Recommendation: **Mini** (reason at the end). Evidence: `~/.hermes/plans/figma-to-bricks/evidence/footer-icon-list/planner/`
(`notes.md` lists every receipt). The builder copies this file to `docs/plans/2026-11-10-footer-icon-list.md` as Task 0.

Re-planned by planner 2 (Opus 5.5 high, 2026-11-10) after review 1: **Full** from here. ⟦v2⟧
Branch `footer-icon-list-build`, built head `bdd3dde7dc8c06b8daa0ec442a87ae1961e469fa`; the fixer keeps its commits and stacks it on staging-fit-cancels (Task F0). ⟦v2⟧
Planner 2's evidence: `~/.hermes/plans/figma-to-bricks/evidence/footer-icon-list/planner-2/` (`notes.md`; `probe/probe2.log` and `probe/table.md`; `bdry/bdry-time.log`; `red/`; `code/` holds every file this plan has the fixer write, with `code/SHA256SUMS`). ⟦v2⟧
The approved v1 text: `~/.hermes/plans/figma-to-bricks/evidence/footer-icon-list/plan-approved.md`, and on the branch `git show bdd3dde7:docs/plans/2026-11-10-footer-icon-list.md`. ⟦v2⟧

## Amendments (v2, planner 2) ⟦v2⟧

Lines ending in ⟦v2⟧ are new or changed; a heading ending in ⟦v2⟧ marks its whole section as new. ⟦v2⟧

- Amendment 1: Q2 is settled the other way (B): the capture's reader keeps each box side by one name, the cascade's winner, at every range and under a hover, and marks the capture (`web.code.oneName`). The conversion-only rule ("the name the capture lists later") is removed: review 1 proved it wrong where a stronger rule writes a side again (R1-1). ⟦v2⟧
- Amendment 2: Q1 is answered B: the inline sides (left and right beside inline-start and inline-end) come with the reader's rule, because the reader reads each element's own direction and writing mode (probes r, s, t, u). ⟦v2⟧
- Amendment 3: a new question for Justin, Q4: what captures made before this build do. ⭐ A: they paste exactly as before, with one note per part to capture the page again. ⟦v2⟧
- Amendment 4: the job stacks on staging-fit-cancels (its bounded runs replace `revert`): with the capture's winner per range, they make every probe shape exact, with no conversion code of this job's (probes h and q). ⟦v2⟧
- Amendment 5: the first AC is proved on fresh captures of the offline B-Dry stand-in made by each tree's own reader (the saved stand-in capture is an older capture: under Q4 A it keeps its 69 px and gets the note); the head's fresh capture is kept and named by its sha256 for the verifier and the auditor. ⟦v2⟧
- Amendment 6: the third AC is now the reader's rule (`src/web/read/code-sides.ts`), under its old test name in a rewritten `test/unit/site-one-side.test.ts`; `test/unit/site-one-side-ranges.test.ts` (the builder's ranges rule) goes. ⟦v2⟧
- Amendment 7: the fourth AC is now "older captures paste exactly as before": on saved real captures every part's payload is the base's byte for byte and only its notes gain the one note, exactly where a pair is held; its test file and name stay, its body is rewritten. ⟦v2⟧
- Amendment 8: the live check now starts with Justin capturing bdryswi.com again with the merged build (his saved capture is refused anyway). ⟦v2⟧
- Amendment 9: four new ACs after the existing ones (all proposed): AC7 the capture records the winner, AC8 every twice-written shape pastes as the site draws it, AC9 older captures' policy, AC10 the capture's time and bytes. ⟦v2⟧
- Amendment 10: tasks F0–F8 replace nothing already committed; they follow the builder's tasks 0–6 on the same branch. The earlier receipts that encoded the old rule: the builder's `unit-one-side-*` logs, `site-one-side-ranges` and the mutants m1–m4 on `oneSide` (they no longer apply); AC1's `named-proto.log` and the builder's AC1 run (made on the saved older capture with the old rule: the new proof is a fresh capture); AC2's receipts stay valid in kind (same test, same fixture) but are re-run on the new head. ⟦v2⟧
- Amendment 11: the second AC's test keeps its name and drawing check; its capture precondition flips (the capture now holds the item's winner alone, not both names) and moves after the drawing check, so the base's RED is still the 72 px (`planner-2/code/ac2-edit.py`; receipts `red/web-*.log`). ⟦v2⟧

## Questions (⭐ = recommended; the builder takes ⭐ unless Justin answers otherwise)

- **Q1. The inline sides** (`margin-left` beside `margin-inline-start`, `padding-right` beside `padding-inline-end`): the
  same cascade mix-up can happen there, but which physical side a logical inline side means depends on the text
  direction (left-to-right or right-to-left), which a range's declarations can't see.
  - A. Leave them for a follow-up (no captured site holds one today: probe over B-Dry's captures, `notes.md`). ⟦v2⟧
  - ⭐ **B (v2, taken).** Include them now: the capture's reader reads each element's own direction and writing mode, so left and right come with the same rule at no extra cost; probes r, s, t and u paste as the site draws them only with it (main and the built head get r, s and t wrong). ⟦v2⟧
- **Q2. Older captures vs new ones.** The conversion can only read which name the site wrote later from the order the
  capture lists them, which is exact when each name is written once (a reset, then a widget rule: B-Dry's case).
  - A. Fix the conversion only now (every capture, Justin's saved ones too); making the capture itself keep only the winner is a follow-up. ⟦v2⟧
  - ⭐ **B (v2, settled by review 1 and the main session's ruling).** Change the capture (`src/web/read/code.ts`, `code-states.ts`) to keep only the cascade's winner: exact on new captures; the conversion guesses nothing. ⟦v2⟧
- **Q3. Justin's staging page.** It is off by this today too (see "Justin's staging page today").
  - ⭐ **A.** After the merge Justin captures bdryswi.com again, re-pastes B-Dry's whole home on staging /homev2/ and runs `site:live` (AC6, live). ⟦v2⟧
  - B. Leave staging as it is until site-native-structure merges, then one re-paste for both.
- **Q4 (Justin's decision). What captures made before this build do.** They hold both names of a side and say nothing about which one the site applied. ⟦v2⟧
  - ⭐ **A. They paste exactly as before, and say so.** Every older capture's paste stays byte for byte as today's; a part holding a side written by two names with different values gets one note: "capture the page again with this build". Trade-off in plain words: always safe and exact, but an old capture keeps its wrong spacing (B-Dry's footer list 69 px short) until the page is captured again, which Justin has to do anyway (his saved 2026-11-09 capture is refused for missing stylesheets, check 3do). ⟦v2⟧
  - B. They use the built rule ("the name listed later wins"). Trade-off: fixes B-Dry's old captures without a re-capture, but pastes the wrong spacing wherever a stronger rule writes the side again, where today's paste is right (probes b, d, f, w, x: 30 px against the site's 5, 40 against 4, 33 against 12, 20 against 10, 12 against 3). ⟦v2⟧
  - C. A narrower rule for older captures: drop a physical side only when it is zero and listed before a logical one (a reset's zero). Trade-off: right on every probe that has a reset (a, c, h, k, pb, z2, z3) and never worse there, but it can't be proved never worse: a stronger rule writing the side to zero again (a "first item flush" rule, a `.mt-0` utility class after a page builder's gap) is read as the reset's zero and pasted with the gap, where today's paste is right. ⟦v2⟧

## Playback (plain words)

1. Since Build 2026-11-10.4 our test drawing prints a class's Bricks settings the way the published page prints them.
2. Since then B-Dry's footer contact list (four rows with an icon each: phone, address, hours, email) is drawn 69 px
   too short at every width, where the old drawing matched the site within 0.11 px. The paste itself did not change.
3. Question: is the new drawing wrong, or was the paste always wrong and the old drawing hid it?
4. Answer: **the paste is wrong, and the new drawing shows what real Bricks shows.** Justin's staging page has the
   same short list today.
5. Review 1 found that the built fix (the conversion keeps "the name the capture lists later") is wrong whenever a site writes a side a second time with a stronger rule: the capture doesn't record which name won. So the capture itself must keep the site's winner. ⟦v2⟧

## Root cause (proved)

**The site writes each row's top and bottom spacing twice, under two names, and our paste keeps both.**

- On bdryswi.com a reset sets every `li` to `margin: 0; padding: 0`. Elementor's icon-list rule, later and stronger,
  spaces the rows with the logical names `margin-block-start: calc(23px/2)` and `padding-block-end: calc(23px/2)`. In
  the browser the later declaration wins, so each row gets 11.5 px above and below.
- The capture keeps both. `src/web/read/code.ts:145-152` builds each element's declarations as a map by property
  name. `margin-top: 0px` and `margin-block-start: calc(23px/2)` are different names, so both survive, in the order
  each was first written. In the stand-in capture, `body/div:0/footer:0/div:9/div:1/div:1/div:0/ul:0/li:1` at
  `1367-up` lists `margin-top` at position 5 and `margin-block-start` at 23 (`probe5`, `notes.md`). Only six nodes in the
  whole B-Dry capture hold such a pair: the four footer rows, with different values, and two page paragraphs, both 0.
- The conversion splits the pair. `src/core/site/controls.ts:72` maps `margin-top`/`padding-bottom` to Bricks
  controls (`_margin`, `_padding`). Logical names have no rule there, so they stay the class's custom CSS
  (`controls.ts:118-122`).
- Published Bricks prints a class's controls as `.<class>.brxe-<element>` (0,2,0) and its custom CSS as `.<class>`
  (0,1,0). That is what B-Dry staging prints, Bricks 2.4.2: all 343 control blocks there
  (`reference/bricks/README.md` "Class selectors"; `evidence/staging-fit/planner/staging/css/inline-2.css`). So the
  physical `margin-top: 0px` control beats the logical `margin-block-start` custom CSS whatever the print order:
  `probe3.log`, "real Bricks / new renderer" gives margin-top 0px either way.
  - The new renderer prints exactly that (`test/browser/render-order.ts:23-46`, `klass`).
  - The old renderer printed the controls as `.<class>` before the custom CSS, so the custom CSS won by order. That
    happened to be the site's winner here, which hid the bug.
- The exact declarations:
  - `.home__facebook__row-cztp.brxe-div { … padding-bottom: 0px … }` vs `.home__facebook__row-cztp { padding-block-end: calc(23px/2) }` (row 1);
  - `.home__facebook__row-upmg.brxe-div { … margin-top: 0px … padding-bottom: 0px … }` vs `.home__facebook__row-upmg { margin-block-start: calc(23px/2); padding-block-end: calc(23px/2) }` (rows 2 and 3);
  - `.home__facebook__row-wwpc.brxe-div { … margin-top: 0px … }` vs `.home__facebook__row-wwpc { margin-block-start: calc(23px/2) }` (row 4).
  - Row 4 sits 11.5 + 23 + 23 + 11.5 = **69 px** higher. `probe1.log` (main's own `footer.html`, Chrome) measured the
    box at 167.11 px against 236.11 px, with row 4's top at 133.69 against 202.69 px: exactly 69.00 at 1440 and at 390.
    Writing those three classes' control selectors back as `.<class>`, or dropping only their `margin-top`/
    `padding-bottom` controls, gives the site's 236.11 px.
- **A paste that held both names never drew right in real Bricks.** The one rule a class's custom CSS is written as
  sorts the names (`src/core/site/classes.ts:85-86`, `Object.keys(decls).sort()`). `margin-block-start` sorts before
  `margin-top` (and `-block-end` before `-bottom`), so the physical name wins there as well. Justin's staging page holds
  an older all-custom-CSS paste of exactly that shape (below).
- Answer to "which side": **(a), the conversion.** The new renderer prints what real Bricks prints; nothing in
  `test/browser/render*.ts` changes.
- **Why the conversion alone can't fix it (review 1, R1-1; proved again here).** The reader (`code.ts:145-153`) writes each declaration into a map by name, so a name keeps the place of its first, weakest declaration; a reset's `margin-top: 0`, a logical rule, then a stronger `margin-top` (a class, `!important`, an inline `style`) leaves `margin-top` listed first holding the winning value. The capture never records which name won, and ranges are stored as changes from the next wider range (`src/web/code.ts` `encode`), so the order is lost across ranges too. Every rule the conversion could apply guesses (probe table below: the built rule is wrong on b, d, f, w, x where main is right). ⟦v2⟧
- **What the capture already has (v2).** DevTools' matched styles list the element's rules in cascade order (specificity, then order; the inline style last; `cascade()` in `src/web/read/authored.ts` puts `!important` last), and the browser treats a physical side and its logical name as one property, so the side's value is the last of either name in that list (probe c: a class's `margin-block-start` beats a later `article { margin-top: 0 }`, as the site draws it). The reader only has to drop a side's other name each time one is set, with the logical name mapped through the element's own writing mode and direction. ⟦v2⟧

### Receipts (all under the evidence folder)

- `named-main.log`: `site-elementor-page-bdry` on a `git archive` of main fails, footer 69 px at every width, e.g.
  `footer 1440: 69 (body/div:0/footer:0/div:9/div:1/div:1)`.
- `named-proto.log`: the same test on a prototype of the fix passes 2/2 (footer ≤ 1.09, page ≤ 1.02, header ≤ 0.03).
- `proto-footer.log`, `proto-footer-239.log`: `site:check --part footer --elementor` on the stand-in capture is within
  0.11 px with Bricks 2.4.2 and with `--bricks 2.3.9`. Main gave 69.07 px with both: fixer-3's `main-242.log`,
  `main-239.log`.
- `fixture-main.log` / `fixture-proto.log`: the generic fixture below. Main is 72 px off at 768 and up and 36 px on
  phones; the prototype is 0 px at every width.
- `unit-one-side-main.log` / `-proto.log`: the unit rule. 4 of 5 tests fail on main (the 5th is a guard); 5 of 5 pass
  on the prototype.
- `unit-main.tap` / `unit-proto.tap`: the whole unit suite gives 3462 pass and 0 fail on both. No existing test pins
  the old output, the site-slider goldens included.
- `bytes-2.log` and `sums-proto.log`, five saved real captures: every header and page part, and every part of the
  other captures, is byte for byte as main's. Only footers holding the pair change.
- `proto-whole.log` / `main-whole.log` (`--whole --elementor`): footer 0.11 px with the fix, 69.07 on main. The page
  part is 64 / 46.5 / 6.93 px off in `--whole` on **both**, a separate pre-existing issue (see "Found elsewhere").
- `proto-src.patch`, `proto-tests/`: the prototype the tasks below write out (scratch only, never committed).
- The receipts above that ran the v1 rule (`named-proto.log`, `unit-one-side-*`, `sums-proto.log`, `fixture-proto.log`) prove the v1 rule only; planner 2's receipts are listed under "The probes (v2)". ⟦v2⟧

## The probes (v2) ⟦v2⟧

A fixture site (`planner-2/probe/index.html`, `style.css`; the same files become `test/fixtures/web/sites/twice-sides/`) holds review 1's shapes a–q plus inline sides (ltr, rtl), an inherited vertical writing mode, `var()`/`calc()`, shorthands and four hover looks. It was captured by main's reader (old), by the prototype reader (new: one name per side) and by a "move each written name to the end" reader (candidate 1b), each converted by main's, the built head's and staging-fit-cancels' (`ce5b38ac`) converters, drawn as Bricks 2.4.2 and 2.3.9 print a paste, and every margin and padding side (and n's width) compared with the site's at 1300, 900 and 500, y, z, z2 and z3 hovered too (`probe/probe2.ts`, `probe/probe2.log`; WRONG = off at some width or sample). ⟦v2⟧

| element | shape | site (1300 · 900 · 500) | old reader × main | × head (built) | × staging-fit-cancels | new reader × main | × head | × staging-fit-cancels | move-to-end reader × head |
|---|---|---|---|---|---|---|---|---|---|
| a | reset 0, logical once (B-Dry shape) | 20px | WRONG | ok | WRONG | ok | ok | ok | ok |
| b | reset, logical, stronger class physical | 5px | ok | WRONG | ok | ok | ok | ok | ok |
| c | logical class beats a later element-selector physical | 25px | WRONG | ok | WRONG | ok | ok | ok | ok |
| d | reset, !important physical, logical later | 4px | ok | WRONG | ok | ok | ok | ok | ok |
| e | !important physical, logical later | 4px | ok | ok | ok | ok | ok | ok | ok |
| f | reset, inline style physical, logical class | 12px | ok | WRONG | ok | ok | ok | ok | ok |
| g | inline style physical, logical class | 12px | ok | ok | ok | ok | ok | ok | ok |
| h | physical wide, logical added on phones | 0px · 0px · 18px | WRONG | ok | WRONG | WRONG | WRONG | ok | ok |
| i | logical strong, weaker physical added on phones (R1-2) | 22px | WRONG | WRONG | WRONG | ok | ok | ok | WRONG |
| j | logical wide, stronger physical on phones | 22px · 22px · 7px | ok | ok | ok | ok | ok | ok | ok |
| k | physical then logical, stronger physical on phones | 16px · 16px · 9px | WRONG | WRONG | WRONG | ok | ok | ok | WRONG |
| n | width then inline-size | 300px | WRONG | ok | WRONG | ok | ok | ok | ok |
| q | physical only at 768-1024 (R1-3) | 14px · 3px · 14px | WRONG | WRONG | ok | WRONG | WRONG | ok | WRONG |
| r | ltr: reset, margin-inline-start | 24px | WRONG | WRONG | WRONG | ok | ok | ok | WRONG |
| s | rtl: reset, margin-inline-start | 24px | WRONG | WRONG | WRONG | ok | ok | ok | WRONG |
| t | rtl: inline-start plus a stronger margin-left (two sides) | 24px/6px | WRONG | WRONG | WRONG | ok | ok | ok | WRONG |
| u | ltr: padding-inline-start, stronger padding-left | 8px | ok | ok | ok | ok | ok | ok | ok |
| v | inherited vertical-rl: margin-top and margin-block-start are two sides | 5px/20px | WRONG | WRONG | WRONG | ok | WRONG | ok | WRONG |
| w | var()/calc(): logical calc(var), stronger physical var | 10px | ok | WRONG | ok | ok | ok | ok | ok |
| x | margin-block shorthand, stronger margin shorthand | 3px | ok | WRONG | ok | ok | ok | ok | ok |
| x2 | margin shorthand, stronger margin-block shorthand | 12px/2px | WRONG | ok | WRONG | ok | ok | ok | ok |
| pb | reset, padding-block-end | 11.5px | WRONG | ok | WRONG | ok | ok | ok | ok |
| y | physical rest, logical hover | 0px | ok | ok | ok | ok | ok | ok | ok |
| z | stronger physical rest, weaker logical hover | 4px | ok | ok | ok | ok | ok | ok | ok |
| z2 | stronger logical rest, weaker physical hover | 9px | WRONG | ok | WRONG | ok | ok | ok | ok |
| z3 | logical rest, stronger physical hover | 9px | WRONG | ok | WRONG | ok | ok | ok | ok |
| y:hover | physical rest, logical hover (hovered) | 15px | ok | ok | ok | ok | ok | ok | ok |
| z:hover | stronger physical rest, weaker logical hover (hovered) | 4px | WRONG | WRONG | WRONG | ok | ok | ok | WRONG |
| z2:hover | stronger logical rest, weaker physical hover (hovered) | 9px | WRONG | WRONG | WRONG | ok | ok | ok | WRONG |
| z3:hover | logical rest, stronger physical hover (hovered) | 30px | ok | ok | ok | ok | ok | ok | ok |

Reading it: ⟦v2⟧

- **The new reader with staging-fit-cancels' converter is right on all 30 rows**, on both Bricks samples and at every width. It is the only column with no WRONG. ⟦v2⟧
- The new reader on main's converter is wrong only on h and q: a range whose winner name differs from the next wider range's drops the other name, and main sends a dropped name back with `revert`, which as a class control (0,2,0) beats the logical winner. staging-fit-cancels' bounded runs write no `revert`, so they fix both. Main is wrong on them today too. ⟦v2⟧
- The built head's converter on new captures is still wrong on v (its rule drops a side of a vertical line, where the two names are two sides) and on h and q. So the built rule must go. ⟦v2⟧
- Candidate 1b (move each written name to the end, keep the built "listed later" rule) is wrong on 9 rows: ranges are stored as changes (i, k, q), and the inline sides, the vertical line and the hover looks never pass through the built rule. ⟦v2⟧

### The candidates weighed (v2) ⟦v2⟧

1. **The reader keeps only the winning name per side, per element, range and state (chosen).** Exact on every probe above with staging-fit-cancels (probe2.log). Shorthands come for free (the browser expands them before the names are set, rows x and x2), so do `var()` and `calc()` (resolved before, rows w and a), inline sides and vertical writing (the logical name is mapped through the element's computed `writing-mode` and `direction`, rows r, s, t, u, v), and the hover looks (the state's cascade in `code-states.ts` gets the same rule, rows y–z3). Cost: one batched page call (`codeAsks`, 300 asks each) for the targets that declare a logical side or size, no extra `CSS.getMatchedStylesForNode` (B-Dry timing below). Capture file: one new optional field `web.code.oneName: true`; older readers of a new capture are fine (a new capture just has no pair). ⟦v2⟧
2. **Record the winner beside both names (a marker the conversion reads).** The same information as 1, at more cost: a new per-node, per-range field, and conversion code reading it in `statesOf` and in every consumer that reads declarations directly (the fold rules' `marginOf`, the accordion, the sliders, `roleOf`, control-weight's `inline-own.ts`), to drop a value nothing needs. Not prototyped; rejected on cost. ⟦v2⟧
3. **Read the computed value of the physical side and keep the name equal to it.** Not exact: B-Dry's declared `calc(23px/2)` never equals the computed `11.5px` string, a `%` side computes against the layout, so every declared value would need its own evaluation in the element's context; and it can't see a hover's winner. Rejected. ⟦v2⟧
4. (1b) **Move each written name to the end of the map and keep the built rule.** Wrong on 9 probe rows (above). Rejected. ⟦v2⟧

### The B-Dry stand-in with the new reader (v2) ⟦v2⟧

`bdry/bdry-time.ts`: the offline B-Dry stand-in (web-code-proof's saved home page, served on 127.0.0.1) captured by main's reader and by the new one, in the order old, new, new, old, each in a fresh Chrome resolving no host but 127.0.0.1 and Google Fonts, under an 8G scope (`bdry/bdry-time.log`). ⟦v2⟧

- Times (machine load 14–21 from other agents' jobs): old 496 s, new 573 s, new 554 s, old 563 s: old 1059 s, new 1127 s together, +6.4%; the two old runs alone differ by 13%, so the difference is inside this PC's noise. The new reader asks Chrome's matched styles exactly as before; it adds one batched page call per 150 targets that declare a logical side. ⟦v2⟧
- The two captures (sha256 old `23a4db08…`, new `5dd4d842…`; `bdry/standin-OLD.json`, `standin-NEW.json`) differ only on 6 of 1205 elements, every difference in their declarations, and everything outside the elements is the same: the four footer rows (`…/footer:0/div:9/div:1/div:1/div:0/ul:0/li:0`–`li:3`: `margin-top: 0px` and `padding-bottom: 0px` left out where `margin-block-start`/`padding-block-end` win) and two page paragraphs whose `margin-bottom: 0px` gives way to the later `margin-block-end: 0px` (both zero: they draw the same). ⟦v2⟧
- The new capture converted by the fix on staging-fit-cancels (`red/ac1-newcapture-fix.log`, F2B_ELEMENTOR_STANDIN = `bdry/standin-NEW.json`): the named whole-page test passes 2/2 (header, page and footer within 2 px at every width) on the capture the new reader made, with no conversion rule of this job's. ⟦v2⟧
- The 14 web test files on fixture sites that write logical sides (the Elementor fixtures, `site-check-settle`, `capture-hidden-parts`, `site-live-*`) pass 32/32 on the fix tree (`red/elementor-fix.tap`): the reader's change moves none of them. ⟦v2⟧

## What else the cause reaches (the general rule)

- **Any site element whose cascade writes one side by its physical name and, with a different value, by its logical
  name.** In practice: a reset or normalise (`margin: 0`, `padding: 0`, `p { margin-top: 0 }`) together with a page
  builder's or theme's logical spacing.
  - Elementor ≥ 3 icon lists: `margin-block-start`/`padding-block-end`.
  - Widget gaps: `margin-block-end`.
  - Container paddings written as `padding-block-*`.
  - WordPress block themes' flow spacing: `margin-block-start` on `.is-layout-flow > *`, a very common shape on
    WordPress sites.
- The same mix-up affects sizes (`width`/`inline-size`, `height`/`block-size` and their min/max), insets
  (`top`/`inset-block-start`) and the block borders. The rule covers all of them.
- Inline sides (left/right) have the same mix-up; the reader maps them through the element's own direction (Q1 B). ⟦v2⟧
- **On the site's own side, either name can win.** When the logical one wins (B-Dry), today's paste loses it in real
  Bricks: the physical name is a control or sorts later.
  - When the physical one wins (a stronger physical rule later), today's paste happens to draw right in real Bricks.
    The old renderer drew it wrong.
  - The capture now keeps whichever the site's cascade applied, so both draw right, whatever order and weight the site used. ⟦v2⟧
- **Only differing pairs change.** Pairs that draw the same (the same value, or both zero, like B-Dry's two page
  paragraphs and its header's `0px`/`0%`) draw the same either way; in a new capture they too hold one name (the winner), which draws the same as before. ⟦v2⟧
- **Builds 2026-11-09.2 and .3:**
  - .2 claimed the page within 1.02 px. That holds: the page paste has no differing pair and is within 1.02 px with
    the new renderer (`named-proto.log`).
  - .3 claimed the whole page, header, page and footer, within 2 px. That **did not hold for the footer** on the right
    reading: real Bricks drew the icon list 69 px short at every width, and only the old renderer's print order hid
    it. With this fix and a fresh capture it holds: footer ≤ 2 px (AC1). ⟦v2⟧
  - The fold rules themselves (8 and 9) are unaffected. Their `marginOf` (`elementor-measured.ts:10`) reads the
    physical name, else the logical one, so it reads the one name a new capture holds. ⟦v2⟧
- **Justin's staging page today** (read-only GET, `staging/homev2.html`, 2026-11-10; the same paste as the 2026-11-09
  copy except interaction ids). It holds an older paste of this footer: rows `home__facebook__row-yhxt/-crhh/-qinp`,
  all custom CSS, one sorted rule per class (`staging/rows-css.txt`), e.g. `.home__facebook__row-crhh { … margin-block-start:
  calc(23px/2); margin-bottom: 0px; … margin-top: 0px; … padding-block-end: calc(23px/2); padding-bottom: 0px; … }`.
  - In one rule the later declaration of the two names wins: `margin-top: 0px` and `padding-bottom: 0px` (`probe3.log`,
    "one sorted rule"). So **staging's footer contact list is 69 px shorter than bdryswi.com's today.** This is read
    from the printed CSS and the probe, not measured in Chrome on staging (the brief allows curl only).
  - A re-capture and a re-paste with the fix are needed (Q3, AC6). ⟦v2⟧
- **site-native-structure's AC14** (B-Dry's whole page within tolerance at every width) is blocked by this on main,
  and on its own head (`head-239.log`, 69 px). It is unblocked once this merges and that branch rebases **and its AC14 input is a capture made by this build's reader**: under Q4 A the saved stand-in capture (`standin-capture-0581852c.json`) keeps the 69 px, so site-native-structure needs the same input swap as Amendment 5 (a fresh stand-in capture named by its sha256). ⟦v2⟧

## The fix (v2: the capture keeps the winner) ⟦v2⟧

**Rule (reader):** for each element, its `::before`/`::after` and each inline element of its words, at every range and under each state the reader reads, the declarations are set in cascade order (as today); setting a box side or size (margin, padding, inset, a border side's width, style or colour, the sizes and their min and max) drops the other name of the same side already set. The same side means: the same physical side once each logical name is mapped through the element's computed `writing-mode` and `direction` (left-to-right `margin-inline-start` is `margin-left`, right-to-left it is `margin-right`; in `vertical-rl` `margin-block-start` is `margin-right` and `margin-top` is another side). A name set again keeps its first place, so a target without both names is byte for byte as before. The flow is asked only of targets that declare a logical side or size, in one batch. The capture says so: `web.code.oneName: true`. ⟦v2⟧

**Rule (conversion):** none picks a winner. A capture without `web.code.oneName` (older) converts exactly as before; a part where some element holds a block side or size by both names with values that draw differently in some range gets one note (`sides.ts` `olderPairs`, `olderSidesNote`): capture the page again with this build. The inline sides are left out of the note (which side a logical name means needs the direction, and main's paste of them never changed). ⟦v2⟧

- **Where:** ⟦v2⟧
  - `src/web/read/code-sides.ts` (new, pure): `Flow`, `sideKey(name, flow)`, `isLogical(name)`, `oneName(out, flow)`. ⟦v2⟧
  - `src/web/read/code.ts`: the target's `flow`; the flows asked after the shorthands are expanded; every name set through `oneName`; the state targets carry their flow. ⟦v2⟧
  - `src/web/read/code-states.ts`: the state's cascade sets names through the same side rule; a target whose rest named no logical side has its flow asked there, in one batch. ⟦v2⟧
  - `src/core/snapshot/web.ts`: `WebCode.oneName?: true`. `src/web/code.ts` `assembleCode`: `oneName: true`. ⟦v2⟧
  - `src/core/site/sides.ts` (rewritten): `PAIRS`, `holdsPair`, `olderPairs`, `olderSidesNote`; no `oneSide`. ⟦v2⟧
  - `src/core/site/convert.ts` `prepare`: three lines (the note). `src/core/site/blocks.ts`: back to the base's text (no `oneSide`). ⟦v2⟧
- **Not touched:** the renderer (`test/browser/render*.ts`), `controls.ts`, `classes.ts`, `parts.ts`, the fold files, `inline-own.ts` (control-weight), the Figma pipeline, `src/web/read/authored.ts` (the measured route's authored values read physical names only; see "Found elsewhere"). ⟦v2⟧
- **Known limits (HANDOFF):** a writing mode outside horizontal-tb, vertical-rl/lr and sideways-rl/lr leaves both names (no side is dropped); `!important` inside cascade layers is ordered as `cascade()` orders it today (not layer-reversed; the same for one name written twice); a corner's radius (`border-start-start-radius`) isn't a side here. ⟦v2⟧

### What of the built code stays (v2) ⟦v2⟧

- `src/core/site/sides.ts`: **stays, rewritten.** `oneSide` (and its `before` ranges branch) goes: on new captures it has nothing to do (no pair), on older ones Q4 A says paste as before, and on a new capture it would still drop a side of a vertical line (probe v). `PAIRS` stays (the older-capture note and AC4's guard read it). ⟦v2⟧
- `src/core/site/blocks.ts`: **back to the base's text** (`statesOf` without `oneSide`). The builder's ranges addition (keep the losing name at the winner's value) goes: with the capture's winner per range and staging-fit-cancels' bounded runs, h, j, k and q are exact without it (probe column "new reader × staging-fit-cancels"). ⟦v2⟧
- `statesOf`'s append order (R1-2): no longer matters: no code reads the order of names to pick a winner. ⟦v2⟧
- `test/unit/site-one-side.test.ts`: rewritten for the reader's rule (AC3, same test name). `test/unit/site-one-side-ranges.test.ts`: deleted. `test/unit/site-one-side-sums.test.ts`: rewritten (AC4, same test name). ⟦v2⟧
- `test/web/site-logical-sides.test.ts` and `test/fixtures/web/sites/logical-sides/`: **stay unchanged** (AC2): the test captures the fixture fresh, so the new reader is what makes it pass. ⟦v2⟧
- `docs/HANDOFF.md`'s section and the ledger: rewritten / extended (Task F7). ⟦v2⟧

### The other jobs, and the merge order (v2) ⟦v2⟧

- **staging-fit-cancels** (`staging-fit-cancels-stack7` `ce5b38ac`, review-clean): this job **stacks on it** (Task F0) and merges after it. Its bounded runs are what make h and q exact. A rebase of `bdd3dde7` onto `ce5b38ac`, and onto main `f40ce6ce`, in a scratch clone: only `docs/HANDOFF.md` conflicts (the task 6 commit; keep both sections), `blocks.ts` replays cleanly. ⟦v2⟧
- **control-weight** (`control-weight-fix1`, on staging-fit-cancels): `inline-own.ts` rebuilds a moved element's ranges from per-range full readings; each reading now holds one name per side, so its rebuilt ranges do too, and a winner that changes between ranges is a bounded run. R1-4's worry (an order rebuilt from mixed readings) is gone: nothing reads the order. No shared function; `convert.ts` may meet a context-only conflict near the import lines or `prepare`'s `note`: keep both. Either order. ⟦v2⟧
- **site-menu** (`site-menu-stack6`/`fix5`): changes `src/web/read/code.ts` (`readCode` becomes a wrapper over `readOnce`, the facts call gains `root`), `code-facts.ts` and `web.ts` (`opens?` right after `sheets?`). This job's `code.ts` hunks are the import line (after `markupOf`'s, beside site-menu's changed `page-reader` import: keep both), the `Target` line, the expansion loop and the `readStates` call: untouched by site-menu. `web.ts`: both add a field after `sheets?`: keep both. Opened boxes are read by `readOnce` too, so they get one name per side for free. Merge site-menu first (queued earlier); the finisher's rebase resolves. ⟦v2⟧
- **panel-embed-code** (`panel-embed-code-stack9`): `web.ts` (fields of `WebFloating` and `WebEmbed`, not `WebCode`), `assemble.ts`, `tracker.ts`, `floating.ts`: no shared lines. Either order. ⟦v2⟧
- **site-native-structure**: merges after this job (its AC14 needs the fix and a fresh stand-in capture; see above). ⟦v2⟧
- **Order:** staging-fit-cancels → site-menu → panel-embed-code → control-weight → footer-icon-list → site-native-structure (the queue as it stands; this job only needs staging-fit-cancels before it). ⟦v2⟧

## Acceptance criteria (all **proposed**; one named test each)

- AC1 (proposed): B-Dry's named whole-page test passes again because the footer's icon list keeps the site's spacing when the offline stand-in is captured by this build's reader (footer ≤ 2 px at every width; RED on base, whose own reader's capture keeps both names: 69 px): test `B-Dry's whole page with the Elementor step: within 2 px at every width` (`test/web/site-elementor-page-bdry.test.ts`, named-only, env below, F2B_ELEMENTOR_STANDIN unset so each tree captures fresh, or set to the head's fresh capture named by its sha256 for supporting runs). ⟦v2⟧
- AC2 (proposed): a generic site whose reset writes sides by physical names and whose list rule spaces items by logical ones (plus a physical-wins badge, an equal pair and a phone gap) pastes within 2 px at every width with Bricks' class printing (RED on base: 72 px, 36 on phones): test `a side written by its physical and its logical name keeps the site's winner: 1:1 at every width` (`test/web/site-logical-sides.test.ts`, new fixture `test/fixtures/web/sites/logical-sides/`).
- AC3 (proposed): the reader's rule: set in cascade order, a target's declarations keep one name per box side and size, the cascade's winner (the later set, physical or logical); a logical name's side follows the element's writing mode and direction (right-to-left inline-start is the right side; in a vertical line `margin-top` and `margin-block-start` are two sides); a name set again keeps its place, and a target with no flow is written byte for byte as before; encoded per range and read back, every range's state holds one name per side (RED on base and on the built head: the rule's file doesn't exist): test `one side: a later logical name wins over a reset's physical one, in every range` (`test/unit/site-one-side.test.ts`). ⟦v2⟧
- AC4 (proposed): every older paste and every Figma design is byte for byte as before: on saved real captures (all older than this build) each part (header, page, footer; code method and Elementor step) converts to the base's payload and sources exactly, and its notes are the base's plus the one note to capture again exactly where an element under the part holds a block side or size by both names with different values; the Figma route, the committed site goldens and the corpus are unchanged: test `pastes change only where a part holds a side written by both names` (`test/unit/site-one-side-sums.test.ts`, named-only). ⟦v2⟧
- AC5 (proposed): the merged jobs' checks are unchanged for pastes without the shape: `npm run test:web` and `npm run test:browser` pass by test name as on base (the new AC2 test added), including `site:check --whole` and `site:live`'s drawing: test `--whole draws the parts together and other hosts' pictures from the capture` (`test/web/site-check-cli.test.ts`).
- AC6 (proposed) (live): after Justin captures bdryswi.com again with the merged build and re-pastes B-Dry's whole home on staging /homev2/ from that capture, `npm run site:live -- <new capture> https://bdry.staging.growithgro.com/homev2/ --elementor` reports the footer contact list's rows within 2 px of the capture at the widths it reads (paste check, next free id at the merge): check `site:live footer rows on staging /homev2/` (Justin's run; the report's footer rows). ⟦v2⟧
- AC7 (proposed): the capture keeps each box side by one name, the site cascade's winner, at every range and under a hover, on a generic fixture holding every order a site can give (review 1's a–q, inline sides ltr and rtl, a vertical line where the two names are two sides, var()/calc(), shorthands, hover looks), and marks the capture `web.code.oneName` (RED on base and on the built head: their captures keep both names): test `the capture keeps each box side by one name, the cascade's winner, at every range and under a hover` (`test/web/site-twice-sides.test.ts`, new fixture `test/fixtures/web/sites/twice-sides/`). ⟦v2⟧
- AC8 (proposed): that fixture's section pasted by the code method and drawn as Bricks 2.4.2 and 2.3.9 print a paste shows every element's margins and paddings (and the sized element's width) as the site does at 1300, 900 and 500, the four hover elements hovered too (RED on base, its reader keeping both names: a, c, h, i, k, n, r, s, t, v, x2, pb, z2, z3 and z, z2 hovered; on the built head: b, d, f, i, k, q, r, s, t, v, w, x and z, z2 hovered): test `a side the site writes twice by two names pastes as the site draws it at every width, on both Bricks samples, hovered too` (`test/web/site-twice-sides.test.ts`). ⟦v2⟧
- AC9 (proposed): a capture made before this build (no `web.code.oneName`) that holds a block side by both names with different values pastes as it always did (the physical side a class control, the logical one custom CSS: nothing guessed) and the section's and the part's notes say once to capture the page again; a capture made since this build, an older one whose two names draw the same, and a section without the pair get no such note (RED on base: no note; on the built head: the physical side dropped): test `an older capture with a side written by both names pastes as before and says to capture again` (`test/unit/site-older-sides.test.ts`). ⟦v2⟧
- AC10 (proposed): the offline B-Dry stand-in captured by the base's reader and by this build's (base, head, head, base) takes at most 15% longer in total with this build (the PC's own spread between two runs of one tree was 13%), Chrome's matched styles asked as before, and this build's capture is the base's except `web.code.oneName`, the times and, on elements holding a side or size by two names in some range, the name that lost (its side still held by the other name) (RED on base and on the built head: no `oneName`): test `the B-Dry stand-in captures in its old time and differs only where a side had two names` (`test/web/capture-one-side-bdry.test.ts`, named-only, env below). ⟦v2⟧

Env for the named-only tests (the builder sets these; they are paths on this PC):

```
F2B_CODE_PROOF_BDRY=/home/justin/.hermes/plans/figma-to-bricks/evidence/web-code-proof/inputs/bdry-2026-10-29
F2B_CODE_PROOF_CAPTURE=/home/justin/.hermes/plans/figma-to-bricks/evidence/web-code-page/planner/capture.json
F2B_ELEMENTOR_PAGE_OUT=<E>/footer-icon-list/fixer-1/ac1-out   (AC1: the head's fresh capture lands here as standin-capture.json; record its sha256)
F2B_ONE_SIDE_BASE=<a git archive of the integration base with node_modules linked: staging-fit-cancels' head, or main once it holds it>
F2B_ONE_SIDE_CAPTURES=<E>/site-native-structure/inputs/standin-capture-0581852c.json:<E>/bdryswi-com-home-2026-11-04-code.f2b-capture.json:<E>/site-native-structure/fixer-3/natives.f2b-capture.json:<E>/elementor-phone-fit/planner/bdry-standin.f2b-capture.json:<E>/site-slider/fixer-2/swiper8-check/capture.f2b-capture.json
F2B_BASE_TREE=<the same archive as F2B_ONE_SIDE_BASE>   (AC10)
F2B_ONE_SIDE_EVIDENCE=<E>/footer-icon-list/fixer-1/ac10   (AC10)
```

`<E>` = `/home/justin/.hermes/plans/figma-to-bricks/evidence`. F2B_ELEMENTOR_STANDIN stays unset for AC1's proof runs (each tree captures the stand-in with its own reader; about 4–8 min a capture). ⟦v2⟧ Run B-Dry tests under `systemd-run --user --scope -p
MemoryMax=8G -p MemorySwapMax=0` (export the variables first), `TMPDIR=~/.cache/fil-b/t1` (short),
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`, one Chrome job at a time.

## Tasks (test first; one commit per passing task; never bump BUILD; never commit CLAUDE.md)

Tasks 0–6 below are the builder's, done (commits on `footer-icon-list-build` up to `bdd3dde7`); the fixer's tasks F0–F8 follow them. ⟦v2⟧

### Task 0: set up

- Copy this plan to `docs/plans/2026-11-10-footer-icon-list.md` and start the ledger
  `.superpowers/sdd/2026-11-10-footer-icon-list/progress.md`.
- Run `npm run check` and `npm run corpus` and record the numbers.
- Make the base archive for AC4: `git archive 7eeca437 | tar -x -C ~/.cache/fil-b/base`, then link `node_modules`.
- Commit the plan copy and the ledger.

### Tasks 1–6 (v1, done) ⟦v2⟧

The v1 tasks (the `oneSide` rule, its tests, the byte receipt, B-Dry's receipts, the gates, the docs) are in `git show bdd3dde7:docs/plans/2026-11-10-footer-icon-list.md` and the ledger. Their code is replaced or kept as "What of the built code stays (v2)" says. ⟦v2⟧

### Task F0 (v2): stack on staging-fit-cancels, plan copy, base trees ⟦v2⟧

- In your own worktree on `footer-icon-list-build` (`bdd3dde7`): if `staging-fit-cancels` is merged into `main`, run `git rebase main`; otherwise `git rebase staging-fit-cancels-stack7` (its head at planning: `ce5b38ac`; take its current head). The one expected conflict is `docs/HANDOFF.md` in the task 6 commit: keep both sections (staging-fit-cancels' first, then this job's) and both end-of-run entries. Record the new base commit `<B>` (`git merge-base HEAD main` if merged, else the staging-fit-cancels head you rebased onto) in the ledger. ⟦v2⟧
- Replace `docs/plans/2026-11-10-footer-icon-list.md` with this v2 plan (the v1 text stays in git history). Add a ledger section "Fix pass 1 (plan v2)". ⟦v2⟧
- Make two scratch trees with `node_modules` linked: `~/.cache/fil-f1/base` = `git archive <B>`, `~/.cache/fil-f1/head0` = `git archive HEAD` (the rebased built head, for REDs). ⟦v2⟧
- Run `npm run check` on the rebased head and record the tallies (expect the built tests to pass: nothing of this job's changed yet). ⟦v2⟧
- Commit the plan copy and the ledger. ⟦v2⟧

### Task F1 (v2): the reader's rule (AC3) ⟦v2⟧

- Write `test/unit/site-one-side.test.ts` exactly as `planner-2/code/site-one-side.test.ts` (sha256 in `code/SHA256SUMS`); it replaces the v1 file's content (same file, the first test keeps AC3's name). ⟦v2⟧
- **RED:** `node --test test/unit/site-one-side.test.ts` fails on an import failure (`src/web/read/code-sides.ts` missing). Proved on the built head and on staging-fit-cancels: `planner-2/red/unit-headred.log`, `unit-sfcred.log`. ⟦v2⟧
- Write `src/web/read/code-sides.ts` exactly as below. ⟦v2⟧
- **GREEN:** 4/4 (`planner-2` ran it: 4 pass on the fix tree). Commit. ⟦v2⟧

```ts
// One name per box side (footer-icon-list): a site's cascade can write one side of a box by its physical name
// (`margin-top`, a reset's `margin: 0`) and by its logical one (`margin-block-start`, a page builder's list spacing).
// The browser treats the two names as one property: the declaration later in the cascade (!important last, then
// specificity, then order: the order the reader lists them in, authored.ts cascade) is the side's value, and the other
// has no effect. The reader keeps only that name, so a paste never holds both (Bricks prints a class's physical side as a
// control, `.<class>.brxe-<element>`, 0,2,0, over the logical one in its custom CSS, 0,1,0). Which physical side a
// logical name means follows the element's computed writing-mode and direction (its flow): in a right-to-left line
// `margin-inline-start` is `margin-right`, in a vertical one `margin-block-start` is `margin-right` or `margin-left` and
// `margin-top` is another side. Margins, paddings, insets, the border sides' width, style and colour, and the sizes.
// Pure (runs in Node on the reader's lists).
export interface Flow { writingMode: string; direction: string }

// the physical sides [block-start, block-end, inline-start, inline-end] in a flow; null: a writing mode not listed here
function sidesOf(f: Flow): [string, string, string, string] | null {
  const rtl = f.direction === "rtl";
  switch (f.writingMode) {
    case "horizontal-tb": return ["top", "bottom", rtl ? "right" : "left", rtl ? "left" : "right"];
    case "vertical-rl": case "sideways-rl": return ["right", "left", rtl ? "bottom" : "top", rtl ? "top" : "bottom"];
    case "vertical-lr": return ["left", "right", rtl ? "bottom" : "top", rtl ? "top" : "bottom"];
    case "sideways-lr": return ["left", "right", rtl ? "top" : "bottom", rtl ? "bottom" : "top"];
    default: return null;
  }
}
const LOGICAL = ["block-start", "block-end", "inline-start", "inline-end"];
const physical = (side: string, f: Flow): string | null => {
  if (!LOGICAL.includes(side)) return side;
  return sidesOf(f)?.[LOGICAL.indexOf(side)] ?? null;
};
const SIDE = "(top|right|bottom|left|block-start|block-end|inline-start|inline-end)";
const BOX = new RegExp(`^(margin|padding)-${SIDE}$`), INSET = new RegExp(`^(?:inset-${SIDE}|(top|right|bottom|left))$`);
const BORDER = new RegExp(`^border-${SIDE}-(width|style|color)$`), SIZE = /^(min-|max-)?(width|height|inline-size|block-size)$/;

// the box side or size a property sets, the same for its physical and its logical name in this flow ("margin|top",
// "inset|left", "border-width|bottom", "size|width", "min-size|height"); null: not a side or size, or an unknown flow
export function sideKey(name: string, f: Flow): string | null {
  let m = BOX.exec(name);
  if (m) { const s = physical(m[2], f); return s && `${m[1]}|${s}`; }
  m = INSET.exec(name);
  if (m) { const s = physical(m[1] ?? m[2], f); return s && `inset|${s}`; }
  m = BORDER.exec(name);
  if (m) { const s = physical(m[1], f); return s && `border-${m[2]}|${s}`; }
  m = SIZE.exec(name);
  if (m && sidesOf(f)) {
    const across = m[2] === "width" || (m[2] === "inline-size" && f.writingMode === "horizontal-tb") || (m[2] === "block-size" && f.writingMode !== "horizontal-tb");
    return `${m[1] ?? ""}size|${across ? "width" : "height"}`;
  }
  return null;
}

// a logical side or size name (only then is an element's flow asked: a target with physical names alone can't hold two)
export const isLogical = (name: string): boolean => /(^|-)(block|inline)-(start|end|size)(-|$)/.test(name) && sideKey(name, { writingMode: "horizontal-tb", direction: "ltr" }) !== null;

// a writer for one target's declarations as the cascade sets them, in cascade order: setting a side or size drops the
// other name of it set before; a name keeps its first place when set again. f null (the target names no logical side):
// every name is set as it comes, byte for byte as before
export function oneName(out: Record<string, string>, f: Flow | null): (name: string, value: string) => void {
  if (!f) return (name, value) => { out[name] = value; };
  const holder = new Map<string, string>();
  for (const k of Object.keys(out)) { const s = sideKey(k, f); if (s) holder.set(s, k); }
  return (name, value) => {
    const s = sideKey(name, f);
    if (s) {
      const was = holder.get(s);
      if (was !== undefined && was !== name) delete out[was];
      holder.set(s, name);
    }
    out[name] = value;
  };
}
```

### Task F2 (v2): the reader keeps the winner, the capture says so (AC7 RED first) ⟦v2⟧

- Write the fixture `test/fixtures/web/sites/twice-sides/index.html` and `style.css`, and `test/web/site-twice-sides.test.ts`, exactly as `planner-2/code/twice-sides/` and `planner-2/code/site-twice-sides.test.ts` (sha256 in `code/SHA256SUMS`). The fixture is generic: no site's copy. ⟦v2⟧
- **RED:** `node --test --test-name-pattern='the capture keeps each box side by one name' test/web/site-twice-sides.test.ts` (with `CHROME_PATH` and a short `TMPDIR`) fails on its misses list: both names kept (planner 2's runs on the built head and on staging-fit-cancels: `planner-2/red/web-headred.log`, `web-sfcred.log`). ⟦v2⟧
- Make these edits (they are `planner-2/code/apply-fix.py`'s "src" part, which applies them by anchor and fails on a missing one): ⟦v2⟧
  - `src/web/read/code.ts`: after `import { markupOf } from "./code-markup.ts";` add `import { isLogical, oneName, type Flow } from "./code-sides.ts";`. ⟦v2⟧
  - In `interface Target { … rest: Set<string> }` add `; flow?: Flow` after `rest: Set<string>`. ⟦v2⟧
  - Replace the loop that writes `t.out` (the block starting `  targets.forEach((t, i) => {` whose body sets `Object.assign(t.out, longhands)` / `t.out[d.name] = d.value`) with the block below. ⟦v2⟧
  - In the `readStates(…)` call, the target map gains `, flow: t.flow` after `rest: t.rest`. ⟦v2⟧
  - `src/web/read/code-states.ts`: after `import { pathOf } from "./page-reader.ts";` add `import { isLogical, sideKey, type Flow } from "./code-sides.ts";`; `StateTarget` gains `flow?: Flow` (with the comment line below); replace the `found.forEach` cascade block as below. ⟦v2⟧
  - `src/core/snapshot/web.ts` `WebCode`: after the `sheets?` line add `oneName?: true;` with its comment (below). `src/web/code.ts` `assembleCode`: the returned object ends with `oneName: true,   // footer-icon-list: read/code-sides.ts`. ⟦v2⟧
- The second AC's test: edit `test/web/site-logical-sides.test.ts` as `planner-2/code/ac2-edit.py` does (it applies by anchor): the precondition "an item's widest range holds both names" becomes "the item holds `margin-block-start` alone", asserted after `assert.deepEqual(misses, [])`. Without this edit the test fails on the new capture by its own precondition (planner 2's first fix-tree run). ⟦v2⟧
- **GREEN:** `node --test test/web/site-twice-sides.test.ts test/web/site-logical-sides.test.ts` passes 3/3 (planner 2's fix tree: `red/web-fix.log`). REDs of the same three tests: the built head fails all three (its capture keeps both names; AC8 on b, d, f, i, k, q, r, s, t, v, w, x and z, z2 hovered), staging-fit-cancels fails all three (AC2 72 px from 768 up, 36 on phones) (`red/web-headred.log`, `red/web-sfcred.log`). Run `npm run typecheck`. Commit. ⟦v2⟧

`code.ts`, the loop (replaces the old `targets.forEach` block's first lines through `else t.out[d.name] = d.value;\n    }`): ⟦v2⟧

```ts
  // footer-icon-list: one name per box side and size, the cascade's winner (code-sides.ts); the flow (computed
  // writing-mode and direction) asked only of targets that declare a logical side or size, all in one batch
  const longOf = (d: { name: string; value: string; short: boolean; maybe?: boolean }): Record<string, string> | null => {
    const lh = expanded.get(`${d.name}\u0000${d.value}`) ?? {};
    return d.short || (d.maybe && Object.keys(lh).some((k) => k !== d.name)) ? lh : null;
  };
  const flowAt = targets.map((_, i) => i).filter((i) => resolved[i].some((d) => d.value !== null && Object.keys(longOf(d) ?? { [d.name]: "" }).some(isLogical)));
  const flowAsks = flowAt.flatMap((i): Array<[number, string, string]> => [[targets[i].at, targets[i].pseudo, "writing-mode"], [targets[i].at, targets[i].pseudo, "direction"]]);
  for (let k = 0; k < flowAsks.length; k += 300) {
    const got = (await s.run<{ props: string[] }>(codeAsks, [{ vars: [], props: flowAsks.slice(k, k + 300) }])).props;
    for (let j = 0; j < got.length; j += 2) targets[flowAt[(k + j) / 2]].flow = { writingMode: got[j], direction: got[j + 1] };
  }
  targets.forEach((t, i) => {
    const put = oneName(t.out, t.flow ?? null);
    for (const d of resolved[i]) {
      if (d.value === null) continue;
      const lh = longOf(d);
      if (lh) for (const [k, v] of Object.entries(lh)) put(k, v);
      else put(d.name, d.value);
    }
```

`code-states.ts`, the cascade (replaces `      found.forEach((f, i) => {` through the end of its `for (const d of …)` loop): ⟦v2⟧

```ts
      // footer-icon-list: one name per box side under the state too (code-sides.ts); a target whose declarations at
      // rest named no logical side has no flow yet: asked here, in one batch, where the state's name one
      const named = (i: number): string[] => resolved[i].flatMap((d) => { const lh = d.short ? longhands.get(`${d.name}\u0000${d.value}`) : undefined; return lh && Object.keys(lh).length ? Object.keys(lh) : [d.name]; });
      const asked = found.map((_, i) => i).filter((i) => !found[i].t.flow && named(i).some(isLogical));
      const fa = asked.flatMap((i): Array<[number, string, string]> => [[found[i].t.at, found[i].t.pseudo, "writing-mode"], [found[i].t.at, found[i].t.pseudo, "direction"]]);
      const flows = new Map<number, Flow>();
      for (let k = 0; k < fa.length; k += 300) {
        const got = (await s.run<{ props: string[] }>(codeAsks, [{ vars: [], props: fa.slice(k, k + 300) }])).props;
        for (let j = 0; j < got.length; j += 2) flows.set(asked[(k + j) / 2], { writingMode: got[j], direction: got[j + 1] });
      }
      found.forEach((f, i) => {
        // the cascade, longhand by longhand (normal declarations in order, then !important ones); a side's other name
        // set before gives way
        const win = new Map<string, Item>();
        const list = resolved[i];
        const flow = f.t.flow ?? flows.get(i) ?? null;
        const holder = new Map<string, string>();
        for (const d of [...list.filter((x) => !x.important), ...list.filter((x) => x.important)]) {
          const lh = d.short ? longhands.get(`${d.name}\u0000${d.value}`) : undefined;
          for (const [k, v] of Object.entries(lh && Object.keys(lh).length ? lh : { [d.name]: d.value })) {
            const side = flow && sideKey(k, flow);
            if (side) { const was = holder.get(side); if (was !== undefined && was !== k) win.delete(was); holder.set(side, k); }
            win.set(k, { ...d, name: k, value: v });
          }
        }
```

`StateTarget` and `WebCode`: ⟦v2⟧

```ts
// flow (footer-icon-list): its computed writing-mode and direction when its declarations at rest name a logical side
export interface StateTarget { at: number; pseudo: "" | "::before" | "::after"; path: string; part: string; rest: Set<string>; flow?: Flow }
```

```ts
  oneName?: true;                              // footer-icon-list: each box side and size is held by one name, the site
                                               // cascade's winner (absent: an older capture, which may hold both)
```

### Task F3 (v2): the conversion picks no winner (blocks.ts back, sides.ts rewritten, AC9) ⟦v2⟧

- Write `test/unit/site-older-sides.test.ts` exactly as `planner-2/code/site-older-sides.test.ts`. ⟦v2⟧
- **RED:** `node --test test/unit/site-older-sides.test.ts` fails: on the built head on `"_margin":{"top":"0px"}` (the physical side dropped), on staging-fit-cancels on the note count (0, want 1) (`planner-2/red/unit-*.log`). ⟦v2⟧
- `src/core/site/blocks.ts`: make it exactly the base's text (`git checkout <B> -- src/core/site/blocks.ts`): no `sides.ts` import, `statesOf` pushes `cur`. ⟦v2⟧
- Delete `test/unit/site-one-side-ranges.test.ts` (the ranges rule is gone). ⟦v2⟧
- Write `src/core/site/sides.ts` exactly as below (replaces the v1 file). ⟦v2⟧
- `src/core/site/convert.ts`: add `import { olderPairs, olderSidesNote } from "./sides.ts";` before the `import { pageRanges` line, and after the line `  const note = (m: string) => { if (!notes.includes(m)) notes.push(m); };` in `prepare` add: ⟦v2⟧

```ts
  // footer-icon-list: an older capture holding a box side by two names says to capture again (sides.ts)
  const older = olderPairs(original.web!.code!, rootPath);
  if (older) note(olderSidesNote(older));
```

- **GREEN:** AC9 passes; `npm run check` passes with the base's tallies plus this job's files (planner 2's fix tree: 3483 pass, 0 fail, 72 skipped, `planner-2/red/unit-fix.tap`). Commit. ⟦v2⟧

```ts
// A box side written by two names in an older capture (footer-icon-list). Since this build the capture's reader keeps
// each box side and size by one name, the site cascade's winner (src/web/read/code-sides.ts), and marks the capture
// (web.code.oneName). An older capture keeps both names, each where its first declaration put it, so which one the site
// applied can't be read from it: the paste keeps both, as before (Bricks then shows the physical one, a class control at
// `.<class>.brxe-<element>`, 0,2,0, over the logical one in its custom CSS, 0,1,0), and the part says to capture the
// page again. Pure.
import type { CodeByRange, CodeDecls, WebCode } from "../snapshot/web.ts";
import { statesOf } from "./blocks.ts";

const ZERO = /^[+-]?0*\.?0+(px|%|em|rem|vw|vh)?$/;
// [physical, logical]: one side or size in horizontal writing, whatever the direction
export const PAIRS: ReadonlyArray<readonly [string, string]> = [
  ...["margin", "padding"].flatMap((p) => [[`${p}-top`, `${p}-block-start`], [`${p}-bottom`, `${p}-block-end`]] as const),
  ["top", "inset-block-start"], ["bottom", "inset-block-end"],
  ...["width", "style", "color"].flatMap((x) => [[`border-top-${x}`, `border-block-start-${x}`], [`border-bottom-${x}`, `border-block-end-${x}`]] as const),
  ["width", "inline-size"], ["height", "block-size"], ["min-width", "min-inline-size"], ["min-height", "min-block-size"],
  ["max-width", "max-inline-size"], ["max-height", "max-block-size"],
];

const same = (a: string, b: string): boolean => a.trim() === b.trim() || (ZERO.test(a.trim()) && ZERO.test(b.trim()));
// a state holding one block side or size by both names with values that draw differently (a state declaring a writing
// mode other than horizontal-tb is left out: its two names are two sides). The inline sides (left or right beside
// inline-start or inline-end) are left out: which of them a logical name means depends on the direction, and main's
// paste of them never changed (older fixture captures hold such pairs where the physical side wins)
export function holdsPair(d: CodeDecls): boolean {
  const wm = d["writing-mode"];
  if (wm !== undefined && wm !== "horizontal-tb") return false;
  return PAIRS.some(([p, l]) => p in d && l in d && !same(d[p], d[l]));
}

// how many elements at or under root an older capture holds such a pair on, in some range (its own declarations, its
// ::before/::after's or an inline element's of its words); 0 for a capture made since this build (web.code.oneName)
export function olderPairs(code: WebCode, root: string): number {
  if (code.oneName) return 0;
  const holds = (b: CodeByRange | undefined) => !!b && statesOf(b, code.ranges).some(holdsPair);
  return Object.entries(code.nodes).filter(([p, n]) => (p === root || p.startsWith(root + "/"))
    && [n.decls, n.pseudo?.before, n.pseudo?.after, ...Object.values(n.inline ?? {})].some(holds)).length;
}
export const olderSidesNote = (n: number): string =>
  `${n} element${n === 1 ? "" : "s"} here ${n === 1 ? "has" : "have"} a box side the site writes by two names (margin-top and margin-block-start, or the like) with different values: this capture was made before the capture kept only the one the site applies, so the paste keeps both as before and Bricks shows the margin-top kind, which may not be the site's; capture the page again with this build`;
```

### Task F4 (v2): the byte receipt for AC4, rewritten ⟦v2⟧

- Replace `test/unit/site-one-side-sums.test.ts` with `planner-2/code/site-one-side-sums.test.ts` (same test name; the body now asserts the payloads byte for byte and the note exactly where `olderPairs` counts). ⟦v2⟧
- Run it with the env above (`F2B_ONE_SIDE_BASE` = the base archive). Planner 2's run on the fix tree against staging-fit-cancels: 1/1, 26 verdicts, every payload the same, the note on the four B-Dry footers' parts only (both routes) (`planner-2/red/sums-fix.log`). It is a guard: on the built head and on the base it fails on its import (`red/sums-*.log`). ⟦v2⟧
- Confirm the Figma side is untouched: `npm run corpus` equals Task 0's numbers. Commit. ⟦v2⟧

### Task F5 (v2): B-Dry (AC1) and the capture's cost and bytes (AC10) ⟦v2⟧

- Write `test/web/capture-one-side-bdry.test.ts` exactly as `planner-2/code/capture-one-side-bdry.test.ts`. ⟦v2⟧
- The time and bytes receipt (AC10): run it named-only with the env above (`F2B_BASE_TREE` = the base archive) under the 8G scope; it takes four B-Dry captures. **RED** on the base and on the built head's tree (`~/.cache/fil-f1/head0`, the test copied in): `web.code.oneName` missing; record those runs. ⟦v2⟧
- The B-Dry receipt (AC1): run `node --test test/web/site-elementor-page-bdry.test.ts` with F2B_ELEMENTOR_STANDIN **unset** and `F2B_ELEMENTOR_PAGE_OUT` set, in the head (passes 2/2) and in the base archive (fails: footer 69 px). Record the head's fresh capture's sha256 (`sha256sum <out>/standin-capture.json`) in the ledger and in HANDOFF: the verifier and the auditor may reuse it as F2B_ELEMENTOR_STANDIN for supporting runs. ⟦v2⟧
- `npm run site:check -- <the head's fresh capture> --part footer --elementor`, with the default 2.4.2 and with `--bricks 2.3.9`: both OK (worst ≤ 2 px). The same on the saved older stand-in capture: 69 px as on main, and the note "capture the page again" in its notes (Q4 A). ⟦v2⟧
- Before/after pictures of the footer (base capture and paste, head capture and paste) to `~/.hermes/plans/figma-to-bricks/shots/footer-icon-list/`, never committed. Ledger; commit the test and the ledger. ⟦v2⟧

### Task F6 (v2): gates ⟦v2⟧

- `npm run check`, `npm run test:browser`, and `npm run test:web` (with CHROME_PATH): pass by test name as the base plus this job's tests. Compare by name against the base archive run the same day. AC5's named test is in it. ⟦v2⟧
- Expected differences to record, not to fix: the named-only story pins of capture-speed that compare a capture with an older tree's byte for byte (`capture-speed-same.test.ts` "AC1 every fixture site captures as it did before", `capture-speed-bdry.test.ts` "AC2 the saved B-Dry page captures and pastes exactly as before") now differ by `web.code.oneName` and, on sites with a pair, the dropped names: name them in the ledger, with the first difference each prints. ⟦v2⟧
- `npm run corpus` unchanged. **Mutation** (`mutation-testing-discipline`, under `systemd-run … MemoryMax=4G`), each must fail a named test, then restore: (m1) `oneName` returns the plain writer for every flow → AC3, AC7, AC8 fail; (m2) `sideKey` maps `inline-start` to `left` whatever the direction → AC3 (rtl) and AC8 (s, t) fail; (m3) `code-states.ts` without the side rule → AC7 and AC8 (z, z2 hovered) fail; (m4) `olderPairs` ignores `oneName` → AC9 fails; (m5) `holdsPair` without the "draws the same" check → AC9 (the zero pair) and AC4 fail. ⟦v2⟧
- A SIGTERM / 137 / "Killed" is checked against earlyoom first: `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`. ⟦v2⟧

### Task F7 (v2): docs and records ⟦v2⟧

- `docs/HANDOFF.md`: rewrite this job's section: the capture keeps each side's winner (plain words); the 69 px proof; the probes' table (short form) and the link to `planner-2/probe/`; Q4's answer and what an older capture does (the note); the known limits (other writing modes, layered `!important`, corner radii, the measured route's authored values); the head's fresh stand-in capture's sha256; that site-native-structure's AC14 needs a fresh stand-in capture too; the paste check entry (next free id at the merge) and that it starts with a re-capture. ⟦v2⟧
- CLAUDE.md standing rule for the finisher (replaces v1's): "**A captured box side is held by one name, the site cascade's winner** (`web/read/code-sides.ts`, `web.code.oneName`): the reader drops a side's other name (physical or logical, mapped by the element's writing mode and direction) as the cascade sets it; the conversion never picks between two names, and an older capture holding both pastes as before with a note to capture again (`site/sides.ts`)." If CLAUDE.md can't be written, the finisher leaves it in `~/.hermes/plans/figma-to-bricks/footer-icon-list-claude-md-pending.md`. ⟦v2⟧
- Commit. ⟦v2⟧

### Task F8 (v2): stop at ready-for-review ⟦v2⟧

- The ledger names every commit F0–F7, the base `<B>`, the RED and GREEN receipts per AC and the mutants. Report `ready-for-review` with the head SHA. The next step is a fresh review of the whole story (from `<B>`), then the verifier and the blind auditor. ⟦v2⟧

## Found elsewhere (not this job)

- `site:check --whole --elementor` on the B-Dry stand-in draws the **page** part 64 px off (from 768 to 2560, at 1440
  too), 46.5 px on phones and 6.93 px at 1196–1964. The same happens on base and on the fix; the per-part checks put the
  page within 1.02 px. So the page drawn beside the header and footer differs from the page drawn alone: a candidate
  for its own job (`main-whole/report.json`, element `…/div:0/div:0/div:0/div:1` of the page's first section).
- Follow-ups:
  - Q1 (inline sides): done in v2 (the reader). ⟦v2⟧
  - Q2 (capture-side exactness): done in v2. ⟦v2⟧
  - Hover/state looks: done in v2 (the state's cascade keeps one name per side). A look whose winning name differs from the rest's (rest `margin-block-start`, hover `margin-top`, probe z3) draws right in the renderer on both samples; a live paste check of such a look is owed with the first site that has one. ⟦v2⟧
  - The measured route's authored values (`src/web/read/authored.ts` `AUTHORED`) read physical names only, so a logical winner is invisible there; that route is being retired for websites, and its values are checked against the browser's px before use. ⟦v2⟧

## Mini or Full

**Full (v2).** The Mini plan's conversion-only fix was proved unable to be right (review 1, R1-1); the fix moves into the capture (a format field, the reader, the state reader), adds a policy for older captures that is Justin's decision (Q4), and stacks on another job. One review of the whole story after the fix, then the verifier and the blind auditor. ⟦v2⟧
