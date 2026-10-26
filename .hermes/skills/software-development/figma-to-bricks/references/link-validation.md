# Native, inline and PDF link validation

Use this procedure when planning or reviewing changes to generated link destinations, tab behavior or file downloads. These are validation steps, not a claim that an unresolved implementation is supported.

## 1. Freeze the navigation contract

1. Record the selected Figma action, semantic source role, emitted Bricks kind, destination, target/rel and intended action: same-tab navigation, new-tab viewing or download. Compare the broken element with a working sibling.
2. Write explicit unchanged controls: inline prose, whole-linked text, linked pictures/vectors, ordinary pages, other document types and telephone/email links. Preserve the approved distinction between a structural download control and a viewing link.
3. Establish the page origin, direct destination and actual redirect chain with read-only requests. Keep old saved-page state separate from current converter output; changing the converter does not repair an already-saved paste.

### Establish destination identity before repairing matching

1. Identify the expected WordPress entry from accessible page inventory: retain its ID, original title, slug, parent, returned canonical `link` and visible publication status. Preserve original strings alongside any normalized comparison keys. A page-list title does not reveal its permalink, and similar quote/dash characters alone do not establish a normalization defect.
2. Trace the exact reported CTA through source action/target, core output, panel inventory match, copied payload and published anchor. Compare a working sibling at the same boundaries. Bind retained historical inputs and REST answers to their capture provenance; do not silently treat them as the current page or connection state.
3. Follow the actual public mouse or keyboard navigation, retain redirects and final URL, then check the final page's identity using its canonical address, page ID when exposed, heading and relevant content. Reject a generic page, attachment, soft 404 or neighboring service even when it returns HTTP 200. A locally served navigation probe proves transport behavior, not that WordPress selected the intended page.
4. Separate editor behavior from public navigation: selecting a linked Div inside Bricks may not exercise the frontend anchor. If the public link and expected entry match, report that observed boundary and ask only for the smallest missing artifact, such as the URL after the user's click or freshly copied element JSON. Do not invent a matcher patch to explain an unreproduced failure.
5. Propose a repair only at the demonstrated failing boundary. Verify the canonical match rather than deriving a replacement slug from a title; preserve the approved unmatched-link warning/fallback policy and never fuzzy-substitute a sibling. Include how a corrected conversion reaches already-saved pages, since a converter release alone does not rewrite their hrefs.
6. Keep wrong-page, unavailable-page and wrong-tab acceptance independent throughout review and reporting. An adjacent metadata fix can ship as a clearly bounded result, but must leave the original destination symptom explicitly unresolved until the intended page is actually reached.

## 2. Preserve semantics across output modes

Before choosing eligibility from an emitted kind, trace transformations from the original role through understand and emit. Inline-picture output can turn an image into a Div, so a Div rendered as an anchor is not sufficient evidence of a download control.

Run the same positive and negative fixtures with both `inlinePictures:true` and `inlinePictures:false`, including the panel's actual default. Keep image/vector provenance as a negative control while proving ordinary Buttons and linked boxes still qualify. Add a same-base regression that passes on the old revision and fails on the erroneous classification; do not rewrite the expected result to match the transformed kind.

Trace `_attributes` readers and writers before adding a field. Preserve existing attributes, deterministic IDs, marquee-copy tabindex and relinking behavior. Test attribute-array overwrite, unstable/order-dependent IDs and missing-role guards separately.

Include vector-only frames and masked image groups that normalise collapses into a single picture, plus original and marquee-copy links. Remove the image and vector eligibility guards independently in an isolated source copy: require the corresponding unchanged fixture family to fail while genuine Button/box controls remain green. A single causal revert establishes the combined regression but does not isolate both provenance guards.

