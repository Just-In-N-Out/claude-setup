# renderer-font-recovery — bounded PLANNER result

## Decision and smallest indispensable input

**Renderer release remains HELD. This plan is not implementation or font-acquisition approval.** Justin's “continue” authorized this read-only investigation, not a replacement font, changed expectations, new release exception, OS font install, site upload, or source change.

**A ⭐ — Recover the actual licensed face first.** One smallest request: **provide the Garamond Condensed Regular font used by the original Figma design, together with its foundry/source and the license covering private automated browser capture** (one font-and-license bundle; a precise existing project-owned asset location plus entitlement is sufficient). Do not request a whole font folder or Figma account access. The design label alone cannot identify the vendor/version, and no suitable asset was found in the bounded project inventory.

Other choices, only if A is unavailable:
- **B — Explicit renderer-only substitute policy.** Approve a named substitute and altered-fidelity scope first; EB Garamond is an openly licensed candidate, not an exact condensed face or a selected/validated remedy. No silent alias under the original name.
- **C — Separate diagnostic-only release exception.** Change the release contract explicitly, keeping the failing corpus publicly identified as non-comparable. This does not recover Garamond or satisfy the present gate. Not recommended over A; unavailable without a separately approved policy revision.

A bare continuation cannot authorize B/C. File/license validation is a prerequisite to A, not a request to buy an unidentified font. No purchase is presently justified.

## Playback / approach

1. The stronger renderer checks exposed a real missing font that older reports overlooked.
2. Determine the actual family and legal supply route; retain the failure rather than adjusting the detector to hide it.
3. Provision only an approved, verified asset for private captures, then compare both original HTML versions under the same policy.
4. Keep production conversion, typography, live WordPress and loader behavior outside this recovery.

Original approved scope remains linked and unmerged: `/Users/justin/.hermes/plans/figma-to-bricks/renderer-proof-hardening.md`. Read its reviewer and fix-pass reports before resuming; this supplement does not replace their provenance or approved expected/missing contract.

## Investigation snapshot and verified root cause

- Main inspected at `dc6713d` / BUILD `2026-10-21.21`; `main...origin/main`, with only the pre-existing modified user debug JSON. Renderer worktree `/Users/justin/Documents/FigmaToBricksV2/.claude/worktrees/renderer-proof-hardening` is clean at `9c91bed589c3c84e3cf72ce239b860fec625af55`. R1/R2 are already fixed: implementation `d8b0cd03d3e6a3e2ab49d0c9f69c0b0783189e14`. Do not redo or revert those fixes.
- Existing fix-pass report records 1797 unit/rule + 6 performance and 181 browser passes; corpus child exit 1, 17 historical v1 findings plus genuine Garamond non-comparability. These are existing gates, not gates rerun by this planner.
- **Fresh bounded probe executed successfully at 2026-10-21 22:52 UTC:** one sequential Chrome page, original builder baseline and final saved HTML, width 1512, no screenshots/full suite/corpus. Both exact HTML files hash `cd67b7fa6e0af48b70759307d772581e3c9b0891d33b8aebb30507d775947715`.
- Each fresh capture observes `loaded=[Inter, Playfair Display]`, `failed=[]`, `missing=[Garamond Condensed]`. Direct positive-size H2 `brxe-liqdko` and DIV `brxe-zzthgi` both paint **Times / Times-Roman, eight glyphs each** by CDP `CSS.getPlatformFontsForNode`. Widths are 179.859375 and 1082.609375; heights 64 and 514. This is neither an unused-family false positive nor a case-folding problem.
- Fresh primary Google HTTP observation: the minimal family request returns **400**; Inter control **200**. The reviewer already retained the exact full request's same failure. No inference is made about the original historical network event.[9][10]
- Root cause within the verified boundary: renderer asks Google for an unavailable exact family, has no supplied exact face or configured replacement, and paints browser fallback. **Identity/vendor and lawful entitlement to the intended font remain unknown.** Request weight repair cannot cure a minimal family-only 400.

### Weight 5 provenance — informational, not a new converter finding

The configured original input is `/Users/justin/Desktop/figmaplugin/figma-to-bricks-debug-final-design.json`, build `2026-09-30.12`, root `Meet Team`, SHA-256 `3a6f3bd0e19ab7578ef03604e2b359c5ba8d8d70c8a99a5133aed9b66e3b612a`. Nodes `1081:3022` and `1081:3048` already contain family **Garamond Condensed**, style **Regular**, weight **5**, on both node and styled segment. Fresh actual `loadSnapshot` → `textOf` execution preserves those values; original/final HTML computes 5.

