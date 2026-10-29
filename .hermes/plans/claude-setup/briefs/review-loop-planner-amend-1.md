# Brief: PLANNER (amendment 1), story `review-loop`

## Role
You are a **planner** amending the approved plan of Justin's setup story `review-loop`. You edit only the plan file `~/.hermes/plans/claude-setup/review-loop.md`. You do **not**:
- touch code, tests, skills or hooks, or the read-only `evidence/review-loop/plan-approved.md`;
- commit, push or start agents.

## Skills to load first
- `implementation-planning`

Read the amendment rules in `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`, under "At \"go\"" ("When Justin decides something mid-build that changes an approved AC, a planner amends the plan…").

## Why
Justin's rule (b), in the plan and in `references/review-loop.md`: a **Full** story's rounds 1 and 2 both review the whole story. After round 1, the referee's REVIEW AGAIN line said "fix them, then review the fix commits", so the orchestrator ran a delta round 2 in this Full story.

Review round 5 found it (R5-1, P2), and fixer 4 fixed it in commit `99a6694`. **When round 1 is the latest round,** every REVIEW AGAIN line that would send a delta round now names both pipelines:
- **P0–P2 form:** `REVIEW AGAIN: <k> P0-P2 finding(s) in review-1 at <sha7>: fix them, then review again (Full: round 2 reviews the whole story from <base7>; Mini: review the fix commits)`
- **"Commits after" form:** `REVIEW AGAIN: <c> commit(s) after review-1's head <sha7> are unreviewed: review again (Full: round 2 reviews the whole story from <base7>; Mini: review <sha7>..<sha7>)`
- **"Not a pure rebase" form:** the same pattern, with Mini's part "review what changed since <sha7>".

Rounds 2 and later keep the original wording.

Justin's standing instruction is "keep pushing and doing everything", and this aligns the AC text with his own rule. The approved AC2 and AC7 text still states only the old wording for every round. A blind auditor reading it word for word could reject the correct new behaviour.

## What to do
1. **Confirm the exact new strings** from the worktree at head `aba309358277f1845febe2c23f87db27665bfbe6`: `/home/justin/.claude-setup-wt/review-loop/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh`, the `next()` helper and its callers, and AC2/AC7 in `review-check.test.sh`.
2. **Amend AC2 and AC7** in `~/.hermes/plans/claude-setup/review-loop.md`:
   - keep each AC whole on one line, with its test name unchanged;
   - state the round-1 form and the round-2+ form;
   - mark each changed line (e.g. `[amended 1]`).
3. **Add an Amendments list at the top,** right after the title, covering:
   - what changed, why, and on whose authority (Justin's rule (b) and his standing instruction);
   - which earlier receipts encode the old expectation: the builder's `ac2`/`ac7` logs at `d3f220f`, and the review rounds' suite logs before `aba3093`, with the difference now expected;
   - that the pre-amendment text lives in `evidence/review-loop/plan-approved.md` (the current read-only copy, which the orchestrator will move aside).
4. **Change nothing else** in the plan.

## Output
- `status`: `amended`.
- `changed_lines[]`: the new AC2 and AC7 lines in full.
- `amendments_section`.
- `skill_lessons[{skill, lesson, evidence, enforce}]`. An empty list is normal.
