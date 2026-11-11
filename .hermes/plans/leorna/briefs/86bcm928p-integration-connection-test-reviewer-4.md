# REVIEWER brief, round 4 (delta: bring-main-in + PR record): 86bcm928p connection test for integrations

Role: REVIEWER, round 4, scope **delta**. You are a fresh general-purpose agent (Opus 5.5, high effort) that never saw the build or an earlier review's work.

**Report only:**
- Change no source and commit nothing. Don't touch the worktree's files or index.
- Write only into `/home/justin/.hermes/plans/leorna/evidence/86bcm928p/review-4/`.
- Start no other agents.

## What to review
- Worktree: `/home/justin/Leorna/86bcm928p-integration-connection-test`, branch `feat/86bcm928p-integration-connection-test`. PR #126 is open on GitHub; its pushed head is `80491bd`.
- Range: `from` = review 3's clean head `ecbd6b5e6ff7eca29ef82c1763b5c2120b292a58`; `head` = `6eeeb26692bd3c6f493e2a8de36121e153b75075` (local, not pushed). Check HEAD is that SHA before you start.
- It has two commits:
  1. `80491bd`, a merge of GitHub main `09924b5e38473a93d8520cb849441a200ab73761` into the branch. The only conflict was `delivery/stories.json`, resolved by appending this story's entry last. Both sides also changed `cmd/control-plane/main.go` and `internal/web/handler.go`; per the finisher, git merged those cleanly.
  2. `6eeeb26`, "feat(86bcm928p): record PR #126" (`delivery/stories.json` only).
- Story base, for context: `4ef14efb46da789aec30fad1e5a988d8770140e2`.
- Approved plan: `/home/justin/.hermes/plans/leorna/evidence/86bcm928p/plan-approved.md`.
- The finisher's claims and logs: `/home/justin/.hermes/plans/leorna/evidence/86bcm928p/pr-finisher/` (`gates-80491bd/`, `gates-80491bd.txt`, `record-check.log`). Read them, but don't trust them.

Your judgements:
1. **Is the merge honest?**
   - Every file changed on one side only equals that side's blob.
   - The files whose merged content differs from both parents are exactly the both-sides set.
   - The two both-sides Go files equal `git merge-file -p` of their three blobs.
   - The story's own patch survived in every file.
   - Use the `leorna` skill step 7.2 recipes.
2. **Does main's new content interact with the story without a text conflict?**
   - Look at what `4ef14ef..09924b5` changed in the packages the story touches (`internal/web`, `cmd/control-plane`, integrations, store, handler wiring, CSRF/admin middleware, fixtures).
   - Check whether any of it changes the story's route, its admin/CSRF guards, the tester wiring, or the test fixtures the AC tests rely on.
   - Prove it either way, e.g. run both AC tests by name on `6eeeb26`, or an overlay mutant where it matters.
3. **Is the `stories.json` record correct by value?**
   - main's entries are unchanged and in order, with this story's entry last and listing PR 126;
   - `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'` passes;
   - `scripts/check-story-shippable.py 86bcm928p` prints only the expected PR-state BLOCKED lines.
4. Anything else in this range is in scope. Anything outside it is P3.

ACs:
- AC1: `TestIntegrationConnectionTestAC1ReachabilityWithPostgres`
- AC2: `TestIntegrationConnectionTestAC2FailureMessagesWithPostgres`
- No `(live)` ACs.

## Skills: load each with the Skill tool and say so in one line
1. `leorna` (reviewer rules; step 7.2 bring-in checks)
2. `engineering-best-practices`
3. `requesting-code-review`, then `code-review-practice`. Skip their subagent and auto-fix steps.
4. `mutation-testing-discipline`
5. `security-best-practices` and `multi-tenant-auth-management` (the admin route's guards)
6. Read `/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` ("The reviewer's duties", including "Three trees per probe" for delta rounds, and "Records") and the `review-fix-cadence` severity scale.
7. Before starting, read `~/.claude/skills/leorna/references/repeat-mistakes.md` and `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md`.

## Probing
- Run read-only probes with `go test -overlay`, or in a detached scratch copy. Never edit the worktree.
- Toolchain: go1.27.4 is at `~/.local/leorna-toolchain/go1.27.4/bin`. Put it first on a task-local PATH (main requires 1.27.4), with `~/.local/leorna-toolchain/bin` for golangci-lint and govulncheck.
- Postgres/ClickHouse: start your own containers named `928p-rev4-*` on loopback ports. Never use or touch `leorna-pg` or `leorna-test-pg`. Never print a password, and remove your containers when done.
- Scratch: your own fresh `~/.cache/86bcm928p-review-4/` (`mkdir` without `-p`), never `/tmp`. Remove it at the end, except for the logs you copy into `review-4/`.

## Severity: Justin's scale
- **P0/P1:** a security hole, a guard bypass, a false AC, or a wrong block that breaks normal work.
- **P2:** a bug a real person or agent could plausibly hit, realistic edge cases included; anything that breaks an AC or the UI; or a test that can't fail.
- **P3:** cosmetic, docs, a hole only a deliberate evasion hits, or a setup none of Justin's machines has.

Every P0–P2 needs a concrete real-use `scenario` of 5+ words; without one, the referee counts it as P3. A finding that is the same defect as an earlier round's sets `repeats`, plus `new_fact` when you have one.

## Your outputs
1. Write `/home/justin/.hermes/plans/leorna/evidence/86bcm928p/review-4/review.json`:
   - `round: 4`, `scope: "delta"`, `from: "ecbd6b5e6ff7eca29ef82c1763b5c2120b292a58"`, `head: "6eeeb26692bd3c6f493e2a8de36121e153b75075"`;
   - `findings[]` with ids `R4-<k>`. Use an empty list when clean.
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
