# REVIEWER brief, round 1 (full): 86bcxnykn, update the control plane in place from the admin console (with rollback)

Role: REVIEWER, round 1 of the review loop (a fresh general-purpose agent on Fable 5.2, high effort). **Report only:** change no source, commit nothing, push nothing, and restore anything you touch. You never saw the build. Start no other agents. Skip `requesting-code-review`'s "independent reviewer subagent" and auto-fix steps: you are the fresh reviewer.

- Worktree: `/home/justin/Leorna/86bcxnykn-admin-console-update`, branch `feat/86bcxnykn-admin-console-update`. Review it read-only; run probes in your own detached copies (`git archive <sha> | tar -x` into your scratch, or `git worktree add --detach` under your own scratch, removed by its own path afterwards, never `git worktree prune`).
- Head: `91326925e7af53413e8217578bde84e8916a4964`. Base (merge-base with `origin/main`): `4ef14efb46da789aec30fad1e5a988d8770140e2`. Review `git diff 4ef14ef...9132692`: 49 files, +7110/−23.
- Approved plan (read-only copy; the contract): `/home/justin/.hermes/plans/leorna/evidence/86bcxnykn/plan-approved.md`. Read all of it, including "Justin's answers" (every ⭐ option: Q1 A, Q2 A, Q3 A, Q4 A).
- Evidence root: `/home/justin/.hermes/plans/leorna/evidence/86bcxnykn/`. You write **only** in `review-1/`. The builder's receipts are in the root and `build/` (INVENTORY.md, gates-9132692.txt, mutants-9132692.txt, migration-000032-9132692.txt, ac<n>-9132692.log, the AC screenshots). Treat them as claims to check, not facts.

## Story and ACs
The admin console shows a newer stable release with its notes; only admins can start an update; the control plane redeploys itself to the release's image digest (never a tag), runs forward-only migrations, and shows the new version; a failed health check redeploys the previous digest automatically and shows why; every update and rollback is audited (who, from, to, result).
- AC1: `TestControlPlaneUpdateAC1OfferWithPostgres`
- AC2: `TestControlPlaneUpdateAC2RedeployWithPostgres`
- AC3: `TestControlPlaneUpdateAC3RollbackWithPostgres`
- AC4: `TestControlPlaneUpdateAC4AuditWithPostgres`
- AC5 (proposed) (live): Justin's dev-server check from the README runbook. Mark it `not_run` ("live: owed to Justin"); review only the runbook's accuracy.

