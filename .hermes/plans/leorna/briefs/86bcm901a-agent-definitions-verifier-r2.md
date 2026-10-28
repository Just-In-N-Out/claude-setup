# VERIFIER (round 2) — leorna-control-plane, story 86bcm901a "Curate agent definitions"

Role: VERIFIER, a fresh agent. You never saw the build, the reviews, the fixes or the merge.

**The source is read-only:** never edit, commit, stage, stash or reset anything in the worktree.

Your job:
- re-run the gates;
- check that bringing main in kept both stories' meaning;
- prove every acceptance criterion on head and on base.

Your verdict decides whether the story goes to the blind AC auditor.

## Candidate
- Worktree: `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901a-agent-definitions`, branch `feat/86bcm901a-agent-definitions`.
- **HEAD `55abda3d8d7d188692ff1032280d826d9e2be641`. BASE `db3406eaa72dbf07dcb9c0ca2c828a4377db74e2`**, which equals `git merge-base HEAD origin/main` and is GitHub main: the merge of PR #95, 86bcm901b prompts.
- Before you start, check that HEAD is `55abda3`, `git status --porcelain --ignored` is empty, and the merge base is `db3406e`. If any of these fails, stop and report it.
- History, for context:
  - The story's 11 commits ended at `9c13e02`, which round 1 accepted.
  - `6ae305e` merged `origin/main` (`db3406e`) in, resolving conflicts in `cmd/library-upstream/main.go`, `delivery/stories.json`, `internal/library/README.md`, `internal/library/curation.go`, `internal/library/curation/curation.json` and `internal/library/upstream/importer.go`, and set library 0.7.0, because 901b shipped 0.6.0.
  - `55abda3` records PR #97 in `delivery/stories.json`.

## Read first
- The approved plan, read-only: `~/.hermes/plans/leorna/evidence/86bcm901a/plan-approved.md`. It holds the ACs, each AC's named test and command, and "Justin's answers (2026-10-28)". Never edit it.
  - The plan's older lines say library 0.6.0, but its line ~1102 says a later merger takes the next minor. 0.7.0 is that case.
