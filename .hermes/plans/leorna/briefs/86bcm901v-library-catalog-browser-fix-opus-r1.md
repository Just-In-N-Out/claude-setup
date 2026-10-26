# Sol6.1xhigh INTERMEDIATE FIXER — Opus R1 — 86bcm901v

## Assignment and exact permission

Verify the complete Opus report, then fix valid introduced **F1-F4** test-first on the existing approved catalog branch. **F2 optionA explicitly approved by Justin 2026-10-22 19:03 EDT:** “A — Limit complex parsing and show safe plain text instead; only those items lose formatting”. Normal Markdown stays formatted; structurally excessive/pathological Markdown may use a clearly identified safely escaped plain-text/source preview to prevent expensive parsing. This is a scoped approved fallback, not permission to truncate, weaken bounds/security or accept delays unchanged. **F2 is its own LAST task/commit after core F1/F3/F4.** Stop corrected candidate for fresh independent review; no release/self-approval/manual waiver.

Full pipeline remains: completed Sol clean review, completed Opus findings → this Sol fix → fresh independent re-review of behavioral delta plus full feature/applicable verifier → final coordinated records and genuinely operator-led manual/actual200%zoom. Previous clean reviews cover c7c8ec0 only, never your later bytes.

### Justin’s relevant words
> go
> that autonomous click is not workin gon the laptop

Original1A2A3A approvals remain. No native laptop clicks/type/focus/visible manual fixture, no driver/global-permission repair. No push, PR, main merge, deploy, tool-home/cloud/ClickUp writes. No independent chat/CLI agent or children. This assignment is existing governed fixes, not a fresh feature needing another go.

## Fresh skills and check-before-fix

Fresh leorna → engineering-best-practices → review-fix-cadence, receiving-code-review, test-driven-development, git-commit-rules, mutation-testing-discipline, security-best-practices, multi-tenant-auth-management, ux-frontend-workbench, frontend-testing-workflow, concurrent-state-validation. systematic-debugging for unexpected failures. Follow project AGENTS/relevant notes; no broad context/research restart. You cannot ask Justin directly; return a scoped blocker or await parent steering. Return actual skills_loaded[] and defect_loop_skills[]; audit[] so far is not a future waiver.

Read the complete report before editing and verify each claim/introduced classification against actual code and original decisions. Prove bug witnesses using tests/probes; push back only with concrete evidence. Do not apply a reviewer’s suggested implementation blindly. F2’s issue is understood, but policy is unchosen; evidence-only reproduction is allowed in private overlay/output without claiming the limitation accepted.

## Exact writer ownership

Every terminal call workdir **/Users/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901v-library-catalog-browser**. Existing branch **feat/86bcm901v-library-catalog-browser**, admission HEAD **c7c8ec0a585c32448f8458893203f636b1847de4**, original base **0da9f5443a2a49b157cf24b5d30301345d371d3e**. Parent verified all503tracked hashes, clean status and no actual sibling overlap for the narrow writer set. Verify HEAD/clean state at entry; preserve any unexpected change and stop, no reset/stash/clean/rebase or fresh branch. You alone own this catalog branch/index/scoped commits until return; parent abstains.

Owned live paths for F1/F3/F4: internal/web/library.go, internal/web/library_test.go, internal/web/library_browser_test.go, internal/library/catalog_test.go. Product category/tag matching is already correct: F4 adds tests, not new matching semantics. **F2 optionA now authorizes writes to internal/web/library_preview.go and internal/web/library_preview_test.go**, plus existing owned library.go integration/tests, as its own LAST task/commit after core F1/F3/F4. No broader source/dependency ownership is added. No go.mod/dependency change, new parser architecture, auth/loader/API/schema/CI/client/shared-record edits.

Keep shared internal/library/README.md and delivery/stories.json untouched; return exact private drafts for later coordinated finisher, not a dropped docs task. Do not edit parent-owned plan, shared notes, handoff or board; propose updates in return. Original Sol/Opus review snapshots, sealed reports and other-session prompt-kind/quality-gate branches remain read-only. Use private overlays for mutations and restore exact bytes.