When adding tiled/masked source trees to a fixture, finalize the entire tree through the fixture's `snapshot()` builder after insertion: it populates absolute geometry and image metadata. A subtree appended after snapshot finalization can miss mosaic recognition and exercise a structural box instead. Assert the intended normalized provenance (`tiled`/`mask`, image/vector role, actual emitted mode) before judging its no-download behavior; preserve malformed-setup diagnostics separately rather than attributing them to the converter.

## 3. Confirm the Bricks carrier

1. Search copied samples and official schema/docs before inventing a field. The archived Link Control schema has `newTab` and `rel`, not a download key.
2. For a custom attribute, establish which element owns the actual root anchor. For an approved structural download control, use the source-backed custom-attribute carrier: append `{name:"download", value:""}` to `settings._attributes` through the existing deterministic attribute-ID convention, preserving every existing attribute. Do not invent `settings.link.download`. The empty value leaves filename selection to the server/browser; it does not choose a save directory. Verify the serialized payload and DOM; an attribute on a child image or span does not establish anchor behavior.
3. Archive authoritative evidence with its schema version. Mark documented examples as documented, not copied from the installed builder. Treat `reference/bricks/pdf-link-documented.json` as documented-schema evidence, not proof of the installed version's paste round trip.
4. Capture the **actual final plugin clipboard payload after all panel/store mutations**, then paste, save, copy the whole affected element back and inspect the live anchor. Bind each artifact to the selected element, plugin build, destination and capture time. Core output and a local renderer cannot prove the final clipboard contains the fields, and neither proves installed Bricks retains them. Include both an address present during core conversion and one assigned later through the real panel workflow.
5. For a failed live paste, compare ordinary, timestamp-query and (when authorized) read-only `LSCWP_CTRL=NOCACHE` responses with exact request times, raw cache headers and label-selected anchor attributes. A timestamp is not a guaranteed bypass; LiteSpeed documents NOCACHE as Admin-IP restricted, so infer execution only from the actual response, not the query name. Explicit no-cache/private/no-store and CDN DYNAMIC headers strengthen the comparison without proving admin configuration or every origin-cache layer. If both cached and fresh/no-cache responses omit `download`, stop treating repeated purges or replacement PDF uploads as the next diagnostic step: request only the saved whole element's Copy JSON, not its icon/label or a full page export. Its missing field does not yet prove Bricks dropped it; compare the matching pre-Bricks final clipboard payload. Re-pastes/purges can happen mid-check; reselect by visible label, retain changed IDs/WordPress modification times, and rerun the actual click against the updated page before reporting its behavior.

### Locate the first missing-field boundary

1. Parse the supplied file locally, for example with `json.loads(Path(path).read_text())`, rather than loading a full page export into chat or judging an excerpt. Filter `content` for linked elements, reconstruct labels from their child IDs, and return only the affected root's complete `settings`, relevant children and compact capture receipt. Count matches programmatically; inspect every candidate before asserting there is only one. If the whole file is malformed, distinguish a separately parsed complete element from a valid whole payload; do not silently repair unrelated text.
2. Inspect the actual root anchor's `settings.link` fields and named entries in `settings._attributes`, preserving child links and unrelated settings. Archive exact supplied values and the input digest; chat annotations such as `@url:` are not established runtime URL corruption and must not be silently rewritten or used to manufacture a predicate failure.
3. Record where the user says the capture came from. Do not infer Bricks-origin copying merely from `source:"bricksCopiedElements"`, `sourceUrl` or the Bricks `version`: the plugin also emits that interchange envelope. Distinguish user-supplied direct-plugin output from tool-observed native clipboard readback.
4. Correlate captures by label, destination, structure, build and capture time as well as IDs. A new conversion or paste can change IDs; identify it as a new capture rather than pretending it is the exact failed run. Establish absence at each observed boundary without assigning an unobserved loss transition.

