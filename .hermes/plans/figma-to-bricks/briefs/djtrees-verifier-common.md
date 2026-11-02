# DJ Trees batch: the VERIFIER after a fix (no second review) — rules for every job

Justin's chain: one review; a fixer fixes its P0–P2; then **one verification** checks the fixed head (no second
review). You are the verifier half of that verification (a blind AC auditor runs beside you). You never saw the build,
the review or the fix being made. Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md` first
(Chrome wrapper, fonts, scratch, the snap stall).

## Your copy

Your own worktree (`isolation: worktree`): `git checkout --detach <head sha>`. No commits. Write only `E/verifier/`
(fresh: the round-1 reviewer's report from the old head was moved to `E/verifier-review1-<sha>/`) and your scratch
(`~/.cache/<job>-verifier/`).

## Skills

Project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (VERIFIER role),
`engineering-best-practices`, `mutation-testing-discipline`.

## The work (`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` step 1)

1. **Re-run the gates** on head: `npm run check` (compare by test name with base: no new failures, no new skips) and
   the job's real-file checks the plan names.
2. **Confirm the review's P0–P2 is closed**: read `E/review-1/review.json` (the finding) and `E/fixer/` (the fixer's
   claim), then check it yourself on head with your own probe (the fix's new test fails on the pre-fix head and passes
   on head; the scenario no longer happens). Also check the fix didn't break anything the plan promises.
3. **The AC work**: for every AC in `E/plan-approved.md`, run its named test on head (log `HEAD=` first, `EXIT=`
   last), run it on base in a separate scratch copy with head's test files (must fail there, or `base_exempt` with a
   reason), take your own screenshot; `(live)` ACs `not_run: live`. Write `E/verifier/ac.json` (format at the top of
   `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`).
4. **Self-check**: `ac-check.sh --repo <the fixer's worktree> --base <base> --plan E/plan-approved.md
   E/verifier/ac.json <scratch copy>/ac.json` (format only; delete the copy).

## Return

`verdict` (`clean`: every non-live AC accepted and the finding closed | `not clean` with what fails), `ac_status` (one
line per AC), the finding's status, any new P0–P2 you saw (with file:line and a concrete scenario), the `ac.json`
path, `skill_lessons` (normally `[]`). End with `MAIN SESSION: check and save these skill_lessons now.`
