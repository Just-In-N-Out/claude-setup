# Link and upload fixes (B2: link-upload-fixes)

**Approved by Justin 2026-10-21** (answers L1A L2A L3A, all ⭐).

**Status: merged and pushed as 2026-10-21.11, 6ba11f5 (2026-10-21).** Approved L1A/L2A/L3A. Continued the existing builder → fresh reviewer → finisher pipeline after frame-text-links; both fresh review findings fixed test-first, rebased/gated on main .10 (2dd96eb), locked ff-only merge, rebuilt and pushed main. Permanent plan/ledger/proof in `docs/plans/2026-10-21-link-upload-fixes*`. Paste check **3al** owed; 3aj is Google partial fonts and 3ak text-breaks. No live-site writes. B2 CLAUDE.md write denied; exact pending edits `link-upload-fixes-claude-md-pending.md`; prior .9/.10 pending files untouched and not applied. The original planning baseline below remains history, not current state.

Loaded **figma-to-bricks (PLANNER)** and **systematic-debugging** first, then the rules summary, relevant CLAUDE.md sections, memory, link-hrefs plan/ledger and HANDOFF. BUILD and git agree on `.4`; CLAUDE.md's opening build line still says `.2`, so its old status is not the baseline.

## Open questions

The plan below is written as if each ⭐ answer is chosen. These are approval choices, not instructions for an agent to change the live site.

1. **Old pages still holding guessed links: how should we repair them?**
   - **A ⭐ Re-convert and re-paste pages with old links.**
   - B Plan site-side redirects as a separate job.
   - Why A: a new paste can use the exact page address. Renaming a picture cannot reliably fix links already saved in Bricks. B needs a separate site-side design and permission; it is not a small plugin patch.
2. **Should “inside the JSON” change old WordPress media?**
   - **A ⭐ Rename own media only in WordPress picture mode.**
   - B Rename in both modes; still stop queued work on Cancel.
   - A changes link-hrefs' earlier “every Convert, either mode” behaviour. It still reads pages/media and fixes the new paste's links in both connected modes; it only limits media writes. Cancellation always stops new repairs.
3. **An attachment-ID link hides whether it is a picture or PDF.**
   - **A ⭐ Drop ID links; use direct URLs for documents.**
   - B Resolve IDs and keep documents in a separate follow-up.
   - Under A, positive `?attachment_id=123` links are left off with an honest “attachment type unknown” note, including PDFs hidden behind that form. Direct `.pdf` and other ordinary document links stay. This conservative exception needs approval; do not pretend an ID proves the file is a picture. B is larger: credential-safe lookup, offline behaviour and document restoration, rather than just closing a filename guard.

## Request played back

1. Keep links from opening pictures, including less common media formats and WordPress's attachment-ID addresses.
2. Make uploads keep their safe `-image` / `-video` address even when a JPEG contains a different title.
3. Stop saying a link or picture address was fixed when it was not. Make the instructions for already-pasted pages reliable.
4. Do not change someone else's media. Do not start a media rename after a run is cancelled; with Q2A, an inside-JSON conversion only reads the site.
5. Turn the existing paste checker into a real production guard, and add the missing path tests. No layout, arrow detection, typography or font-policy changes.

## What was checked, before choosing fixes

### Tight feedback loop

Ran on the unmodified main code:

```sh
node --test test/unit/ui-site-read.test.ts test/unit/ui-site-pages.test.ts test/unit/ui-wordpress.test.ts test/unit/normalise-file-links.test.ts test/unit/payload.test.ts
```

**55 tests passed.** They do not catch these gaps. A separate scratch-only probe, importing the actual main modules and replacing `env.fetch` with in-memory answers, ran **14 assertions: 13 expected failures and one passing R5 control**. It observed:

- upload query `slug`: missing;
- a shared post/media slug: `kept === true`, followed by contradictory notes;
- unchanged or missing rename-result slug: `freed === true`;
- attachment-ID plus all five listed missing extensions: guard returns false;
- inside-JSON run: one rename POST; cancelled run released from a deferred media GET: one rename POST;
- invalid final paste: `payloadProblems` detects it, but `startRun().done()` returns it;
- unattached media whose `link` is a file: root slug counts, unrelated nested slug does not. That guard is currently correct.

Re-run command while the scratch file exists:

