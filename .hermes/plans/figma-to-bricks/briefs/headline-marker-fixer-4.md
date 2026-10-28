# FIXER 4 — headline-marker, R3-F1 and current-main integration

Fresh pipeline fixer. Verify the new review finding, correct its whole supported class test-first, integrate the completed latest main in this same assignment, commit coherent records, and stop ready for a fresh focused review. Do not spawn agents, merge into main, push, bump BUILD or edit main source/CLAUDE/skills/memory.

## Pins, ownership and contract

- Own `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/headline-marker`, branch `worktree-headline-marker`, incoming clean HEAD `a364eb54fc8a825e4600481cdc08f788c8d47fcf`, old merge-base `27b787b78d88850cbb9863bb31fcfc840406331c`.
- Latest observed coherent main `979c5b331cc095ed1602602fb7a49eb295fa78e0`, completed slider-autoplay release build 2026-10-28.3, clean/equal to origin; merge lock was observed free after that release. Recheck before integrating and never use another owner's half-finished release.
- This feature has now seen main advance twice during quality work (label-floor, then slider-autoplay). Follow the established lock-before-next-rebase/gates procedure below to prevent an integration race.
- Approved plan `/home/justin/.hermes/plans/figma-to-bricks/evidence/headline-marker/plan-approved.md`; committed copy `docs/plans/2026-10-26-headline-marker.md` with review-fix amendments. AC1–AC13 remain the contract; AC13 alone is live, originally paste check 3bo.
- Your evidence only `/home/justin/.hermes/plans/figma-to-bricks/evidence/headline-marker/fixer-4/`. Fresh task-owned scratch via `mktemp -d` and `mkdir` without `-p`; never reuse another role's scratch.
- You are not alone. Other chats own photo-hotspots and other features. Do not touch their worktrees, evidence, processes or edits. Preserve both features' meaning in every integration conflict; never revert others' changes. Main is read-only except the authorized shared merge-lock control.

## Skills

