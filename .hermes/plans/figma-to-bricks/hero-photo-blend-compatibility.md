# hero-photo-blend — autonomous compatibility verdict (2026-10-21)

**Outcome: STOP 1A implementation.** Chrome 155 renders the CSS SVG data-URI filter correctly; actual Safari 26.5 does not draw either intended shadow. Same-document inline definitions work in both. 1A colour snapshots remain approved; “2 just figure it out” authorized this investigation, not live writes or a fallback. Ask the dispatcher for a revised transport decision rather than asking Justin to paste a failing 1A sample.

## Reproduce and artifacts

Scratch root: `/Users/justin/.hermes/cache/scratch/hero-h1b-compat/`.

```sh
python3 /Users/justin/.hermes/cache/scratch/hero-h1b-compat/collect.py
node /Users/justin/.hermes/cache/scratch/hero-h1b-compat/probe.mjs
node /Users/justin/.hermes/cache/scratch/hero-h1b-compat/safari-followup.mjs
```

Uses existing system Chrome, safaridriver, Node and project's read-only Chrome/PNG helpers, with temporary loopback HTTP servers and disposable automation sessions. No install, Safari enable/config change, credentials, production source change, site write, upload, signing, build or commit. Chrome helper uses headless software/GPU-disabled capture; Safari is actual macOS Safari, not Playwright WebKit. The main probe has **156 browser captures**, 78 per browser; follow-up has **8 top-level Safari captures**. `browser-results.json`, `safari-followup.json`, exact HTML/PNGs under `renders/`, site headers/bodies/CSS, `local-source-discovery.json`, and SHA-256 `manifest.json` are the evidence. Scratch is subject to idle pruning; archive requires an authorized destination/action, not an invented retention claim.

## Capability verdicts — measured versus inferred

| Capability | Verdict | Evidence / limit |
|---|---|---|
| Chrome transport | PASS locally | Chrome155.0.0.0: `<img>` and background Div independently render intended x/y shadows RGB51 and phantom RGB255. Chain control produces phantom RGB92; no-filter control has no intended shadows. This is synthetic transport, not converter output or Bricks acceptance. |
| Safari transport | FAIL 1A | Safari26.5/macOS26.5.1, DPR2: intended x/y shadows RGB255 (absent) for both modes; source remains visible, no CSP violation. Inline control renders RGB51/RGB51 and phantom255. Top-level retries after500ms and a further1200ms reproduce failure for percent-encoded URI, base64 URI, and same-origin external SVG; inline passes twice. This rules out only the tested iframe/load/encoding explanations, not every possible WebKit mechanism/version. |
| Installed frontend CSP | No observed blocker, not blanket approval | Successful GETs for home, Hydraulic and Remanufactured pages and site CSS carry `Content-Security-Policy: upgrade-insecure-requests`; no CSP meta was found in those pages. Chrome local HTTP controls allow the filter with `img-src 'self' data:` and suppress it with `img-src 'self'`, recording `img-src`/`data` violation while source stays visible. Future policies, authenticated builder policies and unsampled pages are not proved. Safari failure also occurs without a restricting policy. |
| Bricks transport / sanitization | UNPROVED | No installed PHP/theme package or local WordPress installation found in scoped Downloads/Documents/Desktop/Local Sites/Sites discovery (dependencies/hidden folders excluded). Existing user-supplied exports show `_cssCustom`; archived official Video schema2.4.3 declares a string/code control. Historical sample versions are not installed-version proof. Public compiled post/global CSS is readable, but no custom CSS SVG filter URL was found. A theme-library base64 SVG background icon exists: it proves only that static library asset, not custom CSS filtering or save sanitization. No local PHP runtime was available. |
| Responsive bounds | Partial Chrome proof; gate stays open | Exact Chrome viewport and Safari iframe inner widths320/390/1440 recorded. Source sizes128×96,156×117,300×225; extra tiny24×18. Negative/positive offsets, coloured alpha overlap, sigma6.25/3.5 and tiny0.25/1.125, layer blur2.5px, rounded alpha, scale1/1.1. Analytically bounded and min-size-normalized regions have maxRGB0 versus expanded6-sigma reference in **14 comparisons each**; default region fails all14, up to204RGB. Safari comparisons are **invalid as shadow-bounds proof** because the data filter did not render; equality is not success. |
| Cost / size | Measurements, not a performance acceptance | Encoded two-shadow filters1129–1301 bytes. All-case navigation/wait/capture medians: Chrome200.79ms, Safari585.41ms; these include fixed waits and readback and are **not GPU/frame timings or a production budget**. One estimated RGBA logical region at300×225 is669600 bytes for bounded max-size, versus18073125 for normalized min24×18 (26.99× area). These are arithmetic surface estimates, not measured allocation; intermediates, DPR and transforms add further uncertainty. |

