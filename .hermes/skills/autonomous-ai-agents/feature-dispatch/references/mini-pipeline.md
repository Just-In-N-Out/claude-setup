# Mini pipeline (Justin, 2026-10-22)

The lighter of the two pipelines. Applies to every repo (Leorna, FigmaToBricksV2, any other). Same phases as Full, fewer and faster agents.

## When to recommend Mini

All of these hold:
- a clear bug or a small change
- likely 1-3 source files
- no product/design decision to make
- doesn't touch auth, tenants, permissions, payments, data migrations or API contracts
- no source overlap with a running feature

Otherwise recommend **Full**. Justin's explicit pick always wins.

## Roles (Justin, 2026-11-10: same routing as Full)

| Role | Model | Effort |
|---|---|---|
| Planner | **Fable 5.2** | **high** |
| Builder (implements) | **Opus 5.5** | **xhigh** |
| Reviewer, round 1 (the one full review; separate, fresh, never saw the build) | **Fable 5.2** | **high** |
| Reviewer, later rounds (one per fix round: the fix commits and what they touch) | **Opus 5.5**, a fresh one per round | **high** |
| Fixer (on REVIEW AGAIN, verifier findings or NOT ACCEPTED) | **Opus 5.5**, fresh | **high** |
| Verifier (after the MOVE ON that follows a fix; fresh) | **Opus 5.5** | **high** |
| AC auditor (blind, fresh, before every finish step) | **Opus 5.5** | **xhigh** |

In one line: planner Fable 5.2 high; builder Opus 5.5 xhigh; reviewer round 1 Fable 5.2 high, later rounds Opus 5.5 high; fixer Opus 5.5 high; verifier Opus 5.5 high; AC auditor Opus 5.5 xhigh; finisher Opus 5.5 high; pipeline main session Opus 5.5 high.

Sol 6.1 is only a substitute Justin approves when Claude is at its limit (ask, never switch silently). The 2026-10-22 Sol builder/finisher rows are superseded, and so is "Sol" in the steps below.

Mini saves time by having fewer agents (one full review instead of two, a short plan, fix/verify only on findings); each role runs on Full's model and effort. Routing mechanics are the same as Full (set `delegation.provider/model/reasoning_effort` -> dispatch -> verify live model -> reset), with each role's effort from the table. Board `model=` shows e.g. `fable-5.2 high (mini)`, `opus-5.5 xhigh (mini)`, `gpt sol-6.1 high (mini)`.

## Steps

1. **Planner (Fable 5.2 high).** Short plan, not the full template: playback, root cause with file/line evidence (bugs), the fix, numbered ACs (AC1, AC2…) with one named test each (marked **proposed** when the request gave none; `(live)` right after the id when only Justin can check it: `- AC3 (live): …`), touched files, a one-line Docs & records task, questions at the top (if any). Add to the brief: "Mini mode: load the project skill and only the code/docs sections this touches; skip the full Step 1 context load; finish within about 15 steps. If this is bigger or riskier than a Mini job, say so in `summary` and recommend Full." Plan approval is unchanged: Phase 2 message, Justin's **go**.
2. **Builder (Opus 5.5 xhigh).** Normal Phase 3 brief: test-first, project branch naming, before/after shots, `found_else`. Add: "Mini pipeline: if the fix needs more than ~3 source files, a design decision, or touches auth/tenant/data/API areas, stop with `status: stopped`, `stop_reason: escalate to full`."
3. **Reviewer (fresh Fable 5.2 high).** Round 1 of the review loop: one fresh full review, every repo (Full has two full rounds). Still a separate agent that never saw the build; never the builder or finisher. Same review-only brief and output schema as Phase 3b, plus the VERIFIER's AC work from `ac-verification.md` (writes `verifier/ac.json`); it also writes `review-1/review.json` (`review-loop.md`).
4. Run `scripts/review-check.sh` (`review-loop.md`). **MOVE ON** at round 1 → the blind AC auditor, then `scripts/ac-check.sh --reviews` (`ac-verification.md`); on `ALL ACCEPTED` or `READY FOR THE USER` (live ACs owed to Justin, named in the hand-over), the finisher runs only the project's finish step (Figma: merge + BUILD; Leorna: stop-and-show diff, PR text, team message, ClickUp draft; never push or post). **REVIEW AGAIN** → an Opus 5.5 high finisher fixes the listed P0–P2 test-first (`receiving-code-review`) and stops `ready-for-next-review`; a fresh Opus 5.5 high delta reviewer (review only: the fix commits and what they touch) writes the next `review.json`; repeat until MOVE ON; then a fresh verifier (with the AC work) → auditor → `ac-check.sh --reviews`. **ASK JUSTIN** → ask; from round 3 (in Mini, the review of the second fix) a round with only P2 left asks too: his "fix" → `"continue": true`, "follow-up" → `"accept"` and the lines go to `follow-ups.md`. **NOT ACCEPTED** or verifier findings → finisher → a fresh delta review until MOVE ON → verifier → auditor → ac-check. After the finisher's rebase, a pure rebase gets a rebase receipt and `ac-check.sh --rebase-receipt` (`ac-verification.md`), not a new verifier and auditor; a rebase that resolved conflicts takes the full path. Same brakes as Full, no round cap, but Justin is asked from round 3 when only P2 is left. Ask Justin only for a decision that's his, on ASK JUSTIN, or when the same AC fails twice for the same reason.
5. **Escalation to Full.** Any Mini agent that finds the job bigger or risky: tell Justin in one line, offer **full**. On **full**, keep the branch, commits and evidence; continue from the first Full phase not done yet (usually a Fable high re-plan or the Full review order). Set `pipeline=full` on the board.

## Unchanged from Full

Skills every agent loads, project gates, merge/push policy, before/after pictures, `found_else`, board helper, briefs in files, phase announcements, the reset-chat prompt, Opus-limit question (applies to every Mini role on Claude, Fable or Opus).
