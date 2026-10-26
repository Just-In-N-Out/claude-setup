# card-hover-shift — a hovered card's title drops to a new line and its arrow vanishes on tablets and phones (PLANNER)

**Approved by Justin 2026-10-22** (desktop picks): Q1A, Q2A, **Q3B (differs from ⭐: fix the hover arrow wrapper too)**, Q4A, model Opus 5.5 medium build / Opus 5.5 xhigh review+verify. See "Justin's answers" at the end.

Base: main `b4ed333` (BUILD 2026-10-22.5). Planner only: no worktree, code, test or commit. Debug JSON untouched (scratch copy, sha256 in evidence).
Skills loaded, in order: figma-to-bricks (PLANNER; rules-summary first), engineering-best-practices, implementation-planning, systematic-debugging, frontend-ui-repair (Agent Defect Loop, run by the main chat as pipeline roles).
Size: **in-between → Opus 5.5 medium** builder/finisher, fresh **Opus 5.5 xhigh** reviewer and verifier. The code change is small (one source file), but it adds a line to one of Justin's written decisions ("the instance keeps padding and spacing" gains "and how each layer sizes") and it reaches every hover copy in every design. When unsure, take the bigger size. One word ("sol") moves it to Sol 6.1 xhigh.

## Questions (⭐ = recommended; the plan below assumes the ⭐ answers)

**Q1. Where the fix applies**
- A ⭐ At every width. This also fixes laptops (1024–1366), where the hovered label gets squeezed and the title slides 13–34px left.
- B Only ≤991px (tablets and phones). Laptops keep the small shift.

**Q2. Which layers take the card's own sizing in the hover copy**
- A ⭐ Only layers the hover variant draws at the same size (±1px).
- B Every paired layer, even ones the hover resizes.

**Q3. The leftover 3px-wider hover arrow (at 360px, one long title wraps)**
- A ⭐ Leave it. Measure it and list it as a follow-up.
- B Also fit a wrapper the hover variant adds into the arrow's own room.

**Q4. The new written rule**
- A ⭐ Add "and how each layer sizes (fill, hug, fixed)" to CLAUDE.md's "The instance keeps…" line.
- B Keep it as a code comment only.

## 1. The request, played back

1. On the page's "MORE SERVICES / EXPLORE WHAT ELSE WE DO." section there's a 2×2 grid of linked service cards. Each card is one row: a yellow "Service 0X" label, an uppercase title and a small ↗ arrow.
2. At tablet width (Bricks "Tablet portrait", 990px) hovering a card plays its hover animation. But the title drops below the label onto a new line at the card's bottom edge, and the arrow disappears.
3. Justin says the same happens on phones (where a tap counts as a hover).
4. Expected: the hover animation plays, and the label, title and arrow stay where they were, matching the unhovered card and desktop.
5. Fix it with general logic (no keying on this design) and leave desktop unchanged.

## 2. Root cause (with evidence)

**How a hover works here.** This card's hover can't be drawn with CSS hover styles alone (its arrow changes). So the plugin builds a **hover copy**: a copy of the Figma hover variant's layers, laid over the card (`placement: "cover"`, absolute, inset −1px), which fades in on hover while the card's own layers fade out (`src/core/understand/overlay.ts` `hoverLayer`). The copy takes its **look** from the variant. From the instance it takes only words, photos, hidden layers, padding and spacing (overlay.ts:55–71; CLAUDE.md "Other states of a component show the variant as designed").

**What differs in the Figma file.** In the user's debug file (`figma-to-bricks-debug-page-1.json`, scratch copy), component set "Component 3" has 4 variants × hover on/off:

| layer | default variant (e.g. `553:7372` variant=2,:hover=false) and every instance | hover variant (e.g. `553:7362` variant=2,:hover=true) |
|---|---|---|
| `div.oc-n` (label) | FIXED 80 | FIXED 80 |
| `div.oc-t` (title holder) | **FILL** (layoutGrow 1), drawn 567 | **FIXED 567** |
| arrow | `div.oc-arrow` HUG 16×25 | wrapper `div.oc-arrow:css-transform` 19×35 (pad 3/1.88) around it |

