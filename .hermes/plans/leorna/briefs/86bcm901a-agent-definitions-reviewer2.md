# REVIEWER 2 — leorna-control-plane, story 86bcm901a "Curate agent definitions"

Role: REVIEWER 2, a fresh agent that never saw the build or review 1. You do a full, independent code review of the candidate and report. **Report only:** don't edit, commit, stage, stash or reset anything in the worktree. Fixes are a later fixer's job.

## Candidate
- Worktree: `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901a-agent-definitions`, branch `feat/86bcm901a-agent-definitions`.
- HEAD `6ae52182e946e0812054044f704ea870ef461145`, BASE `1ee7157f5dfeb24ddf2df7e3bb5363833385d50d` (= `origin/main` when the branch was made). Review `git diff BASE..HEAD` (review 1 ran on `0ab7e6f`; fixer 1 added 5 commits `0ab7e6f..6ae5218`), and read the surrounding code wherever a change depends on it.
- Before you start, check that HEAD is still `6ae5218` and the tree is clean. If not, stop and report it.

## Read first
- The approved plan, read-only: `~/.hermes/plans/leorna/evidence/86bcm901a/plan-approved.md`, including its "Justin's answers (2026-10-28)" section. Justin approved every ⭐ answer:
  - A a: upstream code-reviewer replaces ours as 2.0.0.
  - B a: test-writer is retired and test-engineer supersedes it.
  - C a: AC5 runs from a sample project's `.claude/agents`.
  - D a: the host toolchain.
  Review against those decisions. Don't reopen them; flag a decision only if the code contradicts it.
- The card's DoD (in the plan): unit + integration tests (happy path + 1 failure), OpenAPI updated if the API is touched, lint/format/CI green (gitleaks + golangci-lint), demoable in isolation, short module README note.

## Acceptance criteria (from the plan)
- AC1: the 4 upstream agents are in the library with their source commit recorded. Test `TestAC1_TheFourUpstreamAgentsAreInTheLibraryWithSourceCommit` (`./internal/library`).
- AC2: each overlapping demo agent has a replace/keep/merge decision recorded. Test `TestAC2_EachOverlappingDemoAgentHasAReplaceKeepOrMergeDecision`.
- AC3: each agent renders for every tool that supports agents and is skipped with a reason where unsupported. Test `TestAC3_EachAgentRendersWhereSupportedAndIsSkippedWithAReasonElsewhere` (`./cmd/library-gate`).
- AC4: each agent passes the content quality gate. Test `TestAC4_EachAgentPassesTheContentQualityGate` (needs `LEORNA_TEST_GITLEAKS_BIN=/usr/local/bin/gitleaks`).
- AC5 (live): one live run per agent in Claude Code. Only Justin can run it, so mark it `not_run` (live) in `ac_status`. Do review the kit at `~/.hermes/plans/leorna/evidence/86bcm901a/ac5-live/` for whether a context-free Justin could follow it.

## Skills (load with the Skill tool and say so in your first steps)
`leorna` (REVIEWER role; do its Step 1 context load), `engineering-best-practices`, `requesting-code-review`, `code-review-practice`, `security-best-practices` (third-party content in the library, importer file and lock writes, secret scanning). Add `backend-data-migrations` if you judge the T8 upgrade path needs it.

## What to look at (beyond your skills' checklists)
- **Correctness:**
  - The `library-upstream import --version` flag and its guard.
  - The content lock: it must stay append-only and immutable.
  - The `curation.json` `agents` / `demoAgents` records.
  - The 0.5.0 → 0.6.0 library version bump.
  - The T8 upgrade test (a library item changed without a version bump).
- **Tests:**
  - Does each AC test really check its AC, and every clause of it?
  - Could it pass with the feature broken?
  - Happy path plus at least one failure case.
  - Mutation receipts: `~/.hermes/plans/leorna/evidence/86bcm901a/mutation-*.txt`.
- **Third-party content:**
  - The 4 agents must match upstream at `aeac41d4d005` byte for byte, as planned.
  - Licence and attribution, THIRD_PARTY_NOTICES, and the source commit recorded.
  - The rendering skip reasons: no tool installs agents at client `f105e27`.
