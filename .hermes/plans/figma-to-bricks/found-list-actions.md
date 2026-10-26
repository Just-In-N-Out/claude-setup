# found-list-actions — reconciliation plan: already fixed in 2026-10-21.22

## Questions / recommended disposition

**Q1. How should this old finding be handled?**
- **A ⭐ Record the existing .22 fix; do not build it again.** The current source, original five-case reproduction and genuine-cell controls agree with the released fix. Parent may apply this safe recommendation within the existing named-batch grant.
- B Keep open pending an additional read-only verification.

**Q2. If later list-head work changes the shared action boundary?**
- **A ⭐ Keep one predicate and the .22 action regressions.** Parent settles consolidation/sequence after both plans; this plan grants no competing writer.
- B Start a separate action implementation. Not recommended: no current failing case supports it.

There is **no new product-policy question for this finding**. The existing Q1A action/data ambiguity was approved for list-panel-followups. **Latest parent steering: Justin explicitly approved found-list-head Q2B**: the head reserves trailing action widths plus the current tier's gaps so titles align with data columns. That policy hold is cleared; head work is still queued for Tiles-B/source/test ownership integration. This does not authorize broader label/layout policy changes or another action-label fix.

## Parent reconciliation — October22
Accepted Q1A/Q2A. Parent independently verified9656d5d and5e32aec ancestors of mainb4ed333, exact four contract files unchanged; reran planner probe9/9 and node --test test/unit/list-actions.test.ts9/9, exits0. Closed only canonical old action-word-replacement finding crediting original21.22 release, not a new implementation/release. No standalone builder; list-head reuses already-exported rowActions and preserves .22 controls. Panel3av and all unrelated holds remain.

## Goal, playback and stopping point

1. The canonical finding is the exact `found-else.md` heading **2026-10-21 (csv-list-pdfs builder)**: “with a spreadsheet, a row's action button (e.g. 'Quote') can get its words replaced by a leftover column's value; PDF row buttons now keep their words, other action buttons still don't.”
2. Reconcile that historical statement against release .22 before assigning another fix.
3. Preserve genuine data replacement, box-shaped/non-PDF actions, PDF actions, missing-document/no-data-loss controls and panel/store behavior.
4. Deliver this plan and bounded evidence only. No worktree, source/test edit, application test-suite run, build, branch, commit, shared-ledger write or live-site request was made.

**Outcome:** the stated defect is **already fixed**, not partly fixed, for the approved action definition. Recommend parent close only that exact historical row, crediting **build 2026-10-21.22 (list-panel-followups)**. No new source patch or release is proposed. No failing reproduction of the canonical symptom was found on current main; do not manufacture RED by undoing correct behavior.

## Current context and authority

- Repository: `/Users/justin/Documents/FigmaToBricksV2`; main and the local `origin/main` ref both `b4ed333631dba923b73e1731ad420a4f92d880f1`, BUILD `2026-10-22.5`, inspected October 22, 2026. No remote fetch/push verification is claimed by this planner.
- Only the user's root `figma-to-bricks-debug-page-1.json` was dirty; preserved untouched. Disk was **5.2 GiB free**, lower than the brief's earlier approximate 6.2 GiB. No deletion, archive or clone was attempted.
- Root debug: build `2026-10-20.6`, SHA-256 `79bc7494d213e8a8ea35a50d28ba574d2fa2ceded82d76c506f0f4406b33acd9`; one saved list entry, but current normalise/understand recognises **0 lists / 0 list rows / 0 row Buttons**. It cannot establish this action-label symptom; generic fixtures are the relevant reproduction. No replay/capture of the whole page was needed.
- `CLAUDE.md` Start here still says `.12`; this is stale protected documentation, not source identity. The existing `.22` pending file already describes the fix. It was read, not altered or retried.
- Source identity, ancestry, hashes and current outputs are in `evidence/found-list-actions/planner/`. The active brief and October 22 out-of-band ownership clarification bind this plan, including the later explicit approval of found-list-head Q2B. Earlier held-Q2 wording in the sibling's plan/brief is superseded by that steering; parent owns updating shared records.
- **Explicit routing: Sol 6.1 (`gpt-6.1-sol`), xhigh throughout** planner, any subsequently approved builder, separate fresh reviewer, finisher and independent verifier. Do not inherit the overlapping head feature's Opus routing. No builder is recommended here, so this finding consumes no new builder/finisher slot; six remains the cap.
- Constraints unchanged: W-B held; ALONE unchanged; Garamond Condensed **UNVERIFIED**, no substitute, expected-family narrowing or extension of a historical release waiver. No CLAUDE writes/retries/bypass by any tool or agent; pending proposals only. All site access GET-only; this investigation needed none.
- Tool-observed investigation start: `2026-10-22 07:26:22 EDT`; the bounded reconciliation forecast recorded after initial context was 10–15 minutes, medium confidence. Probes themselves used two sequential ≤35-second processes, each capped at 256 MiB Node old-space, total measured 0.795 seconds; an additional ≤25-second root-scope probe passed. No Chrome/corpus/performance slot was used. Final elapsed and artifact validation are recorded in `plan-validation.json`.

