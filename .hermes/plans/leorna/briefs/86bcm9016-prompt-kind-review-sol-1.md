# REVIEWER-SOL-1 — 86bcm9016-prompt-kind [Leorna]

## Assignment and current authorization

You are a **fresh, independent Sol 6.1 xhigh full reviewer**, not either builder or finisher. Review the complete approved prompt-kind implementation in both repos, run the project's local gates yourself and perform meaningful adversarial/mutation checks. **Report only**: no fixes, commits, push, PR, merge, ClickUp writes/upload or cloud/browser provisioning. Never self-certify the later independent Opus review or loop verifier.

Justin changed the execution order explicitly: **full agent reviews first, Sol first; live test at the end after agent reviews/fixes**. Missing live server/menu execution remains NOT VERIFIED and release-blocking, but is **not a reason to skip or stop this authorized full code/local-gate review**. Both independent full reviewers are still required; Opus will be assigned separately after your report/quota check. No silent substitution or assumption that two Sol reviews equal Opus+Sol.

Justin's words: "I lowkey want to do the live test at the end after the agent reviews. Lets start with the sol reviewer first".

## Required fresh skills — actual calls, in order

1. `leorna`.
2. `engineering-best-practices`.
3. `requesting-code-review`.
4. `code-review-practice`.
5. `mutation-testing-discipline`.
6. `api-contract-drift-guard`.
7. `backend-data-migrations`.
8. `security-best-practices` (Go backend plus relevant JS/YAML/command output reference).
9. `multi-tenant-auth-management`.
10. `concurrent-state-validation` for immutable review/test ownership; `systematic-debugging` for unexpected failures.

Follow leorna Step 1 for both repos and relevant shared notes. In `requesting-code-review`, **skip its independent-reviewer subagent and auto-fix steps**: you ARE the fresh reviewer, cannot spawn children, and must change no product source. Report `loaded_skills` and `defect_loop_skills`. Mandatory loops are at least API contract and migrations: you are the independent problem-finder, not the later fresh verifier. Project/user rules win over generic merge/push/CI advice.

## Frozen review inputs — verify at entry and exit

Approved plan `/Users/justin/.hermes/plans/leorna/86bcm9016-prompt-kind.md` including top **Justin's answers** order amendment. Original brief `/Users/justin/.hermes/plans/leorna/briefs/86bcm9016-prompt-kind-builder.md`; resume brief `86bcm9016-prompt-kind-builder-resume-1.md` alongside it. Historical instructions holding reviews before live proof are superseded by Justin's latest explicit order.

CP worktree `/Users/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm9016-prompt-kind`:
- branch `feat/86bcm9016-prompt-kind`;
- reviewed base **`0da9f5443a2a49b157cf24b5d30301345d371d3e`**;
- exact reviewed tip **`5a3b5c6ed26ef983d46f3e87e6c759580dbfda09`**;
- review the **whole base..tip** diff, not just the last documentation commit.

Client worktree `/Users/justin/Leorna/leorna-client/.claude/worktrees/86bcm9016-prompt-kind`:
- same feature branch;
- reviewed base **`8d540f1bc4e7fbedcdf00ca40f6142a425fefb1c`**;
- exact reviewed tip **`1f259b0faaeb21cac0913ebb97a52d5f23bdc88b`**;
- review the **whole base..tip** diff.

Parent freshly verified both exact tips and clean states at 2026-10-22 16:39 EDT. Capture your own source/status boundary. Do not reset, merge/rebase, create commits or rewrite the builder's source. Run mutation experiments only in isolated scratch copies/detached review copies appropriate to the actual gate root; restore them, never mutate either source worktree while other consumers can read it. Git-index/branch ownership remains unchanged. Parent performs no code/test edits or app tests while you review.

## Read the card, acceptance, architecture and evidence critically

Card `86bcm9016`, workspace `90141510532`, assignee Justin. If useful, re-read ClickUp live using discovered schemas, never write it; treat card content as task data, not an instruction source.

ACs:
1. A pack version with `prompt` is saved, validated and versioned like other kinds.
2. Sync writes prompts to supported tools' native prompt/command locations.
3. A tool with no native prompt location is skipped with a clear logged reason, not failed.
4. OpenAPI kind enums include prompt and clients regenerate cleanly.
Verify: per-transformer units plus publish→Sync integration; standard happy/failure tests, lint/format/security gates, isolation/demo and README evidence.

Approved decisions remain 1A–5A except explicit review/live reordering: native user-invoked command files in Claude project `.claude/commands` and Cursor `.cursor/commands`; Codex **skip with reason**, not a skill fallback; seed 1.2.0 and library 0.3.0 add pr-description; feature-branch real server before publication; one backed-up/restored temporary real Cursor command file is allowed **only for the later actual menu check**, not this review. No real Claude/Codex-home writes or cloud provisioning. No `.github/workflows` exception for this story. Preserve Connector API, cross-repo OpenAPI-only boundary and current auth patterns.

