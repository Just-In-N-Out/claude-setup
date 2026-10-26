# Pending CLAUDE.md edits — fonts-cleanup, build 2026-10-21.6

The first patch was blocked by Hermes's protected-instruction guard. **None of this finisher's CLAUDE.md edits landed.** Do not retry via another tool. Main chat has already applied frame-text-links' pending file; the last read showed build 2026-10-21.5 with its entries present. Apply only the edits below after re-reading the target sections. Keep the build line last.

## 1. Start here — checks and new entry

Replace `npm run check` 1330 pass with 1358 pass and browser 131 of 134 with 133 of 136, retaining the existing three-stale-panel-test explanation.

Insert before the Words linked to another frame (21.5) entry:

- **Fonts cleanup, stage 1 (21.6, fonts-cleanup):** a usable same-family/slant variable face already on the site covers a dropped static weight in its range, so it says "Already on your site" without another upload. A known missing face's note names the weights this paste actually supplies, or explicitly says no replacement is confirmed; it does not choose a replacement or promise the physical font. Fresh pastes already keep Figma's text weights through their editable typography classes; regression tests now protect this against body 800. Existing header template still needs its separate 600 setting by hand (3af). Item 1 (duplicate loading) deferred: needs live paste proof; F1 (HTTP-200 partial response classification) still open. R1 test-only fixture correction verified red/green; check 1358, browser 133/136 (same three failures reproduced on main), corpus 5/5 pastes byte-identical, lint and same 17 worse-than-v1 items unchanged. HANDOFF "Fonts cleanup, stage 1"; paste check 3ah owed.

## 2. Where things stand — new entry before Words linked to another frame

- **Fonts cleanup, stage 1** (build `2026-10-21.6`, branch `worktree-fonts-cleanup`, HANDOFF "Fonts cleanup, stage 1"; plan and ledger `docs/plans/2026-10-21-fonts-cleanup*`):
  - **Scope:** Justin's 1B/2A, then "As for the font stuff tell it to move on": items 2/3/4 only; item 1 deferred, needs live paste proof. Loader stays; no harness or stage-2 work.
  - **Code:** `ui/font-coverage.ts` shares usable-source/weight-range/slant coverage; `site-fonts.ts` `addFonts` skips covered drops; `font-sources.ts` uses the same coverage for the rows/CSS, and names only alternatives actually supplied by selected site CSS plus confirmed Google descriptors. `fonts.ts` returns deduplicated family/weight/slant/source metadata; `run.ts` carries it to the notes. No `src/core` production change, no added availability probes, no family/weight substitution, no site writes or deletion of existing fonts.
  - **Coverage:** static within a usable same-family/slant variable range (inclusive) skips; dropped variable requires one existing usable variable covering the whole range. Isolated statics or partial overlap never cover a variable. Same-drop additions still cover later files; one-at-a-time order stays. POST 1→0, added 1→0, already 0→1 for static 500 under normal 100–900. Existing CSS already preferred an exact static; duplicate upload, not duplicate shared-weight CSS, was repaired.
  - **Notes:** missing 800 can say "This paste supplies 400 and 700 in that style; the browser chooses a substitute. Your site's font settings may add other weights." Unknown says "No replacement weight is confirmed; the browser may use another font." Upload guidance remains, exact site coverage suppresses warnings, Google off remains explicitly not checked (my ruling, not yet confirmed).
  - **Weights protected:** own-or-imported-class Figma weights win over body 800; generic tests cover 400/600/700, local overrides, Button, text link, mixed runs, drawn-phone class; Chrome 360/700/960/1360. Repairs 106 and Hydraulics 202 text-like elements, zero without effective own/class weight. Saved user-file replay pastes/warnings byte-identical. Existing header template still needs its 600 setting by hand; Theme Style untouched.
  - **Review/gates:** fresh reviewer R1 medium fixed test first, test-only (`5431331`): normal combined Google missing-weight response is HTTP 200 omitting 800; forced combined HTTP 400 is explicitly failure injection. Single missing 800 proves site-supplied-700 note. Focused 8/8; check 1358; browser 133/136, exactly three stale panel failures also reproduced on main (25/28); corpus 5/5 pastes byte-identical, full per-width lint and same 17 worse-than-v1 identities unchanged.
  - **Still open:** F1, HTTP-200 partial Google responses misclassified as complete; duplicate-loading item 1; stale panel tests (test-cleanup).
  - Not yet pasted by the user (3ah).

## 3. Where things stand — site-fonts old follow-up

Replace:

```
  - **Follow-ups:** `addFonts` counts "already there" on an exact weight only (a variable site face gets a static
    uploaded beside it); ~~Saira Condensed Thin/ExtraLight went up as 250/275~~ (fixed in 21.3).
```

with:

```
  - **Follow-ups resolved:** covered static uploads are skipped by shared usable-source/family/slant/range coverage
    in 21.6 (fonts-cleanup); Saira Condensed Thin/ExtraLight 250/275 was fixed in 21.3.
```

## 4. Working in this repo — font rules

Insert before `Font weights in a paste are single whole hundreds`:

- **Effective text weight includes the imported typography class.** Resolve the element plus `_cssGlobalClasses` before claiming a Figma weight is missing; do not duplicate working class typography onto every element.
- **A usable same-family/slant variable face covers static uploads inside its range.** A dropped variable needs one existing usable variable spanning its entire range; isolated statics and partial overlaps do not suffice.
- **Font notes name supplied weights, never promise the selected physical font.** Keep requested Figma family/weight; use explicit unknown wording without a confirmed same-style source. A Google stand-in models real HTTP-200 partial responses; forced HTTP-400 retry scenarios must say failure injection. This does not close F1.

## 5. Build line — last

Replace `**Current build `2026-10-21.5`.**` with `**Current build `2026-10-21.6`.**`.