File/line trace: `src/core/snapshot/upgrade-v1.ts:10–19` relocates text extras without changing weights; `src/core/normalise/text.ts:84–99,113–121` accepts numeric segment weight before falling back to a style-derived weight. Current extraction requests both `fontName`/`fontWeight` and preserves returned segments (`src/plugin/extract/text.ts:7,38–49`); it does not establish why the old v1 exporter received 5. Historical extraction/font-file metadata cause is **unproved**. No normalization to 400, font file editing, or converter bug claim is authorized. A real Regular file should retain its genuine descriptor; browser face matching against requested 5 must be observed, not faked with a descriptor of 5.

### Bounded asset discovery

`project-audit.json` inventories font extensions under the explicit v2 project, excluding `.git`, `.claude`, `.superpowers`, `dist`, `node_modules`; **no font binary found in that scope**. Garamond mentions are generated final-design paste/HTML references, not asset files. The specific configured v1 debug was read, not its unrelated surrounding private directories. Current configured `fontStandIns` contains only Mont→Montserrat and Caviar Dreams→Quicksand (`corpus/corpus.json:29–32`). No Garamond provisioning path is configured.

This does **not** prove Justin owns no such asset. User/system font directories, Figma/Adobe caches, unrelated private folders and OS permissions were not inspected. No live-site request, authentication, font download, acquisition, font install, source/test edit, worktree creation, merge, commit or BUILD write occurred.

## Legitimate sources investigated — identity is not established

| Primary source | What it establishes | Recovery consequence |
|---|---|---|
| Very Cool Studio's own Garamond Condensed page | Describes **VC Garamond Condensed**, Kyle Benson, released 2022, 42 styles; own commercial and trial license links.[1] | A plausible name match only. Nothing links the original debug's unnamed-vendor Regular face to this release. |
| Very Cool commercial terms v1.3 | Permits licensee-operated devices, sites, servers/domains, subject to entity/size, redistribution and extraction restrictions.[2] | Legitimate purchase route **if** identity and entitlement are established; no automatic right to distribute the file or commit it. Actual entitlement still must be checked. |
| Very Cool trial terms v1.3 | Internal non-public evaluation only; no commercial projects/production/public use; restrictions persist until licensed.[3] | Trial is not a general renderer-release workaround. Investigating whether this is the intended face could be an independently approved font evaluation; do not assume commercial plugin validation qualifies. No trial acquired. |
| MyFonts/Monotype catalog and licenses | Lists URW **Garamond Std Regular Condensed** and separately **ITC Garamond Condensed Volume**, with separate desktop/web/server categories.[4][5][6] | Multiple legitimate but distinct products. Name overlap is insufficient; a desktop license label is not evidence for arbitrary web embedding/server redistribution. Read the actual product EULA/entitlement before provisioning. No purchase/price recommendation. |
| Google's own EB Garamond metadata and OFL | Family is **EB Garamond**, normal/italic, `wght` 400–800; SIL OFL 1.1 grants use/embedding subject to its conditions, including license/copyright retention with distribution.[7][8] | Legally documented **substitute candidate**, not Garamond Condensed, and not a proven match in outlines, widths or line breaks. Metadata has a weight axis, not a verified condensed instance. No source renaming, faux condensation or binary download. |

**Recommendation:** A. Neither a matching-looking title nor a web-visible font resource establishes identity or permission to reuse its bytes. If the supplied face turns out to have another internal family, record a verified Figma display-family → actual file identity mapping; do not silently rename an unrelated family into Garamond Condensed. If no such mapping is established, stop and choose explicit B/C or remain held.

## Implementation boundary / size / ownership

- **A, after asset + scope approval:** Small, Sol 6.1 high, bounded evidence/provisioning harness; separate fresh Sol 6.1 high reviewer and same-model finisher. Known failure, one tooling area, no product decision change. If solving it needs a reusable loader API, production modification or broader font policy, stop and resize/replan rather than growing A.
- **B/C:** an explicit policy change, In-between / Opus 5.5 medium builder, fresh Opus 5.5 xhigh reviewer, unless Justin explicitly chooses a different model. Dispatcher checks quota and ownership before launching, not a reason to change models silently.
- Existing renderer branch owns `test/browser/render.ts`, `fonts.ts`, focused tests, `tools/lib/corpus.ts` and `tools/corpus.ts`. Preserve its changes and gates. Recovery initially touches **new private evidence runner/config/manifest only** under this plan's evidence directory; **no repository code change is pre-authorized by this plan**.
- A can use an approved process-local browser-setup hook around the existing capture path to load verified font bytes before capture. It must exercise real rendering/reporting/CLI decisions: no mocked captures, supplied success flags, altered `regressions`, exit assignment, font observers or expectation deletion. Any durable repository hook needs its own exact file allowlist before edit.
- B may request a narrow later allowance for `corpus/corpus.json` plus mapping tests in `test/unit/render.test.ts` and report assertions in `test/unit/corpus.test.ts`; not granted now. Existing `requestedFontFamilies`/stand-in support supplies the natural seam (`render.ts:28–35,223–253`; `corpus-files.ts:1–23`). No loader rewrite or per-design code branch.
- Phone/media recovery planners are read-only independent work; their source files are not granted here. Hero-photo-blend and list-panel-followups are active separate owners. Their conversion changes may invalidate cross-base images even without exact code overlap. Global corpus-width rollout remains queued behind renderer hardening. Stagger browser/corpus/performance gates; no expensive gates were run during this research.