```sh
node /Users/justin/.hermes/cache/scratch/b2-link-probes.mjs
```

It intentionally exits 1 on current main. Its assertions are investigation, not committed regression tests or an implementation. Builder writes permanent tests first and sees them fail before fixing. Scratch evidence lives in `/Users/justin/.hermes/cache/scratch/b2-link-evidence/` and is temporary; refresh the GET captures during the build and retain the useful red/green proof in the ledger.

Ranked hypotheses checked: (1) safe filename never reaches WordPress's slug field; (2) `served` wins over known media occupancy; (3) rename success is assumed from a fulfilled request; (4) media repair is outside run cancellation/mode policy. Each predicted the observed seam above. No layout hypothesis was needed.

### The user's debug JSON: working siblings versus broken card

Read, never edited, the on-disk `figma-to-bricks-debug-page-1.json`: build `2026-10-20.6`, frame **Hydraulic Cylinder Repairs Final**. The four service cards all have only hover reactions and no click/text hyperlinks. The Rods card is structurally like the Remanufactured, Core and Assembly siblings; the different destination/site state, not a misplaced Figma hyperlink, explains the failure.

Main's conversion lists each card's own element and title-derived path:

| Card | Core address |
|---|---|
| Remanufactured | `/remanufactured-hydraulic-cylinders/` |
| Core Exchanges | `/core-exchanges/` |
| Rods | `/rods-1-15-rechroming-rods/` |
| Assembly | `/assembly-test-paint-delivery/` |

Do not alter card selection or hard-code these names/IDs. Generic fixtures must prove the rule.

### The live site has changed since the October 20 report

Read-only GET evidence from `darksalmon-badger-335429.hostingersite.com`, October 21:

| Exact target | Observed |
|---|---|
| Media 647 | Already renamed to `rods-1-15-rechroming-rods-image`; original PNG source URL unchanged; `post: null` |
| Media 514 | Already renamed to `remanufactured-hydraulic-cylinders-image`; original AVIF source URL unchanged; `post: null` |
| Hydraulic page's Rods card | Already points directly to `/rods-1-15-rechroming-rods-final/` |
| Remanufactured and Core pages' Rods cards | Still point to `/rods-1-15-rechroming-rods/` |
| Plain old Rods path | 301 to the PNG; `X-LiteSpeed-Cache: hit`, `X-Redirect-By: Yoast SEO` |
| Same Rods path with fresh query | 301 to the actual Rods page; cache miss, redirected by WordPress |
| Plain old Remanufactured path | 301 to the AVIF |
| Old Remanufactured path with fresh query | **404**, although the published page exists at `/remanufactured-hydraulics-cylinders-final/` |

Evidence: `live-get-summary.json`, `redirect-headers.json`, and the saved page/REST responses in the scratch evidence directory. These are observations, not permission to purge caches or create redirects. They prove **a renamed attachment and repaired old links are different outcomes**. Do not repeat the old claim that media 647 still needs renaming today.

## Item-by-item root cause, fix and test

### R1 — Metadata can undo a safe upload filename

**Root cause.** `src/ui/files.ts:30–32` makes a suffixed filename, and both upload/fallback calls use it (`src/ui/uploader.ts:74,82`). But `src/ui/wordpress.ts:106–112` sends only the file headers/body and optional alt text, not `slug`. WordPress's attachment insertion uses EXIF/IPTC title defaults; the posts controller accepts an explicit slug as `post_name`. A suffixed filename alone does not control that field.[1][2]

**Fix.** In the shared `uploadMedia` request, explicitly send `slug` equal to the **actual transmitted filename's stem**, alongside any `alt_text`. Preserve the JPEG metadata/title, file contents, source URL, timeouts and alt handling. The caller already supplies `…-image.ext` or `…-video.ext`: do not add a second suffix, or give videos `-image`. Include pretty and query-style REST routes.

**Test.** RED request assertion for original JPEG with an unrelated metadata title: upload name `cleaning-image.jpg`, requested slug `cleaning-image`, metadata-derived title irrelevant to the requested slug. Use a source-backed stand-in for the title-vs-slug rule, not a pretend real WordPress upload. Cover no alt/with alt, video `-video`, and the existing original/WebP-refused/SVG-fallback upload routes. Do not upload anything to the user's site for this proof.

### R2 — A shared slug can preserve a picture link, with a false note

