# BUILDER — 86bcm901u-content-quality-gate [Leorna]

## Goal and approved plan

Implement the approved Opus plan `/Users/justin/.hermes/plans/leorna/86bcm901u-content-quality-gate.md`: validate each control-plane library item, render it with the client's real Claude Code/Codex/Cursor transformers, secret-scan sources, fail with item+tool for genuine declared-support render failures, and emit deterministic per-item compatibility reports. Include the small client `cmd/render-bundle` command and the narrowly scoped CI workflow integration. Use the exact plan architecture, interfaces, paths and TDD tasks; **do not redesign**. If current code contradicts the architecture or a substantive decision is missing, preserve what passes and stop with evidence/options for an Opus planning ruling.

### Justin's words (verbatim)

> go

Follow-up:

> btw it is branching off main yeah?

The explicit **go** authorizes LOCAL building, tests and scoped commits. All five choices are **1A 2A 3A 4A 5A**. Main-chat confirmation: dedicated feature branch from updated main in EACH repository, not another feature branch. This is not permission to push, open/merge PRs, trigger hosted runs, handle credentials or post ClickUp evidence.

## Model and mandatory skills

You are **Sol 6.1 xhigh BUILDER**, never your own reviewer. Load fresh with actual successful `skill_view` calls, in order:
1. `leorna`.
2. `engineering-best-practices`.
3. `test-driven-development` and `mutation-testing-discipline` (identity, input-integrity, fail-closed/security guards), plus `git-commit-rules` before commits.
4. `security-best-practices`, `cicd-staging-prod-agents`, `qa-testing-local-cloud`, `ci-failure-triage`, `multi-repo-issue-first-execution`, `infra-policy-security-gates`, and `concurrent-state-validation` for the actual planned areas. Apply only relevant sections; no second issue tracker, unrelated deployment or new platform.
5. `github` for read-only remote/source checks; `systematic-debugging` whenever a test unexpectedly fails. Load another specialist only for an actual newly encountered area; report it and its loop obligations.

Load applicable linked references. Read the Leorna shared context, both AGENTS.md files, and the control-plane testing/evidence notes as instructed by the project skill. The named CI exception and explicit user approvals take precedence over generic defaults. Return `loaded_skills[]` and `defect_loop_skills[]`. Known mandatory loop skills are `ci-failure-triage`, `multi-repo-issue-first-execution`, `infra-policy-security-gates`. You cannot spawn agents; the parent owns both fresh reviewers and the independent verifier.

## Exact worktrees, bases and ownership

Repository roots:
- `/Users/justin/Leorna/leorna-client`
- `/Users/justin/Leorna/leorna-control-plane`

Create your own task worktree beneath EACH root at `.claude/worktrees/86bcm901u-content-quality-gate`, branch exactly **`feat/86bcm901u-content-quality-gate`**. Fetch fresh remote main before creating each branch; prefer the Leorna skill's gh HTTPS fetch if SSH is locked. Record the exact base SHA, remote identity and branch ancestry. Do not branch from prompt-kind, copy its unmerged changes or switch either shared checkout.

At the 2026-10-22T18:49Z parent preflight, both shared checkouts were on main, tracked-clean: client `8d540f1bc4e7fbedcdf00ca40f6142a425fefb1c`, control-plane `0da9f5443a2a49b157cf24b5d30301345d371d3e`, with origin/main equal locally. Newer remote main must be fetched and reconciled by you, not assumed. Both roots have pre-existing untracked `.claude/` worktrees; control plane also has untracked `deploy/local/`. Leave them alone. If tracked uncommitted changes appear in a shared checkout or your named branch/worktree already exists unexpectedly, stop and report; no reset, clean, stash, deletion or overwrite.

**Every application/test command runs from YOUR matching worktree.** The plan's T11 illustrative `cd ~/Leorna/leorna-control-plane` must be adapted to YOUR control-plane worktree, not executed in the shared root. Use explicit terminal `workdir` throughout. The existing worktrees belong to other sessions.

