# REVIEWER brief, round 5 (delta): Leorna story 86bcm928h-per-user-credentials

**Role:** a fresh, independent REVIEWER, **report only**. Opus 5.5, effort high. You never saw the build, the earlier reviews or the fixes.

Every rule in the round-1 brief applies to you too: `~/.hermes/plans/leorna/briefs/86bcm928h-per-user-credentials-reviewer-1.md`. Read it first. It is overridden only where this file says something different.

**Load every skill the round-1 brief names**, and say so in your first steps:
- `leorna`
- `engineering-best-practices`
- `requesting-code-review`
- `code-review-practice`
- `security-best-practices`
- `mutation-testing-discipline`

Reviewers in rounds 3 and 4 loaded only some of them.

## What's different in round 5
- **Write only into** `~/.hermes/plans/leorna/evidence/86bcm928h/review-5/`. The scratch folder is `~/.cache/86bcm928h-review-5/`, removed at the end.
- **Scope:** a delta.
  - `from` = `9b35bbbfb6b798d1729fd203c37d56cd4a070d56`, the round-4 head.
  - `head` = `0af447184c884a7e6d74efb4fb98909143e8d2d3`.
  - Review fix commit 0af4471 (`git diff 9b35bbb..0af4471`, `application/application_test.go` only) and what it touches.
  - Anything else you notice outside it counts as P3.
  - If HEAD has moved past 0af4471, stop and report it.
- **Earlier records:**
  - `review-4/review.json`
  - `review-4/justin.json`: Justin said fix R4-1.
  - `fixer-4-report.md`
  - `fixer-4/`: the mutant sources and logs
  - `gates-0af4471.txt`
- **The fixer's answer:** R4-1 (P2) is fixed. The "version 11 refused" subtest now builds a real full-schema database and sets `user_version=11`. It asserts the guard's own error and that the file is unchanged.
  - Judge whether the fix holds. Rerun the mutants yourself under the 4G cap with `go test -overlay`, quoting each env assignment as `env "PATH=$PATH" …`:
    - `version != 10` → `version < 10`
    - the guard deleted
    - the guard writes something, then refuses
  - Each must now fail the test. The real code must pass.
  - If the fix doesn't hold, raise it again at P2 with `"repeats": "R4-1"`, plus a `"new_fact"` of 5+ words when you have one.
- **Two trees per probe:** run on `9b35bbb` and on `0af4471`.
- **review.json:** `{"round": 5, "scope": "delta", "from": "9b35bbbfb6b798d1729fd203c37d56cd4a070d56", "head": "0af447184c884a7e6d74efb4fb98909143e8d2d3", "findings": [...]}`, with ids `R5-<k>`.
  - Self-check it with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo /home/justin/Leorna/leorna-client/.claude/worktrees/86bcm928h-per-user-credentials --base a7839b3af664efcfa59eb1ed3fe276ec1262a4de ~/.hermes/plans/leorna/evidence/86bcm928h`.
  - Exit 2 means your file is wrong, so fix it.
- **Report:** if a hook stops you writing `report.md`, put the whole report in your final message.
- **Earlyoom check:** `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'`

## Return
Same schema as round 1: `{verdict, findings[], ac_status[], found_else[], skill_lessons[]}`. AC8 (live) is `not_run`. End with `MAIN SESSION: check and save these skill_lessons now.`
