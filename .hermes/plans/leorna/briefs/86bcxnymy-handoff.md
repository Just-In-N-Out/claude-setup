# 86bcxnymy handoff (main session, 2026-11-11)

Story: [Client self-update to the admin-approved version, with staged rollout](https://app.clickup.com/t/86bcxnymy), pipeline **Full**, approved plan `~/.hermes/plans/leorna/evidence/86bcxnymy-client-self-update/plan-approved.md` (go given in advance with every ⭐; answers in `briefs/86bcxnymy-justin-answers.md` and at the end of the plan).

## State now: both halves reviewed clean, verifier not yet dispatched

- **Control plane:** `~/Leorna/leorna-control-plane/.claude/worktrees/86bcxnymy-client-self-update`, branch `feat/86bcxnymy-client-self-update`, head `54c8f1a` (13 commits on base `4ef14ef`). Reviews: round 1 (Fable) → fix 1 → round 2 → fix 2 → round 3 (ASK JUSTIN, he said "Fix", `control-plane/review-3/justin.json`) → fix 3 → round 4 clean, `review-check.sh` MOVE ON.
- **Client:** `~/Leorna/leorna-client/.claude/worktrees/86bcxnymy-client-self-update`, branch `feat/86bcxnymy-client-self-update`, head `76ed828` (20 commits on base `a7839b3`). Reviews: round 1 (Fable) → fix 1 → round 2 (full) clean, MOVE ON.
- Follow-ups (deferred P3s plus an AC8 checklist note): `evidence/86bcxnymy-client-self-update/follow-ups.md`.
- Nothing pushed, no PR, nothing posted.

## Next steps

1. Dispatch the **verifier** (Opus 5.5 high, `general-purpose`): brief `briefs/86bcxnymy-client-self-update-verifier-1.md` (ready).
2. Clean → the blind **AC auditor** (Opus 5.5 xhigh): give it only the approved plan copy, the client worktree, head `76ed828`, base `a7839b3`, the control-plane head `54c8f1a` (to build its binary for the end-to-end ACs) and its own folder `<evidence>/auditor/`; never the verifier's folder or report, the reviews or the builders' summaries.
3. Then: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh --repo ~/Leorna/leorna-client/.claude/worktrees/86bcxnymy-client-self-update --base a7839b3af664efcfa59eb1ed3fe276ec1262a4de --plan <evidence>/plan-approved.md --reviews <evidence> <evidence>/verifier/ac.json <evidence>/auditor/ac.json`, plus `review-check.sh` on `<evidence>/control-plane` still MOVE ON at the control-plane head. Expect `READY FOR THE USER` (AC8 live).
4. Finisher (Opus 5.5 high): the `leorna` hand-over for both repos (two PR texts, the R1-8 migration rollback note in the control-plane PR, review prompt, ClickUp evidence draft, team message); never push or post. AC8 owed to Justin.

## Open questions for Justin

- A separate small job for the Go 1.27.4 toolchain bump (GO-2026-6859 turns `make audit` red on both repos' main). Asked several times; no answer yet.
- Found in another story: 86bcm928e's commit `27ca94f` trips gitleaks 12 times (logged in `~/.hermes/plans/leorna/found-else.md`).