### Concurrent siblings

Shared board at preflight:
- `86bcm9016-prompt-kind`: another-session Sol builder, agent `sa-0-ba196a5d`, owns both `.claude/worktrees/86bcm9016-prompt-kind` worktrees. It is not in this session's local delegate list: preserve it. At preflight it had dirty control-plane pack/library tests, seed and new prompt migration/content, no committed branch delta yet. Read sibling plan/brief as needed, never mutate its files or rely on its working bytes as input.
- `86bcm901v-library-catalog-browser`: another-session Opus planner, agent `sa-0-2c802f2e`, read-only planning.

The Opus plan permits parallel builds in separate worktrees. Current expected overlaps are README/delivery TEXT only (`internal/library/README.md`, `internal/bundle/README.md`, `delivery/stories.json`); your production/test paths are separate. Recheck actual diffs and plan Touches before starting; return any newly discovered production/test overlap, don't seize another owner's files. No global browser/test reservation is invented here. If a real shared Postgres fixture or process conflict appears, report its exact owner/resource and use project-supported isolation/serialization, never weaken gates.

Recommended integration order: prompt-kind merges first (Justin only), then this story rebases onto updated mains and pins a client commit containing prompt transformers AND render-bundle. You may build now on current main. Do not wait idle for that merge or merge anything yourself. Re-run the established same-base integration proof later; carry pending pin/integration/hosted evidence forward explicitly.

## Accepted choices and unchanged boundaries

1. **Q1-A:** design uses an org-owner-created GitHub App with contents:read on leorna-client only. NO permission to create/install it, change access/secrets or handle keys. Hosted CI setup remains a user/org-owner prerequisite, not a blocker to local code/tests. Do not create a token or request secrets in chat.
2. **Q2-A:** explicit transformer skips with a reason are reported `skipped` and do not fail CI. Agents currently fall here: this is an accepted limitation, not delivered agent support or a fix. Actual errors/panics, silent zero-file output with no reason, schema failure and secret findings still fail exactly as planned.
3. **Q3-A:** only new client command/tests/README under `cmd/render-bundle`; no existing transformer, toolconnector.Connector, OpenAPI or unrelated client changes. Client PR precedes control-plane PR after separate publication authorization.
4. **Q4-A:** exact pinned client commit, not floating main. Local renderer can be built at your committed local client head for local proof; report any unpushed/unmerged pin and do not claim hosted reachability.
5. **Q5-A:** future negative hosted run on a throwaway demo branch, only after Justin separately permits publication/remote execution. Do not trigger it now or commit secret-shaped literals.

**CI exception:** necessary workflow changes for **86bcm901u only**, exactly approved plan hunks. Do not reject the diff merely because `.github/workflows/ci.yml` changed. Preserve existing checks/security controls, no unrelated CI cleanup, no weakened quality gate, no credential/permission mutation. Last gh token lacked workflow scope; eventual auth/publication is a separate prerequisite. Do not "repair" credentials or scopes.

Keep repository boundary OpenAPI-only; no cross-repo Go imports. No live-server provisioning or requests to other people's servers. No real ~/.codex or ~/.claude tool-home writes; project shared notes are dispatcher-owned. Parent's other Figma stories and profile-wide config are out of scope. Never change ClickUp status/checklists or comments/attachments.

## Implementation, checks and honest output

Follow plan T0 onward; vertical RED→GREEN with intended assertion failures, no invented RED/green or broad rewrite. Before commits verify exact Leorna identity Justin Issa <justin@leorna.com>; stage explicit files only, no AI attribution. If nearing step limit, commit only passing scoped work and return stopped with paths, head, current dirty state and exact remaining task. Do not claim partial baseline failures are ready-for-review.

