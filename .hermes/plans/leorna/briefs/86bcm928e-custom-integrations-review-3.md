# REVIEWER brief — 86bcm928e custom integrations, round 3 (delta)

**Role:** a fresh REVIEWER (Opus 5.5, high effort), report only, for Leorna card 86bcm928e "Custom integrations defined by the admin" (control plane, Full pipeline). You never saw the build or the fixes. Change no source, commit nothing, push nothing, write nothing to ClickUp, start no agents (skip `requesting-code-review`'s "independent reviewer subagent" and auto-fix steps: you are the fresh reviewer). The only files you may write are under `/home/justin/.hermes/plans/leorna/evidence/86bcm928e/review-3/`. Scratch goes in `~/.cache/928e-review-3/` (never `/tmp`); remove it at the end. Restore anything you touch in the worktree; run mutations in your own detached copy (`git worktree add --detach`) or `go test -overlay`, removed with `git worktree remove --force` (never `git worktree prune`).

## Skills to load, in order (say so in one line)
`leorna` (hard rules; skip its Step 1 load except `leorna-control-plane-workflow.md` and the repo's `AGENTS.md`), `engineering-best-practices`, `requesting-code-review`, `code-review-practice`, `review-fix-cadence`, `mutation-testing-discipline`, `multi-tenant-auth-management`. The record format is in `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`; read it, and `references/ac-verification.md` for what `ac_status` means.

## What to review (delta)
- Worktree `/home/justin/Leorna/86bcm928e-custom-integrations`, branch `feat/86bcm928e-custom-integrations`, head `0a45d39097ae4557409173536a68d852ea13ec6f`, previous reviewed head `94fa2ee03ced193b65f76848e7e8ec09712f3668` (review 2: clean, full), story base `4ef14efb46da789aec30fad1e5a988d8770140e2`. Confirm all three.
- **Scope: the one fix commit `0a45d39` (`git diff 94fa2ee..0a45d39`, `internal/web/custom_integrations_test.go` only, +52/−12) and what it touches.** It came from the blind AC auditor's NOT ACCEPTED on AC2: AU1-1 — AC2's "another company's pack builder" clause couldn't fail (the POST had no `target_key`, so the builder answered 409 for any item; mutant A2-2, `c.tenant_id=$2` always true in `internal/store/postgres/pack_builder.go:315`, survived), plus the verifier's V7 (AC2 configured `region=eu-west`, equal to the example, so rendering the examples instead of the admin's values survived). The auditor's and verifier's specs: `evidence/86bcm928e/auditor/mutants/specs.py.txt`, `evidence/86bcm928e/verifier/mutants/SUMMARY.txt`; the fixer's receipts: `evidence/86bcm928e/fixer-2/`.
- Check, don't trust: AC2's test was only tightened, never weakened (read every changed and removed assertion in `git diff 94fa2ee..0a45d39` against the approved plan's AC2 line in `/home/justin/.hermes/plans/leorna/evidence/86bcm928e/plan-approved.md`); the new cross-tenant step can now fail (rerun A2-2 yourself); the control (the other company's own item reaching the review) is real; the us-east checks read each tool's synced file (Claude Code, Codex, Cursor); no production code changed; and the retaken `ac2-sync-run.png` in the evidence root shows the result only (no SHA, token, e-mail, tenant id or real domain).
- Run AC1–AC3 by name on head with your own Postgres (`928e-review3-pg`, `mirror.gcr.io/library/postgres:18.6-alpine3.23`, db name ending `_test`, wait with `docker exec 928e-review3-pg pg_isready -h 127.0.0.1`, remove only it at the end), plus `go test ./internal/web -run 'TestCustomIntegration|TestIntegrations' -timeout 1800s`. The fixer's full gates are in `evidence/86bcm928e/gates-0a45d39.txt` (`make audit` fails on GO-2026-6859 on base too; outside the branch). Toolchain `~/.local/leorna-toolchain/go/bin:~/.local/leorna-toolchain/bin`. The machine may be loaded: rerun a timeout before judging.
- Earlier P3s are in `evidence/86bcm928e/follow-ups.md`; restate one only with a new fact.

## Severity (Justin's scale)
- **P0/P1:** a security hole, a guard bypass, a false AC, or a wrong block that breaks normal work.
- **P2:** a bug a real person or agent could plausibly hit, realistic edge cases included, anything that breaks an AC or the UI, or a test that can't fail.
- **P3:** cosmetic, docs, a hole only a deliberate evasion hits, or a setup none of Justin's machines has.
Every P0–P2 needs a concrete real-use scenario of 5+ words; without one it is P3. A repeat sets `repeats` and needs a `new_fact`.

## Record
Write `/home/justin/.hermes/plans/leorna/evidence/86bcm928e/review-3/review.json` with `round: 3`, `scope: "delta"`, `from: "94fa2ee03ced193b65f76848e7e8ec09712f3668"`, `head: "0a45d39097ae4557409173536a68d852ea13ec6f"`, ids `R3-<k>`, as `review-loop.md` says. Self-check with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo /home/justin/Leorna/86bcm928e-custom-integrations --base 4ef14efb46da789aec30fad1e5a988d8770140e2 /home/justin/.hermes/plans/leorna/evidence/86bcm928e`. Exit 2 means your file is wrong; fix it.

## Desktop memory rule
A command that dies with SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first. Mutation runs always under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`. Don't end your turn to wait for a background command; wait with foreground polls under 170 s (Bash `timeout` set above the poll's bound).

## Other findings and lessons
- Anything outside this story: `found_else` (one line each, evidence, severity).
- Lessons: don't edit any skill or memory file; list them in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section (`enforce` is `none` or a one-line check proposal). An empty list is normal.

## Report back
`{verdict: clean|findings, findings[{id, severity, file_line, claim, scenario, repeats, new_fact}], ac_status[{ac, accepted, test, screenshot, evidence}], review_json, review_check_exit, found_else[], skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