## Root cause and existing repair — exact current call sites

### Historical cause, not a new hypothesis

The old `list-rows.ts` binding algorithm treats plain text and native Button labels as cells (`cellsOf`, current lines 15–18). It first matches drawn words to spreadsheet values, then assigns unused columns to all remaining unbound cells (`bind`, lines 26–36). That fallback is intentional for sample data and must remain.

Before the fix, `rowsFrom` protected only the selected PDF target's descendants, and only when `live = linked && button !== null`. A non-PDF action, or any action while no documents linked, was therefore just another unmatched “cell”; a leftover column replaced its shown words. A linked PDF target kept its words, producing the reported difference. The historical RED artifact on main `9f9b751` records:

| Case | Historical output | Current output |
| --- | --- | --- |
| A: Quote + Sheet(PDF), leftover Sheet, no PDFs | Quote → `a1.pdf` / `b2.pdf` / `c3.pdf` | Both action labels retained; Sheet unbound |
| C: Quote + leftover Notes, no PDFs | Quote → `note-A1` / `note-B2` / `note-C3` | Quote retained; Notes unbound |
| D: Quote + Sheet(PDF), PDFs + Notes | Non-target Quote → notes | Quote retained; only PDF target linked/dropped per row |
| B: PDFs, no extra Notes | Correct | Byte-identical control |
| E: no leftover column | Correct | Byte-identical control |

### Released repair remains intact

- `src/core/understand/list-links.ts:24–48`: button-shaped boxes as well as native Buttons, never arbitrary painted cells/stat figures.
- `list-links.ts:56–64`: existing `actionsIn` requires the same button words on every drawn row and excludes words present in any spreadsheet cell. **`rowActions` is already exported at line 64.** `rowTarget` uses that same predicate at lines 65–69; there is no need to invent or duplicate it.
- `src/core/understand/lists.ts:239,259–263`: retrieves saved data, chooses PDF target and passes `rowActions(rows, saved && saved.columns.length ? saved : null)` into `rowsFrom`.
- `src/core/understand/list-rows.ts:59–64`: adds every action subtree to `inside`, independently of `live`, and excludes its cells from binding via `keep`. The existing live PDF path and linking-column omission remain.
- `list-rows.ts:67–75`: only the live selected document target is removed on a row without its document; other actions and real cells remain.
- `src/ui/lists.ts:78–82`: an unbound action says “stays as drawn”; unused columns say “Not shown”.

The merged action fix is **`9656d5d596a9ced0840130a87e3b177a52e5d1f0`**, the rebased counterpart of builder commit `8864679`. Release **`5e32aecff89627a5c30aced57c675fdd161ee800`** is “Build 2026-10-21.22: List panel follow-ups…”. Both are ancestors of current main. The **three production files above plus `test/unit/list-actions.test.ts` are byte-identical** between the action-fix commit, .22 release and current checkout. `source-and-reconciliation.json` records each SHA-256 and exact comparison, not just similar commit messages.

