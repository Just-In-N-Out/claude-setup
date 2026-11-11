# VERIFIER brief, round 2 (after bring-main): Leorna story 86bcm928h-per-user-credentials

**Role:** `VERIFIER (read only) for leorna feature "86bcm928h-per-user-credentials"`. You are a fresh agent: Opus 5.5, effort high. You never saw the build, reviews, fixes or merge.

Every rule in the round-1 verifier brief applies to you too: `~/.hermes/plans/leorna/briefs/86bcm928h-per-user-credentials-verifier-1.md`. Read it first. That covers the story summary, skills, gates, the AC work, the Windows rules, tools and environment, earlyoom, long waits, found_else, skill_lessons and the return schema. It is overridden only where this file says something different.

## What's different in round 2
- **Head:** `0af447184c884a7e6d74efb4fb98909143e8d2d3`. If HEAD differs, stop and report it.
- **Base:** `a7839b3af664efcfa59eb1ed3fe276ec1262a4de`. That is GitHub main, which the story merged in (merge a608c1d), and it equals `git merge-base HEAD origin/main`. Main added #30 (managed config drift), #31 (predefined integration tiles) and #32 (agent items install).
  - The base run is a separate detached copy of a7839b3 with head's test files.
  - Each AC test must pass on head and fail on base.
- **Write only into** `~/.hermes/plans/leorna/evidence/86bcm928h/verifier/`, which is a new, empty folder you create.
  - The previous verifier's folder for 1f98596 is `verifier-1f98596/`, kept for the record. Don't copy its screenshots or receipts. Take everything fresh on this head.
  - The scratch folder is `~/.cache/86bcm928h-verifier-2/`, removed at the end.
- **Reviews since the last verifier:**
  - `review-4/` (merge delta). Its R4-1 (P2) was fixed per Justin's `review-4/justin.json`.
  - `review-5/` is clean. The referee printed `MOVE ON: review-5 at 0af4471 is clean`.
  - The fixer reports are `bring-main-3/`, `fixer-4-report.md` and `fixer-4/`.
  - Confirm R4-1 is closed. Look for regressions the merge caused, especially:
    - the SQLite renumber: main's migration 9 is `managed_drift_queue`, and the story's is now 10;
    - the story's no-secret properties through main's new drift, restore and agent-items entry points.
- **Re-run all the gates yourself** on head, as the round-1 brief lists them. Gitleaks runs over `origin/main..HEAD`. It also runs `gitleaks dir` over the 10 both-sides files taken from the merged tree, because `gitleaks git` skips a merge commit's own diff.
- **Screenshots, one per AC, all fresh:**
  - **No banner on evidence images** (Justin, 2026-11-10; `ac-verification.md`). An image shows only the result. Don't put an explanatory label, header or caption on it, such as:
    - "local rendering", "not the app window" or "rendering"
    - test or helper names in a banner, "stub bridge" or "other panels hidden"
    - head SHAs, "elided" or redaction notes
  - Say how an image was made in the `.log` or receipt, never on the image.
  - For a terminal capture, the image shows the command, its output and the `EXIT=` line, and nothing else added.
  - For a UI capture (AC1, AC4, AC7), the image shows the panel only.
- **AC8 (live)** is still owed to Justin: `"accepted": false, "not_run": "live: <why>"`.
- **Earlyoom check:** `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'`. A bare `grep sending` also matches the startup banner.
- **Mutation runs:** quote env assignments (`env "PATH=$PATH" …`). On WSL, an unquoted PATH exits 127, which is not a kill.

## Return
Same schema as round 1. End with `MAIN SESSION: check and save these skill_lessons now.`
