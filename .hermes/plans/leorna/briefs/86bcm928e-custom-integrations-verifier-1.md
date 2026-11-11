# VERIFIER brief, round 1: 86bcm928e, custom integrations defined by the admin

Role: VERIFIER (read only; a fresh general-purpose agent on Opus 5.5, high effort). You never saw the build. Change no source and commit nothing; restore anything you touch. Start no other agents. Write only into `/home/justin/.hermes/plans/leorna/evidence/86bcm928e/verifier/`.

- Worktree: `/home/justin/Leorna/86bcm928e-custom-integrations`, branch `feat/86bcm928e-custom-integrations`.
- **Head: `94fa2ee03ced193b65f76848e7e8ec09712f3668`.** Base (`git -C <worktree> merge-base HEAD origin/main`): `4ef14efb46da789aec30fad1e5a988d8770140e2`. Check both yourself (GitHub main has moved on to 89cc6e8; the merge-base is still 4ef14ef, and the story is verified against it).
- Approved plan (the contract, read-only): `/home/justin/.hermes/plans/leorna/evidence/86bcm928e/plan-approved.md`. Justin's answers 1A–5A are chosen (1A: only `npx` at an exact version or a digest-pinned `docker run`; 2A: token variable or OAuth; 3A: no delete; 4A: desktop tile list unchanged; 5A: own Postgres).
- Reviews: `review-1/review.json` (3 P2s, R1-1..R1-3, fixed in `94fa2ee`; fixer evidence in `fixer-1/`), `review-2/review.json` (clean, full, on `94fa2ee`). The referee printed **MOVE ON** for `94fa2ee`. Deferred P3s (R1-4..R1-9, R2-1) are in `follow-ups.md`; don't re-raise them.
- Builder's rulings are in `builder/INVENTORY.md`.

## Your job (`/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`, VERIFIER; read the whole file first)
1. Re-run the project's gates yourself on head (the plan's Task 11 gates section; toolchain `~/.local/leorna-toolchain/go/bin:~/.local/leorna-toolchain/bin`, golangci-lint 2.14.0 and govulncheck 1.7.0 by absolute path; Postgres no-skip run with `-timeout 1800s`) and the loop skills' validation gates (`api-contract-drift-guard`: contracts-check, no contract path in the diff; `backend-data-migrations`: migration 000032 up/down and round-trip, and the base binary's behaviour with the new table present). Known outside-the-story gate failure, to confirm and attribute, not to report as a finding: `make audit` fails on GO-2026-6859 (go1.27.3 net/http) on base `4ef14ef` too; prove the rest with `make secrets library-check build` and the remaining `make check` targets. Under load `internal/web -race` can hit go test's 10-minute default (`leorna/references/gates.md`): rerun before judging.
2. Confirm each round-1 finding is closed (R1-1, R1-2, R1-3) and look for regressions the fix caused.
3. Run `git log -p 4ef14ef..94fa2ee -- <each AC's test files>` and read every changed assertion against the approved plan: a fix round must not have narrowed an AC's test.
4. For every AC: run its own test on head and on base, as `ac-verification.md` says, with logs `verifier/ac<n>-94fa2ee.log` and `verifier/ac<n>-base-4ef14ef.log`. The base must fail on the test's own line or a build/import failure of the new code (a `[setup failed]` alone doesn't count; follow `ac-verification.md` for giving the base tree the test and labelling it on the log's second line). Take a screenshot per AC yourself (a real admin-console capture through headless Chrome, or a terminal capture of the run rendered in Chrome with the recipe in `ac-verification.md`). Images show the result only: nothing drawn on them.
   - AC1: `TestCustomIntegrationAC1DefineSavesTenantOwnedTileWithPostgres` (./internal/web)
   - AC2: `TestCustomIntegrationAC2ConfigurePackSyncLikePredefinedWithPostgres` (./internal/web)
   - AC3: `TestCustomIntegrationAC3InvalidDefinitionBlockedWithPostgres` (./internal/web)
   - No live ACs.
5. For a clause an AC's test seems not to exercise, prove it with a `go test -overlay` mutant (under the memory cap) that the AC's test kills, reading the line it failed on.
6. Write `verifier/ac.json` in the format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`, with a `command` per row. Self-check it as `ac-verification.md` says (copy into your own scratch, run `ac-check.sh` without `--reviews`, delete the copy).

## Skills: load each one with the Skill tool in this order, and say so in one line
`leorna` (VERIFIER rules; skip its Step 1 load except `leorna-control-plane-workflow.md` and the repo's `AGENTS.md`), `engineering-best-practices`, `mutation-testing-discipline`, `api-contract-drift-guard`, `backend-data-migrations`, `security-best-practices`, `multi-tenant-auth-management`.

## Rules
- Postgres: your own capped container (`928e-verify1-pg`, `--memory 1g`, `mirror.gcr.io/library/postgres:18.6-alpine3.23`, a database ending in `_test`, wait with `docker exec 928e-verify1-pg pg_isready -h 127.0.0.1`); never anyone else's. Stop and remove it when done.
- Memory (WSL desktop): follow "Windows Desktop: Runaway Memory" in `/home/justin/.claude/CLAUDE.md`. A command dying with SIGTERM, 143, 137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first. Mutants under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`, never alongside `make check`.
- Scratch: your own `~/.cache/928e-verify1/`, created fresh with `mkdir` (no `-p`); `TMPDIR`, Go temp and Chrome profiles there with short socket paths (Chrome: `~/.cache/mv1/{t,u}`). Remove your detached copies by their own paths with `git worktree remove --force`, never `git worktree prune`.
- Before handing back, gitleaks-scan your verifier folder (build any key-shaped fixture text from parts) and check images for domains, URL bars, tenant IDs, tokens and emails.
- Don't end your turn to wait for a background command; wait in the foreground with bounded polls under 3 minutes, the Bash `timeout` above each bound.
- No real Scaleway, GitHub or ClickUp writes.
- Other bugs: `found_else`. Skill lessons: `skill_lessons[{skill, lesson, evidence, enforce}]` plus a "Skill lessons" section; never edit skills or memory; `enforce` is `none` or a one-line check proposal. An empty list is normal.

## Return
`{verdict: clean|findings, findings[{id, severity, claim, evidence}], ac_status[{ac, accepted, test, screenshot, evidence}], gates, found_else[], defect_loop_skills[], skill_lessons[]}`. `clean` needs every AC accepted. End with the line `MAIN SESSION: check and save these skill_lessons now.`
