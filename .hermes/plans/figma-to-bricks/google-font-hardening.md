# Google font hardening — bounded Sol follow-up

## Questions / dispatch decision

**No blocking question for the descriptor-only fix.** It corrects confirmed coverage, not Figma typography or font loading policy. Justin authorized small conflict-free Sol found fixes; the parent dispatcher owns execution. This is a PLANNER deliverable, not implementation or approval of a new range policy.

**Range emission: explicitly deferred.** It is a reproducible existing invariant breach, but not an approved small change under the constraints below. Do not quietly discard range faces or rewrite them in this batch. A later proposal must resolve range-to-discrete emission and matching supplied metadata together, preserve subsets, and settle the conflict with verbatim accepted Google CSS. No answer to that broader question is needed to ship descriptor validation.

## Request played back

1. Some malformed Google font descriptors currently make the panel say a requested font is supplied when it is not confirmed.
2. Tighten only that claim, retaining the good returned faces, original CSS, requested typography, site precedence and existing request counts.
3. Investigate returned weight ranges too, but leave that item open rather than turn this into a CSS-emission redesign or collide with live work.

## Status and context

- Loaded `figma-to-bricks` (PLANNER), its rules summary first, relevant main `CLAUDE.md` Start here / font entries / font-weight rules, project memory, and `systematic-debugging`.
- Investigation began on `2dd96eb`, build `2026-10-21.10`. **Link-upload-fixes merged during this investigation**: final inspected main is `6ba11f5c2b146888b73a4cea707ea53a26c514ab`, build **2026-10-21.11**, equal to origin/main. Main has only the user's modified debug JSON; it was not edited or used to manufacture these synthetic cases.
- `CLAUDE.md` still reports .8 and F1 open. That is stale documentation, not code state: B8 is merged in .9 (`1b21e19`; production fix `f736955`). Existing `.9` / `.10` pending CLAUDE edits are separate parent/finisher work; this planner does not apply them.
- B8's actual returned family/weight/slant coverage is mandatory. Preserve interval boundary coverage, normalized family comparison, subset deduplication, defaults, partial-success behavior and failure-only retries. Loader duplication stage 2 remains held for live paste proof.
- No application/test edits, worktree, branch, commit, build, browser/fixture edit or live-site write were made. Scratch diagnostics and durable plan/evidence only.

## Owned items and root-cause evidence

### 1. Returned weight ranges reach paste CSS — medium, confirmed synthetic, **DEFERRED**

- `src/ui/fonts.ts:17–22` accepts Google-CDN blocks without changing descriptors; `:67–84` returns them verbatim; `:89–94` appends CSS to the first real top-level element.
- A synthetic HTTP-200 response containing `font-weight: 100 900` produces that exact declaration in `_cssCustom`. The assertion that the paste contains no such range fails. The current proof agrees with the earlier reviewer proof at `~/.hermes/cache/scratch/google-partial-fonts-review/review-proof.json`, `after.edgeCases.range`.
- This is **not evidence of a real discrete-weight Google request returning a range**. The earlier reviewer had not observed one; this pass used frozen/synthetic responses and made no live Google request. Do not describe the risk as a newly observed live failure.
- Project rule is unambiguous: `CLAUDE.md:997–1000` prohibits ranges and non-number weights anywhere in a paste, custom CSS included; it describes Bricks collecting them into its Google Fonts link. The site-font path already emits one requested discrete weight per applicable variable face (`font-sources.ts:34–61`). This is not permission to change Google CSS indiscriminately.
- The site path builds its own typed data into rules. Google's path retains external CSS, including URLs, formats and Unicode subsets. Project architecture also forbids regex CSS rewriting (`CLAUDE.md:888`). A blind replacement, range-endpoint choice, all-hundreds expansion, or wholesale rejection would introduce changed capabilities/coverage or throw away valid usable faces. Changing only emitted CSS while retaining range-wide `supplied` would also make notes inaccurate.
- **Boundary:** keep current interval metadata/tests and emitted CSS untouched in this batch. Do not add a permanently failing/skipped CI test, claim the global no-range invariant is fixed, normalize arbitrary Google weights, or mark this found item closed. Retain the explicit red diagnostic as evidence for the later decision.

### 2. Malformed family/style descriptors certify coverage — low, confirmed, **READY FOR SMALL SOL BUILD**

