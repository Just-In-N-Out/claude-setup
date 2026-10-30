# List, CSV and upload-panel validation

Use this procedure when planning, building or reviewing asynchronous list/PDF panel changes. These are acceptance probes, not evidence that a proposed implementation already passes.

## 1. Freeze observable contracts

Read the approved plan's connection, cancellation, cache, removal and separator rulings. Identify the real panel wiring, plugin store and shared upload API before choosing tests. Preserve shared API signatures unless explicitly authorized; prefer deferred offline REST responses over real uploads. Keep secrets out of logs and snapshots.

Write each expected transition as request → state change → permitted side effects. Include queued files, the request already sending, cached results, saved list addresses, picker readiness, Convert blocking, status text and Cancel visibility.

## 2. Exercise connection freshness with multiple files

Start a batch of at least three distinct files and defer the first upload response. While it is in flight, separately test:
- a failed connection test;
- an edited site address;
- edited user or credential settings;
- a newer upload or Convert run.

Resolve the old response, then assert exact POST destinations/counts, list-save messages, cache reuse and current UI state. Under a stop-on-invalidation contract, queued files must not start and the stale pick must not save addresses; the already-sent request may settle into the site-scoped cache without abort or retry. Assert both immutable per-pick settings and continuing authorization: a snapshot alone prevents destination drift but does not prove permission to send the next file.

Test overlapping connection checks in both completion orders. An old successful check must not enable pickers for edited settings after their newer check failed; an old failure must not overwrite a newer valid success. Test settings edits without another check as well.

## 3. Prove cancellation and normal completion independently

Cancel one pick while another list remains active. Assert that blocking counts release exactly once, the other pick still blocks Convert, and stale completion cannot clear the newer pick's note or ownership. Pick the same bytes again while the first request is sending and verify a single POST with site-scoped reuse. Separately assert normal completion hides Cancel; cancellation tests do not cover that state.

Use mutations that remove the per-pick settings copy, ignore invalidation, double-release ownership or leave Cancel visible. Label surviving equivalent mutations separately from missing coverage.

## 4. Verify removal text against real stored state

Run Remove PDFs → Remove spreadsheet without Convert between them. Inspect plugin-store contents and panel status after each answer; do not accept a browser assertion that merely repeats stale conversion metadata. Exercise failed removals and out-of-order save replies so error text still wins and acknowledgements retain request order. A direct helper probe that never clicks Remove cannot establish the real button's status behavior.

## 5. Separate delimiter mechanics from product policy

For comma, semicolon and tab inputs, test ordinary headers, delimiters inside quoted titles, escaped double quotes, quoted and unquoted ties, and matching body rows. Compare newly accepted formats with previously working CSV controls. Record the approved tie order explicitly; making delimiter counts quote-aware does not authorize changing which delimiter wins an unquoted tie.

Keep file extensions, MIME acceptance and decoding claims separate. Do not label all Excel text exports supported merely because UTF-8 TSV works: inspect UTF-16/BOM/NUL fixtures before claiming Unicode Text support. Record unsupported encoding as a separate finding rather than silently adding a new decoder during a bounded parsing fix.

When a real-byte picker test unexpectedly passes old source, compare the exact selected File's native `text()` and `arrayBuffer()` bytes in the tested browser with the same bytes in Node before changing production. Native decoding can differ across runtimes: a Node reproduction is not Chrome/Figma proof. Preserve the evaluated JS, byte digest, actual onchange, posted message, unchanged store oracle and full-bundle provenance; classify a valid old-source pass as characterization, not a fabricated RED. Respect the original launch cap when a disk-backed diagnostic fails before its observation.

## 6. Close on integrated evidence

- Keep offline no-network panel fixtures explicit about their normal-conversion settings. Every synthetic `init` rebuilds missing settings from defaults: a pending inline picture with the AVIF default can start the existing encoder's glue/Wasm downloads before a diagnostic runs. Preserve the trap failures and trace their stacks; retain the intended Original-file fixture setting rather than disabling traps or changing production conversion behavior. Wrap repeated CDP evaluation locals in an IIFE because top-level lexical declarations can persist across calls in one document.
- Pictures from outside Figma (website captures) arrive as SVG, AVIF and WebP; Figma only ever hands the panel PNG/JPEG/GIF, and `src/ui/files.ts`'s sniff labels any unknown file PNG. `env.decode` (createImageBitmap) refuses SVG: draw it as an `<img>` from a `data:image/svg+xml;base64` address onto a canvas (untainted even at a null origin). AVIF decodes but is ~12x bigger as PNG: recognise it, don't redraw it (web-panel planner).
- Separate main-output focus preservation from a diagnostic control's native disabled-button behavior. A browser may blur a focused button when the request disables it. Keep exact paste bytes/textarea selection/ordinary status-controls-settings assertions and forbid the diagnostic from focusing the main output; test Tab reachability after settlement without inventing a requirement to override native blur.

For a live diagnostic, separate the panel's current display from the conversion that produced the failing payload. A detected action label and displayed PDF filename establish visible assignment, not the source URL/role at emission, current output metadata, native clipboard contents or installed behavior. A Copied status does not establish that later file assignments were included in that conversion. Record the screenshot's visible build and selection as current observations; do not use a newer banner to identify an earlier capture or infer that the user reloaded. Reuse received screenshots and payloads instead of requesting them again or replacing an already-assigned PDF. Ask for further evidence only after naming which unresolved boundary it can discriminate; when original source is required, a screenshot-only request cannot satisfy that requirement.

Before broad gates, map and exercise the real picker → plugin store → reconversion → emission → final-panel → copy path, not only core conversion or an upload helper. Cover both a PDF address already present in the source and one supplied by the real picker/store flow. Establish where that stored address enters conversion before assuming a post-emit rewrite: panel-supplied addresses can be assigned before emission. Inspect the root anchor's href, new-tab/rel fields, download/custom attributes and existing attributes at each relevant transition and in the final serialized output. Trace actual writers before choosing emit versus a binding step; an emitter-only fixture proves neither the real assignment order nor final-copy preservation. Require unchanged prose, picture/vector and ordinary-link controls.

Keep four proof levels distinct: converter output; real final-panel serialization/copy-attempt payload; native clipboard readback; installed paste/save/copy-back and live DOM. Intercepting a copy handler or reading its textarea establishes the attempted payload, not a successful native copy; a stubbed or false-returning `document.execCommand('copy')` does not verify clipboard contents. Preserve that limitation rather than calling the attempt a clipboard round trip. Use the matching payload → saved Copy JSON → live-anchor decision table in `references/link-validation.md` for installed failures; do not claim a particular writer is faulty without a reproduction.

Retain RED evidence and selective mutation results. Rebase onto actual main and repeat required full gates, checking action words, data cells, final PDF link/download settings and unchanged designs. Keep policy-dependent cases deferred explicitly; passing upload tests does not prove final clipboard semantics, installed retention or a separator-policy decision.
