# found-list-head — list column-titles (head) not recognised + D2 test fidelity (PLAN, not implemented)

Planner: Opus 5.5 medium, 2026-10-22. Base: main `b4ed333` (BUILD 2026-10-22.5). Planning only: no worktree, code, test, ledger or CLAUDE.md edits.
Evidence (durable, read-only probe): `~/.hermes/plans/figma-to-bricks/evidence/found-list-head/probe-head.ts` + `probe-head.out.txt` (`node probe-head.ts [repo]`, Node 22, <1 s, writes nothing, no Chrome/corpus).
Sizing: builder/finisher **Opus 5.5 medium**; fresh reviewer and Agent Defect Loop verifier **Opus xhigh**.

## Dispatcher decision status — October22
Safe recommendations Q1A/Q3A/Q4A accepted under named bug-planning authorization. Q2B changes list layout, so remains awaiting Justin; no builder before that answer and Tiles-B/source ownership clearance. D2 test edit only after Tiles-B, exact narrow grant needed then. Newly added found-list-actions planner investigates old CSV action labels and may overlap lists/list-links/fixtures: reconcile both plans before any concurrent writers.

## Justin's answer — October22
**Q2B approved.** Justin swipe-replied to the list-head alignment question with "B". Head reserves trailing actions' widths plus tier gaps so titles align above their data columns, blank over actions. This resolves the new-policy hold for this scope only. Q1A/Q3A/Q4A remain accepted. Builder queued on Tiles-B integration and list-actions exact source/test reconciliation, NOT waiting for another go. Model Opus5.5 medium, fresh review+verifier Opus xhigh. No changes to W-B/ALONE/Garamond/CLAUDE restrictions.

## Playback
1. Round 3 finding 223 (found-else.md:228) says a `badge:true` list's column-titles row is not recognised as the head.
2. found-tiles corrected it: the literal `listPage({badge:true})` head **is** recognised. The real triggers are records with untitled trailing action buttons, and fixed-width badges.
3. The D2 test in `adapt-fixed-tiles-review.test.ts:225–249` relabels records as `head` because that fixture's real head isn't recognised. So it never tests a real head.
4. Justin asked for three more agents on the grouped bugs. That authorises this plan. It does not authorise a change to list design or any extra scope.

## Questions (⭐ = recommended; Q2 is HELD for Justin, not for the dispatcher's grant)
**Q1. Untitled trailing action columns: should the head be recognised?**
- A ⭐ Yes. `headOf` accepts a row with fewer columns than the record only when every extra record column is **trailing** and is a row action. "Row action" uses the same predicate as `list-links.ts actionsIn/rowActions` (a Button or button-shaped box whose words are the same on every row; never a data cell). Every other check stays exact.
- B No. Keep the exact column count, and close 223 as "by design".

**Q2. HELD (new layout policy).** Once recognised, should the head reserve the records' action width?
- Why it matters: in `adapt/rules/list.ts share()`, records' buttons keep their size (`flexShrink 0`) while their data columns shrink. A head with no action columns starts shrinking only later, so below the design width its titles drift right of their columns, by up to the action width.
- A Recognise only (Q1) and accept the drift as a known residual. Titles still hide on phones and stop wrapping on tablets.
- B ⭐ (Justin must answer) The head reserves the trailing actions' widths plus gaps at every tier, so each title sits over its column, as `list-layout.test.ts` already pins for the other lists. This is a new list-layout rule and it must follow the tier gap.
- C Defer the whole feature.
- Without an answer to Q2, the builder does not start (see Risks).

**Q3. Fixed-width badges.**
- A ⭐ Head-scoped only. A new `badgeBox` predicate in `understand/lists.ts`: a painted or outlined box holding one line of words that does **not** stand as tall as the row's cells, with radius > 0 or shorter than the row (a painted table cell fills its column at full height and stays a cell). In `headOf`, a column pair where both are `pilled` or `badgeBox`:
  - (a) is width-exempt in `lined`;
  - (b) has its words excluded from `looks`.
  The global `pilled` (markColumns dots), `list.ts keepsSize` and the records' plan stay unchanged, so the D1 pin at `adapt-fixed-tiles-review.test.ts:207–223` still holds.
