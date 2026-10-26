# Google partial fonts — don't call an omitted weight available

**Approved by Justin 2026-10-21** (no questions).

PLANNER only · B8 / Round 2 · 2026-10-21 · awaiting Justin's approval.

Investigated main `aa19bae`, build `2026-10-21.7`. Loaded `figma-to-bricks` (PLANNER), its rules summary and the relevant CLAUDE.md font entries, then `systematic-debugging`. Read B1's plan, HANDOFF **“Fonts cleanup, stage 1”**, its review proof, and the current font code/tests. No worktree, branch, application change, build or commit made. The user's modified debug JSON was read only and left alone.

## Open questions

**None needed.** This corrects an existing availability claim, not a font-design choice. Keep Figma's requested family, weight and slant; name the omission using B1's existing notes. Do not choose a substitute, add availability probes, or revisit the deferred duplicate-loader work.

## The request, played back

1. Google can answer successfully but leave out one of the weights the design requested.
2. The panel must mark that weight missing, rather than saying it comes from Google.
3. Keep the weights that did arrive, and keep using a site's exact matching font when it has one. Do not change the design to a different weight.

## Item B8 / F1 — a partial HTTP-200 Google answer counts as complete

### Root cause, with evidence

The original found-else reference to `fonts.ts:44–45` predates B1. On current main:

- `src/ui/fonts.ts:25–30` treats a successful response with any accepted Google-CDN `@font-face` block as usable. That is enough to keep its CSS, **not** enough to certify every requested face.
- `fonts.ts:36–54` already parses actual family, weight/range and slant descriptors into `SuppliedFace`, deduplicating unicode subsets. B1 added this metadata for explanations.
- **`fonts.ts:65–72` is the defect:** line 67 returns `missing: []` for any nonempty combined answer. The individual-retry branch also decides availability from response non-emptiness, not the requested face's coverage.
- `fonts.ts:75–76` returns the accurate `supplied` list alongside the inaccurate `missing` list.
- `src/ui/font-sources.ts:70–86` gives usable site coverage priority, then assumes a face not listed in `googleMissing` is from Google. This makes 800 say “Google” and prevents B1's missing-weight explanation from appearing.
- `src/ui/run.ts:155–161` already forwards `google.missing` and `google.supplied` correctly. No production integration change is needed.

**Hypotheses checked:** (1) the successful-response early return bypasses coverage — confirmed; (2) the response parser loses the missing-weight evidence — ruled out, because `supplied` correctly contains only 400; (3) the panel drops a correctly reported warning — ruled out, because `missing` is already empty before the panel sees it. The existing site-priority code is a working comparison, not something to rewrite.

### Real-response reproduction and tight loop

Previous review proof: `~/.hermes/cache/scratch/fonts-cleanup-review/real-response-proof.json:2–33` shows both IBM Plex Mono 400 and 800 labelled Google, no notes, while emitted weights are Google's 400 plus the site's 700. The 700 is **not** Google's answer.

Fresh public GETs during this planning pass reproduced the issue on October 21, 2026:

| Requested IBM Plex Mono styles | HTTP | Accepted font-face weights |
| --- | --- | --- |
| 400 + 800 | 200 | 400 only |
| 400 alone | 200 | 400 |
| 800 alone | 400 | none |

Replaying the saved combined CSS through current `loadGoogleFonts` gives `supplied: [400]`, `missing: []`, both rows `google`, and no notes. No requests went to WordPress or a live site write endpoint. HTTP-error HTML is not font-face evidence.

Diagnostic files are in `~/.hermes/cache/scratch/google-partial-fonts/`: `probe.mjs`, `real-proof.json`, `synthetic-proof.json`, and raw `google-400-800.css`, `google-400.css`, `google-800.css`. Scratch files can expire; retain the small response fixtures/proof in the implementation's permanent evidence before relying on them later.

**Deterministic red-capable command, run and failed on main:**

