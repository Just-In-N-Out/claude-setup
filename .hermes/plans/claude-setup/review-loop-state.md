# Where review-loop stands (resume note for the main session)

Updated 2026-10-29 ~03:45. Justin is asleep. He said "approve either way"; the plan is pre-approved with every ⭐ option.

## The pipeline (Full; its own new rule applies)
- Review → fix repeats until a fresh review has no P0–P2 (brakes in the memory note `review-loop-until-clean.md`). Then verifier → blind auditor → `ac-check.sh`.
- Merge: Q10 A, so reuse harness-guards' base-only rule (range-diff all `=`, `main`'s new commits touch no story file, gates pass).

## Status
- **Done:** the plan `review-loop.md` (18 ACs; AC18 is live on the Mac; AC11 and AC17 run only when named), and the approved copy `evidence/review-loop/plan-approved.md`.
- **Running:** the builder (`briefs/review-loop-builder.md`), worktree `~/.claude-setup-wt/review-loop`.
- **Next:**
  1. reviewer 1 (full);
  2. the fix/review loop with delta reviews;
  3. verifier, then auditor, then `ac-check.sh`;
  4. finisher: rebase with the base-only checks, then the `--ff-only` merge, then `sync.sh`.

  Peer sessions edit feature-dispatch, ac-verification, CLAUDE.md and leorna, so expect rebase conflicts.
- **After the merge:** delete the live memory note `review-loop-until-clean.md` (the merge does it) and update `MEMORY.md`'s index line.
