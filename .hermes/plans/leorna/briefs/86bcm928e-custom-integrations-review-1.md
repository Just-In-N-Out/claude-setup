# REVIEWER brief — 86bcm928e custom integrations, round 1 (full)

**Role:** a fresh REVIEWER (Fable 5.2, high effort), report only, for Leorna card 86bcm928e "Custom integrations defined by the admin" (control plane, Full pipeline). You never saw the build. Change no source, commit nothing, push nothing, write nothing to ClickUp, start no agents (skip `requesting-code-review`'s "independent reviewer subagent" and auto-fix steps: you are the fresh reviewer). The only files you may write are under `/home/justin/.hermes/plans/leorna/evidence/86bcm928e/review-1/`. Scratch goes in `~/.cache/928e-review-1/` (never `/tmp`); remove it at the end. Restore anything you touch in the worktree; run mutations in your own detached copy (`git worktree add --detach`), removed with `git worktree remove --force` (never `git worktree prune`).

## Skills to load, in order (say so in one line)
`leorna` (hard rules; skip its Step 1 load except `leorna-control-plane-workflow.md` and the repo's `AGENTS.md`), `engineering-best-practices`, `requesting-code-review`, `code-review-practice`, `review-fix-cadence`, `mutation-testing-discipline`, and the specialists `security-best-practices`, `multi-tenant-auth-management`, `backend-data-migrations`, `api-contract-drift-guard`. The record format is in `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`; read it, and `references/ac-verification.md` for what `ac_status` means.

## What to review
- Worktree `/home/justin/Leorna/86bcm928e-custom-integrations`, branch `feat/86bcm928e-custom-integrations`, head `5fc0826115e9158c16b1bfb5e9897051672ab056`, base `4ef14efb46da789aec30fad1e5a988d8770140e2` (GitHub main; confirm both). 11 commits, 24 files, +3741/−98.
- Approved plan (the contract, with Justin's answers: 1A only `npx` at an exact version or digest-pinned `docker run`; 2A token variable or OAuth; 3A no delete; 4A desktop tile list unchanged; 5A own Postgres): `/home/justin/.hermes/plans/leorna/evidence/86bcm928e/plan-approved.md`.
- The ACs (whole lines in the plan): AC1 `TestCustomIntegrationAC1DefineSavesTenantOwnedTileWithPostgres`, AC2 `TestCustomIntegrationAC2ConfigurePackSyncLikePredefinedWithPostgres`, AC3 `TestCustomIntegrationAC3InvalidDefinitionBlockedWithPostgres` (all `./internal/web`).
- Review `git diff <base>...HEAD` against the plan and the `leorna` rules. Focus: tenant isolation (another company can never read, edit, configure or pack a custom tile), role checks and CSRF, the secret scan and launcher policy at define **and** configure time (can any field or parameter value smuggle a secret or an unpinned command?), audit records never holding URL/command/args/headers/values, migration 32 (up/down, round-trip and reset lists, number free vs. main), that predefined tiles behave exactly as before, form parsing edge cases, and tests that can't fail.
- Run the gates and the AC tests yourself; try mutations on the guards; don't trust the builder's summaries. The builder's evidence (`builder/INVENTORY.md` with its 11 rulings, gate logs, mutants, screenshots) is in `/home/justin/.hermes/plans/leorna/evidence/86bcm928e/`; check rulings against the plan and flag any that changes approved behaviour.
- Own Postgres: `docker run -d --name 928e-review1-pg …` as in the plan's Task 0 (`mirror.gcr.io/library/postgres:18.6-alpine3.23`, db name ending `_test`), wait with `docker exec 928e-review1-pg pg_isready -h 127.0.0.1`, remove only it at the end. Toolchain: `~/.local/leorna-toolchain/go/bin:~/.local/leorna-toolchain/bin` (golangci-lint 2.14.0, govulncheck 1.7.0, bind by absolute path).
- The machine is heavily loaded (load 30–60 on 24 cores from other sessions). `internal/web` under `-race` can pass go test's 10 min default package timeout locally (CI: ~148 s): a "test timed out after 10m0s" with a seconds-old running test is load, not a hang; rerun before judging, and run a single slow test alone before calling it a regression. Never run your own AC or mutant tests alongside `make check`.

## Severity (Justin's scale)
- **P0/P1:** a security hole, a guard bypass, a false AC, or a wrong block that breaks normal work.
- **P2:** a bug a real person or agent could plausibly hit, realistic edge cases included (inputs, configs, git operations, macOS and WSL), anything that breaks an AC or the UI, or a test that can't fail.
- **P3:** cosmetic, docs, a hole only a deliberate evasion hits, or a setup none of Justin's machines has.
Every P0–P2 needs a concrete real-use scenario of 5+ words; without one it is P3.

## Record
Write `/home/justin/.hermes/plans/leorna/evidence/86bcm928e/review-1/review.json` with `round: 1`, `scope: "full"`, `from: "4ef14efb46da789aec30fad1e5a988d8770140e2"`, `head: "5fc0826115e9158c16b1bfb5e9897051672ab056"`, ids `R1-<k>`, as `review-loop.md` says. Self-check with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo /home/justin/Leorna/86bcm928e-custom-integrations --base 4ef14efb46da789aec30fad1e5a988d8770140e2 /home/justin/.hermes/plans/leorna/evidence/86bcm928e`. Exit 2 means your file is wrong; fix it.

## Desktop memory rule
A command that dies with SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first (a bare `grep sending` also matches the startup banner). Mutation runs always under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`. Don't end your turn to wait for a background command; wait with foreground polls under 170 s (Bash `timeout` set above the poll's bound).

## Other findings and lessons
- Anything outside this story: list it in `found_else` (one line each, evidence, severity), don't fold it into findings.
- If you learn something reusable, don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section. `enforce` is `none` or a one-line proposal for a check (kind, what it checks, where it runs). An empty list is normal.

## Report back
`{verdict: clean|findings, findings[{id, severity, file_line, claim, scenario, repeats, new_fact}], ac_status[{ac, accepted, test, screenshot, evidence}], review_json, review_check_exit, defect_loop_skills[], found_else[], skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
