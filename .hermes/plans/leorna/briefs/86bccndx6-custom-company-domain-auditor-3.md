# BLIND AC AUDITOR 3 — 86bccndx6 custom company domain

Role: fresh, blind AC auditor (pipeline step 6). Prove every AC in the approved plan yourself, from only the plan and the source pins below. **Never open another role's reports, records or receipts** (no `verifier*/`, `auditor-*/`, `review-*/`, `fix-*/`, `bring-main-*/`, `builder/`, `finisher/`, `live-run/` folders, and no `follow-ups.md`, `handover.md` or `ac-check-*.txt` under the evidence root). Source is read-only: don't edit product code or tests, commit, push, open PRs, post to ClickUp, or touch Scaleway, DNS or any cloud account. No nested agents.

## Pins
- Approved plan: `/home/justin/.hermes/plans/leorna/evidence/86bccndx6/plan-approved.md` (the AC contract; read it first).
- Worktree: `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bccndx6-custom-company-domain` (branch `feat/86bccndx6-custom-company-domain`).
- Head: `44817ca1a5a10dd3f184f1550b7e131202ed31c6`.
- Base (old code): `f0a326b83aae9d181e4f6681645685ae4b1fff91` (= `git merge-base HEAD main`).
- Your folder: `/home/justin/.hermes/plans/leorna/evidence/86bccndx6/auditor/` (new and empty); output `auditor/ac.json`. Owned scratch: `/home/justin/.hermes/cache/scratch/86bccndx6-auditor-3/`.

## Load these skills and references first
`leorna` (and its references as needed), `engineering-best-practices`, `adversarial-verification-loop`, `security-best-practices`, `multi-tenant-auth-management`, `mutation-testing-discipline`. Read `/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` in full: it sets the `ac.json` format, the base-run rules (`base_log`/`base_exempt`), screenshots, receipts and the self-check. Follow the repo's `AGENTS.md`.

## What to prove
Every AC in the plan, by its exact named test (AC4 is `(live)`: no live target or grant exists, so record it `not_run` with a true live reason; never substitute a fixture pass). For each AC:
- run it on head (receipt starts `HEAD=<sha>`, keeps the test's own output and true exit) and on an isolated base copy at `f0a326b` with the head's test-only helpers; the base must fail for the missing behaviour, not a missing helper, symbol or no-match;
- read every assertion against its approved clause (`git log -p f0a326b..HEAD -- <the AC test files>` too), and for any clause the test seems not to exercise, prove it with a read-only `go test -overlay` mutant that makes the AC test fail on that clause's own assertion line;
- take your own screenshot: the real UI for visible ACs, a terminal render of your run for non-visual ones. Every cited file must be inside your folder.

Also run the gates yourself: the focused packages, the DB packages via `go test -json` with per-test skip accounting (own Postgres `_test` DB, wait with `pg_isready -h 127.0.0.1`; ClickHouse with CI's service env from `.github/workflows/ci.yml`), and the unchanged `make check` with CI's linter and govulncheck bound by absolute path.
- `make check` needs `tofu` on your run's PATH (`TestGoldenHCLPassesTofuValidate` skips silently without it: check `command -v tofu` and confirm `--- PASS`, not SKIP, with a verbose run of that one test), GitHub and the OpenTofu registry (it runs `tofu init`). Before it, curl `https://github.com/scaleway/terraform-provider-scaleway/releases/download/v2.91.0/terraform-provider-scaleway_2.91.0_SHA256SUMS` and `https://registry.opentofu.org/v1/providers/scaleway/scaleway/versions` until several clean 200s each. If either is down at the end, keep the failed log and report `make check` as environment-blocked, with the command still owed.
- The machine is shared: under heavy load a single ClickHouse test can fail with "metric store unavailable"; rerun it alone under `-race`, then the unchanged gate, and report every run. Don't run your own AC or mutant tests alongside your `make check`.
- This is the Windows desktop (WSL): heavy and mutation runs go under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (6G for the full `-race` suite). If something dies with 137/143, SIGTERM or "Killed", check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before treating it as a result. Don't touch `leorna-pg` or `ndx6-preview-*`. The WSL desktop has no host `pg_isready`: use `docker exec <container> pg_isready -h 127.0.0.1`. If Docker Desktop crashes (vhdx unmount error, `/var/run/docker.sock` gone), never restart it or WSL: report the Docker-backed gates as environment-blocked. Don't use `pkill -f`. Remove containers you start. Confirm the worktree is clean, untracked files included, before and after.

## Report
- `verdict` (clean / not clean / environment-blocked) and `ac_status` per AC, matching `auditor/ac.json`, with each AC's head log, base log (or justified `base_exempt`) and screenshot.
- Gate results with commands and output tails; any genuine source finding (P0–P3 with file:line and a real-use scenario) separate from environment limits.
- `skill_lessons[{skill, lesson, evidence, enforce}]`: only reusable lessons a future task needs that the skill doesn't already say (empty is normal). `enforce` is `none`, or a one-line proposal for a check (kind, what it checks, where it runs). Never edit skills or memory yourself.
- End with `MAIN SESSION: check and save these skill_lessons now.`