```sh
node /Users/justin/.hermes/cache/scratch/google-partial-fonts/probe.mjs --synthetic
```

It supplies a generic Sample Sans HTTP-200 response with only normal 400, asks for normal 400 + 800, and asserts `missing === ["Sample Sans 800"]`. Actual `[]` fails with that exact assertion (exit 1). The same probe without `--synthetic` captured the real responses and failed identically for IBM Plex Mono. The builder will replace this diagnostic with permanent fixture-backed tests in its own worktree; no network is needed for the regression loop.

**Existing tests run:** `node --test test/unit/ui-fonts.test.ts test/unit/ui-font-sources.test.ts` — 23 pass; `node --test test/unit/ui-run-font-fallbacks.test.ts` — 8 pass. They miss the defect deliberately: `ui-fonts.test.ts:48–58` asserts unchanged F1 classification, and `ui-run-font-fallbacks.test.ts:30–42` tests the realistic partial response but explicitly leaves out the availability assertion. Those deferrals must become regression checks.

### Check against the user's files

Read-only inspection of the on-disk `figma-to-bricks-debug-page-1.json` (build `2026-10-20.6`, root **Hydraulic Cylinder Repairs Final**) and `corpus/files/hydraulics-home.json` shows the actual Schedule Now text and its segment both ask for IBM Plex Mono **600**, with 400 examples in component records. This is not evidence that the current page asks for 800. The defect is proven independently by the real response and the generic 400+800 fixture. Do not alter the debug file to manufacture the case or confuse it with the site's older header-weight problem.

### Proposed fix

1. Keep the accepted CSS and the existing network policy: one combined GET per family; only use today's individual-face retries when the combined response fails or has no accepted blocks. A partial HTTP 200 needs **no extra requests**.
2. Use the actual returned descriptors, not the request or HTTP status, to decide which requested faces are covered. Apply the same check to CSS collected from individual retries, so a nonempty wrong-weight answer is not accepted there either.
3. Coverage requires a matching nonempty normalized family key, matching slant, and a numeric weight contained within a valid returned weight interval, inclusive. A matching static covers only its number; isolated statics never imply intermediate coverage. Reuse `familyKey`/`sameFamily`, `suppliedFaces` and `weightBounds`; do not invent a second parser or fake source URLs to satisfy the site-face `covers` signature. `covers` must retain its usable-URL requirement for uploads.
4. Missing or malformed descriptors cannot prove coverage. Preserve the parser's existing CSS defaults (omitted weight/style mean normal 400); unknown weights or invalid families do not become requested weights by inference. Preserve duplicate-request elimination and deterministic family/face ordering.
5. Return the same `{ css, missing, supplied }` shape. Preserve accepted CSS/subsets verbatim and all supported faces; do not synthesize an 800 rule, rename the family, load another weight, or introduce range output. Metadata can recognize a returned interval without creating one.
6. Let the existing source planner do the rest: an omitted Google face is missing unless a usable same-family/slant site face covers it. The existing note should then name only confirmed supplied alternatives, or explicitly say unknown. Google off remains “not checked”. No new panel controls or wording redesign.

### Tests and acceptance

**Permanent tight loop:**

```sh
node --test test/unit/ui-fonts.test.ts test/unit/ui-run-font-fallbacks.test.ts
```

Add assertions first and record RED on the untouched production loader, then GREEN after the change:

- **Exact symptom:** generic 400+800 request, successful CSS containing only 400 → `missing: ["Sample Sans 800"]`, `supplied` only 400, supported CSS unchanged, **one Google call**.
- Complete response → nothing missing, including correct normal/italic combinations; same weight in the other slant or another family cannot cover the request.
- Returned interval covers its inclusive boundaries and interior, not outside; separate static endpoints do not cover an in-between request. Repeated unicode subsets do not create extra metadata/missing entries; duplicate design faces stay deduplicated.
- Omitted default descriptors cover normal 400, not arbitrary requested weights. Unknown/invalid descriptors supply no invented face; cover a nonempty wrong-face single response too.
- Combined failure → preserve existing individual retry behavior and CSS retention, but classify from actual descriptors there as well. Label the existing `ui-fonts.test.ts:34–38` combined-400 stand-in explicitly **failure injection**. Keep timeout/network-error tests.
- Update `ui-fonts.test.ts:48–58`: retain descriptor/subset/CSS assertions, replace the intentional empty-missing assertion with the correct omitted-face result. Make unrelated orchestration helpers describe the faces they actually mean to serve; for example, the Lora 700 control currently serves descriptor-default 400. Don't weaken coverage to accommodate an unrealistic fixture.
- Strengthen the existing **normal partial-response** integration test in `ui-run-font-fallbacks.test.ts`: rows 400 Google / 800 missing, note supplies 400 and site's emitted 700, original text settings still request 800, one Google GET, zero library POSTs.
- Cover no site/empty site, exact static site 800, site variable covering 800, wrong-style/out-of-range site face, and site read failure. Exact usable coverage says site and suppresses the missing note; no coverage retains missing/unknown truthfully. Google off makes no Google request and stays unchecked.

**Non-visual proof:** old → new rows/notes/call counts and byte-identical accepted font CSS, with unchanged requested typography settings. This fix changes classification/notes, not rendered page output; no before/after page images are expected. Keep existing rendering-weight tests green. If the builder finds it must change rendering or loader ownership, stop and split that change rather than broadening B8.

## Tasks — test first

0. After approval only: refresh main/build and create B8's own worktree following the skill. Copy the plan; start `.superpowers/sdd/google-partial-fonts/progress.md`. Run baseline check/browser/corpus and save report plus corpus pastes. Do not use main's modified debug JSON as a test fixture to edit.
1. Add the minimal partial-200 loader and integration assertions; record exact RED results. Retain a small generic response fixture based on the saved real descriptor structure, not live-network-dependent tests.
2. Make the focused loader coverage fix. Prefer `fonts.ts` only in production; use existing neutral helpers. Expand boundary/slant/retry tests above, correct the deliberately deferred assertions and clearly label failure injection. Commit the passing task.
3. Run the non-visual differential proof with saved responses, including site coverage; retain the old/new rows, notes, CSS and call-count evidence. Replay the user's debug copy and Hydraulics unchanged. Compare core pastes/warnings to the matching baseline; no page-output change is intended.
4. Run `npm run check`, `npm run test:browser`, `npm run corpus`; compare every corpus paste, per-width lint and worse-than-v1 identities, not just exits or noisy scores. Current documented baseline has three stale upload-name browser failures and 17 worse-than-v1 identities; re-establish it on the builder's actual base, because other batches are merging. No new regression. Send committed work to the fresh reviewer, then one verified test-first fix pass; finisher rebases and reruns gates.
5. Complete **Docs & records** below at the merge. No claim that the deferred double-loader issue or the site's existing header template has been repaired.

## Risks and boundaries

- A false missing result can be introduced by a wrong family/slant comparison or unrealistic fixture. Test the actual descriptors, numeric ranges and normalized names, never particular production fonts or layer ids.
- This proves requested-style coverage in accepted CSS, not glyph coverage, successful font-binary downloads, or which physical face the eventual site chooses. Preserve B1's cautious wording.
- Google responses may vary by client and over time. CI uses frozen generic CSS; public GETs are supporting evidence, not the gate.
- Avoid new request latency: a partial 200 remains one combined request. Existing failed-request retries/timeouts remain unchanged.
- Do not weaken `covers`/`usableFace`, change upload deduplication, change site-family filtering, add fallback loading, remove the Google loader, change Bricks settings, or edit core layout/text/emit code.
- The fix does not require a real paste to prove the panel row. Existing font paste checks 3af/3ah still stand; a new conversion does not retroactively repair saved pages or site-owned templates.

## Files and pipeline parts touched