### Approval boundary retained

The already-approved Q1A cost is deliberate: a Button/badge with identical sample words on every drawn row, absent from spreadsheet values, is treated as an action and stays drawn. Do not reverse it by guessing from text, label names, “Quote”, column names or PDF-like words. Conversely, a Button whose words occur in the sheet is still eligible data. These are existing decisions, not unresolved defects in this task.

## Evidence and validation actually performed

Run from the verified repository (read-only diagnostics, **not** `node --test`):

```bash
node --max-old-space-size=256 /Users/justin/.hermes/plans/figma-to-bricks/evidence/found-list-actions/planner/probe-current.ts /Users/justin/Documents/FigmaToBricksV2
node --max-old-space-size=256 /Users/justin/.hermes/plans/figma-to-bricks/evidence/list-panel-followups/probe-leftover.ts /Users/justin/Documents/FigmaToBricksV2
```

Both exited **0** with empty stderr, Node `v22.19.0`. `probe-current.ts` denies fetch and observes normalise → understand → convert/emission without rendering. Its **9 diagnostic cases** passed real assertions:
1. A single non-PDF action with leftover Notes keeps its words in IR and all three emitted native Button labels.
2. Two actions, leftover file-name column, no PDFs: both retain words and null bindings.
3. Non-target action with PDFs + Notes: Quote retained; missing-document row loses only the PDF action; two native PDF links retain `newTab:true, rel:"noopener"`.
4. Two unrelated action labels (`Enquire`, `Review options`): same preservation, ruling out a Quote-text special case.
5. Box-shaped icon action with no PDFs preserves its label.
6. A Button with words present in CSV remains data and takes its leftover column, rather than being protected indiscriminately.
7. Varying badges still bind sample columns in order.
8. Painted genuine data cells with a missing document keep every data word; no data target or dropped cell.
9. No saved spreadsheet retains the drawn action and null bindings.

The **original five-case diagnostic** on current main is **byte-identical** to archived fixed output `probe-leftover-branch-48dbb65.jsonl` (SHA-256 `f96027a9c0f428f8dc0a493d5f7e38f095ed9d4a300254a923c0dd79d30a924d`). Programmatic comparison to archived pre-fix output changes exactly A/C/D and retains B/E. Historical RED was **not freshly re-executed** or re-labelled as current RED; the archived ledger records five failing T1 tests on old source and nine passing on the repaired branch.

Evidence index (all under `/Users/justin/.hermes/plans/figma-to-bricks/evidence/found-list-actions/planner/`):
- `probe-current.ts`: bounded reproducible diagnostic, no source mutation/network.
- `current-core-controls.jsonl`, `.stderr.txt`: actual current observations and summary.
- `original-five-current.jsonl`, `.stderr.txt`: original probe's current output.
- `probe-receipt.json`: exact commands, cwd, exits, timings.
- `source-and-reconciliation.json`: main/local-origin identity, release ancestry, four exact file hashes/comparisons, five-case comparison, root debug identity/scope.
- `root-debug-scope.json`: actual current root applicability result.
- `plan-validation.json`: plan completeness, shell syntax and final scope/evidence checks.

**Not run:** application unit/browser suites, `npm run check`, build, corpus, snaps, installed-Bricks or live-Figma/paste checks. This is sufficient for the requested reconciliation/plan, **not** new release sign-off. Existing HANDOFF panel check **3av remains owed** (Figma only); installed PDF compatibility obligations remain separate.

## Tests currently pinning the contract (read-only)

