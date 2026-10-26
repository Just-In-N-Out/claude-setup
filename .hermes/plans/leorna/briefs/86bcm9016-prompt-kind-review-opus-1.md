# REVIEWER-OPUS-1 — 86bcm9016-prompt-kind [Leorna]

## Assignment / current pipeline

Fresh independent **Opus 5.5 xhigh full reviewer**, report only, for the entire feature in both repos. You are neither a builder/fixer nor the later independent loop verifier. Load `leorna` → `engineering-best-practices` → `requesting-code-review` → `code-review-practice` → `mutation-testing-discipline` → `api-contract-drift-guard` → `backend-data-migrations` → `security-best-practices` → `multi-tenant-auth-management`; also `concurrent-state-validation` and `systematic-debugging` as applicable. Use actual fresh tool calls; include `loaded_skills` and `defect_loop_skills` in return. Read relevant references and project AGENTS/shared notes as leorna Step 1 requires. Skip requesting-code-review's nested-reviewer and auto-fix steps: YOU are the independent reviewer, report only, no children.

Current cadence (`review-fix-cadence`): Sol full review → valid fixes if any → this fresh Opus full review → Sol fixes valid Opus findings if any → required fresh re-review/verifier. **Sol first full review was clean, so no no-op repair or new commit was introduced between reviews.** Review the whole feature, not just a nonexistent fix delta. Prior Sol approval is not your verdict. Fresh independent Opus verification for the API-contract/migration loops is still a later distinct assignment.

Justin explicitly reordered real live acceptance to the end after agent reviews/fixes. **Do not stop the full code/local-gate review for missing live server or native menus.** All unexecuted live requirements remain NOT VERIFIED/release-blocking; do not waive them or permit testing after merge. No deployment, cloud action, native GUI clicks, launcher/browser interaction or real tool-home writes in this review. No fixes, commits, branches/ref updates in source repos, push, PR, merge, ClickUp writes/uploads or edits to shared plan/board/notes/skills.

## Frozen input — independently verify at entry and exit

Approved plan: `/Users/justin/.hermes/plans/leorna/86bcm9016-prompt-kind.md`, top approved answers/Q4 order amendment controls older historical live-first text. Builder/resume briefs and immutable evidence are alongside the paths below.

| Repo | Original source worktree | Reviewed base | Exact candidate tip |
|---|---|---|---|
| CP | `/Users/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm9016-prompt-kind` | `0da9f5443a2a49b157cf24b5d30301345d371d3e` | `5a3b5c6ed26ef983d46f3e87e6c759580dbfda09` |
| Client | `/Users/justin/Leorna/leorna-client/.claude/worktrees/86bcm9016-prompt-kind` | `8d540f1bc4e7fbedcdf00ca40f6142a425fefb1c` | `1f259b0faaeb21cac0913ebb97a52d5f23bdc88b` |

Branch in both: `feat/86bcm9016-prompt-kind`. Parent reverified exact tips/clean status after Sol return. Whole base..tip diffs are 26 CP +16 client files. Treat the pinned ranges, not moving main/sibling tips, as this candidate. Source worktrees are read-only. Execute in owned immutable detached copies/snapshots with separate temp/cache/DB/output ownership; mutation experiments only there, restore exact original bytes and unchanged oracles. Preserve source branch refs, original worktrees and all sibling agents' files/databases/caches.

Other-session catalog builder `sa-0-08ec5b23` and quality-gate fixer `sa-0-cb9f50f7` own their separate worktrees. Do not stop/restart them or use their moving source as this candidate. Known future integration concerns: README overlap, prompt-first integration, renderer pin containing prompt support. Report any newly observed collision, don't perform an integration/rebase in a report-only review. Parent performs no source/test writes or app tests during your review.

## Scope / acceptance and accepted decisions

Card `86bcm9016`, workspace `90141510532`; read live if needed using discovered ClickUp tools, no writes. AC1 prompt pack versions save/validate/version normally. AC2 supported tools receive native prompts/commands. AC3 unsupported tools skip with clear persisted reason, without failing Sync. AC4 OpenAPI kind enums and generated clients regenerate cleanly. Review full production reachability, correctness/regressions, tenant/auth boundaries, migration up/down and data safety, path/body/name/frontmatter handling, warnings reaching persistence/UI, immutable pack versions, seed/lock/hash integrity and cross-repo contract parity. No auth bypass, Connector redesign, cross-repo Go imports or workflow changes were authorized.

Approved 1A–5A: Claude project `.claude/commands/<name>.md` with explicit user invocation; Cursor user command body-only files; Codex skip with clear persisted warning, not skills fallback; seed1.2.0/library0.3.0 with pr-description; actual feature-branch server validation before publication, now after reviews. Permission for one temporary backed-up/restored real Cursor command file belongs to the later live/menu phase only. No broader real Claude/Codex home writes or cloud provisioning.

