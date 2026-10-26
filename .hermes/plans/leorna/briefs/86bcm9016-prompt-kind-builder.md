# BUILDER — 86bcm9016-prompt-kind [Leorna]

## Authorization

Justin explicitly replied **go** on 2026-10-22, approving the Opus plan at `/Users/justin/.hermes/plans/leorna/86bcm9016-prompt-kind.md` and all five ⭐ answers (**1A 2A 3A 4A 5A**). You are **Sol 6.1 xhigh BUILDER**, implementing the approved design across both repos, not redesigning or replanning.

Justin's words: `go`.

The plan's new approval/answers block is authoritative. Its historical questions remain as the approved choices, not unresolved decisions. If a design premise is false or incomplete, stop and report the exact decision needed for an Opus revision. Do not replace native commands with skills, weaken tests, introduce a fallback, or widen scope on your own.

## Mandatory skills — fresh explicit calls

Load in order: `leorna` → `engineering-best-practices` → `test-driven-development` → `mutation-testing-discipline` → `api-contract-drift-guard` → `backend-data-migrations` → `security-best-practices` → `multi-tenant-auth-management`. Also load `git-commit-rules` before committing, and `concurrent-state-validation` for worktree/shared-state ownership. Use `systematic-debugging` for any unexpected test/gate failure. Load additional relevant specialists as needed. Report the actual `loaded_skills` names.

Follow leorna Step 1 for both repos and relevant shared notes, including `clickup-evidence.md`, `leorna-control-plane-workflow.md`, live/server privacy and delivery/hand-over rules. The project/user rules override generic auto-merge, auto-fix, CI or auth advice.

**Agent Defect Loop applies** to `api-contract-drift-guard` and `backend-data-migrations`. You implement; later fresh Opus + Sol reviewers are independent problem-finders; later Sol finisher fixes; a fresh Opus verifier checks the final candidate. Children cannot spawn agents. Do not self-certify independent review/verification or merge. Return `defect_loop_skills` including any others you load.

## Exact scope and approved decisions

Implement the complete pinned Opus design and its AC→tests→evidence map, tasks, 18 mutations, gates, Docs & records and stop conditions. The plan, not this summary, supplies detailed paths and tests.

1. Add `prompt` to the server pack kinds, labels, validation/versioning, storage CHECKs (migration 21 or stop if current main invalidates its reservation), library/seed and both OpenAPI kind enums. Regenerate code.
2. Add `pr-description` starter content, seed **1.2.0**, library **0.3.0**.
3. Client accepts the kind. Claude project `.claude/commands/<name>.md` and Cursor `~/.cursor/commands/<name>.md` are user-invoked native command outputs with the plan's per-tool formatting. Codex skips each prompt with the clear warning, visible in Sync/run logs, without failing Sync. No prompt→skill fallback.
4. Copy server OpenAPI bytes exactly into the client snapshot, regenerate and prove drift checks. Preserve Connector API and existing golden files.
5. Test-first, per-AC units, real Postgres, HTTP/publish→sync integration and approved real-tool/manual proof; run both repos' full gates. Preserve actual per-command exit/report status, never infer green from a shell wrapper or a later receipt write.
6. Follow Docs & records and retain per-head evidence. Leave unrelated findings in `found_else`; do not fix them.

No `.github/workflows/*` changes for this story: the other session's exception for **86bcm901u** does not apply here. No auth bypass, cross-repo Go imports, broad connector redesign, unrelated upgrades, pushes, PRs, merges, ClickUp writes/status/checkbox changes or evidence uploads. Justin says **make a PR/push/post** separately and merges himself.

## Fresh state and worktree ownership

Repos:
- `/Users/justin/Leorna/leorna-control-plane`.
- `/Users/justin/Leorna/leorna-client`.

Your exact branch in each: **`feat/86bcm9016-prompt-kind`**.

Use isolated worktrees:
- `/Users/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm9016-prompt-kind`.
- `/Users/justin/Leorna/leorna-client/.claude/worktrees/86bcm9016-prompt-kind`.

Before the first change, reconcile fresh repo roots, git status, current remote main, existing branch/worktree ownership and the shared dispatch board. Follow clean updated-main preflight; do not reset hard or overwrite an existing feature branch/worktree. The parent observed at 2026-10-22 18:31 UTC: CP clean tracked main `0ad43a3`, 11 commits behind `origin/main`, untracked `deploy/local/` (leave untouched); client clean on merged prior feature `9c09193`. Only the primary worktree existed in either repo. Plan bases: CP `0da9f5443a2a49b157cf24b5d30301345d371d3e`; client `8d540f1bc4e7fbedcdf00ca40f6142a425fefb1c`. Verify fresh main before branch creation; stop on design-relevant drift rather than redesign. Use gh HTTPS if SSH is locked, following leorna. No parent source/test edits will occur while you own implementation.

