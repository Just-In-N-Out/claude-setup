# PLANNER — headline-marker, prove a viable general correction for R3-F1

You are a fresh planner for an existing approved Full-pipeline feature. Main session only orchestrates. Investigate the unresolved geometric assumption, prove an implementable in-scope method, and write a small implementer-ready amendment. Do not spawn agents or edit production/tests, rebase the feature branch, commit, merge, push, bump BUILD, acquire the merge lock, or edit skills/memory/CLAUDE.

## Pins and ownership

- Feature worktree `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/headline-marker`, branch `worktree-headline-marker`, clean HEAD `76d0f7bf2f75677211b46310af8d4408fdd128d5`, old merge-base `27b787b78d88850cbb9863bb31fcfc840406331c`.
- Production/tests unchanged from `a364eb54fc8a825e4600481cdc08f788c8d47fcf`; fixer 4 committed only plan/ledger/HANDOFF records. Confirm that scope from git metadata.
- Current coherent local main `5e2f98bff77fa1d214b7d76968a54a6dafa32ca6`, clean/equal to origin. It is the completed slider-autoplay .3 release `979c5b3` plus a records-only follow-up. Last observed merge lock free. Main is read-only for you.
- Immutable approved plan `/home/justin/.hermes/plans/figma-to-bricks/evidence/headline-marker/plan-approved.md`; feature plan `docs/plans/2026-10-26-headline-marker.md` contains existing rulings and fix-pass amendments. AC1–AC13 are authoritative; AC13 alone is live (3bo, subject to collision renumbering at integration).
- Write your amendment only to `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/headline-marker/docs/plans/2026-10-28-headline-marker-height.md`. This new plan file is your only permitted project-file write. The next builder will commit it. Keep the immutable approved plan unchanged.
- Your own evidence `/home/justin/.hermes/plans/figma-to-bricks/evidence/headline-marker/planner-height/`, created fresh; task-owned fresh `mktemp -d` / `mkdir` without `-p`. Scratch exports, experimental HTML/CSS/SVG and disposable test copies are permitted there or in your own scratch; no actual feature source/test edits.
- Other chats own other worktrees/evidence/processes. Do not touch them, terminate their processes, remove locks, or revert any edit. Do not launch another chat or change pipeline models/routes.

## Skills

Load the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, its `references/rules-summary.md` and `references/rendering-validation.md`, then `engineering-best-practices`, `implementation-planning`, and `systematic-debugging`. Read the approved architecture/spec sections your proposed change actually touches. Main runs all later independent roles; do not spawn agents for any skill step.

## Playback and evidence

The feature makes Figma Trim path strokes draw around heading words, following the words as the heading changes width, using the existing per-text CSS and SVG-background image transport. A rotation/gutter correction fixed ordinary same-size runs but fails with larger marked words and permitted wrapping.

Reviewer R3-F1, verbatim: “src/core/adapt/rules/mark.ts:35 reserves rotation reach in lh units, but an inline-block containing larger styled words can exceed one inherited line height. AC9 still fails. A right-aligned heading with plain 56px text, marked 80px words and an 8° ring produces scroll widths 391/376/361/330 at viewports 390/375/360/320. Fresh documents removing only rotation fit exactly; unmarked controls and the same snapshot on base also fit. At 390, the inherited line height is 60.724px while the span is 86.781px tall; wrapping at 320 increases it to 173.563px.”

Read the completed research rather than repeat it blindly:

- `/home/justin/.hermes/plans/figma-to-bricks/evidence/headline-marker/fixer-4/report.json` and `research.md`, with all 56 durable scripts/results/source hashes/exit receipts.
- `/home/justin/.hermes/plans/figma-to-bricks/evidence/headline-marker/reviewer-3/report.json`, `counterexample-ac9-mixed-size.test.ts`, `.log`, `counterexample-ac9-mixed-size-base.log`, `mixed-80--8-390.json`, `mixed-80--8-320.png`.
- Earlier rotation finding and fixed controls in `integration-df32227/auditor/` and `fixer-3/`.