All four hover variants (`553:7342/7362/7381/7400`) have the FIXED title holder. All four default variants have FILL. The drawn width is the same (567); only the resize mode differs.

**What the plugin emits** (replay of the scratch copy, card `krjgyr` "Core Exchanges", copy `rnsbxz`):
- Card's title holder `txrswg`: `flex-basis:0; flex-grow:1; min-width:0`, and ≤991 `min-width:min(114px,100%)`. It shares the row.
- Copy's title holder `wipqyg`: `width:567px; max-width:100%; min-width:114px`. Its sizing comes from the variant, because `prune` (overlay.ts:47–83) never replaces `x.sizing` / `src.sizing` for a frame. The IR sizing was set from the variant layer at build time (`understand/node.ts:15`), and `style/sizing.ts:203–233` reads `ir.sizing.w`.
- At ≤991 both rows get `flex-wrap:wrap; row-gap:18px` (card `krjgyr` and copy `rnsbxz`). In the copy, 80 + 18 + 567px can't fit, so the title wraps to its own full-width line and the arrow wraps to a third line. The copy is pinned to the card's box (top/bottom −1px), so the title lands on the card's bottom edge and the arrow falls below it. That's the "disappears" Justin saw. The card's own arrow is faded out (`.trigger-…:hover #brxe-jdktzg {opacity:0}`).
- Above 991 there's no wrap: the fixed 567px holder shrinks and squeezes the FIXED 80px label (`min-width:46px`) to 47–67px. "Service 03" wraps to 2 lines at ≤1200 and the title shifts 13–34px left. This is the same cause, a smaller symptom.

**Reproduced in Chrome** (scratch `repro.ts`: real render via `test/browser/chrome.ts` + `render.ts`, real mouse hover, 4 cards × 15 widths; logs in evidence):
- **main:** at every width ≤991 (990/768/600/480/390/375/360/320) each hovered copy stacks label / title (full width) / arrow. At 990 "Core Exchanges": own title at y62 next to the label at x125; copy title at x27 y62 under the label; copy arrow at y111 in a 112px card, i.e. outside it. That matches Justin's screenshot. 1440→1024: the copy label is 47–67px wide instead of 80, and the title starts at x91–112 instead of x125.
- **Emulation** (`EMULATE=1`: give each copy child whose paired own child has `flex-grow:1` the same flex-grow/basis/width:auto/min-width): label and title match the own card within ≤3px at every width from 1440 to 320. The arrow is offset by the variant's designed ≤5px nudge, and every copy child stays inside the card. The one exception is at 360: "Assembly, Test, Paint & Delivery" fits the own row with <5px to spare, and the hover arrow's wrapper is 3px wider, so the copy title wraps (Q3).

**Ranked hypotheses tested:** (1) the copy keeps the variant's FIXED sizing → confirmed by data and emulation. (2) A tablet rule misses the copy → the copy does get the same wrap/gap/label floors; only the title holder differs because it isn't "fill". (3) The hover rule restores a desktop value at a breakpoint (the `:hover` CSS on the card is paint only) → ruled out.

## 3. Approach

In `hoverLayer`'s `prune` (overlay.ts), a paired layer `v` (hover variant) with an instance layer `i` takes the instance's **sizing mode** on each axis, when:
- the variant draws that axis at the same size as the main's layer `m` (±1px; with no main known, compare with `i`) (Q2A),
- and the layer is not the copy's root (the root is placed by cover).

Set both `src.sizing` and the IR's `sizing`: `style/sizing.ts` reads `ir.sizing` for the layer and `p.sizing` (scene) for its parent. A size the hover really changes keeps the variant's sizing. This follows the existing rule, which is a structural, design-agnostic check: "look comes from the variant, layout from the instance" (padding and spacing are already taken).

Every downstream rule then sees the copy exactly as the card: fill holder → `flex:1 1 0`, the ≤991 `min(114px,100%)` floor, the same wrap points. No `adapt/rules` change, no new breakpoint styles, no CSS regex. That keeps "only adapt/rules writes bp styles".

