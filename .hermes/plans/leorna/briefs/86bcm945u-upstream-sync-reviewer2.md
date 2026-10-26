# REVIEWER 2 brief (review only): Leorna story 86bcm945u "upstream-sync" (Full pipeline)

Dispatched 2026-10-24. Model: Opus 5.5, effort xhigh. A fresh agent that has never seen this code or build. Second of two full reviews (`review-fix-cadence`: review 1 → fixer 1 → **review 2 of the corrected code (you)** → fixer 2 → verifier → blind AC audit).

## Your role

You are the second independent **REVIEWER** for ClickUp card `86bcm945u`, "Upstream content sync + licence attribution". You review the **whole corrected story**, not only the fixes. **Report only:** change no source, make no commit, push nothing. Restore anything you touch. Leave the builder's worktree exactly as you found it: committed and clean, no untracked files (a later script fails on any).

## Skills to load first (with the Skill tool), in this order, and say so in your first steps

1. `leorna` (its review rules and hard rules).
2. `engineering-best-practices`.
3. `requesting-code-review` and `code-review-practice`. **Skip** `requesting-code-review`'s "independent reviewer subagent" and auto-fix steps: you *are* the fresh reviewer, and you can't spawn agents.
4. `mutation-testing-discipline` (your mutation checks).
5. `security-best-practices` (third-party content read from the network; git subprocesses; an HTML admin page) and `multi-tenant-auth-management` (the admin-only page).

## What to review