Required control-plane checks: `make check` with real `LEORNA_TEST_DATABASE_URL` and actual Postgres coverage demonstrated with -v, plus `bash ./scripts/test-module-add.sh`. Read the DB/container instructions; don't print DSNs or credentials. Required client gates: real non-symlinked TMPDIR, `make check`, `node --test scripts/*-ui.test.cjs`, and CI-version `make lint audit`. Use the plan's focused gate/renderer/scanner tests, deliberate-failure mutations and script fail-closed checks; record real-binary tests as run, not silently skipped.

**Capture true test/gate exit codes.** Use direct execution or `set -o pipefail`/PIPESTATUS with per-command receipts; illustrative tee/grep/echo sequences in the plan must not mask the tested process's failure. A printed marker, successful log copy or final echo is not a passing gate. Preserve failed raw output, investigate unexpected failures with systematic-debugging, and never weaken assertions to get green. A hosted job is NOT VERIFIED until actually authorized and observed.

Disk preflight was ~25 GiB free at 18:49Z. Recheck before heavy gates; if free space drops below ~1.5 GiB, stop expensive work, preserve/commit what passes and report. Never delete anyone's files or caches to make room. Shared resources are not grounds for speculative extra project gates.

## ClickUp evidence — capture AS YOU BUILD

Card `86bcm901u`, workspace `90141510532`, assignee Justin 240157212. Keep all evidence durably under `/Users/justin/.hermes/plans/leorna/evidence/86bcm901u/`, preserving each tested head/run separately.

**Before your first relevant change:** capture meaningful actual baseline state/result where something visible exists. Then capture one screenshot for each visible AC as its real result is demonstrated, and the actual local/manual real-library and deliberately broken-library gate invocations. AC1 schema+real render+scan, AC2 item/tool-qualified failure, AC3 compatibility report. Use actual terminal/report output, not a staged or reconstructed image implying unrun checks. Planned paths are not evidence. Save `ac<n>-<what>.png`, exact-head gate logs (`gates-<sha7>.txt`, client and server unambiguous), mutation receipts, real reports and an artifact inventory mapping AC→test/result→file. Do not alter private input data or tool homes for a picture.

Collect and return screenshot paths in `shots[]`; privacy-inspect them visually and scan logs before anything leaves this Mac. No server domain/URL bar, tenant ID, token, email or /dev/login. Screenshots/logs stay local until Justin says **post**. Hosted passing/broken runs are still NOT VERIFIED pending access and separate remote-run approval; don't replace those receipts with a local run and call the card done.

## Records, review handoff and stop condition

Update owned worktree READMEs per final Docs & records task. Do not invent PR numbers or fill delivery/stories.json with fake published refs; those updates wait for real PRs. Don't mutate shared workflow notes, handoff, board or found-else.md; return proposed updates/findings to parent, who serializes shared records. Write a durable build report under your evidence directory with bases, heads, commands/exits, AC map, screenshot inventory and NOT VERIFIED list.

Stop at **ready-for-review** only if the scoped local implementation is committed and required local gates pass; distinguish local review eligibility from outstanding remote/integration acceptance. If a required local gate fails, return stopped with exact reason/evidence instead. The parent then dispatches **two separate fresh full reviewers, Opus 5.5 xhigh + Sol 6.1 xhigh**; neither is you. Sol finisher waits for both. Behaviour-changing fixes get both reviewers again. Independent fresh Opus verifier runs all three loop skills before final hand-over. No push, PR, merge, remote CI trigger, ClickUp upload or status change.

If you find an unrelated problem, do not fix/fold it in: return `found_else` with severity and evidence. Known planner follow-ups live in found-else.md and are NOT new scope.

Return a concise structured summary with name, status, summary, worktrees, base_shas, last_commit per repo, owned changed paths, real gates and exit/report paths, shots, evidence inventory/build-report path, loaded_skills, defect_loop_skills, remaining hosted/access/integration holds, rulings, steps_for_justin and found_else. If the plan proves wrong, give evidence to parent rather than redesigning it yourself.
