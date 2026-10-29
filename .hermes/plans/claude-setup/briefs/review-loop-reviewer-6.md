# Brief: REVIEWER 6 (delta round), story `review-loop`

## Role
You are the fresh **reviewer 6** for Justin's setup story `review-loop`. You never saw the build, rounds 1–5, or the fixes. You **only report**:
- no source changes, no commits;
- no other agents;
- never write the live `~/.claude`, `~/.hermes`, `~/.hermes/skills-library`, global git config, `~/.claude-setup.git` refs or GitHub.

Write only into `~/.hermes/plans/claude-setup/evidence/review-loop/review-6/`.

**Live guards.** git-guard checks every Bash call and the git hooks check every commit. A deny is the guard working. Probe git through a script file in a temp `HOME`.

**This is a delta round under the story's own loop.** You review only the fix commits since round 1's head, and what they touch. Your `review.json` goes to the story's referee.

## Skills to load first
1. `engineering-best-practices`
2. `requesting-code-review`: skip its nested-reviewer and auto-fix steps.
3. `code-review-practice`
4. `mutation-testing-discipline`

## Scope
- **Worktree:** `/home/justin/.claude-setup-wt/review-loop`, branch `review-loop`. Story base: `691651c1e942896f42f4e64ed547a1a2a121ef3c`.
- **Round 5's head:** `aff26c8b2e4d3cc4cc151224dc5a54f1bcde244a`. Round 5 was the second **full** review of the whole story.
- **Candidate head:** `aba309358277f1845febe2c23f87db27665bfbe6`.
- **Review:** `git diff aff26c8..aba3093`, 4 commits (`99a6694`, `bb33a25`, `7db9f3f`, `aba3093`). Read the rest of the story only for context.
- **Before you start,** confirm HEAD is `aba3093` and that `git status --porcelain --untracked-files=all` is empty. If either fails, stop.
- **Approved plan:** `~/.hermes/plans/claude-setup/evidence/review-loop/plan-approved.md` (read-only).
- **Earlier rounds:** `~/.hermes/plans/claude-setup/evidence/review-loop/review-1/review.json` and `review-2/` … `review-5/review.json`, plus Justin's answers in `review-2/justin.json` and `review-3/justin.json` (both `continue`). Read them to link repeats (`repeats` and `new_fact` fields), not to anchor your judgement.
- **What the fix commits changed:**
  - **R5-1:** when round 1 is the latest round, every REVIEW AGAIN line that would send a delta round names both pipelines: "review again (Full: round 2 reviews the whole story from <base7>; Mini: …)" (the `next()` helper). Rounds 2+ are unchanged.
  - **R5-4:** the records go to jq on stdin, not one `--argjson` argument.
  - **R5-5:** boundary tests for `new_fact` and the scenario word counts.
  - **R5-6:** one sentence in `review-loop.md` on rejected findings.
  - **Doc fixes:** R5-2 (`leorna/SKILL.md`), R5-3 (feature-dispatch Phase 3b), R5-7 (the Codex reviewer role), R4-2 (the "unless … run a full review from <base>" exception in four places), R4-1.
  - **Plan amendment, in progress in parallel:** a planner is amending the plan's AC2 and AC7 to state the round-1 form of the line. Judge the code against the rule (Full's round 2 is whole-story), not against the old AC wording.
- **Already on the follow-up list** (`evidence/review-loop/follow-ups.md`; raise these only with something new): R1-3, R1-6, R1-7, R1-8, AC16's one-line limit, review-fix-cadence:32's wording, and the one extra delta review after a finisher rebase in the sync-rewrite case.

## Focus
- Is every round-1 REVIEW AGAIN path covered by `next()`, with no other path still saying "review the fix commits" for round 1? Is any round-2+ path changed by mistake?
- **stdin to jq:** does it keep exact JSON? Does it handle an empty `justin` list and very large records, on bash 3.2 and 5.3, and on jq 1.6 semantics?
- Do the doc edits leave any contradiction across CLAUDE.md, feature-dispatch, `review-fix-cadence`, `review-loop.md`, leorna and the Codex roles?
- **Real bash 3.2:** the local Docker image `review-loop-r2-bash32:local`.
- **Do the new tests fail when each fix is reverted?**

## Severity (Justin's rule)
Every P0–P2 finding must name a concrete real-use scenario of 5+ words; without one it is P3.
- **P0/P1:** the referee or gate lets unreviewed or still-buggy code through, a false AC, a wrong ASK or REVIEW AGAIN that would stall every story, or a broken suite.
- **P2:** a bug a real reviewer, fixer or orchestrator could plausibly hit, including realistic edge cases, or a test that can't fail.
- **P3:** cosmetic, docs wording, deliberate-only, or a setup none of Justin's machines has.

## How
- Run on head:
  - `bash .hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.test.sh`, also as `PATH=/usr/bin:/bin /bin/bash`;
  - the named runs `ac11_ac_check_existing_cases_pass` and `ac17_existing_suites_pass`.
- Do mutation checks in your own clone: `git clone -q ~/.claude-setup.git ~/.cache/review-loop-reviewer6/c && git -C … checkout -q --detach aba3093`.
- Don't treat the fixers' evidence as proof.

## Your round record (required)
Write `review-6/review.json` per the worktree's `references/review-loop.md`:
- round 6;
- scope `delta`;
- `from` = `aff26c8b2e4d3cc4cc151224dc5a54f1bcde244a`, `head` = `aba309358277f1845febe2c23f87db27665bfbe6`;
- findings `R6-<k>`, with `repeats`/`new_fact` where one repeats an earlier finding.

Then self-check it and save the output as `review-6/referee.txt`:
`bash ~/.claude-setup-wt/review-loop/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo ~/.claude-setup-wt/review-loop --base 691651c1e942896f42f4e64ed547a1a2a121ef3c ~/.hermes/plans/claude-setup/evidence/review-loop`

## Scratch and the desktop
- Keep scratch in your own `<scratchpad>/review-loop-reviewer6/` folder (fresh `mkdir`). Remove it by its literal path.
- Put `TMPDIR` and anything large in `~/.cache/review-loop-reviewer6/`.
- **Gotchas:**
  - In the Bash tool, `grep` is ugrep, so use `command grep`.
  - Use `tail -n N`.
  - Never `pkill -f`.

## Output (final message)
- `verdict`: `clean` (no P0–P2) or `changes-needed`.
- `findings[{id, severity, file_line, scenario, claim, evidence, fix}]`.
- `p3[]`.
- `ac_status[{ac, accepted, test, evidence}]` for AC1–AC18. AC18: `not_run: "live: …"`.
- `referee_last_line`.
- `found_else[]`.
- `skill_lessons[{skill, lesson, evidence, enforce}]`. An empty list is normal.

If you list any lessons, end with `MAIN SESSION: check and save these skill_lessons now.`
