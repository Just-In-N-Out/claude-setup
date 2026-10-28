# FIXER 1 — leorna-control-plane, story 86bcm901a "Curate agent definitions"

Role: FIXER 1, a fresh agent. Act on reviewer 1's findings: check each one yourself, fix the valid ones test-first, push back with evidence on any you find wrong, then stop at `ready-for-review`. Don't redesign, and don't reopen Justin's decisions.

## Candidate
- Worktree: `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901a-agent-definitions`, branch `feat/86bcm901a-agent-definitions`.
- Reviewed HEAD `0ab7e6f6fa19f0be5f3bd8a8457575b03541d320`; BASE `1ee7157f5dfeb24ddf2df7e3bb5363833385d50d`.
- Before you start, check that HEAD is `0ab7e6f` and the tree is clean. If not, stop and report it.

## Read first
- Reviewer 1's report: `~/.hermes/plans/leorna/evidence/86bcm901a/reviews/review-1-0ab7e6f.md` (file:line, evidence and recommended fixes for each finding).
- The approved plan, read-only: `~/.hermes/plans/leorna/evidence/86bcm901a/plan-approved.md`, including "Justin's answers (2026-10-28)":
  - A a: upstream code-reviewer replaces ours as 2.0.0.
  - B a: test-writer is retired and test-engineer supersedes it.
  - C a: the AC5 sample project.
  - D a: the toolchain.
  Don't edit the plan or its copy.

## Skills (load with the Skill tool and say so in your first steps)
`leorna` (FIXER role; do its Step 1 context load), `engineering-best-practices`, `receiving-code-review`, `test-driven-development`, `mutation-testing-discipline` (R1-1 is about mutants that survived), `git-commit-rules`.

## Findings to act on
- **R1-1 (medium):** the `--version` guard's "above **every** recorded version" check and its number-by-number comparison are untested.
  - Add the subtest the reviewer describes: a fixture lock holding `agent/reviewer@1.9.0` and `@1.10.0`. Then `1.9.5` is refused ("not above …@1.10.0", tree unchanged), and `1.10.1` or `2.0.0` is accepted with every old entry unchanged.
  - Then prove it kills both of the reviewer's mutants, using `go test -overlay` only (never edit production code to test it): "compare with the first only" and "string compare instead of `versionAbove`".
  - Keep the receipts as `$EV/mutation-R1-1-*.txt`.
- **R1-2 (low):** the T8 test (`internal/store/postgres/library_agents_test.go`) seeds invented demo rows.
  - Build the demo items from their real published content, and assert each `Checksum()` equals the content lock's values.
  - Then record T8 again: RED on a detached BASE copy holding only that test file (it must fail for the real reason, not because of an invented fixture), and GREEN on head, both as `go test -json` streams. Name the logs `$EV/t8-fix1-base-1ee7157.*` and `$EV/t8-fix1-<head7>.*`.
- **R1-3 (low):** an adapted agent could never pass both curation tests, because the 9019 orphan loop rejects `diffs/agent-<name>.diff`.
  - Make the orphan check also count `record.Agents` adaptation diffs as referenced, as the smallest change.
  - Add a test that fails before the change: a fixture with one adapted agent and its diff.
  - Note that sibling stories 86bcm901b (prompts) and 86bcm901j (MCP) may change the same orphan loop for their own kinds. Keep the change small and self-contained so the finisher can merge it, and name the file in your report.
- **R1-4 (low):** wording only, in the `curation.json` demo decision reasons.
  - Name the dropped step in each reason: code-reviewer's "run git diff and read the changed files in full", and test-writer's "run the tests and iterate until they pass for the right reason", which test-engineer doesn't carry over.
  - Fix the counts ("two points" / "two lines").
  - Change "could not edit files" to "had no Edit or Write tool".
  - The decisions stay as they are. `curation.json` doesn't ship, so there's no version bump; confirm the curation and AC2 tests still pass.
- **R1-5 (low):** the AC5 kit, `~/.hermes/plans/leorna/evidence/86bcm901a/ac5-live/CHECKLIST.md` (evidence, not repo).
  - Tell Justin to deny any `npx` or `npm` command and allow file writes only inside `sample-project/`, and explain why: a real Lighthouse run would fill in the scorecard and contradict step 6's "not measured" pass rule.
  - Tell him to read each agent's report as written: expand the agent block, or end each prompt with "show its report exactly as written".
  - Note that "Build verified: no" is expected, because `go` isn't on his normal PATH.
  - Keep it short and plain. Re-check `agents.sha256` still matches if anything there changes.