**Expected production:** `src/ui/fonts.ts` only. `src/ui/font-coverage.ts` is a read-only helper dependency; modify it only if a tiny interval helper is genuinely needed, preserving every existing site/upload contract.

**Expected tests:** `test/unit/ui-fonts.test.ts`, `test/unit/ui-run-font-fallbacks.test.ts`; optionally a small dedicated Google-response fixture. Existing `ui-font-sources.test.ts` is a regression dependency; add tests there only if not already expressible through the focused integration test.

**Read only:** `src/ui/run.ts`, `font-sources.ts`, `font-names.ts`, `site-fonts.ts`, current debug files and B1 evidence. No planned changes to `Outcome.fonts`, shared panel/browser stand-ins, or `test/unit/ui-run.test.ts`.

**Pipeline:** panel font loading/source classification after emit. `extract → normalise → understand → style → adapt → emit` stays unchanged; no breakpoint-rule changes.

## Overlaps and order

- **fonts-cleanup (B1), merged build .6:** direct dependency, not parallel work. Reuse its response descriptors and existing warning path. Its deferred duplicate-loading item stays open. The test-only review correction already supplies the realistic partial-200 integration stand-in.
- **link-upload-fixes (B2), building:** it may change **`src/ui/run.ts`**. This plan reads that shared file but does **not** edit it or the generic `ui-run.test.ts`. The B8 integration test imports run.ts, so rerun after B2 merges; preserve B2's cancellation/media changes. If a production run.ts edit unexpectedly becomes necessary, report the exact shared hunk before proceeding.
- **test-cleanup:** owns general panel stand-ins/browser fixes; B8 avoids `test/fixtures/panel.ts` and `test/browser/panel.test.ts`. Keep font response data local to the focused test.
- **text-breaks, text-link-followups, cta-label-wrap, pill-clip, layout-floors:** no planned production overlap. Equal-card-fixes is already on the inspected base. Ordinary rebase/docs conflicts still need both batches' records retained.

**B8 can build once approved; no source-file serialization dependency is planned.**

## Docs & records — final implementation task

- Copy this approved plan to `docs/plans/2026-10-21-google-partial-fonts.md`.
- Move the completed ledger to `docs/plans/2026-10-21-google-partial-fonts-ledger.md`, recording RED/GREEN, real-response provenance, non-visual before/after proof and gate/baseline results.
- Update `docs/HANDOFF.md` with scope, unchanged font requests/CSS, request counts and a unique **conversion/panel check**, allocated at merge: reload the plugin; Convert a design requesting a supported and an omitted weight; inspect Fonts for supported=Google / omitted=missing, and the supplied-weight/unknown note; with exact matching site coverage, inspect “on your site” and no missing note. No re-paste is owed for unchanged rendered output. Keep 3af/3ah and loader-removal follow-up separate. No live writes by agents.
- Finisher bumps `BUILD` only after merge, rebuilds dist and updates main `CLAUDE.md` **Start here** / **Where things stand**. Record the rule: **a Google HTTP-200 answer certifies only requested faces actually covered by its returned family/weight/slant descriptors**. Preserve all B1 rules; follow pending-edit procedure if protected writes are blocked.
- At merge only, mark the F1 line in `~/.hermes/plans/figma-to-bricks/found-else.md` as `~~item~~ ✅ fixed in build <BUILD> (google-partial-fonts)`; update B8 status in `found-batches.md`. Do not strike the double-loader item or claim the live site's header template changed.

## Other things found

No separate new application bug. The inaccurate/deferred font assertions and unlabelled combined-failure fixture are test gaps directly in B8's acceptance path, not extra product scope. The individual-retry nonempty-response shortcut is the same root cause and is covered by this fix. General search-files calls intermittently failed with “No such process”; targeted read-only Python scans recovered the source locations. Documentation extraction was unavailable through the configured backend; primary Google endpoint GETs and the official Google CSS API documentation search supplied the needed external evidence. No blocker to the plan.
