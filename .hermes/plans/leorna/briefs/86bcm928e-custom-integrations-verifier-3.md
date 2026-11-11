# VERIFIER brief, round 3: 86bcm928e, custom integrations defined by the admin (after main was brought in)

Role: VERIFIER (read only; a fresh general-purpose agent on Opus 5.5, high effort). You never saw the build. Change no source and commit nothing; restore anything you touch. Start no other agents. Write only into `/home/justin/.hermes/plans/leorna/evidence/86bcm928e/verifier/` (empty; earlier rounds' files are in `verifier-round-*` folders: don't read them as proof).

- Worktree: `/home/justin/Leorna/86bcm928e-custom-integrations`, branch `feat/86bcm928e-custom-integrations`.
- **Head: `57b7e9b6c087741c4e4316cdcdba5b00d30710fb`.** Base (`git -C <worktree> merge-base HEAD origin/main`): **`d3e7391c23c2518d95f11fbe77e26baeb568bb86`** (GitHub main, brought in by merge `c8bbe58`). Check both yourself, and that GitHub main is still `d3e7391` (`gh api repos/LeornaAI/leorna-control-plane/commits/main --jq .sha`).
- Approved plan (read-only; includes "Justin's answers at 'make a PR' (2026-11-11)": edit POST moved to `/admin/integrations/custom/{tileID}/edit`, the connection tester resolves the company's custom tiles, migration renumbered to 000033): `/home/justin/.hermes/plans/leorna/evidence/86bcm928e/plan-approved.md`.
- History: ALL ACCEPTED on `0a45d39` (before main moved). Then merge `c8bbe58` (main `d3e7391`: #123, #124 Go 1.27.4, #125 company sign-in with migration 32, #126 connection test), fix 1 `c423592` (route clash), fix 2 `57b7e9b` (custom-tile connection test); evidence `bring-main-2/`. Review 4 (delta `0a45d39..57b7e9b`) clean; the referee printed **MOVE ON** for `57b7e9b`. Deferred P3s are in `follow-ups.md` (incl. R4-1); don't re-raise them.

## Your job (`/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`, VERIFIER; read the whole file first)
1. Re-run the project's gates yourself on head with **Go 1.27.4** (`~/.local/leorna-toolchain/go1.27.4/bin` first on PATH; check `go version` matches the tree's toolchain line; then `~/.local/leorna-toolchain/bin`, golangci-lint 2.14.0 and govulncheck 1.7.0 by absolute path): full `make check` (audit is expected to pass now), `make secrets library-check build`, `test-module-add`, `test_release`, Postgres no-skip with `-timeout 1800s` (judge skips per `leorna/references/gates.md`), `go test ./internal/web/ ./cmd/control-plane/` with no DB URL (no `panic:`), no `.github/`/contract path, authors on branch-only commits (`git log --format='%an <%ae>' HEAD ^4ef14ef ^origin/main`), no attribution lines, gitleaks over `d3e7391..HEAD`. Loop skills' validation: `api-contract-drift-guard` (contracts-check, no contract path), `backend-data-migrations` (migration **000033** up/down and round trip with main's 000032 present, and main's binary at `d3e7391` refusing then recovering after the down file). Render the gate summary as `verifier/gates-57b7e9b.png` (WSL recipe in `ac-verification.md`). Under load `internal/web -race` can hit the 10-minute default: rerun before judging.
2. Confirm the merge kept the story intact and the two fixes do what the plan's 2026-11-11 answers say (the old edit URL no longer routes; another company can't test or probe a custom tile), and look for regressions against main's #125/#126.
3. Run `git log -p 4ef14ef..57b7e9b -- <each AC's test files>` and read every changed assertion against the approved plan: no AC test narrowed (fix 1 may change the edit POST URL only).
4. For every AC: run its own test on head and on base `d3e7391`, as `ac-verification.md` says, logs `verifier/ac<n>-57b7e9b.log` and `verifier/ac<n>-base-d3e7391.log`. The base must fail on the test's own line or a build/import failure of the new code (`[setup failed]` alone doesn't count; label any base-tree additions on the log's second line). Take a screenshot per AC yourself (a real admin-console capture through headless Chrome, or a terminal capture of the run rendered in Chrome). Images show the result only: nothing drawn on them; check each for domains, URL bars, tenant IDs, tokens and emails.
   - AC1: `TestCustomIntegrationAC1DefineSavesTenantOwnedTileWithPostgres` (./internal/web)
   - AC2: `TestCustomIntegrationAC2ConfigurePackSyncLikePredefinedWithPostgres` (./internal/web)
   - AC3: `TestCustomIntegrationAC3InvalidDefinitionBlockedWithPostgres` (./internal/web)
   - No live ACs.
5. For a clause an AC's test seems not to exercise, prove it with a `go test -overlay` mutant (memory-capped) that the AC's test kills, reading the line it failed on.
6. Write `verifier/ac.json` in the format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`, with a `command` per row. Self-check it as `ac-verification.md` says (copy into your own scratch, run `ac-check.sh` without `--reviews`, delete the copy).

## Skills: load each one with the Skill tool in this order, and say so in one line
`leorna` (VERIFIER rules; skip its Step 1 load except `leorna-control-plane-workflow.md` and the repo's `AGENTS.md`), `engineering-best-practices`, `mutation-testing-discipline`, `api-contract-drift-guard`, `backend-data-migrations`, `security-best-practices`, `multi-tenant-auth-management`.

## Rules
- Postgres: your own capped container (`928e-verify3-pg`, `--memory 1g`, `mirror.gcr.io/library/postgres:18.6-alpine3.23`, a database ending in `_test`, bounded `docker exec 928e-verify3-pg pg_isready -h 127.0.0.1` wait that fails when its bound runs out); never anyone else's. Remove it when done.
- Memory (WSL desktop): follow "Windows Desktop: Runaway Memory" in `/home/justin/.claude/CLAUDE.md`. SIGTERM, 143, 137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first. Mutants under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`, never alongside `make check`.
- Scratch: your own `~/.cache/928e-verify3/`, created fresh with `mkdir` (no `-p`); `TMPDIR`, Go temp and Chrome profiles there with short socket paths (Chrome: `~/.cache/mv3/{t,u}`). Remove your detached copies by their own paths with `git worktree remove --force`, never `git worktree prune`.
- Before handing back, gitleaks-scan your verifier folder (build any key-shaped fixture text from parts).
- Don't end your turn to wait for a background command; foreground polls under 3 minutes, the Bash `timeout` above each bound.
- No real Scaleway, GitHub or ClickUp writes.
- Other bugs: `found_else`. Skill lessons: `skill_lessons[{skill, lesson, evidence, enforce}]` plus a "Skill lessons" section; never edit skills or memory; `enforce` is `none` or a one-line check proposal. An empty list is normal.

## Return
`{verdict: clean|findings, findings[{id, severity, claim, evidence}], ac_status[{ac, accepted, test, screenshot, evidence}], gates, found_else[], defect_loop_skills[], skill_lessons[]}`. `clean` needs every AC accepted. End with the line `MAIN SESSION: check and save these skill_lessons now.`