Rejected:
- `flex-wrap:nowrap` on hover copies. Phones that genuinely wrap would overflow, and the copy would no longer match the card.
- Copying the card's breakpoint CSS onto the copy in adapt. That's a second source of truth, with collision rules.

## 4. Tasks (builder; test first, commit after each passing task)

0. **Setup**: Step 2 copy `card-hover-shift`; `npm run check` green before changes. Save the baseline `npm run corpus` report, `corpus/report-v2.json` and `corpus/out/v2/*/bricks.json` copies. Copy the debug JSON to scratch and `npm run replay` it to `.superpowers/sdd/card-hover-shift/before/`.
1. **Before pictures (hover state)**: copy `~/.hermes/plans/figma-to-bricks/evidence/card-hover-shift/repro.ts` to `.superpowers/sdd/card-hover-shift/tools/`. Extend it with a clipped `page.screenshot` of the hovered "MORE SERVICES" grid at 990 and 390 (plus 768 and 375), and save to `shots/before/`. `npm run snap` doesn't hover, so the hover pictures come from this script. Also run `npm run snap -- <scratch debug> .superpowers/sdd/card-hover-shift/shots/before --sides` for the unhovered page.
2. **RED unit test** in `test/unit/understand-overlay.test.ts`, using a generic fixture. The card is a row with a fixed 80 label box, a FILL title holder and a 16px icon. Its hover variant is the same with the title holder FIXED at the drawn width and the icon recoloured. Assert the copy's title holder has `sizing.w === "fill"` (IR and src), equal to the instance's.
   - **Control:** a hover variant that really widens a fixed box (100→140) keeps `fixed` and its own width.
   - **Control:** the copy root keeps its cover placement.
   - Run `node --test test/unit/understand-overlay.test.ts`. It must fail on the new assertion only.
3. **GREEN**: implement in `src/core/understand/overlay.ts` `prune` (a small `sizingOf(v, i, m)` helper; stays under 300 lines). Re-run that file, then `npm test`.
4. **RED→GREEN browser test** in a new file `test/browser/hover-copy-layout.test.ts`.
   - Fixture: a 2-column grid of 4 linked row cards built from that fixture, with titles of different lengths (one long enough to wrap on phones).
   - For widths 1440, 1366, 1300, 1200, 1100, 1024, 992, 990, 768, 600, 480, 390, 375, 360, 320: `mouseMove` onto each card. Assert:
     - copy label and title rects equal the paired own rects within ±3px in x/y, with the same height (line count);
     - the arrow is within ±6px;
     - every copy child lies inside the card.
   - Also assert unhovered rects are unchanged vs before (no layout change to the card itself).
   - Give the fixture enough slack that the 3px arrow wrapper difference can't trigger a wrap (Q3A). The design-file residual is measured separately in task 6.
   - Prove RED: `git checkout HEAD~1 -- src/core/understand/overlay.ts`, see the test fail at ≤991, then restore.
5. **Mutation**: drop the "same drawn size" guard and check the widening control in task 2 fails. Drop the IR-sizing half (keep src only) and check the browser test fails. Restore.
6. **After proof on the real file**:
   - Replay the scratch debug copy and run the repro script at all 15 widths. Every card: label and title equal ±3px, arrow inside the card.
   - Report the 360 "Assembly…" residual (Q3A) with numbers.
   - Element-diff before/after `bricks.json` by id: only hover-copy children (`data-label` contains `:hover=true`) may change.
   - Take the after pictures into `shots/after/`, and copy `before-more-services-{990,390}.png` / `after-…` to `~/.hermes/plans/figma-to-bricks/shots/card-hover-shift/`.
   - Laptop check (1024–1366): the hovered copy's last-item right edge equals the own card's within ±6px (designed arrow nudge).
7. **Gates**:
   - `npm run check` green.
   - `npm run corpus`: compare with the baseline (`cmp` pastes; any changed paste must differ only inside hover copies; no new lint identity; no new "Worse than v1").
   - `npm run test:browser` at the merge.
8. **Docs & records** (below).

## 5. Tests and acceptance

