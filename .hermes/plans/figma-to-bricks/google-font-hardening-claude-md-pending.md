# Google font hardening — pending main CLAUDE.md edits

Merged and pushed **build 2026-10-21.13**, commit `6d65aeab775752559706040efc648df6953138b0`. Main and origin/main verified equal. The first protected CLAUDE.md patch was denied; **none of these edits landed**. Do not retry from the finisher or route around the guard. Main chat: re-read current anchors, preserve all parallel edits, apply the following in order, current-build line last; then rename this file `google-font-hardening-claude-md-applied.md`. Earlier .9–.12 updates were already present when read and were not overwritten.

## 1. Rule clarification (Working in this repo)

Before this exact anchor:

```text
- **Font notes name the weights supplied, never promise the font the browser picks.** Keep Figma's family and
```

Insert:

```text
- **Google supplied metadata validates supported family/style syntax before unquoting and normalization.**
  Malformed descriptors cannot certify coverage; valid multiword names containing keyword words, Unicode/opposite
  quotes and supported signed/fractional oblique angles remain covered. Accepted raw CSS and request policy stay
  unchanged. Returned Google weight-range emission remains a separate deferred issue.
```

## 2. Where things stand

Before the exact entry beginning:

```text
- **Fonts cleanup, stage 1** (build `2026-10-21.6`, branch `worktree-fonts-cleanup`, HANDOFF "Fonts cleanup, stage 1";
```

Insert:

```text
- **Google font descriptor hardening** (build `2026-10-21.13`, branch `worktree-google-font-hardening`, HANDOFF
  "Google font descriptor hardening"; plan and ledger `docs/plans/2026-10-21-google-font-hardening*`):
  - `ui/fonts.ts` validates supported literal family/style descriptors before normalization and supplied coverage.
    Mismatched/missing family quotes and `oblique nonsense` cannot certify a face. Unicode/opposite quotes and
    signed/fractional one/two oblique endpoints in deg/grad/rad/turn remain supported. Unsupported syntax stays
    unconfirmed, never rewritten; valid companion faces/subsets remain supplied.
  - Fresh Sol review R1 (medium, introduced) fixed test-first: valid unquoted Noto Serif / Example math retain
    coverage. Six keyword-containing multiword controls failed before the fix and pass after; standalone/leading
    reserved-name and malformed-delimiter checks remain. Focused font suites 157/157; independent reviewer 3/3.
  - Latest-main .12 gates: check 1577 unit/rule + 6 serial performance; browser 154/154, no skips. One initial
    strip-scroll flake passed unchanged in isolation and on the complete rerun; original logs retained.
    Exact-.12 archive versus branch: all five pastes/HTML byte-identical, complete per-file reports equal at all
    29 widths (only top-level createdAt differs), same 17 existing v1 differences. User-debug/Hydraulics core
    payloads and requested 9/11 face lists unchanged; local CSS/request proofs pass, no site writes.
  - Only the malformed-descriptor found item is closed. Returned Google weight-range emission remains OPEN /
    DEFERRED in `~/.hermes/plans/figma-to-bricks/google-font-hardening.md`; loader duplication remains separate.
    Conversion/panel check 3am; no paste check owed. Reload/Convert, supported faces stay confirmed, malformed
    responses missing/unknown, exact usable site coverage wins. Existing 3af/3ah/3aj stay separate.
```

## 3. Start here checks and feature entry

Replace this exact checks block:

```text
- **Checks:** `npm run check` 1479/1479 unit/rule plus 6/6 serial performance; browser (`npm run test:browser`)
  154/154, no skips/failures. The three stale panel upload-name expectations are fixed; all newer B2 tests remain.
  Five .11/main versus .12 pastes and full HTML byte-identical; full findings/heights/fonts equal at 29 widths.
  Separately labelled matched-policy recapture gives exactly equal complete reports, same 17 existing v1
  differences. Legacy moving-animation scores remain non-comparable; budgets/tolerances unchanged.
```

With:

```text
- **Checks:** `npm run check` 1577/1577 unit/rule plus 6/6 serial performance; browser (`npm run test:browser`)
  154/154, no skips. One initial strip-scroll flake passed unchanged in isolation and the complete rerun; logs kept.
  Exact .12/main versus .13: five full pastes/HTML byte-identical; complete per-file reports equal at 29 widths
  (full findings/heights/fonts/scores; only report createdAt differs), same 17 existing v1 differences. Budgets,
  tolerances and capture policy unchanged. Earlier moving-animation evidence keeps its existing qualifications.
- **Google font hardening (21.13, google-font-hardening):** malformed family/style descriptors cannot falsely
  confirm coverage. Valid unquoted multiword names (Noto Serif, Example math), Unicode/opposite quotes and supported
  oblique angles remain confirmed; fresh review R1 fixed test-first. Accepted CSS, requested weights and GET counts
  unchanged; usable site coverage still wins. Range emission explicitly deferred; double loading separate.
  HANDOFF "Google font descriptor hardening", conversion/panel check 3am; **no paste check owed**.
```

## 4. Current-build line LAST

Only if it still reads .12 (never lower a newer build), replace:

```text
**Current build `2026-10-21.12`.**
```

With:

```text
**Current build `2026-10-21.13`.**
```

## Other records already complete

- BUILD bumped and dist rebuilt; main pushed and remote readback verified.
- In-repo HANDOFF, plan, ledger committed; R1 red/green and rebased gates archived under `evidence/google-font-hardening/finisher/`.
- found-else.md closes only the malformed descriptor item with .13; range line remains open/deferred with plan pointer.
- Skill records the keyword-containing family positive-control lesson. Rules summary clarification is independent of this protected write.
