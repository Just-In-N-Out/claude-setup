# Missing-font capture recovery (read-only planning)

Use this procedure when honest expected/missing diagnostics expose a font absent from both old and new captures. This is not standing approval to acquire, install, upload, substitute, or change release policy.

1. Preserve original reports, complete HTML and payloads. Match whole-HTML hashes before attributing any measured change to converter code.
2. Reproduce the gap with one sequential Chrome page and a narrowly chosen width. Inspect direct visible text and positive geometry; use CDP `CSS.getPlatformFontsForNode` to distinguish actual fallback glyphs from a merely declared computed family. An empty failed set does not prove completeness.
3. Trace original configured debug node and styled-run family/style/weight through snapshot upgrade and normalization. A strange weight already in the raw export is provenance, not proof of a new converter bug; do not silently normalize it as part of font recovery.
4. Inventory only explicit project asset paths and configured font references. Exclude unrelated user/system font directories and app caches. A bounded inventory finding no asset is not proof the user owns none.
5. Read primary foundry/catalog metadata and the actual license. Similar family names may identify different vendors/versions. Publicly served bytes, an available trial, or a desktop license label do not establish permission for private browser embedding, automated captures, CI, redistribution, or production use. Treat uncertain entitlement as a stop.
6. Ask for one smallest missing bundle: the intended font file or exact project-owned location plus source/entitlement for the proposed capture use. Do not request a whole font folder or buy an unidentified face.
7. After explicit approval, preflight capture-only provisioning without OS/site changes. Preserve genuine face descriptors and requested source values; verify actual glyph supply from the approved asset rather than making a same-name alias to an unrelated face. Leave the observer, expectations, comparability logic and CLI exit branch real.
8. Keep a fresh-context absent/broken/wrong-family negative control. A successfully loaded but unused face is not sufficient proof.
9. Recapture both saved before/after HTML under one matched policy at every affected retained width. If the CLI compares with v1, recapture the original v1 HTML too under the same policy rather than ignoring a now-different loaded-family set. Label these matched-policy recaptures; never overwrite original incomplete evidence.
10. A substitute is a separate explicit altered-fidelity decision. Prove its actual full stylesheet request and glyph supply; do not relabel it as the intended family. Mapping changes HTML, so compare policy-rendered twins and enumerate those deltas separately from original HTML equality.
11. A diagnostic-only release split is also a separate policy decision. It cannot make the unresolved font failure green or satisfy an unchanged release gate.

Keep asset/license identity, requested-family status, physical glyph supply, same-policy comparability, and release approval as separate claims. Complete focused proof before expensive browser/corpus gates; require fresh independent review before release.
