# FIXER 7 — 86bccndx6 custom company domain (verifier 3 not clean)

Role: fixer after verifier 3 returned not clean on head b036ab6. Verify each gap first, then close it test first. Both are AC tests that can't fail when a clause breaks. The product behaviour is reported correct at head, so expect test changes only. If making a test exercise the clause exposes a real product bug, fix that test first too and say so. Stop at `ready-for-review`. No nested agents. Don't push, open PRs, post to ClickUp, or touch Scaleway, DNS or any cloud account.

## Load these skills first
`leorna` (skip its Step 1 context load beyond what you need), `engineering-best-practices`, `receiving-code-review`, `test-driven-development`, `mutation-testing-discipline`. Read `/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` for what an AC test must prove. Follow the repo's `AGENTS.md`.

## Where
- Worktree `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bccndx6-custom-company-domain`, branch `feat/86bccndx6-custom-company-domain`, head `b036ab6ee92e28bebf7dfb25d74df81ec13e930f`, base `f0a326b83aae9d181e4f6681645685ae4b1fff91` (= merge base with main).
- Approved plan (AC1–AC6): `~/.hermes/plans/leorna/evidence/86bccndx6/plan-approved.md`. Don't change ACs or the plan. Only add or strengthen assertions; never narrow or remove one.
- Verifier 3's record: `~/.hermes/plans/leorna/evidence/86bccndx6/verifier/ac.json` (AC1, AC3 accepted; AC2, AC5, AC6 not accepted; AC4 live). Its mutants and probe: `verifier/mutants/V1.log`, `V1-supporting.log`, `V1-probe-head.log`, `V1-probe-V1.log`, the probe file `zz_verifier3_probe_test.go.txt`, and `mutants/K5f-vs-ac6.log`. Use them as your RED proofs: each new assertion must make the named AC test fail under that mutant, on the new assertion's own line (`go test -overlay`, never by editing the worktree).
- Your evidence goes in `~/.hermes/plans/leorna/evidence/86bccndx6/fix-7/`.
- Commit with `git commit -m "test(86bccndx6): …"` (or `fix(…)` for a product change). No author overrides, no AI co-author lines, never stage CLAUDE.md.

## Gaps (from verifier 3)
1. **AC2 `TestCustomDomainActivationPreservesGeneratedAccess` and AC5 `TestCustomDomainGuardsAndRetry`: no test fails when the readiness gate is removed.** Mutant V1 removes only `if st.Phase != domain.PhaseReady` in `DomainManager.Activate` (`internal/installer/scaleway/domain.go:317`); all five canonical tests and the whole focused `./internal/installer/scaleway` and `./internal/launcher` packages still pass. The installer route only blocks activation when `Status` returns an error; a binding still `creating`, or no binding at all with a correct CNAME, returns no error, so the phase gate is the only protection. AC2's plan row "No activation before CNAME/provider-ready/TLS" is only tried with a wrong CNAME. Fix: in both the AC2 and AC5 tests, add an activation attempt while the provider binding is `creating`, and one with no binding yet (correct CNAME), each asserting it is refused with `patches == 0` and no redeploy, and `LEORNA_PUBLIC_BASE_URL` unchanged. The earlier survivors K2a and K2a3 (`auditor-3edaa91/mutants/`) should then be killed too; check them.
2. **AC6 `TestCustomDomainResumeAndRecovery`: no lost or interrupted create.** The plan's AC6 row says "lost response reconciles without duplication", but the test never loses a create response. K5f, the plan's own "repeat Create after timeout" mutation, passes AC6 (only AC5 kills it, at `:182`). Fix: add a lost-create-response step to the AC6 test, ideally followed by reopening the manager, and assert `creates == 1` with the binding reconciled.

Then re-check that every mutant verifier 3 recorded as killed (`verifier/mutants/summary.json`) still kills the AC test it belongs to, and that every AC test still fails on base `f0a326b` for the missing behaviour (head test files copied into a base archive).

## Gates
- Focused packages (`./internal/installer/... ./internal/launcher/... ./cmd/launcher/... ./internal/web/...`), the AC1–AC6 tests by name with fresh head logs and screenshots in `fix-7/` (AC4 stays skip-gated), and the DB packages via `go test -json` (own Postgres `_test` DB, wait with `pg_isready -h 127.0.0.1`; ClickHouse with CI's service env from `.github/workflows/ci.yml`).
- Then the unchanged `make check` with CI's linter and govulncheck bound by absolute path (curl `https://github.com/scaleway/terraform-provider-scaleway/releases/download/v2.91.0/terraform-provider-scaleway_2.91.0_SHA256SUMS` first for several clean 200s; it needs GitHub for `tofu init`), plus `make secrets library-check build` and `python3 -m unittest scripts/test_release.py`.
- The machine is shared: under heavy load a single ClickHouse test can fail with "metric store unavailable"; rerun it alone under `-race`, then the unchanged gate, and report every run. Don't run your own AC or mutant tests alongside your `make check`.
- This is the Windows desktop (WSL): heavy and mutation runs go under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (6G for the full `-race` suite). If something dies with 137/143, SIGTERM or "Killed", check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before treating it as a result. Don't use `pkill -f`. Don't touch `ndx6-preview-server`/`ndx6-preview-db`. Remove containers you start.

## Report
- Each gap: fixed (commit SHA, the mutant that now kills the named AC test and on which line, RED and GREEN logs) or rejected with evidence.
- New head SHA, `git status --porcelain` (must be clean), gate results with output tails, `ac_status` per AC.
- `skill_lessons[{skill, lesson, evidence, enforce}]`: only reusable lessons a future task needs that the skill doesn't already say (empty is normal). `enforce` is `none`, or a one-line proposal for a check (kind, what it checks, where it runs). Never edit skills or memory yourself.
- End with `MAIN SESSION: check and save these skill_lessons now.`