Load `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, `references/rules-summary.md` and `references/rendering-validation.md`, then `engineering-best-practices`, `receiving-code-review`, `systematic-debugging`, `test-driven-development`, `mutation-testing-discipline`, and `git-commit-rules`. Main session owns all independent reviews and verification; do not spawn a subagent for any skill step. The rendering guide now contains both proven lessons about fresh transform controls and 1lh versus actual inline-block height.

## Finding, verbatim

**R3-F1 — medium, introduced:** “src/core/adapt/rules/mark.ts:35 reserves rotation reach in lh units, but an inline-block containing larger styled words can exceed one inherited line height. AC9 still fails. A right-aligned heading with plain 56px text, marked 80px words and an 8° ring produces scroll widths 391/376/361/330 at viewports 390/375/360/320. Fresh documents removing only rotation fit exactly; unmarked controls and the same snapshot on base also fit. At 390, the inherited line height is 60.724px while the span is 86.781px tall; wrapping at 320 increases it to 173.563px.”

Reviewer suggestion (verify it; you own the solution): “Reserve against the actual rendered height, including larger runs and permitted wrapping, while preserving surrounding ink, timing and paint order. Add this combination to the named AC9 oracle.”

Evidence directory `/home/justin/.hermes/plans/figma-to-bricks/evidence/headline-marker/reviewer-3/`:

- `report.json`
- `counterexample-ac9-mixed-size.test.ts` (exit 1 on candidate)
- `counterexample-ac9-mixed-size.log`
- `counterexample-ac9-mixed-size-base.log` (exit 0)
- `mixed-80--8-390.json`
- `mixed-80--8-320.png`

Earlier AUD-F1 is fixed for its original uniform-text witnesses: independent reviewer reproduced old failures, verified fresh controls and exact-old-source causality, confirmed expanded named AC9 passes on the new candidate and fails on incoming old source, and independently killed four intended mutants. Preserve that progress. Fixer 3 evidence `/home/justin/.hermes/plans/figma-to-bricks/evidence/headline-marker/fixer-3/`; old audited head df32227 evidence `integration-df32227/auditor/`.

The new witness is a new fact and a distinct root cause; it is not permission to patch the 80px example or one line count. The supported class includes mixed run sizes and the plan's permitted wrapping when a marked phrase cannot fit a narrow phone.

## Work

1. Reproduce R3-F1 yourself in fresh documents, with the no-rotation, unmarked and base controls. Record root cause with file:line and real used-height/scroll measurements. Keep failed probes and diagnostic live-style changes separately; Chrome 156 may retain stale scrollWidth after dynamic transform removal.
2. Research and implement the general supported-class correction, test-first. Use primary sources and browser experiments where behavior is uncertain. Do not assume one inherited line height equals the rendered marked span; do not hardcode fixture strings, font sizes, overflow amounts, angles or line counts. Preserve marked text styles/layout, Figma paint order, timing, constant stroke weight and design-width geometry. AC9 still requires visible ink surrounding its words (or underline below), not merely a fitting scrollWidth or a hidden/clipped drawing. Preserve all existing uniform-text and earlier positive/negative cases.
3. Add the new mixed-size/wrapping combination to the approved named AC9 browser test, `the mark stays around its words at every width as the heading rewraps`, and prove red on the incoming faulty source, green with the correction. Retain the approved ten-width sweep, both edges, turned marks and paint-order controls. Add meaningful unit/mutation coverage and conservative class-level controls; tests must exercise behavior rather than repeat the formula.
4. Once the correction is ready for integration (do not hold a global lock just for initial research), acquire the established merge lock as `headline-marker` **before the next rebase and integrated gates**, per the project procedure after two main advances. Confirm a completed exit 0 and read actual ownership; a background session is not acquisition. Preserve diagnostics and never delete or release another owner's lock, repair the shared helper, or force/stash/discard main edits. On timeout/stale/conflicting ownership, report the holder and preserve work.
5. Under that valid lock, rebase onto the coherent latest **local** main (last observed 979c5b3). Keep both feature additions, HANDOFF sections and semantic links. No fetch/pull or branch push. Verify the complete combined changes, not only src/test equality if final commits include other paths. If conflict resolution needs a product decision or changes behavior beyond this correction, stop with evidence/options. Recheck any new integration source affecting this class.
6. Run the required final integrated gates: npm check, npm corpus, headline-marker browser file, full browser suite compared by full names with the exact new integration base, mapped corpus-backed unit/performance checks in fresh git-archive copies, and the four approved replay pairs (hydraulics, GRO, scratch debug-page-1, brainstorm: payload/HTML/warnings). Available Hydraulics/GRO complete corpus reports, fonts and output files retain their no-regression contract relative to the new base. Record runtimes, raw logs, explicit exits, source pins and screenshots. Existing three legacy Mac inputs remain unavailable, and earlier baselines had 12 font failures/one Mac-only skip; compare the actual new base rather than assuming old counts.
7. Preserve raw and retried browser results accurately. Fixer 3's raw extra Inter-load leaf/parent failed, then its unchanged complete-file retry passed 30/30; reviewer independently validated all source hashes and name multisets and itself ran head/base with exactly the same original 12 failures and one skip. This does not waive a new failure. Existing builders.ts split remains deferred; AC5/AC6 companion-test mappings remain informational, not reported behavior failures.
8. Consolidate all owned plan/ledger/HANDOFF records before handback, including final integration pins, test evidence, rulings and paste-check collision handling (take the next free number on coherent main if 3bo conflicts). Do not alter the immutable approved plan or live tags. Commit by file after passing tasks with configured Justin <issajustin04@gmail.com>, plain git commit, no AI trailers or author override; inspect staged paths each time, with no CLAUDE.md, AGENTS.md, debug JSON or unrelated edits.
9. Return a clean final candidate ready for review. If safely holding the merge lock through this successful handoff, state exact ownership and keep it for the orchestrator's review/verification/release continuation; root will own eventual release. Release your own lock on failure/stop paths and read back ownership. Never release another feature's lock. Main source stays unchanged by you.

If the original CSS-only contract cannot be met without a real product/transport tradeoff, stop with concrete researched options and evidence; do not silently change acceptance wording, invent an unsupported emitter, remove styling or shrink the words to hide the failure. The user authorized ordinary general fixes, not an unreviewed product redesign.

Machine: `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Use explicit workdirs; record actual runtime versions/paths. Await long gates with complete logs and separate actual exits, not a wrapper's final copy/echo. Terminate only processes proven yours. Setup sync remains blocked by the read-only setup repository even with escalation; do not bypass it.

## Report

Return `{status:ready-for-review|stopped, head, base, integration_tip, finding_disposition, root_cause, changes, tests_red_green, gates, shots, records, lock, rulings, deferred, skill_lessons:[{skill,lesson,evidence}]}`. Further behavioral changes require fresh focused review, then new verifier → blind auditor → ac-check; no release yet. List only new reusable proven lessons, normally empty, and never edit skills/memory. Send milestone checkpoints to root when possible. End with `MAIN SESSION: check and save these skill_lessons now.`
