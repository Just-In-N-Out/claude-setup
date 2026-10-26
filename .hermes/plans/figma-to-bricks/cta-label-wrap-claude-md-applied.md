# Pending CLAUDE.md edits: cta-label-wrap (build 2026-10-21.8)

The write to the main `CLAUDE.md` was denied by Hermes's guard. **None of these edits went in.** Apply in this order
(build line last).

## 1. "Where things stand": insert after the Equal card fixes entry (ends "... layout-floors'."), before "- **Fonts cleanup, stage 1** (build `2026-10-21.6`"

```
  - **CTA label wrap** (build `2026-10-21.8`, branch `worktree-cta-label-wrap`, HANDOFF "Button words that wrapped in
    narrow cards"; plan and ledger `docs/plans/2026-10-21-cta-label-wrap*`; W1A confirmed by Justin, W2A W3A):
    `adapt/least.ts` (`buttonLike`, the one-line width a layer needs per tier, `floored`: CSS holds a button only with
    a stepped min-width or no clipping / min-width-0 box around it); `layout.ts` keeps a row only while each item holds
    its buttons (alike cards stack, never one left alone; "two" stacks where a half can't hold its button; a held button
    leaves the others their 200px; alike pills wrap, never the cards stack); `rules/label.ts` `label.oneLine` writes
    `white-space: nowrap` per element (`_cssCustom`); `unpin` lets a button's floor go only to its line. Hydraulics
    "Call Us Now" one line at 768–480. **Still broken (handed to pill-clip):** the design's service pills wrap on
    laptops (1200). Rulings not yet confirmed: drawn fields still count as buttons (F7); per-element custom CSS kept
    (F9). Paste check **3ai** owed.
```

## 2. "Start here": insert before "- **Equal card fixes (21.7, equal-card-fixes):**"

```
- **CTA label wrap (21.8, cta-label-wrap):** a button's words stay on one line as Figma draws them: the layout plan
  keeps items side by side only while each holds its buttons (alike cards stack rather than squeeze a pill), a kept
  row gives a button its one-line width where CSS holds it, `white-space: nowrap` on its words. Hydraulics Info
  cards' "Call Us Now" one line at 768–480. Laptop pills (design at 1200) still wrap: pill-clip batch. Paste check
  **3ai** owed. HANDOFF "Button words that wrapped in narrow cards".
```

## 3. "Start here" checks line (line 8): replace "`npm run check` 1376 pass; browser suite (`npm run test:browser`) 136 of 139." with

```
`npm run check` 1402 pass; browser suite (`npm run test:browser`) 137 of 140.
```

## 4. Build line (last): `**Current build `2026-10-21.7`.**` → `**Current build `2026-10-21.8`.**`
