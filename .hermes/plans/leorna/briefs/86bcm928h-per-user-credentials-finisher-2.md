# FINISHER brief, round 2 (refresh the hand-over after bring-main): Leorna story 86bcm928h-per-user-credentials

**Role:** FINISHER. You are a fresh agent: Opus 5.5, effort high.

Every rule in the round-1 finisher brief applies to you too: `~/.hermes/plans/leorna/briefs/86bcm928h-per-user-credentials-finisher.md`. Read it first. It covers:
- the hand-over steps 1–7 and the skills
- don't move the accepted head
- the rules and the return schema

It is overridden only where this file says something different.

**Justin's standing instruction:** hand-over only. **No push, no PR, no ClickUp post** until he says, and never merge. Under the `leorna` rule, the ClickUp evidence is posted only once the PR is merged.

## State now
- **Accepted head:** `0af447184c884a7e6d74efb4fb98909143e8d2d3`. If HEAD differs, stop and report it.
- **Base:** `a7839b3af664efcfa59eb1ed3fe276ec1262a4de` = GitHub main = `git merge-base HEAD origin/main`.
- **Commits since the round-1 hand-over (1f98596):**
  - Main was brought in with merge a608c1d. It added #30 (managed config drift), #31 (predefined integration tiles) and #32 (agent items install).
  - The story's SQLite migration is now **10**, because main's 9 is `managed_drift_queue`.
  - 9b35bbb: main's renamed generated constant.
  - 0af4471: the unknown-version test now uses a real database (R4-1).
- **`ac-check.sh --reviews` on 0af4471:**
  `READY FOR THE USER: 7 of 8 ACs proven on 0af4471; live ACs owed to the user: AC8`
  `REVIEWS  CLEAN: review-5 at 0af4471 is clean`
- **Evidence:** `~/.hermes/plans/leorna/evidence/86bcm928h/`
  - The new proofs are `verifier/` and `auditor/`, both on 0af4471.
  - The earlier `verifier-1f98596/` and `auditor-1f98596/` are kept for the record. Don't use their images.
  - Reviews `review-4/` and `review-5/`; fixer records `bring-main-3/`, `fixer-4-report.md`, `fixer-4/`.
  - Gate logs `gates-9b35bbb.txt` and `gates-0af4471.txt`, plus the verifier's `verifier/gates/`.
  - `follow-ups.md`, which now also holds R4-2 and R5-1.

## What to redo
Rewrite each round-1 draft for head 0af4471. Overwrite the same paths:
- `~/.hermes/cache/scratch/leorna-pr-86bcm928h-per-user-credentials.md`
- `leorna-review-prompt-86bcm928h-per-user-credentials.md`
- `leorna-clickup-86bcm928h.md`
- `leorna-team-message-86bcm928h.md`

Read each old draft first, then replace every 1f98596-era fact.

1. **Stop and show** on 0af4471:
   - the diff stat against origin/main (three dots)
   - `.github/` empty
   - authors only Justin Issa <justin@leorna.com>, with no AI lines
   - the gates, citing `verifier/gates/` and `gates-0af4471.txt` with each log's recorded exit code

   The verifier's first `make check` exited 2 under heavy load: main's 1 s timing test `TestSyncEngineCancellationAfterSuccessPersistsPartialAndReturnsCause`. Its rerun exited 0. Say so plainly.
2. **Integration check, read-only:**
   - Re-fetch GitHub main using the `leorna` step 7.1 command, with the URL written out, and record its SHA. If main has moved past a7839b3, say so and stop at the report: don't merge.
   - Run `git merge-tree` against open PR #29 (check `FETCH_HEAD` equals `headRefOid`).
   - Run it against each unmerged local `feat/` branch, as the `leorna` skill's hand-over says.
3. **PR text:**
   - **Test Plan:** say main was brought in at a7839b3 (merge a608c1d), and on which head the gates and AC tests ran.
   - **Migration notes:**
     - the story's migration is 10, after main's 9 (`managed_drift_queue`);
     - a dev database from the story's pre-renumber build won't open and must be deleted (R4-2). No released client has it.
   - **Assumptions:** keep the round-1 items (the absolute-`.exe` launch replacing the plan's PowerShell route; the tool install locations covered and not covered; the P3 follow-ups). Add R4-2 and R5-1. Note that the plan copy still describes the PowerShell route and the 8→9 migration, and that no AC wording is affected.
4. **ClickUp evidence draft:**
   - Use one image per AC from `auditor/` or `verifier/` on 0af4471.
   - **No banner on evidence images** (Justin, 2026-11-10). Open every image you list and check it shows the result only: no explanatory label, header or caption, no "rendering", test or helper names in a banner, "stub bridge", head SHAs, "elided" or redaction notes.
   - Also check there's no server domain or URL, tenant ID, token, email or git credential target.
   - If an image fails, don't fix it: list it as a finding and pick the other folder's image for that AC.
   - Draft only; **don't upload**. Mark the comment "post after the PR is merged".
5. **Team message:** marked "send after merge".
6. **`PROJECT_MEMORY.md` line:** redraft it for 0af4471 (it is still not committed; it goes in at "make a PR").
7. **Records:** update the dated 86bcm928h status line in `leorna-workflow.md` (in `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/`):
   - branch, head 0af4471, main a7839b3 brought in, not pushed, no PR
   - READY FOR THE USER with AC8 owed
   - the follow-ups path

   Set the frontmatter `modified:`. The "never edit skills or memory" rule in `skill_lessons` covers skills and lessons only: this one dated story-status line is yours to write. Make no other memory edits.

## Return
Same schema as round 1, with `head_sha` 0af4471. End with `MAIN SESSION: check and save these skill_lessons now.`
