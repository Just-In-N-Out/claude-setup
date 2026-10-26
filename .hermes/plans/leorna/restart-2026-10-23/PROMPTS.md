# Restart prompts (2026-10-23)

Close the three old sessions first, so two orchestrators never run one story. Start each new session in `~/Leorna` (plain `claude`, not `claude -w`) and paste one prompt.

## 1. Quality gate v2 (86bcm901u)

```
Resume story 86bcm901u "Content quality gate (CI)", v2. You are the orchestrator (first section of ~/.claude/CLAUDE.md): don't plan, build, test or review yourself.

Read first: ~/.hermes/plans/leorna/restart-2026-10-23/STATE.md section 1 (where the paused session stopped), then the plan ~/.hermes/plans/leorna/86bcm901u-quality-gate-v2.md.

Where it is: the builder finished on feat/86bcm901u-quality-gate-v2 at 2e8b5cd (worktree ~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901u-quality-gate-v2). Its gates are green per SUMMARY-2e8b5cd.txt, but it never marked ready-for-review and nobody has reviewed it.

Next:
1. Tell me in a few lines where it stands (the summary the old session never sent).
2. The plan was approved before the pause, so make its read-only copy now: mkdir -p ~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v2 && install -m 444 ~/.hermes/plans/leorna/86bcm901u-quality-gate-v2.md ~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v2/plan-approved.md. The verifier and the auditor write into verifier/ and auditor/ subfolders of that evidence folder (feature-dispatch references/ac-verification.md).
3. Continue the pipeline from step 5: fresh reviewer 1 on 2e8b5cd → fixer → fresh reviewer 2 → fixer → verifier → blind AC auditor → ac-check.sh, looping until ALL ACCEPTED. Give reviewer 1 the builder's 12 rulings (its hand-back in ~/.claude/projects/-Users-justin-Leorna/6850ae17-035c-4b3b-99a9-e3c323c5286a.jsonl or that session's subagents folder) and the NOT VERIFIED list.
4. Then the Leorna hand-over: PR text, review prompt, team message, ClickUp evidence draft.

Rules that still hold: every agent a fresh general-purpose Opus 5.5 xhigh agent, brief saved first; one screenshot per AC; skill_lessons from every agent; no push, PR, post or ClickUp change unless I say so; don't touch the old attempt or its DBs. My away grant still holds for this pipeline only: when an agent asks something, take its recommendation. Hosted CI, GitHub's summary rendering, ClickHouse and CRLF stay NOT VERIFIED until a PR and don't block local acceptance. G1 waits on CP #85 and client #20. Also check and save the builder's unsaved api-contract-drift-guard lesson (parity rebuild check).
```

## 2. Catalog browser v2 (86bcm901v)

```
Resume story 86bcm901v "Library catalog browser", v2 (fresh start). You are the orchestrator (first section of ~/.claude/CLAUDE.md): don't plan, build, test or review yourself.

Read first: ~/.hermes/plans/leorna/restart-2026-10-23/STATE.md section 2.

Where it is: the blind planner finished, but its plan was never saved. Its full output is ~/.hermes/plans/leorna/restart-2026-10-23/86bcm901v-catalog-browser-v2-planner-output.md. The worktree is ~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901v-catalog-browser-v2 (branch feat/86bcm901v-catalog-browser-v2 at 57c7fc1, no commits).

Next:
1. Save that output as ~/.hermes/plans/leorna/86bcm901v-catalog-browser-v2.md (without its first line, which is an instruction to you). Check it has numbered AC1–AC3, each with a test and a screenshot; if not, send it back to a planner.
2. Show me the plan as CLAUDE.md step 3 says: questions Q1–Q5 with their recommended answers (all A), the ACs, the planner's 7 found_else items. Check and save its 6 skill lessons.
3. My earlier grant still holds: treat the recommended answers as mine and go straight on to the builder. Before dispatching it, make the plan's read-only copy: mkdir -p ~/.hermes/plans/leorna/evidence/86bcm901v-catalog-browser-v2 && install -m 444 ~/.hermes/plans/leorna/86bcm901v-catalog-browser-v2.md ~/.hermes/plans/leorna/evidence/86bcm901v-catalog-browser-v2/plan-approved.md.
4. Builder in the existing worktree, then the rest of the pipeline through ac-check.sh until ALL ACCEPTED, then the Leorna hand-over.
5. Fix the stale records: add a board entry for v2, mark the old 86bcm901v entry superseded, update the 901v status line in leorna-workflow.md.

Rules that still hold: every agent a fresh general-purpose Opus 5.5 xhigh agent, brief saved first; one screenshot per AC; skill_lessons from every agent; no CI edits; no push, PR, merge, ClickUp, my servers, cloud, or writes to my real ~/.claude or ~/.codex; don't touch the old attempt. Merge order: #85 first, then this story. The admin library page overlaps 945u's AC1.
```

## 3. Upstream content sync (86bcm945u)

```
Resume story 86bcm945u "Upstream content sync + licence attribution". You are the orchestrator (first section of ~/.claude/CLAUDE.md): don't plan, build, test or review yourself.

Read first: ~/.hermes/plans/leorna/restart-2026-10-23/STATE.md section 3.

Where it is: no plan and nothing built. The old planner was stopped mid-research, so start a new one.

Next:
1. CLAUDE.md step 1: recommend Full or Mini and ask me.
2. Dispatch a fresh planner (general-purpose, Opus 5.5 xhigh). Base its brief on ~/.hermes/plans/leorna/restart-2026-10-23/86bcm945u-planner-brief.md and the explorer digests in 86bcm945u-explorer-reports-forwarded.md (same folder), plus the newer facts in STATE.md section 3: 901u-v2 is built at 2e8b5cd, 901v-v2's plan proposes /admin/library, and migration 21 is taken by #85. Bring the brief up to the current CLAUDE.md rules (the card's AC1–AC4, `(live)` tags where only I can check) and save it under ~/.hermes/plans/leorna/briefs/ first.
3. The plan's questions should cover: which repo (recommended: control plane), CLI-only sync or CLI plus a scheduled CI run, how the admin console part fits with 901v-v2, and importing items now or building only the machinery.
4. Show me the plan and wait for my go (on go, make the plan's read-only copy as CLAUDE.md step 3 says). Then the pipeline through ac-check.sh until ALL ACCEPTED or READY FOR THE USER, then the Leorna hand-over. No push, PR, post or ClickUp change unless I say so.
```
