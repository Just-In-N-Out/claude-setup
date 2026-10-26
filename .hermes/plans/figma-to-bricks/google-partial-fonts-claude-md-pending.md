# Google partial fonts — pending CLAUDE.md edits

Merged and pushed build **2026-10-21.9**, commit `1b21e19450be63d80be3c1f765f70c73d3a5c09e`.

The first attempted CLAUDE.md patch was denied by the protected-file guard. **No edits below have landed.** Do not retry via another tool/path. Apply these exact edits when a permitted session can write it, re-reading first to preserve concurrent changes. Target: `/Users/justin/Documents/FigmaToBricksV2/CLAUDE.md`. Build line is last; do not lower a newer build if another feature has since merged.

## 1. Start here — add before CTA label wrap

- **Google partial fonts (21.9, google-partial-fonts):** a successful Google answer confirms only faces covered by
  its returned family/weight/slant descriptors. Omitted weights say missing unless usable exact site coverage wins;
  accepted CSS, Figma requests and request counts stay unchanged. Fresh review passed; check 1430; browser 137/140
  (the same three stale tests); five corpus pastes/HTML and full per-width lint/heights/fonts identical to main .8.
  Conversion/panel check **3aj**; **paste check: none owed**. Double loading and the header-template setting remain
  separate. HANDOFF "Google partial fonts".

## 2. Start here — checks

Replace `**Checks:** \`npm run check\` 1402 pass` with `**Checks:** \`npm run check\` 1430 pass`. Browser remains 137 of 140, same three known stale upload-name failures.

## 3. Start here — Fonts cleanup F1 status

Replace:

```text
  its own 600 by hand (3af). Item 1 (fonts loaded twice) deferred: needs a live paste proof; F1 (an HTTP-200 Google
  answer missing a weight counted as complete) still open. check 1358 at its merge; HANDOFF "Fonts cleanup, stage 1";
```

with:

```text
  its own 600 by hand (3af). Item 1 (fonts loaded twice) deferred: needs a live paste proof; F1 (an HTTP-200 Google
  answer missing a weight counted as complete) fixed in 21.9 (google-partial-fonts). check 1358 at its merge; HANDOFF "Fonts cleanup, stage 1";
```

## 4. Where things stand — add after Fonts cleanup stage 1 and before Words linked to another frame

- **Google partial fonts** (build `2026-10-21.9`, HANDOFF "Google partial fonts"; plan and ledger
  `docs/plans/2026-10-21-google-partial-fonts*`):
  - `src/ui/fonts.ts` `missingFaces` classifies requested styles from returned `suppliedFaces`, using normalized
    family, matching slant and inclusive `weightBounds`. Both combined-success and individual-retry paths use the
    same coverage check. Omitted descriptors keep normal-400 defaults; explicitly empty or unproven descriptors
    do not invent coverage. Site coverage and existing warning wording still win where appropriate.
  - No extra request for a partial HTTP 200; existing combined-failure retries retained. Accepted CSS, requested
    typography and complete proof payloads unchanged; one Google GET, zero library POSTs in all four site cases.
  - Fresh Sol review passed with no findings. Rebased check 1430/1430; browser 137/140 (the same three stale panel
    failures); five corpus pastes/HTML and complete per-width lint/heights/fonts identical to archived main .8;
    same 17 worse-than-v1 identities. Evidence `~/.hermes/plans/figma-to-bricks/evidence/google-partial-fonts/`.
  - Conversion/panel check **3aj**; **paste check: none owed**. Existing 3af/3ah, duplicate loading and the old header
    template remain separate. Pre-existing Google CSS range emission and loose descriptor validation stay in
    found-else.md; this fix does not harden them or rewrite accepted CSS.

Also replace the Fonts cleanup stage-1 line:

```text
  - **Still open:** F1 (HTTP-200 partial Google answers counted complete); item 1; stale panel tests (test-cleanup).
```

with:

```text
  - **F1 fixed in 21.9:** partial Google answers count only returned descriptor coverage. **Still open:** item 1;
    stale panel tests (test-cleanup).
```

## 5. Working in this repo — add after Font notes, before Font weights in a paste

- **A Google HTTP-200 answer certifies only requested faces actually covered by its returned family/weight/slant
  descriptors.** Nonempty accepted CSS alone is not coverage. Keep supported CSS unchanged; partial success needs
  no extra request. A usable same-family/slant site face still wins; never infer omitted requested weights.

## 6. Current build — apply last

Replace `**Current build \`2026-10-21.8\`.**` with `**Current build \`2026-10-21.9\`.**` only if .8 is still current.