**Root cause.** `src/ui/site-read.ts:154–156` gets `served` and `held` independently. In `src/ui/site-pages.ts:108–109`, an unpublished match plus a served post/archive keeps the original address even when `held` says that exact address still belongs to media. The returned `picture` is hard-coded false whenever a page match exists. Notes at `:170,175` can consequently say both “kept, already opens” and “this link goes to its page” for a link still opening a picture. The scratch probe reproduces this exact combination.

**Fix.** A known, unfreed media holder disqualifies the original address from the keep-post/archive exception. Use the matched page's separate real/future address; if the chosen address itself remains known to be a media address, leave the link off instead. A real draft stays clearly labelled as a draft, not as a working published page. Apply the same decision to element links and frame-text-links' newly supported run links. Notes and counts must derive from the final decision, not just “a page was found”. Preserve valid post/archive keeps when no media blocks the path.

**Test.** RED shared-slug matrix: other person's media, refused own rename, verified rename, draft target, published target, and no target. Assert final href or plain words **and** mutually consistent notes/counts. Include a served post without media as the unchanged control. If a fallback destination differs from the original path, inspect that candidate's media occupancy too; do not just reintroduce the same issue at a second path. Do not rewrite unrelated typed URLs when frame-text-links' origin markers exclude them.

### R3 — Freeing an address does not reliably repair old pastes

**Root cause.** No code rewrites the saved Bricks pages or installs a redirect. `site-read.ts:110–115` and `site-pages.ts:165–173` nevertheless promise that a freed/guessed address opens its named page. HANDOFF `:2682–2687` bases the promise on WordPress's 404 guess. That function can be disabled, uses a loose slug prefix by default, and selects an ID without an ordering clause.[3] Today the fresh old Remanufactured URL actually returns 404; its singular `hydraulic` is not the published page's plural `hydraulics`. The saved redirects additionally show a cache hit can still open the picture after the REST slug changed.

**Fix, Q1A.** Keep writing the actual matched page permalink into **new** pastes. Stop claiming media renaming repaired old pages. Whenever a link changes from guessed to matched, say the new paste uses the real address and older pages using the old address need re-converting/re-pasting. This note must still appear after the media was renamed in an earlier run and is no longer returned by the current slug lookup. “Address freed” means only that the attachment moved, never “all old links fixed”. Missing-page notes say the guessed address may not work until a page exists **at that exact address**, otherwise convert again after creating/publishing the page. No new redirect code, page writes, SEO-plugin changes, cache purges or site credentials in this batch.

**Test.** RED notes for a renamed attachment, an attachment already moved before this run, a matched page with a different spelling, missing page and draft page. With redirect guessing disabled and with two similarly prefixed pages, the new paste still uses the exact selected canonical permalink; tests never model a rename as automatically rewriting existing page hrefs. Explicit acceptance: old saved href remains old until Justin re-pastes it. Document those user steps, not an unverified “Convert alone fixed it”.

### R5 — Unattached media's root-only path lacks a discriminating test

**Root cause.** This is a **coverage gap**, not a proven production defect. `src/ui/site-read.ts:98–104` already limits `post: null/0` to a one-part path when the media's own `link` does not match it. Existing cases do not sharply distinguish a bare root slug from an unrelated parent path with the same final slug. WordPress's path lookup verifies complete ancestry, not only the last slug.[4]

**Fix.** Keep the working rule. Add focused tests before changing/moving it. If the media helper moves, retain its semantics, including an exact own attachment permalink and the documented missing-fields fallback.

**Test.** A media item with `post: null` and its `link` pointing to its file: `/<slug>/` holds it, `/unrelated/<slug>/` does not. Repeat for `post: 0`, own/unowned items, trailing slash, and a page-attached item's exact parent permalink versus unrelated/root paths. Unattached media cannot match an unrelated nested path merely because its last segment matches. Kill explicit local mutants that remove `top`, make it always true, or compare only the basename; keep these mutation edits inside the approved worktree, restore them immediately. Do not claim all 41 historic mutants were rerun without their actual list/results.

### R6 — A refused or ignored rename is counted as done

**Root cause.** `wordpress.ts:146–148` treats a successful HTTP reply with no slug as the requested slug. `site-read.ts:137–138` sets `freed = true` for any fulfilled result, even the old slug. There is no exact-item readback. The probe reproduces both unchanged-slug and missing-slug false successes.