Accepted/documented limits are not fixes: old clients fail closed on unknown prompt kinds (update desktops before assigning those versions); rollback deletes prompt rows before narrowing CHECKs; invalid tool-native slugs can fail Sync despite broader server name validation; command-body shell substitution policy, command/skill shadowing and prior F1–F5 remain follow-ups. Do not change policy or broaden scope. If you find a valid introduced defect within the approved contract, prove it and report severity/impact/file:line/reproduction; distinguish pre-existing and explicitly accepted behavior. Do not dismiss a reproduced failure because ordinary tests pass.

## Prior proof — evidence to inspect, not approval to inherit

- Original builder: `/Users/justin/.hermes/plans/leorna/evidence/86bcm9016/build-20261022T183739Z/`.
- Builder resume: `.../resume-20261022T192831Z/` including environment-notes.md, artifacts.json and closure-check.json.
- Sol full review: `/Users/justin/.hermes/plans/leorna/evidence/86bcm9016/review-sol-1/REPORT.md`, `report.json`, `closure.json`, command/mutation receipts and local probes.
- Parent artifact audit: `.../parent-checks/sol-review-1.json` — matched all175 inventory sizes/SHA-256s,16 passing gate receipts,12 qualified mutation receipts and all associated control/mutant/restored log hashes; source pins/clean status unchanged and actual required skill calls observed. Parent did not re-run product tests or make a second code-review verdict.

Sol reported no introduced findings, with full local gates,39 UI tests,12 independent mutations; actual provider-published serialized bytes into production client Sync/writers and reopened warning persistence; old production client fails closed; populated migration rollback preserves non-prompt rows. Inspect its exact probes critically after forming your independent review hypotheses; don't simply restate them as yours. Report what YOU actually execute, versus historical proof. The16 existing screenshots are test-log images only, not live app/menus. Built binaries and local wire probes are not deployed desktop acceptance or native Windows runtime proof.

## Execute required local gates and independent adversarial checks

Select task-local GNU realpath and compatible Bash: `/opt/homebrew/opt/coreutils/libexec/gnubin:/opt/homebrew/bin` ahead of system tools; Go1.27.3. CP canonical `make check`, `bash ./scripts/test-module-add.sh`, separate verbose/race tests with explicit owned Postgres DB; required prompt/Postgres tests must actually run. **Owned test DB names must end `_test`** for resetDatabase guard; derive actual fixture constraints before allocating. Do not drop/reuse sibling DBs. **Do not use `GO=go -v`**: Go verbosity goes after `test`; retain canonical make gate plus separate verbose execution. All observations/failures must have receipts pinned to exact source and invocation. No global PATH/startup, dependency/Makefile/CI changes to fix host invocation.

Client canonical `make check`,39 UI tests (`node --test scripts/*-ui.test.cjs`), `make lint audit` with CI-compatible golangci-lint (existing2.14.0) and isolated real-tool tests; explicit Windows cgo/cross-vet bindings when required. Derive/reverify preserved binaries/toolchain archive from Sol's `tool-bindings.json` and `cross-toolchain-reverified.json`/resume environment notes before reusing, avoiding a redundant multi-GB compiler download. Never claim cross-vet as native Windows execution. Required gates and optional/env-gated skips must be named separately, not hidden by an exit0.

Perform independent sensitivity/adversarial probes appropriate to all changes, including guard widening, contract drift, DB constraints/rollback, output injection/paths, unsupported-tool warning production wiring/persistence and tenant isolation. A valid mutation kill requires green control, intended failure, unchanged oracle, exact source restoration and restored green; preserve logs/hashes/patches. An ambiguous edit refused before execution is not a kill. Do not modify original source worktrees. Probe databases/disposable tool homes only; no actual deployed API or GUI use in this phase.

About13GiB free was observed at dispatch preparation; recheck, reuse verified compatible existing tools where safe, keep test-state ownership separate, checkpoint heavy work before ~1.5GiB free rather than deleting unrelated files. No invented execution deadline. Do not read launcher private browser storage/credentials: user Terminal47019/tab1 and its browser are on hold and must remain untouched.

## Output

Save full report and per-command/mutation receipts/logs to `/Users/justin/.hermes/plans/leorna/evidence/86bcm9016/review-opus-1/` (claim unique run subdir if already present). Include complete reviewed bases/tips, actual gate commands/exit/log hashes and skips, mutation control/failure/restoration, loaded and loop skills, source equality/clean status at exit, and `found_else`. Preserve all historical artifacts; don't overwrite Sol evidence.

Return `{verdict: approved|changes-required|blocked, summary, reviewed_bases, reviewed_heads, findings:[{id,severity,introduced,claim,evidence,affected_paths}], gates, mutations, loaded_skills, defect_loop_skills, found_else, evidence_path, full_report, live_acceptance:"pending after reviews"}`. Clean code/local approval is not release approval. Dispatcher handles valid fixes, final independent review/verifier, owed live/menu proof and later hand-over. Nothing published or uploaded without Justin's separate authorization.