- Unit: copy sizing follows the instance (fill), the widening control keeps fixed, the root stays cover.
- Browser: the 15-width hover geometry above. Phones 375/360/320 are included per the phone rule. Laptops 1100–1366 and 1024/992 are included per the margins rule.
- Real file: the repro script at all widths. Before vs after numbers go in the ledger.
- Lint at 990/768/390/375/360/320 with a card hovered: no new error.
- Paste check (Justin): hover each service card at Tablet portrait and Mobile in the Bricks builder and on the live page. The title stays beside its label and the arrow stays at the top right.

## 6. Choices made (from ⭐)

Q1A all widths · Q2A same-size guard · Q3A residual measured and recorded, not fixed · Q4A CLAUDE.md line.

## 7. Risks

- Other designs' hover copies change wherever a variant's sizing mode differs from the instance at the same drawn size. That's intended (same bug class), but corpus pastes may move. The builder must show each changed element is a hover-copy child and that its hovered rect now matches its own card.
- Text twins whose words the instance changed: their `src.sizing` was already the instance's (overlay.ts:58), but the IR sizing wasn't. The new rule will align IR with src there too. Check `understand-overlay.test.ts:105` still passes, and add a geometry assertion if output changes.
- The hover variant's arrow wrapper is 3px wider and 10px taller than the card's arrow. Where a title has <5px slack, the copy can wrap where the card doesn't (seen at 360). Where the arrow sits on its own line, the copy can poke ≤8px past the card's bottom. Both are measured in task 6 and left for Q3 if Justin wants them.
- Bricks' builder preview may render the copy slightly differently from the renderer. The paste check covers that.

## 8. Touches

- `src/core/understand/overlay.ts` (only source file).
- `test/unit/understand-overlay.test.ts` (add tests; the builder may edit the existing case at :105 if it pins the old IR sizing).
- `test/browser/hover-copy-layout.test.ts` (new).
- Read-only imports: `test/browser/chrome.ts`, `render.ts`, `lint.ts`, `test/fixtures/builders.ts`.
- Existing tests that may assert the old behaviour, which the builder may edit if they pin a hover copy's fixed width: `test/unit/understand-overlay.test.ts`, `test/unit/emit-states.test.ts`, `test/browser/interactions.test.ts` (hover layer geometry tests :129–187), `test/golden/*` if a golden paste holds a hover copy.
- Pipeline parts: understand (overlay). Style, adapt and emit are unchanged.

## 9. Overlaps

- `found-layout`: nudge.ts, upright.ts, place.ts, style.ts → no shared file.
- `found-tiles`: settings.ts, past-edge.ts, scene.ts, compose.ts → no shared file.
- `found-contacts` and `found-gates` (gates edits `test/browser/lint.ts`, which we only import) → no shared file.
- `found-list-head`: lists.ts, list-links.ts, rules/list.ts → no shared file.
- `found-text-decoding`: panel test → no shared file.

**Can build in parallel with all of them.** Rebase before the merge: corpus pastes may shift from layout/tiles merges, so re-take the corpus baseline on the rebased main.

## 10. Docs & records (last task)

- Copy the plan to `docs/plans/2026-10-22-card-hover-shift.md` (or the merge date).
- Move the ledger from `.superpowers/sdd/card-hover-shift/progress.md` to `docs/plans/card-hover-shift-ledger.md`.
- Update `docs/HANDOFF.md` with a section "Hover copies size like the card (card-hover-shift, build …)" and the **paste check owed**: the next free number on main at merge time (3ba is reserved and 3bb/3bc are taken; likely 3bd). Justin's steps: reload the plugin, Convert and copy, paste into Bricks, save, LiteSpeed Purge All. Hover each service card at Tablet portrait and Mobile, then reply *pasted + page name*.
- Bump `BUILD` (finisher, at the merge).
- Finisher updates the main `CLAUDE.md` "Start here" and "Where things stand".
- New `CLAUDE.md` rule (Q4A): under "Other states of a component show the variant as designed", the instance line becomes "words and photos that differ from its own main component, layers it hides, padding and spacing, **and how each layer sizes (fill/hug/fixed) where the variant draws it at the same size**". Finisher also updates `references/rules-summary.md` ("Variants supply looks; instances retain content and sizing modes").