Your evidence root **/Users/justin/.hermes/plans/leorna/evidence/86bcm901v/fix-opus-r1-20261022T225849Z** is already atomically claimed. All private logs/probes/captures/receipts/dispositions/checkpoints/drafts here; never add receipts into sealed producer directories. Before write-prone metadata/help/version or CLI, bind isolated HOME/config/cache. Preserve existing Justin Issa <justin@leorna.com> includeIf identity; verify before commits, no identity overrides/AI lines. Prior review disclosed pre-isolation metadata/possible auto-linter cache writes with unknown attribution: do not claim whole-host exclusive isolation or roll back user caches/config.

## Reports and verbatim received findings

Actual complete Opus report **/Users/justin/.hermes/plans/leorna/evidence/86bcm901v/review-opus-r1-20261022T221056Z/report.json**, manifest-review.json, readable report.md and raw witnesses. Parent intake ~/.hermes/plans/leorna/evidence/86bcm901v/planning/opus-review-r1-parent-intake.json checked121payloads/64,818,287bytes, exact set and503source pins. Prior Sol clean report ~/.hermes/plans/leorna/evidence/86bcm901v/review-sol-r1-20261022T214031Z/report.json. Complete returned findings preserved separately (not scraped from truncated live output): ~/.hermes/plans/leorna/evidence/86bcm901v/planning/opus-review-r1-findings-received.json.

### OPUS-R1-F1 (P2)
{
  "id": "OPUS-R1-F1",
  "severity": "P2",
  "introduced": true,
  "location": "internal/web/library.go:183",
  "claim": "The catalog tile link's aria-label ('View <name> version <v>') replaces the accessible name. That name doesn't contain the visible text 'View details', which fails WCAG 2.5.3 Label in Name (Level A, failure technique F96). Speech-input users can't activate the link by saying what they see.",
  "witness": "Chrome's accessibility tree (CDP getPartialAXTree) gives visible='View details' and accessible_name='View catalog-item-001 version 1.0.0' (adv-browser-probe.log). The journey test selects this link by its aria-label, so no existing test can catch the mismatch.",
  "fix": "Use aria-label='View details for {{.Name}} version {{.Version}}', or visually hidden text after 'View details'. Write the test first: assert the accessible name contains the visible label, then update the journey selector."
}

### OPUS-R1-F2 (P3)
{
  "id": "OPUS-R1-F2",
  "severity": "P3",
  "introduced": true,
  "location": "internal/web/library_preview.go renderLibraryPreview via libraryItemView",
  "claim": "The 64 KiB input cap and 1 MiB output cap both hold, but render CPU has no bound and grows roughly with the square of the body size. The render takes no context and isn't cached, so every view of the detail page repeats the cost. The trust model mitigates this but doesn't remove it: content ships with the control plane and only admins can read it.",
  "witness": "Best of 3, body '[a](' repeated: 8KiB 67ms, 16KiB 216ms, 32KiB 933ms, 64KiB 3.74s. Body '>' repeated grows the same way, then fails at about 3.5s when it hits the output cap. On the real detail route, '[a](' x16384 took 5.64s, 3.72s and 3.37s (status 200). '>' x65536 took 2.4-4.3s and returned 500. The maximal seeded control body took 37-142ms. Logs: adv-scaling-probe.log, adv-probe.log.",
  "fix": "Parent/Justin decision: either accept and document this as a limitation of trusted shipped content, or add a structural budget before parsing and/or cache the preview per immutable item ID. Add a regression test that bounds the render time."
}

### OPUS-R1-F3 (P3)
{
  "id": "OPUS-R1-F3",
  "severity": "P3",
  "introduced": true,
  "location": "internal/web/library.go:111-115",
  "claim": "A page past the last result shows '24 matching items · ... · Page 2' and also the status text 'No library items match these filters.' The two statements contradict each other, and the only recovery link clears every filter.",
  "witness": "TestOpusCatalogHTTPProbeWithPostgres, GET ?page=2 with 24 rows (adv-probe.log).",
  "fix": "Show distinct copy for an out-of-range page and add a first-page link that keeps the filters, built with libraryURL(filter,1). Test both states."
}

### OPUS-R1-F4 (P3)
{
  "id": "OPUS-R1-F4",
  "severity": "P3",
  "introduced": true,
  "location": "internal/library/catalog_test.go, internal/web/library_test.go",
  "claim": "No test protects exact matching for category and tag. A category or tag filter changed to prefix matching passes every catalog domain and HTTP test.",
  "witness": "Overlay mutants category-prefix-widen and tag-prefix-widen both exited 0. All of TestCatalog*, TestLibraryCatalogWithPostgres and TestLibraryCatalogPaginationWithPostgres passed (mut-category-prefix-widen.log, mut-tag-prefix-widen.log).",
  "fix": "Add decoys whose category or tag extends the filtered value (for example 'testing-extra', 'review-extra'), then prove both mutants now fail."
}

