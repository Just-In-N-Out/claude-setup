# REVIEWER 11 — 86bccndx6 custom company domain (fix-commit review)

You are a fresh, independent code reviewer for a Leorna control-plane story. You have no context from the people who built it. Report only: do not edit code, commit, push, open PRs, post to ClickUp, or touch Scaleway or any cloud account.

## The story
- ClickUp 86bccndx6, "custom company domain": an admin adds a domain they own in the installer, the installer creates a Scaleway Serverless Container custom domain, shows the DNS CNAME, and once TLS is issued the server and client discovery move to that domain, while the generated `*.functions.fnc.fr-par.scw.cloud` domain keeps working.
- Worktree `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bccndx6-custom-company-domain`, branch `feat/86bccndx6-custom-company-domain`, head `e6ea3d7f0ec1082be6330a2405835c637de5d6cb`, merge base with main `9fce72dee016b21e3d8db50225ca6aeccd542fc1`.
- Approved plan with AC1–AC6: `~/.hermes/plans/leorna/evidence/86bccndx6/plan-approved.md` (read it first). AC4 is a live check only the user can run.

## Scope: round 11 reviews only the bring-main-2 merge since review 10, and what it touches
`e6ea3d7` merges main `9fce72d` (PR #114, 86bccndx6's sibling 86bcm928t, integration governance and usage) into the reviewed head `44817ca`. The fixer's evidence and merge proofs are in `bring-main-2/` (`merge-proofs.txt`, `interaction-check.txt`, `interaction-mutant-e6ea3d7.log`); read them only if useful, don't trust their conclusions. Per the `leorna` skill's merge-verification guidance, review only the files both sides changed (only `delivery/stories.json`, hand-resolved: main's file plus this story's entry appended last), and spot-check the proofs yourself (one-side files equal their side's blob, the story patch survived, no file outside the both-sides set differs from both parents, no duplicate migrations).

Then check how #114's code meets the story's:
1. #114's new `internal/web/integration_governance_test.go:62-66` sets the story's `handler.discovery`/`discoveryHost` and its tests call `/v1/client/...` through the story's `requireClient` host binding. Is that setup correct for the story's binding, and does any real (non-test) #114 path reach the client API without the host the story requires?
2. #114's non-test changes (`internal/integration/reach.go`, the `internal/itembuilder/builder.go` guard, the new section on GET `/admin/content-usage`) under the story's generated-host redirect (`internal/web/custom_domain_browser.go`: GET-only, query dropped) and `/.well-known/leorna` / `LEORNA_PUBLIC_BASE_URL`.
3. Anything else in the 5 #114 commits that a custom-domain admin or client could hit differently now.

## Load these skills first
`leorna`, `engineering-best-practices`, `requesting-code-review`, `code-review-practice`, `security-best-practices`, `multi-tenant-auth-management`. Follow the repo's `AGENTS.md`.

## Gates (local only)
Focused packages (`./internal/installer/... ./internal/launcher/... ./cmd/launcher/... ./internal/web/...`), the AC1–AC6 tests by name, and the unchanged `make check` (it needs `tofu` on PATH: `TestGoldenHCLPassesTofuValidate` skips silently without it, so check `command -v tofu` and confirm `--- PASS` with a verbose run of that test; it also needs GitHub, so first curl `https://github.com/scaleway/terraform-provider-scaleway/releases/download/v2.91.0/terraform-provider-scaleway_2.91.0_SHA256SUMS` until several clean 200s; if GitHub is still down at the end, report it as environment-blocked with the command owed). A Postgres/ClickHouse test container is fine: wait for Postgres with `pg_isready -h 127.0.0.1`, and give ClickHouse CI's service env from `.github/workflows/ci.yml` (`CLICKHOUSE_DB=leorna_metrics`, `CLICKHOUSE_USER=leorna_test`, its password, the pinned image), or every ClickHouse test fails with "metric store unavailable". Under heavy load a single ClickHouse test can still fail that way: rerun it alone under `-race`, then the unchanged `make check`, and report every run. Don't touch the containers `ndx6-preview-server`/`ndx6-preview-db` (not yours). This is the Windows desktop (WSL): run mutation and heavy runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (6G for the full `-race` suite). If something dies with 137/143, SIGTERM or "Killed", check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first. Remove containers you start.

## Environment
Docker is up. If Docker Desktop crashes (`/var/run/docker.sock` gone), never restart it or WSL: report the Docker-backed gates as environment-blocked. The WSL desktop has no host `pg_isready`: use `docker exec <container> pg_isready -h 127.0.0.1`. Don't touch `leorna-pg` or `ndx6-preview-*`; remove containers you start. Don't use `pkill -f`. Run #114's own tests too (`TestIntegrationGovernance*WithPostgres`, `TestContentUsageIntegrationsUnavailableWithoutWiring`, `./internal/integration`, `./internal/itembuilder`).

## Where to write
`~/.hermes/plans/leorna/evidence/86bccndx6/review-11/review.json`, in the same schema as `review-10/review.json`, with your notes and logs in `review-11/`. That folder is the only place you write. At the end, run `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <worktree> --base 9fce72dee016b21e3d8db50225ca6aeccd542fc1 ~/.hermes/plans/leorna/evidence/86bccndx6` and confirm it accepts your record.

## Report
- `verdict`: clean / not clean, and `ac_status` per AC (accepted / not accepted / live-owed, with evidence).
- Findings ranked P0–P3, each with file:line, a concrete real-use failure scenario and a suggested fix. P0/P1: security hole, guard bypass, false AC, or a wrong block that breaks normal work. P2: a bug a real admin could plausibly hit, or a test that can't fail. P3: cosmetic, docs, or only reachable by deliberate evasion. A P0–P2 with no concrete real-use scenario is P3.
- Gate results with the commands and their output tails.
- `skill_lessons[{skill, lesson, evidence, enforce}]`: only reusable lessons a future task needs that the skill doesn't already say (empty is normal). `enforce` is `none`, or a one-line proposal for a check (kind, what it checks, where it runs). Never edit skills or memory yourself.
- End with: `MAIN SESSION: check and save these skill_lessons now.`