## Other things found (not in this fix)

1. **Unhovered card drops its arrow to its own line on tablets** (P3). At 990 the "Remanufactured Hydraulic Cylinders" card (title 2 lines) puts its arrow at x27 on a third line (card 155px tall vs a 112px neighbour). At 768/600 the same happens for most cards. It's the base row-wrap policy, not hover. Possible owner: a row-allocation plan; `found-layout` doesn't cover it. Evidence: `main.log` "own=" columns.
2. **Header text links' hover copies are 2–3px off** (P3, unverified). The nav links "/", "/about-page-final/", "/contact-page-final/" have hover copies 50/58/79px wide and 21 tall vs own 55/63/87 × 18, offset −1 to −3px in y at every width. It may be designed (different line height in the variant). Needs a look in Figma before calling it a bug. Evidence: unfiltered repro output.
3. **The text twin's IR sizing isn't updated when the instance changed its words** (P3). overlay.ts:56–60 replaces `src.sizing` with the instance's but leaves `ir.sizing` (which style reads) as the variant's. The new rule will likely align it as a side effect (see Risks). If not, it's its own small item.
4. **The debug file is from build 2026-10-20.6** (info, not a bug). Justin's screenshot shows Service 01/03/04/05 (another page of the same site); the replayed page shows 02–05. Same component, same cause.

Evidence: `~/.hermes/plans/figma-to-bricks/evidence/card-hover-shift/` — `repro.ts`, `main.log` (main b4ed333), `emulate.log` (fill emulation), `input.sha256`, `source-commit.txt`.


## Justin's answers (2026-10-22)

- **Q1 → A** fix at every width (laptops too).
- **Q2 → A** only layers the hover variant draws at the same size (±1px) take the card's sizing.
- **Q3 → B (differs from ⭐)**: fix the hover arrow wrapper in this feature too. The extra wrapper the hover variant adds around the arrow (`div.oc-arrow:css-transform`, 19×35 with padding 3/1.88, around the 16×25 arrow) must not take more row room than the card's own arrow, so the copy wraps exactly like the card: at 360 "Assembly, Test, Paint & Delivery" stays on the label's line when hovered, and an arrow on its own line never pokes below the card. Keep the arrow's visible hover position and motion as designed (±1px). General rule (any added wrapper around a paired layer), not keyed on this design. Build it as its own task and commit after Q1/Q2, so it can be dropped alone. Prefer the understand stage (overlay.ts) or style sizing; if it needs `adapt/rules/` breakpoint styles or would change how the hover looks, write it as "My ruling, not yet confirmed" or stop with options, keeping the Q1/Q2 commits.
- **Q4 → A** CLAUDE.md "The instance keeps…" line + rules summary (finisher), plus the wrapper rule from Q3B.
- **Model:** Opus 5.5 medium builder/finisher; fresh Opus 5.5 xhigh reviewer and verifier (Agent Defect Loop: frontend-ui-repair).

## Approved continuation — October 22, 2026

Justin replied **"1"** to the builder-stop choice: **Finish both fixes: allow a narrow change to how responsive layout counts the arrow wrapper's space, keeping the same strict test.**

This approves option 1 from the stopped builder: narrowly scoped responsive room/minimum accounting for the wrapper compensation. It replaces the earlier stop boundary against touching responsive planning only for this demonstrated mismatch. It does not approve a new structural wrapper representation, a change to the designed hover motion, weaker assertions, unrelated layout-policy changes, or release without independent review and verification.

Resume the existing worktree and branch, not a new copy. Saved tip: `936cfa4bc50f863d71921941ee14b2d667712dc4`. Q1/Q2 commits: `d2270e7` and `b0c50a4`. Provisional Q3B: `0263b58`. Keep the failing 375px motion oracle: the stopped candidate planned 23px copy padding vs 24.5px own padding. Diagnose and repair the accounting test-first, with only the essential responsive-planning files added to the scope. Record the exact expanded file ownership before editing, checking other-session owners first. All other gates, original proof, screenshots, no user-debug edits and documentation obligations remain.