Fixer 4 verified the new failure. An actual-height cap makes scrolling fit but at 320 squeezes the carrier to 285px around 288px of text. A tighter rotated-rectangle cap gives carrier 287.781px and decoded painted SVG width 283.582px, still inside the 288px text. No successful correction or pixel pass was claimed; production and tests were preserved. Its recommendation is a **scoped investigation of rotation inside the existing SVG image carrier**; geometry, timing and compatibility are still unproved. This is a research lead, not an approved implementation decision.

Do not substitute scrolling-only acceptance for the complete approved ink-surrounding, paint, timing, stroke-weight and text-layout contract. The current marked-text styles and the original AUD-F1 positive controls must remain. No hardcoded example sizes/strings/angles/line counts. Keep plain/unmarked conversions byte-identical as contracted. Fallback unturning, inline-SVG/Code transport, word shrinking or acceptance weakening require a genuine revised decision and are not implicitly authorized.

## Research and plan

1. Confirm the known root cause with source file:line evidence and inspect the prior research/provenance. Use fresh transformed/no-transform documents; Chrome 156 can retain stale scrollWidth after dynamic transform removal. Larger nested runs and permitted wrapping require actual used-height controls, not an assumed 1lh.
2. Research a viable general approach within the existing CSS-only/SVG-image transport. Use primary specifications/official browser sources for uncertain behavior and record URLs and the exact supported assumptions. You own the technical design; do not merely prescribe the failed actual-height cap again.
3. Produce isolated browser/geometry/pixel/timing spikes sufficient to establish viability before prescribing production changes. Prove the relevant existing clauses, including word-surrounding ink, rotation/paint, supported shape kinds, timing/start direction, scrolling/reduced motion, responsive width and unchanged design-width geometry. Include the reported larger-run/wrapping class and earlier controls, not only one fixture. Work against clearly pinned scratch source; inspect current-main overlaps and name integration dependencies without editing/rebasing the feature branch.
4. Address the probe-harness limitation honestly: fixer 4's screenshot capture stalled even on plain controls; geometry probes completed but it claimed no new pixel captures. Successful earlier gates used Node v22.23.3 and Chrome 156.0.8078.47. Record actual executable/PATH/browser versions, preserve failed runs, and follow the project runtime/proven-owned-process rules. Restore a valid capture control before claiming pixel viability; do not weaken the oracle or terminate other workers. Archived scripts may contain deleted temp paths: adapt a separate private copy and retain provenance rather than rerunning stale absolute dependencies.
5. Write the amendment with playback/root cause, proven method and its limitations, typed data/interface changes, named files/tasks, tests and mutation strategy, integration/record steps, and questions/⭐ recommendations at the top. It must be implementable by a fresh builder without redesign. Include numbered AC1–AC13 with their existing approved named tests and existing live designation; preserve the contract and immutable original. If any actual criterion/transport/product tradeoff needs revision, explicitly mark it proposed and explain rather than silently changing it. Do not propose a build whose central geometry or transport is still unproved.
6. Keep source stages pure and typed, with breakpoint writes only in adapt/rules, sizes from shared page facts, deterministic IDs, sandbox-safe built-ins and no new runtime dependencies. If shared SVG/sizing infrastructure must change, name the blast radius and prove unrelated assets remain as contracted; prefer scope within marked text where the evidence allows it. Preserve all other feature additions during the later integration onto coherent current main.
7. Include a final Docs & records task and the required next build/test-first, fresh review, verifier, blind auditor and ac-check steps. Do not acquire the global lock for research. The implementer must take the existing lock before the next rebase/integrated gates after the two actual main advances, following valid ownership and failure-path release rules.

Justin's standing auto-go covers a proved in-scope general correction. Ask no user question yourself. If no viable original-contract path is established, return concrete bounded options and decisive evidence, clearly separating untried in-scope work from product decisions that truly require Justin. Do not declare the whole feature impossible merely because the first two cap approaches failed.

## Report

Return `{status: plan-ready|decision-required|research-held, plan, head, integration_pin, summary, root_cause, viable_method, proofs, limitations, questions, recommended, numbered_acs, tasks, evidence, skill_lessons:[{skill,lesson,evidence}]}`. List only new reusable proven lessons, normally empty; never edit skills/memory. End with `MAIN SESSION: check and save these skill_lessons now.`
