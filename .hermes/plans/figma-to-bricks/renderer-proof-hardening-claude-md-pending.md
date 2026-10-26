# renderer-proof-hardening — exact main CLAUDE.md edits pending

Target: `/Users/justin/Documents/FigmaToBricksV2/CLAUDE.md`
Release: **2026-10-22.3**, pushed commit **6a7b74412c7461db11bbff0800c5a079c4c205dd**. No new paste/conversion check or user action.

**Apply after the older ones, in build order**, through `font-reporting-tests-claude-md-pending.md` (2026-10-22.2). Main CLAUDE's build line was re-read after push and remains 2026-10-21.12. **None of these edits landed or was attempted.** Earlier protected-write denials and the older unapplied sequence are respected; no retry, terminal/execute_code bypass or main-chat alternative route. Keep this file pending until all sections actually land via a permitted path; set the build line last.

## Edit 1 — Start here: insert after the 22.2 Google font reporting bullet

```text
- **Renderer proof hardening (22.3):** the local renderer copies native rel literally instead of inventing noopener,
  and puts copied linked-image tabindex on its actual anchor. Showcase clipping tests measure outside paint/hits,
  not only frame dimensions. Font diagnostics keep observed loaded/failed separate from expected/missing; Unicode
  caseless comparisons preserve display spelling, and the real corpus CLI rejects incomplete current-only captures
  even with an empty/absent baseline. Fresh review R1/R2 fixed test-first; original repros pass, mutations fail.
  Rebased on main51bbd2e (.2): check2079/2079 +6 performance; browser240/240, no skips/failures. Five payloads and
  complete HTML byte-identical; full legacy reports/loaded-family sets equal at29 widths. Corpus still exit1:
  same17 historic v1 items plus one truthful Garamond non-comparability diagnostic. Garamond Condensed:
  UNVERIFIED — pre-existing on main (Times-Roman shown on both main and branch); genuine licensed font not
  available; no stand-in substituted, expected font set NOT narrowed. Justin's M1A waives ONLY this release hold,
  not font completeness/other gates. W-B remains deferred. No new paste/conversion check or user action.
  Existing3ar/3as, busy-host listing flake and global narrow-width rollout stay open; renderer tests are not
  installed-Bricks compatibility proof. HANDOFF "Renderer proof hardening"; evidence/renderer-proof-hardening/finisher-m1a/.
```

## Edit 2 — Where things stand: append after 22.2, preserving earlier entries

```text
- **Renderer proof hardening** (build `2026-10-22.3`; plan/ledger `docs/plans/2026-10-21-renderer-proof-hardening*.md`):
  tooling only; native rel is literal payload data (missing stays absent), linked img/figure tabindex routes to
  the wrapper anchor without changing child attributes/styles. Full-bleed showcase zoom is tested through native
  hit-testing and screenshot RGBA, with overflow-visible and never-zooming negative twins; frame geometry remains
  a separate claim. FontStatus records expected/missing separately from observed loaded/failed, with CSS Unicode
  default caseless family equivalence and original spelling. Corpus validates every current capture independently
  of baseline existence/intersection, including failed/missing and expected-minus-loaded inconsistencies; legacy
  optional metadata stays optional. Real CLI controls exercise shared/empty/absent baselines without replacing
  diagnostics or exit logic. R1/R2 fixed; original reviewer repros2/2, selective mutation failures2/9/3, restored21/21;
  Unicode16.0 full-scalar audit has no collisions/inconsistencies. Integrated onto51bbd2e: check2079+6/browser240,
  no skips/failures. Five same-base payloads and full HTML byte-identical, full legacy reports exactly equal29 widths,
  including loaded-family sets; original17 v1 diagnostics unchanged plus the honest Garamond diagnostic (exit1).
  UNVERIFIED — pre-existing on main (Times-Roman shown on both main and branch); genuine licensed font not
  available; no stand-in substituted, expected font set NOT narrowed. Justin's M1A waives only that release hold
  for this release, not completeness. W-B stays deferred. Prior missing-Yellowtail baseline preserved as non-comparable;
  unchanged full rerun matched. No new paste/conversion check; existing3ar/3as and installed-Bricks proof remain owed.
  Canonical renderer-rel, linked-image focus, clipping-test honesty and missing-font diagnostic limitations close;
  busy-Chrome flake/global375/360/320 rollout do not. Released6a7b744; main/origin/remote verified equal; dist rebuilt.
```

## Edit 3 — Working in this repo: append tooling-proof rules after capture policy guidance

```text
- Font loaded/failed are observations, not a completeness guarantee: absent stylesheets can leave both empty.
  Compare decoded literal family names with Unicode default caseless semantics, preserving display names and
  significant quoted whitespace/opposite quotes; do not normalize distinct Unicode forms or punctuation away.
  Validate current expected/missing/failed states independently of baseline existence and file intersection;
  exercise the actual CLI exit branch with shared/empty/absent baselines, injecting only capture data and paths.
  Never make a missing genuine font pass by narrowing expectations or substituting an unapproved face.
- Local renderer proofs must reflect actual payload rel/anchor tabindex. A scaled child's frame dimensions do
  not prove clipping: test outside paint/hits and same-fixture overflow-visible/never-zooming negative controls.
  Local renderer/HTML navigation proof is not installed Bricks or real-PDF integration proof.
```

## Edit 4 — Start here: replace Checks, then build line LAST

```text
- **Checks:** `npm run check`2079/2079 unit/rule +6/6 serial performance; browser240/240, no failures/skips;
  original reviewer repros2/2 and restored font/CLI21/21 pass. Same-base main22.2/candidate five payloads/full HTML
  byte-identical; full legacy reports and loaded-family sets equal29 widths. Actual corpus exit1: same17 historic
  v1 items plus one honest Garamond non-comparability diagnostic. Only that pre-existing font gate's release hold
  is waived by Justin's M1A; Garamond remains UNVERIFIED, not font-complete. No substitution or expected-set
  narrowing. W-B deferred; no new paste/conversion check. Existing checks remain owed to their owners.
```

After all prior pending files and all edits above land, replace `**Current build `2026-10-22.2`.**` with:

```text
**Current build `2026-10-22.3`.**
```