**Fix.** Keep the per-site/per-media `oneAtATime` queue. After an allowed POST, GET that exact media ID and verify its actual slug/permalink/parent no longer occupies the old protected path before marking it freed. Do not synthesize the desired slug from an incomplete reply. A collision suffix such as `-image-2` is accepted if confirmed safe; unchanged/invalid data or failed readback is “not verified”, never “freed”. Name refusal, ignored change and verification failure accurately. A failed readback must not trigger a blind repeat POST: the earlier write may already have happened. Serialize the write/readback together so an alt update cannot race the verification.

**Test.** RED POST 200 with unchanged slug; missing slug and unchanged GET; returned new slug but unchanged GET; malformed/wrong-ID readback; failed GET; real refusal; and confirmed suffixed slug. Assert freed count, final link decision, exact-target GET and retained file URL/id/alt. Confirm the queue still releases after failure and other media IDs do not wait behind it.

### R7 — Some media addresses pass the filename-only guard

**Root cause.** `src/core/normalise/links.ts:22–43` has a finite extension list and inspects only the pathname. It misses `.ogg`, `.jfif`, `.apng`, `.avi`, `.mkv` and positive attachment-ID query forms. The existing tests at `test/unit/normalise-file-links.test.ts:23–28` only cover the old list.

**Fix.** Extend the shared guard for those suffixes, case/encoding/query/hash handling intact. Under Q3A, recognize a positive numeric `attachment_id` query even on a URL with no file suffix; zero, malformed IDs and an ID appearing only in the fragment do not establish an attachment address. Use a distinct note for opaque IDs: their media type is unknown, not proven to be an image. `.ogg` is an ambiguous media container, so avoid a note falsely claiming its precise type. Do not broaden this into blocking all query-string URLs, all downloads or every audio format. Direct PDFs, office files, normal pages, `?page_id=`, calls, emails and anchors remain controls. A video source address is not a navigation link and must remain usable.

**Test.** RED generic Open-link and text-run fixtures for every added suffix, mixed case, encoded filename, relative/absolute ID URLs, ordinary query parameters around the ID and `&amp;` in emitted HTML. Include document and navigation controls plus video-source controls. The final payload validator must use the same classification. No Figma layer-name or site-specific branch.

### R8 — Mode and cancellation do not govern media repairs

**Root cause.** `src/ui/run.ts:72–74` starts `checkLinks` whenever WordPress is connected, independently of the `upload`/pictures-mode gate at `:42–43`. That check performs media POSTs in `site-read.ts:135–138`. `run.cancel()` at `run.ts:91–94` stops only the describer/uploader: it neither cancels the link task nor gives it an active-run guard. The deferred-GET probe confirms a rename starts after cancellation; the inline-mode probe confirms another rename with no upload mode selected. There is no new user-facing Cancel button to add here: this is the existing run cancellation/error path.

**Fix.** Under Q2A, pass a deliberate read/repair policy through the link task, keep matching read-only in inline mode, and make every queued media write recheck the run's active flag immediately before sending. Distinguish skipped work from refusal or missing ownership. Already-sent requests cannot be undone. The precise bounded cancellation contract is below under Task 2.

**Test.** RED inline-mode no-POST test and deferred-GET/queued-write cancellation tests; GREEN no newly started repair after cancellation, no success note for skipped work, and no copyable Outcome from a cancelled run. Keep a normal active WordPress-picture repair as the positive control.

### payloadProblems — The checker never guards production output

**Root cause.** Source search finds only the definition at `src/core/emit/payload.ts:52`; all callers are tests. `src/core/convert.ts:34–49` returns the emitted payload, and `src/ui/run.ts:146–177` returns its post-processed payload without checking it; `src/ui/main.ts:210–213` serializes/enables/copies it. The probe sends a structurally valid six-letter-ID payload with `/photo.png`: the checker reports it, the real run still returns it.

**Fix.** Add one shared assertion helper around `payloadProblems`, with a useful bounded error message. Invoke it after core emission, and on the final panel payload **after** assets, font additions and relinking, before returning an Outcome that can be copied. No partial/corrupt paste and no silent removal of arbitrary layout errors. Normal link filtering still removes known bad links with notes; the final guard catches anything that leaks through. Retain `makePayload` as a constructor usable by negative tests; do not make intentionally malformed test construction impossible.

