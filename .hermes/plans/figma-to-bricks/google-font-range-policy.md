# google-font-range-policy — PLANNER (round 3, section E)

Model: builder **Opus 5.5 medium**; separate fresh reviewer **Opus xhigh**. Planner only: no worktree, source, test, commit, build or site write was made. Inspected main `9f9b751` (BUILD `2026-10-21.19`, = origin/main; only the user's debug JSON modified, untouched).

## Approved under Justin's away auto-go (2026-10-21 ~16:38 EDT)

**Q1A Q2A Q3A (all ⭐).** Justin authorized continuing plans with recommended answers for the next two hours. Preserve exact requested weights, request count, single-weight CSS and subsets; duplicate-loader removal remains held. Malformed/unsupported faces may be omitted with honest missing coverage; do not quietly misparse/drop legitimate ordinary CSS. Builder must flag any new scope or product/security trade-off.

## Questions for Justin (answered above under away auto-go)

**Q1. What should the plugin do if Google ever answers with a weight range (`font-weight: 100 900`)?**
Your rule says a paste never holds a weight range (Bricks copies it into its Google Fonts link and Google refuses the whole link). Today the plugin pastes Google's answer unchanged, so a range would get through.
- **A ⭐ Split it into the design's weights.** Read that one face's lines into typed parts and write one face per weight the design asked for that the range covers (same file, same subsets, same other lines). Faces that already have one number stay byte-for-byte as Google sent them. No new requests, no substitute weights. The panel lists exactly the weights the paste holds. Medium: one new small file plus `fonts.ts`.
- **B Prove it can't happen and stop.** Add tests that pin the plugin's request (never asks for a range) and a saved real Google answer (discrete weights). Leave a theoretical range unchanged in the paste. Smallest, but the no-range rule stays unenforced if Google's behaviour changes.
- **C Leave out any range face and say so.** Simple, but it drops a usable font face the design needs (the weight becomes "missing").

**Q2. A range that doesn't reach the design's weight (Google returns 600–700, design asks 800). Under 1A:**
- **A ⭐ Same as the site path:** emit nothing from that face, and the panel says "Requested … 800. No replacement weight is confirmed". Matches `siteFaceCss`, which never emits range weights the design doesn't use. Visible change: today the browser would draw 700 from the range; afterwards it uses whatever else loads (another face or the system font).
- **B Keep today's look:** emit that face at its two end weights (600 and 700) as plain numbers, and say "supplies 600 and 700". Adds weights the design didn't ask for (whole numbers, so Bricks' link stays valid).

**Q3. A face whose weight isn't one plain number and can't be split safely** (an unreadable range, `nonsense`, reversed `700 300`, or lines the small reader can't parse, e.g. comments or escapes). These already count as unconfirmed since .13, but their CSS still goes into the paste.
- **A ⭐ Leave it out of the paste.** It already gives no confirmed weight, so nothing confirmed is lost; the existing "missing / no replacement confirmed" note applies. Also covers `normal`/`bold` keywords: those are written as 400/700 by the same splitter (Q1A), not dropped.
- **B Keep pasting it unchanged** (rule still broken for those, as today).

Not a question (fixed by the brief): duplicate-loader stage 2 stays **HELD** for its live proof. This plan removes neither loader: the paste keeps its own `@font-face` lines and Bricks' link.

## Playback

1. Your rule: no weight ranges or word weights anywhere in a paste, because Bricks puts them in its single Google Fonts link and Google then refuses every font on the page.
2. The site's own font lines already obey it (build .3). Google's answer is pasted as Google wrote it.
3. A hand-made Google answer containing `100 900` reaches the paste, and the panel then says the range is supplied. This is a **synthetic** test, not something seen from Google for the plugin's requests.
4. You want the paste and the panel's "supplied" list to say the same thing, the design's exact weights and Unicode subsets kept, with no regex CSS rewriting, no quietly lost faces, no substitutes and no extra requests.

## Evidence (durable: `~/.hermes/plans/figma-to-bricks/evidence/google-font-range-policy/planner/`)

**Root cause (code, main 9f9b751):** `src/ui/fonts.ts:18–23` `fontFaces` keeps every gstatic-only block verbatim. `:93–110` `loadGoogleFonts` joins them into `css` unchanged. `:115–120` `withFontCss` appends that to the first top-level element's `_cssCustom`. `:63–80` `suppliedFaces` reports a range as `weight: "100 900"`, so `missing` is `[]` and `supplied` advertises the whole range. No stage enforces the no-range rule for Google CSS. The site path does enforce it: `font-sources.ts:34–61` `selectedSiteFaces` writes one numeric rule per covered design weight.

**Tight loop:** `node evidence/.../probe.mjs` (all fetches stubbed, `externalRequests: 0`), run against main's `src/`. Exit **1** = red. Output in `proof.json`:

| case | what it is | paste weights | supplied | red? |
|---|---|---|---|---|
| A | **SYNTHETIC** hand-written `100 900` block for a discrete 800 request | `100 900` | `100 900` | yes |
| B | **LIVE** saved Google answer to the URL the plugin builds (`Inter:wght@400;700`) | `400`, `700` (14 subset blocks) | 400, 700 | no |
| C | **LIVE range-shaped** answer (`Inter:wght@100..900`, a URL the plugin never builds) served for a discrete request: a synthetic mismatch | `100 900` | `100 900` | yes |

**Live Google observation (read-only GETs, Chrome 130 UA, `live-google/fetched-at.txt`, raw `r1–r6.css`, `index.txt`):** all HTTP 200.
- Discrete requests return **discrete** weights, including for variable families: Inter 400;700, Inter ital 0,400;1,800, Roboto Flex 300;500, Saira Condensed 100;200;600. Inter's 400 and 700 point at the same variable file (subset files appear twice).
- Only the `..` range syntax returns `font-weight: 100 900`.
- `googleFontsUrl` (`fonts.ts:9–15`, pinned by `ui-fonts.test.ts` "URL asks for exactly the weights…") only builds `;`-separated whole numbers.
- **Conclusion:** with today's requests no real range has been seen. This is a defensive invariant gap, not a reproduced user bug. Other user agents and future Google behaviour were not tested.
- Design weights in the user's debug JSON and corpus are all whole hundreds (300–800), so no in-between request weights arise.

**Negative twins / controls:** live discrete answer (B) stays byte-identical. Subsets stay separate blocks. `.13` descriptor tests (single-number weights) are unaffected by construction.

**Baseline:** `node --test ui-fonts ui-google-font-descriptors ui-font-sources ui-run-font-fallbacks` → **157 pass / 0 fail** (`focused-baseline.tap`).

**Hypotheses ranked:** (1) verbatim pass-through with no emission-side invariant: confirmed by A/C. (2) Google returns ranges for discrete requests: **not observed** (live B and r3–r5). (3) Request builder asks for ranges: ruled out (code + test). (4) The site path leaks ranges: ruled out (existing `ui-font-sources`/`ui-run` no-range tests).

## Approach (if 1A / 2A / 3A)

New pure file **`src/ui/google-faces.ts`** (~90 lines; `fonts.ts` is 121 and would pass 200 otherwise):
- `readFace(block) → { decls: Array<{name, raw}> } | null`: one character scanner over the block body. It tracks quotes and parentheses and splits on top-level `;`. It returns `null` on comments, backslash escapes, unbalanced quotes or parens, nested braces, or duplicate `font-weight`/`font-style`/`font-family`. These are typed declarations. Nothing is regex-replaced.
- `projectFaces(blocks, requested)`: for each block in order:
  - weight is one number (or omitted) → original text kept byte-for-byte;
  - `normal`/`bold` → rewritten as `400`/`700` (3A);
  - a valid range → one block per requested weight of the same family and slant inside the inclusive bounds, ascending. The output is `@font-face {` + each original declaration's raw text, with only the font-weight value replaced, + `}`. Every other declaration (src, unicode-range, display, stretch…) keeps its original text.
  - A range covering no requested weight → nothing (2A). An unreadable or non-number weight → nothing (3A).
  - A projected copy is skipped if a single-number block in the same answer already gives that family/slant/weight with the same `unicode-range` (statics first, like the site path).
- `fonts.ts`: per answer (combined, or each per-face retry with *its* requested face), run `projectFaces` before `missingFaces`/`suppliedFaces`. That way `css`, `missing` and `supplied` all come from **the same emitted blocks**, so they agree by construction. `{css, missing, supplied}` shape, request URLs, request counts, retry policy, family order and `withFontCss` stay unchanged. No `run.ts`, `font-sources.ts`, `main.ts` or core change.

## Tasks (TDD; ledger `.superpowers/sdd/google-font-range-policy/progress.md`)

**T0 baseline.** Worktree per skill Step 2. Copy this evidence folder's `probe.mjs`, `live-google/*.css` (as fixtures, see T1) and the plan. Save `npm run check`, `npm run test:browser`, `npm run corpus` reports, `corpus/report-v2.json` and all `corpus/out/v2/*/bricks.json` before edits.

**T1 RED: new `test/unit/ui-google-font-ranges.test.ts`**, self-contained `env.fetch` stub. Copy `r1.css` and `r2.css` to `test/fixtures/google/` labelled "live Google answer 2026-10-21, Chrome UA". Generic family names in synthetic cases. Each case asserts paste weights, `supplied`, `missing`, URL and call count:
1. Synthetic `100 900` + request 800 → paste has only `font-weight: 800`, one face per subset, `src`/`unicode-range` text identical. `supplied` = 800; `missing` = [].
2. Range with 3 subsets + requests 400/700 → 6 blocks (3 subsets × 2), order deterministic, every non-weight declaration byte-equal.
3. Italic and normal ranges + mixed requests → slant never crosses over.
4. 2A: range 600 700, request 800 → no block from it, `missing` 800, `supplied` excludes it; `fontNotes` says "No replacement weight is confirmed".
5. Static 400 plus range 100 900 in the same answer, request 400 → only the original static (byte-equal); no duplicate.
6. 3A: `nonsense`, `700 300`, a range block with a comment or escape, or a duplicate `font-weight` → left out of the paste, `missing` retained. `bold` → emitted as `700`.
7. Live r1 discrete fixture → `css` byte-identical to the accepted blocks (negative twin). Live r2 fixture served for discrete 400/700 → 7 subsets × 2 numeric blocks, no range.
8. Failure injection (combined HTTP 400, per-face retries return ranges) → same retry count; each face projected only to its own weight; no duplicates.
9. Integration through `startRun` (copy the shape of `ui-run.test.ts:164`, new file or new case; no fixture edits): the final payload `_cssCustom` has no font-weight containing a space or a letter, with Google ranges and site variables both present.
10. `googleFontsUrl` never contains `..`.
- Record RED on the untouched loader (assertion failures, not import errors).

**T2 GREEN.** Implement `google-faces.ts` and wire it into `fonts.ts`. Update the **existing tests that pin the old behaviour** (allowed edits, stronger new assertions):
- `ui-fonts.test.ts:66–72`: interval coverage. Keep 200/800 missing; `supplied` becomes `300`, `500`, `700` (the emitted weights), not `"300 700"`.
- `ui-fonts.test.ts:159–169`: a `600 700` italic range with request normal 800 is now omitted (2A). Keep the subset-dedup assertion for the 400 blocks; `css` equals the two 400 blocks.
- `ui-fonts.test.ts:101–111`: invalid weights stay missing; add a check that the paste CSS no longer holds them (3A).
- Run the focused 4 files plus the new file. Prove RED again by `git checkout HEAD~1 -- src/ui/fonts.ts src/ui/google-faces.ts`, then restore.

**T3 gates.**
- `npm run check`, `npm run test:browser`, `npm run corpus`. Corpus pastes should be **byte-identical**: the corpus uses discrete Google answers or stand-ins. Any change is a stop-and-explain.
- Replay a scratch copy of the debug JSON before/after: core payload identical (fonts are panel-only).
- Text proof table (old → new paste weights / supplied / missing) for probe cases A, B, C. No screenshots (not a visual change in practice).
- Fresh Opus xhigh reviewer: scanner edge cases (quotes in `src`, `format('woff2')` parens, `tech()`), byte-preservation, metadata coherence, no new requests, no substitution, B8/.13 tests intact. The reviewer must not call this a live-observed bug.

**T4 Docs & records.**
- Plan → `docs/plans/<date>-google-font-range-policy.md`; ledger → `docs/plans/<date>-google-font-range-policy-ledger.md` (RED/GREEN, probe table, live-vs-synthetic labels, evidence path).
- `docs/HANDOFF.md` section: Google ranges are split into design weights. Defensive: never seen from Google for the plugin's discrete requests. Conversion check owed (number allocated at merge after 3as): reload, Convert, panel fonts unchanged for real designs. No paste check owed unless corpus/replay output changes. Loader duplication still HELD.
- BUILD bump by the finisher only. Main `CLAUDE.md` Start here / Where things stand. Rule refinement: "Google's answer is split into the design's own whole-number weights; never pasted with a range or word weight; metadata lists exactly what is pasted." Update `rules-summary.md` "Range emission deferred" → the new rule.
- `found-else.md:117`: strike only at the verified merge, with the build. Leave line 30 (duplicate loading) open.

## Touches

- **Edit:** `src/ui/fonts.ts`; new `src/ui/google-faces.ts`; new `test/unit/ui-google-font-ranges.test.ts`; new `test/fixtures/google/inter-400-700.css`, `inter-100-900.css` (copied live answers). Existing **`test/unit/ui-fonts.test.ts`** lines 66–72, 101–111 and 159–169 (old range/invalid pass-through assertions).
- **Read-only:** `font-coverage.ts`, `font-names.ts`, `font-sources.ts`, `run.ts`, `site-fonts.ts`, `ui-google-font-descriptors.test.ts` (must stay green unchanged), `ui-font-sources`, `ui-run*`, core, payload guard.
- **Stop if:** `run.ts`, `font-sources.ts`, panel/main, shared fixtures or core need changing, or corpus pastes change.

## Overlaps (checked 2026-10-21 against live branches)

- **pill-clip** (`5a5f845`), **hero-photo-blend** (`46c17a5`, picture-shadow H1B; separate work, no font files): `git diff main...` touches no `ui/font*`/`ui/run.ts`. **card-link-words** merged (.19); its branch is gone.
- **A renderer-proof-hardening:** owns `test/browser` fontStatus/capture helpers. No shared file. If A changes how the corpus reports loaded families, compare our corpus fonts against A's labelled baseline. Sequence corpus gates, don't run them in parallel in shared main.
- **B media-rename** (`site-media.ts`), **C phone** (`normalise/contacts.ts`), **D list-panel** (`ui/main.ts`, lists): no shared files. If D's main.ts work touches font rows, that is a hard dependency (not expected).
- Duplicate-loader stage 2: HELD, untouched. Shared HANDOFF/BUILD/CLAUDE only under the finisher's merge lock.

## Risks

- The scanner is deliberately small. Anything unusual is left out (3A), which could hide a real face if Google changes formatting. Mitigation: the live fixtures as positive controls, and the reviewer's edge cases.
- 2A changes the browser's fallback for a range that misses the design weight (never seen live).
- Live observation is one UA on one day; it doesn't prove Google never returns ranges.

## Found elsewhere

None new. The `ui-fonts.test.ts:101–111` invalid weights (`nonsense`, `700 300`) currently also reach the paste verbatim. That is the same root cause, folded into Q3, not a separate item.