| Test/call site | Pinned behavior |
| --- | --- |
| `test/unit/list-actions.test.ts:31–61` | Non-PDF actions, leftover columns and non-target action with PDFs retain labels; correct bindings and “Not shown” detail |
| `list-actions.test.ts:64–94` | Missing-PDF target removal, no-leftover controls, genuine Button cells, varying badges and icon-box actions |
| `list-actions.test.ts:97–102` | Approved same-sample-word badge/action Q1A cost; cannot silently change |
| `test/unit/understand-lists.test.ts:80–85,126–142` | Sample words bind in order, partial matches and varying badge data |
| `understand-lists.test.ts:228–254` | Document links/drop only selected target; no-PDF/no-target data retained |
| `test/unit/list-pdfs-review.test.ts:79–113` | Painted cells and linked words never dropped, CSV-valued Button is data, icon-box and native PDF target words retained |
| `list-pdfs-review.test.ts:121–138` | Stat boxes not actions; PDFs kept with no spreadsheet remain reported |
| `test/unit/ui-lists.test.ts` | Binding/detail wording; preserve real data replacement, not a blanket unmatched-column ban |
| `test/unit/pdf-new-tab.test.ts`, `test/browser/pdf-new-tab.test.ts` | PDF link metadata/navigation proof boundaries; non-PDF unchanged |
| `test/browser/panel.test.ts:352–403` | Real picker → save message → acknowledgement; add/replace/remove lifecycle |
| `panel.test.ts:418–487` | Real plugin store answers, Remove PDFs then Remove, refusals and order |
| `panel.test.ts:518–736` | Connection freshness, multi-file pick invalidation, cancellation, ownership and normal completion |

No current test asserting the old Quote-replacement outcome was found. Do not edit correct Q1A tests merely to create a failing build task.

## Touches / exact ownership overlaps

**This planner's write allowlist only:** this plan plus its own bounded evidence directory. **Production/test edit allowlist: empty.** All code/tests below are research and preservation targets, not permission to write.

| Owner | Exact intersection / disposition |
| --- | --- |
| **found-list-head** | Owns `src/core/understand/lists.ts` (`headOf:195–211`, caller `:252`) and any required export from `src/core/understand/list-links.ts`; `src/core/adapt/rules/list.ts` is now permitted under **Justin-approved Q2B**, still subject to queued ownership integration. This is **understand**, not a separate normalise detector. Our existing protected-label call is `lists.ts:263`; shared predicate is already exported `list-links.ts:64`. Reuse it; do not add a second action classifier. |
| **found-list-head tests/fixtures** | Owns `test/fixtures/lists.ts`, `test/unit/understand-lists.test.ts`, `test/unit/adapt-list.test.ts`, new `test/unit/list-head.test.ts`, `test/browser/list-layout.test.ts`. Our diagnostics consume the same `listPage({actions})` fixture. Changes there must retain the .22 action suite and data-cell controls. No fixture/test changes are requested here. |
| **head integration requirement** | `rowActions(rows)` defaults to no sheet. The existing binder supplies saved sheet data to exclude CSV-valued Buttons. If head recognition reuses the predicate, the head owner must deliberately preserve that data-cell distinction (using the available saved sheet when appropriate), plus trailing-only/path-index negatives. This is a review requirement for the proposed head change, **not** a demonstrated additional shipping defect. |
| **Tiles-B, queued** | Owns fixed-tile/kinds/least/shapes/unpin/icons files and `test/unit/adapt-fixed-tiles-review.test.ts`; head's D2 fidelity repair must wait Tiles-B/narrow parent grant. No action-label change needs that file. |
| **found-text-decoding** | `src/ui/list-box.ts:35–40` file-reading boundary; possible `src/ui/lists.ts`/panel import tests. No source overlap with this reconciliation; shared panel lifecycle tests are preservation-only here. No decoder or file acceptance change is folded in. |
| **found-gates** | Width/lint/geometry/snap; no action-source intersection. Heavy corpus slot belongs there; unused by this planner. |
| **found-contacts** | Normalise contacts/page words/page links; no direct file overlap, but normalise feeds action recognition. Preserve current sheet/data/action controls after rebasing. |
| **found-layout / Tiles-A** | Place/nudge/turned labels vs past-edge/scene/compose/settings; no direct action-source/test writes. Rebase/integration checks only. |

