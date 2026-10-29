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
- **Review 6: CLEAN.** The referee said MOVE ON at `aba3093`.
- **Plan amendments:** 1 (AC2/AC7 round-1 line) and 2 (12 ACs reconciled with their tests). The old approved copy is `evidence/review-loop/plan-approved-v0-at-go.md`; the amended one is installed as `plan-approved.md` (09:55).
- **Verifier 1: CLEAN** (17/17 non-live; self-check READY FOR THE USER). **Auditor: CLEAN.** `ac-check` on `aba3093` gives READY FOR THE USER 17/18 both live and with the worktree's `--reviews` (REVIEWS CLEAN).
- **Finisher step 1 done:** head `aae49fd`, base `c40a51c`. Two conflicts were resolved keeping both sides (CLAUDE.md "Every brief", `ac-verification.md` steps 1–2). All gates are green.
- **Review 7: CLEAN.** The referee says MOVE ON at `aae49fd` (`--base c40a51c`).
- **Verifier 2: CLEAN** at `aae49fd` (17/17). **Running:** auditor 2 (`briefs/review-loop-auditor-2.md`) → `ac-check` (live + `--reviews`, `--base` = `merge-base`) → finisher 1b: base-only rebase onto the moved `main` (Q10 A, if it touches no story file) → merge right away → sync. Earlier: `main` changed 4 story files (CLAUDE.md, feature-dispatch `SKILL.md`, `ac-verification.md`, leorna `SKILL.md`), so base-only won't hold. Conflict resolutions need a delta review (the referee says "not a pure rebase"), then verifier → auditor → `ac-check` again.
- **DON'T EDIT story files until merged:** CLAUDE.md, feature-dispatch `SKILL.md` and `references/*`, leorna, `review-fix-cadence`, the Codex tomls, `MEMORY.md`. Hold lesson saves for those files.
- **Next:**
  1. auditor (blind; brief from harness-guards-auditor-2 adapted);
  2. `ac-check` live: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh --repo ~/.claude-setup-wt/review-loop --base <base> --plan evidence/review-loop/plan-approved.md evidence/review-loop/verifier/ac.json evidence/review-loop/auditor/ac.json`;
  3. the worktree's `ac-check.sh` with `--reviews evidence/review-loop` too;
  4. finisher: base-only rebase (Q10 A), then merge, then sync.
- **After the merge:** delete the live memory note `review-loop-until-clean.md` (the merge does it) and update `MEMORY.md`'s index line.