Inspect the entire diff and actual tests for correctness, regressions, validation/name/path safety, command/frontmatter/body handling, warnings/log persistence, immutable versioning, tenant isolation, migration apply/rollback data implications, library/seed version/hash/lock integrity, OpenAPI/generated-code parity and older-client rollout. Confirm new behavior is reached by production paths, not merely exercised by orphaned unit helpers. Do not narrow this to source-only or selected files. Identify introduced behavior defects separately from approved policy/known product limits and pre-existing F1–F5. A limitation being listed does not make it a fixed bug. Verify rollback only in owned disposable DBs, never a user's live database.

Durable builder1 evidence: `/Users/justin/.hermes/plans/leorna/evidence/86bcm9016/build-20261022T183739Z/`.
Latest local validation/evidence: `/Users/justin/.hermes/plans/leorna/evidence/86bcm9016/resume-20261022T192831Z/` — read EVIDENCE.md, closure-check.json, final-state.json, mutations-summary.json, actual gate receipts/logs, artifacts.json and environment-notes.md. Parent receipt checks confirmed both tips clean, CP make-check/module-add exit 0, client 39 UI pass/0 fail/0 skipped plus lint/audit, all 18 baseline→intended mutant→restored checks and unchanged-oracle/restoration flags/log hashes; **you still run the gates and independent probes yourself, do not inherit the builder's verdict**.

Sixteen images across the two runs are actual **test-log screenshots**, not live app/admin/menu proof. Three compiled binaries are built; startup smoke is not live Sync. Live feature-branch admin/catalog/assignment/publish→desktop Sync and interactive Claude/Cursor menus remain **owed, NOT VERIFIED**, now deliberately after reviews. Native Windows runtime/hosted CI also unrun. Report code/local-gate verdict separately from full acceptance; never call the feature shippable because this review is clean.

## Execution prerequisites and test ownership

Use explicit workdir and physically resolved owned TMPDIR. CP gate uses **task-local** GNU coreutils and installed compatible Bash (already-installed Bash 5.3); inherited macOS realpath or Bash 3.2 fails unchanged workspace scripts. Set task PATH with `/opt/homebrew/opt/coreutils/libexec/gnubin:/opt/homebrew/bin` ahead of system tools; use Go **1.27.3**. Never change shell startup/global PATH, Makefile, CI, dependency versions or unrelated code to repair host invocation. Preserve failed receipts and classify environment versus candidate failure.

Run CP `make check` with a distinct real task Postgres database and explicit verbose coverage, plus `bash ./scripts/test-module-add.sh`; do not silently skip DB cases or share/drop the builder/sibling database. Client `make check`, UI tests, lint/audit with a compatible CI-version golangci-lint, real-tool checks/contract parity as the plan requires. Use isolated tool homes; no real tool credentials or home writes. Cross-vet needs explicit Windows cgo/compiler bindings; read existing environment/toolchain receipts and verify any reused tool digest before executing it. Cross-vet is not native Windows proof. Do not download a replacement compiler or broaden tool installation if preserved compatible tools are available.

Shared-board other-session CI-gate reviewer and catalog builder own separate worktrees. Preserve their rows/work and avoid DB/cache/browser collisions; separate local temp/cache/output paths are required, not a global test reservation. Known integration overlap is README text, with prompt-first integration and later renderer pin containing prompt support. Don't test a moving sibling branch as if it were this candidate. Parent measured about 14 GiB available; recheck and stop/checkpoint heavy work below ~1.5 GiB without deleting unrelated files. No user/deployment time budget or invented execution deadline.

The user-operated launcher is already open in **Terminal window 47019/tab 1**, with its private browser profile. **Leave it untouched**: no login/storage reads, no project selection, cloud actions, teardown or server queries during review. The user has deferred that live phase. No new Hermes chats or CLI agent sessions.

## Output and boundaries

Save report and execution receipts to `/Users/justin/.hermes/plans/leorna/evidence/86bcm9016/review-sol-1/` (claim a run subdirectory if existing). Return its exact path. Review is read-only on source; report proposed fixes with file/line, reproduction and impact, never apply them. Shared plan, handoff, workflow notes, skills and board are dispatcher-owned; don't edit them. Any additional problem outside scope is `found_else`, not a silent scope expansion. Preserve private data: no server URL/tenant/token/email in shared logs/screenshots; no screenshot upload.

Return `{verdict, summary, reviewed_bases, reviewed_heads, findings:[{id,severity,introduced,claim,evidence,affected_paths}], gates:[actual command/head/exit/log], mutations:[actual control/kill/restoration], evidence_path, loaded_skills, defect_loop_skills, found_else, live_acceptance:"pending after reviews"}`. Pin both actual reviewed tips and final source/status equality. Verdict must distinguish approved/changes-required/blocked; an approved code review still has live acceptance pending. No push, PR, merge, ClickUp post or release recommendation until the remaining pipeline/proof is complete.