**Test.** RED real `startRun().done()` rejection for a bad final file link, bad rich-text href and one structural error; GREEN valid payload returned normally. Test assertion helper failure details and core valid conversions. Browser proof: after Convert begins, a rejected final payload is not copied, “Copy again” stays disabled, and a useful failure is visible. Existing main.ts error handling should suffice; change it only if the test proves otherwise. Repair invalid positive fixtures, not the validator: `ui-run.test.ts:16` currently manufactures `el0` IDs, and `ui-site-read.test.ts:209–212` uses `a/b/c/p`. Give those valid deterministic six-letter IDs and update references. Do not skip the ID/tree checks just to keep fixtures green.

## Build tasks — test first

0. **Wait for frame-text-links; refresh the baseline.** Re-read main, BUILD, HANDOFF and the merged text-link markers/API. Create the feature worktree only after this plan is approved. Copy this plan into it. Run baseline `check`, browser suite and corpus; preserve corpus reports/pastes. The known three old panel naming failures belong to test-cleanup; record whether still present rather than silently accepting new failures.
1. **R1:** write upload-query and fallback-route tests; prove RED; send the explicit filename-stem slug; prove GREEN. No upload-cache invalidation/re-upload.
2. **R5 + R6 + R8:** lock current path guards with discriminating tests; split read-only media inspection from allowed repair into purpose-named `ui/site-media.ts` if needed. Test mode/cancellation/queue/readback cases first, then implement the explicit repair policy and verified result. Keep files near 300 lines; new media tests go in a focused file, not another large addition to the current 292-line site-read test.
3. **R2 + R3:** tests for final destination selection and honest notes; implement media-aware keep logic and exact-new-paste/old-paste wording. Extend the predecessor's element and text-run coverage without losing origin scoping. No site-side repair system.
4. **R7:** write all missing-format and opaque-ID tests; extend the common classifier/notes under Q3A. Assert documents and video sources still work.
5. **Production guard:** final-run negative tests and browser non-copy proof first; add shared assertion + core/final-run calls, and correct only the invalid positive fixtures it exposes. Do not make guard failures warnings that still copy a paste.
6. **Integration and evidence:** run focused tests, `npm run check`, `npm run test:browser`, and before/after corpus comparisons. Replay a scratch copy of Justin's on-disk debug file. Use captured GET answers with **all writes stubbed** to compare baseline vs worktree output, including element and run links. Return a text table of old/new hrefs, upload request slug, rename POST/readback result, notes, and no-POST inline/cancel proofs. No screenshots are required for this nonvisual fix. Preserve baseline code by commit/archive, not checkout edits in main. No corpus file or width gets worse; unchanged visual output is expected.
7. **Review:** all work committed in the feature copy; builder stops at ready-for-review. Fresh Sol reviewer per B2's dispatch assignment. Finisher verifies findings test-first, rebases and re-runs check/browser/corpus before the normal locked fast-forward merge. No merge or BUILD bump by the builder.
8. **Docs & records** — see the final task below.

### Cancellation contract for Task 2

- `startRun` owns a synchronous active/cancelled flag and passes an explicit repair policy. With Q2A, repair is allowed only for an active, connected WordPress-picture run. Connected inline runs still read/match links.
- Check permission immediately before every POST, **inside** `oneAtATime` after earlier work has finished, not just before queuing it. A cancelled read or queued repair cannot later start a mutation.
- Distinguish deliberately skipped repair from “not ours” or “WordPress refused”; notes must not lie about ownership or permissions.
- Cancel cannot undo a request already sent. Let that operation settle/verify within existing timeouts; report it honestly, prevent subsequent writes and prevent a cancelled run from producing a fresh copyable Outcome. `cancel()` must account for repair work, not only the uploader/describer. No new Cancel button or wholesale upload-abort redesign.
- Deterministic deferred-promise tests: Cancel before media GET resolves; Cancel while repair waits behind an alt update; Cancel after the first of two repair POSTs starts; inline mode with an owned cached picture. Assert **zero newly started rename POSTs after cancellation**, not “an in-flight server write was rolled back”.

## Risks and boundaries

