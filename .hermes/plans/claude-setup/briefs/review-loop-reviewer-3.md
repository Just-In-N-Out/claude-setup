# Brief: REVIEWER 3 (delta round), story `review-loop`

## Role
You are the fresh **reviewer 3** for Justin's setup story `review-loop`. You never saw the build, rounds 1–2, or the fixes. You **only report**:
- no source changes, no commits;
- no other agents;
- never write the live `~/.claude`, `~/.hermes`, `~/.hermes/skills-library`, global git config, `~/.claude-setup.git` refs or GitHub.

Write only into `~/.hermes/plans/claude-setup/evidence/review-loop/review-3/`.

**Live guards.** git-guard checks every Bash call and the git hooks check every commit. A deny is the guard working. Probe git through a script file in a temp `HOME`.

**This is a delta round under the story's own loop.** You review only the fix commits since round 1's head, and what they touch. Your `review.json` goes to the story's referee.

## Skills to load first
1. `engineering-best-practices`
2. `requesting-code-review`: skip its nested-reviewer and auto-fix steps.
3. `code-review-practice`
4. `mutation-testing-discipline`

## Scope
- **Worktree:** `/home/justin/.claude-setup-wt/review-loop`, branch `review-loop`. Story base: `691651c1e942896f42f4e64ed547a1a2a121ef3c`.
- **Round 2's head:** `9aca235eb2d63ebc414e8afec380d1a83e20f710`.
- **Candidate head:** `2fad9c37412dd51b063dc79a03966a9a280c2d99`.
- **Review:** `git diff 9aca235..2fad9c3`, 2 commits (`0642210`, `2fad9c3`). Read the rest of the story only for context.
- **Before you start,** confirm HEAD is `2fad9c3` and that `git status --porcelain --untracked-files=all` is empty. If either fails, stop.
- **Approved plan:** `~/.hermes/plans/claude-setup/evidence/review-loop/plan-approved.md` (read-only).
- **Earlier rounds:** `~/.hermes/plans/claude-setup/evidence/review-loop/review-1/review.json` and `review-2/review.json`, plus Justin's answer in `review-2/justin.json` ("Keep going"). Read them to link repeats (`repeats` and `new_fact` fields), not to anchor your judgement.
- **What the fix commits changed:**
  - **R2-1:** a full round whose `from` isn't on `--base`'s history now gives REVIEW AGAIN ("run a full review from <base>") instead of exit 2. Exit 2 stays only when `from` isn't an older commit of its own head. The check runs before the "HEAD is the reviewed head" MOVE ON. Brakes still come first.
  - **R2-2:** `pids` failures name git's first stderr line in the single `error:` line, via a `mktemp` file removed by `trap … EXIT`.
  - **Tests:** new AC7 cases, including a real sync-rewrite scenario.
  - **Docs:** `references/review-loop.md`.
- **Already on the follow-up list** (`evidence/review-loop/follow-ups.md`; raise these only with something new): R1-3, R1-6, R1-7, R1-8, AC16's one-line limit, review-fix-cadence:32's wording, and the one extra delta review after a finisher rebase in the sync-rewrite case.

## Focus
- Does R2-1's fix stay true to the rule? It must never MOVE ON with a mis-recorded range, never stall on a true record, and keep the brakes first.
- **The new `trap … EXIT`:** does it clobber an existing trap, or leave temp files behind when a signal arrives? Is `mktemp` portable to macOS (BSD `mktemp` without `-t`)?
- **Real bash 3.2:** run the suite under it. The local Docker image `review-loop-r2-bash32:local` has bash 3.2.57 plus git, jq, python3 and GNU tools.
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
- Do mutation checks in your own clone: `git clone -q ~/.claude-setup.git ~/.cache/review-loop-reviewer3/c && git -C … checkout -q --detach 2fad9c3`.
- Don't treat the fixers' evidence as proof.

## Your round record (required)
Write `review-3/review.json` per the worktree's `references/review-loop.md`:
- round 3;
- scope `delta`;
- `from` = `9aca235eb2d63ebc414e8afec380d1a83e20f710`, `head` = `2fad9c37412dd51b063dc79a03966a9a280c2d99`;
- findings `R3-<k>`, with `repeats`/`new_fact` where one repeats an earlier finding.

Then self-check it and save the output as `review-3/referee.txt`:
`bash ~/.claude-setup-wt/review-loop/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo ~/.claude-setup-wt/review-loop --base 691651c1e942896f42f4e64ed547a1a2a121ef3c ~/.hermes/plans/claude-setup/evidence/review-loop`

## Scratch and the desktop
- Keep scratch in your own `<scratchpad>/review-loop-reviewer3/` folder (fresh `mkdir`). Remove it by its literal path.
- Put `TMPDIR` and anything large in `~/.cache/review-loop-reviewer3/`.
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