| Evidence from matching captures | Next diagnostic boundary |
|---|---|
| Saved Copy JSON lacks fields; final plugin clipboard is unknown | Inspect the actual final clipboard output; do not blame the importer yet |
| User-supplied pre-Bricks plugin output already lacks fields | Verify the producing runtime/build and real assignment/eligibility path; this capture does not implicate import/save or a live cache |
| Core output contains fields; final clipboard omits them | Trace the demonstrated post-core transition, relinking and serialization writers; do not assume all panel assignments occur after emit |
| Final clipboard contains fields; saved Copy JSON omits them | Investigate import/save/copy behavior; inspect the live DOM to distinguish copying from frontend retention |
| Saved Copy JSON contains fields; fresh live anchor omits them | Investigate publication/rendering and evidenced cache layers |
| Actual anchor contains fields; click still fails | Exercise the browser/response/redirect/handler boundary below |

Once a supplied artifact establishes one boundary, do not request it again. Reuse the saved audit and passing probes, then delegate one focused discriminator at the first unresolved transition before commissioning another full converter/corpus cycle; repeating green upstream fixtures cannot explain a contradictory user capture. Pass the attachment path and compact parsed evidence, not the whole export, to the diagnostic owner. Keep candidate causes labelled hypotheses until the matching boundary is reproduced, and retain a failed live outcome even when the source release is independently verified.

When supplied plugin output contradicts current-source probes, resolve producer identity before choosing the next source check:

1. Distinguish bundles currently on disk, the plugin currently running in Figma, and the runtime that produced the supplied capture. A reproduced bundle proves disk contents, not the active producer; coexisting development registrations prove availability, not which one ran.
2. Preserve the still-displayed failed conversion before any reload, reopen, Convert or Copy. Inspect its visible build read only if accessible; otherwise ask only for that observation. Record whether the user identifies it as the same still-open producing instance. A newly opened instance cannot retrospectively identify an older capture.
3. Consume a supplied same-instance banner answer once: record the version and user-reported provenance, remove the obsolete build question, and retain any unverified runtime-byte identity separately. Agreement with the on-disk build label is not a bundle-hash verification or a demonstrated cause.
4. If the reported producer build agrees with the audited build but fixtures still disagree with the user capture, inspect the actual source role/provenance, URL at emission and real final-output path. Do not repeat generic passing fixtures or reconstruct an alleged original Figma snapshot from the final Bricks tree: emitted kinds omit source semantics, so that reconstruction cannot establish the original eligibility decision.
5. If indispensable actual input remains unavailable, state that precise gap and request one supported evidence action, checking first whether it preserves the failed state. Keep the cause unresolved rather than presenting a stale-build hypothesis or speculative patch as a fix.

## 4. Probe browser behavior before choosing the route

Serve a small valid PDF from local HTTP endpoints with the relevant content type and response headers. Treat HTML served at a PDF-shaped path only as a navigation probe, never as PDF-download or installed-Bricks proof. Use two origins, such as separate ports, and exercise this matrix in the exact browser under test:

| Path | Required observations |
|---|---|
| Direct same-origin PDF | Mouse and Tab+Enter; download request/completion; filename and bytes; original page and tab count |
| Direct cross-origin PDF | Accepted viewing fallback; original page remains where promised; new tab and opener isolation |
| Same-origin redirect to same-origin PDF | Final filename/bytes and original-page behavior |
| Same-origin redirect to cross-origin PDF | Actual navigation fallback, not merely retained target/rel fields |
| Unchanged prose, picture/vector and text links | No newly introduced download; original viewing/navigation behavior |
| Non-PDF control | Existing navigation and no unintended download |

Do not infer redirect behavior from the direct-origin cases. A download attempt that redirects across origins can navigate the originating page despite `target=_blank`; reproduce the exact chain in headed and headless modes when it changes the product contract. Bound feasibility claims to the variants and browser versions actually tested: an unsuccessful declarative matrix does not prove that every HTML-only route is impossible. Before proposing a supported-subset release, check the user's actual file with read-only requests and distinguish a presently direct response from the redirect-triggered limitation; a direct response today does not guarantee future hosting/CDN behavior. Preserve the failed receipt and hold release for an in-scope correction or an explicit limitation decision. Do not present server changes, JavaScript fetching or a new Code element as an already-approved fix.

