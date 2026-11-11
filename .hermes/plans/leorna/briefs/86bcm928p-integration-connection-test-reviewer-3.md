# REVIEWER brief, round 3 (delta): 86bcm928p connection test for integrations

Role: REVIEWER, round 3, scope **delta**. You are a fresh general-purpose agent (Opus 5.5, high effort) that never saw the build or an earlier review's work.

**Report only:**
- Change no source and commit nothing. Don't touch the worktree's files or index.
- Write only into `/home/justin/.hermes/plans/leorna/evidence/86bcm928p/review-3/`.
- Start no other agents.

## What to review
- Worktree: `/home/justin/Leorna/86bcm928p-integration-connection-test`, branch `feat/86bcm928p-integration-connection-test`.
- Range: `from` = review 2's head `4818a8c1592f603384b24c01d97c883d15944069`; `head` = `ecbd6b5e6ff7eca29ef82c1763b5c2120b292a58`. Check HEAD is that SHA before you start.
- Review `git diff 4818a8c..ecbd6b5`: one test-only fix commit touching `internal/integration/connectiontest/prober_test.go`, `network_test.go` and `internal/web/integration_connection_test.go`. Review it and what it touches. Anything else you notice outside that scope is P3.
- Story base (for context only): `4ef14efb46da789aec30fad1e5a988d8770140e2`.
- Approved plan: `/home/justin/.hermes/plans/leorna/evidence/86bcm928p/plan-approved.md` (plan choice 4: 401 passes; 403 and every other status is "Not an MCP endpoint (HTTP n)").

Earlier records, all under `/home/justin/.hermes/plans/leorna/evidence/86bcm928p/`. Read them, but don't trust them:
- `review-1/review.json` (clean, 6 P3s)
- `review-2/review.json` (R2-1 P2, R2-2 P3, R2-3 P3), plus its `mutants/` and `zz_review2_probe_test.go`
- `fixer-2/REPORT.md`: the fixer's answer to each (R2-1 fixed, R2-2 fixed, R2-3 deferred as a follow-up), with `fixer-2/mutation/` and `fixer-2/gates-ecbd6b5.txt`
- `auditor/REPORT.md` and `fixer-1/REPORT.md`: the earlier AC1 test fix

Your judgements:
1. Does ecbd6b5 really close R2-1? Do R2M2, R2M4, R2M5 and R2M6 each fail on the new tests, with R2M6 failing in the AC2 test itself?
2. Did the fix weaken any existing assertion? In particular, AC2's "4 distinct failure messages, one per step" check now that two cases share the Not-MCP step.
3. Is the `TestMain` dead-proxy setup sound? It must not leak into or break other tests, must be order-independent, and must not reach the network.
4. Is R2-2 closed?
5. Is deferring R2-3 acceptable? If the deferral doesn't hold, raise R2-3 again at its severity with `repeats: "R2-3"`.

ACs:
- AC1: `TestIntegrationConnectionTestAC1ReachabilityWithPostgres`
- AC2: `TestIntegrationConnectionTestAC2FailureMessagesWithPostgres`
- No `(live)` ACs.

## Gate note
The fixer's `make check` stopped at `audit` on **GO-2026-6859** (net/http in go1.27.3), which also fails on base. `make secrets` fails only on a sibling branch's commit (`feat/86bcm928e`, 27ca94f). Neither is caused by this story, so don't report either as a story finding. Confirm the attribution if you can do it cheaply, and mention it in `found_else`.

## Skills: load each with the Skill tool and say so in one line
1. `leorna` (reviewer rules)
2. `engineering-best-practices`
3. `requesting-code-review`, then `code-review-practice`. Skip their subagent and auto-fix steps.
4. `mutation-testing-discipline`
5. Read `/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` ("The reviewer's duties", including "Three trees per probe" for delta rounds, and "Records"), and the `review-fix-cadence` severity scale.

## Probing
- Run read-only probes with `go test -overlay`, or in a detached scratch copy (`git -C <wt> archive <sha> | tar -x -C ~/.cache/86bcm928p-review-3/…`). Never edit the worktree.
- Compare base, `4818a8c` and `ecbd6b5` trees where it helps.
- Postgres: the containers `928p-builder-pg` and `928p-builder-ch` are running. Their settings are in `~/.cache/86bcm928p-builder/env.sh` and its pg env file (0600; never print the password). Use your **own** `_test` database name, and drop it when you're done.
- Toolchain: `~/.local/leorna-toolchain`.
- Scratch: your own fresh `~/.cache/86bcm928p-review-3/` (`mkdir` without `-p`), never `/tmp`.

## Severity: Justin's scale
- **P0/P1:** a security hole, a guard bypass, a false AC, or a wrong block that breaks normal work.
- **P2:** a bug a real person or agent could plausibly hit, realistic edge cases included; anything that breaks an AC or the UI; or a test that can't fail.
- **P3:** cosmetic, docs, a hole only a deliberate evasion hits, or a setup none of Justin's machines has.

Every P0–P2 needs a concrete real-use `scenario` of 5+ words (who does what, and what goes wrong); without one, the referee counts it as P3. A finding that is the same defect as an earlier round's sets `repeats`, plus `new_fact` when you have one.

## Your outputs
1. Write `/home/justin/.hermes/plans/leorna/evidence/86bcm928p/review-3/review.json`:
   - `round: 3`, `scope: "delta"`, `from: "4818a8c1592f603384b24c01d97c883d15944069"`, `head: "ecbd6b5e6ff7eca29ef82c1763b5c2120b292a58"`;
   - `findings[]` with ids `R3-<k>`. Use an empty list when clean.
   Probe files and logs may go in the same folder. Don't write a prose report file there.
2. Self-check: run `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo /home/justin/Leorna/86bcm928p-integration-connection-test --base 4ef14efb46da789aec30fad1e5a988d8770140e2 /home/justin/.hermes/plans/leorna/evidence/86bcm928p`. Exit 2 means your file is wrong: fix it. Exits 0, 1 and 3 are the referee's verdict; don't act on them.
3. Return a report with `verdict` (`clean` or `changes_requested`), the findings with evidence, `ac_status[{ac, accepted, test, screenshot, evidence}]`, `found_else[]` and `skill_lessons[]`.

## Windows desktop: runaway memory
A command that dies with SIGTERM, exit 143 or 137, or "Killed" may be an earlyoom kill. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'`. Run mutants and heavy checks under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.

## Rules
- Other bugs go in `found_else` (one line each, with severity and evidence).
- `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section. Never edit skills or memory yourself. `enforce` is `none`, or a one-line proposal for a check (kind, what it checks, where it runs) when the lesson is about a rule that was broken or nearly broken. An empty list is the normal answer.
- Don't end your turn to wait for a background command. Wait in the foreground with bounded polls of under 3 minutes each.
- End your report with the line `MAIN SESSION: check and save these skill_lessons now.`