- **The rules for your AC work:** `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`. Follow it exactly:
  - the run recipe on head and on base;
  - the Go base-copy rules: copy in only the test files the AC test needs;
  - the WSL screenshot recipe;
  - the `ac.json` format, which is also at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`;
  - the blind self-check.
- The merge resolution recipe, which you may read: `~/.hermes/plans/leorna/evidence/86bcm901a/hand-over/merge-notes.md` (the 901b section).

## Acceptance criteria (from the plan; use the plan's exact test names and commands)
- **AC1:** the 4 upstream agents are in the library with their source commit recorded. Test `TestAC1_TheFourUpstreamAgentsAreInTheLibraryWithSourceCommit` (`./internal/library`).
- **AC2:** each overlapping demo agent has a replace/keep/merge decision recorded. Test `TestAC2_EachOverlappingDemoAgentHasAReplaceKeepOrMergeDecision`.
- **AC3:** each agent renders for every tool that supports agents, and is skipped with a reason where unsupported. Test `TestAC3_EachAgentRendersWhereSupportedAndIsSkippedWithAReasonElsewhere` (`./cmd/library-gate`).
- **AC4:** each agent passes the content quality gate. Test `TestAC4_EachAgentPassesTheContentQualityGate`, with `LEORNA_TEST_GITLEAKS_BIN=/usr/local/bin/gitleaks`. A skip counts as a reject.
- **AC5 (live):** one live run per agent in Claude Code.
  - Justin accepted it on 2026-10-28 at `9c13e02`: `~/.hermes/plans/leorna/evidence/86bcm901a/ac5-live/ACCEPTED.md` and `run-agent/RESULT.md`.
  - Report it as `"accepted": false, "not_run": "live: accepted by Justin on 9c13e02; agent bodies byte-identical at 55abda3"`, but only after you prove the four `internal/library/content/items/agent/*/body.md` at `55abda3` match `ac5-live/agents.sha256` (hash `git show 55abda3:<path>`).
  - If they don't match, say so plainly: Justin's acceptance would no longer carry.

## Skills (load with the Skill tool and say so in your first steps)
`leorna` (VERIFIER role; do its Step 1 context load), `engineering-best-practices`, `adversarial-verification-loop`, `mutation-testing-discipline`.

## What to do
1. **Gates on head**, in a detached copy of HEAD under your cache folder, never in the worktree:
   - `make check` with `LEORNA_TEST_DATABASE_URL`;
   - `bash ./scripts/test-module-add.sh`;
   - the Postgres tests, read per test from a `go test -json` stream over the whole DB packages (`./internal/cloud/dbcheck ./internal/store/postgres ./internal/web`). Fail any skip whose reason names `LEORNA_TEST_DATABASE_URL`;
   - `make library-check`;
   - check that make resolves golangci-lint 2.14.0 and govulncheck v1.7.0, bound through the Make variables;
   - branch checks:
     - `content.lock.json` keeps every line from main and from `9c13e02`, unchanged;
     - no `.github/` changes;
     - every commit in `db3406e..HEAD` is by `Justin Issa <justin@leorna.com>` with no AI attribution lines;
     - no tracked `CLAUDE.md`;
     - `delivery/stories.json` is valid, main's entries are unchanged by value, this story's entry is last and lists PR 97, and `python3 -B -m unittest discover -s scripts -p 'test_story_shippable.py'` passes.

   `TestSetupWizardWithPostgres` can time out under load. If it fails, run it alone and rerun it; log both runs.
2. **The merge kept both stories' meaning.** For each of the 6 conflicted files, check that both 86bcm901a's and 86bcm901b's changes are present and correct:
   - the `--version` and `--requires` flags and their `ImportOptions` fields both work;
   - `curation.json` has main's `skills`, plus this story's `agents`/`demoAgents` and 901b's `prompts`, by value;
   - the README keeps both sections;
   - library 0.7.0 is consistent.

   Also run 901b's own AC tests on head and confirm they pass: `TestAC1_NineUpstreamCommandsArePromptItemsWithSourceCommit`, `TestAC2_EachPromptRendersAsANativeCommandOrIsSkippedWithAReason`, `TestAC3_EachPromptFlagsTheSkillsItInvokesAsDependencies`, `TestAC4_EveryPromptPassesTheContentQualityGate`.
3. **Every AC on head and on base `db3406e`**, using the recipe in `ac-verification.md`:
   - write logs `ac<n>-55abda3.log` and `ac<n>-base-db3406e.log`;
   - the base copy must fail for a real reason: its own fail line, or a build failure of the new code. Never accept `[setup failed]`.
   - For any AC clause the test seems not to exercise, confirm the test catches it:
     - for code, with a `go test -overlay` mutant;
     - for data the test reads at run time, by editing your own detached copy and resetting between mutants.
4. **One screenshot per AC:** a terminal capture of its head run, rendered with Chrome for Testing as `ac-verification.md` says, under `env -u DISPLAY -u WAYLAND_DISPLAY`.
   - Open every PNG.
   - Also grep each PNG's text source for emails, URLs, tokens and passwords before citing it.
5. **Write `verifier/ac.json`**, then self-check it blind, as `ac-verification.md` says:
   - `cp` (not `ln`) your report, logs and images to a scratch folder outside the evidence tree;
   - run `ac-check.sh --base db3406e…` with your report as both reports;
   - then delete the copy.

## Where things go
- **Your evidence folder:** `~/.hermes/plans/leorna/evidence/86bcm901a/verifier/`. Create it, and write only there. Every receipt your `ac.json` cites must be inside it.
  - The only other files you may read in the evidence tree: `plan-approved.md`, `hand-over/merge-notes.md`, `ac5-live/agents.sha256`, `ac5-live/ACCEPTED.md` and `ac5-live/run-agent/RESULT.md`.
  - Never read or write `auditor/` or `round1-9c13e02/`.
- **Postgres:**
  - Reuse `leorna-test-pg` and read its port with `docker port leorna-test-pg 5432`. Never touch `leorna-pg`.
  - Use only your own `leorna_86bcm901a_verifier2_test` and `leorna_86bcm901a_verifier2_base_test` DBs, and drop them at the end.
  - Never print a URL or password.
- **Toolchain:** task-local `PATH=$HOME/.local/leorna-toolchain/go/bin:$HOME/.local/leorna-toolchain/bin:$PATH`.
- **Disk:** `/tmp` is a small shared tmpfs.
  - Put `TMPDIR`, detached copies and caches in `~/.cache/86bcm901a-verifier2/` (`mkdir`, no `-p`).
  - Small scratch goes in `/tmp/claude-1000/-home-justin-Leorna/6a5cb64a-ef1e-4913-b9a6-0011ebf1675e/scratchpad/86bcm901a-verifier2/` (`mkdir`, no `-p`).
  - Remove both at the end. Remove `git worktree add` copies with `git worktree remove --force`.
- **Waiting:** a foreground Bash call is moved to the background after 180 s, so split long waits into polls under 170 s each (a bounded `node -e` loop re-reading the log). Ending your turn to wait counts as finishing.

## Boundaries
- Never touch other stories' worktrees, branches, DBs or evidence.
- Never push, open or edit a PR, post to ClickUp, or write to Justin's real `~/.claude` or `~/.codex`. Don't run Claude Code.
- At the end, HEAD is still `55abda3` and `git status --porcelain --ignored` is empty.

## Rules for every role
- If you find any other bug or problem, don't fix it or fold it in. List it in `found_else`, one line each, with evidence and severity.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer: list only what a future task needs that the skill doesn't already say.

## Report (final message)
- `verdict`: `clean` only when AC1–AC4 are accepted on `55abda3`, AC5's agent bodies match, every gate exits 0, and the merge keeps both stories' meaning. Otherwise `not_clean`, with each reason.
- `ac_status[]`: per AC, its status, test, head log, base log and screenshot paths.
- Every gate with its exit code and log path.
- The merge check per file, with 901b's AC results.
- The last line of your blind self-check.
- `found_else[]` and `skill_lessons[]`.
- End with `MAIN SESSION: check and save these skill_lessons now.`
