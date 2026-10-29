# Brief: FIXER 4, story `review-loop`

## Role
You are **fixer 4** for Justin's setup story `review-loop`. You act on review round 5 (the second full review), test-first, in the story's worktree, and stop at `ready-for-review`. A fresh reviewer then does a delta review of your commits.

You don't start other agents, push, merge, rebase, run the real `sync.sh`, or write the live `~/.claude`, `~/.hermes`, `~/.hermes/skills-library` or global git config. A git-guard deny is the guard working.

## Where the loop stands
- Rounds 1–4 ended MOVE ON at `aff26c8`.
- The orchestrator then ran round 5, a second **full** review. The rule gives a Full story two full rounds, and round 2 had wrongly been a delta.
- Round 5 found one P2. Its referee line is REVIEW AGAIN, and no brake tripped.
- Justin's standing words: "keep pushing and doing everything".

## Skills to load first
- `engineering-best-practices`
- `receiving-code-review`
- `test-driven-development`
- `mutation-testing-discipline`
- If something fails unexpectedly, use `systematic-debugging`.

## Where you work
- **Worktree:** `/home/justin/.claude-setup-wt/review-loop`, branch `review-loop`. Head `aff26c8b2e4d3cc4cc151224dc5a54f1bcde244a`, story base `691651c1e942896f42f4e64ed547a1a2a121ef3c`.
- **Before you start,** confirm HEAD is `aff26c8` and that `git status --porcelain --untracked-files=all` is empty.
- **Approved plan:** `~/.hermes/plans/claude-setup/evidence/review-loop/plan-approved.md` (read-only). Don't change, add or rename ACs or test names.
- **Commits:** plain `git commit -m "…"`, identity `Justin <issajustin04@gmail.com>`. No AI trailer and no author overrides.

## Round 5 to act on
The record is `~/.hermes/plans/claude-setup/evidence/review-loop/review-5/review.json`, and the receipts are in that folder (`probes.txt`, `probe-size.txt`, `mutants.txt`).

### Must fix
**R5-1 (P2): `review-check.sh:204` and `references/review-loop.md:65`.** After round 1 lists P0–P2, the referee says "fix them, then review the fix commits", and `review-loop.md:65` gives the next brief `from` = this round's head. In a Full story, round 2 must review the whole story. This story's own round 2 went wrong exactly this way.
- For round 1's REVIEW AGAIN, end the line with the exception, e.g. "fix them, then review again (Full: round 2 reviews the whole story from <base>; Mini: the fix commits)". Pin it in AC2 for n=1, with later rounds unchanged.
- In `review-loop.md:65`, add "(Full's round 2: full, `from` = `--base`)".
- The same rule applies to the "commits after the reviewed head" form, if round 1 is the latest round.

### Also fix (small P3s in this story's own files, test-first where testable)
- **R5-4:** pass the review records to jq through stdin or `--slurpfile`, not one `--argjson` argument, which fails on Linux past 128 KiB. Add a test with records over 128 KiB that gives the normal outcome.
- **R5-5:** pin AC5's `new_fact` boundary at 4 and 5 words, and add a case with leading or trailing whitespace (`' a b c d'`).
- **R5-6:** add one sentence to `review-loop.md` saying the delta reviewer judges each fixer rejection and re-raises it with `repeats` when the rejection doesn't hold.
- **Docs that still contradict the loop:**
  - R5-2: `leorna/SKILL.md:96`, a fix after the verifier is reviewed first;
  - R5-3: feature-dispatch `SKILL.md:349` FINISHER context;
  - R5-7: `.codex/agents/pipeline-reviewer.toml:15`, the Mini exception;
  - R4-2: CLAUDE.md step 5, `SKILL.md:345/360` and `review-fix-cadence:32`, adding "(unless review-check.sh says run a full review from <base>)";
  - R4-1: `review-loop.md:47`, "an earlier full round's from".
- Keep feature-dispatch under 100,000 characters, and AC12/AC13 green.

### Leave alone
Everything else on `evidence/review-loop/follow-ups.md`.

## Done means
- **Each fix:** test-first, with a killed mutant per changed rule.
- **On the new head:**
  - `review-check.test.sh` offline passes, plain and as `PATH=/usr/bin:/bin /bin/bash`;
  - the named runs `ac11_ac_check_existing_cases_pass` and `ac17_existing_suites_pass` pass.
- **Real bash 3.2:** run the offline suite under it. Use the local Docker image `review-loop-r2-bash32:local` (bash 3.2.57 plus git, jq, python3 and GNU tools).
- **Clean tree.** Don't rebase.

## Evidence
`~/.hermes/plans/claude-setup/evidence/review-loop/fix-4/`.

## Scratch and the desktop
- Keep scratch in your own `<scratchpad>/review-loop-fixer4/` folder (fresh `mkdir`). Remove it by its literal path.
- Put `TMPDIR` and anything large in `~/.cache/review-loop-fixer4/`.
- **Gotchas:**
  - In the Bash tool, `grep` is ugrep, so use `command grep`.
  - Use `tail -n N`.
  - Never `pkill -f`.
  - A fake tool on PATH must resolve the real one before PATH changes.

## Output
- `status`: `ready-for-review` or `stopped`.
- `head_sha`.
- `fixes[{id, action, commits, test, evidence}]`.
- `found_else[]`.
- `skill_lessons[{skill, lesson, evidence, enforce}]`. An empty list is normal.

If you list any lessons, end with `MAIN SESSION: check and save these skill_lessons now.`