- B Widen the global `pilled` to badgeBox. This also changes phone-card dots and is broader. Not recommended.
- C Defer the fixed-badge half.

**Q4. D2 test fidelity (file owned by queued Tiles-B).**
- A ⭐ Prove the real recognised head in a **new list-owned file** now. Edit D2 (`:225–249` only: drop the relabel, use the real head, keep the head-vs-row equality) only **after Tiles-B merges**, under a narrow grant recorded in the plan.
- B Leave D2 as it is and add a comment.
- C Ask Tiles-B to do the D2 edit.

Held, unchanged: W-B, ALONE, grid/widest-item least. Garamond stays UNVERIFIED (no stand-in, no narrowed expected set, no historical waiver). No CLAUDE.md write or retry by any agent. No live-site writes.

## Root cause (file:line, main b4ed333)
`src/core/understand/lists.ts headOf` (:195–211), called once from `planLists` :252. The head is consumed by:
- `adapt/rules/list.ts:141–150` (share at every tier, `display:none` on phones);
- `adapt/kinds.ts:51 listLine` → `shapes.ts:115` keep/stack, `shapes.ts:100` no tile width, `sides.ts:93`;
- `style/lists.ts:16`;
- `listButtons` skip-list :258.

1. **Trailing actions.** `:204` `its.length !== cols.length` rejects any head without titles over the records' trailing Buttons. `columnsOf` (:165) counts Buttons as columns; it drops only thin rules.
2. **Fixed badges, two independent failures.**
   - `:168 pilled` needs `sizing.w === "hug"`. A fixed badge's words (12px gold) therefore enter `looks` (:207) beside the titles (11px grey): two looks, so it is rejected.
   - `:205 lined`: when head and record badges are fixed at different widths, neither hugs and the width differs by more than EDGE, so it is rejected.
   - `badge+fixSame80` (all badges 80 wide) still fails: the `looks` failure alone is enough.

Probe (`probe-head.out.txt`), head recognised? head phone-hidden?
| variant | head | phone hidden | head CSS when unrecognised |
|---|---|---|---|
| default, badge, cellRules | yes | none | — |
| actions1, actions2, thumb+actions1, hug+actions1 | **no** | no | generic `_flexWrap:tablet_portrait` + rowGap (titles wrap) |
| badge+actions2, badge+fixHug, badge+fixSame80, badge+fixHug+actions2 | **no** | no | same |
| actions1 + head spacer frame over actions (positive control) | yes | none | — |
| actions1 + "ACTIONS" title in title look (positive control) | yes | none | — |

**Symptom when unrecognised:**
- On phones the titles row stays visible above the compact cards.
- On tablets it gets generic row reflow and wraps.
- `listLine` is false for it, so `shapes`/`sides`/`unpin` treat it as an ordinary row. A fixed badge in it can get a tile hold.

**Decision versus bug:**
- The exact-count rule (comment :192–194: "as many, starting where the record's start") is a deliberate heuristic. It was never decided for untitled action columns, and the designer controls (spacer, title) prove the intent: titles over records, hidden on phones. Extending recognition to trailing actions (Q1A) and to head-scoped badges (Q3A) is a bounded recognition bug.
- Reserving the action width (Q2B) is new layout policy and is held.

**Generic repro:** any list (pills or search+count) whose records end in one or more identical action Buttons and whose titles row has no title over them; or whose badge column is FIXED width. No names, ids, texts or pixels are keyed.

## Ownership / overlaps (exact)
**List-head allowlist (no named live builder owns any of these on main or in branch diffs):**
- Source:
  - `src/core/understand/lists.ts` (headOf, new badgeBox);
  - `src/core/understand/list-links.ts` (export the existing action predicate only);
  - `src/core/adapt/rules/list.ts` (Q2B only).