Other-session read-only planners are on the shared board: catalog browser `86bcm901v-library-catalog-browser` (`sa-0-2c802f2e`) and content quality gate `86bcm901u-content-quality-gate` (`sa-0-e07c1bca`). They do not block independent implementation solely by existing. Preserve their owners/rows and do not restart them. You own only this plan's source/tests in your worktrees; do not write their plans/briefs. Record exact changed paths and source/test overlaps for future integration. If an actual competing writer/shared mutation is demonstrated, stop the conflicting operation, name its owner/release condition and preserve all work; never invent a global resource hold. Shared root README, contracts, library manifest/lock, delivery/stories.json and shared notes need reconciliation on later integration. Only append Build notes to your own plan; shared board/handoff/notes are dispatcher-owned, so return proposed updates instead of editing them.

Use explicit workdir on every terminal call. Scratch is under `/Users/justin/.hermes/cache/scratch`, not system temp. Client TMPDIR must resolve physically (not symlinked). Give your test runs their own temp/output paths. Confirm real DB tests ran, not silently skipped. Do not disturb another test namespace. Parent just measured 27 GiB available; recheck as needed and checkpoint/stop if below about 1.5 GiB; never delete unrelated work to free space.

## Evidence Task E — as you build

**Before the first visible behavior change**, capture meaningful untouched before-state evidence. As each visible AC and actual live/manual check runs, take the corresponding result screenshot (not a staged screenshot or end-of-task reconstruction). Nonvisual ACs need real logs/test proof. Save durably under `/Users/justin/.hermes/plans/leorna/evidence/86bcm9016/` with `ac<n>-<what>.png`, before/after pairs where meaningful, `gates-<sha7>.txt`, mutation logs and `EVIDENCE.md` mapping AC→test/result→actual artifact. Avoid overwriting planning receipts or historical evidence; separate per-run/head outputs. Return screenshot paths and provenance in `shots`.

Screenshots, gate logs and real/manual evidence are required deliverables, not a promise. Privacy-inspect each screenshot with vision and redact/crop/retake before sharing; inspect logs too. No private server domain, URL bar, tenant ID, token, email or dev-login detail may leave the Mac. Draft the ClickUp closing comment and attachment list; **do not upload/post**.

### Approved narrow real-home permission

Q5 A permits exactly **one temporary test command file** in Justin's real `~/.cursor/commands`, backed up first, removed/restored afterwards, for the Cursor slash-menu check. Do not overwrite an unrelated command or alter other configuration. Record the original file/existence and exact path; retain a private backup, verify restoration, and capture the result. This does not authorize writes to real `~/.codex`, `~/.claude` or other user files. Use isolated homes/projects for other real-tool tests.

### Live publish→sync requirement

Q4 A is approved: before PRs, Justin installs his own test server from this feature branch. Do **not** create cloud resources, install a server on his behalf, touch Christian/Yan servers, or expose a domain/tenant/token. Prepare the required build/install artifact and exact short hands-on prerequisite when ready; continue safe independent implementation/tests meanwhile. If no permitted server is available, stop with committed passing work and state the exact missing live proof/prerequisite, **NOT VERIFIED**. Do not claim full acceptance or silently switch to after-merge/skip. A server-dependent stop does not erase completed tests/evidence.

## Commits and return boundary

Use the repo-resolved identity `Justin Issa <justin@leorna.com>`; verify before each commit. No identity override or AI attribution. Commit scoped passing work on the exact feature branches only. Do not merge local main, push, make PRs, or clean up a worktree needed by later review.

If all approved build gates/proof are complete, return **ready-for-review**, never merged/ready-to-ship. If a real trade-off, permission prerequisite, failed external gate or step limit blocks completion, return **stopped** with the exact reason, options, both worktrees, base/head SHAs, clean/dirty status, tests actually run and remaining proof. Commit passing work before an out-of-steps stop. No fabricated output.

Return concise structured fields: name, status, summary, rulings, stop_reason/steps_for_justin if needed, worktree(s), last_commit(s), base/head SHAs, complete changed_paths per repo, gates and mutations with actual results and log paths, shots, evidence inventory/NOT VERIFIED, loaded_skills, defect_loop_skills, found_else. Both independent full reviews and loop verification remain dispatcher-owned after your result.