Read-only branch-diff snapshot at 07:27 EDT: committed contacts changes were contacts/page-links/page-words + owned tests/plan; gates changes breakpoints/geometry/lint + tests; layout/tiles had no main-ahead committed changes at that instant. These are timestamped observations, not future lock ownership. Parent must recheck actual dirty/committed diffs before any later writer.

**Recommended sequencing:** no standalone action builder. Parent settles head consolidation/sequence from both plans. The now-Q2B-approved head feature remains queued for Tiles-B/source/test ownership integration. Carry this proof as a **preservation checklist** in that single feature; run the unchanged action suite after predicate/head edits and after Tiles-B integration. Do not import this feature's Sol routing into the head feature; its Q2B authorization came explicitly from Justin, not from this reconciliation.

## Ordered tasks / implementation handoff

### T0 — Ready: reconcile and retain (completed by this planner)
- Read brief, canonical row, .22 approved Q1A plan/ledger/HANDOFF, pending docs, current source/tests and active head plan.
- Prove release ancestry and byte-identical relevant code/tests; exercise bounded current diagnostics.
- Save this plan and raw receipts. Stop before application suites, source/test changes and shared records.

### T1 — Parent-owned: exact historical closure, not another fix
- Verify `source-and-reconciliation.json` and original five current observations.
- Apply Q1A recommendation within the existing grant: strike **only** the canonical `csv-list-pdfs builder` action-label row as fixed in **2026-10-21.22 (list-panel-followups)**, with fix `9656d5d` / release `5e32aec` and this evidence. Do not credit .22.5 or invent a new build.
- Preserve the adjacent listing-browser flake and unrelated minors. Do not close head detection/width policy, UTF-16, missing fonts or live checks.
- Tell the head owner the exact overlap and existing `rowActions` export. Parent chooses consolidation/sequence; this planner changes no shared queue/ledger.

### T2 — Optional parent-owned read-only independent confirmation
- If Q1B is selected, a fresh **Sol 6.1 xhigh** verifier can rerun the two bounded diagnostic commands against the then-current exact main, checking case counts, emitted labels, bindings and ancestry itself.
- No source write is required to confirm this existing release. Stop if the source identity or output changed; report the precise difference. Do not mutate main to prove sensitivity.
- This optional confirmation is not presented as a missing implementation, newly approved release, or completed fresh review.

### T3 — Gated: only if a genuinely new current RED appears
- **Not currently ready or approved:** no residual reproducer, patch or production allowlist exists.
- Return the exact failing fixture/output to parent. Parent must add a narrow amendment and choose one writer with found-list-head. Do not implement an invented fallback or duplicate classifier.
- Preserve these exact existing suites; in an approved worktree, focused future commands are:

```bash
node --test test/unit/list-actions.test.ts test/unit/list-pdfs-review.test.ts test/unit/understand-lists.test.ts test/unit/ui-lists.test.ts test/unit/pdf-new-tab.test.ts
node --test --test-concurrency=1 test/browser/panel.test.ts test/browser/pdf-new-tab.test.ts test/browser/list-layout.test.ts
npm run check
npm run test:browser
npm run corpus
```

- These commands are **planned, not executed here**. Future corpus/browser work must acquire its resource slot and preserve baseline reports/pastes/HTML/font sets. Garamond remains UNVERIFIED; no historical waiver carries forward. Visible output change needs before/after evidence and relevant widths, including 375/360/320; a new head-layout change additionally owes laptop 1100–1366 measurements under the head plan. Do not run broad gates solely to justify a duplicate action fix.

## Review contract / Skills / Agent Defect Loop

