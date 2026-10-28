# FIXER 2 — leorna-control-plane, story 86bcm901a "Curate agent definitions"

Role: FIXER 2, a fresh agent. Act on reviewer 2's findings: check each one yourself, fix the valid ones, and push back with evidence on any you find wrong. Then re-run the gates and stop at `ready-for-review`. Don't redesign, and don't reopen Justin's decisions.

## Candidate
- Worktree: `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901a-agent-definitions`, branch `feat/86bcm901a-agent-definitions`.
- Reviewed HEAD `6ae52182e946e0812054044f704ea870ef461145`; BASE `1ee7157f5dfeb24ddf2df7e3bb5363833385d50d`.
- Before you start, check that HEAD is `6ae5218` and the tree is clean. If not, stop and report it.

## Read first
- Reviewer 2's report: `~/.hermes/plans/leorna/evidence/86bcm901a/reviews/review-2-6ae5218.md`.
- The approved plan, read-only: `~/.hermes/plans/leorna/evidence/86bcm901a/plan-approved.md`, including "Justin's answers (2026-10-28)". Don't edit it or its copy.
- For context only: review 1 (`reviews/review-1-0ab7e6f.md`) and the "Fixer 1" section of `~/.hermes/plans/leorna/evidence/86bcm901a/README.md`.

## Skills (load with the Skill tool and say so in your first steps)
`leorna` (FIXER role; do its Step 1 context load), `engineering-best-practices`, `receiving-code-review`, `test-driven-development`, `git-commit-rules`. Add `mutation-testing-discipline` if you take on R2-2.

## Findings to act on
- **R2-1 (low, actionable):** wording only, in `internal/library/curation/curation.json`.
  - Check each claim against the agent bodies before you reword it:
    - **test-writer reason (`:619`):** upstream test-engineer does run a new bug test, but only to confirm it fails (`items/agent/test-engineer/body.md:33-35`). What it never says is to run its tests until they pass.
    - **code-reviewer note (`:551`) and decision (`:613`):** upstream asks for a fix only on Critical and Required findings (`items/agent/code-reviewer/body.md:93`, template lines 74-78). It asks for file:line on every finding.
  - Reword those lines so each claim is exactly true. The decisions themselves stay as they are.
  - `curation.json` is outside the embedded `content/`, so there's no version bump and no lock change.
  - Leave `example.md` alone: changing it would change the unreleased 2.0.0 checksum for a nit.
  - Confirm that the curation and AC2 tests and `./internal/library/...` still pass.
- **R2-2 (nit, optional):** in `internal/library/curation_test.go:162`, the `orphanDiffs` call site isn't pinned by a test. It fails safe: the loss shows up as a loud orphan failure, not a silent pass.
  - Change it only if a test can really kill the "pass `nil`" mutant, proven with `go test -overlay` or a scratch copy (never by editing production or test code in place to try it).
  - Otherwise leave it, and say why in one line.
  - Keep any change small: sibling stories may also edit `curation_test.go`.
- **R2-3 (nit):**
  - Add `TestAnAdaptedAgentsDiffIsNotAnOrphan` to the Curated agents "Verification" list in `internal/library/README.md` (around `:502`).
  - In the evidence kit `~/.hermes/plans/leorna/evidence/86bcm901a/ac5-live/CHECKLIST.md` (not the repo), make the source head reference correct for your new head. Reviewer 2 checked by sha256 that the bodies are the same at `6ae5218`; re-check them against your head and keep `agents.sha256` matching.
  - Add the one-line how-to for expanding an agent's block in Claude Code. Check the actual key in Claude Code's docs or `--help` before you write it; if you can't confirm it, leave the fallback prompt as the only instruction.

## Gates after the fixes (the same canonical set as fixer 1)
- **Toolchain:**
  - Use a task-local `PATH=$HOME/.local/leorna-toolchain/go/bin:$HOME/.local/leorna-toolchain/bin:$PATH`. Never change the global PATH.
  - Check that make resolves golangci-lint 2.14.0 and govulncheck v1.7.0 (CI's pins), binding them through the Make variables.
- **Postgres:**
  - Reuse the running `leorna-test-pg`; never stop or recreate it.
  - Read its port with `docker port leorna-test-pg 5432` (55432 here, **not** 5432; 5432 is `leorna-pg`, which you never touch).
  - Use only your own `leorna_86bcm901a_fixer2_test` DB, and drop it at the end. Never print the URL or password.
- **Temporary space:** `/tmp` is a small tmpfs shared by every session.
  - Put `TMPDIR` and big caches in `~/.cache/86bcm901a-fixer2/` (`mkdir`, no `-p`), and remove it at the end.
  - Small scratch goes in `/tmp/claude-1000/-home-justin-Leorna/6a5cb64a-ef1e-4913-b9a6-0011ebf1675e/scratchpad/86bcm901a-fixer2/` (`mkdir`, no `-p`); remove only that.
- **Run on the new head:**
  - `make check` with `LEORNA_TEST_DATABASE_URL`;
  - `bash ./scripts/test-module-add.sh`;
  - the Postgres tests, read per test from a `go test -json` stream (only the 2 ClickHouse subtests of `TestTeamsAPIWithPostgres` may skip);
  - `make library-check`;
  - AC1–AC4, with AC4's `LEORNA_TEST_GITLEAKS_BIN=/usr/local/bin/gitleaks`;
  - the branch checks (lock append-only, no `.github/` changes, authors, no AI lines, no `CLAUDE.md`, `stories.json` valid).
- Log everything to `$EV/gates-<head7>/` and `$EV/gates-<head7>.txt`.
- **Flaky test:** `TestSetupWizardWithPostgres` can time out under load. If it fails, run it alone and rerun it, and log both.
- Use `python3 -B` for any unittest run.
- The tree must be committed and clean at the end (`git status --porcelain --ignored` empty).

## Boundaries
- Work only in this story's worktree and branch. Never check out another branch in the main checkout.
- Never touch other stories' worktrees, branches, DBs or evidence folders: 86bcm901b, 86bcm901j, 86bcm901w or any other.
- Never push, open a PR, post to ClickUp, or write to Justin's real `~/.claude` or `~/.codex`. Don't run Claude Code for AC5.
- **Commits:**
  - Use plain `git commit -m "…"` with the repo's identity (`Justin Issa <justin@leorna.com>`), following the branch's message style (`docs(86bcm901a): … (review 2 R2-1)`).
  - No `-c user.*`, no `--author`, and no `Co-Authored-By` or any AI attribution line.
  - Never commit `CLAUDE.md`.
  - The content lock stays append-only. No `.github/` changes.
- If a fix would change behaviour, a test's meaning, an AC or a decision, stop and report it instead.
- `$EV` = `~/.hermes/plans/leorna/evidence/86bcm901a/`. Add a short "Fixer 2" section to `$EV/README.md`. No secrets, passwords or URLs in any receipt.
- Wait for long commands in the foreground (a bounded `node -e` poll on the log; foreground `sleep` is refused). Ending your turn to wait counts as finishing.

## Rules for every role
- If you find any other bug or problem along the way, don't fix it or fold it in. List it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer: list only what a future task needs that the skill doesn't already say.

## Report (final message)
- Status: `ready-for-review`, or `stopped` and why.
- The new HEAD SHA, the commit list since `6ae5218`, and `git diff --stat 6ae5218..HEAD`.
- Per finding: fixed (with file:line and the test result) / pushed back (with evidence) / left (with the reason).
- Every gate with its exit code and log path. Every AC test's head result.
- `found_else[]` and `skill_lessons[]`.
- End with `MAIN SESSION: check and save these skill_lessons now.`
