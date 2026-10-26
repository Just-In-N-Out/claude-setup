# media-rename-collision — protect all linked destinations during owned-media repair

PLANNER · Sol6.1 xhigh · 2026-10-21 · **Approved to continue under Justin's 2026-10-21 request, “Why three paused please continue”, and standing recommended-choice authorization: Q1A.** Dispatcher reserves `site-media.ts` and the narrow `site-pages.ts` occupancy/history/notes extension; shared upload APIs and `run.ts` remain frozen. Builder stops ready-for-review; no live-site writes.

## Questions / recommended options

**Q1 — If the usual new media name is another link's address:**
- **A ⭐ Choose a deterministic unprotected alternate before the one rename POST** (for example `catalog-image-2`), then index the address WordPress actually returns. If WordPress nevertheless assigns another protected address, leave every affected new-paste link plain; do not send a corrective/retry POST in this conversion.
- B Skip this media's rename, name the collision, and leave links to its occupied original address plain. Smaller write surface, but the original address remains blocked.

A retains ordinary repair behaviour and existing one-write/no-blind-retry discipline. B is a valid conservative fallback, not something the builder should select silently. No change to inline mode, cancellation, ownership, attachment-ID/document policy, upload naming or saved-page repair policy is being requested.

**Source reservation, not a user policy question:** a small `src/ui/site-pages.ts` contract/notes extension is recommended alongside `site-media.ts` to keep verified move history distinct from final occupancy. The now-available list-panel-followups plan explicitly excludes `site-pages.ts`, `run.ts` and WordPress helpers from its ownership (`:166–174`), so the proposed production edits do not conflict with D. Dispatcher confirms the reservation before a builder starts. No `run.ts`, `main.ts`, `site-read.ts` or upload API change is expected. If the strict two-file boundary is retained, defer the reoccupied-source/history case explicitly rather than claim the whole issue fixed.

## Request played back

1. Moving one of the plugin's pictures off a page address must not make another linked address silently open that picture.
2. Check every original link and matched page candidate against the final, exact media address, not just the old media name.
3. Continue changing only upload-cache-owned media in an active WordPress-picture run. Inline conversions remain read-only; cancellation starts no further repairs.
4. Keep one verified write/readback per eligible media ID, unchanged file/ID/alt, accurate notes, and no claim that saved Bricks links or redirects were repaired.

## Baseline and scope

Repository: `/Users/justin/Documents/FigmaToBricksV2`.

Latest verified main: **`9f9b7519f2aaaca89b77007b436a742d72043610` / BUILD `2026-10-21.19`**, equal to origin/main; only the user's debug JSON is modified. Main advanced from `f6f6600` during planning when card-link-words finished; the relevant media sources did not change. The opened CLAUDE.md status still says `.12`; actual git/BUILD and HANDOFF superseding entries are the baseline, not that stale opening status.

Canonical assigned item: **LINK-RENAME-COLLISION**, `~/.hermes/plans/figma-to-bricks/found-else.md:10`, also HANDOFF:3595–3596. **Reproduced; ready to build after Q1 and source reservation. Not fixed.** No other found-item is owned or closed here.

Loaded figma-to-bricks PLANNER, rules summary and systematic-debugging; read narrow CLAUDE architecture/debugging/link sections, memory, link-upload-fixes plan, relevant HANDOFF and current sources/tests. This is a saved offline reviewer finding, not a newly observed live-site incident. No public-site request, credential use, live write, repository edit, worktree, build or commit was performed.

## Evidence and root cause

### Tight loops actually run

Durable evidence directory:
`/Users/justin/.hermes/plans/figma-to-bricks/evidence/media-rename-collision/planner/`

