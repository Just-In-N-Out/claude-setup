# Phone side padding: a landscape shrink no longer sticks on upright phones

**Approved by Justin 2026-10-21** (answers P1A P2B).

## Open questions
1. When a box is wider on upright phones than on landscape ones, which padding should it get?
   - A. Figma's own padding, stepped by space.ramp as usual ⭐ (recommended)
   - B. Keep the landscape shrink (today's behaviour)
2. Should the same fix cover tablet → landscape (the same leak one step up)?
   - A. Yes, one general rule for every breakpoint ⭐ (recommended)
   - B. Upright phones only

## Request played back
1. The three Info cards under the logo marquee on the hydraulics homepage have 17 px sides on an upright phone (390); Figma has 30 px.
2. The 17 is the shrink written for landscape phones (cards three across, narrow), and it carries down to upright phones, where the cards stack full width.
3. Fix it with general logic so every box's padding at every breakpoint follows space.ramp from Figma's values.

## Root cause (with evidence)
- `src/core/adapt/rules/space.ts:45-53` (`sideAt`): a box whose padding is under 40 (not "big") returns `undefined` when it shows as designed, meaning "as designed".
- `src/core/adapt/rules/space.ts:80-86` (the tier loop) reads `undefined` as "no change here, skip". Bricks cascades tablet_portrait → mobile_landscape → mobile_portrait, so if a wider tier wrote a smaller value, the narrower tier gets that value instead of going back to the designed one.
- For the cards: at 478 (landscape) the cards sit three across, narrower than drawn, so `sideCap(w)` (line 52, facts.ts:102, an eighth of the width, at least 16) gives 17. At 390 they stack wider than drawn, so `w = 0`, the result is 30 = base, so `undefined` comes back and nothing gets written. The 17 stays.
- Reproduced: `npm run snap -- corpus/files/hydraulics-home.json <out> 390,478`. Cards `zrbcsm`, `ekcbkb`, `xgnnxp` emit `_padding` 30, `:tablet_portrait` 27/28, `:mobile_landscape` 17, and **no `:mobile_portrait`**, so they show 17 at 390.
- Side effect: `layout.ts:129-140` (`sidesAt`) works out each tier on its own and assumes 30 at upright phones. So layout's text widths don't match what the paste shows either.

## Approach
In the tier loop, treat "as designed" as a real value: `const v = sideAt(...) ?? designed`. When it differs from what the wider tier shows, write it. A tier going back to Figma's value then gets an explicit entry. Nothing is keyed on names, texts or pixel values. It covers every side, every tier and every box.

## Tasks
1. Test first (RED) in `test/unit/adapt-space.test.ts`, with a generic fixture: a row of three alike flow boxes with 30 px padding, three across on landscape (narrower than drawn) and stacked on upright phones. Expect `mobile_portrait` padding left/right = 30. Add a tablet → landscape twin (wider at landscape than tablet; it should return to the design value).
2. Fix the loop in `space.ts` (one line plus a comment). Run `npm run check`.
3. Before/after pictures: `npm run snap -- corpus/files/hydraulics-home.json .superpowers/sdd/phone-side-padding/shots/{before,after} 390,478,768,1440 --sides`. The section to show is the Info cards row under the logo marquee, at 390 (the bug) and 478 (unchanged, 17). Copy them to `~/.hermes/plans/figma-to-bricks/shots/phone-side-padding/before-info-cards-390.png` / `after-…`.
4. `npm run corpus` before and after: diff the pastes by element id. Expect only new `:mobile_portrait`/`:mobile_landscape` padding entries, and check every one goes back to a designed value.
5. Docs & records (below).

## Tests
- Unit RED → GREEN as in Task 1. Check that it really catches the bug: put the old `space.ts` back, see the test fail, then restore.
- Golden/corpus: the new entries are intended. Update goldens only for those.

## Choices (as recommended)
- Q1 A: back to the space.ramp value on wider-again tiers.
- Q2 A: one rule for every tier.

## Risks
- Other boxes across the corpus gain an upright-phone padding (bigger than today). Text may wrap differently there, and cards that are meant to share heights (build .15) could shift. Measure each changed element at 390.
- Golden files churn. Check each diff is only the restored padding.

## Pipeline parts touched
- adapt only: `src/core/adapt/rules/space.ts` (loop), `test/unit/adapt-space.test.ts`, goldens under `test/golden` if they change. No style/emit change.

## Overlap with parallel planners
- early-line-breaks: likely touches `layout.ts` widths/`sidesAt` or type wrapping. Different file from `space.ts`, but the effects connect: once this lands, the text width at 390 matches layout's assumption. Build this first or rebase carefully.
- frame-text-links: no clash (links/emit).
- test-cleanup: splits `src/core/style/style.ts` and adds row-stretch tests. No shared files. A golden refresh could conflict, so whoever merges second re-runs the goldens.

## Docs & records
- Plan copied to `docs/plans/2026-10-21-phone-side-padding.md`.
- Ledger moved to `docs/plans/2026-10-21-phone-side-padding-ledger.md`.
- `docs/HANDOFF.md`: section for this fix, with the paste check owed: next free is **3ac** (3ab was build .15). Renumber at merge if taken.
- `BUILD` bumped by the finisher at merge (from 2026-10-20.15).
- Main `CLAUDE.md` "Start here" / "Where things stand" updated by the finisher after the merge. A new rule to add there: "a tier that goes back to the designed value writes it explicitly; Bricks cascades landscape → portrait".

## Other things found
- `space.ts:123`: the "pushed item" `margin-left: 0` is written at mobile_landscape and meant to flow on to portrait, so that one is fine. But the gap/margin steps (lines 93-94, 107-108, 130-131) compare phone to tablet only, so a landscape-only value (none today) would leak the same way. Low; latent.


## Justin's answers (2026-10-21)

1A: Figma's padding, stepped by space.ramp. **2B (differs from the recommendation): upright phones only; don't extend the fix to the tablet → landscape leak.** Justin added: "the most important thing when it comes to padding is that it looks clean on any layout".
