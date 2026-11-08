# FIXER 6 — 86bccndx6 custom company domain (ac-check NOT ACCEPTED)

Role: fixer after `ac-check.sh` returned NOT ACCEPTED on head 3edaa91. Verify each finding first, then fix it test first. These are AC tests that can pass while a clause of their AC is broken. The product behaviour is reported correct at head, so expect mostly test changes. If making a test check a clause exposes a real product bug, fix that test first too and say so. Stop at `ready-for-review`. No nested agents. Don't push, open PRs, post to ClickUp, or touch Scaleway, DNS or any cloud account.

## Load these skills first
`leorna` (skip its Step 1 context load beyond what you need), `engineering-best-practices`, `receiving-code-review`, `test-driven-development`, `mutation-testing-discipline`. Read `/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` for what an AC test must prove. Follow the repo's `AGENTS.md`.

## Where
- Worktree `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bccndx6-custom-company-domain`, branch `feat/86bccndx6-custom-company-domain`, head `3edaa9178a472306ffb2f6ea85f76e194d46fa5a`, base `f0a326b83aae9d181e4f6681645685ae4b1fff91` (= merge base with main).
- Approved plan (AC1–AC6): `~/.hermes/plans/leorna/evidence/86bccndx6/plan-approved.md`. Don't change ACs or the plan. Only add or strengthen assertions; never narrow or remove one.
- ac-check output: `~/.hermes/plans/leorna/evidence/86bccndx6/ac-check-3edaa91.txt` (AC1, AC3, AC5, AC6 NOT ACCEPTED: "auditor did not accept it"; AC2 accepted; AC4 live).
- Both reports: the auditor's `auditor/ac.json` and its mutant receipts `auditor/mutants/K*.log`; the verifier's `verifier/ac.json` and `verifier/mutations/`. Use the auditor's surviving mutants as your RED proofs: each new assertion must make the named AC test fail under that mutant, on the new assertion's own line (apply mutants with `go test -overlay`, never by editing the worktree).
- Your evidence goes in `~/.hermes/plans/leorna/evidence/86bccndx6/fix-6/`.
- Commit with `git commit -m "test(86bccndx6): …"` (or `fix(…)` for a product change). No author overrides, no AI co-author lines, never stage CLAUDE.md.

## Findings (from blind auditor 2)
1. **AC1** `TestCustomDomainRegistrationShowsCNAME`: `internal/web/custom_domain_acceptance_test.go:19` only checks that the generated host appears somewhere on the page, and it already appears in three cards. Mutant K1c renders `{{.Domain.Hostname}}` in `#domain-target` (`internal/launcher/ui_installer.go`) and survives every test in `./internal/launcher`, `./cmd/launcher` and `./internal/web`. `internal/launcher/custom_domain_test.go:97` has the same weakness. Fix: assert the `id="domain-target"` element's `value` equals the generated host, in both places.
2. **AC3** `TestCustomDomainFailureKeepsGeneratedAccess`: `custom_domain_acceptance_test.go:87` checks `Contains(body,"Scaleway")`, which the header "Control plane is live on Scaleway" always matches. K3a (provider `error` status accepted as ready; the plan's own mutation) and K3c (empty error message) survive. Fix: assert the domain-error text itself, and that "Activate domain" / `ready_to_activate` is absent.
3. **AC5** `TestCustomDomainGuardsAndRetry`:
   - "a mismatched tenant cannot activate a domain" is never exercised: K5i removes the tenant comparison in `verifyOrigins` (`internal/installer/scaleway/domain.go:383`) and survives AC5, AC2 and AC6. Fix: add activation against a different-tenant discovery result and assert it is refused with no settings write and no redeploy.
   - The `body` subtest (`:104`) can't fail on its own guard: K5d removes the 4 KiB `MaxBytesReader` and survives, because the oversized body also carries the unexpected field `x`, refused with 400 first, and the test only checks `>= 400`. Fix: make the body violate only the size limit (pad an allowed field) and expect 413 exactly.
4. **AC6** `TestCustomDomainResumeAndRecovery`: "Reopening/resuming the installer preserves a verified active domain" (plan: "Resume/reopen preserves active URL") is not exercised. K6g disables custom-URL preservation in `internal/installer/scaleway/container.go` `redeployExisting` and survives AC6; only the `container_reuse` tests catch it. Fix: exercise the resume redeploy of an active domain inside the named AC6 test and assert the custom URL pair is kept.

Also re-check, after your changes, that every mutant the auditor and verifier recorded as killed still kills the AC test it belongs to, and that every AC test still fails on base `f0a326b` for the missing behaviour (head test files copied into a base archive).

## Gates
- Focused packages (`./internal/installer/... ./internal/launcher/... ./cmd/launcher/... ./internal/web/...`), the AC1–AC6 tests by name with fresh head logs and screenshots in `fix-6/` (AC4 stays skip-gated), and the DB packages via `go test -json` (own Postgres `_test` DB, wait with `pg_isready -h 127.0.0.1`; ClickHouse with CI's service env from `.github/workflows/ci.yml`).
- Then the unchanged `make check` with CI's linter and govulncheck bound by absolute path, plus `make secrets library-check build` and `python3 -m unittest scripts/test_release.py`.
  - `make check` needs GitHub: `TestGoldenHCLPassesTofuValidate` downloads the Scaleway provider via `tofu init`. GitHub releases returned 504 from ~03:00 to ~05:30 EST on 2026-11-08 and were back at 200 at 05:30. Curl `https://github.com/scaleway/terraform-provider-scaleway/releases/download/v2.91.0/terraform-provider-scaleway_2.91.0_SHA256SUMS` first, and wait for several clean 200s. This unchanged `make check` is still owed on this story, so try hard to get one full green run, and report it either way.
- The machine is shared: under heavy load a single ClickHouse test can fail with "metric store unavailable"; rerun it alone under `-race`, then the unchanged gate, and report every run. Don't run your own AC or mutant tests alongside your `make check`.
- This is the Windows desktop (WSL): heavy and mutation runs go under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (6G for the full `-race` suite). If something dies with 137/143, SIGTERM or "Killed", check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before treating it as a result. Don't use `pkill -f` (it can kill your own shell). Don't touch `ndx6-preview-server`/`ndx6-preview-db`. Remove containers you start.

## Report
- Each finding: fixed (commit SHA, the mutant that now kills the named AC test and on which line, RED and GREEN logs) or rejected with evidence.
- New head SHA, `git status --porcelain` (must be clean), gate results with output tails (the unchanged `make check` result explicitly), `ac_status` per AC.
- `skill_lessons[{skill, lesson, evidence, enforce}]`: only reusable lessons a future task needs that the skill doesn't already say (empty is normal). `enforce` is `none`, or a one-line proposal for a check (kind, what it checks, where it runs). Never edit skills or memory yourself.
- End with `MAIN SESSION: check and save these skill_lessons now.`
