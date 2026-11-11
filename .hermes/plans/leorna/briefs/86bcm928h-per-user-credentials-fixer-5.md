# FIXER brief, round 5 (bring main in after the Go 1.27.4 bump): Leorna story 86bcm928h-per-user-credentials

**Role:** FIXER. Bring the new GitHub main into the story branch. You are a fresh agent: Opus 5.5, effort high.

Every rule in the round-1 fixer brief applies to you too: `~/.hermes/plans/leorna/briefs/86bcm928h-per-user-credentials-fixer-1.md`. Read it first. Its gate list is the one in `~/.hermes/plans/leorna/briefs/86bcm928h-per-user-credentials-fixer-3.md` step 6. It is overridden only where this file says something different.

Also read these before you start:
- `~/.claude/skills/leorna/references/repeat-mistakes.md`
- `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md`

## State
- **Worktree:** `/home/justin/Leorna/leorna-client/.claude/worktrees/86bcm928h-per-user-credentials`
- **Branch:** `feat/86bcm928h-per-user-credentials`
- **Head:** `40abddbb3bef5659de72cefb67076026e73dee94`. This is pushed, and it is PR #33's head. If HEAD differs, stop and report it.
- **Old main:** `a7839b3`, already merged into the branch.
- **New GitHub main:** `3f4bad7`, the merge of PR #34. Its one change is `go.mod` `toolchain go1.27.3` → `go1.27.4`, for GO-2026-6859 (net/http).
  - Because of that advisory, #33's "Go quality gates" fails at `make audit`.
  - Re-running #33's CI would test the old merge ref, so main has to be brought in.
  - Re-fetch main first. If it has moved past 3f4bad7, use the newer SHA and say what else came in.
- **TMPDIR:** `~/.cache/86bcm928h-fixer-5/tmp`
- **Toolchain:** Go **1.27.4** from `~/.local/leorna-toolchain/go1.27.4/bin`, first on a task-local PATH, with `GOTOOLCHAIN=local`. Echo `go version`. Also golangci-lint 2.14.0 and govulncheck v1.7.0 from `~/.local/leorna-tools`.

## The work
1. **Merge main:** run `git merge origin/main`, with the message `merge: bring main (<sha7>) into feat/86bcm928h-per-user-credentials`.
   - It should merge with no conflicts.
   - Prove the merge is honest in one line: `git merge-tree --write-tree 40abddb <main>` must equal `HEAD^{tree}`.
   - List the files the merge brought in.
   - If there is any conflict, stop and report it. Don't resolve it.
2. **Gates on the new head**, using Go 1.27.4. Run every gate from fixer-3 step 6:
   - `make check`
   - the UI tests
   - `make lint audit`, which must now pass with "No vulnerabilities found"
   - gitleaks over `origin/main..HEAD`
   - `GOOS=windows go vet` with Zig cgo
   - the native Windows `./login` and `./application` tests with `LEORNA_TEST_SECURE_STORE=1`, one binary at a time, test credentials only, with 0 "Leorna Client" entries in `cmdkey /list` afterwards
   - authors and AI-attribution checks
   - `.github/` diff empty

   Then run every AC1–AC7 test by name.

   A 1 s timing test from main, `TestSyncEngineCancellationAfterSuccessPersistsPartialAndReturnsCause`, can fail under heavy load. Rerun it alone before you judge it.

   Write `~/.hermes/plans/leorna/evidence/86bcm928h/gates-<sha7>.txt`, recording each gate's exit code.
3. **Don't push.** A fresh review of the merge comes first, and the main session pushes it after that.
4. **AC8:** Justin said not to mention it in anything that goes out. Leave it out of your gate log and anything you write for the PR. Your `ac_status` covers AC1–AC7 only.

## Return
Same schema as round 1, with `status: ready-for-next-review` or `blocked`. Also include:
- `merge_commit`, `new_head`, `main_sha`
- `merge_proof` (the two tree ids)
- `files_from_main[]`
- `gates[{name, exit, log}]`
- `ac_tests[{ac, test, exit}]`

End with `MAIN SESSION: check and save these skill_lessons now.`