- Repo: `~/Leorna/leorna-control-plane`, branch `feat/86bcm945u-upstream-sync`
- Worktree: `/Users/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm945u-upstream-sync`
- **Base** `6e74ced843642439d1dac9f25673440fb0f285f5` (merge-base with origin/main). **Head** `bc23303a93231de1995a75417d4cb1696750cc2a`. 19 commits.
- Review 1 covered `6e74ced..9e31271`. Fixer 1 then added 4 commits, `9e31271..bc23303`: 9 files, +402/−23.
- Review **the whole story, `git diff 6e74ced..bc23303`**, against:
  - the approved plan `~/.hermes/plans/leorna/evidence/86bcm945u/plan-approved.md` (read-only; ACs AC1–AC7, Justin's answers, tasks, Gates, Definition of Done);
  - the `leorna` skill's rules and the repo's `AGENTS.md`.
- Then look closely at the fix delta `9e31271..bc23303`:
  - confirm each review-1 finding is really closed;
  - look for regressions the fixes caused;
  - judge fixer 1's rulings.
- **Run the gates yourself and try mutations. Don't trust summaries**, including review 1's and fixer 1's. Do your runs in your own detached worktree at head (e.g. `git -C ~/Leorna/leorna-control-plane worktree add --detach ~/.hermes/cache/scratch/86bcm945u-review2/head bc23303`), with your own Postgres database whose name ends in `_test`. Remove that worktree when you're done. Never share or drop another agent's database.
- Gates: `make check` (bind CI's golangci-lint version by absolute path, as the `leorna` skill says), `bash ./scripts/test-module-add.sh`, and each AC's own command from the plan, including AC2 with `LEORNA_TEST_DATABASE_URL` and AC7 with `LEORNA_TEST_UPSTREAM_NETWORK=1` (a skipped AC test counts as not run).

### Inputs from the first round

- Review 1's full report: `~/.hermes/plans/leorna/evidence/86bcm945u/review1/review1.md`, with probes and mutations in `review1/`. Don't re-report a finding that is now closed. Re-open one only with new evidence.
- Fixer 1's receipts: `~/.hermes/plans/leorna/evidence/86bcm945u/fix1/` (RED/GREEN logs, `mutations-fix1.txt`) and the "Fix 1" section of `INVENTORY.md`.
- Review 1's findings and fixer 1's dispositions:
  - **F1 (minor):** the clone deadline didn't hold (`exec.CommandContext` without `WaitDelay`). Fixed in 22e2703 with `command.WaitDelay = gitWaitDelay` (2 s) and test `TestCloneStopsAtItsDeadlineWhenTheServerStalls`.
  - **F2 (minor):** no test for the lock-immutability guard (`importer.go`). Tests added in 1deb75a: `TestAcceptNeverOverwritesARecordedVersion` and `TestImportNeverOverwritesARecordedVersion`. Code unchanged.
  - **F3 (minor):** untested guards: the other-upstream refusal in `accept`, the GIT_DIR / repository-location env scrub, and the 50,000-entry tree cap. Tests added in 1deb75a: `TestAcceptRefusesAnItemFromAnotherUpstream`, `TestGitIgnoresRepositoryLocationVariables` and `TestParseTreeCapsEntries`. Code unchanged.
  - **F4 (nit):** the upstream frontmatter `name` was echoed with `%s`. Fixed in 3eecae7 with `%q` and test `TestTransformQuotesTheUpstreamName`.
  - **F5 (nit):** NEXT STEP suggested an `accept` that `accept` refuses. Fixed in bc23303: `importableKind` returns the step with its refusal. Tests `TestDiffNeverSuggestsAStepTheToolRefuses` and `TestNextStepForAMultiFileRootIsNotAnAccept`.
  - **F6 (nit, evidence):** the author email was in the evidence. Redacted in `INVENTORY.md`, with an upload copy `gates-9e31271-acs-and-checks-redacted.txt`; the original is kept as the receipt. No commit.

### Rulings to judge

**Fixer 1's rulings** ("My ruling, not yet confirmed"):
1. The wait bound is 2 s. The orphaned `git-remote-https` helper isn't killed (no process-group kill, which would need platform-specific code). The error reads "signal: killed:" with no "timed out" wording.
2. The F1 test fails rather than skips if git never reaches the stalled server, and it forces `NO_PROXY=*` and `GIT_CONFIG_GLOBAL=/dev/null`.
3. The F5 fix goes beyond the tracked-skill case: added multi-file skills, skill folders with no SKILL.md, and prompts are all marked "not importable". This narrows the plan's "untracked, added → available to import" row to the shapes import accepts.
4. `runGit`'s stderr echo is unchanged. A probe showed git 2.50 masks control characters in its own fatal messages; sideband `remote:` lines were not probed.
5. Only the four variables that can change a bare-clone read have test cases (GIT_DIR, GIT_COMMON_DIR, GIT_OBJECT_DIRECTORY, GIT_NAMESPACE). The others are scrubbed but documented as equivalent.
6. `plan-approved.md` still contains the email but isn't an upload candidate. Two gate scripts in `fix1/` contain a test-database URL and are marked not for upload.

**The builder's rulings** (review 1 agreed with all of them; re-open one only with new evidence):
1. `Transform(kind, name, raw)` signature.
2. AC2's main screenshot is the built binary in dev mode on 127.0.0.1 via `/dev/login`.
3. Extra `ac2/ac3/ac4-test-run.png` captures.
4. Path quoting plus the git env scrub.
5. `accept` refuses multi-file roots and other-upstream items; one diff row per tracked item.
6. How symlink skipping is tested.
7. The AC3/AC4 demos build the tool from head.
8. `write.go` wasn't written test-first, but mutation M8-v2 kills its containment test.

### Look hard at

- **Untrusted upstream:** git invocation, path and name guards, symlinks, caps, refusing unknown formats; whether the F1 change opens anything new (e.g. an orphaned helper process or a leaked file descriptor).
- **Never overwriting Leorna adaptations:** `diff` / `import` / `accept`, version bump, `content.lock.json`, checksum stability (the 8 shipped checksums unchanged).
- **The admin page:** admin-only (member → 403, signed out → sign-in), escaping, no data from other tenants.
- **Notices and installer:** `THIRD_PARTY_NOTICES.md` equals the embedded record; the Windows launcher carries the notice; `--notices` works.
- **Tests:** each AC test is real, named as the plan says, fails on base and passes on head. Happy path plus at least one failure case per the Definition of Done. The new guard tests kill their mutations, and nothing is a blind test.
- **Evidence:** the folder `~/.hermes/plans/leorna/evidence/86bcm945u/` should have one screenshot per AC (see `INVENTORY.md`). The screenshots were taken on 9e31271; fixer 1 says none of their outputs changed. Check that claim, check the redaction, and check that no upload candidate shows a server domain, a real host in a URL bar, a tenant ID, a token, an email or a password. Don't edit these files.
- **Scope:** no `.github/` change, no OpenAPI change, no migration, nothing outside the plan's files unless a ruling explains it.

### Already known (don't re-report as new)

- Missing server Go-module licences in `THIRD_PARTY_NOTICES.md`.
- Library items copied into tenant packs lose source and licence.
- The card's typos (`scripts/skill-lint.js`, `v0.6.13`).
- The installer version picking up a `portal-dist-*` tag (`scripts/dist.sh`).
- `cmd/launcher/README.md` not mentioning `--notices`.
- govulncheck's "1 vulnerability in modules you require, but your code doesn't appear to call these", also on base.

Mark one only if this story made it worse.

## Where you write

Only in `~/.hermes/plans/leorna/evidence/86bcm945u/review2/` (logs, mutation receipts, your report as `review2.md`) and your scratch folder. Nothing in the repo.

## Rules

- Write nothing to ClickUp, push nothing, touch no server. Never put a server domain, URL, tenant ID or token in your report.
- **Other problems outside this story:** list each in `found_else` (one line, evidence, severity), not as findings.
- **Skill lessons:** if you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer.

## What to return

- `verdict`: `clean` or `findings`
- `findings[{id, severity: critical|major|minor|nit, introduced: true|false, claim, evidence (file:line, command and output)}]`
- `review1_closure[{id: F1..F6, closed: true|false, evidence}]`
- `ac_status[{ac, accepted: true|false, test, screenshot, evidence}]` for AC1–AC7 on head bc23303
- `rulings[{who: fixer1|builder, n, verdict: agree|disagree, why}]`
- `defect_loop_skills[]`, `found_else[]`, `skill_lessons[]`

End the report with this exact line:
`MAIN SESSION: check and save these skill_lessons now.`
