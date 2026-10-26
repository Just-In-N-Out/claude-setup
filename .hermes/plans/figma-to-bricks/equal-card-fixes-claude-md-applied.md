# Pending CLAUDE.md edits from the equal-card-fixes finisher (build 2026-10-21.7)

Hermes's guard denied the first `patch` to the main `CLAUDE.md`. **None of these edits went in.** Apply them in
order; the build line last. Re-read CLAUDE.md first: fonts-cleanup (build .6) may have added its own entry since.

## 1. "Where things stand": after the "Cards drawn the same height" block (after its line "  - Not yet pasted by the user (3ab).")

```
  - **Equal card fixes** (build `2026-10-21.7`, branch `worktree-equal-card-fixes`, HANDOFF "Equal card fixes (recheck
    R1–R7)"; plan and ledger `docs/plans/2026-10-21-equal-card-fixes*`; Justin's Q1A, Q2A): `bottoms.ts`
    `spaceFallsBelow` trims a box only where the freed space falls under its content (a column unless space-between;
    a row only with its items at the top and not wrapping: CSS shares a wrapping row's extra height between its
    lines, review F1); `contentSetsHeight` (hug, no min height holding it open past 1px) gates the trim and `style.ts`
    `fromTop`; `adapt/rules/rows.ts` `row.reflow` sets `flexGrow: 0` on a stacked row's item that keeps its size at the
    first stacked tier (a 64×64 photo stayed 64×116); every untested guard tested, dead guards deleted. Justin's pages
    and the corpus pastes byte-identical except design's one Button `_flexGrow:tablet_portrait 0`; no paste check owed.
    R5 (the layout plan's room for an outlined 0-padding box) and the reviewer's twoShare / reflow flex-grow items are
    layout-floors'.
```

## 2. "Start here": a new entry right after the "- **Checks:**" bullet (above the newest feature entry)

```
- **Equal card fixes (21.7, equal-card-fixes):** the recheck of 20.15's equal cards. A card's frozen bottom space is
  trimmed only where the freed space falls under its words: row cards centred or at the bottom, wrapping row cards and
  cards a min height holds open keep their drawn bottom (and their centring), so nothing moves at the design width; a
  small photo in a stretched card stays square on tablets (flex-grow 0 once stacked). Justin's pages byte-identical:
  no paste check owed. check 1376; HANDOFF "Equal card fixes (recheck R1–R7)".
```

And in the "- **Checks:**" bullet: `npm run check` 1376 pass; browser suite 136 of 139 (the same three stale
link-hrefs panel tests).

## 3. Build line (last)

`**Current build `2026-10-21.5`.**` (or `.6` if fonts-cleanup updated it) → `**Current build `2026-10-21.7`.**`