- **Old-paste repair is not automatic.** Q1A deliberately replaces an unreliable promise with re-pasting exact links. Q1B is a separate approved site-side project, not silently folded into this batch.
- **Caches already disagree with REST.** A successful rename/readback is not proof the public old URL is safe. Justin purges LiteSpeed after his paste; checker reads the saved page hrefs and redirect destinations, not merely a success note.
- **Ownership is the existing site-specific upload cache only.** No guessing from filenames, IDs in a fixture or a similar title; no other person's media changes. Already-renamed live 647/514 require no new POST today.
- **Readback can fail after a real write.** Say unverified and request a later Convert; never pretend rollback or retry the write blindly.
- **Q2A and Q3A alter edge behaviour.** They require approval: inside-JSON loses automatic media repair; opaque document-ID links need a direct document URL. Direct PDF links stay allowed.
- **Guard activation can uncover existing defects.** Correct positive fixtures, but if a genuine unrelated corpus emission fails, report it separately and stop/split rather than weaken the guard or start a layout repair in B2.
- **No visual changes intended.** Do not touch CSS, breakpoints, card heights, typography, arrow/title inference, upload encoders or the site's theme.

## Files and pipeline parts touched

All paths below are repository-relative unless marked otherwise. This is the expected edit set; optional edits must be recorded in the ledger.

**Normalise:** `src/core/normalise/links.ts` (guard and accurate notes). Its callers in `normalise/normalise.ts` and `normalise/text.ts` should inherit the shared check without edits; coordinate if the merged predecessor makes a call-site change necessary.

**Emit/core boundary:** `src/core/emit/payload.ts` (shared assertion), `src/core/convert.ts` (assert emitted payload). Preserve the predecessor's emitted text-link format/markers; no emitter redesign.

**Panel:** `src/ui/wordpress.ts` (explicit upload slug, queued verified media update), `src/ui/site-read.ts` (inspection/candidate/repair integration), new `src/ui/site-media.ts` (focused media-path/repair policy if split), `src/ui/site-pages.ts` (matching/notes), `src/ui/run.ts` (mode/cancellation/final guard). `src/ui/main.ts` is read and browser-tested; edit only if its existing rejection path permits stale copying.

**Tests:** `test/unit/ui-wordpress.test.ts`, `ui-uploader.test.ts`, `ui-videos.test.ts`, `ui-site-read.test.ts`, new `ui-site-media.test.ts`, `ui-site-pages.test.ts`, `ui-run.test.ts`, `normalise-file-links.test.ts`, `payload.test.ts`, `corpus-page-links.test.ts`; predecessor's frame-text-link integration tests; `test/browser/panel.test.ts` for the new non-copy regression. Use new `test/fixtures/site-media.ts` for a small stateful write/readback fixture if needed. `test/fixtures/panel.ts` only if a shared positive stand-in genuinely needs a narrow update; no general stand-in audit here.

**Not touched:** extract, understand, style, adapt, renderer, snap tooling. Existing service-grid fixture can be reused unchanged. Runtime BUILD and docs are finisher-only changes listed below.

## Overlaps and build order

- **Hard dependency — frame-text-links:** shared `src/ui/site-read.ts`, `src/ui/site-pages.ts`; shared link metadata/HTML contract in `src/core/emit/page-addresses.ts`, `src/core/normalise/text.ts`, `src/core/normalise/scene.ts`, and potentially its new `src/ui/text-links.ts` (read/retain, not replacements). Shared site-read/site-pages and frame-link tests. Do not build from its current worktree or overwrite its run markers. Start B2 only from main containing that merge.
- **B3 text-breaks:** may build beside B2 after the predecessor. Avoid editing `normalise/text.ts`, typography or text-HTML generation; B2 uses the common link guard. If B3 also needs a shared text-link helper or file-link test, agree ownership before editing. Potential shared `test/unit/normalise-file-links.test.ts` and the predecessor's text-link fixtures, not a known adapt overlap.
- **B1 fonts-cleanup:** primary font files are separate. Potential shared `src/ui/run.ts`, `test/unit/ui-run.test.ts`, `test/fixtures/panel.ts`, `test/browser/panel.test.ts` if its font-note tests touch those seams. Rebase narrowly; keep both the final validation/cancellation and font behaviour.
- **test-cleanup:** definite shared `test/browser/panel.test.ts` and potential `test/fixtures/panel.ts`. B2 owns only new link/guard regressions and required valid fixture shapes; test-cleanup owns the three old naming failures and general WordPress stand-in audit. Coordinate browser-file changes or serialize them; do not mark their found-items fixed in this batch.
- **cta-label-wrap, B4 equal-card-fixes, B5 layout-floors:** no expected production source overlap (adapt/layout/rules versus link/UI code). Shared `docs/HANDOFF.md`, `src/shared/build.ts`, main `CLAUDE.md`, skill rules summary and found-item records are merge-time serial work for every batch. Allocate the paste-check number only from current main.

