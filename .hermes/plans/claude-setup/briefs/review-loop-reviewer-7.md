# Brief: REVIEWER 7 (delta round: the finisher's rebase), story `review-loop`

## Role
You are the fresh **reviewer 7** for Justin's setup story `review-loop`. You never saw the build, rounds 1–6, the fixes, or the rebase. You **only report**:
- no source changes, no commits;
- no other agents;
- never write the live `~/.claude`, `~/.hermes`, `~/.hermes/skills-library`, global git config, `~/.claude-setup.git` refs or GitHub.

Write only into `~/.hermes/plans/claude-setup/evidence/review-loop/review-7/`.

**Live guards.** git-guard checks every Bash call and the git hooks check every commit. A deny is the guard working. Probe git through a script file in a temp `HOME`.

**This is a delta round under the story's own loop.** You review only the fix commits since round 1's head, and what they touch. Your `review.json` goes to the story's referee.

## Skills to load first
1. `engineering-best-practices`
2. `requesting-code-review`: skip its nested-reviewer and auto-fix steps.
3. `code-review-practice`
4. `mutation-testing-discipline`

## Scope
- **Worktree:** `/home/justin/.claude-setup-wt/review-loop`, branch `review-loop`. Story base after the finisher's rebase: `c40a51cea5dce2ee9b04e1f3064847b78a81559b` (`git merge-base HEAD main`; the old base was `691651c`).
- **Round 6's head (the last clean review):** `aba309358277f1845febe2c23f87db27665bfbe6`.
- **Candidate head:** `aae49fd2c35a3c6d0c3b1e41f95eff46de71bd0f`, the story rebased onto local `main`.
- **Review:** what changed since `aba3093`: `git range-diff aba3093...aae49fd`. 23 commits are `=`, and two are `!`: 9/25 (`af78335` → `bda3f9f`, two conflict resolutions) and 25/25 (context only). The finisher's conflict notes are in `~/.hermes/plans/claude-setup/evidence/review-loop/finisher/conflicts/`; use them to find the hunks, not as proof. Read the rest of the story only for context.
- **Before you start,** confirm HEAD is `aae49fd` and that `git status --porcelain --untracked-files=all` is empty. If either fails, stop.
- **Approved plan:** `~/.hermes/plans/claude-setup/evidence/review-loop/plan-approved.md` (read-only).
- **Earlier rounds:** `~/.hermes/plans/claude-setup/evidence/review-loop/review-1/review.json` and `review-2/` … `review-6/review.json`, plus Justin's answers in `review-2/justin.json` and `review-3/justin.json` (both `continue`). Read them to link repeats (`repeats` and `new_fact` fields), not to anchor your judgement.
- **What the rebase changed:**
  - **`.claude/CLAUDE.md`:** `main` added the "Several jobs at once (user, 2026-10-29)" paragraph before the "Every brief…" line. The story added ", and every reviewer also writes its `review.json`" to that line. Both were kept.
  - **feature-dispatch `references/ac-verification.md` Steps 1 and 2:** `main` added a "(when it re-runs an earlier round's probe files … 901j verifier 3)" clause to step 1. The story inserted ", only after `review-check.sh` prints MOVE ON for the current head" into step 1 and rewrote step 2. Step 1 now has both; step 2 is the story's.
  - **Auto-merged:** `main`'s other edits in `ac-verification.md`, feature-dispatch `SKILL.md` and `leorna/SKILL.md`.
- **Already on the follow-up list** (`evidence/review-loop/follow-ups.md`; raise these only with something new): R1-3, R1-6, R1-7, R1-8, AC16's one-line limit, review-fix-cadence:32's wording, and the one extra delta review after a finisher rebase in the sync-rewrite case.

## Focus
- Did the resolutions keep both meanings, with nothing of `main`'s and nothing of the story's dropped or garbled? Check all four shared files: CLAUDE.md, feature-dispatch `SKILL.md`, `ac-verification.md` and `leorna/SKILL.md`.
- Does `main`'s new text contradict the review-loop rule anywhere? For example, the "Several jobs at once" paragraph, or `main`'s new verifier, screenshot and overlay notes.
- Do the story's doc tests (AC12–AC14) still prove what they should on the merged text? feature-dispatch must stay under 100,000 characters.
- Run the suites on `aae49fd`, including under real bash 3.2 (`review-loop-r2-bash32:local`).

## Severity (Justin's rule)
Every P0–P2 finding must name a concrete real-use scenario of 5+ words; without one it is P3.
- **P0/P1:** the referee or gate lets unreviewed or still-buggy code through, a false AC, a wrong ASK or REVIEW AGAIN that would stall every story, or a broken suite.
- **P2:** a bug a real reviewer, fixer or orchestrator could plausibly hit, including realistic edge cases, or a test that can't fail.
- **P3:** cosmetic, docs wording, deliberate-only, or a setup none of Justin's machines has.

## How
- Run on head:
  - `bash .hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.test.sh`, also as `PATH=/usr/bin:/bin /bin/bash`;
  - the named runs `ac11_ac_check_existing_cases_pass` and `ac17_existing_suites_pass`.
- Do mutation checks in your own clone: `git clone -q ~/.claude-setup.git ~/.cache/review-loop-reviewer7/c && git -C … checkout -q --detach aae49fd`.
- Don't treat the fixers' evidence as proof.

## Your round record (required)
Write `review-7/review.json` per the worktree's `references/review-loop.md`:
- round 7;
- scope `delta`;
- `from` = `aba309358277f1845febe2c23f87db27665bfbe6` (round 6's head), `head` = `aae49fd2c35a3c6d0c3b1e41f95eff46de71bd0f`;
- findings `R7-<k>`, with `repeats`/`new_fact` where one repeats an earlier finding.

Then self-check it and save the output as `review-7/referee.txt`:
`bash ~/.claude-setup-wt/review-loop/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo ~/.claude-setup-wt/review-loop --base c40a51cea5dce2ee9b04e1f3064847b78a81559b ~/.hermes/plans/claude-setup/evidence/review-loop`

## Scratch and the desktop
- Keep scratch in your own `<scratchpad>/review-loop-reviewer7/` folder (fresh `mkdir`). Remove it by its literal path.
- Put `TMPDIR` and anything large in `~/.cache/review-loop-reviewer7/`.
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