- `fonts.ts:41` reads descriptor text. `:42` removes matching outer quotes, but a mismatched quote pair remains a raw string and is not rejected by `:46`.
- `font-names.ts:4–8` intentionally normalizes punctuation away for matching. Thus `'Sample Sans\"` still compares like `Sample Sans`. Normalization is not syntax validation; do not change this shared helper or valid family aliases.
- `fonts.ts:46` accepts `oblique` followed by arbitrary text via `oblique(?:\s.*)?`; `:47` calls every such value italic. Consequently `oblique nonsense` certifies an italic 800 request.
- `missingFaces` at `:58–64` consumes the resulting falsely confirmed `SuppliedFace`, so both exact malformed examples return `missing: []`. B8's coverage consumer is correct for trustworthy metadata; fix validation at its input rather than undo B8 or add a second coverage algorithm.
- Working controls in the same harness: properly single/double-quoted families, unquoted `Sample Sans`, and `oblique 10deg` still certify their actual returned 800 face. Each case uses exactly one stubbed Google call.

**Hypotheses checked:** (1) malformed descriptor validation falsely certifies coverage — confirmed by isolated family/style cases; (2) a lost/misclassified Google response or retry explains it — ruled out by one successful accepted block and one request per case; (3) site-priority/UI integration causes the defect — ruled out by reproducing directly in `loadGoogleFonts` without a site or panel. Site precedence remains a regression control, not an implementation target.

## Tight loop and evidence actually run

```sh
node /Users/justin/.hermes/plans/figma-to-bricks/evidence/google-font-hardening/planner/probe.mjs
```

Exit **1**, intentionally RED: malformed oblique and mismatched family quotes fail their missing/supplied assertions; the independent range no-emission assertion also fails. Valid controls pass. All responses are local stubs (`externalRequests: 0`); the CDN path is synthetic, not a captured physical font. `proof.json` preserves exact input/output and assertion failures.

```sh
node --test test/unit/ui-fonts.test.ts test/unit/ui-font-sources.test.ts test/unit/ui-run-font-fallbacks.test.ts
```

On final inspected .11 main: **59 passed, 0 failed, 0 skipped**. Raw output is `evidence/google-font-hardening/planner/focused-baseline.tap`. Existing tests do not exercise these two precise malformed forms. They do protect B8, variable metadata, site precedence, retries, missing notes and requested typography.

Permanent planner evidence root: `/Users/justin/.hermes/plans/figma-to-bricks/evidence/google-font-hardening/planner/` (`probe.mjs`, `proof.json`, `focused-baseline.tap`, `css-fonts-4.html`). Scratch originals may expire; implementation must use the durable copies.

**Primary grammar reference:** W3C CSS Fonts Module Level 4, §§2.1.1, 4.2 and 4.4, retrieved October 21, 2026; saved as `css-fonts-4.html`. Family names are a quoted string or an identifier sequence; oblique descriptors permit angle values, not arbitrary following words. Use this only to validate the currently supported family/normal/italic/oblique forms. It is not approval to add current-draft style keywords, change B8 defaults or weight semantics, or implement all CSS syntax.

## Bounded implementation approach

Production file: **`src/ui/fonts.ts` only**, small pure descriptor-validation helpers used before constructing `SuppliedFace`.

1. Validate family descriptor syntax **before** unquoting/normalization: a quoted value must have the matching delimiters and no stray unescaped delimiter/trailing tokens; an unquoted value must be a legitimate identifier sequence, not a malformed quoted value. Retain existing safety exclusions/unsupported-escape behavior. Preserve valid Unicode names, normalized aliases, and a different quote character inside a correctly quoted string. Do not globally ban apostrophes or punctuation in quoted names.
2. Validate supported style descriptors as complete values. Keep normal, italic, bare oblique and valid oblique literal angle form(s), including signed/fractional angles and valid angle units; reject arbitrary words, trailing garbage, too many angles and out-of-domain angles. Do not reduce oblique handling to only bare `oblique` or only the positive `10deg` example. Preserve the established boolean slant interpretation; no slant-matching redesign.
3. The metadata parser need not become a full CSS engine. Never claim coverage from a descriptor it cannot validate. Leave accepted raw CSS intact, including valid companion faces; unknown syntax is unconfirmed, not rewritten or replaced. Do not add dependencies/browser-only parsing, CSS expression evaluation, or a broad tokenizer/refactor. If preserving an encountered legitimate descriptor requires such work, report that specific case and defer that extension rather than broaden this fix or silently discard usable CSS.
4. Invalid descriptors must yield no supplied metadata for that block and no confirmed coverage from it; a valid block in the same answer still counts. Explicit malformed style/family values must not be treated like omitted defaults. Keep omitted style/weight normal-400 behavior and named-weight handling exactly as B8 tests specify.
5. Preserve `{ css, missing, supplied }`, request URLs, family/request ordering, deduplication and request policy. A partial or malformed-but-accepted HTTP 200 makes no new request. Failed combined GETs retain existing individual retries and use the same validated response metadata.
6. No substitutions, synthesized faces, load probes, uploads, deletions, changed typography, or source planning/UI wording changes. `fontPlan` and `fontNotes` should reflect corrected evidence through existing logic.