1. Reran the original archived reviewer `media-edge-probes.mjs` against actual current main. `saved-probe-main.json` shows one media item, ID 7, moved `/catalog/` → `/catalog-image/`, followed by exact-ID GET. The `/catalog-image/` Match still has **`picture:false`, `held:null`, `blocked:null`**. The saved script intentionally asserts this bad outcome; its successful exit demonstrates reproduction, not safety.
2. Wrote a planner-only, fail-closed in-memory REST harness **outside the repository**:
   ```sh
   node --test /Users/justin/.hermes/plans/figma-to-bricks/evidence/media-rename-collision/planner/protected-destinations.test.mjs
   ```
   Latest execution: **exit 1; 8 tests, 6 fail, 2 pass**. Every failure says an actual occupied destination still has `picture=false`. Covers original ordering, reversed ordering, numeric server suffix, complete attached permalink, a forced candidate destination, and a later move reoccupying an earlier freed path. Two passing negative twins cover unrelated destinations and attached-vs-unrelated/root paths. Forced unexpected destinations are explicitly labelled fault injection, not observed WordPress responses. See `protected-destinations-main.tap` and `latest-probe-manifest.json` (HEAD/BUILD/source hashes).
3. Existing focused tests:
   ```sh
   node --test test/unit/ui-site-media.test.ts test/unit/ui-link-destinations.test.ts test/unit/ui-site-pages.test.ts
   ```
   **29/29 pass**, exit 0; `focused-existing.tap` and `execution-results.json`. Existing suites protect the predecessor's rules but miss newly occupied destinations. No full check/browser/corpus gate was run by the planner.

### Source trace / ranked hypotheses

1. **Most likely, confirmed: source-only verification/indexing.** `src/ui/site-media.ts:47` captures `on` from each media item's pre-write state. `:53` always requests `${slug}-image`. `:56–58` checks only whether that returned media still occupies those old paths; `:61–62` sets source `held.freed=true`; `:68` writes only the original `on` keys. No pass indexes the returned media against *all* protected paths. Both paths in the minimal saved reproduction are already present in the input.
2. **Candidate paths missing upstream, falsified as the primary cause.** `src/ui/site-read.ts:93–99` already passes the union of original hrefs and first-pass matched page addresses. The media helper receives the right protected set but stops using it after the rename.
3. **POST falsely treated as proof, falsified for this finding.** `src/ui/wordpress.ts:148–163` already serializes POST + exact-ID GET; validates ID/slug/file/link/parent; checks permission immediately before POST. The saved response really changes the slug/file permalink. Retain this queue rather than replacing it.

`src/ui/site-pages.ts:109–119` trusts the returned path-specific Held map: missing entries are safe, and a `freed:true` entry is not a blocker. `:125–153` consequently preserves the destination href. Merely checking a requested new slug or adding a single new map key is insufficient: WordPress may assign a suffix, attached media uses full paths, source/destination objects must not share `freed`, and subsequent rows must not overwrite final blockers.

### Why a narrow notes contract extension is necessary

Current `Held` (`site-pages.ts:20`) and `movesAt` (`:99–102`) use one record both for **current occupancy** and **historical verified movement**. The same-media-ID deduplicated move accounting is deliberate (`:174–189`; predecessor review B2-REVIEW-2).

Fault injection proves a later rename can occupy an earlier repaired source. That path must now block; retaining the old `freed:true` entry is unsafe, but replacing it with a new blocker erases the earlier verified move. Separate those facts in a small optional move-history field/result contract, keeping the existing interface/default behaviour for ordinary callers. Do not attach the source's shared `freed:true` object as its destination blocker. Collision notes must not say an occupied address is free or say a cache-owned upload has “no record” of ownership. Ordinary noncolliding note wording/counts must remain unchanged.

### Debug-file applicability / working twins

Read-only inspected the user's modified on-disk debug file: build `2026-10-20.6`, root **Hydraulic Cylinder Repairs Final** (`553:7604`). It has no Catalog-named layer; matching Remanufactured/Core title text has no own hyperlink/reaction. The saved reviewer issue requires media-library/cache state and two protected destinations, which this Snapshot alone does not contain. Do not manufacture a Figma naming/layout cause or hard-code those real card names. Generic media/page fixtures are the discriminating reproduction; replaying a scratch copy of the debug file remains a builder non-regression check.

## Recommended implementation (Q1A)