Loaded for this planning investigation: `figma-to-bricks` (+ rules-summary, panel-validation), `engineering-best-practices` (+ peer-review-strategy), `implementation-planning` (+ plan-validation), `systematic-debugging`, `qa-testing-local-cloud` (+ reference), `frontend-ui-repair`, `frontend-testing-workflow`, `feature-dispatch`. Skill-authoring/shared memory writes are excluded by this planner's output allowlist.

For any later approved production amendment, all roles remain **Sol 6.1 xhigh**:
- Every role: project skill and engineering baseline; frontend UI/panel/list specialist checks above.
- Builder: `test-driven-development`, `mutation-testing-discipline`, `systematic-debugging`, `frontend-ui-repair`, `frontend-testing-workflow`, `qa-testing-local-cloud`.
- Separate fresh reviewer/problem-finder: `requesting-code-review`, `code-review-practice`, `mutation-testing-discipline`, UI/QA specialists. First **spec conformance**, then **code quality**; a fresh **adversarial pass** must attempt real-cell overprotection, box-only action loss, missing-PDF data loss and panel/store lifecycle regressions. Raw current-candidate execution evidence, not summaries.
- Finisher: `receiving-code-review`, `git-commit-rules`, TDD; fixes findings test-first, stops at **ready-for-verify**, no merge/BUILD bump.
- **Agent Defect Loop skill: `frontend-ui-repair`.** Parent dispatches a new independent verifier on the same explicit model/effort to exercise required validators and findings after fixes, then resumes release only if clean and other policy/proof gates are met. Children do not spawn roles. No self-review shortcut or substituted human/live acceptance.

This planning turn supplies neither those later reviews nor a new clean-verifier claim. Since no implementation is proposed, do not manufacture builder/reviewer/finisher work to close a stale row.

## Risks, dispositions and other findings

- **Already fixed / duplicate implementation:** canonical non-PDF action-label replacement, .22 evidence above.
- **Existing approved tradeoff retained:** identical sample-word badge classified as action; spreadsheet-valued Button remains data.
- **Approved, queued under existing owner:** head recognition/action-width **Q2B** and D2 sequencing after Tiles-B/source/test ownership integration; not merged into this defect. The Q2 policy hold has cleared, with no broader label/layout expansion.
- **Existing other owner:** UTF-16 reader finding, not action binding.
- **Open / not claimed:** panel check 3av and installed PDF compatibility/live checks; listing flake; Garamond; W-B and ALONE policy exclusions.
- **New found_else defects:** none. Stale canonical status and redundant export wording are reconciliation/coordination notes, not newly invented product bugs.
- Risk of optional broadening: “protect every Button” would freeze genuine data; “never use leftover columns” would break sample binding. Both are explicitly rejected by existing tests and this plan.

## Docs & records — last, parent/finisher only

1. **This no-code reconciliation:** parent updates only the exact canonical status/ownership record with .22 credit and evidence; no new release, BUILD bump, source/test commit, new paste-check number or historical ledger rewrite is needed. This planner writes none of those shared files.
2. If parent elects to preserve this as repo documentation, copy to `docs/plans/2026-10-22-found-list-actions.md` in an explicitly assigned docs worktree; reference the existing `docs/plans/2026-10-21-list-panel-followups-ledger.md`, rather than inventing a new implementation ledger or RED chronology.
3. If T3 later becomes an approved implementation, its amended plan must specify its own copied plan, ledger moved to `docs/plans/found-list-actions-ledger.md`, and `docs/HANDOFF.md` update with the next free applicable panel/paste check. Preserve existing 3av and siblings' records. **BUILD is release-only**, after fresh review, independent verification, coordinated full gates and merge lock—not for this planning result.
4. No CLAUDE.md write, retry or bypass. Existing `list-panel-followups-claude-md-pending.md` already holds the .22 entry, unapplied and ordered behind older pending builds. Any genuinely new future rule belongs only in a scoped `found-list-actions-claude-md-pending.md` proposal after older pending entries; do not create redundant pending status for this no-change reconciliation. No such pending file was created here.
