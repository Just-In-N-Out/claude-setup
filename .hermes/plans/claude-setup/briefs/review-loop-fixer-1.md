# Brief: FIXER 1, story `review-loop`

## Role
You are **fixer 1** for Justin's setup story `review-loop`. You act on review round 1, test-first, in the story's worktree, and stop at `ready-for-review`. A fresh reviewer then does a **delta** review of your fix commits, per the story's own loop.

You don't start other agents, push, merge, rebase, run the real `sync.sh`, or write the live `~/.claude`, `~/.hermes`, `~/.hermes/skills-library` or global git config.

**Live guards.** git-guard checks every Bash call and the git hooks check every commit. A deny is the guard working.

## Skills to load first
- `engineering-best-practices`
- `receiving-code-review`: verify each finding before fixing it.
- `test-driven-development`
- `mutation-testing-discipline`
- If something fails unexpectedly, use `systematic-debugging`.

## Where you work
- **Worktree:** `/home/justin/.claude-setup-wt/review-loop`, branch `review-loop`. Head `d3f220f77c9966c5880c779c3411dcdea65950dd`, base `691651c1e942896f42f4e64ed547a1a2a121ef3c`.
- **Before you start,** confirm HEAD is `d3f220f` and that `git status --porcelain --untracked-files=all` is empty.
- **Approved plan:** `~/.hermes/plans/claude-setup/evidence/review-loop/plan-approved.md` (read-only). Don't change, add or rename ACs or test names; put new cases inside the existing AC test functions.
- **Commits:** plain `git commit -m "…"`, identity `Justin <issajustin04@gmail.com>`. No AI trailer and no author overrides.

## Round 1 to act on
The round record is `~/.hermes/plans/claude-setup/evidence/review-loop/review-1/review.json`, and the reviewer's receipts are in that folder.

### Must fix
**R1-1 (P1): `review-check.sh:80`, `JUDGE=$(cat <<'JQ' … JQ)`, doesn't parse under macOS `/bin/bash` 3.2.**
- **Why:** bash 3.2's `$(` scan has no here-document logic.
- **Fix:**
  - Take the jq programs out of `$(…)`: `read -r -d '' JUDGE <<'JQ' || :`, or a function that prints them. Do the same for `VALIDATE` and any other heredoc inside `$(` in the three scripts.
  - Make AC16's test fail on a heredoc opened inside `$(` (an ERE such as `[$][(][^)]*<<`) in `review-check.sh`, `ac-check.sh` and `review-check.test.sh`. That is RED on the current head.
- **Proof:**
  - **Parse:** if the reviewer's port of bash 3.2's scan (`review-1/bash32-comsub-scan.py`) can be reused, run it on the fixed scripts.
  - **Behaviour:** the referee's outputs are unchanged. All AC1–AC10 cases stay green.

### Also fix: P3s in this story's own files, cheap and test-first where testable (Justin wants the rule text consistent)
- **R1-2,** feature-dispatch `SKILL.md:222`: remove the "Otherwise dispatch the verifier" path, so every fix gets a fresh review.
- **R1-4,** `review-check.sh:148`: exit 2 when the `diff-tree | patch-id` pipeline fails. Add a test case.
- **R1-5,** `review-check.sh:103`: validate `continue` as a boolean, and require `accept` or `continue` in `justin.json`. Add AC6/AC8 cases.
- **R1-9,** `review-check.sh:134`: a `full` round's `from` must be `--base` or an ancestor of it. Add an AC7/AC8 case.
- **R1-10,** CLAUDE.md step 5: add the Mini exception ("Mini: round 1 only") to match the other docs.

### Leave alone (they go on the follow-up list)
- **R1-3** (fails closed);
- **R1-6** (message wording);
- **R1-7** (a design question for Justin);
- **R1-8** (the FigmaToBricksV2 repo's own CLAUDE.md, outside this story).

## Done means
- **Each fix:** test-first, with a killed mutant per changed rule.
- **On the new head:**
  - `review-check.test.sh` offline passes, plain and as `PATH=/usr/bin:/bin /bin/bash`;
  - the named runs `ac11_ac_check_existing_cases_pass` and `ac17_existing_suites_pass` pass;
  - feature-dispatch is under 100,000 characters.
- **Clean tree.** Don't rebase.

## Evidence
`~/.hermes/plans/claude-setup/evidence/review-loop/fix-1/`.

## Scratch and the desktop
- Keep scratch in your own `<scratchpad>/review-loop-fixer1/` folder (fresh `mkdir`). Remove it by its literal path.
- Put `TMPDIR` and anything large in `~/.cache/review-loop-fixer1/`.
- **Gotchas:**
  - In the Bash tool, `grep` is ugrep, so use `command grep`.
  - Use `tail -n N`.
  - Never `pkill -f`.

## Output
- `status`: `ready-for-review` or `stopped`.
- `head_sha`.
- `fixes[{id, action: fixed|pushed-back, commits, test, evidence}]`.
- `found_else[]`.
- `skill_lessons[{skill, lesson, evidence, enforce}]`. An empty list is normal.

If you list any lessons, end with `MAIN SESSION: check and save these skill_lessons now.`
