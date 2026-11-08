# REVIEWER brief, round 1 (full): 86bcm928t integration governance and usage

Role: REVIEWER, round 1, scope **full**. You are a fresh general-purpose agent (Opus 5.5, high effort) that never saw the build.
**Report only:**
- Change no source and commit nothing. Don't touch the worktree's files or index.
- Write only into `/home/justin/.hermes/plans/leorna/evidence/86bcm928t/review-1/`.
- Start no other agents.

## What to review
- Worktree: `/home/justin/Leorna/86bcm928t-integration-governance-usage`, branch `feat/86bcm928t-integration-governance-usage`.
- Range: `from` = story base `f0a326b83aae9d181e4f6681645685ae4b1fff91` (= `git merge-base HEAD origin/main`); `head` = `9276c33966aea25c8227ca3efe56a1bdb203012e`. Check that HEAD is that SHA before you start. Review `git diff f0a326b...9276c33`: 4 commits, 11 files.
- Approved plan (the ACs and their meaning): `/home/justin/.hermes/plans/leorna/evidence/86bcm928t/plan-approved.md`.
- Builder evidence (read it, don't trust it): `/home/justin/.hermes/plans/leorna/evidence/86bcm928t/builder/`.

ACs:
- AC1: Given an integration, then it reaches engineers only through packs assigned to their team/project. Test: `TestIntegrationGovernanceAC1PackAssignmentOnlyWithPostgres`. Passes on base by design (`base_exempt`).
- AC2: Given the dashboards, then integration usage (which integrations, by team) is shown where measurable. Test: `TestIntegrationGovernanceAC2DashboardByTeamWithPostgres`.
- AC3: Given any integration change, then it appears in the change audit. Test: `TestIntegrationGovernanceAC3ChangeAuditWithPostgres`.

Justin's own constraints on the story:
- AC1 must prove another team **and** another tenant can't get the integration.
- AC2 shows only what 902h's records really measure; everything else is a follow-up.
- AC3 reuses 927y's audit records, with no second audit path.

## Skills: load each with the Skill tool and say so in one line
1. `leorna`: the reviewer rules (report only; an AI review is never a human approval).
2. `engineering-best-practices`
3. `requesting-code-review`, then `code-review-practice`, including their security and quality checks.
4. The specialists: `security-best-practices`, `multi-tenant-auth-management`, `api-contract-drift-guard`, `backend-data-migrations`.
5. Read `/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` ("The reviewer's duties" and "Records") and the `review-fix-cadence` skill's severity scale.

## What to look for
- **Correctness and tenancy:** every new store read in `internal/integration/reach.go` and `internal/web/content_usage.go` is scoped to the signed-in admin's company. Check for no cross-company leak in the "Integrations by team" table, admin-only access, and correct expiry and override handling.
- **The older-form refusal** (`internal/itembuilder/builder.go`): does it really close the unaudited path for `integration-…` MCP items? Look for both bypasses (other routes that save pack versions without an audit) and over-blocks (normal work it now wrongly refuses).
- **The tests:**
  - Does each AC test check what its AC claims?
  - Can each test fail? The builder's mutants are in `builder/mutation/`. Read them, and probe any clause no mutant covers.
  - Do the failure cases hit the real boundary (404 vs 403, store vs HTTP)?
- **Contract and migrations:** confirm there is no OpenAPI or migration change. If there is one, check its drift rules.
- **Records:** READMEs and `delivery/stories.json` (main's entries unchanged by value, this story's appended last).
- **Probing:** run tests read-only with `go test -overlay` or a detached scratch copy (`git -C <wt> archive 9276c33 | tar -x -C ~/.cache/86bcm928t-review-1/…`), never by editing the worktree.
  - Postgres: the builder's container `928t-builder-pg` is running. The connection settings are in `~/.cache/86bcm928t-builder/env.sh` and `pg.env` (0600, never print the password).
  - Use your **own** `_test` database name, never the builder's, and drop it when done.
  - Toolchain: `~/.local/leorna-toolchain/go/bin` on a task-local PATH.

## Severity: Justin's scale
- **P0/P1:** a security hole, a guard bypass, a false AC, or a wrong block that breaks normal work.
- **P2:** a bug a real person or agent could plausibly hit, realistic edge cases included; anything that breaks an AC or the UI; or a test that can't fail.
- **P3:** cosmetic, docs, a hole only a deliberate evasion hits, or a setup none of Justin's machines has.

Every P0–P2 needs a concrete real-use `scenario` of 5+ words (who does what, and what goes wrong). Without one, the referee counts it as P3.

## Your outputs
1. Write `/home/justin/.hermes/plans/leorna/evidence/86bcm928t/review-1/review.json` in the format in `review-loop.md`:
   - `round: 1`, `scope: "full"`, `from: "f0a326b83aae9d181e4f6681645685ae4b1fff91"`, `head: "9276c33966aea25c8227ca3efe56a1bdb203012e"`.
   - `findings[]` with ids `R1-<k>`, each with `severity`, `file_line`, `claim` and `scenario`. Use an empty list when clean.
   - Probe scripts and logs may go in the same folder. Don't write a prose report file there: return the summary in your report.
2. Self-check by running `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo /home/justin/Leorna/86bcm928t-integration-governance-usage --base f0a326b83aae9d181e4f6681645685ae4b1fff91 /home/justin/.hermes/plans/leorna/evidence/86bcm928t`. Exit 2 means your file is wrong: fix it. Exits 0, 1 and 3 are the referee's verdict; don't act on them.
3. Return a report with:
   - `verdict` (`clean` or `changes_requested`)
   - the findings, each with evidence
   - `ac_status[{ac, status: accepted|not_accepted|not_run, evidence}]` for AC1–AC3
   - `found_else[]`
   - `skill_lessons[]`

## Windows desktop: runaway memory
A command that dies with SIGTERM, exit 143 or 137, or "Killed" may be an earlyoom kill. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before reading it as a result. Rerun any heavy check under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.

## Rules
- If you find another bug outside this story, don't fold it in: list it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable, don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill or `memory`.
  - `enforce` is `none`, or, for a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: kind, what it checks, where it runs.
  - An empty list is the normal answer.
- Don't end your turn to wait for a background command. Wait in the foreground with bounded polls under 3 minutes each.
- End your report with the line `MAIN SESSION: check and save these skill_lessons now.`