## Concrete recovery sequence — 15 bounded tasks

1. **Freeze ownership and provenance.** Dispatcher verifies current main and `9c91bed` worktree status/diff, reserves the font-proof runner, and records chosen policy/approver. Keep original renderer plan, reviewer/fixpass reports and all failed captures immutable. No automatic merge.
2. **Resolve the one missing asset/entitlement input.** Inspect only the supplied exact font path or bundle. If missing, unlicensed, wrong family or unusable, retain the hold; do not scan font folders or fetch an unofficial mirror.
3. **Validate font identity before loading.** Read font name IDs 1/2/4/6/16/17, vendor/version/copyright/license fields, OS/2 weight/width, slant, variation axes and glyph coverage for the direct text. Hash the exact file. Compare with Figma family/style and available vendor records; names alone are not sufficient. Do not mutate metadata or assume Regular=400 repairs the source weight.
4. **Record license-specific constraints.** Establish licensee, permitted private browser capture/embedding, redistribution/CI limits and any conversion restrictions. Store entitlement provenance privately; do not copy license secrets or proprietary binary into git. Unclear terms are a stop, not an inference of permission. No asset acquisition under this research grant.
5. **Choose the minimal capture-only carrier.** Prefer original licensed bytes loaded as an explicitly supplied FontFace in the isolated browser, not an OS install or site upload. Bind only to a verified intended display-family mapping; use genuine style/weight descriptors. FontFace ArrayBuffer/private loopback serving is a proposed implementation, **not yet proved or approved**; choose one that the actual license permits. No persistent system registration or font-name forgery.
6. **Preflight one exact before/after pair at 1512.** Preserve complete HTML byte hashes before/after provisioning. Provision identically after navigation and before settling/measurement; bound readiness. Record requested family, loaded/failed/missing, actual file digest and face descriptors. Retain the failing unprovisioned twin separately.
7. **Verify physical glyph supply.** On both direct visible nodes, use text ranges/positive geometry and CDP platform-font evidence linked to the verified file; reject Times-Roman fallback, uncovered glyphs or a merely loaded-but-unused face. Preserve computed request weight 5 and actual selected face. An unexpected result returns to asset identity analysis, not converter edits.
8. **Prove the missing-font detector stays red-capable.** In fresh isolated contexts, remove/break only the supplied asset and require the real observer/CLI font rejection; wrong-family control also rejects, legitimate case-only family twin still passes. Do not leak a warm global font into the negative control. Successful setup must not override observed failure fields.
9. **Recapture original saved v2 baseline and final HTML, matched.** Use one sequential Chrome page under the exact same approved font/capture policy at **390,768,1024,1440,1512,1920**. These are all six affected widths in the retained reports, not a new global-width rollout. Save complete lint/findings/heights/page+section scores, glyph observations and actual font state. No original report overwrite.
10. **Bring the v1 comparison onto the same policy too.** The retained v1 final-design baseline also lacks Garamond. Recapture its own saved original complete HTML at its same six widths with the same face and capture/motion policy, under a new **matched-policy v1 recapture** label. Do not substitute v2 HTML, regenerate CSS from sorted JSON or write `corpus/baseline.json` silently. Mismatched legacy v1 fonts cannot be ignored to make the CLI green.
11. **Compare honestly under the new policy.** Compare complete saved HTML/payload bytes separately from font-environment changes; compare all matched widths/findings/multiplicities/heights/font sets. Compare only matched-policy scores. Retain the historical 17 finding identities, but do not promise the new physical font preserves their count or old fallback geometry: investigate any changed diagnostics under the new policy. Distinguish A's actual-face proof from B's altered-fidelity proof.
12. **Apply B only if expressly selected.** Record named original→substitute mapping and licensing source, revised capture-policy identity and no Figma-fidelity claim for affected text. Preflight the renderer's **actual complete Google request**, not just family-only 200; assert real glyph supply. Mapping changes HTML, so preserve originals and prove policy-rendered before/after HTML equal to each other, with deltas restricted to the approved mapping/request. Do not alias EB Garamond as the original face or mark the original available. If this needs loader/weight changes, stop; B does not authorize them.
13. **Run final gates once prerequisites are proved.** Focused renderer/font/corpus + actual CLI tests first; then serialize `npm run check`, `npm run test:browser`, and real corpus on the final integration base. Require complete fonts in every current file, including current-only ones; preserve absent/empty-baseline and Unicode family controls. If a temporary matched-v1 report path is necessary, override only paths with recorded, real recaptures; keep diagnostic/exit logic untouched. Capture child exits/raw logs. Existing v1 differences may still cause corpus exit 1; report the exact reasons, not a fake all-green claim. Default unprovisioned CLI failure remains an explicit limitation unless the approved policy makes provisioning part of the supported gate invocation.
14. **Fresh independent review before release consideration.** Reviewer independently checks entitlement/identity boundaries, real glyph supply, matched pairs/v1 provenance, negative controls and exact file scope; rechecks R1/R2 preservation. Rebase-induced layout changes require fresh same-base pairs. Any unresolved missing font, unapproved B/C, unmatched comparison, unavailable evidence or failed actual gate keeps release held. C requires its own explicit contract amendment; no code path suppressing Garamond failures.
15. **Docs & records — last release task, only after approval and proof.** Copy approved supplement to `docs/plans/2026-10-21-renderer-font-recovery.md`; add/move ledger to `docs/plans/2026-10-21-renderer-font-recovery-ledger.md`; link original renderer plan and immutable manifests. Update renderer HANDOFF with exact source/policy/license provenance, original versus matched-policy reports, child exits and remaining holds. No new user paste check for local tooling; retain existing installed-Bricks checks. Finisher alone, following actual release approval, handles BUILD bump/build/merge/push and main CLAUDE Start here/Where things stand; no such action was taken here. Preserve pending protected-doc edits if applicable. Durable rule, if implementation creates one: face identity/entitlement and actual glyph supply are prerequisites; matching fallback does not make a capture comparable. Keep proprietary assets out of repository/archive distribution unless licensed. No canonical finding closes before verified release.

