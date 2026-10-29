# Brief: FIXER 2, story `review-loop`

## Role
You are **fixer 2** for Justin's setup story `review-loop`. You act on review round 2, test-first, in the story's worktree, and stop at `ready-for-review`. A fresh reviewer then does a delta review of your commits.

You don't start other agents, push, merge, rebase, run the real `sync.sh`, or write the live `~/.claude`, `~/.hermes`, `~/.hermes/skills-library` or global git config. A git-guard deny is the guard working.

## Justin's answer
The referee asked him (brake c), and he said "Keep going". It is recorded in `evidence/review-loop/review-2/justin.json` as `continue: true`, and the referee now says `REVIEW AGAIN`.

## Skills to load first
- `engineering-best-practices`
- `receiving-code-review`
- `test-driven-development`
- `mutation-testing-discipline`
- If something fails unexpectedly, use `systematic-debugging`.

## Where you work
- **Worktree:** `/home/justin/.claude-setup-wt/review-loop`, branch `review-loop`. Head `9aca235eb2d63ebc414e8afec380d1a83e20f710`, story base `691651c1e942896f42f4e64ed547a1a2a121ef3c`.
- **Before you start,** confirm HEAD is `9aca235` and that `git status --porcelain --untracked-files=all` is empty.
- **Approved plan:** `~/.hermes/plans/claude-setup/evidence/review-loop/plan-approved.md` (read-only). Don't change, add or rename ACs or test names.
- **Commits:** plain `git commit -m "…"`, identity `Justin <issajustin04@gmail.com>`. No AI trailer and no author overrides.

## Round 2 to act on
The record is `~/.hermes/plans/claude-setup/evidence/review-loop/review-2/review.json`, and the receipts are in that folder (see `p1-sync-rebase.sh` and `p1-sync-rebase.txt`).

### Must fix
**R2-1 (P2): `review-check.sh:143`.** The R1-9 fix exits 2 on a true full-round record when the story's base commit was rewritten on the integration branch. The setup repo's `sync.sh` rebases local `main` onto origin, so a story cut from an unpushed sync commit B0 ends up with B0 an ancestor of neither `--base` nor the rebased base.
- **Fix (the reviewer's):**
  - keep exit 2 only when `from` is not an older commit of its own `head`;
  - otherwise, when `from` isn't on `--base`'s history, print `REVIEW AGAIN` with a clear reason ("from <sha7> is not on --base's history: run a full review from <base>"). That still catches R1-9's wrongly recorded range.
- **Tests:** add the rewritten-base case to AC7, both before and after a finisher-style rebase. Keep R1-9's own case caught.
- **Docs:** update `references/review-loop.md`'s record rules if they need it.

### Also fix, if small (a P3 in this story's own code)
**R2-2:** the R1-4 fix silences git's stderr and always blames the git version. Capture git's first stderr line into the single `error:` line, still the first `error:` line, so `ac-check.sh --reviews` reports it. Pin diff-tree's stderr handling with a test (mutant R2M1 survived).

## Done means
- **Each fix:** test-first, with a killed mutant per changed rule.
- **On the new head:**
  - `review-check.test.sh` offline passes, plain and as `PATH=/usr/bin:/bin /bin/bash`;
  - the named runs `ac11_ac_check_existing_cases_pass` and `ac17_existing_suites_pass` pass.
- **Real bash 3.2:** run the offline suite under it. Reviewer 2 left a local Docker image, `review-loop-r2-bash32:local` (bash 3.2.57 plus git, jq, python3 and GNU tools), or use `docker run bash:3.2` with `apk add …`.
- **Clean tree.** Don't rebase.

## Evidence
`~/.hermes/plans/claude-setup/evidence/review-loop/fix-2/`.

## Scratch and the desktop
- Keep scratch in your own `<scratchpad>/review-loop-fixer2/` folder (fresh `mkdir`). Remove it by its literal path.
- Put `TMPDIR` and anything large in `~/.cache/review-loop-fixer2/`.
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
