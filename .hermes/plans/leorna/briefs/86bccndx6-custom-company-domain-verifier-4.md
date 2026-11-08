# VERIFIER 4 — 86bccndx6 custom company domain

Role: fresh, read-only AC verifier (pipeline step 6). You never saw the build. Re-run the gates and prove every AC yourself on the new code and on the old code. Do not edit product source or tests, commit, push, open PRs, post to ClickUp, or touch Scaleway, DNS or any cloud account. No nested agents.

## Routing context
- Review-9 is clean on the current head: `review-check.sh` printed `MOVE ON: review-9 at 8a8ebb3 is clean`. Before it, verifier 3 on b036ab6 was not clean (AC2/AC5: no test failed with the `PhaseReady` gate in `DomainManager.Activate` removed, mutant V1; AC6: the test never lost a create response, K5f passed); fixer 7 (8a8ebb3, tests only) closed both and review-9 checked it. Verifier 3's record is archived in `verifier-b036ab6/` (its mutants are useful to re-apply, its receipts are not your proof). The previous verifier/auditor round on 3edaa91 ended NOT ACCEPTED (the blind auditor rejected AC1, AC3, AC5, AC6 because their named tests could pass with a clause broken); fixer 6 strengthened those tests (4ab65e1, 02ecd4b, b036ab6) and review-8 checked them. Justin brought main in on 2026-11-08 ("main is updated do your routine and all make sure it is all good"), and chose to fix R6-1 and keep looping (`review-6/justin.json`).
- Worktree `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bccndx6-custom-company-domain`, branch `feat/86bccndx6-custom-company-domain`.
- **Head:** `8a8ebb36a010476fc46d0f73897c2f2c598661e6`. **Base (old code):** `f0a326b83aae9d181e4f6681645685ae4b1fff91` = `git merge-base HEAD main` = local `main` = `origin/main`.
- Approved plan: `~/.hermes/plans/leorna/evidence/86bccndx6/plan-approved.md` (the AC contract; read it first).
- Evidence root `~/.hermes/plans/leorna/evidence/86bccndx6`. Write only `<evidence>/verifier/` (new; earlier verifiers are archived in `verifier-19cbf79/`, `verifier-3edaa91/` and `verifier-b036ab6/`, don't reuse their receipts) and owned scratch under `/home/justin/.hermes/cache/scratch/86bccndx6-verifier-4/`. Your record is `<evidence>/verifier/ac.json`.
- Review records `review-1`..`review-9/review.json`, fixer folders `fix-1`..`fix-7`, `bring-main-1/` (merge proofs). These are context only, never your proof.

## Load these skills and references first
`leorna` (and its references as needed), `engineering-best-practices`, `adversarial-verification-loop`, `security-best-practices`, `multi-tenant-auth-management`, `api-contract-drift-guard`, `mutation-testing-discipline`. Read `/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` in full: it sets the `ac.json` format, the base-run rules (`base_log`/`base_exempt`), screenshots and receipts, and the self-check. Follow the repo's `AGENTS.md`.

## ACs (exact named tests, in control-plane)
- AC1 `TestCustomDomainRegistrationShowsCNAME`
- AC2 `TestCustomDomainActivationPreservesGeneratedAccess`
- AC3 `TestCustomDomainFailureKeepsGeneratedAccess`
- AC4 (live) `TestCustomDomainLiveClientDiscovery`: no live target or grant exists, so record it `not_run` with a true live reason; never substitute a fixture pass.
- AC5 `TestCustomDomainGuardsAndRetry`
- AC6 `TestCustomDomainResumeAndRecovery`

For each: run it on head (receipt starts `HEAD=<sha>`, keeps the test's own output and true exit) and on an isolated base copy at `f0a326b` with the head's test-only helpers; the base must fail for the missing behaviour, not a missing helper, symbol or no-match. Check every AC assertion against its approved clause, don't trust totals. Visible ACs get a real UI screenshot taken by you; non-visual ones a terminal render of the run. Every cited file must be inside `verifier/`; never copy another role's receipts.
Also confirm the review findings are closed with their own probes: review-5 `review-5/probes/zz_review5_scaleway_test.go`, review-6 `review-6/probes/zz_review6_scaleway_test.go`, review-7 `review-7/probes/zz_review7_scaleway_test.go` (via `go test -overlay`), and re-apply the earlier blind auditor's and verifier 3's mutants (`auditor-3edaa91/mutants/K*.log` and `verifier-b036ab6/mutants/`, rebuilt from their diffs) against the named AC tests to confirm each now fails on its clause's own line, and spot-check the merge proofs in `bring-main-1/`.

## Gates
- Focused packages, the DB packages via `go test -json` (own Postgres `_test` DB; wait with `pg_isready -h 127.0.0.1`; ClickHouse with CI's service env from `.github/workflows/ci.yml`), and per-test skip accounting as the `leorna` skill says.
- Then `make check` with CI's linter and govulncheck bound by absolute path, `make secrets library-check build`, `python3 -m unittest scripts/test_release.py`, and `bash ./scripts/test-module-add.sh`, run serially with make (it edits `go.work`).
- The unchanged client consumer check against `leorna-client` (pinned `feafa3cdf8fafaa1e07a92e32a698b5d9a9ac2c6`), as supporting proof only.
- `make check` needs `tofu` on your run's PATH (`TestGoldenHCLPassesTofuValidate` skips silently without it: check `command -v tofu` and confirm `--- PASS`, not SKIP, with a verbose run of that one test) and GitHub (it runs `tofu init`). It passed on 8a8ebb3 in review-9; curl `https://github.com/scaleway/terraform-provider-scaleway/releases/download/v2.91.0/terraform-provider-scaleway_2.91.0_SHA256SUMS` before yours, and if GitHub 504s again, report the gate as environment-blocked with the command owed (never as passed).
- The machine is shared: under heavy load a single ClickHouse test can fail with "metric store unavailable"; rerun it alone under `-race`, then the unchanged gate, and report every run. Don't run your own AC or mutant tests alongside your `make check`.
- This is the Windows desktop (WSL): heavy and mutation runs go under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (6G for the full `-race` suite). If something dies with 137/143, SIGTERM or "Killed", check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before treating it as a result. Don't touch `ndx6-preview-server`/`ndx6-preview-db`. Remove containers you start. Confirm the worktree is clean, untracked files included, before and after.

## Report
- `verdict` (clean / not clean / environment-blocked) and `ac_status` per AC, matching `verifier/ac.json`, with each AC's head log, base log (or justified `base_exempt`) and screenshot.
- Gate results with the commands and output tails; any genuine source finding separate from environment limits.
- `skill_lessons[{skill, lesson, evidence, enforce}]`: only reusable lessons a future task needs that the skill doesn't already say (empty is normal). `enforce` is `none`, or a one-line proposal for a check (kind, what it checks, where it runs). Never edit skills or memory yourself.
- End with `MAIN SESSION: check and save these skill_lessons now.`