Quota observation on approval: Claude window is 100% used, reset **due October 22, 2026 at 12:19 EDT**. Builder is queued for Opus 5.5 medium, not running. Historical quota hold only; superseded by the model override below. A due reset is not proof quota is available.

## Option-1 implementation / ownership addendum — October 22, 2026

Resume on `936cfa4` in the existing feature worktree. The unchanged archived strict browser oracle was restored byte-for-byte and freshly fails at 375px card 1, reporting the designed (3,-3) arrow as (2,-2). Original stop archive manifest: all 21 entries verified by SHA-256 before further work.

Essential expanded source ownership: **`src/core/adapt/least.ts` child-footprint aggregation only** (content, recursive minimum and reading-width aggregation). Use the existing flow-only IR `spill` metadata, matching the existing negative CSS margins; preserve the wrapper's own border-box width and content, subtract compensation only as its parent counts its footprint. No new breakpoint declarations or row/grid/phone/wrapped-minimum policy. A dedicated **`test/unit/hover-copy-room.test.ts`** owns these accounting regressions; `test/browser/hover-copy-layout.test.ts` permanently adopts the exact archived strict ±1px oracle.

Ownership checked against shared `dispatch.json`, plans/briefs, and every actual worktree's committed plus dirty diffs. Active `hero-media-row` owns `least.ts` interface/return exposure of `reading` only, disjoint from these aggregation hunks; preserve that addition when the second branch rebases. No hero files/tests are edited. `found-tiles` Tiles-B is queued/paused and owns future `keeps()`/`shapes.ts` policy, which this continuation does not touch. `found-layout` is paused and read-only on these planning files. All other inspected branches are disjoint. Neither absent local delegates nor paused status relinquishes their ownership. Any newly demonstrated overlapping hunk stops for parent coordination rather than overwrite. Finisher must retain both HANDOFF sections and repeat combined gates after integration.

Local start 09:57 EDT; initial discovery slice 5 minutes. Forecast after reproduction: 35–65 minutes to accounting fix, strict/browser/real-input proof, full check/corpus and durable review handoff, medium confidence; external font completeness may remain blocked and is not waived.

## Continuation outcome / remaining literal acceptance — October 22, 2026

Sol builder implemented option 1 in `b330f864d2ea961a1d801526c28be3eaf28de9e1`. Source change is nine lines in `adapt/least.ts`: parents subtract a flowing child's `spill.left + spill.right` in content, recursive minimum and readable-width aggregation; the child's own border-box size/minimum stays drawn. No `keeps`, row/grid decisions, breakpoint rules or designed motion changed. Fresh causal probe against `936cfa4` reproduces **content 290/293 → 290/290**, recursive minimum **342/345 → 342/342**, and at 375 own/copy padding **24.5/23 → 24.5/24.5px**. Earlier reported 294/297 numbers were from a different diagnostic, not this newly pinned fixture.

The strict archived browser file is now tracked and is **SHA-256 identical** (`928b7e5e…31ef`); fresh RED at 375 preceded the fix, GREEN after it. New room tests have intended RED/GREEN, including a separately isolated nested reading requirement. Eight focused mutations fail as intended, scratch source/test hashes restore exactly, and restored tests pass. A first browser attempt completed both assertions but hung in teardown until the 180s tool cap; it is preserved separately. Unchanged retry and full browser suite pass.

Fresh gates on b330f86: `check` exit0 (2121 unit/rule, 6 performance); `test:browser` exit0 (246/246, no skips); corpus first run exit1 with transient Yellowtail failure, preserved. Unchanged corpus retry exit1 returns exactly the original 18 Worse-than-v1 identities; full per-width findings/heights/fonts equal across all five files; four pastes/HTML unchanged, hydraulics changes two hover-copy elements only. Four full file reports are exactly equal; hydraulics only improves section6 similarity 0.9003→0.9025, with page score/structure and all other sections equal. Existing missing Garamond Condensed remains **UNVERIFIED/non-comparable**, never substituted or removed from expectations. This is a no-worse comparison, not a clean font/corpus exit or release waiver.

