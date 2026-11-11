# VERIFIER brief, round 3 (PR #33 final head): Leorna story 86bcm928h-per-user-credentials

**Role:** `VERIFIER (read only) for leorna feature "86bcm928h-per-user-credentials"`. You are a fresh agent: Opus 5.5, effort high. You never saw the build, the reviews or the fixes.

Every rule in the round-2 verifier brief applies to you too: `~/.hermes/plans/leorna/briefs/86bcm928h-per-user-credentials-verifier-2.md`. That covers the no-banner images, the earlyoom grep, quoted env and the load note. It in turn points to the round-1 brief: `~/.hermes/plans/leorna/briefs/86bcm928h-per-user-credentials-verifier-1.md`. Read both. Only what this file says differently overrides them.

## What's different in round 3
- **Head:** `eef72c761ad616f50409c1e985e97e039936a772`. It is pushed, and it is PR #33's head. If HEAD differs, stop and report it.
- **Base:** `3f4bad71b3f4cce6b387d167228db167c57c7148`. This is GitHub main, the merge of PR #34, and it equals `git merge-base HEAD origin/main`. Main moved twice since the plan:
  - a7839b3 brought in #30, #31 and #32 (merged at a608c1d, with the SQLite renumber 9→10);
  - 3f4bad7 brought in #34, which changes only `go.mod` toolchain go1.27.3 → go1.27.4, for GO-2026-6859 (merged at eef72c7).
- **Toolchain:** Go **1.27.4** from `~/.local/leorna-toolchain/go1.27.4/bin`, first on a task-local PATH, with `GOTOOLCHAIN=local`. Echo `go version`. Also golangci-lint 2.14.0 and govulncheck v1.7.0 from `~/.local/leorna-tools`.
  - `make audit` must report "No vulnerabilities found".
  - The base copy at 3f4bad7 also uses Go 1.27.4.
- **Write only into** `~/.hermes/plans/leorna/evidence/86bcm928h/verifier/`. It is a new, empty folder you create.
  - Earlier folders are kept for the record: `verifier-1f98596/`, `verifier-0af4471/`, `auditor-1f98596/`, `auditor-0af4471/`. Don't copy from them. Take everything fresh.
  - Scratch goes in `~/.cache/86bcm928h-verifier-3/`, removed at the end.
- **Reviews since the last verifier:**
  - `review-6`: the record commit 40abddb, which changes `PROJECT_MEMORY.md` and removes the README's AC8 row.
  - `review-7`: the conflict-free merge eef72c7.
  - Both are clean. The referee printed `MOVE ON: review-7 at eef72c7 is clean`.
  - Confirm the README and `PROJECT_MEMORY.md` claims against the code.
- **AC8:** Justin said not to mention AC8 in anything that goes out. It stays internal:
  - In `verifier/ac.json`, keep the AC8 row as before, `"accepted": false, "not_run": "live: <why>"`, because `ac-check.sh` reads the plan's AC list.
  - Don't put AC8 on any image.
- **PR #33's CI** is running on eef72c7 now. You don't need to wait for it. Record `gh pr checks 33 -R LeornaAI/leorna-client` at the end, as information.

## Return
Same schema as round 1. End with `MAIN SESSION: check and save these skill_lessons now.`