## Ordered fix outcomes

1. F1: prove actual visible/computed-accessible name mismatch, then retain visible View details in an item/version-specific accessible name. Update relevant automated selector/AX regression, preserve link purpose and keyboard operation. Capture actual AX before/after evidence; an unchanged visual screenshot alone cannot prove an ARIA change.
2. F3: prove positive-match/out-of-range vs true zero-match states, then distinct accurate copy and first-page recovery retaining all current filters/search. No auth/navigation/API redesign. Capture real headless before/after out-of-range state during execution, not after reconstruction.
3. F4: test prefix-extension decoys in domain and HTTP families so exact category/tag matches are protected. Prove BOTH actual reviewer prefix mutants now fail for intended assertions, keep positive/existing cases green and restore.
4. **F2 optionA AUTHORIZED 2026-10-22 19:03 EDT**: finish as separate final task/commit after the core three. Justin’s exact answer: “A — Limit complex parsing and show safe plain text instead; only those items lose formatting”. Use the existing preview surface, clearly identify escaped plain-text/source fallback for structurally excessive Markdown; ordinary content stays formatted. B/C not selected. Bound parsing work before expensive work; caching alone must not disguise an unbounded cold render. Do not truncate, execute content, relax64KiB/1MiB caps/inertness/security or add parser/dependency/architecture. Document concrete engineering budgets and verify the pathological classes and normal/maximal controls, including cold requests and actual fallback UI evidence. The reviewer’s2s observation is not a new mandatory AC; AC3 remains strict as approved. If the remedy exceeds owned paths or needs a further product-policy change, stop with concrete options. This is not acceptance of the known slow limitation.

## Evidence, gates and stopping contract

RED → unchanged GREEN per finding; commit passing scoped changes with explicit paths, not git add. Preserve first failure, actual source/head/argv/cwd/start/end/exit and sensitivity controls. Before first fix capture useful actual baseline (AX data for F1, real page for F3), then during each test capture corrected evidence. No logs-as-UI screenshot, no synthetic manual acceptance. Private per-finding disposition table includes validity/introduced/verdict/reproduction/commit/remaining scope.

Run full canonical make check and bash ./scripts/test-module-add.sh on the final corrected head, separate verbose named actual Postgres/headless browser proofs and relevant compile-valid mutations/restoration. No native/interactive manual fixture. Existing GNU realpath+compatible Bash/CI linter via task-only PATH; preserve outside-scope failures, no workflow/global tool repair or gate weakening. Existing approved local test container; own uniquely named disposable database **leorna_catalog_fix_opus_r1_test** ending_test with verified reset guard/ownership, never reuse/drop siblings or print secrets. Keep shared CPU/DB admission and heavy launch fail-closed; loaded-host timings are not quiet measurements. The report’s loaded-but-admitted Opus timing caveat and failed probe/fixture/mutation-harness logs remain historical, not discarded.

Use isolated headless browser/profile/cache/output; other-session refs/DBs/Terminals/Chrome untouched. Recheck disk and actual conflicting owner/resource immediately before heavy runs; stop safely below~1.5GiB, no unrelated deletion. Do not let a hypothetical idle reservation block independent fixes. Two focused repair/recheck cycles for one unexpected approach then narrow/report; preserve original attempts. Record tool-observed start and useful5–15min slices, real-clock checkpoints≤15min; rough fix forecast30–60min excluding user decision/resource waits, low confidence, not a hard expiry.

At return all scoped source passing/committed/clean, temporary mutations restored, required exact-head local gates/evidence and per-finding dispositions saved. **F2 is now chosen(A); no outstanding answer/go is owed for it.** If any finding cannot be fixed within the authorized contract, return stopped with precise evidence, not a false ready. Once all four findings have evidence-backed dispositions and required checks, stop **ready-for-next-review**; parent owns fresh independent review, any applicable Opus verifier, final shared records/manual200%zoom acceptance. Never self-approve or convert missing live/manual/hosted/combined-sibling proof into pass. No push/PR/merge/deploy/ClickUp post.