Do not assume headed and headless PDF behavior agrees in either direction. Test both when download-versus-view decides the mechanism. Record the browser version in evidence and report unrun browsers as unproved.

### Trust completed downloads, not directory noise

- Correlate `Browser.downloadWillBegin` and `Browser.downloadProgress` by GUID; require the relevant GUID to complete and identify the actual saved file.
- Check the suggested filename, saved filename and exact served-versus-saved bytes or SHA-256. Chrome download behavior `allow` preserves the ordinary server-derived filename; `allowAndName` can instead name the file by GUID.
- Ignore viewer-created `downloads.html`/`.crdownload` stubs as success signals. A file appearing in the directory without a matching completed PDF event is not proof of a download.
- Assert current-page URL, new page targets and opener accessibility independently of the download event. Retaining `target` and `rel` in HTML is not proof of fallback behavior. For a claimed no-opener tab, attach to the actual opened page and evaluate `window.opener === null`; target metadata such as `canAccessOpener:false` is supplementary, not the same assertion. If the opened target cannot be inspected, retain that limit instead of promoting metadata to an executed opener check.

## 5. Prove the harness and preserve evidence

1. Pin exact base and candidate revisions and use identical snapshots and conversion options. Compare the complete conversion result, not only selected anchors or the payload subtree: strip only the approved added link attributes, then deep-compare everything else, including link/page metadata, warnings, ordering and existing attributes. Identify each changed anchor by stable source identity and emitted kind across both picture modes and copies; aggregate anchor counts alone can hide a changed owner. This catches unintended href, style, index or metadata changes while proving the intended controls still gain the attribute.
2. Inspect the renderer at those revisions. It must copy actual payload fields, not synthesize `noopener`, `download` or tabindex in a way that hides a missing or misplaced setting.
3. Kill missing-download and misplaced-attribute mutants with independent DOM, mouse and keyboard assertions. Retain unaffected controls so a broken harness cannot make every case fail.
4. Preserve original logs, probe scripts, request/redirect receipts and failed collectors separately from corrected runs. If the collector mistakes viewer scratch files for downloads, correct the collector and rerun both modes without erasing the invalid result.
5. Return text proof for a behavior-only fix: source role and emitted kind → href, target, rel, download → observed tab/navigation/file outcome. Keep local browser proof, installed paste/copy-back and live-site acceptance separately labelled.

### Qualify source-independent raster differences without waiving them

- Predeclare a bounded alternating base/candidate/base/candidate schedule per failing input, using one active page, exact full-HTML equality, the unchanged capture policy and complete expected-font observations. Retain every primary pair and unchanged-source pair; do not retry until a convenient pair matches.
- When fresh captures introduce additional raster differences, retain whole-page receipts and compare the original changed-channel support separately. An unchanged base reproducing those original channels supports source-independent attribution, but does not make a nonmatching full-page control equal. Name the additional differences and keep the strict primary full-page assertion red when it still fails; crops, later matching pairs and channel-support attribution are supplementary, not acceptance replacements.
- Decode Node TAP's escaped hash characters in retained diagnostic comment lines before JSON parsing. A reader-only correction does not justify rerunning the browser or replacing its original raw log.
- For a capture-readiness hypothesis, predeclare a same-document full-page primary/repeat pair separated by a fixed bounded frame barrier, alongside unchanged-source reload controls. Record document identity, viewport and complete fonts; preserve every first capture. A differing repeat localizes raster instability within one document, but combines capture/readiness effects and does not prove the barrier is a repair. Later equal captures must not replace a red first-pair gate or become a discard-first/retry-until-green policy without separately scoped causal qualification.
