# Where harness-guards stands (resume note for the main session)

Updated 2026-10-28, late. Justin is asleep. He said: "keep this running and make sure it implements what we talked about."

## Standing approvals from Justin
1. **harness-guards:** go with every recommended option.
2. **After harness-guards merges and `sync.sh` has pushed to GitHub, build story `review-loop`.** Justin: "push the GitHub and, once that's done, work on what we talked about—make a plan agent and then go for it."
   - It is described at the top of `evidence/harness-guards/follow-ups.md`.
   - Pre-approved: the planner's recommended options apply, and there's no wait for "go".
   - Still list its ACs and `(live)` ACs in the message.
3. **New review rule, from now on** (memory: `~/.claude/projects/-home-justin/memory/review-loop-until-clean.md`):
   - review → fix loops until a fresh review finds no P0–P2 (realistic edge cases count), with the brakes in the memory note;
   - P3s go to the follow-ups;
   - verifier → auditor → `ac-check.sh` runs only after a clean review.

## harness-guards pipeline
- **Done:** build; review 1 → fix 1; review 2 → fix 2; verifier 1 → fix 3 (V1 plus the rebase onto main, new base `3864d61`, head `d82956d`).
- **Fix 4 done:** head `e4469c0`, base `3864d61`. The LeornaAI fallback is a strict one-name URL; `$TMPDIR` counts as a temp folder.
- **Reviewer 3: CLEAN** at `e4469c0`; its P3s are in follow-ups.
- **Verifier 2: CLEAN** at `e4469c0` (`evidence/harness-guards/verifier/ac.json`; its own self-check gave READY FOR THE USER, 20/22).
- **Auditor: CLEAN.** `ac-check.sh` on e4469c0 gave READY FOR THE USER, 20/22 (live AC21 and AC22 owed to Justin).
- **Finisher step 1 done:** rebased onto `80ef3a8`, new head `6b57a5b` (range-diff all `=`, no conflicts, every gate green). `main` had already moved again by then (e2479ef, no story files).
- **Verifier 3 and auditor 2: CLEAN.** `ac-check.sh` on `6b57a5b` (base `80ef3a8`) gave READY FOR THE USER, 20/22 (live AC21 and AC22).
- **Justin chose (A), 2026-10-29 02:59:** a base-only rebase may merge without re-verify when `range-diff` vs `6b57a5b` is all `=`, `main`'s commits since `80ef3a8` touch no story file, and every gate passes on the new head. If any check fails, re-verify fully.
- **MERGED 2026-10-29 ~03:10:** local `main` = `dc5d4f5` (finisher 1b: two base-only rounds, every check passed). The enforce proposals were moved to `enforce-backlog.md`.
- **DONE 2026-10-29 ~03:15.**
  - Global `core.hooksPath` is set on the desktop, and the smoke test passed (CLAUDE.md and AI-trailer commits refused).
  - `sync.sh` pushed; local = GitHub `main` (`d794172`). Codex AGENTS.md was rebuilt.
  - Justin's checks: `harness-guards-your-checks.md`.
- **Next story:** `review-loop`. Planner running (brief `briefs/review-loop-planner.md`, plan `review-loop.md`). Pre-approved, recommended options.
- **Old rounds' folders:** `verifier-round1-dccc042`, `verifier-round2-e4469c0`, `auditor-round1-e4469c0`.
- **Merge blocker (Justin's call):**
  - Peer sessions keep moving `main` (my own synced edits get swept into their syncs too), so `--ff-only` needs yet another rebase, and the rule then needs another re-verify.
  - Ask Justin to pick:
    - (A) a base-only rebase may merge without re-verify when `range-diff` is all `=`, `main`'s new commits touch no story file, and the gates pass. Recommended, because it's mechanical and leaves the other sessions alone.
    - (B) pause the peer sessions' syncs for the merge window.
- **Next:**
  1. Verifier clean → blind auditor (`evidence/harness-guards/auditor/`, given only the plan, worktree, head and base) → `ac-check.sh`. Not clean → fixer → fresh reviewer on the fix → verifier.
  3. **Finisher:**
     - rebase onto local `main`; if HEAD changes, verifier → auditor → `ac-check` again;
     - `--ff-only` merge into `~/.claude-setup.git` `main`;
     - activation as the plan says (settings.json hooks live; global `core.hooksPath` on this desktop);
     - `sync.sh` push.
  4. **After the merge:**
     - append `evidence/harness-guards/enforce-proposals-pending.md` to `enforce-backlog.md`, then delete it;
     - save the held lesson about `TMPDIR` vs the githooks temp skip, depending on fix 4's choice;
     - tell Justin AC21 (desktop) and AC22 (Mac) are his;
     - the finisher may remove the roughly 64 leftover failed-test folders in `~/.cache/harness-guards-tests/` (fix 4's RED/mutant runs, dated after 20:00 on 2026-10-28).
- **Syncs are held until the merge,** so `main` doesn't move under the verified head. Push everything at the finish.
