# VERIFIER — leorna-control-plane, story 86bcm901a "Curate agent definitions"

Role: VERIFIER, a fresh agent that never saw the build, the reviews or the fixes. **Source read-only:** never edit, commit, stage, stash or reset anything in the worktree. You re-run the gates, check that the review findings are closed, and prove every acceptance criterion on head and on base. Your verdict decides whether the story goes to the blind AC auditor.

## Candidate
- Worktree: `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901a-agent-definitions`, branch `feat/86bcm901a-agent-definitions`.
- HEAD `9c13e02c1e6b111d6b33bd415371ac53c025d81b`. BASE `1ee7157f5dfeb24ddf2df7e3bb5363833385d50d` (= `git merge-base HEAD origin/main`).
- Before you start, check that HEAD is `9c13e02` and `git status --porcelain --ignored` is empty. If either is not, stop and report it.

## Read first
- The approved plan, read-only: `~/.hermes/plans/leorna/evidence/86bcm901a/plan-approved.md`. It holds the ACs, each AC's named test and command, and "Justin's answers (2026-10-28)". Never edit it.
- **The rules for your AC work:** `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`. Follow it exactly: the run recipe on head and base, the Go base-copy rules (copy only the test files the AC test needs), the screenshot recipe for the WSL desktop, and the `ac.json` format. The format is also at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`.
- The reviews whose findings you confirm are closed:
  - `~/.hermes/plans/leorna/evidence/86bcm901a/reviews/review-1-0ab7e6f.md`: R1-1 to R1-5 and R1-7 fixed; R1-6 and R1-8 FYI.
  - `~/.hermes/plans/leorna/evidence/86bcm901a/reviews/review-2-6ae5218.md`: R2-1 and R2-3 fixed; R2-2 left because no test can kill that mutant while no agent is adapted.

## Acceptance criteria (from the plan; use the plan's exact test names and commands)
- AC1: the 4 upstream agents are in the library with their source commit recorded. Test `TestAC1_TheFourUpstreamAgentsAreInTheLibraryWithSourceCommit` (`./internal/library`).
- AC2: each overlapping demo agent has a replace/keep/merge decision recorded. Test `TestAC2_EachOverlappingDemoAgentHasAReplaceKeepOrMergeDecision`.
- AC3: each agent renders for every tool that supports agents and is skipped with a reason where unsupported. Test `TestAC3_EachAgentRendersWhereSupportedAndIsSkippedWithAReasonElsewhere` (`./cmd/library-gate`).
- AC4: each agent passes the content quality gate. Test `TestAC4_EachAgentPassesTheContentQualityGate`, with `LEORNA_TEST_GITLEAKS_BIN=/usr/local/bin/gitleaks`. A skip is a reject.
- AC5 (live): one live run per agent in Claude Code. Only Justin can run it, so report it as `"accepted": false, "not_run": "live: …"`. Still check that the kit at `~/.hermes/plans/leorna/evidence/86bcm901a/ac5-live/` matches head: compare `agents.sha256` against the bodies at `9c13e02`.

## Skills (load with the Skill tool and say so in your first steps)
`leorna` (VERIFIER role; do its Step 1 context load), `engineering-best-practices`, `adversarial-verification-loop`, `mutation-testing-discipline` (for checking the clauses each AC test exercises).

## What to do
1. **Gates on head**, the canonical set, run by you in a `git archive` snapshot or a detached copy of HEAD under your cache folder (not in the worktree, because `make check` writes there):
   - **Commands:**
     - `make check` with `LEORNA_TEST_DATABASE_URL`;
     - `bash ./scripts/test-module-add.sh`;
     - the Postgres tests, read per test from a `go test -json` stream (only the 2 ClickHouse subtests of `TestTeamsAPIWithPostgres` may skip);
     - `make library-check`.
   - **Tool versions:** check that make resolves golangci-lint 2.14.0 and govulncheck v1.7.0 (CI's pins), binding them through the Make variables.
   - **Branch checks:**
     - the content lock only gains lines;
     - no `.github/` changes;
     - every commit by `Justin Issa <justin@leorna.com>`, with no AI attribution lines;
     - no tracked `CLAUDE.md`;
     - `delivery/stories.json` valid, using `python3 -B`.
   - **Flaky test:** `TestSetupWizardWithPostgres` can time out under parallel load. If it fails, run it alone and rerun it, and log both.
2. **Every AC on head and on base**, using the recipe in `ac-verification.md`:
   - **Logs:** `ac<n>-9c13e02.log` and `ac<n>-base-1ee7157.log`.
   - **Base failure:** the base copy must fail for a real reason (its own fail line, or a build failure of the new code), not `[setup failed]`.
   - **Clause check:** for any AC clause the test seems not to exercise, use a `go test -overlay` mutant to confirm the AC test catches it.
3. **One screenshot per AC**, a terminal capture of its head run rendered with Chrome for Testing as `ac-verification.md` describes. Open every PNG and make sure no password, token or DB URL is visible.
4. **Review findings:** confirm each fixed finding is fixed on head, with one line of evidence each.
5. **Write `verifier/ac.json`**, then self-check it while staying blind, exactly as `ac-verification.md` says: `cp` (not `ln`) your report, logs and images to a scratch folder outside the evidence tree, run `ac-check.sh` with your report as both reports, then delete the copy.

## Where things go
- **Your evidence folder:** `~/.hermes/plans/leorna/evidence/86bcm901a/verifier/`. Create it, and write only there. Every receipt your `ac.json` cites must be inside it.
  - Don't read or copy anything from other roles' evidence files except the two review reports and the plan copy.
  - There must never be an `auditor/` folder you read or write.
- **Postgres:**
  - Reuse the running `leorna-test-pg`; never stop or recreate it.
  - Read its port with `docker port leorna-test-pg 5432` (55432 here, **not** 5432; 5432 is `leorna-pg`, which you never touch).
  - Use only your own `leorna_86bcm901a_verifier_test` and `leorna_86bcm901a_verifier_base_test` DBs, and drop them at the end. Never print the URL or password.
- **Toolchain:** task-local `PATH=$HOME/.local/leorna-toolchain/go/bin:$HOME/.local/leorna-toolchain/bin:$PATH`. Never change the global PATH.
- **Temporary space:** `/tmp` is a small tmpfs shared by every session.
  - `TMPDIR`, snapshots, detached copies and big caches go in `~/.cache/86bcm901a-verifier/` (`mkdir`, no `-p`).
  - Small scratch goes in `/tmp/claude-1000/-home-justin-Leorna/6a5cb64a-ef1e-4913-b9a6-0011ebf1675e/scratchpad/86bcm901a-verifier/` (`mkdir`, no `-p`).
  - Remove both at the end, and only those. Any `git worktree add` copy must be removed with `git worktree remove --force`.
- **Waiting:** wait for long commands in the foreground (a bounded `node -e` poll on the log; foreground `sleep` is refused). Ending your turn to wait counts as finishing.

## Boundaries
- Never touch other stories' worktrees, branches, DBs or evidence folders: 86bcm901b, 86bcm901j, 86bcm901w or any other.
- Never push, open a PR, post to ClickUp, or write to Justin's real `~/.claude` or `~/.codex`. Don't run Claude Code for AC5.
- At the end, HEAD must still be `9c13e02` and `git status --porcelain --ignored` empty.

## Rules for every role
- If you find any other bug or problem along the way, don't fix it or fold it in. List it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer: list only what a future task needs that the skill doesn't already say.

## Report (final message)
- `verdict`: `clean` only when every AC except AC5 is accepted on `9c13e02`, every gate exits 0, and every fixed finding is confirmed fixed. Otherwise `not_clean`, with each reason.
- `ac_status[]`: per AC, accepted / not accepted / not_run (live), with its test, head log, base log and screenshot paths.
- Every gate with its exit code and log path. The review-finding closure list.
- The last line of your blind self-check of `ac-check.sh`.
- `found_else[]` and `skill_lessons[]`.
- End with `MAIN SESSION: check and save these skill_lessons now.`
