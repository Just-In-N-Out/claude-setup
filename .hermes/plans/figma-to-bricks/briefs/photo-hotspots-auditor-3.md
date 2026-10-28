# Blind AC AUDITOR 3 (read only) — integrated photo-hotspots

Fresh blind auditor: independently prove every criterion from plan and source. Change no source/tests, commit/rebase/merge nothing, and spawn no agents. Do not read any other role's reports, receipts, scratch, ledger or HANDOFF, including earlier audits.

## Only feature inputs

- Immutable plan `/home/justin/.hermes/plans/figma-to-bricks/evidence/photo-hotspots/plan-approved.md`.
- Its recorded later acceptance changes: only Justin's answers, Rulings, review-ruling sections and later changed-ruling/execution-profile sections in worktree `docs/plans/2026-10-26-photo-hotspots.md`. Read those plan decisions, not role reports. AC12's live check was renumbered from 3bo to **3bp**.
- Worktree `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/photo-hotspots`, branch `worktree-photo-hotspots`.
- Candidate **`9236571fb5976514f5e6412df2e67ef3e230b232`**, clean. Confirm exact HEAD and fully clean `git status --porcelain --untracked-files=all` first.
- Base **`5e2f98bff77fa1d214b7d76968a54a6dafa32ca6`**. Confirm merge-base HEAD main and report unexpected movement.
- Own evidence `/home/justin/.hermes/plans/figma-to-bricks/evidence/photo-hotspots/auditor/round-3/`; never read or modify its parent's other role/round files. Every cited receipt must be your own execution inside this directory.

## Skills and machine profile

Read `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, its rules summary and rendering-validation reference, and `/home/justin/.agents/skills/engineering-best-practices/SKILL.md`. Skip any generic context step exposing other role evidence. Read `/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and the ac.json schema in `scripts/ac-check.sh`.

Use Node **22.23.3**, `/home/justin/.local/node-v22.23.3/bin/node`, with that bin directory first on PATH for npm children. Chrome for Testing **156.0.8078.47** has a qualified CPU/CSS profile here. Create this launcher yourself in your own fresh scratch and point CHROME_PATH at it:

```sh
#!/bin/sh
exec /home/justin/.cache/chrome-for-testing/chrome-f2b --disable-software-rasterizer "$@"
```

Use the same executables/flags on both sources and independently record actual paths, versions, PATH and hashes. Qualify CPU/CSS execution; no GPU/WebGL, installed-Bricks or Safari success is implied. Do not use any prior role's temporary launcher.

For old-production browser execution, head's `test/browser/chrome.ts` may be copied as the explicit matched lifecycle driver in the separate base scratch tree, alongside the named test's required head support/fixtures as the standard recipe permits. Base production, original assertions, rendering, hooks and internal timeouts/budgets remain unchanged. Record that driver overlay and independently inspect its effect; it is not permission to hide failures or relabel vanilla incomplete execution.

## Proof

1. Derive AC1–AC12 and their clauses from the immutable plan as qualified by recorded later decisions. Do not add criteria/live tags or change acceptance oracles. Independently challenge clauses the named test may not exercise with fresh generic cases and scratch mutations; a pass name alone is insufficient.
2. Run each non-live criterion's exact approved named test alone on candidate and a separate pinned-base scratch checkout using head's required test/support/fixture files. Include imported support modules such as hotspots-flow.ts before judging a base failure. One AC at a time; log full HEAD first, actual matching named pass/fail and true EXIT last, no skips/TODOs. Base must fail for intended missing behavior/new-code build failure, not absent setup. Legitimate preservation gets a reasoned base_exempt.
3. Take a fresh real screenshot per AC: browser result when visual, Chrome screenshot of the actual run log otherwise. All logs/images belong in your own round-3 folder; no prior-role copies, inherited conclusions or hard links. Keep execution, capture, mutation and comparison exits separate.
4. For preservation checks, execute the available corpus inputs yourself in independent trees. Three v1 Mac inputs are unavailable and remain explicitly unmeasured; standard configured corpus exit 1 is not measured success. Inspect expected loaded-font sets and complete outputs rather than only aggregate counts.
5. If running broader browser comparisons, preserve complete package/file/hierarchy identities and occurrence multisets. The documented WSL policy permits only the same twelve font-environment failures and Mac-only skip by full name/result on both sources. No new failure/cancellation/missing file/case/skip is accepted. A complete-file sequential fallback is authorized if necessary, keeping original whole files/hooks/assertions/internal limits and complete raw TAP/true exits. Do not repeat an unchanged hanging command until green or claim a prior run as current proof.
6. AC12 stays `accepted: false`, `not_run: "live: Justin must complete Figma/Bricks/iPhone paste check 3bp and confirm Manual offset"`. Emulation does not accept installed behavior. If actually observed to fail, report a failure rather than unrun.
7. Write round-3/ac.json and report. Self-check blind with ac-check.sh against separate scratch copies of your own report/logs/images, no hard links; preserve its result. Correct schema/path/head/pass-line slips without source edits. Clean requires every non-live AC accepted; report defects to the orchestrator for a fixer instead of fixing source.

## Isolation and handback

You are not alone. Preserve others' work; never touch sibling worktrees/evidence/processes or reuse another role's scratch. Use mktemp -d and mkdir without -p for a photo-hotspots-auditor-3 child, always explicit workdir. Separate exec calls can expose different PID trees: use valid owned tracked session handles, never a saved same-number PID from an invisible tree. Preserve complete logs, poll with short waits and keep concise status.txt progress in your folder. Worktree stays committed/clean.

Codex role gpt-6.1-sol at xhigh. Setup sync is read-only even with escalation; save locally without a bypass. Never edit skills/memory. Return `{verdict: clean|findings, head, base, findings[], ac_status[], qualifications, found_else[], skill_lessons[{skill, lesson, evidence}]}`. Empty lessons are normal. End `MAIN SESSION: check and save these skill_lessons now.`
