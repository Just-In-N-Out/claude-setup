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
- **Running:** fix 4, covering the `..` URL escape in the LeornaAI fallback and `$TMPDIR` as a temp folder. Brief: `briefs/harness-guards-fixer-4.md`.
- **Next:**
  1. **Reviewer 3:** fresh, on every story change since review 2's head `7b30f16`, i.e. fix rounds 2–4 including the rebase resolution. Loop review → fix until no P0–P2.
  2. Verifier → blind auditor → `ac-check.sh`.
  3. **Finisher:**
     - rebase onto local `main`; if HEAD changes, verifier → auditor → `ac-check` again;
     - `--ff-only` merge into `~/.claude-setup.git` `main`;
     - activation as the plan says (settings.json hooks live; global `core.hooksPath` on this desktop);
     - `sync.sh` push.
  4. **After the merge:**
     - append `evidence/harness-guards/enforce-proposals-pending.md` to `enforce-backlog.md`, then delete it;
     - save the held lesson about `TMPDIR` vs the githooks temp skip, depending on fix 4's choice;
     - tell Justin AC21 (desktop) and AC22 (Mac) are his.
- **Syncs are held until the merge,** so `main` doesn't move under the verified head. Push everything at the finish.
