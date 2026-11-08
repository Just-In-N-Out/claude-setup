# REVIEWER 5 — 86bccndx6 custom company domain (fix-commit review)

You are a fresh, independent code reviewer for a Leorna control-plane story. You have no context from the people who built it. Report only: do not edit code, commit, push, open PRs, post to ClickUp, or touch Scaleway or any cloud account.

## The story
- ClickUp 86bccndx6, "custom company domain": an admin adds a domain they own in the installer, the installer creates a Scaleway Serverless Container custom domain, shows the DNS CNAME, and once TLS is issued the server and client discovery move to that domain, while the generated `*.functions.fnc.fr-par.scw.cloud` domain keeps working.
- Worktree `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bccndx6-custom-company-domain`, branch `feat/86bccndx6-custom-company-domain`, head `9c6f2b2bc6965cc1627f5445fe4bc3dde85d3ffa`, story base `3aa979df41568c9039007f66d7f32193e66a8533`.
- Approved plan with AC1–AC6: `~/.hermes/plans/leorna/evidence/86bccndx6/plan-approved.md` (read it first). AC4 is a live check only the user can run.

## Scope: round 5 reviews only the fix commits since review 4, and what they touch
`git diff 19cbf79..9c6f2b2` (4 commits, 13 files, +493/−17): 7204c9b (R4-1 create retry), f9b69aa (R4-2 resume redeploy of an unhealthy custom-domain server, new `VerifyConfiguredPair`), ea29cbc (R4-3 Use generated domain: capability check, no-op, button visibility), 9c6f2b2 (R4-4 live test binds a deployed tag to its digest through registry reads). Read the code those changes call and are called by, and check they didn't break anything around them. Review-4's record is `~/.hermes/plans/leorna/evidence/86bccndx6/review-4/review.json`. The fixer's evidence is in `fix-3/` (read it only if useful; don't trust its conclusions).

Check in particular:
1. Each R4-1..R4-4 is really fixed for the scenario in review-4, and its new test would fail if the fix were reverted (try that in a `go -overlay` scratch copy, never in the worktree).
2. R4-1: the protection against a lost create response still holds (no duplicate binding when the first create did succeed but the read lags).
3. R4-2: `VerifyConfiguredPair` can't be satisfied by another container's or another project's binding, or by a DNS/TLS probe that hits a private, loopback or link-local address; an unproven pair still makes zero writes.
4. R4-3: the no-op and the button-visibility rules don't hide the button when recovery is really needed.
5. R4-4: the registry read stays inside the selected project, is read-only, and a tag that resolves to a different digest fails. The live test is still skip-gated.
6. Admin-facing messages are clear, and the docs changes match the code.

## Load these skills first
`leorna`, `engineering-best-practices`, `requesting-code-review`, `code-review-practice`, `security-best-practices`, `multi-tenant-auth-management`, `api-contract-drift-guard`. Follow the repo's `AGENTS.md`.

## Gates (local only)
The focused packages (`./internal/installer/... ./internal/launcher/... ./cmd/launcher/... ./internal/web/...`), the AC1–AC6 tests, and `make check` (a Postgres/ClickHouse test container is fine; `make audit` fails on the base with GO-2026-6865, which is a known baseline failure). This is the Windows desktop (WSL): run mutation and heavy runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (6G is fine for the full `-race` suite). If something dies with 137/143, SIGTERM or "Killed", check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before treating it as a test result.

## Where to write
`~/.hermes/plans/leorna/evidence/86bccndx6/review-5/review.json`, in the same schema as `review-4/review.json`, with your notes and logs in `review-5/`. That folder is the only place you write. Run `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <worktree> --base 3aa979df41568c9039007f66d7f32193e66a8533 ~/.hermes/plans/leorna/evidence/86bccndx6` at the end and confirm it accepts your record.

## Report
- `verdict`: clean / not clean, and `ac_status` per AC (accepted / not accepted / live-owed, with evidence).
- Findings ranked P0–P3, each with file:line, a concrete real-use failure scenario and a suggested fix. P0/P1: security hole, guard bypass, false AC, or a wrong block that breaks normal work. P2: a bug a real admin could plausibly hit, or a test that can't fail. P3: cosmetic, docs, or only reachable by deliberate evasion. A P0–P2 with no concrete real-use scenario is P3.
- Gate results with the commands and their output tails.
- `skill_lessons[{skill, lesson, evidence, enforce}]`: only reusable lessons a future task needs that the skill doesn't already say (empty is normal). `enforce` is `none`, or a one-line proposal for a check (kind, what it checks, where it runs). Never edit skills or memory yourself.
- End with: `MAIN SESSION: check and save these skill_lessons now.`
