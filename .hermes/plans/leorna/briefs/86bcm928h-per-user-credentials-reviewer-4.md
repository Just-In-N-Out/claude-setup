# REVIEWER brief, round 4 (bring-main delta): Leorna story 86bcm928h-per-user-credentials

**Role:** a fresh, independent REVIEWER, **report only**. Opus 5.5, effort high. You never saw the build, the earlier reviews, the fixes or the merge.

Every rule in the round-1 brief applies to you too: `~/.hermes/plans/leorna/briefs/86bcm928h-per-user-credentials-reviewer-1.md`. Read it first. It covers:
- the story summary, skills and security focus
- the sandbox and tool rules
- earlyoom and long waits
- Justin's severity scale
- found_else, skill_lessons and the return schema

It is overridden only where this file says something different.

## What's different in round 4
- **Write only into** `~/.hermes/plans/leorna/evidence/86bcm928h/review-4/`. The scratch folder is `~/.cache/86bcm928h-review-4/`, removed at the end.
- **Scope: a delta covering the bring-main merge and its fix.**
  - `from` is the last reviewed head, `1f985964ba53c8f6fe91a93a8e9ed7bd30c072a2`, which review-3 found clean.
  - `head` is `9b35bbbfb6b798d1729fd203c37d56cd4a070d56`.
  - The commits:
    - `a608c1d`, "merge: bring main (a7839b3) into feat/86bcm928h-per-user-credentials"
    - `9b35bbb`, "fix(86bcm928h): use main's renamed IntegrationSignInTools constant…"
  - Main `a7839b3` added three merged PRs: #30 (managed config drift), #31 (predefined integration tiles) and #32 (agent items install).
  - If HEAD has moved past 9b35bbb, stop and report it.
- **The fixer's account** is in `~/.hermes/plans/leorna/evidence/86bcm928h/bring-main-3/` (logs) and `gates-9b35bbb.txt`. Treat it as a claim to check, not as proof.
- **What to check** (`leorna` skill, Doing a story → step 7, the bring-in checks):
  1. **The merge is honest.**
     - Every file changed on one side only equals that side's blob.
     - The set of files whose merged content differs from both parents equals the both-sides set.
     - A both-sides file that equals `git merge-file -p` is git's clean result. Read only the hand-resolved files: `application/application.go`, `application/application_test.go`, `scripts/sync-ui.test.cjs`.
     - Check that the story's own patch survived, per file, comparing `git diff -U0 7a83443 1f98596` against `git diff -U0 a7839b3 9b35bbb`.
  2. **The SQLite migration renumber.**
     - Main's migration 9 (`managed_drift_queue`) is unchanged.
     - The story's tables are migration 10.
     - Databases at 8 and 9 upgrade, and a fresh database gets both migrations.
     - A version this build doesn't know (11) is refused.
     - Is there any real path where a database got the story's old 9? The branch was never pushed and no tag contains it.
  3. **Semantic clashes with no text conflict.** Check each of these against main's new code:
     - `application/sync.go`: the Sync hook order, and the integration-needs save next to main's `finish`, agent guard and removal changes.
     - `desktop/bridge.go`: drift processing after `engine.Run`, and Logout's `ForgetCompany` next to restore.
     - The frontend `dist/` files (`index.html`, `style.css`, `sync.js`, `integrations.js`): IDs, CSS and event order.
     - The generated-API rename in 9b35bbb. Are there other removed or renamed generated identifiers the story uses? Grep the `-` names in `git diff 7a83443 a7839b3 -- '*.gen.go'`.
  4. **The story's security properties through main's new entry points.**
     - Drift check and reports, restore preview and apply, and agent-items Sync must never write, store, log or send the credential or its value. Paths and hashes only.
     - Run the story's no-secret checks through those entry points, with main as the control.
  5. **Stale wording.** Grep the tracked tree for `86bcm928h`, `86bcryh0w`, `86bcm9284` and `86bctmuwy` next to until/once/later.
- **Two trees per probe:** where you probe behaviour, run it on `1f98596` and on `9b35bbb`, with `a7839b3` (main) as the control. That separates what the merge caused from what was already there.
- **review.json:**
  - Its shape: `{"round": 4, "scope": "delta", "from": "1f985964ba53c8f6fe91a93a8e9ed7bd30c072a2", "head": "9b35bbbfb6b798d1729fd203c37d56cd4a070d56", "findings": [...]}`, with ids `R4-<k>`.
  - Self-check it with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo /home/justin/Leorna/leorna-client/.claude/worktrees/86bcm928h-per-user-credentials --base a7839b3af664efcfa59eb1ed3fe276ec1262a4de ~/.hermes/plans/leorna/evidence/86bcm928h`.
  - Exit 2 means your file is wrong, so fix it.
- **Earlyoom check:** `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'`.

## Return
Same schema as round 1: `{verdict, findings[], ac_status[], found_else[], skill_lessons[]}`. AC8 (live) is `not_run`. End with `MAIN SESSION: check and save these skill_lessons now.`