- **R1-7 (nit, do it if trivial):** add `item.Key()` to the AC3 tripwire message (`cmd/library-gate/agents_test.go:95`).
  - That file is the AC3 test's package. After changing it, rerun AC3 on head and on BASE (the base must still fail its own way).
  - Save the logs as `$EV/ac3-fix1-<head7>.log` and `$EV/ac3-fix1-base-1ee7157.log`.
- **R1-6 (FYI): no change.** Accepting `--version` for a name never published matches the approved plan.
- **R1-8 (FYI): no change.** It goes to the hand-over.
- **found_else nit:** for every `python3 -m unittest` run, use `python3 -B` so no `scripts/__pycache__/` lands in the tree. Delete the existing gitignored `scripts/__pycache__/` in this story's worktree only.

## Gates after the fixes (the same canonical set as the builder's T13)
- Toolchain: task-local `PATH=$HOME/.local/leorna-toolchain/go/bin:$HOME/.local/leorna-toolchain/bin:$PATH`. Check that make resolves golangci-lint 2.14.0 and govulncheck v1.7.0 (CI's pins); bind them through the Make variables if needed. Never change the global PATH.
- Postgres:
  - Reuse the running `leorna-test-pg` container; never stop or recreate it.
  - Read its port with `docker port leorna-test-pg 5432` (55432 here, **not** the plan's 5432; 5432 is `leorna-pg`, which you never touch).
  - Use only your own DBs, `leorna_86bcm901a_fixer1_test` and `leorna_86bcm901a_fixer1_base_test`, and drop them at the end.
  - Never print the URL or password.
- `/tmp` is a small tmpfs shared by every session.
  - Set `TMPDIR`, the detached BASE copies and big caches to `~/.cache/86bcm901a-fixer1/` (`mkdir`, no `-p`), and remove it at the end.
  - Small scratch goes in `/tmp/claude-1000/-home-justin-Leorna/6a5cb64a-ef1e-4913-b9a6-0011ebf1675e/scratchpad/86bcm901a-fixer1/` (`mkdir`, no `-p`); remove only that.
- Run on the new head:
  - `make check` with `LEORNA_TEST_DATABASE_URL`;
  - `bash ./scripts/test-module-add.sh`;
  - the Postgres tests read per test from a `go test -json` stream (only the 2 ClickHouse subtests of `TestTeamsAPIWithPostgres` may skip);
  - `make library-check`;
  - every AC test, AC1–AC4, with AC4's `LEORNA_TEST_GITLEAKS_BIN=/usr/local/bin/gitleaks`.
  Log them to `$EV/gates-<head7>/` and `$EV/gates-<head7>.txt`. `TestSetupWizardWithPostgres` can time out under load: if it fails, run it alone and rerun it, and log both runs.
- The tree must be clean at the end: committed, with no untracked files.

## Boundaries
- Work only in this story's worktree and branch. Never check out another branch in the main checkout.
- Never touch other stories' worktrees, branches, DBs or evidence folders: 86bcm901b, 86bcm901j, 86bcm901w or any other.
- Never push, open a PR, post to ClickUp, or write to Justin's real `~/.claude` or `~/.codex`. Don't run Claude Code for AC5.
- Commits: plain `git commit -m "…"` with the repo's identity (`Justin Issa <justin@leorna.com>`), following the branch's existing message style.
  - No `-c user.*`, no `--author`, and no `Co-Authored-By` or any AI attribution line.
  - Never commit `CLAUDE.md`.
  - The content lock stays append-only.
  - No `.github/` changes.
- If a fix would change behaviour beyond the finding, a test's meaning, an AC or a decision, stop and report it instead.
- `$EV` = `~/.hermes/plans/leorna/evidence/86bcm901a/`. Open every PNG you cite. No secrets, passwords or URLs may be visible.
- Wait for long commands in the foreground (a bounded `node -e` poll on the log; foreground `sleep` is refused). Ending your turn to wait counts as finishing.

## Rules for every role
- If you find any other bug or problem along the way, don't fix it or fold it in. List it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer: list only what a future task needs that the skill doesn't already say.

## Report (final message)
- Status: `ready-for-review`, or `stopped` and why.
- New HEAD SHA; the commit list since `0ab7e6f`; `git diff --stat 0ab7e6f..HEAD`.
- Per finding: fixed (with its RED then GREEN test and the file:line) / pushed back (with evidence) / no change (FYI).
- Every gate with its exit code and log path. Every AC test's head result.
- Mutation receipts for R1-1. T8's RED and GREEN receipts.
- `found_else[]` and `skill_lessons[]`.
- End with `MAIN SESSION: check and save these skill_lessons now.`
