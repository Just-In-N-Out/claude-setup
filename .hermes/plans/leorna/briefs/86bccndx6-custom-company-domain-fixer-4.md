# FIXER 4 — 86bccndx6 custom company domain (review round 5)

Role: fixer for review round 5. Verify the finding below first, fix it test first if valid (push back with evidence if not), then stop at `ready-for-next-review`. No nested agents. Don't push, open PRs, post to ClickUp, or touch Scaleway or any cloud account.

## Load these skills first
`leorna` (skip its Step 1 context load beyond what you need), `engineering-best-practices`, `receiving-code-review`, `test-driven-development`, `mutation-testing-discipline`. Follow the repo's `AGENTS.md`.

## Where
- Worktree `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bccndx6-custom-company-domain`, branch `feat/86bccndx6-custom-company-domain`, head `e4cb538af7722f8bb37f4de32a2cd7b20ad04cdd` (main `f0a326b` merged in), merge base with main `f0a326b83aae9d181e4f6681645685ae4b1fff91`.
- Approved plan (AC1–AC6): `~/.hermes/plans/leorna/evidence/86bccndx6/plan-approved.md`. Don't change ACs; every AC test must stay green.
- Review record: `~/.hermes/plans/leorna/evidence/86bccndx6/review-5/review.json`; the reviewer's probe `review-5/probes/zz_review5_scaleway_test.go` with `probes-head.log` (fails on e4cb538) and `probes-19cbf79.log`. Use the probe as your RED test where it fits.
- Your evidence goes in `~/.hermes/plans/leorna/evidence/86bccndx6/fix-4/` (`fix-3/` shows the shape). Keep the R4-1..R4-4 fixes and earlier fixes working.
- Commit with `git commit -m "fix(86bccndx6): …"` (no author overrides, no AI co-author lines, never stage CLAUDE.md).

## Finding to fix (P2)
**R5-1** `internal/installer/scaleway/domain.go:456-462` (the UseGenerated no-op added in ea29cbc), with `:363-364` and `internal/launcher/ui_installer.go:726`. The no-op decides "already done" from the container settings alone (PUBLIC already equals the generated URL). It never checks that the container is ready or that generated discovery works. So after a Use generated domain whose settings write landed but whose redeploy or verification failed (RedeployContainer 5xx, the 2-minute operation budget, or post-redeploy discovery failing into reconcile_required), the retry the installer itself points the admin to makes no write, no redeploy and no check, and reports "Already using the generated domain; nothing was changed." After a reload the button is gone. Before ea29cbc the same retry redeployed and verified.
Suggested fix: when the settings already hold the generated pair, still require the container to be ready and generated discovery to return the generated origin with a valid tenant. If either fails, skip the settings write but redeploy and verify, and keep reconcile_required on failure. Keep the zero-write no-op for the healthy case, including the AC6 old-server assertion (0 patches, 0 redeploys). Keep the button visible while recovery is still needed. Add both probe cases to `TestDomainUseGeneratedRequiresCompatibleServerAndAChange`.

You may also fix, in the same change and only if it falls out naturally, R5-3 (the no-op forces `dns_required` even when the binding is ready) and R5-4 (`delivery/custom-company-domain.md:9` suggests `docker inspect '{{index .RepoDigests 0}}'`, which prints `<repo>@sha256:…`, while `image_digest` must be `sha256:<64 hex>`). Leave R5-2.

## Gates
Focused packages (`./internal/installer/... ./internal/launcher/... ./cmd/launcher/... ./internal/web/...`), the AC1–AC6 tests by name (AC4 stays skip-gated; recapture the AC6 screenshots if the recovery UI changes), the DB packages via `go test -json` against a Postgres/ClickHouse test container (wait with `pg_isready -h 127.0.0.1`), `make check` (should pass end to end now, audit included), `make secrets library-check build`, `python3 -m unittest scripts/test_release.py`. Mutation-test the new guard (`go test -overlay`, never edit the worktree for mutants). This is the Windows desktop (WSL): run heavy runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (6G is fine for the full `-race` suite). If something dies with 137/143, SIGTERM or "Killed", check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before reading it as a test result. Remove any containers you start.

## Report
- The finding: fixed (commit SHA, RED log, GREEN log, mutants killed) or rejected with evidence; same for any P3 you took.
- New head SHA, `git status --porcelain` (must be clean), gate results with output tails, `ac_status` per AC.
- `skill_lessons[{skill, lesson, evidence, enforce}]`: only reusable lessons a future task needs that the skill doesn't already say (empty is normal). `enforce` is `none`, or a one-line proposal for a check (kind, what it checks, where it runs). Never edit skills or memory yourself.
- End with `MAIN SESSION: check and save these skill_lessons now.`
