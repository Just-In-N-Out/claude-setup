# REVIEWER 9 — 86bccndx6 custom company domain (fix-commit review)

You are a fresh, independent code reviewer for a Leorna control-plane story. You have no context from the people who built it. Report only: do not edit code, commit, push, open PRs, post to ClickUp, or touch Scaleway or any cloud account.

## The story
- ClickUp 86bccndx6, "custom company domain": an admin adds a domain they own in the installer, the installer creates a Scaleway Serverless Container custom domain, shows the DNS CNAME, and once TLS is issued the server and client discovery move to that domain, while the generated `*.functions.fnc.fr-par.scw.cloud` domain keeps working.
- Worktree `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bccndx6-custom-company-domain`, branch `feat/86bccndx6-custom-company-domain`, head `8a8ebb36a010476fc46d0f73897c2f2c598661e6`, merge base with main `f0a326b83aae9d181e4f6681645685ae4b1fff91`.
- Approved plan with AC1–AC6: `~/.hermes/plans/leorna/evidence/86bccndx6/plan-approved.md` (read it first). AC4 is a live check only the user can run.

## Scope: round 9 reviews only the fixer-7 commit since review 8, and what it touches
`git diff b036ab6..8a8ebb3` (1 commit, 2 test files, +96): "test: AC2/AC5 refuse unready activation, AC6 reconciles a lost create". Why: after review-8 was clean, verifier 3 (`verifier/ac.json`) accepted AC1 and AC3 but not AC2, AC5 and AC6: no test failed when the `PhaseReady` gate in `DomainManager.Activate` (`internal/installer/scaleway/domain.go:317`) was removed (mutant V1), and AC6's test never lost a create response (K5f, "repeat Create after timeout", passed AC6). Fixer 7 added tests only (its evidence is in `fix-7/`; read it only if useful, don't trust its conclusions).

Check in particular:
1. No product code changed in the delta, and no existing assertion was narrowed or removed (`git log -p b036ab6..8a8ebb3`).
2. The new AC2/AC5 steps (activation with no binding yet and while the binding is `creating`, CNAME correct) check the plan's clause "No activation before CNAME/provider-ready/TLS", go through the real installer route and `DomainManager.Activate`, and each fails under V1 (and under K2a) on its own new line. Judge fixer 7's claim that K2a3 (the route's Status gate removed alone) is an equivalent mutant: does `Activate`'s own `check` reject every input class the route gate does?
3. The new AC6 subtests (lost create response then check; then reopen) check the plan's "lost response reconciles without duplication", fail under K5f on their own line, and use the real resume/reopen path.
4. The tests are not flaky (time, ordering, network) and add nothing that leaks secrets into logs.

## Load these skills first
`leorna`, `engineering-best-practices`, `requesting-code-review`, `code-review-practice`, `security-best-practices`, `multi-tenant-auth-management`. Follow the repo's `AGENTS.md`.

## Gates (local only)
Focused packages (`./internal/installer/... ./internal/launcher/... ./cmd/launcher/... ./internal/web/...`), the AC1–AC6 tests by name, and the unchanged `make check` (it needs `tofu` on PATH: `TestGoldenHCLPassesTofuValidate` skips silently without it, so check `command -v tofu` and confirm `--- PASS` with a verbose run of that test; it also needs GitHub, so first curl `https://github.com/scaleway/terraform-provider-scaleway/releases/download/v2.91.0/terraform-provider-scaleway_2.91.0_SHA256SUMS` until several clean 200s; if GitHub is still down at the end, report it as environment-blocked with the command owed). A Postgres/ClickHouse test container is fine: wait for Postgres with `pg_isready -h 127.0.0.1`, and give ClickHouse CI's service env from `.github/workflows/ci.yml` (`CLICKHOUSE_DB=leorna_metrics`, `CLICKHOUSE_USER=leorna_test`, its password, the pinned image), or every ClickHouse test fails with "metric store unavailable". Under heavy load a single ClickHouse test can still fail that way: rerun it alone under `-race`, then the unchanged `make check`, and report every run. Don't touch the containers `ndx6-preview-server`/`ndx6-preview-db` (not yours). This is the Windows desktop (WSL): run mutation and heavy runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (6G for the full `-race` suite). If something dies with 137/143, SIGTERM or "Killed", check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first. Remove containers you start.

## Where to write
`~/.hermes/plans/leorna/evidence/86bccndx6/review-9/review.json`, in the same schema as `review-8/review.json`, with your notes and logs in `review-9/`. That folder is the only place you write. At the end, run `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <worktree> --base f0a326b83aae9d181e4f6681645685ae4b1fff91 ~/.hermes/plans/leorna/evidence/86bccndx6` and confirm it accepts your record.

## Report
- `verdict`: clean / not clean, and `ac_status` per AC (accepted / not accepted / live-owed, with evidence).
- Findings ranked P0–P3, each with file:line, a concrete real-use failure scenario and a suggested fix. P0/P1: security hole, guard bypass, false AC, or a wrong block that breaks normal work. P2: a bug a real admin could plausibly hit, or a test that can't fail. P3: cosmetic, docs, or only reachable by deliberate evasion. A P0–P2 with no concrete real-use scenario is P3.
- Gate results with the commands and their output tails.
- `skill_lessons[{skill, lesson, evidence, enforce}]`: only reusable lessons a future task needs that the skill doesn't already say (empty is normal). `enforce` is `none`, or a one-line proposal for a check (kind, what it checks, where it runs). Never edit skills or memory yourself.
- End with: `MAIN SESSION: check and save these skill_lessons now.`