## Evidence, commands, limitations

New durable evidence: `/Users/justin/.hermes/plans/figma-to-bricks/evidence/renderer-font-recovery/planner/`.
- `probe.mjs`, `proof.json`: fresh executed original-HTML/glyph and raw→normalized provenance checks. Probe succeeds only when the **existing failure is reproduced**; its exit 0 is not a release pass.
- `project-audit.json`: bounded project inventory, states and report width/font snapshots.
- `public_sources.py`, `public-sources.json`, `license-sources.json`, named `*.raw.txt` / `*.txt`: text/HTML/license/metadata HTTP evidence only, no font bytes.
- `citation-ledger.json`: mechanically assigned public source IDs.

Reproduce the narrow diagnostic, without a remedy:
```sh
node /Users/justin/.hermes/plans/figma-to-bricks/evidence/renderer-font-recovery/planner/probe.mjs
```

Authoritative existing reports:
- `/Users/justin/.hermes/plans/figma-to-bricks/evidence/renderer-proof-hardening/reviewer/REPORT.md`
- `/Users/justin/.hermes/plans/figma-to-bricks/evidence/renderer-proof-hardening/fixpass/REPORT.md`

Tool limitations: configured web extraction backend refused extraction; primary pages were retrieved as public text/HTML with curl instead. An initial urllib chunked fetch was incomplete; replacement full curl captures are hashed/status-recorded. Adobe's primary help page returned 403 and is **not relied upon** for license conclusions. No access-control workaround was attempted. One generic tool terminal inherited a stale sibling cwd and failed before execution; all subsequent shell calls used explicit `/Users/justin` or supplied repository paths.

Other things found: no new converter bug. Existing weight-5 source anomaly stays informational and separate. Exact vendor/version and usable licensed asset remain unresolved; the smallest user input above is genuinely necessary for A after this bounded investigation.

## Sources

[1] https://verycoolstudio.com/typefaces/garamond-condensed
[2] https://verycoolstudio.com/terms
[3] https://verycoolstudio.com/trial-terms
[4] https://www.myfonts.com/products/regular-condensed-garamond-333613
[5] https://www.myfonts.com/products/regular-condensed-garamond-333613/licenses
[6] https://www.myfonts.com/products/itc-garamond-condensed-volume-package-380326/licenses
[7] https://raw.githubusercontent.com/google/fonts/main/ofl/ebgaramond/METADATA.pb
[8] https://raw.githubusercontent.com/google/fonts/main/ofl/ebgaramond/OFL.txt
[9] https://fonts.googleapis.com/css2?family=Garamond+Condensed
[10] https://fonts.googleapis.com/css2?family=Inter
