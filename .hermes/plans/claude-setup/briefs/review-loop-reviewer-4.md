# Brief: REVIEWER 4 (delta round), story `review-loop`

## Role
You are the fresh **reviewer 4** for Justin's setup story `review-loop`. You never saw the build, rounds 1–3, or the fixes. You **only report**:
- no source changes, no commits;
- no other agents;
- never write the live `~/.claude`, `~/.hermes`, `~/.hermes/skills-library`, global git config, `~/.claude-setup.git` refs or GitHub.

Write only into `~/.hermes/plans/claude-setup/evidence/review-loop/review-4/`.

**Live guards.** git-guard checks every Bash call and the git hooks check every commit. A deny is the guard working. Probe git through a script file in a temp `HOME`.

**This is a delta round under the story's own loop.** You review only the fix commits since round 1's head, and what they touch. Your `review.json` goes to the story's referee.

## Skills to load first
1. `engineering-best-practices`
2. `requesting-code-review`: skip its nested-reviewer and auto-fix steps.
3. `code-review-practice`
4. `mutation-testing-discipline`

## Scope
- **Worktree:** `/home/justin/.claude-setup-wt/review-loop`, branch `review-loop`. Story base: `691651c1e942896f42f4e64ed547a1a2a121ef3c`.
- **Round 3's head:** `2fad9c37412dd51b063dc79a03966a9a280c2d99`.
- **Candidate head:** `aff26c8b2e4d3cc4cc151224dc5a54f1bcde244a`.
- **Review:** `git diff 2fad9c3..aff26c8`, 2 commits (`97f3a67`, `aff26c8`). Read the rest of the story only for context.
- **Before you start,** confirm HEAD is `aff26c8` and that `git status --porcelain --untracked-files=all` is empty. If either fails, stop.
- **Approved plan:** `~/.hermes/plans/claude-setup/evidence/review-loop/plan-approved.md` (read-only).
- **Earlier rounds:** `~/.hermes/plans/claude-setup/evidence/review-loop/review-1/review.json` and `review-2/review.json`, `review-3/review.json`, plus Justin's answers in `review-2/justin.json` and `review-3/justin.json` (both `continue`). Read them to link repeats (`repeats` and `new_fact` fields), not to anchor your judgement.
- **What the fix commits changed:**
  - **R3-1:** the off-base check now takes the latest full round anywhere in the records (the delta chain's root). Its `from` must be `--base` or an older commit of it, otherwise REVIEW AGAIN ("run a full review from <base>"). Only a full round from `--base` clears it; a `from` that is gone counts as off-base. Brakes and Justin's answers still come first.
  - **R3-2:** a `mktemp` failure (a missing `TMPDIR`) no longer exits 2. The EXIT trap is set only when `mktemp` succeeded.
  - **Tests:** AC7 runs a table of 33 record sequences (`evidence/review-loop/fix-3/base-rule-table.txt`), and exports `TMPDIR` for the whole test so `notmp` sees every run.
  - **Docs:** `references/review-loop.md` lines about 47 and 63.
- **Already on the follow-up list** (`evidence/review-loop/follow-ups.md`; raise these only with something new): R1-3, R1-6, R1-7, R1-8, AC16's one-line limit, review-fix-cadence:32's wording, and the one extra delta review after a finisher rebase in the sync-rewrite case.

## Focus
- **This off-base area produced a P2 in rounds 2 and 3.** Attack it hard:
  - Is there any realistic record sequence where the referee says MOVE ON over an unreviewed range, or stalls (exit 2, or REVIEW AGAIN that no reviewer can clear) on true records?
  - Check the fixer's claim that the delta chain covers `full.from..HEAD`.
  - Try sequences the table lacks.
- **The trap and `mktemp` change:** run it on real bash 3.2 in the local Docker image `review-loop-r2-bash32:local`.
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
- Do mutation checks in your own clone: `git clone -q ~/.claude-setup.git ~/.cache/review-loop-reviewer4/c && git -C … checkout -q --detach aff26c8`.
- Don't treat the fixers' evidence as proof.

## Your round record (required)
Write `review-4/review.json` per the worktree's `references/review-loop.md`:
- round 4;
- scope `delta`;
- `from` = `2fad9c37412dd51b063dc79a03966a9a280c2d99`, `head` = `aff26c8b2e4d3cc4cc151224dc5a54f1bcde244a`;
- findings `R4-<k>`, with `repeats`/`new_fact` where one repeats an earlier finding.

Then self-check it and save the output as `review-4/referee.txt`:
`bash ~/.claude-setup-wt/review-loop/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo ~/.claude-setup-wt/review-loop --base 691651c1e942896f42f4e64ed547a1a2a121ef3c ~/.hermes/plans/claude-setup/evidence/review-loop`

## Scratch and the desktop
- Keep scratch in your own `<scratchpad>/review-loop-reviewer4/` folder (fresh `mkdir`). Remove it by its literal path.
- Put `TMPDIR` and anything large in `~/.cache/review-loop-reviewer4/`.
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