1. Snapshot/deduplicate the original protected paths and original eligible media by ID. Keep existing `opensAt` semantics: unattached root slug or exact own permalink; attached full parent path; legacy missing-field fallback. Do not broaden pathname/query/case/encoding policy in this fix.
2. Before a permitted write, pick an expected destination whose applicable full path(s) do not intersect *any* protected original/candidate path. Try the existing `-image` base first, then deterministic numeric alternatives. Bound selection by the finite protected set; no extra network probing or search of the whole media library. This changes only a colliding repair request; uploads, video naming and ordinary repairs stay unchanged. With Q1B, replace this selection with an explicitly noted skipped repair.
3. Call existing `setMediaSlug` once per original eligible ID. Keep active-mode permission recheck **inside** the existing per-site/per-ID queue, exact-ID GET there, original ID/file/alt invariants and failure handling. A GET/POST reply is never a guessed successful rename. Do not enqueue re-indexed incoming destinations as new repairs or chase a collision with another POST.
4. Record valid exact readback as current media state; separately record whether the old path was verifiably vacated. Rebuild occupancy across the entire protected set from final known media records after repairs settle, not incrementally from stale loop entries. Known current blockers take precedence over historical freed entries. If the server assigns a protected suffix/parent path anyway, block every affected destination, including candidates, without another write.
5. Keep verified movement history independent of the current blocker map so Match.moves/notes count each media ID once even when a source is reoccupied. Make collision-specific notes distinguish a verified media move from final address availability; retain ordinary notes exactly. Reuse normal relink behaviour for blocked native and listed frame-text links; do not widen relink scope to unrelated typed URLs.
6. Unowned, inline/read-only, skipped, refused, malformed/wrong-ID, unchanged-file/slug and failed-readback cases keep the predecessor's conservative policy. Never index a wrong-ID/malformed reply as trusted occupancy. A sent write with unreadable verification remains unverified, not a guessed destination or a retry. This bounded fix cannot guarantee unknown external server state or cached public redirects; do not claim it can.

## Tasks — test first and acceptance

### 0. Reserve scope and capture the real build baseline

Obtain Q1 approval and dispatcher reservation of the small `site-pages.ts` extension. Re-read HEAD/BUILD/source diffs immediately before creating the approved feature worktree. No planner-created worktree. Baseline `npm run check`, separate `npm run test:browser`, and `npm run corpus`; preserve complete corpus report, all saved pastes/HTML and loaded-family sets before any source edit. Record existing failures, not merely exit codes. Start a TDD ledger. No live upload/rename or cache purge.

### 1. RED: isolated collision and safe-name tests

Create `test/unit/ui-media-rename-collision.test.ts`; new isolated fixture only if useful. Port the planner's minimal case, but write desired safety assertions, not the archived reviewer's bad-outcome assertions.

- Original `/catalog/` + protected `/catalog-image/`, both input orders: one allowed request chooses an unprotected alternate under A; stable ID/file/alt; exact GET; no final href opens known media.
- Protected `-image`, `-image-2`, multiple protected alternatives; duplicated paths/media rows; only one write per original media ID.
- Actual server suffix differs from requested slug and lands on another protected path: index actual, do not guess requested path; block destination; one POST only.
- Attached exact parent permalink versus unrelated parent/root; trailing slash twins; unattached root/file-permalink and missing-field fallback controls.
- Matched published/draft candidate not present among original hrefs is protected too. Forced unexpected exact-ID return is labelled injection, not a realistic page-creation promise.

Show RED against the current source, then implement safe selection/final occupancy in `site-media.ts` and show GREEN.

### 2. RED: history, blocker precedence and notes

Add new-file tests for later media reoccupying an earlier freed source and varied response order. Final blocker must win over any source-freed history. Assert all native/listed frame-text hrefs and anchor indices after relink, unaffected typed URLs, correct skipped/collision reason, unchanged payload words/styles/IDs, once-per-ID verified movement reporting, and no assertion that an occupied address is free. Add the narrowly reserved `site-pages.ts` contract/notes change; no page ranking redesign.

### 3. Preserve ownership / cancellation / uncertain-write controls

Extend the new isolated suite, reusing (not weakening) existing regression suites:
- owned ID + active WordPress-picture run is the positive write control; unowned IDs never move;
- connected inline mode is read/match only and does not even send a safe alternate POST;
- cancellation before media GET, while queued behind alt update, and after one sent POST: zero subsequent repair writes, sent exact readback settles, cancelled run returns no paste;
- failed/wrong-ID/incomplete/unchanged/malformed readback and changed file URL: no fabricated freed state and no retry;
- ordinary verified `-image-2` outside protected paths remains allowed; same-ID alt waits for readback, unrelated IDs proceed.

