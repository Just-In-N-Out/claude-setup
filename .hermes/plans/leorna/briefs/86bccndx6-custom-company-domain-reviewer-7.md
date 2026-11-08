# REVIEWER 7 — 86bccndx6 custom company domain (fix-commit review)

You are a fresh, independent code reviewer for a Leorna control-plane story. You have no context from the people who built it. Report only: do not edit code, commit, push, open PRs, post to ClickUp, or touch Scaleway or any cloud account.

## The story
- ClickUp 86bccndx6, "custom company domain": an admin adds a domain they own in the installer, the installer creates a Scaleway Serverless Container custom domain, shows the DNS CNAME, and once TLS is issued the server and client discovery move to that domain, while the generated `*.functions.fnc.fr-par.scw.cloud` domain keeps working.
- Worktree `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bccndx6-custom-company-domain`, branch `feat/86bccndx6-custom-company-domain`, head `3edaa9178a472306ffb2f6ea85f76e194d46fa5a`, merge base with main `f0a326b83aae9d181e4f6681645685ae4b1fff91`.
- Approved plan with AC1–AC6: `~/.hermes/plans/leorna/evidence/86bccndx6/plan-approved.md` (read it first). AC4 is a live check only the user can run.

## Scope: round 7 reviews only the fix commits since review 6, and what they touch
`git diff 6147a83..3edaa91` (2 commits: 1bec4db "only lock status on a recovery this installer wrote", 3edaa91 "pin that a not-ready redeploy never locks status"). Read the code they call and are called by in `internal/installer/scaleway/domain.go` (UseGenerated, `generatedHealthy`, `finishGenerated`, `updateURLs`, `compensate`, `check()` and the recovery-pending flag and `pendingTenant`), the button rules in `internal/launcher/ui_installer.go`, and the README changes. Review-6's record is `~/.hermes/plans/leorna/evidence/86bccndx6/review-6/review.json` (R6-1 P2, R6-3 and R6-4 P3 fixed; R6-2 an accepted limit with a README rewording). Justin chose to fix and keep looping (`review-6/justin.json`). The fixer's evidence is in `fix-5/` (read it only if useful; don't trust its conclusions).

Check in particular:
1. R6-1 is fixed for review-6's scenario (fresh install, nobody signed in, create failed, Use generated domain pressed: zero provider writes, setup hint kept, Check DNS not locked, the binding gets created once the cause is fixed). The review-6 probe `review-6/probes/zz_review6_scaleway_test.go` and the review-5 probe `review-5/probes/zz_review5_scaleway_test.go` both pass; the new tests fail if the fix is reverted (`go -overlay` scratch copies, never the worktree).
2. **A test expectation was changed and needs your judgement:** fixer 4's case "fresh manager, generated discovery fails" expected a redeploy; fixer 5 moved it and it now expects 0 writes. So after a launcher restart, a ready container whose generated discovery fails is no longer redeployed by the button, and resume is the route. Is that right for a real admin, or does it reopen R5-1 (an unfinished recovery that the button can no longer finish after a restart)?
3. R5-1 still holds within a session (retry after a failed redeploy redeploys and verifies; the healthy no-op is zero writes; AC6 old server: 0 patches, 0 redeploys).
4. R6-3: the compensation path records the tenant, and a retry with a different tenant is refused.
5. The flag can't be left set so the admin is stuck, and can't be cleared without a verified redeploy.
6. Admin-facing messages and the README/doc changes match the code.

## Load these skills first
`leorna`, `engineering-best-practices`, `requesting-code-review`, `code-review-practice`, `security-best-practices`, `multi-tenant-auth-management`. Follow the repo's `AGENTS.md`.

## Gates (local only)
Focused packages (`./internal/installer/... ./internal/launcher/... ./cmd/launcher/... ./internal/web/...`), the AC1–AC6 tests by name, and `make check`. A Postgres/ClickHouse test container is fine: wait for Postgres with `pg_isready -h 127.0.0.1`, and give ClickHouse CI's service env from `.github/workflows/ci.yml` (`CLICKHOUSE_DB=leorna_metrics`, `CLICKHOUSE_USER=leorna_test`, its password, the pinned image), or every ClickHouse test fails with "metric store unavailable". Under heavy load a single ClickHouse test can still fail that way: rerun it alone under `-race`, then the unchanged `make check`, and report every run. Don't touch the containers `ndx6-preview-server`/`ndx6-preview-db` (not yours). This is the Windows desktop (WSL): run mutation and heavy runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (6G for the full `-race` suite). If something dies with 137/143, SIGTERM or "Killed", check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first. Remove containers you start.

## Where to write
`~/.hermes/plans/leorna/evidence/86bccndx6/review-7/review.json`, in the same schema as `review-6/review.json`, with your notes and logs in `review-7/`. That folder is the only place you write. At the end, run `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <worktree> --base f0a326b83aae9d181e4f6681645685ae4b1fff91 ~/.hermes/plans/leorna/evidence/86bccndx6` and confirm it accepts your record.

## Report
- `verdict`: clean / not clean, and `ac_status` per AC (accepted / not accepted / live-owed, with evidence).
- Findings ranked P0–P3, each with file:line, a concrete real-use failure scenario and a suggested fix. P0/P1: security hole, guard bypass, false AC, or a wrong block that breaks normal work. P2: a bug a real admin could plausibly hit, or a test that can't fail. P3: cosmetic, docs, or only reachable by deliberate evasion. A P0–P2 with no concrete real-use scenario is P3.
- Gate results with the commands and their output tails.
- `skill_lessons[{skill, lesson, evidence, enforce}]`: only reusable lessons a future task needs that the skill doesn't already say (empty is normal). `enforce` is `none`, or a one-line proposal for a check (kind, what it checks, where it runs). Never edit skills or memory yourself.
- End with: `MAIN SESSION: check and save these skill_lessons now.`