## Bounds contract and exact remaining gaps

Scratch conservative padding is `max(0, directional_offset + 4*(shadow_sigma + layer_sigma), 4*layer_sigma)` on each side, compared with an analogous6-sigma reference. Gaussian support is not mathematically finite; 4-sigma is a practical raster experiment, not an exact infinite-support theorem. The fixed max-size region encloses the **declared fixture envelope only**; the normalized region derives from a **declared minimum24×18 only**, and becomes expensive on larger pictures. Neither min/max envelope has been established for every converter picture/video/showcase/responsive path. Tiny estimates with unspecified layer sigma in the first results contain `null`; those entries are invalid and are not used in the stated estimates. Preserve the original result rather than silently repairing measured data.

The `calc(100% + …px)` attribute experiment also pixel-matches12 Chrome fixture comparisons, but this does not establish standards/browser portability, actual resolved resource region, a safe cost contract, or Safari support. Do not promote it to the implementation.

Zoom here is a static transform on the filtered element, **not** the actual showcase pseudo-element's hover transition, ancestor clipping, reduced motion, video alpha, final asset substitution or converter output. Those remain later implementation gates for any separately approved route.

Exact installed acceptance gap: no observed **this filter** paste → save → copy-back element, retained encoded fragment after save, resulting compiled declaration, and saved frontend result. Read-only GETs and a schema string cannot prove permission-dependent save sanitization or minification. Existing frontend CSS does not contain an example of the proposed filter. Do not fabricate that roundtrip, invoke a renderer as its substitute, or access credentials/private source. If a revised route still needs a real saved roundtrip, parent must obtain a legitimate local package/disposable authorized environment or a narrowly authorized user-run proof after browser feasibility—not silently grant live-write permission.

## Read-only site and collection issues

GET-only: home plus `/hydraulic-cylinder-repairs-final/` and `/remanufactured-hydraulics-cylinders-final/` return200. Home's `/services-repairs/` link returns404; recorded, not repaired. Initial chunked reads of `post-10.min.css` and some official docs were incomplete; `curl --http1.1` with identity encoding successfully re-fetched them. Complete post10 CSS is525467 bytes and has no SVG data URI or `filter:url(...)`. One linked Google Fonts request returned400; unrelated, not fixed. Retry filenames for two Bricks docs initially collided; `official-custom-code.html` is the independently re-fetched authoritative custom-code page, while `retry-academy.bricksbuilder.io.html` is asset-loading. The raw retry ledger is preserved.

Primary documentation: W3C Filter Effects Module Level1, filter region and primitives (`https://www.w3.org/TR/filter-effects-1/`); Bricks Academy Custom Code (`https://academy.bricksbuilder.io/builder/features/custom-code/`). Both are saved in scratch after successful retries. They explain the graph/region and Code/SVG security contract; neither establishes installed acceptance. Local reference sources: `reference/bricks/README.md` (historical copied-sample/builder observations) and `video-schema.json`2.4.3 (`_cssCustom` string/code). No remote theme PHP/private package was fetched.

## Minimal actual gates / next decision

1. **Failed transport gate:** do not build1A. Ask parent whether to approve a **new bounded1B planning/investigation scope** (not implementation or permission changes); same-document controls justify studying it, not silently adopting it. Preserve snapshot decision unless a new decision reverses it.
2. For a newly approved route, establish supported installed save/copy-back/CSS acceptance and a general responsive bounds/cost contract. Ask for source-scope expansion only where evidence requires it; do not default to arbitrary padding or shared/adapt edits.
3. Resolve pill-clip's active `paint.ts` ownership before any implementation. Preserve hero branch `46c17a58bbb7d7959f7ffba06038e07f27b876b8` and R1 half-sigma. At investigation, main is9f9b751/build2026-10-21.19; no repository/worktree source/build/commit changed, only expected main mutable debug and hero untracked `.superpowers/` existed.
