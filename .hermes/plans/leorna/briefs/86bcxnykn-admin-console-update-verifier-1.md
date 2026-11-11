# VERIFIER brief, round 1: 86bcxnykn, update the control plane in place from the admin console (with rollback)

Role: VERIFIER (read only; a fresh general-purpose agent on Opus 5.5, high effort). You never saw the build. Change no source and commit nothing; restore anything you touch. Start no other agents. Write only into `/home/justin/.hermes/plans/leorna/evidence/86bcxnykn/verifier/`.

- Worktree: `/home/justin/Leorna/86bcxnykn-admin-console-update`, branch `feat/86bcxnykn-admin-console-update`.
- **Head: `b9f1804631fbf6ffc20d0d0d6e0e103d67dff627`.** Base (`git -C <worktree> merge-base HEAD origin/main`): `4ef14efb46da789aec30fad1e5a988d8770140e2`. Check both yourself.
- Approved plan (the contract, read-only): `/home/justin/.hermes/plans/leorna/evidence/86bcxnykn/plan-approved.md`. Every ⭐ option is chosen.
- Reviews: `review-1/review.json` (2 P2 fixed in `6035363` and `b9f1804`), `review-2/review.json` (clean, full, on `b9f1804`). Fix round 1's dispositions are summarised below. The referee printed **MOVE ON** for `b9f1804`.
- Builder's rulings 1–6 are in the evidence `INVENTORY.md` (both reviewers judged them sound; ruling 3 was narrowed by R1-3's fix).

## Your job (`/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`, VERIFIER; read the whole file first)
1. Re-run the project's gates yourself on head (the plan's Gates section; tools by absolute path from `~/.local/leorna-tools/`; Postgres no-skip run with `-timeout 1800s`) and the loop skills' validation gates (`api-contract-drift-guard`: contracts-check and additive-only spec; `backend-data-migrations`: migration 000032 up/down and the base binary refusing then recovering). Known outside-the-story gate failures, to confirm and attribute, not to report as findings: `make audit` fails on GO-2026-6859 on base `4ef14ef` too (prove the rest with `make secrets library-check build`); `make secrets` hits 12 gitleaks findings in commit `27ca94fe0` on sibling branch `feat/86bcm928e-custom-integrations` (prove the story with `gitleaks git --log-opts=<head>` and `--log-opts=<base>..<head>`).
2. Confirm each review finding is closed (R1-1, R1-2, R1-3) and look for regressions the fixes caused. The deferred P3s are in `follow-ups.md`; don't re-raise them.
3. Run `git log -p 4ef14ef..b9f1804 -- <each AC's test files>` and read every changed assertion against the approved plan: a fix round must not have narrowed an AC's test.
4. For every AC: run its own test on head and on base, as `ac-verification.md` says, with the logs `verifier/ac<n>-b9f1804.log` and `verifier/ac<n>-base-4ef14ef.log`. The base must fail on the test's own line or a build/import failure of the new code (a `[setup failed]` alone doesn't count: give the base tree head's new `internal/update` package as the builder did, and label it on the log's second line). Take a screenshot per AC yourself (a real console capture through headless Chrome, or a terminal capture of the run rendered in Chrome on WSL with the recipe in `ac-verification.md`). Images show the result only: nothing drawn on them.
   - AC1: `TestControlPlaneUpdateAC1OfferWithPostgres`
   - AC2: `TestControlPlaneUpdateAC2RedeployWithPostgres`
   - AC3: `TestControlPlaneUpdateAC3RollbackWithPostgres`
   - AC4: `TestControlPlaneUpdateAC4AuditWithPostgres`
   - AC5 (proposed) (live): `"accepted": false, "not_run": "live: owed to Justin (dev Scaleway server runbook in internal/update/README.md)"`.
5. For a clause an AC's test seems not to exercise, prove it with a `go test -overlay` mutant (under the memory cap) that the AC's test kills, reading the line it failed on.
6. Write `verifier/ac.json` in the format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`, with a `command` per row. Self-check it as `ac-verification.md` says (copy into your own scratch, run `ac-check.sh` without `--reviews`, delete the copy).

## Skills: load each one with the Skill tool in this order, and say so in one line
`leorna` (VERIFIER rules), `engineering-best-practices`, `mutation-testing-discipline`, `api-contract-drift-guard`, `backend-data-migrations`, `security-best-practices`, `multi-tenant-auth-management`.

## Rules
- Postgres: your own capped container (`xnyk-verify1-pg`, `--memory 1g`, CI's pinned image, a database ending in `_test`); never anyone else's. Stop and remove it when done.
- Memory (WSL desktop): follow "Windows Desktop: Runaway Memory" in `/home/justin/.claude/CLAUDE.md`. A command dying with SIGTERM, 143, 137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first. Mutants under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`, never alongside `make check`.
- Scratch: your own `~/.cache/86bcxnykn-verify1/`, created fresh with `mkdir` (no `-p`); `TMPDIR`, Go temp and Chrome profiles there with short socket paths (Chrome: `~/.cache/xv1/{t,u}`). Remove your detached copies by their own paths with `git worktree remove --force`, never `git worktree prune`.
- Before handing back, gitleaks-scan your verifier folder and check images for domains, URL bars, tenant IDs, tokens and emails.
- Don't end your turn to wait for a background command; wait in the foreground with bounded polls under 3 minutes, the Bash `timeout` above each bound.
- No real Scaleway, GitHub or ClickUp writes.
- Other bugs: `found_else`. Skill lessons: `skill_lessons[{skill, lesson, evidence, enforce}]` plus a "Skill lessons" section; never edit skills or memory; `enforce` is `none` or a one-line check proposal. An empty list is normal.

## Return
`{verdict: clean|findings, findings[{id, severity, claim, evidence}], ac_status[{ac, accepted, test, screenshot, evidence}], gates, found_else[], defect_loop_skills[], skill_lessons[]}`. `clean` needs every agent-run AC accepted (AC5 `not_run` aside). End with the line `MAIN SESSION: check and save these skill_lessons now.`
