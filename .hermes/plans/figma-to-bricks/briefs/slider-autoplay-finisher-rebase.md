# FINISHER — slider-autoplay, prepare local integration only

This role starts only after the orchestrator's ac-check returns ALL ACCEPTED or READY FOR THE USER. Do only the
worktree portion of the finish. The orchestrator will record the accepted HEAD/base and verdict below.

## Skills and inputs
Load `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its rules summary,
`engineering-best-practices`, and `git-commit-rules`; use `systematic-debugging` for unexpected failures and
`test-driven-development` for any necessary code correction. You cannot start agents.

- Worktree `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/slider-autoplay`, branch worktree-slider-autoplay.
- Main folder `/home/justin/Documents/FigmaToBricksV2`, local integration branch main.
- Approved AC1–AC14: `/home/justin/.hermes/plans/figma-to-bricks/evidence/slider-autoplay/plan-approved.md`.
- Amendments and rulings in `docs/plans/2026-10-26-slider-autoplay.md`. Interval is delay plus speed; AC14 expects
  5800/800. AC13 and AC14 remain live paste check 3bm.
- Ledger `.superpowers/sdd/2026-10-26-slider-autoplay/progress.md`, notes `docs/HANDOFF.md`.
- Your evidence only: `/home/justin/.hermes/plans/figma-to-bricks/evidence/slider-autoplay/finisher-rebase/`.

## Do exactly
1. Check clean committed worktree, correct branch, git identity and current local main. Confirm no other finisher
   owns an unfinished main release before using it as a base. You are not alone in the repository: preserve every
   other session's changes, never revert them, and never touch headline-marker or photo-hotspots worktrees/evidence.
2. Commit any feature-owned remaining records by file, if needed, then `git rebase main` against local main only.
   Keep both meanings on conflicts, especially all HANDOFF and plan entries and additive shared-stage changes.
   Do not fetch/pull/push; do not change main. If code corrections are needed, preserve failure evidence and prove
   them test-first. Report material new behavior to the orchestrator for independent verification.
3. On rebased HEAD run `npm run check`, `npm run corpus`, corpus-backed tests in your own scratch git-archive
   trees with corpus.json pointed at local corpus/files, and the whole browser suite compared by test name with
   the pinned current integration base. Also run the entire carousel browser file with zero skips. Use
   `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Preserve complete logs, exact runtime, exit
   status and EXIT= end markers. Distinguish inherited font/environment failures from introduced failures.
4. Keep the branch committed and clean. Record the actual new HEAD and merge-base, exact main used, gates and
   any changed rulings. Stop here; the orchestrator re-verifies and blind-audits a changed HEAD before merging.

Never bump BUILD, move the ledger, edit main-folder files, edit CLAUDE.md, merge, push, stash, or delete the
worktree. Do not edit skills/memory. Do not add AI trailers or override authorship. Check staged paths before
every commit: CLAUDE.md and user debug JSON are never staged.

Make fresh own scratch `/tmp/slider-autoplay-finisher-rebase-XXXXXX`; never reuse/extract into another's directory.
Send concise progress at meaningful checkpoints.

## Report
Return `{status: ready-for-integration|stopped, head, base, main_used, summary, conflicts[], gates,
rulings[], live_acs:["AC13","AC14"], skill_lessons[{skill,lesson,evidence}]}`. Empty lessons are normal.
End with `MAIN SESSION: check and save these skill_lessons now.`
