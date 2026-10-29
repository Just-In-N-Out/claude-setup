# Brief: REVIEWER 2 (delta round), story `review-loop`

## Role
You are the fresh **reviewer 2** for Justin's setup story `review-loop`. You never saw the build, round 1, or the fix. You **only report**:
- no source changes, no commits;
- no other agents;
- never write the live `~/.claude`, `~/.hermes`, `~/.hermes/skills-library`, global git config, `~/.claude-setup.git` refs or GitHub.

Write only into `~/.hermes/plans/claude-setup/evidence/review-loop/review-2/`.

**Live guards.** git-guard checks every Bash call and the git hooks check every commit. A deny is the guard working. Probe git through a script file in a temp `HOME`.

**This is a delta round under the story's own loop.** You review only the fix commits since round 1's head, and what they touch. Your `review.json` goes to the story's referee.

## Skills to load first
1. `engineering-best-practices`
2. `requesting-code-review`: skip its nested-reviewer and auto-fix steps.
3. `code-review-practice`
4. `mutation-testing-discipline`

## Scope
- **Worktree:** `/home/justin/.claude-setup-wt/review-loop`, branch `review-loop`. Story base: `691651c1e942896f42f4e64ed547a1a2a121ef3c`.
- **Round 1's head:** `d3f220f77c9966c5880c779c3411dcdea65950dd`.
- **Candidate head:** `9aca235eb2d63ebc414e8afec380d1a83e20f710`.
- **Review:** `git diff d3f220f..9aca235`, 5 commits (`cf54b00`, `44c5633`, `b542847`, `89d43b5`, `9aca235`). Read the rest of the story only for context.
- **Before you start,** confirm HEAD is `9aca235` and that `git status --porcelain --untracked-files=all` is empty. If either fails, stop.
- **Approved plan:** `~/.hermes/plans/claude-setup/evidence/review-loop/plan-approved.md` (read-only).
- **Earlier round:** round 1's record is `~/.hermes/plans/claude-setup/evidence/review-loop/review-1/review.json`. Read it to link repeats (`repeats` and `new_fact` fields), not to anchor your judgement.
- **What the fix commits changed:**
  - `review-check.sh`: the jq programs are read with `IFS= read -r -d '' X <<'JQ' || :` instead of a heredoc inside `$(…)`, for macOS bash 3.2;
  - `justin.json` validation: `words` plus `accept` and/or a boolean `continue`;
  - a full round's `from` must be `--base` or an older commit of it;
  - `pids()` failures exit 2, with git's own stderr silenced;
  - doc fixes in feature-dispatch `SKILL.md` (lines about 213 and 222) and CLAUDE.md step 5 (the Mini exception);
  - new test cases in AC6, AC7, AC8, AC12 and AC16.
- **Already on the follow-up list** (`evidence/review-loop/follow-ups.md`; raise these only with something new): R1-3, R1-6, R1-7, R1-8, AC16's one-line limit, and review-fix-cadence:32's wording.

## Focus
- Do the fixes really fix round 1's findings, without changing the referee's other decisions?
- **macOS bash 3.2:** is any construct left that 3.2 can't parse? There's a port of its `$(` scan at `evidence/review-loop/fix-1/comsub32_all.py`; check it and use it if sound.
- **`IFS= read -r -d '' X <<'JQ' || :`:** does it keep the program byte-exact, including trailing newlines and backslashes, on bash 3.2 and 5?
- **The new validation:** does it wrongly reject real records? For example, a resumed session's `justin.json`, a delta round after a rebase, or a full round after a rebase whose `from` is the old base.
- **Silenced git stderr in `pids()`:** does it hide a real problem from the orchestrator?
- **Do the new tests fail when the fix is reverted?**

## Severity (Justin's rule)
Every P0–P2 finding must name a concrete real-use scenario of 5+ words; without one it is P3.
- **P0/P1:** the referee or gate lets unreviewed or still-buggy code through, a false AC, a wrong ASK or REVIEW AGAIN that would stall every story, or a broken suite.
- **P2:** a bug a real reviewer, fixer or orchestrator could plausibly hit, including realistic edge cases, or a test that can't fail.
- **P3:** cosmetic, docs wording, deliberate-only, or a setup none of Justin's machines has.

## How
- Run on head:
  - `bash .hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.test.sh`, also as `PATH=/usr/bin:/bin /bin/bash`;
  - the named runs `ac11_ac_check_existing_cases_pass` and `ac17_existing_suites_pass`.
- Do mutation checks in your own clone: `git clone -q ~/.claude-setup.git ~/.cache/review-loop-reviewer2/c && git -C … checkout -q --detach 9aca235`.
- Don't treat the fixer's evidence as proof.

## Your round record (required)
Write `review-2/review.json` per the worktree's `references/review-loop.md`:
- round 2;
- scope `delta`;
- `from` = `d3f220f77c9966c5880c779c3411dcdea65950dd`, `head` = `9aca235eb2d63ebc414e8afec380d1a83e20f710`;
- findings `R2-<k>`, with `repeats`/`new_fact` where one repeats a round-1 finding.

Then self-check it and save the output as `review-2/referee.txt`:
`bash ~/.claude-setup-wt/review-loop/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo ~/.claude-setup-wt/review-loop --base 691651c1e942896f42f4e64ed547a1a2a121ef3c ~/.hermes/plans/claude-setup/evidence/review-loop`

## Scratch and the desktop
- Keep scratch in your own `<scratchpad>/review-loop-reviewer2/` folder (fresh `mkdir`). Remove it by its literal path.
- Put `TMPDIR` and anything large in `~/.cache/review-loop-reviewer2/`.
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
