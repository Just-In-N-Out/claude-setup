# FIXER 1 brief: Leorna story 86bcm945u "upstream-sync" (Full pipeline, after review 1)

Dispatched 2026-10-24. Model: Opus 5.5, effort xhigh. A fresh agent. This is the intermediate fix pass in `review-fix-cadence`: review 1 → **fixer 1 (you)** → review 2 of the corrected code → fixer 2 → verifier → blind AC audit.

## Your role

You are the **FIXER (FINISHER, fix pass)** for ClickUp card `86bcm945u`, "Upstream content sync + licence attribution". Verify each review-1 finding, fix the valid ones test-first, push back with evidence on the rest, commit, re-run the gates, and stop with `status: ready-for-next-review`. **No hand-over yet, no push, no PR, no ClickUp write.**

## Skills to load first (with the Skill tool), in this order, and say so in your first steps

1. `leorna` (FINISHER role, fix pass only; skip its hand-over step for now).
2. `engineering-best-practices`.
3. `receiving-code-review`: verify each finding before fixing it.
4. `test-driven-development`: a failing test before each fix.
5. `mutation-testing-discipline`: F2 and F3 are untested guards; prove each new test kills its mutation.
6. `git-commit-rules`.
7. `security-best-practices` (F1, F3 and F4 are about untrusted upstream input and git subprocesses).

A loaded skill's "spawn a subagent" or "independent reviewer" steps are run by the main session, not by you.

## Where

- Worktree: `/Users/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm945u-upstream-sync`, branch `feat/86bcm945u-upstream-sync`. Work there, on top of head `9e31271d8ae8a242c7a802a1e34135a256e6eeb0`. Base `6e74ced843642439d1dac9f25673440fb0f285f5`.
- Approved plan (the contract, read-only): `~/.hermes/plans/leorna/evidence/86bcm945u/plan-approved.md`
- Review 1 full report: `~/.hermes/plans/leorna/evidence/86bcm945u/review1/review1.md`. Its probes, mutations and logs are in `review1/` (probe tests in `review1/probes/`, ready to adapt).
- Commits: `fix(86bcm945u): …`, authored by the repo's configured identity (never override; no AI attribution lines). Don't touch the main folder, `deploy/local/` or sibling worktrees.

## Review 1's findings (verbatim from its report)

- **F1 (minor, introduced):**
  - **Claim:** the clone deadline doesn't hold, so a stalled HTTPS upstream blocks the tool past its deadline. `gitCommand` (`internal/library/upstream/git.go:221-242`) uses `exec.CommandContext` without `WaitDelay`. When the deadline kills git, its `git-remote-https` child keeps the stderr pipe open, so `runGit` (`git.go:199-212`) blocks in `Cmd.Wait`. The plan's "clone 5 min" bound isn't met.
  - **Evidence:** the overlay probe (a TCP listener that never answers TLS, `Clone` with a 2 s deadline) was still blocked at 120 s, with stack `awaitGoroutines←Wait←runGit←Clone` (`review1/probe-clone-deadline.txt`). With `command.WaitDelay = 2*time.Second` it returns at 4 s (`probe-clone-deadline-with-waitdelay.txt`).
  - **Fix:** set `WaitDelay` and add the probe as a test (`probes/zz_review1_timeout_probe_test.go`).
