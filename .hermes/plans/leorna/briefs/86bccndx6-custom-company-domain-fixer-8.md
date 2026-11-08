# FIXER 8 — 86bccndx6 custom company domain (verifier 4 not clean)

Role: fixer after verifier 4 returned not clean on head 8a8ebb3. Verify the gap first, then close it test first. It is an AC test that can't fail when a clause breaks. The product behaviour is reported correct at head, so expect test changes only. If making a test exercise the clause exposes a real product bug, fix that test first too and say so. Stop at `ready-for-review`. No nested agents. Don't push, open PRs, post to ClickUp, or touch Scaleway, DNS or any cloud account.

## Load these skills first
`leorna` (skip its Step 1 context load beyond what you need), `engineering-best-practices`, `receiving-code-review`, `test-driven-development`, `mutation-testing-discipline`. Read `/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` for what an AC test must prove. Follow the repo's `AGENTS.md`.

## Where
- Worktree `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bccndx6-custom-company-domain`, branch `feat/86bccndx6-custom-company-domain`, head `8a8ebb36a010476fc46d0f73897c2f2c598661e6`, base `f0a326b83aae9d181e4f6681645685ae4b1fff91` (= merge base with main).
- Approved plan (AC1–AC6): `~/.hermes/plans/leorna/evidence/86bccndx6/plan-approved.md`. Don't change ACs or the plan. Only add or strengthen assertions; never narrow or remove one.
- Verifier 4's record: `~/.hermes/plans/leorna/evidence/86bccndx6/verifier/ac.json` (AC1, AC3, AC5, AC6 accepted; AC2 not accepted; AC4 live). Its mutants and probe: `verifier/mutants/N-tls-ro.log`, `N-cname-ro.log`, `K3e.log` (and `*-supporting-focused.log`), the probe `verifier/probes/zz_verifier4_probe_test.go.txt` with `probes/v4-probe-*.log`. Use them as your RED proofs: each new assertion must make the named AC2 test fail under that mutant, on the new assertion's own line (`go test -overlay`, never by editing the worktree).
- Your evidence goes in `~/.hermes/plans/leorna/evidence/86bccndx6/fix-7/`.
- Commit with `git commit -m "test(86bccndx6): …"` (or `fix(…)` for a product change). No author overrides, no AI co-author lines, never stage CLAUDE.md.

## Gap (from verifier 4)
**AC2 `TestCustomDomainActivationPreservesGeneratedAccess` doesn't prove the CNAME and TLS parts of its plan row "No activation before CNAME/provider-ready/TLS".** Its only CNAME case (`internal/web/custom_domain_acceptance_test.go:71-74`) runs before any binding exists, so the readiness gate refuses it too, and it never tries to activate while TLS is failing. Three mutants leave AC2 green: N-tls-ro (the read-only check used by status and activation skips the TLS probe), N-cname-ro (the same check skips the CNAME probe), K3e (the CNAME check removed entirely). Under them, a ready binding with a failing TLS or CNAME shows "Activate domain" and activation switches `LEORNA_PUBLIC_BASE_URL` (patches=1); on head, no button and patches=0. Fix (tests only): in the AC2 test, once the binding is ready, set `dnsErr`, then (cleared) `tlsErr`, and assert each activation is refused with zero patches, no redeploy, `LEORNA_PUBLIC_BASE_URL` unchanged and the error status line, then clear both and continue to the ready path as before. Each of N-tls-ro, N-cname-ro and K3e must fail AC2 on its own new line.

Then re-check that every mutant verifier 4 recorded as killed (`verifier/mutants/summary.json`) still kills the AC test it belongs to, and that every AC test still fails on base `f0a326b` for the missing behaviour (head test files copied into a base archive).

## Gates
- Focused packages (`./internal/installer/... ./internal/launcher/... ./cmd/launcher/... ./internal/web/...`), the AC1–AC6 tests by name with fresh head logs and screenshots in `fix-8/` (AC4 stays skip-gated), and the DB packages via `go test -json` (own Postgres `_test` DB, wait with `pg_isready -h 127.0.0.1`; ClickHouse with CI's service env from `.github/workflows/ci.yml`).
- Then the unchanged `make check` with CI's linter and govulncheck bound by absolute path (curl `https://github.com/scaleway/terraform-provider-scaleway/releases/download/v2.91.0/terraform-provider-scaleway_2.91.0_SHA256SUMS` first for several clean 200s; it needs GitHub for `tofu init`), plus `make secrets library-check build` and `python3 -m unittest scripts/test_release.py`.
- The machine is shared: under heavy load a single ClickHouse test can fail with "metric store unavailable"; rerun it alone under `-race`, then the unchanged gate, and report every run. Don't run your own AC or mutant tests alongside your `make check`.
- This is the Windows desktop (WSL): heavy and mutation runs go under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (6G for the full `-race` suite). If something dies with 137/143, SIGTERM or "Killed", check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before treating it as a result. Don't use `pkill -f`. Don't touch `ndx6-preview-server`/`ndx6-preview-db`. Remove containers you start.

## Report
- The gap: fixed (commit SHA, the mutant that now kills the named AC test and on which line, RED and GREEN logs) or rejected with evidence.
- New head SHA, `git status --porcelain` (must be clean), gate results with output tails, `ac_status` per AC.
- `skill_lessons[{skill, lesson, evidence, enforce}]`: only reusable lessons a future task needs that the skill doesn't already say (empty is normal). `enforce` is `none`, or a one-line proposal for a check (kind, what it checks, where it runs). Never edit skills or memory yourself.
- End with `MAIN SESSION: check and save these skill_lessons now.`