- Tests:
  - `test/unit/adapt-list.test.ts` (append to the heads test :30–37);
  - `test/unit/understand-lists.test.ts` (append);
  - new `test/unit/list-head.test.ts`;
  - `test/browser/list-layout.test.ts` (append);
  - `test/fixtures/lists.ts` (additive opts only: `headSpacer`, `fixedBadges`; defaults byte-identical).

**Collisions:**
- **Tiles-B (queued):** owns `adapt-fixed-tiles-review.test.ts` → D2 waits (Q4A). It also owns `kinds.ts`/`shapes.ts`/`unpin.ts`/`least.ts`: not edited here, but this changes their *input*, because more rows become `listLine`. Fixed badges in those heads stop getting tile holds, so Tiles-B's fixed-badge-in-list expectations may move. Sequence: list-head after Tiles-B, or rebase Tiles-B onto it. The dispatcher picks one; recommended: **list-head after Tiles-B merges** (Tiles-B is already queued, and D2 needs it).
- **found-layout:** `place.ts`/`nudge.ts`/turned labels. No file overlap. Lists override `space.ramp`/`row.reflow`, but Q2B must use the tier gap layout writes. Rebase-check only.
- **found-gates:** branch edits `shared/breakpoints.ts` + `test/browser/geometry.test.ts`. No overlap. Use its geometry helper only after it merges; otherwise local measures in `list-layout.test.ts`.
- **found-contacts:** normalise contacts/page-words/page-links. None.
- **Tiles-A:** past-edge/scene/compose/settings. None.

