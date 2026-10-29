# Where review-loop stands (resume note for the main session)

Updated 2026-10-29 ~03:45. Justin is asleep. He said "approve either way"; the plan is pre-approved with every ⭐ option.

## The pipeline (Full; its own new rule applies)
- Review → fix repeats until a fresh review has no P0–P2 (brakes in the memory note `review-loop-until-clean.md`). Then verifier → blind auditor → `ac-check.sh`.
- Merge: Q10 A, so reuse harness-guards' base-only rule (range-diff all `=`, `main`'s new commits touch no story file, gates pass).

## Justin away (2026-10-29): "Yo, I'm gonna go, so just keep pushing and doing everything."
- **A later ASK JUSTIN from brake c** (a new finding, not worse than the last round): continue under these words, recorded verbatim in that round's `justin.json` with `continue: true`.
- **Brake d** (the same finding again with no new fact) or anything risky: stop and wait for him.
- **Finish and push** when accepted.

## Status
- **Done:** the plan `review-loop.md` (18 ACs; AC18 is live on the Mac; AC11 and AC17 run only when named), and the approved copy `evidence/review-loop/plan-approved.md`.
- **Builder done:** head `d3f220f`, base `691651c`; all non-live ACs pass; 59 mutants.
- **Review 1:** REVIEW AGAIN (R1-1, P1: bash 3.2 can't parse a heredoc inside `$(…)` in `review-check.sh`).
- **Fixer 1 done:** head `9aca235`.
- **Review 2 (delta):** R2-1, a P2 (the R1-9 fix exits 2 on a true record when sync.sh rewrote the story's base). Real bash 3.2 (Docker `bash:3.2`) confirms R1-1 is fixed.
- **The referee:** `ASK JUSTIN` (brake c). Justin answered "Keep going" on 2026-10-29, recorded in `review-2/justin.json` (`continue: true`); the referee now says REVIEW AGAIN.
- **Fixer 2 done:** head `2fad9c3`.
- **Review 3:** R3-1, a P2 (an off-base full round followed by a clean delta gives MOVE ON). Brake c fired, answered with `continue` under Justin's away words (`review-3/justin.json`).
- **Fixer 3 done:** head `aff26c8` (the off-base rule takes the latest full round; a 33-row table in AC7).
- **Review 4: CLEAN.** The referee said MOVE ON. Its P3s are in follow-ups.
- **Orchestrator slip:** round 2 should have been a FULL round (the rule gives Full two full rounds). Corrected with reviewer 5, a second FULL review of `691651c..aff26c8`.
- **Review 5:** R5-1, a P2 (the referee's round-1 line led to the delta round 2); REVIEW AGAIN.
- **Fixer 4 done:** head `aba3093`.
- **Running in parallel:**
  - reviewer 6, a DELTA review of `aff26c8..aba3093` (`briefs/review-loop-reviewer-6.md`);
  - planner amendment 1 (`briefs/review-loop-planner-amend-1.md`), changing AC2 and AC7 for the round-1 line form.
- **When the amendment returns:**
  - sync it;
  - move `evidence/review-loop/plan-approved.md` aside to `plan-approved-v1-pre-amend1.md`;
  - `install -m 444` the amended plan as `plan-approved.md`. Do this before the verifier.
- **When the referee says MOVE ON:** verifier → auditor → `ac-check` (live, plus the worktree's `--reviews`).
- **If round 4 finds yet another P0–P2 in the same off-base/`from` area:** the loop isn't converging there. Stop and wait for Justin; offer to drop the R1-9 check and keep R1-9 as a follow-up.
- **After the merge:** delete the live memory note `review-loop-until-clean.md` (the merge does it) and update `MEMORY.md`'s index line.
