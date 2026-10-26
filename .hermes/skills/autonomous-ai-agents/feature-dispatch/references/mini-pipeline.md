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

## Roles (Justin, 2026-10-23: all-Opus default; everything xhigh)

| Role | Model | Effort |
|---|---|---|
| Planner | **Opus 5.5** | **xhigh** |
| Builder (implements) | **Opus 5.5** | **xhigh** |
| Reviewer (separate, fresh, never saw the build) | **Opus 5.5** | **xhigh** |
| Finisher (only if the review found something) | **Opus 5.5**, fresh | xhigh |
| Verifier (only after a fix round; fresh) | **Opus 5.5** | xhigh |
| AC auditor (blind, fresh, before every finish step) | **Opus 5.5** | xhigh |

Sol 6.1 is only a substitute Justin approves when Claude is at its limit (ask, never switch silently). The 2026-10-22 Sol builder/finisher rows are superseded, and so is "Sol" in the steps below.

Mini saves time by having fewer agents (one review instead of two, a short plan, fix/verify only on findings), not by lowering effort. Routing mechanics are the same as Full (set `delegation.provider/model/reasoning_effort` -> dispatch -> verify live model -> reset), with `reasoning_effort xhigh`. Board `model=` shows e.g. `opus-5.5 xhigh (mini)`, `gpt sol-6.1 xhigh (mini)`.

## Steps

1. **Planner (Opus 5.5 xhigh).** Short plan, not the full template: playback, root cause with file/line evidence (bugs), the fix, numbered ACs (AC1, AC2…) with one named test each (marked **proposed** when the request gave none; `(live)` right after the id when only Justin can check it: `- AC3 (live): …`), touched files, a one-line Docs & records task, questions at the top (if any). Add to the brief: "Mini mode: load the project skill and only the code/docs sections this touches; skip the full Step 1 context load; finish within about 15 steps. If this is bigger or riskier than a Mini job, say so in `summary` and recommend Full." Plan approval is unchanged: Phase 2 message, Justin's **go**.
2. **Builder (Opus 5.5 xhigh).** Normal Phase 3 brief: test-first, project branch naming, before/after shots, `found_else`. Add: "Mini pipeline: if the fix needs more than ~3 source files, a design decision, or touches auth/tenant/data/API areas, stop with `status: stopped`, `stop_reason: escalate to full`."
3. **Reviewer (fresh Opus 5.5 xhigh).** One review, every repo (Mini replaces Full's two-review order). Still a separate agent that never saw the build; never the builder or finisher. Same review-only brief and output schema as Phase 3b, plus the VERIFIER's AC work from `ac-verification.md` (writes `verifier/ac.json`).
4. **Clean review:** the blind AC auditor, then `scripts/ac-check.sh` (`ac-verification.md`). On `ALL ACCEPTED` or `READY FOR THE USER` (live ACs owed to Justin, named in the hand-over), the finisher runs only the project's finish step (Figma: merge + BUILD; Leorna: stop-and-show diff, PR text, team message, ClickUp draft; never push or post).
   **Findings, or `NOT ACCEPTED`:** an Opus 5.5 xhigh finisher fixes valid ones test-first (`receiving-code-review`), stops `ready-for-verify`; then a fresh Opus 5.5 xhigh verifier (read only, with the AC work), the auditor and ac-check again. Loop until `ALL ACCEPTED` or `READY FOR THE USER`, no round cap (2026-10-23; replaces "ask after 2 rounds"). Ask Justin only for a decision that's his, or when a round made no progress (same AC, same reason, no new fact).
5. **Escalation to Full.** Any Mini agent that finds the job bigger or risky: tell Justin in one line, offer **full**. On **full**, keep the branch, commits and evidence; continue from the first Full phase not done yet (usually an Opus xhigh re-plan or the Full review order). Set `pipeline=full` on the board.

## Unchanged from Full

Skills every agent loads, project gates, merge/push policy, before/after pictures, `found_else`, board helper, briefs in files, phase announcements, the reset-chat prompt, Opus-limit question (applies to the Mini planner, reviewer and verifier).