**Existing tests that pin the old outcome:**
- None asserts "no head with actions".
- `adapt-list.test.ts:31–37` pins heads for 6 variants, all of which must stay identical.
- The D1 pin `adapt-fixed-tiles-review.test.ts:207–223` (records' fixed badges) must stay green unchanged.
- D2 (:225–249) is the fidelity gap.

## Tasks (test-first; only after Q1–Q4 are answered)
0. **Admission.**
   - figma-to-bricks Steps 1/2 (worktree `found-list-head`).
   - Re-check disk (6.4 GiB free measured; no speculative deletion).
   - `npm run check`.
   - Baseline corpus + snap in a heavy slot coordinated with gates/tiles: save report-v2.json, pastes, HTML, loaded/expected fonts. Garamond is labelled non-comparable.
   - Copy the probe into `.superpowers/sdd/found-list-head/`.
1. **Fixture (additive).** `listPage({ fixedBadges })` sets badges FIXED at drawn width. Defaults are byte-identical: assert that the `listPage()` and `listPage({badge:true})` snapshots deep-equal main's.
2. **Q1A RED → GREEN.** `list-head.test.ts`:
   - `actions:["Quote"]`, `["Quote","Sheet"]`, thumb+actions and hug+actions all give `head:Head`.
   - Negatives that stay null:
     - a head with an extra *leading* missing column;
     - an extra trailing column that is a data cell (words differ per row) or a non-action box;
     - a "Stats" figures row (adapt-list :34);
     - a highlighted first record.
   - GREEN in `headOf`: allow `its.length < cols.length` only when `cols.slice(its.length)` are all paths in `rowActions(rows)` (top-level index). The x and looks checks are unchanged.
   - Mutant: restore the exact count → RED.
3. **Q3A RED → GREEN.**
   - `fixedBadges`, `fixedBadges+actions` and all-same-width fixed badges give `head:Head`.
   - Negatives: cellRules (painted full-height cells) keeps its head and its 3 dots; a head whose fixed cell holds a second words look that is not a badge stays null.
   - GREEN: the `badgeBox` predicate, used in `headOf` only.
   - Mutants: drop the `lined` exemption → RED; drop the `looks` exclusion → RED.
4. **Q2B (only if Justin answers B).**
   - RED in Chrome, `list-layout.test.ts`: actions list and actions+fixed-badge list. At 1300/1200/1100/1024/992/991/800/768/600/480/479 every title's x equals its column's x (±1). At 390/375/360/320 `Head` is hidden, cards are compact and nothing scrolls sideways.
   - GREEN: in `share()` for a head, a trailing reserve equal to the records' trailing action widths plus their gaps at each tier (exact at the design width, following the tier gap).
   - Under Q2A instead: assert titles one line, hidden on phones, and record the measured drift as a residual.
5. **Controls / no-worse.**
   - `adapt-list.test.ts:30–41` is unchanged and green.
   - D1 is green.
   - The default list's payloads are byte-identical to main (replay old vs new src side by side).
   - Corpus: `cmp` pastes, then diff lint, the Worse-than-v1 list, report fields and font sets. List every changed element id. Expected: only lists with trailing actions or fixed badges change.
   - Layout widths: 1300/1200/1100/1024/992 + 991–320 incl. 375/360/320. For each changed row, compare its last item's right edge with main.
6. **D2 fidelity (after Tiles-B merges; narrow grant, Q4A).**
   - Replace the relabel with the real recognised head of `listPage({badge:true, actions, fixed badges})`. Keep the head-vs-row width equality.
   - Add `assert.equal(head.list.part, "head")` as a precondition.
   - Mutant: break `headOf` → D2 fails on its precondition, not silently.

## Risks / compatibility
- More heads become `listLine`, which changes `shapes`/`sides`/tile holds for those rows. That is the intent, but Tiles-B fixtures may move: sequence after Tiles-B.
- A false positive head: guarded by the action predicate, by trailing-only columns and by the unchanged looks/x checks. The negatives in Task 2 pin this.
- The Q2B reserve must follow the tier gap: a px reserve computed from the drawn gap is exact only at the design width. Measure at the laptop widths.
- Hiding titles on phones is a visible change on pasted pages (paste check owed).
- Corpus files may contain no such list. Then the proof is fixture-only; say so.

## Gates
`npm run check`, `npm run test:browser` (rerun busy-Chrome flakes before calling one a regression), `npm run corpus` no-worse (exit code is not the gate), snap before/after into `shots/found-list-head/`, and the debug replay at every width. The heavy Chrome/corpus slot is coordinated with gates/tiles; never run it concurrently.

## Skills
- Every role: figma-to-bricks (+ rules-summary), engineering-best-practices.
- Planner: implementation-planning, systematic-debugging, qa-testing-local-cloud.
- Builder: test-driven-development, mutation-testing-discipline, frontend-ui-repair (layout specialist; carries **Mandatory Validation and Agent Defect Loop**); systematic-debugging on a surprise.
- Reviewer (Opus xhigh): requesting-code-review + code-review-practice.
- Finisher: receiving-code-review, git-commit-rules, TDD.
- Because frontend-ui-repair is loaded, the finisher stops at ready-for-verify, and a fresh Opus xhigh verifier must come back clean before the merge.

## Docs & records (finisher)
- Plan copied to `docs/plans/2026-10-22-found-list-head.md`; ledger to `docs/plans/found-list-head-ledger.md`.
- `docs/HANDOFF.md` updated with the owed paste check (next free number at the merge): a list with row actions, where titles are over their columns on tablets and hidden on phones.
- BUILD bumped by the finisher only, at release.
- CLAUDE.md "Start here"/"Where things stand" (and a new list-head rule under Q2B) go only to `found-list-head-claude-md-pending.md`, applied after the older pending files in build order. No write attempt or retry.
- Canonical found-else: close 223 (reworded: "head not recognised with untitled trailing actions or fixed-width badges") only after the merge, citing the build. Note the D2 fidelity fix under its own line.
- No shared queue/ledger edits by this planner; dispositions are returned to the dispatcher.

## Found else (not absorbed)
- (low) `adapt/rules/list.ts keepsSize` (:22) treats a fixed-width badge in a record as a shrinking column (`sizing.w` hug only), so its words may squeeze on tablets. D1 pins the current plan; this needs a separate decision.
- (info) `markColumns` dots use the same hug-only `pilled`. With fixed badges past the first "more" column, a dot could precede a badge's words. Not reproduced in the fixture (the badge is the first "more").