Real debug proof: 60 measurements (four hovered service cards at 15 widths), zero layout/containment/strict-motion failures; all requested font families load; hovered lint at 990/768/390/375/360/320 adds no findings. Maximum measured motion error is <0.001px horizontal after the already-documented 2px cover cap, 0.380px vertical. Payload diff versus initial before: 11 changed elements, all hover descendants; versus provisional Q3B: three copy-root phone-padding formulas only; no tree/class changes. Final shots at 990/390/360 are revision-labelled separately, not relabelled provisional evidence. A 60-frame burst targeted 30fps but actually achieved 15.43fps over 3.82s; it proves stable measured geometry, not 30fps visual smoothness.

**Literal acceptance blocker, not silently waived:** the brief says at360 Assembly stays on its label's line. The supplied scratch debug file, original provisional screenshot/log, and final real-font proof all have the **own** label at y25, title at y63.14 (one title line, on a second row). Corrected hover is label y24.5, title y63.64. The hover adds no row/line and its arrow stays inside; it does **not** make the pre-existing base title share the label's row. The prior ledger's “one title line” must not be interpreted as “same row as the label.” Altering the base row/floor policy is explicitly outside option1. Do not declare every named acceptance criterion complete or silently change that policy.

Options for parent/Justin: (1) confirm Q3B means matching the existing card's wrapping (the narrow implemented fix is test-complete and can receive fresh review); (2) separately authorize/investigate the base360 label/title row requirement, retaining this committed work. Until that scope/wording is resolved, builder reports **stopped, implementation verified but not fully ready-for-review** rather than inventing a pass. Fresh independent Sol reviewer/verifier and installed-Bricks paste remain unrun/owed; no merge/push/BUILD/CLAUDE edits/cleanup.

## Model override — October 22, 2026

Justin: **"cant you resume with 6.1 sol"**. Resume now on **Sol 6.1 xhigh** (`openai-codex`, `gpt-6.1-sol`). This explicit feature-specific override replaces the earlier Opus routing for the remaining builder, fresh reviewer, finisher and independent verifier. No scope or acceptance change: option 1 remains approved, strict motion oracle stays, and no merge before independent review and verification. Existing branch/tip/proof preserved.

## Builder result and pending acceptance clarification — October 22, 2026

Builder stopped at `7e13764` (implementation `b330f86`), not merged. Reports strict motion oracle unchanged and passing, 375px spacing repaired, 60 real-card comparisons passing and all browser tests passing; independent review remains unrun at this record. Durable original/final proof: `evidence/card-hover-shift/resume-sol-b330f86/`.

The brief required Assembly to share its label's row at 360px, but the builder measured the original unhovered card already stacked (label/title y25/y63.14), corrected hover matching (y24.5/y63.64). The parent must not silently mark that literal criterion satisfied. Ask whether acceptance is preserving the original unhovered arrangement without hover jumps (recommended), or expanding to base-layout repair. Fresh independent review may proceed now to validate the implementation and this distinction, but **merge/push/BUILD/cleanup remain held pending the answer and all review/verification/release gates**. A source verdict alone is not full acceptance.

## Justin's answers — release decisions (October 22, 2026)

Justin replied **"1A 2A"**:
- **1A (360px acceptance):** keep the existing unhovered phone layout. At 360px the title stays on the line below "Service 05", as it already did before this fix. Acceptance = the hovered card matches the unhovered card (no jump, arrow inside the card). The literal "same label row at 360" wording is withdrawn. No change to the base layout.
- **2A (Garamond):** release with the pre-existing missing Garamond Condensed check marked **UNVERIFIED — pre-existing on main, no stand-in font, expected set not narrowed**. This waives that one check for this release only. Every other gate stays.

Still required before merge: a clean independent verifier verdict, then a release finisher (rebase if main moved, gates, merge lock, ff-only merge, BUILD bump, push, CLAUDE.md/rules-summary per Q4A or a pending file, next free paste-check number).

## Independent review and R1 corrective handoff — October 22, 2026