## Test-first tasks and acceptance

### Task 0 — isolate, refresh and establish baseline

Parent dispatches builder/reviewer/finisher on **Sol 6.1 high**, with a separate fresh Sol reviewer, not an Opus-heavy job. After parent authorization, follow project worktree procedure on current main; recheck live branch/file ownership first. Copy approved plan and start `.superpowers/sdd/google-font-hardening/progress.md`. Save baseline check/browser/corpus reports and all corpus pastes before application edits. Do not run build/corpus in shared main.

### Task 1 — isolated RED regressions

Create **`test/unit/ui-google-font-descriptors.test.ts`**, self-contained local CSS and `env.fetch` stub/reset; no shared panel fixture imports or fixture edits. Add exact malformed examples, then nearby generic variations. Assert:

- Requested normal 800 plus mismatched/missing family delimiters does not certify 800; supplied metadata excludes the malformed block.
- Requested italic 800 plus `oblique nonsense`/trailing junk does not certify italic 800. Invalid nonempty style is not an omitted normal default.
- Correctly quoted/unquoted names, Unicode/normalized aliases, valid embedded opposite quote, normal/italic/bare oblique and valid oblique literal angles remain covered. Keep cases generic, not tied to font/layer names in Justin's designs.
- A response mixing valid and malformed blocks preserves good supplied faces, correct missing design order, every accepted CSS block byte-for-byte, and one combined request. Subsets remain retained/deduplicated as before.
- Injected combined HTTP failure followed by malformed individual responses stays missing without altering the existing retry count. Label it failure injection.
- Use read-only `fontPlan`/`fontNotes` with local typed site-face data to prove an unconfirmed Google face is missing/unknown without a site, but exact usable site coverage still wins; wrong-style/unusable site faces do not. Requested family/weight/slant inputs remain unchanged.

Run the focused test and record RED **on the untouched loader** for the exact assertions, not a syntax/import error. Do not assert the deferred range fix in this test.

### Task 2 — minimal validation and GREEN proof

Change only descriptor validation in `fonts.ts`. Run the new suite plus the existing 59-test loop. Show RED/GREEN with the original production source restored temporarily in the feature worktree, then restore the fix. Record a short old/new descriptor table: missing/supplied, raw CSS equality and GET counts. Keep existing range/subset/default/named-weight tests unchanged and passing. Commit passing bounded work; stop if any source outside `fonts.ts` is required.

### Task 3 — regression gates and independent review

- `node --test test/unit/ui-google-font-descriptors.test.ts test/unit/ui-fonts.test.ts test/unit/ui-font-sources.test.ts test/unit/ui-run-font-fallbacks.test.ts`.
- `npm run check`, `npm run test:browser`, `npm run corpus` in the feature worktree, repeated on the final rebased branch before merge. Re-establish actual baseline; test-cleanup is concurrently repairing known stale upload-name failures. Do not accept new failures or assume old counts.
- Corpus: retain baseline/final full reports and all five pastes; compare bytes, lint, heights, loaded-font status and known worse-than-v1 identities. Corpus may exit 1 for existing identities; moving marquee/font-load noise is not improvement proof.
- Read-only replay of a scratch copy of the user's debug JSON and Hydraulics should preserve core paste output and requested weights. Do not edit the original debug JSON or shared fixtures. This is nonvisual metadata hardening: text proof is appropriate; no new page screenshots/paste required when CSS and rendered output are unchanged.
- Fresh Sol reviewer checks scope, malformed false-coverage fixes, valid-face preservation, exact CSS/request counts and B8 regression protection. Any fix pass is verified/test-first. Reviewer must not call the range item solved.

## Touches / conflicts / pipeline

**Expected application/test diff:** `src/ui/fonts.ts`; new `test/unit/ui-google-font-descriptors.test.ts`. Existing font suites and `font-names.ts`, `font-coverage.ts`, `font-sources.ts`, `site-fonts.ts`, `env.ts`, `run.ts` are read-only dependencies. Panel font metadata after emit only; core extract/normalise/understand/style/adapt/emit and breakpoint rules unchanged.