## Final task — Docs & records

- Copy the approved plan to `docs/plans/2026-10-21-link-upload-fixes.md` (use the actual build-start date if later).
- Start `.superpowers/sdd/<dated-plan>/progress.md`; retain baseline, red/green commands, read-only live findings, mutation evidence, policy answers, review/fix pass and text proof. Move it to `docs/plans/<dated-plan>-ledger.md` at close.
- Update `docs/HANDOFF.md`: a B2 section; correct/supersede the old “Convert alone repairs saved pages” statement; next free **paste check owed**, not a guessed check number. Mark the earlier 3aa repair promise superseded by this check, rather than silently treating it as verified.
- Paste check: reload plugin; Convert the affected Remanufactured and Core pages with WordPress connected; paste/save each so Rods' saved href is the exact canonical page path; LiteSpeed → Purge All. Checker follows those cards read-only and verifies the final destination is a page, not the upload. Hydraulic already has a direct Rods link in the October 21 capture; recheck it, do not claim it still needs repair. Test an actual new JPEG upload only through Justin's normal workflow, checking its REST slug has the safe suffix. Confirm inline conversions do not claim media writes. If a repaste includes existing code, remind Justin about Bricks code-signature regeneration too.
- Finisher bumps `src/shared/build.ts` to the next real BUILD and rebuilds at merge; builder never bumps it.
- Finisher updates main `CLAUDE.md` **Start here** / **Where things stand** and the rules summary after merge: explicit upload slug; verified media move versus old-paste repair; chosen Q2/Q3 policy; operational core/final-paste guard; no automatic redirect guarantee. Respect the protected-file rule and pending-edits path if a CLAUDE.md write is denied. Never stage CLAUDE.md or the user's debug JSON.
- At merge, update `/Users/justin/.hermes/plans/figma-to-bricks/found-else.md`: mark **each B2 item** `~~item~~ ✅ fixed in build <BUILD> (link-upload-fixes)`. For the combined R6–R8 line, strike it only once all three are done. R5 is closed by the measured coverage improvement, not described as a production fix. Leave link R4/test-cleanup and every other batch's items untouched. If Justin chooses a split/defer option, annotate that sub-item instead of marking it fixed.

## Other things found

No additional out-of-scope code bug confirmed. The live cached redirects and the already-renamed media are evidence for R3, not a request to edit/purge the site. The old CLAUDE.md build/status is a records mismatch for the finisher to reconcile with existing pending notes, not grounds to change the planning baseline.

## Primary sources

Fetched the pinned **WordPress 6.8 source**, not a claim about which WordPress version is currently installed on the site. Local copies: `wp-attachments.php` (metadata defaults, lines 327–340), `wp-posts.php` (explicit slug, lines 1378–1380), `wp-canonical.php` (guess/filter/query, lines 918–1005), `wp-post.php` (ancestry, lines 6074–6144), in the scratch evidence directory. The source extraction backend failed; direct read-only source downloads succeeded. Source IDs were registered in `link-upload-fixes-sources.json`; the listing below is generated from that ledger.

```text
Sources:
[1] https://raw.githubusercontent.com/WordPress/wordpress-develop/6.8/src/wp-includes/rest-api/endpoints/class-wp-rest-attachments-controller.php
[2] https://raw.githubusercontent.com/WordPress/wordpress-develop/6.8/src/wp-includes/rest-api/endpoints/class-wp-rest-posts-controller.php
[3] https://raw.githubusercontent.com/WordPress/wordpress-develop/6.8/src/wp-includes/canonical.php
[4] https://raw.githubusercontent.com/WordPress/wordpress-develop/6.8/src/wp-includes/post.php
```

## Justin's answers (2026-10-21)
- L1A L2A L3A (all ⭐). Builds after frame-text-links merges.