Run the existing focused 29-test loop and relevant `ui-wordpress`, `ui-run`, `ui-site-read`, payload-guard and cancellation/panel suites. Existing asserts remain meaningful; do not edit their expectations to make unsafe behaviour pass.

### 4. Differential proof and gates

Use offline stand-ins only, with unknown requests rejected and no real fetch fallback. Archive old/new actual href, requested/actual slug, exact-ID GET, final occupancy, emitted native/run href and notes. Test mutants for omitted full-set projection, requested-vs-actual indexing, shared source/destination freed record, and stale freed entries overriding a later blocker; restore source immediately in the approved worktree. Prove the new test fails with the fix reverted.

Run `npm run check`, **separate** `npm run test:browser`, and `npm run corpus`. Compare full baseline/final corpus outputs and findings/fonts/heights at every existing width; no worse result. Pure core pastes/HTML should be unchanged. Replay a scratch copy of the real debug file; no screenshot change is expected or claimed. Preserve matched-policy evidence if browser/font/motion conditions differ. Do not add global phone-width tooling or relax tolerances in this task.

Builder stops committed/ready-for-review. Fresh independent Sol reviewer checks the plan/invariants; finisher verifies findings test-first, rebases/re-runs all gates and uses the merge lock. No builder BUILD/main edits.

## Touches and existing assertions

**Expected production:**
- `src/ui/site-media.ts` — protected destination reservation, original-ID repair set, final exact-readback occupancy projection.
- **Narrow coordinated extension:** `src/ui/site-pages.ts` — path occupancy versus verified move-history representation, movesAt consumption and collision-specific truthful notes only. Preserve matching/ranking/relink provenance and ordinary output.

**Expected tests:**
- New `test/unit/ui-media-rename-collision.test.ts`.
- Optional new `test/fixtures/media-rename-collision.ts` (strict stateful REST stand-in, complete paths, deterministic deferred events). Prefer this over modifying the shared panel fixture.

**Read/test, no planned edits:** `src/ui/site-read.ts`, `src/ui/run.ts`, `src/ui/main.ts`, `src/ui/wordpress.ts`, shared media/panel fixtures and existing suites. If these require edits, stop and obtain a revised source reservation first.

Existing tests pin the behaviour to preserve, not the bad collision:
- `test/unit/ui-site-media.test.ts:16–93` — cancellation, queued writes, exact readback queue and inline no-write.
- `:94–133` — ignored/invalid readbacks, file/ID/alt invariants, one POST requesting `catalog-image`, ordinary safe suffix accepted. New alternate-name logic must not change this ordinary one-link case.
- `:135–152` — root-only/complete-parent/missing-field path semantics.
- `test/unit/ui-link-destinations.test.ts:34–52` — candidate blocking and native/run/typed relink scope; `:74–86` — every verified move once, including unused candidates, ordinary notes/address counts.
- `test/unit/ui-site-pages.test.ts` — matched page ranking, kept-post exception, typed-link scoping and existing notes. No permanent test found asserts the unsafe second-link outcome; the archived reviewer script intentionally does.

**Pipeline:** connected panel link inspection/repair → final matching → native/listed-run relink/notes. No extract/normalise/understand/style/adapt/emit, font, PDF, upload encoding or Bricks schema change.

## Overlaps / ordering

