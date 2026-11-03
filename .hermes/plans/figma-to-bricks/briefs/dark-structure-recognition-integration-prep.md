# DRAFT — prepare current-main integration before the second/final review

Role: fresh pipeline_finisher, branch preparation only. Do not spawn agents. You are not alone; preserve all other sessions' changes and accommodate them. Load engineering-best-practices, git-commit-rules and project `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with applicable testing pitfalls.

W `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/dark-structure-recognition`, branch worktree-dark-structure-recognition.
M `/home/justin/Documents/FigmaToBricksV2`, READ ONLY.
E `/home/justin/.hermes/plans/figma-to-bricks/evidence/dark-structure-recognition`.
Own evidence E/integration-prep/ and fresh private disk scratch.
Approved plan E/plan-approved.md hash23fe2fb95ab2311819000091925656fea9753555fe4c10ce9fa663f34078b511; no amendment authorized.
Starting fixed head ROOT_MUST_PIN_HEAD.
Fix report ROOT_MUST_PIN_FIX_REPORT.
Prior review E/review-1/review.json and E/review-1/resume/report.md, root referee E/review-1/root-referee.log.

Purpose: local main has advanced with completed independent features, including changes to docs/HANDOFF.md and src/core/style/style.ts shared with this story. Justin allows only TWO review rounds. Prepare the branch integration before the final full review so any conflict resolution is included in that review. This is not acceptance or release: no AC has been independently accepted yet, and all verifier/auditor/ac-check gates remain after review2. No merge, BUILD bump, push, live writes or main-folder modifications.

Confirm fixer has committed its owned changes and W is clean; preserve any unexpected changes and report their owner. Read current local main, record its SHA, then rebase the story onto it. You are the finisher handling the rebase; the fixer was explicitly forbidden to rebase. Preserve both meanings in every conflict; record conflicts and resolutions precisely for review2. Do not make unrelated behavior changes, rewrite main/history, fetch/pull code, push the feature branch or hide a conflict. Produce range-diff from original review base14240810effc26254e2fc6771fdeb6e67910c429..starting-fixed-head to new-main..rebased-head. Check frozen approved/tracked plan and input hashes remain unchanged. Current main's BUILD must be preserved.

The ledger is already tracked at docs/plans/2026-10-31-dark-structure-recognition-ledger.md; do not make an unnecessary move or later records-only commit. Include genuinely necessary integration records in the prepared candidate before review2. Never stage CLAUDE.md or add AI attribution/identity overrides. Do not touch private CLAUDE, shared dependencies/config, other worktrees or skills/memory.

Run npm run check and npm run corpus in this copy and affected recognition checks on the integrated tree. Preserve exact configured outcomes and separately qualified available-input outcomes, inherited failures/skips and missing fonts. No baseline rewriting or fake green. Complete meaningful conflict-specific tests when resolution affects behavior. Full browser execution before merge is still required and will be owned by the subsequent independent verifier; do not launch another paired full-browser run here absent a new concern requiring it. Source/record changes are still unreviewed until review2. Return clean branch, exact final HEAD and integration base, range-diff/conflict evidence, original/qualified gate results and remaining limits.

The approved eight criteria remain: recognition-header-ownership; recognition-header-actions; recognition-footer-navigation; recognition-review-candidate; recognition-preservation-matrix; recognition-panel-contract; recognition-browser-matrix; recognition-installed-round-trip (live). Q1A preserves static supplied reviews with truthful missing-record note, never fabricated reviews/timings; Q2A omits only uniquely owned navigation; Q3A retains existing destination policy. Prior good pages and explicit actions stay preserved. AC8 remains live/owed unless genuinely executed; do not substitute DJ staging2.4.4 for approved Bricks2.3.9 proof.

Runtime: pinned Node22.23.3 `/home/justin/.local/node-v22.23.3/bin/node` plus child PATH; owned Chrome wrapper with --use-gl=disabled, clear DISPLAY/WAYLAND. Short owned disk scratch/TMPDIR/profiles under /home/justin/.hermes, not RAM/tmp. One of three existing shared f2b-chrome locks with nonblocking flock FD selection, node-named marker and owned trap cleanup for a complete sequence. Never run two Chrome jobs or hold two slots yourself; base/head sequential. Read runtime section of briefs/djtrees-common.md if needed. No waiting for all foreign Chrome after acquiring a slot. Root owns setup sync; one role here, global agent ceiling8.

Keep checkpoint.json and report meaningful blockers/progress. Stop ready-for-review2, with verdict, exact original/final HEAD/main, conflict and check receipts, honest ac_status for AC1–AC8, and skill_lessons [{skill,lesson,evidence,enforce}] (normally empty). Never edit skills/memory. End MAIN SESSION: check and save these skill_lessons now.

## Windows Desktop: Runaway Memory (mandatory, latest AGENTS)

Mutation runs always use `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. A command ending SIGTERM, exit143/137, or Killed may be earlyoom rather than a test result. Check `journalctl -u earlyoom --since "-30 min" -o short-iso` for sending lines, identify the killed command and growth, and report it to the orchestrator. A killed check must be rerun under the same 4 GB cap, never bare. Do not weaken or bypass the cap; report a concrete unavailable cgroup/systemd prerequisite if one occurs. Preserve existing three Chrome slots and owned-process cleanup. Include relevant kill facts in checkpoints/handback. Root checks earlyoom since its last check on every report and before dispatching the next role; it maps killed paths to owners and notifies Justin, including unowned kills.