**Explicitly forbidden edits:** `src/ui/main.ts`, `run.ts`, `site-*`, `wordpress.ts`, core payload guard, panel/browser tests, `test/fixtures/*`, shared unit orchestration tests, snap/corpus tooling, layout/pill/link/contact/page-address logic.

**Actual overlap check, refreshed after .11 merged:**

- **test-cleanup**, final recheck worktree tip `e152749`: committed changes include style/style.ts + picture split, panel/browser helpers/tests, panel/WP fixtures, `ui-site-fonts.test.ts`, package/test commands, snap/corpus tooling and records; working tree is clean. Neither `src/ui/fonts.ts` nor the proposed isolated test appears in its tracked or untracked changes. Read shared fixtures only; the new test deliberately does not depend on them. Test-cleanup's font stand-in/snap work is not permission to modify Google metadata or shared fixtures here.
- **link-upload-fixes**, merged .11 during planning: `git diff --name-only 2dd96eb..6ba11f5` confirms application changes in main/run/site/wordpress and payload/link code; it also fixes only invalid IDs in `ui-run-font-fallbacks.test.ts`. It does not touch `fonts.ts` or the proposed isolated file. Preserve its valid six-letter IDs and final payload guard by leaving that integration file unchanged. The existing focused integration suite was rerun on .11 and passes.
- **layout-floors / pill-clip** own adapt/layout; **card-link-words / text-link-followups** own widget/normalise/contact/link/page-address work. No planned overlap. Phone false-positive recognition is explicitly not owned.
- **Shared records** (`docs/HANDOFF.md`, BUILD, main CLAUDE.md, found-item records) require normal serialized finisher merge lock. The builder may write its own worktree records; no concurrent main-folder edits. Refresh the file intersection before builder starts because ownership can move.

**Can run descriptor-only build without source serialization.** There is no reason to wait for test-cleanup or reopen the merged link task, provided the boundary above holds.

## Risks / stop conditions

- Overly strict family/angle checks can introduce false missing claims. Positive controls are mandatory; do not use a Latin-only name allowlist or discard all oblique/variable faces.
- Supported metadata is not proof of glyph availability, binary fetch success or the site's eventual physical font; retain existing cautious notes.
- Current accepted CSS can still contain a weight range. That known medium issue remains open; do not bury it behind the low-severity hardening result.
- A need for CSS emission transformation, parser dependencies, new network behavior, run/panel/fixture changes, new user-facing policy or expanded source scope is a stop/defer, not permission to widen. Parent surfaces any new trade-off to Justin.

## Docs & records — final implementation task

- Copy approved plan to `docs/plans/2026-10-21-google-font-hardening.md` (actual start date if later).
- Move ledger to `docs/plans/2026-10-21-google-font-hardening-ledger.md`; record RED/GREEN, preserved valid CSS, request counts, exact baseline/rebased gates and explicit deferred range status. Archive executable proof and raw reports durably.
- Update worktree `docs/HANDOFF.md`: descriptor-only result, B8 intact, range emission still open. Conversion/panel check: reload/Convert, supported faces remain confirmed; malformed/unconfirmed responses do not promise requested coverage; matching usable site faces still win. **No paste check owed for unchanged CSS/output**; keep existing 3af/3ah and loader-duplication proof separate. Allocate any new conversion-check ID from actual merge-time records.
- Finisher alone bumps BUILD at merge, rebuilds dist, updates main CLAUDE.md Start here / Where things stand without overwriting pending .9/.10 records or lowering the build. Rule clarification: validate supported family/style syntax before normalization and coverage; unvalidated descriptors cannot certify a face. No new font-design decision. Use normal pending-edit procedure if protected writes are denied.
- At verified merge, close **only** the malformed family/style found item (`found-else.md` originally line 113) with the actual build. Leave the range item (original line 112) explicitly open/deferred with this plan reference; do not strike loader duplication or phone recognition. Parent updates batch records with the descriptor-only scope under the usual serialized records ownership.

## Found elsewhere

No additional application defect investigated or added to scope. Stale CLAUDE.md .8/F1 status is already explained by existing pending .9/.10 updates, not a new font bug. Local search intermittently returned “No such process”; targeted reads recovered. Configured web extraction was unavailable; official W3C content was downloaded read-only with curl for the limited grammar cross-check. Neither issue blocks this plan.
