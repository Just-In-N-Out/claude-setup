# Brief: REVIEWER 8 (delta round: the finisher's second rebase), story `review-loop`

## Role
You are the fresh **reviewer 8** for Justin's setup story `review-loop`. You never saw the build, rounds 1–7, the fixes, or the rebases. You **only report**:
- no source changes, no commits;
- no other agents;
- never write the live `~/.claude`, `~/.hermes`, `~/.hermes/skills-library`, global git config, `~/.claude-setup.git` refs or GitHub.

Write only into `~/.hermes/plans/claude-setup/evidence/review-loop/review-8/`.

**Live guards.** git-guard checks every Bash call and the git hooks check every commit. A deny is the guard working. Probe git through a script file in a temp `HOME`.

**This is a delta round under the story's own loop.** You review only the fix commits since round 1's head, and what they touch. Your `review.json` goes to the story's referee.

## Skills to load first
1. `engineering-best-practices`
2. `requesting-code-review`: skip its nested-reviewer and auto-fix steps.
3. `code-review-practice`
4. `mutation-testing-discipline`

## Scope
- **Worktree:** `/home/justin/.claude-setup-wt/review-loop`, branch `review-loop`. Story base after the finisher's rebase: `c82f0e7f116a251f7685658f3f1deb0799ce0c7e` (`git merge-base HEAD main`; the previous base was `c40a51c`).
- **Round 7's head (the last clean review):** `aae49fd2c35a3c6d0c3b1e41f95eff46de71bd0f`.
- **Candidate head:** `25c2f3c5a8ac1c6c37877938faab53f2f6e3bfd9`, the story rebased onto newer local `main`.
- **Review:** what changed since `aae49fd`: `git range-diff aae49fd...25c2f3c`. 24 of 25 story patches are `=`. Patch 9 (`bda3f9f` → `6546860`) is `!` only because `main`'s new text in `feature-dispatch/references/ac-verification.md` (a Screenshot-bullet `go build -overlay …` note) now sits in that hunk's context. There were no conflicts. The finisher's notes are in `~/.hermes/plans/claude-setup/evidence/review-loop/finisher-2/`; use them to find things, not as proof.
- **Before you start,** confirm HEAD is `25c2f3c` and that `git status --porcelain --untracked-files=all` is empty. If either fails, stop.
- **Approved plan:** `~/.hermes/plans/claude-setup/evidence/review-loop/plan-approved.md` (read-only).
- **Earlier rounds:** `~/.hermes/plans/claude-setup/evidence/review-loop/review-1/review.json` and `review-2/` … `review-7/review.json`, plus Justin's answers in `review-2/justin.json` and `review-3/justin.json` (both `continue`). Read them to link repeats (`repeats` and `new_fact` fields), not to anchor your judgement.
- **What the rebase changed:**
  - `main` changed `leorna/SKILL.md` (lines 114–197, away from the story's 83–95) and `ac-verification.md` (inside patch 9's context).
  - Both merged with no conflict, and the story's own `+`/`-` lines are unchanged.
- **Already on the follow-up list** (`evidence/review-loop/follow-ups.md`; raise these only with something new): R1-3, R1-6, R1-7, R1-8, AC16's one-line limit, review-fix-cadence:32's wording, and the one extra delta review after a finisher rebase in the sync-rewrite case.

## Focus
- Confirm the story's `+`/`-` lines are unchanged and `main`'s new text is intact, with nothing duplicated or garbled, in `leorna/SKILL.md` and `ac-verification.md`.
- Does `main`'s new text contradict the review-loop rule?
- Run the offline suite and `ac17_existing_suites_pass` on `25c2f3c`.
- Keep it short. This is a small delta.

## Severity (Justin's rule)
Every P0–P2 finding must name a concrete real-use scenario of 5+ words; without one it is P3.
- **P0/P1:** the referee or gate lets unreviewed or still-buggy code through, a false AC, a wrong ASK or REVIEW AGAIN that would stall every story, or a broken suite.
- **P2:** a bug a real reviewer, fixer or orchestrator could plausibly hit, including realistic edge cases, or a test that can't fail.
- **P3:** cosmetic, docs wording, deliberate-only, or a setup none of Justin's machines has.

## How
- Run on head:
  - `bash .hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.test.sh`, also as `PATH=/usr/bin:/bin /bin/bash`;
  - the named runs `ac11_ac_check_existing_cases_pass` and `ac17_existing_suites_pass`.
- Do mutation checks in your own clone: `git clone -q ~/.claude-setup.git ~/.cache/review-loop-reviewer8/c && git -C … checkout -q --detach 25c2f3c`.
- Don't treat the fixers' evidence as proof.

## Your round record (required)
Write `review-8/review.json` per the worktree's `references/review-loop.md`:
- round 8;
- scope `delta`;
- `from` = `aae49fd2c35a3c6d0c3b1e41f95eff46de71bd0f` (round 7's head), `head` = `25c2f3c5a8ac1c6c37877938faab53f2f6e3bfd9`;
- findings `R8-<k>`, with `repeats`/`new_fact` where one repeats an earlier finding.

Then self-check it and save the output as `review-8/referee.txt`:
`bash ~/.claude-setup-wt/review-loop/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo ~/.claude-setup-wt/review-loop --base c82f0e7f116a251f7685658f3f1deb0799ce0c7e ~/.hermes/plans/claude-setup/evidence/review-loop`

## Scratch and the desktop
- Keep scratch in your own `<scratchpad>/review-loop-reviewer8/` folder (fresh `mkdir`). Remove it by its literal path.
- Put `TMPDIR` and anything large in `~/.cache/review-loop-reviewer8/`.
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
