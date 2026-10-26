# Test cleanup — pending main CLAUDE.md edits

Merged and pushed **2026-10-21.12**, commit `9334c3711bffb72a9ce7d8f135da7691267114fe`.
Main, origin/main and remote refs/heads/main were read back at that commit.

**Applied: none.** The first protected-file patch (Where things stand entry below) was denied. No retry, alternate-path write or bypass was attempted. Main CLAUDE.md still says .8. This is pending documentation, not an unmerged feature.

Do not overwrite or mark applied `google-partial-fonts-claude-md-pending.md` (.9), `text-breaks-claude-md-pending.md` (.10), or `link-upload-fixes-claude-md-pending.md` (.11). A permitted parent session should re-read anchors, apply those content edits in order, then these .12 edits; the final BUILD/check block is last. Preserve every newer entry/build. Only rename this file `test-cleanup-claude-md-applied.md` after actual application.

## 1. Where things stand — denied first patch, none landed

Immediately before the unique `- **Paste checks:**` line insert:

```markdown
- **Test cleanup** (build `2026-10-21.12`, HANDOFF "Test cleanup"; plan/ledger `docs/plans/2026-10-21-test-cleanup*`):
  - Correct safe upload-name panel expectations; list/marquee/live-map guard tests independently mutation-proven.
    Picture/shape styling extracted to `style/picture.ts` with live `wide` access; no conversion output change.
  - Source-backed shared WordPress Font Library collection fixtures; snap pairs top-to-bottom wrapped sections and
    uses configured corpus font stand-ins. Capture tools alone pause finite animations at end/infinite at zero;
    interactive tests stay live. Original moving scores are non-comparable; keep full saved HTML and matched fonts.
  - Serial performance remains in `check`, budgets 3000ms/800ms unchanged; regression tolerances .005/.02 unchanged.
    Rebased onto .11: 1479 unit/rule + 6 performance, 154/154 browser, zero skips/failures. All B2 tests preserved.
    Five pastes/full HTML identical; full findings/heights/fonts at 29 widths equal; matched-policy complete reports
    exactly equal, same 17 known v1 differences. Evidence `~/.hermes/plans/figma-to-bricks/evidence/test-cleanup/finisher/`.
  - No paste check or user action owed. F7 drawn-input ruling, F9 whitespace classes and external-stylesheet
    fontStatus limitation remain open; only the timing sentence closes, never the adjacent size.unpin defect.
```

## 2. Start here — new feature

Immediately before `- **CTA label wrap (21.8, cta-label-wrap):**`, retaining .9/.10/.11 entries, insert:

```markdown
- **Test cleanup (21.12, test-cleanup):** the three stale upload-name panel tests are green; list/marquee/map
  guards have independent mutation tests; picture/shape styling is split out without changing pastes. Snap pairs
  wrapped sections top-to-bottom with corpus fonts. Tool captures use finite-end/infinite-zero; interactive tests
  remain live. WordPress Font Library stand-ins are source-backed; timing gates are serial, not relaxed. Fresh
  review passed; integrated check 1479 unit/rule + 6 performance, browser 154/154, no skips, all B2 tests retained.
  Five pastes/HTML unchanged from .11; complete matched-font/motion reports equal at 29 widths, same 17 existing
  v1 differences. F7/F9/fontStatus remain open. HANDOFF "Test cleanup"; **no paste check or user action owed**.
```

## 3. Working in this repo — gates and capture rules

Replace the unique finish step:

```markdown
    2. Run `npm run check` and `npm run corpus` again on the rebased branch: two features that pass alone can
       break together.
```

with:

```markdown
    2. Run `npm run check`, `npm run test:browser` and `npm run corpus` again on the rebased branch: two features
       that pass alone can break together. Browser is separate from check; preserve newer parallel tests, no skips.
       Compare full saved pastes/HTML, findings, heights and loaded-family sets, not just counts or corpus exit 1.
```

Replace the unique checks paragraph:

```markdown
- **Checks:** `npm run check` runs typecheck, build and the unit and rule tests. Tests use `node --test` on `.ts` files
  directly (Node 22 type stripping), so use only erasable TypeScript syntax: no `enum`, no `namespace`, no parameter
  properties.
```

with:

```markdown
- **Checks:** `npm run check` runs typecheck, build, unit/rule correctness, then serial `test:performance` with the
  unchanged five corpus conversion limits (3000ms) and long-page inference limit (800ms). `test:browser` is a
  separate required merge gate. Tests use `node --test` on `.ts` directly; only erasable TypeScript syntax.
- **Comparable tool captures:** finite animations pause at their end, infinite loops at zero, before geometry/lint/
  tiles; interactive tests stay live. Retain original reports/pastes/full HTML. Legacy animated scores need a
  separately labelled matched-policy recapture of byte-identical complete HTML; loaded font families must match
  (failed:[] alone can miss a missing external stylesheet). Regression tolerances stay .005 colour/structure and
  .02 height ratio; ±.002 is not universal noise. See `docs/testing-tools.md` for audited fixture/capture scope.
```

## 4. Close stale feature follow-up references only

After applying .9, the stage-1 fonts status is expected to read:

```markdown
  - **F1 fixed in 21.9:** partial Google answers count only returned descriptor coverage. **Still open:** item 1;
    stale panel tests (test-cleanup).
```

Replace with:

```markdown
  - **F1 fixed in 21.9:** partial Google answers count only returned descriptor coverage. **Still open:** item 1.
    Stale panel expectations fixed in 21.12 (test-cleanup); all newer B2 cancellation/payload tests preserved.
```

Replace:

```markdown
  - **Follow-ups:** `style.ts` 356 lines (test-cleanup's split).
```

with:

```markdown
  - **Follow-up resolved in 21.12:** picture/shape extracted to `style/picture.ts`; `style.ts` 286 lines,
    extracted module 93, live `wide` access retained; corpus paste/full HTML unchanged.
```

## 5. BUILD/check block — apply last

After previous pending content edits, re-read and replace the then-current Start here BUILD/check block with:

```markdown
**Current build `2026-10-21.12`.**
- **Checks:** `npm run check` 1479/1479 unit/rule plus 6/6 serial performance; browser (`npm run test:browser`)
  154/154, no skips/failures. The three stale panel upload-name expectations are fixed; all newer B2 tests remain.
  Five .11/main versus .12 pastes and full HTML byte-identical; full findings/heights/fonts equal at 29 widths.
  Separately labelled matched-policy recapture gives exactly equal complete reports, same 17 existing v1
  differences. Legacy moving-animation scores remain non-comparable; budgets/tolerances unchanged.
```

Do not lower a newer actual build or overwrite newer verified gate counts. The current on-disk old block at this finisher's last read was .8 / check 1402 / browser 137 of 140; prior pending files change that block, so offsets are not stable.

## Verified release / records

- Build output: dist/code.js 559502 bytes, contains .12; dist/ui.html 157556 bytes, rebuilt (does not embed BUILD).
- User debug JSON preserved modified/unstaged, SHA256 `79bc7494d213e8a8ea35a50d28ba574d2fa2ceded82d76c506f0f4406b33acd9`.
- Nine exact found-item rows/sentence closed for .12. F7/F9/fontStatus, separate size.unpin and unrelated sibling work remain open. Rules summary updated with capture/serial-performance rules, no status lines.
- No live-site writes, paste check or Justin plugin/paste action owed for this tests/tooling-only feature.
