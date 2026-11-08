# REVIEWER 8 — 86bccndx6 custom company domain (fix-commit review)

You are a fresh, independent code reviewer for a Leorna control-plane story. You have no context from the people who built it. Report only: do not edit code, commit, push, open PRs, post to ClickUp, or touch Scaleway or any cloud account.

## The story
- ClickUp 86bccndx6, "custom company domain": an admin adds a domain they own in the installer, the installer creates a Scaleway Serverless Container custom domain, shows the DNS CNAME, and once TLS is issued the server and client discovery move to that domain, while the generated `*.functions.fnc.fr-par.scw.cloud` domain keeps working.
- Worktree `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bccndx6-custom-company-domain`, branch `feat/86bccndx6-custom-company-domain`, head `b036ab6ee92e28bebf7dfb25d74df81ec13e930f`, merge base with main `f0a326b83aae9d181e4f6681645685ae4b1fff91`.
- Approved plan with AC1–AC6: `~/.hermes/plans/leorna/evidence/86bccndx6/plan-approved.md` (read it first). AC4 is a live check only the user can run.

## Scope: round 8 reviews only the fixer-6 commits since review 7, and what they touch
`git diff 3edaa91..b036ab6` (3 commits, 4 files, +182/−10): 4ab65e1 "fix: expose the container deployer with its domain checker" (a product seam, `NewContainerDeployer`), 02ecd4b "test: make the AC1, AC3, AC5 and AC6 tests fail when a clause breaks", b036ab6 "test: AC5 guard refusals never disclose the installer CSRF token". Why: after review-7 was clean, the verifier accepted AC1–AC3, AC5, AC6, but blind auditor 2 rejected AC1, AC3, AC5 and AC6 because their named tests could pass with a clause broken (`ac-check-3edaa91.txt`: NOT ACCEPTED 4 of 6). Fixer 6 strengthened those tests (its evidence is in `fix-6/`, `SUMMARY.txt`; read it only if useful, don't trust its conclusions). The machine rebooted at 06:51 during fixer 6's last unchanged `make check`, so that gate never finished on this head.

Check in particular:
1. The new seam in 4ab65e1 changes no production behaviour (or, if it does, that the change is right and safe), and production still builds the same deployer and domain checker.
2. Each strengthened assertion checks its AC's clause from the approved plan, fails under the auditor's mutant (K1c, K3a, K3c, K5d, K5i, K6g in `auditor/mutants/`) on its own line, and no existing assertion was narrowed or removed (`git log -p 3edaa91..b036ab6 -- <AC test files>`).
3. AC5's new tenant-mismatch case and the 413 body case test real paths; AC6's new resume case exercises the real resume redeploy of an active domain.
4. The tests are not flaky (time, ordering, network) and add nothing that leaks secrets into logs.

## Load these skills first
`leorna`, `engineering-best-practices`, `requesting-code-review`, `code-review-practice`, `security-best-practices`, `multi-tenant-auth-management`. Follow the repo's `AGENTS.md`.

## Gates (local only)
Focused packages (`./internal/installer/... ./internal/launcher/... ./cmd/launcher/... ./internal/web/...`), the AC1–AC6 tests by name, and the unchanged `make check` (still owed on this story: GitHub releases returned 504 earlier on 2026-11-08, so first curl `https://github.com/scaleway/terraform-provider-scaleway/releases/download/v2.91.0/terraform-provider-scaleway_2.91.0_SHA256SUMS` until several clean 200s; if GitHub is still down at the end, report it as environment-blocked with the command owed). A Postgres/ClickHouse test container is fine: wait for Postgres with `pg_isready -h 127.0.0.1`, and give ClickHouse CI's service env from `.github/workflows/ci.yml` (`CLICKHOUSE_DB=leorna_metrics`, `CLICKHOUSE_USER=leorna_test`, its password, the pinned image), or every ClickHouse test fails with "metric store unavailable". Under heavy load a single ClickHouse test can still fail that way: rerun it alone under `-race`, then the unchanged `make check`, and report every run. Don't touch the containers `ndx6-preview-server`/`ndx6-preview-db` (not yours). This is the Windows desktop (WSL): run mutation and heavy runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (6G for the full `-race` suite). If something dies with 137/143, SIGTERM or "Killed", check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first. Remove containers you start.

## Where to write
`~/.hermes/plans/leorna/evidence/86bccndx6/review-8/review.json`, in the same schema as `review-7/review.json`, with your notes and logs in `review-8/`. That folder is the only place you write. At the end, run `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <worktree> --base f0a326b83aae9d181e4f6681645685ae4b1fff91 ~/.hermes/plans/leorna/evidence/86bccndx6` and confirm it accepts your record.

## Report
- `verdict`: clean / not clean, and `ac_status` per AC (accepted / not accepted / live-owed, with evidence).
- Findings ranked P0–P3, each with file:line, a concrete real-use failure scenario and a suggested fix. P0/P1: security hole, guard bypass, false AC, or a wrong block that breaks normal work. P2: a bug a real admin could plausibly hit, or a test that can't fail. P3: cosmetic, docs, or only reachable by deliberate evasion. A P0–P2 with no concrete real-use scenario is P3.
- Gate results with the commands and their output tails.
- `skill_lessons[{skill, lesson, evidence, enforce}]`: only reusable lessons a future task needs that the skill doesn't already say (empty is normal). `enforce` is `none`, or a one-line proposal for a check (kind, what it checks, where it runs). Never edit skills or memory yourself.
- End with: `MAIN SESSION: check and save these skill_lessons now.`