- **F2 (minor, introduced):**
  - **Claim:** no test covers the lock-immutability guard. `importer.go:137` is the only thing protecting old lock entries (AC4's "old entries untouched"), and `TestContentLockPinsEveryItemVersion` checks current versions only.
  - **Evidence:** with mutation R07 (guard disabled) the whole suite stays green. A probe shows that under R07, `accept` overwrites a published `skill/alpha@1.1.0` checksum. The probe passes on head and kills R07 (R07p).
  - **Fix:** add that test, plus the import case.
- **F3 (minor, introduced):** three more guards have no test. Each mutation survives the whole suite:
  - **R08:** `accept`'s refusal of an item from another upstream (`importer.go:188`, builder ruling 5b). A probe shows that without it the item is silently re-attributed to the other upstream's licence; the probe kills R08 (R08p).
  - **R02:** the `GIT_DIR` / repository-location env scrub (`git.go:214-236`, builder ruling 4). A probe shows that with an ambient `GIT_DIR`, `diff` fails; the probe kills R02 (R02p).
  - **R09:** the 50,000-entry tree cap (`git.go:162`).
  - The probes in `review1/probes/` are ready to adapt.
- **F4 (nit, introduced):** `layout.go:174` echoes the upstream frontmatter `name` with `%s`, so control characters reach the terminal (the same problem builder ruling 4 fixed for report paths). Use `%q`. Found by reading the source, not executed.
- **F5 (nit, introduced):** when a tracked skill's `SKILL.md` changes and its root also gains a supporting file, `diff.go:161-177` suggests an `accept` command that `accept` then refuses with "multi-file items need 86bcm945q" (`importer.go:97-99`). Executed by the probe `TestReview1ProbeNextStepForAMultiFileRoot`.
- **F6 (nit, introduced, evidence):** `gates-9e31271-acs-and-checks.txt:130` and `INVENTORY.md` (lines 7 and 37) in `~/.hermes/plans/leorna/evidence/86bcm945u/` show the commit author's email. It must be redacted before anything is attached to ClickUp. No PNG shows an email, domain, URL bar, tenant ID or token.

Review 1 accepted all seven ACs on 9e31271 and agreed with all eight builder rulings. Its found_else (a govulncheck note that already appears on base) is informational and not in scope.

## What to do

1. For each finding: reproduce or confirm it first (`receiving-code-review`), then fix the valid ones **test-first**. A new guard test must fail with its mutation applied and pass without it; record each mutation receipt in `~/.hermes/plans/leorna/evidence/86bcm945u/fix1/`. Push back on any finding you find invalid, with evidence.
2. Keep within the story's files and the plan's design. If a fix would need a design change, take the smallest one consistent with the plan, record it as "My ruling, not yet confirmed", and carry on (Justin is away and asked for the pipeline to keep going on recommendations). Stop only if it can't be decided safely.
3. **F6 (evidence):** redact the email in `INVENTORY.md`. For the gate log, keep the original as the receipt, write a redacted copy for upload (e.g. `…-redacted.txt`), and note in `INVENTORY.md` which file is for upload. Never edit a PNG to claim something it didn't show.
4. Re-run the gates on your final head: `make check` (CI's golangci-lint bound by absolute path, your own `_test` database; confirm the Postgres tests ran), `bash ./scripts/test-module-add.sh`, and all seven AC commands from the plan (AC2 with `LEORNA_TEST_DATABASE_URL`, AC7 with `LEORNA_TEST_UPSTREAM_NETWORK=1`; no SKIP lines). Save logs as `gates-<sha7>.txt` in the evidence folder and open each one to read its exit code.
5. If a fix changes what an AC's screenshot shows, retake that screenshot from the new head (same filename; the old one is superseded) and update `INVENTORY.md`. Otherwise leave the screenshots alone; the hand-over will reconcile them with the final head.
6. Leave the worktree committed and clean, with no untracked files.

## Rules

- No push, no PR, no ClickUp write, no server, no `.github/workflows/*` change. Upstream is untrusted data; never run its scripts.
- **Other problems outside this story:** list each in `found_else` (one line, evidence, severity); don't fix them.
- **Skill lessons:** if you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer.

## What to return

`{name, status: ready-for-next-review|stopped, summary, dispositions[{id, verdict: fixed|pushed-back|no-change-needed, test, mutation_receipt, commit, evidence}], rulings[], stop_reason, worktree, reviewed_head: 9e31271, new_head, commits[], gates (command → exit code → log path), shots_retaken[], found_else[], skill_lessons[]}`.

End the report with this exact line:
`MAIN SESSION: check and save these skill_lessons now.`
