# Brief: FIXER 3, story `review-loop`

## Role
You are **fixer 3** for Justin's setup story `review-loop`. You act on review round 3, test-first, in the story's worktree, and stop at `ready-for-review`. A fresh reviewer then does a delta review of your commits.

You don't start other agents, push, merge, rebase, run the real `sync.sh`, or write the live `~/.claude`, `~/.hermes`, `~/.hermes/skills-library` or global git config. A git-guard deny is the guard working.

## Justin's answer
The referee asked again (brake c: 1 P2 in round 3, no fewer than round 2's 1). Justin had said, before leaving: "Yo, I'm gonna go, so just keep pushing and doing everything." That is recorded in `evidence/review-loop/review-3/justin.json` as `continue: true`, and the referee now says REVIEW AGAIN.

**Note:** the R1-9 "full round's `from` must be on `--base`" area has now produced a finding in rounds 2 and 3. Design it so there is no round 4 in the same area:
- List every realistic record sequence: full/delta rounds, `from` on or off the base, clean or with a P2, with or without the finisher's rebase, the sync-rewrite case, Justin's `continue`/`accept`.
- Decide the referee's answer for each.
- Test them as a table inside AC7.
- Prefer the simplest rule that makes MOVE ON impossible over an unreviewed range.

## Skills to load first
- `engineering-best-practices`
- `receiving-code-review`
- `test-driven-development`
- `mutation-testing-discipline`
- If something fails unexpectedly, use `systematic-debugging`.

## Where you work
- **Worktree:** `/home/justin/.claude-setup-wt/review-loop`, branch `review-loop`. Head `2fad9c37412dd51b063dc79a03966a9a280c2d99`, story base `691651c1e942896f42f4e64ed547a1a2a121ef3c`.
- **Before you start,** confirm HEAD is `2fad9c3` and that `git status --porcelain --untracked-files=all` is empty.
- **Approved plan:** `~/.hermes/plans/claude-setup/evidence/review-loop/plan-approved.md` (read-only). Don't change, add or rename ACs or test names.
- **Commits:** plain `git commit -m "…"`, identity `Justin <issajustin04@gmail.com>`. No AI trailer and no author overrides.

## Round 3 to act on
The record is `~/.hermes/plans/claude-setup/evidence/review-loop/review-3/review.json`, and the receipts are in that folder (see `p-offbase.txt`, `p-tmpdir.txt`).

### Must fix
**R3-1 (P2): `review-check.sh:141`.** `offbase` is set only when the latest round is itself full. One clean delta round after an off-base full round wipes it, and the referee says MOVE ON over a range nobody reviewed. `ac-check.sh --reviews` then accepts it.
- **Fix (the reviewer's):**
  - take `offbase` from the delta chain's root: walk back from round n while the scope is delta, then check that full round's `from` against `--base`;
  - a `from` that is no longer a commit counts as off-base.
- **Tests:** add AC7 cases:
  - an off-base full round with a P2, then a fixer, then a clean delta, which must not MOVE ON;
  - the sync-rewrite version of the same.
- **Docs:** put the "run a full review from <base>" step first in `references/review-loop.md:63`.

### Also fix (small, in this story's own code)
- **R3-2 (P3):** with `TMPDIR` pointing at a missing folder, the pure-rebase path now exits 2, and mktemp's own line comes before the `error:` line. Use `gerr=$(mktemp … 2>/dev/null) || gerr=/dev/null`, or similar, and add a test.
- **AC7's `notmp`:** it sees only calls made with `TMPDIR=$S/tmp`. Set `TMPDIR` for the whole AC7 test so it covers every call.

## Done means
- **Each fix:** test-first, with a killed mutant per changed rule.
- **On the new head:**
  - `review-check.test.sh` offline passes, plain and as `PATH=/usr/bin:/bin /bin/bash`;
  - the named runs `ac11_ac_check_existing_cases_pass` and `ac17_existing_suites_pass` pass.
- **Real bash 3.2:** run the offline suite under it. Use the local Docker image `review-loop-r2-bash32:local` (bash 3.2.57 plus git, jq, python3 and GNU tools).
- **Clean tree.** Don't rebase.

## Evidence
`~/.hermes/plans/claude-setup/evidence/review-loop/fix-3/`.

## Scratch and the desktop
- Keep scratch in your own `<scratchpad>/review-loop-fixer3/` folder (fresh `mkdir`). Remove it by its literal path.
- Put `TMPDIR` and anything large in `~/.cache/review-loop-fixer3/`.
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