- **The builder's rulings, which you judge:**
  - Review-note wording was corrected where the upstream text didn't support the plan's wording. For example, "report-only" became "instructed to report findings with recommended fixes", and CrUX takes `CRUX_API_KEY` or `GOOGLE_API_KEY`.
  - The demo decision reasons were kept as planned, though they leave some partly implied demo steps unnamed: code-reviewer's "run git diff and read the changed files in full", and test-writer's "run the tests and iterate until they pass for the right reason". Does the recorded decision still hold up?
- **Docs and records:** the README agents section and the `delivery/stories.json` entry.

## Running things (optional; you may rely on reading plus targeted runs)
- Toolchain: task-local `PATH=$HOME/.local/leorna-toolchain/go/bin:$HOME/.local/leorna-toolchain/bin:$PATH` (check what's in that folder first). Never change the global PATH.
- **Postgres:**
  - Reuse the running `leorna-test-pg` container and never stop or recreate it.
  - It listens on the port `docker port leorna-test-pg 5432` prints (55432 here), **not** the plan's 5432. 5432 is `leorna-pg`, which you never touch.
  - Make only your own DB, `leorna_86bcm901a_review2_test`, and drop it afterwards. Never print the URL or password.
- **`/tmp` is a small tmpfs shared by every session:**
  - Set `TMPDIR` and any copies or caches to `~/.cache/86bcm901a-reviewer2/` (make it with `mkdir`, no `-p`).
  - Remove it at the end.
  - Your small scratch goes in `/tmp/claude-1000/-home-justin-Leorna/6a5cb64a-ef1e-4913-b9a6-0011ebf1675e/scratchpad/86bcm901a-reviewer2/` (also `mkdir`, no `-p`). Remove only that.
- Never run tests in a way that leaves files in the worktree.

## Boundaries
- Never touch other stories' worktrees, branches, DBs or evidence folders: 86bcm901b, 86bcm901j, 86bcm901w or any other.
- Never push, open a PR, post to ClickUp, or write to Justin's real `~/.claude` or `~/.codex`. Don't run Claude Code for AC5.
- Write only your report file, `~/.hermes/plans/leorna/evidence/86bcm901a/reviews/review-2-6ae5218.md` (create the `reviews/` folder if it's missing), plus your own scratch folders.

## Rules for every role
- If you find any other bug or problem outside this story's scope, don't fold it in. List it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer: list only what a future task needs that the skill doesn't already say.

## Report (final message, and the same content in your report file)
- `verdict`: `clean` (no actionable findings) or `findings`.
- `findings[]`: each with an id (R2-1…), severity (critical / high / medium / low / nit), file:line, what's wrong, evidence (a command and its output, or a quote), and the recommended fix. Mark each one **actionable** or **FYI**.
- `ac_status[]`: per AC, `{ac, status: met | not_met | not_run, evidence}`. AC5 is `not_run` (live).
- What you ran, with exit codes. The candidate SHA you reviewed.
- `found_else[]` and `skill_lessons[]`.
- End with `MAIN SESSION: check and save these skill_lessons now.`

## Review 1 and fixer 1 (read only after your own full review)
Do your own full review of `BASE..HEAD` first, so your read isn't anchored on review 1's. Then:
- read review 1 (`~/.hermes/plans/leorna/evidence/86bcm901a/reviews/review-1-0ab7e6f.md`);
- read the fixer's commits `0ab7e6f..6ae5218` (R1-1 through R1-5 and R1-7 fixed; R1-6 and R1-8 FYI, left as they are);
- note the AC5 kit's new "Three rules while it runs" section in `ac5-live/CHECKLIST.md`.
For each R1 finding, say whether it's closed, and whether the fix is right and introduced nothing new. Look hardest at:
- the T8 upgrade test (`internal/store/postgres/library_agents_test.go`), rewritten to load the demo agents' real 0.5.0 bytes;
- the orphan-diff change in 9019's `internal/library/curation_test.go`, now calling `orphanDiffs` in `curation_agents_test.go`.
The per-AC screenshots in the evidence folder are still from `0ab7e6f`. That's expected: the verifier retakes them.
