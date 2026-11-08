# FIXER 3 — 86bccndx6 custom company domain

Role: fixer for review round 4. Verify each finding below first, fix the valid ones test first, push back with evidence on any that are wrong, then stop at `ready-for-next-review`. No nested agents. Don't push, open PRs, post to ClickUp, or touch Scaleway or any cloud account.

## Load these skills first
`leorna` (skip its Step 1 context load beyond what you need), `engineering-best-practices`, `receiving-code-review`, `test-driven-development`, `mutation-testing-discipline` (the findings touch guards), `security-best-practices`, `multi-tenant-auth-management`. Follow the repo's `AGENTS.md`.

## Where
- Worktree `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bccndx6-custom-company-domain`, branch `feat/86bccndx6-custom-company-domain`, head `19cbf79`, base `3aa979df41568c9039007f66d7f32193e66a8533`.
- Approved plan (AC1–AC6): `~/.hermes/plans/leorna/evidence/86bccndx6/plan-approved.md`. Don't change ACs; every AC test must stay green.
- Review record: `~/.hermes/plans/leorna/evidence/86bccndx6/review-4/review.json`, plus the reviewer's probes in `review-4/` (`probes-head.log`, `probe-live-image.log` and the probe test files). Use those probes as your RED tests where they fit.
- Your evidence goes in `~/.hermes/plans/leorna/evidence/86bccndx6/fix-3/` (the earlier `fix-2/` shows the shape). Keep the R1-1 and R2-1 fixes from fix-1/fix-2 working.
- Commit each fix on the branch with `git commit -m "fix(86bccndx6): …"` (no author overrides, no AI co-author lines, never stage CLAUDE.md).

## Findings to fix (P2)
- **R4-1** `internal/installer/scaleway/domain.go:196-207`: any CreateDomain error sets "creation uncertain", and only finding a binding clears it (`:174`). So an outright refusal that created nothing (e.g. the subdomain is bound in another project, or the quota is full) blocks every later Check for the rest of the session. Suggested fix: clear the flag once a full ListDomains shows no binding (or flag only timeouts and 5xx), then allow one new create.
- **R4-2** `internal/installer/scaleway/container.go:143-148` with `domain.go:379-402`: with a custom domain active and the server unhealthy, resume won't redeploy a fixed image and Use generated domain won't run either (both make zero writes), so the installer has no way to recover. Suggested fix: when the Scaleway records already match the configured URL pair, keep them, redeploy, then verify.
- **R4-3** `domain.go:379-383,405-426`, button at `internal/launcher/ui_installer.go:726`: Use generated domain skips the old-server check that Activate applies. On an older server image it writes and redeploys, then shows a misleading mismatch error (matches the live run, `live-run/generated-domain-diagnosis.md`). On a server already on the generated domain, it still writes once and deploys twice. Suggested fix: require the v1 header before writing, make it a no-op when already on generated, and hide the button when it isn't needed.
- **R4-4** `internal/web/custom_domain_live_test.go:68,94` vs `internal/installer/image/image.go:40`: local image mode deploys the tag `<registry>/control-plane:demo`, but the AC4 live test requires the deployed image to equal a `name@sha256:` reference, so AC4 can never pass on a local-mode install. Suggested fix: deploy by the pushed digest, or have the test check that the registry resolves the tag to that digest. Choose one and say why. The live test stays skip-gated (only Justin runs it); prove the image match offline.

The P3s (R4-5..R4-9) are not yours. Leave them; the main session files them as follow-ups.

## Gates
Run the focused tests, the AC1–AC6 tests, and `make check` (a Postgres/ClickHouse test container is fine; `make audit` already fails on the base with GO-2026-6865, so report that as a known baseline failure and don't fix it). This is the Windows desktop (WSL): run mutation and heavy test runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (6G is fine for the full `-race` suite). If something dies with 137/143, SIGTERM or "Killed", check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before reading it as a test result.

## Report
- For each finding: fixed (commit SHA, RED log, GREEN log, the mutation that the new test kills) or rejected (with evidence).
- New head SHA, `git status --porcelain` (must be clean), gate results with output tails.
- `skill_lessons[{skill, lesson, evidence, enforce}]`: list only reusable lessons a future task needs that the skill doesn't already say (empty is normal). `enforce` is `none`, or a one-line proposal for a check that would have caught a broken rule (kind, what it checks, where it runs). Never edit skills or memory yourself.
- End with `MAIN SESSION: check and save these skill_lessons now.`
