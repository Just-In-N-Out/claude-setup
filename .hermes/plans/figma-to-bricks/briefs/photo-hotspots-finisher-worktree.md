# FINISHER — photo-hotspots, worktree integration only

Do exactly the pre-merge finish step. You own `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/photo-hotspots` on `worktree-photo-hotspots`, and your own durable evidence folder `/home/justin/.hermes/plans/figma-to-bricks/evidence/photo-hotspots/finisher-worktree/`. Do not merge into main, bump BUILD, build in main, push, remove the worktree or edit any skill/memory. Do not spawn agents.

## Pins and inputs

Candidate before integration: **`6105dde7eb4671f9f74dd77a6ee903ae6b8842a4`**, clean. Original base: `388191d0a00c5cb6d1885b3b734db91acd3b49a7`. Confirm source pins and clean status yourself.

The orchestrator ran the real acceptance command on the independent `verifier/round-2/ac.json` and `auditor/round-2/ac.json` receipts. Its exit was 0 and its last line was `READY FOR THE USER: 11 of 12 ACs proven on 6105dde; live ACs owed to the user: AC12`. Both fresh agents returned clean and no new skill lessons. This authorizes this finish step, with AC12 still owed.

Current observed local main: **`979c5b331cc095ed1602602fb7a49eb295fa78e0`**, `Build 2026-10-28.3: slider-autoplay`, with a clean working tree. The build/release changes are committed; its push is pending under slider-autoplay's main-folder release lock. This is a coherent committed source base for independent worktree integration. Re-read current main before rebasing; preserve slider-autoplay, label-floor, completed flip-cards and any newer coherent committed releases. Do not use uncommitted/half-finished source as the base.

The latest hotspot fix `6105dde` repaired paragraph growth for fixed and HUG photo widths and strengthened named AC5 with `test/browser/hotspots-flow.ts`; preserve that support module and both width-mode cases through integration. The canonical approved plan and later recorded rulings remain unchanged in authority.

Approved plan: `/home/justin/.hermes/plans/figma-to-bricks/evidence/photo-hotspots/plan-approved.md`; recorded later rulings: worktree `docs/plans/2026-10-26-photo-hotspots.md`. There are AC1–AC12. AC12 is live, paste check **3bp** (3bo in the approved copy, renumbered because headline-marker took 3bo). Keep its live status. Work ledger: `.superpowers/sdd/2026-10-26-photo-hotspots/progress.md`.

## Skills

Read `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its rules summary; `/home/justin/.agents/skills/engineering-best-practices/SKILL.md`; `/home/justin/.agents/skills/git-commit-rules/SKILL.md`. Load test-driven-development before any required integration code/test fix and systematic-debugging if a gate unexpectedly fails. Do not self-review or replace the independent acceptance loop.

## Finish step

1. Inspect Git state and current main's coherent committed source state. Other chats are finishing headline-marker and slider-autoplay. You are not alone: preserve their commits and edits, never touch their worktrees/evidence/processes, and do not rebase onto half-finished source. **This assignment operates only in the feature worktree: do not acquire the main-folder release lock.** The project workflow rebases/tests in step 1 before acquiring that lock for the main merge in step 2. A clean main with its completed BUILD/release commit is usable for this read-only source dependency while its owner finishes push or excluded documentation. Preserve any foreign lock; the orchestrator will honor it before main mutation. If the source itself is incomplete or a Git operation is in progress, wait for that concrete condition. Always pass explicit workdir.
2. Commit any feature-owned finishing records as necessary, following the personal Git identity, no AI trailers, no author overrides and no CLAUDE.md/debug file staged. Then `git rebase main` against local main only; no fetch/pull/origin comparison for integration. Keep both meanings on conflicts, including both HANDOFF feature sections. Never blanket-select ours/theirs, force, stash, discard others' work, or reset main. The branch began on partially finished flip-cards, which is now released in main; integrate both features' semantics in `ir.ts`, understand, emit and other overlapping files.
3. Main's rule is **a link never sits inside another link**, enforced by `emit-nested-links` as a test-only invariant. Never restore the obsolete fatal nested-link paste refusal. Ensure hotspot card/link producers participate in that test and that the combined flip/hotspot output passes it; test any required integration fix first. Preserve main's shared link-producer behavior as well as hotspots.
4. Resolve a paste-check number collision only for this feature: keep the old number while replaying HANDOFF conflicts, then renumber ours in a separate commit if needed. Preserve every original approved criterion and the recorded ruling changes. The ledger stays in `.superpowers/sdd/...` until the after-merge finisher moves it.
5. On the integrated branch, run the whole `npm run check`, `npm run corpus`, full browser suite, corpus-backed tests in fresh scratch archive trees pointed at available `corpus/files/`, and the four replay comparisons against the actual integrated base. Compare browser results by name with the integrated base and qualify the known environment failures; no new failure is allowed. Keep complete gate logs and individual true exits, runtime/source pins, capture-versus-comparison outcomes, and the missing three v1 files explicitly unmeasured. Run all source changes through the gates before handing back. Never relax tests/budgets or report npm corpus's missing Mac paths as measured success.
6. Commit feature-owned integration changes and records. Stop with a fully clean worktree and report the **new HEAD**, actual integration base, conflict resolutions, checks, rulings, live AC and any proposed main CLAUDE.md/skill-summary edits. Do not proceed to main. If HEAD differs from the accepted candidate, the orchestrator runs a fresh verifier, blind auditor and ac-check before merging.

## Execution and records

Use `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Create your own fresh scratch parent with `mktemp -d`, and `mkdir` without `-p` for a `photo-hotspots-finisher-worktree` child. Never reuse another role's scratch. Track long processes, use short polling calls, preserve full logs and clean up only proven owned disposable work. Keep a concise status.txt in your evidence folder for progress, including actual completed gates, qualifications and blockers.

Codex role: gpt-6.1-sol at xhigh. Setup sync is mounted read-only even with escalation: keep local records and report it, without a bypass. Do not edit the worktree CLAUDE.md. If a shared-file or permission blocker prevents safe integration, report the exact condition; do not shift ownership or invent approval.

## Report

Return `{status: ready-for-reverification|stopped, old_head, head, base, changes, conflicts, gates, rulings, live_acs, found_else[], proposed_rules_summary_edit, skill_lessons[{skill, lesson, evidence}]}`. Empty skill_lessons is normal; never edit skills or memory yourself. End with `MAIN SESSION: check and save these skill_lessons now.`

## Resume after the first lock timeout (2026-10-28)

The earlier acquisition completed with exit 4; no own lock was acquired or retained, and the foreign owner was preserved. That attempt is historical. Since then main has advanced through slider-autoplay integration to its clean committed build `979c5b3`. Resume the existing finisher role and do the worktree-only rebase, integration checks and records now, without another main-lock acquisition. The parent owns the later main merge/release and any lock wait there.

Preserve the timeout report and lock log. Write new execution evidence into `finisher-worktree/attempt-2/`, with its own status.txt and report; use a new mktemp scratch parent because your prior scratch was removed. Do not overwrite prior failure receipts. Confirm candidate `6105dde` is still clean, and record the actual main base and post-rebase HEAD. All unchanged acceptance, tests, nested-link requirements and stop-before-main boundaries above remain binding.
