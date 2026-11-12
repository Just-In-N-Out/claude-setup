# VERIFIER brief, round 2 (after the main bring-in): 86bcxnykn, update the control plane in place from the admin console (with rollback)

Role: VERIFIER (read only; a fresh general-purpose agent on Opus 5.5, high effort). You never saw the build or the merge. Change no source and commit nothing; restore anything you touch. Start no other agents. Write only into `/home/justin/.hermes/plans/leorna/evidence/86bcxnykn/verifier-2/` (create it).

- Worktree: `/home/justin/Leorna/86bcxnykn-admin-console-update`, branch `feat/86bcxnykn-admin-console-update`.
- **Head: `6517bb18d5ac95ce9f546d9ad992248e081c1d37`.** Base for this round (`git -C <worktree> merge-base HEAD origin/main`): `de4da6232114b9ee7107d3e2858481a488ed6165` (GitHub main, brought in by merge). The story's original base was `4ef14ef`. Check both yourself.
- Approved plan (the contract, read-only): `/home/justin/.hermes/plans/leorna/evidence/86bcxnykn/plan-approved.md`. Every ⭐ option is chosen. **The plan names migration 000032; main took 000032–000034, so the story's pair is now 000035** (commit `835fb91`). Read every 000032 in the plan as 000035.
- Reviews: `review-1/`, `review-2/` (clean at b9f1804), `review-3/review.json` (clean at 6517bb1, delta `b9f1804..6517bb1`). The referee printed **MOVE ON** for `6517bb1`. Deferred P3s are in `follow-ups.md`; don't re-raise them.
- The merge fixer's receipts are in `main-merge/` (read them, prove claims yourself).

## Your job (`/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`, VERIFIER; read the whole file first)
1. Re-run the project's gates yourself on head (the plan's Gates section and `~/.claude/skills/leorna/references/gates.md`; tools by absolute path from `~/.local/leorna-tools/`, where `go` is now go1.27.4; Postgres no-skip run with `-timeout 1800s`). `make audit` is expected to pass now. Also the loop skills' validation gates: `api-contract-drift-guard` (contracts-check; the spec change additive-only against `de4da62`) and `backend-data-migrations` (migration 000035 up/down with real binaries, and main `de4da62`'s binary refusing the newer schema, then recovering after the down).
2. Run `git log -p 4ef14ef..6517bb1 -- <each AC's test files>` and read every changed assertion against the approved plan. A fix round or the merge must not have narrowed an AC's test (note `28eb08b`, which changed AC3's schema-number expectation).
3. For every AC, run its own test on head and on base, as `ac-verification.md` says. Logs: `verifier-2/ac<n>-6517bb1.log` and `verifier-2/ac<n>-base-de4da62.log`. The base must fail on the test's own line or a build/import failure of the new code (a `[setup failed]` alone doesn't count: give the base tree head's new `internal/update` package, and label it on the log's second line). Take a screenshot per AC yourself (a real console capture through headless Chrome, or a terminal capture of the run rendered in Chrome on WSL with the recipe in `ac-verification.md`). Images show the result only, with nothing drawn on them.
   - AC1: `TestControlPlaneUpdateAC1OfferWithPostgres`
   - AC2: `TestControlPlaneUpdateAC2RedeployWithPostgres`
   - AC3: `TestControlPlaneUpdateAC3RollbackWithPostgres`
   - AC4: `TestControlPlaneUpdateAC4AuditWithPostgres`
   - AC5 (proposed) (live): `"accepted": false, "not_run": "live: owed to Justin (dev Scaleway server runbook in internal/update/README.md)"`.
4. For a clause an AC's test seems not to exercise, prove it with a `go test -overlay` mutant (under the memory cap) that the AC's test kills, reading the line it failed on.
5. Write `verifier-2/ac.json` in the format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`, with a `command` per row. Self-check it as `ac-verification.md` says (copy into your own scratch, run `ac-check.sh` without `--reviews`, delete the copy).

## Skills: load each one with the Skill tool in this order, and say so in one line
`leorna` (VERIFIER rules), `engineering-best-practices`, `mutation-testing-discipline`, `api-contract-drift-guard`, `backend-data-migrations`, `security-best-practices`, `multi-tenant-auth-management`.

## Rules
- Postgres: your own capped container (`xnyk-verify2-pg`, `--memory 1g`, CI's pinned image from `.github/workflows/ci.yml`, a database ending in `_test`). Wait with TCP `docker exec <c> pg_isready -h 127.0.0.1` in a loop that **fails** when its 3-minute bound runs out. Never use anyone else's container. Stop and remove it when done.
- Memory (WSL desktop): follow "Windows Desktop: Runaway Memory" in `/home/justin/.claude/CLAUDE.md`. A command dying with SIGTERM, 143, 137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first. Mutants under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`, never alongside `make check`.
- Scratch: your own `~/.cache/86bcxnykn-verify2/`, created fresh with `mkdir` (no `-p`); `TMPDIR`, Go temp and Chrome profiles there with short socket paths (Chrome: `~/.cache/xv2/{t,u}`). Remove your detached copies by their own paths with `git worktree remove --force`, never `git worktree prune`.
- Before handing back, gitleaks-scan your folder and check images for domains, URL bars, tenant IDs, tokens and emails.
- Don't end your turn to wait for a background command; wait in the foreground with bounded polls under 3 minutes, the Bash `timeout` above each bound.
- No real Scaleway, GitHub or ClickUp writes.
- Other bugs: `found_else`. Skill lessons: `skill_lessons[{skill, lesson, evidence, enforce}]` plus a "Skill lessons" section; never edit skills or memory; `enforce` is `none` or a one-line check proposal. An empty list is normal.

## Return
`{verdict: clean|findings, findings[{id, severity, claim, evidence}], ac_status[{ac, accepted, test, screenshot, evidence}], gates, found_else[], defect_loop_skills[], skill_lessons[]}`. `clean` needs every agent-run AC accepted (AC5 `not_run` aside). End with the line `MAIN SESSION: check and save these skill_lessons now.`