## The builder's rulings (not yet confirmed by Justin; judge each against the plan and the ACs)
1. A rollback sets `LEORNA_UPDATE_ID` to this update's id, with the previous image and previous `LEORNA_RELEASE_VERSION` (the plan said "previous 3 values").
2. All four `LEORNA_SCW_UPDATE_*` values go into the container's secret env (the plan said project and region as plain env).
3. An extra state-machine row: `requested/pending` with the container already on the target image moves to `deploying/configured`.
4. An unusable update key at startup is logged and leaves updates off; a partial set still stops startup.
5. Wording of the blocked reason.
6. No banner on the audit screenshot (Justin's rule: images show the result only).
Say for each one whether it is sound, and raise a finding if one changes what an AC says or opens a real bug.

## What to look at hardest
- **Security:** admin-only on the server (route and store), another tenant's admin refused, CSRF on both form and API, the update key's scope and that it never reaches logs, errors, audit rows, HTML or evidence; release-notes rendering (XSS under the admin CSP); the feed client (HTTPS only, no redirects, size cap, no SSRF through a configurable URL); digest-only images (`repository@sha256:…`), prereleases excluded, never `latest`.
- **Correctness of the self-update state machine:** restart in the middle of every state, two processes reconciling at once (`SKIP LOCKED`, the one-active index), a stuck or stale Scaleway status (builder's found_else 1: a stale `error` after the rollback redeploy), the 10-minute confirmation window, a rollback after the new version already migrated (Q3 A: `rollback_blocked` with the reason), and what the console shows in each state.
- **Migration 000032:** forward-only, the next free number, the down file, and the `store_test.go` reset list (see `leorna` skill on `resetDatabase`).
- **Installer change:** the best-effort `mint-update` step, and resume on an existing install (env set, nothing else lost, no secret resent in the clear; the SDK's zero-value `privacy`/`protocol`/`sandbox` fields must not be sent: see `internal/installer/scaleway/domain.go`).
- **OpenAPI:** additive only, regenerated code matches (`api-contract-drift-guard`).
- **Tests:** each AC test really asserts its AC's every clause and fails on base for the right reason; run the gates and the AC tests yourself on head, try your own mutants on the guards (under the memory cap), don't trust the builder's summaries. Check `.github/` is untouched and authorship is Justin's Leorna identity with no AI attribution lines.

## Skills: load each one with the Skill tool in this order, and say so in one line
`leorna` (reviewer rules), `engineering-best-practices`, `requesting-code-review`, `code-review-practice`, `mutation-testing-discipline`, then `security-best-practices`, `multi-tenant-auth-management`, `api-contract-drift-guard`, `backend-data-migrations`, `authorized-write-safety`.

## Severity and the record (`review-fix-cadence`; `/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`)
- P0/P1: a security hole, a guard bypass, a false AC, or a wrong block that breaks normal work. P2: a bug a real person or agent could plausibly hit (realistic edge cases, configs, restarts, git operations, WSL and macOS), anything that breaks an AC or the UI, or a test that can't fail. P3: cosmetic, docs, a hole only a deliberate evasion hits, or a setup none of Justin's machines has. Every P0–P2 needs a concrete real-use `scenario` (5+ words: who does what, what goes wrong).
- Write `/home/justin/.hermes/plans/leorna/evidence/86bcxnykn/review-1/review.json`: `{"round": 1, "scope": "full", "from": "4ef14efb46da789aec30fad1e5a988d8770140e2", "head": "91326925e7af53413e8217578bde84e8916a4964", "findings": [{"id": "R1-1", "severity": "P2", "file_line": "…", "claim": "…", "scenario": "…"}]}` (ids `R1-<k>`; empty list when clean).
- Self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo /home/justin/Leorna/86bcxnykn-admin-console-update --base 4ef14efb46da789aec30fad1e5a988d8770140e2 /home/justin/.hermes/plans/leorna/evidence/86bcxnykn`. Exit 2 means your file is wrong: fix it. Exit 0, 1 or 3 is the referee's verdict, not yours to act on.

## Rules
- Postgres: start your own capped container named for this role (for example `xnyk-review1-pg`, `--memory 1g`), CI's pinned image, a database ending in `_test`; never use or drop the builder's `xnyk-builder-pg` or any sibling's DB. Stop your container when done and say so.
- Memory (WSL desktop): follow "Windows Desktop: Runaway Memory" in `/home/justin/.claude/CLAUDE.md`. A command that dies with SIGTERM, 143, 137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first. Mutation runs always go under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`. Never run your mutants alongside a `make check`.
- Scratch: all of it in your own `~/.cache/86bcxnykn-review1/`, created fresh with `mkdir` (no `-p`); `TMPDIR`, Go temp and Chrome profiles there with short socket paths. The `/tmp` scratchpad is a small shared RAM tmpfs.
- Don't end your turn to wait for a background command (the lessons gate treats that as finishing). Wait in the foreground with bounded polls of under 3 minutes each, the Bash `timeout` set above each bound.
- No real Scaleway, GitHub or ClickUp calls that write anything.
- Other bugs outside this story: `found_else` (one line each, evidence, severity), never findings.
- Skill lessons: list reusable ones in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section; never edit skills or memory. `enforce` is `none` or a one-line proposal for a check that would have caught a broken rule (kind, what it checks, where it runs). An empty list is the normal answer.

## Return
`{verdict: clean|findings, findings[{id, severity, file_line, claim, scenario, repeats, new_fact}], rulings[{n, sound, note}], ac_status[{ac, accepted, test, screenshot, evidence}], defect_loop_skills[], found_else[], skill_lessons[]}`, and end with the line `MAIN SESSION: check and save these skill_lessons now.`