Read current branch diffs, not just old ledger ownership:
- **list-panel-followups (D): scope coordinated from its written plan.** Its declared production touches are list recognition/rows/CSV, list-files/pdf-upload, narrow `ui/main.ts` wiring and a list-box extraction (`:156–158`). It explicitly excludes `site-pages.ts`, `run.ts`, `wordpress.ts`, `net.ts` and `site-media.ts` (`:166–174`). This plan needs only `site-media.ts` plus the small `site-pages.ts` extension; no upload signature or `run.ts`/`main.ts` change is proposed. The proposed sources are parallel-safe with D, subject to dispatcher reservation. A newly discovered need in those excluded shared seams is a hard dependency: revise/coordinate before editing.
- **card-link-words:** merged to inspected main `.19` while planning; no outstanding branch source delta. It changed visible label aggregation/provenance and current `site-pages.ts` label notes. Preserve `labelsOf`/subject order and media-ID deduplication; build from `.19` or later, not pre-merge snapshots.
- **pill-clip:** current branch diff is adapt/layout/least/rules/shapes plus style/behaviours/paint/types and its tests. No media source overlap. No layout repair in this batch.
- **hero-photo-blend:** current branch diff is picture/paint/shadow plus tests/docs. No media/library overlap; do not duplicate source/AVIF diagnostics.
- **renderer-proof-hardening (A):** browser renderer/capture/fontStatus and showcase tests separate; no renderer edits here. Rebase/re-run if its harness changes land before gates.
- **phone-recognition-guards (C):** contacts normalisation/tests separate; no label-links/phone policy edits here.
- **google-font-range-policy (E):** font CSS/metadata separate. If it needs run.ts/main.ts, dispatcher coordinates with D; this task still does not own those.
- HELD row/ALONE/global-width/duplicate-loader work remains held. HANDOFF, build/CLAUDE records and paste-check numbering are shared **merge-time serial** work for finishers.

## Risks / remaining decisions

- Q1 safe alternate versus skip needs an explicit answer; no silent change to the original repair strategy.
- Exact readback safety is only knowledge at that time. Concurrent external edits, unreadable verification and cached redirects are not solved by local indexing; no atomic site-wide/redirect guarantee.
- Dropping a new occupied destination's href is fail-safe for the new paste, not a saved-page repair. Proactive reservation avoids predictable new collisions but cannot override a server assigning another path.
- Do not mark this found item fixed with only the original two-link test green: actual suffix, full-parent, candidate and later-reoccupation cases are acceptance criteria.
- No unrelated new bug confirmed; `found_else: []`. Records staleness and the synthetic fault-injection variants are not additional product closures.

## Final task — Docs & records

- Copy the approved plan to `docs/plans/<actual-start-date>-media-rename-collision.md` in the approved feature copy.
- Maintain `.superpowers/sdd/<plan>/progress.md`; retain baseline reports/pastes/HTML, red/green/mutation logs, source/base identity, offline proof and review/fix results. Move the ledger to `docs/plans/<plan>-ledger.md` at close. Preserve the planner evidence separately as **before-only**, not proof of the eventual fix.
- Update `docs/HANDOFF.md` with the selected Q1 policy, source/history distinction, single-write/readback/cancellation guarantees, and the **next free** live/paste check (allocate at merge, not here).
- Live/paste check owed: Justin converts with active WordPress-picture mode through his normal workflow; use actual affected page/media only if such a collision exists. Inspect saved hrefs and media slug/file/ID read-only, verify no destination opens media and inline conversion makes no repair claim. Do not create a synthetic collision or upload to production just for testing. Changed saved hrefs still require re-convert/re-paste/save; a rename alone never repairs saved links. Existing code signatures/cache reminders apply only to the paste performed.
- Finisher bumps the real `BUILD` and rebuilds at merge; update main CLAUDE.md **Start here** / **Where things stand** and any new rule (protected original+candidate destinations; actual address re-indexing; movement history versus occupancy). Update the skill rules summary if a new approved invariant is added. Respect protected-write denials and exact pending-edits workflow; never route around them.
- Only after merge/gates/acceptance, close the single LINK-RENAME-COLLISION row in canonical `found-else.md` with actual BUILD. Leave all other rows, held policies and sibling plans untouched.


## Justin's answer M1A (2026-10-22 ~01:30 EDT)
Justin's words: "Now for M1A, just go with A ... Just keep running them."
Release this feature with the Garamond Condensed font check marked explicitly: "UNVERIFIED — pre-existing on main (Times-Roman shown on both main and branch); genuine licensed font not available; no stand-in substituted, expected font set NOT narrowed". This waives ONLY the release hold on that one pre-existing font gate, for this release. Every other gate stays (rebase, check, test:browser, corpus vs baseline with loaded-family comparison, merge lock, ff-only, build, push, verify). Record the waiver in HANDOFF, ledger and the report. W-B (wrapped-row least) stays deferred: Justin unsure.