Fresh Sol6.1 xhigh reviewer returned `changes_requested; release_held` at7e13764/b330f86. R1 P2 introduced: two hover wrappers can claim the same unmatched original layer, wrongly compensating genuinely added sibling content. Evidence: `evidence/card-hover-shift/reviewer-b330f86/adversarial-unit.tap` and `duplicate-v2/evidence.json`; extra88px wrapper gets margin-right:-8px at1440/990; downstream words at1440 move308→296 (only4px legitimate replacement movement;8px erroneous). Exact finding and original probes passed to FIX-ONLY FINISHER via `briefs/card-hover-shift-finisher-r1.md`. Minimal general matcher/test correction is within approved hover-layout preservation; no unrelated base policy changes.

Reviewer independently passed pinned-runtime check2121+6 and browser246, confirmed corpus same18 baseline findings, unchanged strict375 oracle,60 real input comparisons and original archives. Initial runtime teardown hangs retained as incomplete, not silently called passing. Literal360 scope question remains unanswered; Garamond missing/unverified has no feature-specific waiver. **Fix-only: no merge/push/BUILD/CLAUDE/cleanup. New fresh independent review after output correction, then independent verifier remain mandatory.**

## R1 fix-only checkpoint — October 22, 2026

Finding **valid, introduced, P2**: the original reviewer probe freshly reproduces two compensated wrappers for one original at7e13764. The probe and exact distinct Service/New offer fixture are preserved unchanged. A first-wins reservation is not sufficient: reversing the genuinely added sibling can still award it the replacement. The bounded correction rejects ambiguous ownership in either direction, before pruning: one original claimed by multiple hover wrappers, or one wrapper facing indistinguishable originals. Only proven one-to-one replacements receive compensation; ambiguous/new content keeps full drawn room. No `least.ts`, row/grid/base policy, breakpoint declarations, font policy or strict motion oracle changed. Separately active hero-media-row still owns the `least.ts` reading interface; its work was inspected, not consumed.

Test-first evidence: four competing-wrapper regressions (both orders, with/without main) fail for the intended margins before the correction; a second RED/GREEN closes original-layer ties. Six later positive controls preserve unique replacements beside new content, multiple independent replacements, and ordinary paired-layer ownership. Twelve new unit cases and three browser cases are tracked. Four isolated guard/ownership mutants plus a reviewed-source browser causal revert are killed; exact candidate hashes restore, unchanged controls pass. The archived strict375 browser file remains SHA256`928b7e5e53bc266dea367b3f3d256f5c8f84a593aa9153b165003d58359531ef`.

Fresh corrected-source proof is separate at `evidence/card-hover-shift/fix-r1/`: `check`2133+6 and full browser249/249 pass, no skips, on the same566 source/test/tool/config hashes. Corrected gates are complete for this fix-only checkpoint; independent review/verifier and release holds remain. Fresh baseline/corrected corpus both exit1 with exactly the same18 identities; all five complete file reports, pastes and full HTML are equal at29 widths. Missing Garamond Condensed remains UNVERIFIED, not green. The exact reviewer fixture now emits no compensation for either ambiguous wrapper: added content retains88px and margin-right0 at1440/990/375/360/320; downstream words at1440 move296→308 because neither the4px nor8px claim is proven. Parent content/minimum restore12px at all four tiers without changing either wrapper's own responsive minimum. Single/multiple proven replacements still compensate.

Fresh real-input proof:60 base/60 corrected measurements over15 widths; zero layout/containment/strict-motion or added-hover-lint failures; all expected real-file fonts load. Own geometry and reviewed candidate payload/full HTML remain unchanged. Literal360 Assembly title still occupies a separate row (not a same-label-row pass). Revision-labelled screenshots are in the new archive; original/provisional archives verified322+333+21 entries and remain untouched. Setup/measurement mistakes are retained and labelled in the ledger, not counted as product failures or mutation kills.

**Stopping point: ready-for-review for R1 only, release held.** Parent must run a NEW independent fresh review of the output correction, then independent verifier. Literal360 choice, missing Garamond proof, installed-Bricks/live paste and authorized release/documentation remain open. No merge, push, BUILD bump, main/copy CLAUDE edits, rebase or cleanup authorized/performed.
