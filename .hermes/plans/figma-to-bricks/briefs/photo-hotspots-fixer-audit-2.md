# FIXER — photo-hotspots, second blind-audit findings

Fresh fixer. Independently verify the blind auditor's findings, fix valid ones test-first, and return ready-for-verify. Own only the minimal hotspot note/visibility/clipping logic implicated by the findings, meaningful generic regression tests/fixtures, this feature's plan/HANDOFF/ledger records, and your new evidence folder. You are not alone: preserve concurrent edits and commits, never revert others' work or touch sibling worktrees/evidence/processes. Main remains read-only. Do not rebase, merge, take a release lock, bump BUILD, push, remove worktrees, spawn agents or edit skills/memory.

## Pins and authority

- Worktree `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/photo-hotspots`, branch `worktree-photo-hotspots`, expected clean HEAD `e5ca6a261d6d9380d371e3c20d3c6266e3ac6850`.
- Integration base/main `5e2f98bff77fa1d214b7d76968a54a6dafa32ca6`. Check both pins and cleanliness; stop on an unexpected revision rather than silently changing the baseline.
- Immutable plan `/home/justin/.hermes/plans/figma-to-bricks/evidence/photo-hotspots/plan-approved.md`; later accepted rulings in worktree `docs/plans/2026-10-26-photo-hotspots.md`.
- Read the final blind report/AC receipt `/home/justin/.hermes/plans/figma-to-bricks/evidence/photo-hotspots/auditor/round-3/ac.json` and exact repro evidence named there. There is no separate report.json. The completed handback facts are below. Do not infer acceptance from earlier verifier reports.
- Own evidence `/home/justin/.hermes/plans/figma-to-bricks/evidence/photo-hotspots/fixer-audit-2/`. Keep complete raw logs, actual exits and concise `status.txt` milestone updates.

## Skills

Read `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its rules-summary/rendering-validation references, then engineering-best-practices, receiving-code-review, systematic-debugging, test-driven-development, mutation-testing-discipline for any corrected guard, and git-commit-rules from `/home/justin/.agents/skills/`. Project and session instructions win over older contradictory skill details. Do not edit any skill or memory.

## Findings and intended scope

The auditor reports confirmed failures of AC1 (distinct photo boxes with the same name lose one required panel note) and AC6 (a hanging card re-clips during the specified hide grace). Verify each from its actual report and reproduce with your own generic controls before changing code. Reject an invalid finding with evidence. Do not change ACs or the approved behavior to make an oracle pass.

- AC1 requires one note per eligible photo, even when names repeat; preserve sensible de-duplication for repeated traversal/copies, unsupported-layer notes, deterministic output and existing unmarked preservation. Do not hardcode names, IDs or this user's file.
- AC6 requires the card to remain fully shown while crossing the trigger/card gap and during its existing closing grace/fade, with original photo paint still cropped and hidden cards eventually noninteractive/unread. Cover a hanging card on a clipping photo with meaningful intermediate-time geometry/visibility/hit controls, at rest/open/closing/closed, and reduced motion. Keep the established CSS-only policy unless a real owner decision is needed; do not invent a new close policy or alter timings.
- Preserve ratio-floor/paragraph growth, fixed and HUG photo widths, original rounded crop holders, keyboard/touch behavior, trigger/card adjacency and copies, nested links, overlay/page-link guards, flip/slider/label-floor integration and the committed browser lifecycle correction. Keep every changed source module about 300 lines or less with real responsibility boundaries.

## Work and validation

1. Capture a reproducible RED for each valid finding, implement the smallest general correction, then GREEN. Prove each regression rejects the exact old source or a meaningful causal mutation. Include nearby negative/preservation controls rather than implementation-mirroring assertions.
2. Run relevant focused checks plus the full `npm run check`, standalone hotspot browser file with zero skips, sandbox/type/build and source-size gates. Run the normal complete browser package on head and canonical base, comparing complete package/file/hierarchy case occurrences and results by name. Run available mapped corpus units/performance and measured reports; record standard corpus's honest missing-input result. Compare the four real-file replay payloads/warnings/full HTML against actual base5e2f98b; these unmarked designs must remain identical.
3. Original G4 requires full browser comparison **by test name**, no candidate-only regression/missing cases, and hotspot skipped0. It does not impose an absolute historical failure cap on old base. Last verifier's actual head391/378pass/12fail/1skip and base386/372pass/13fail/1skip both exited1. All candidate failures were the known font cases also on base; one additional base-only autoplay failure had UNKNOWN cause. A passing bounded control did not replace that run or prove hotspots fixes autoplay. Preserve current actual results and any execution variance honestly; never retry unchanged suites until green or rewrite old results to equal historical totals.
4. Pin `/home/justin/.local/node-v22.23.3/bin/node` (v22.23.3), prepend its bin directory to PATH for npm children. Create your own fresh launcher and set CHROME_PATH to it:

```sh
#!/bin/sh
exec /home/justin/.cache/chrome-for-testing/chrome-f2b --disable-software-rasterizer "$@"
```

Same Chrome156 CPU/CSS profile on both sources. In a separate base archive overlay **only** head's `test/browser/chrome.ts` lifecycle driver, retaining canonical base production/original assertions/rendering/hooks/timeouts. Name the driver overlay and CPU/CSS qualification; no GPU/WebGL/Safari/installed-Bricks claim. For focused new-test sensitivity, copy only needed new tests/fixtures/support into isolated old-source trees and show an intended behavior assertion failure, not setup failure. Preserve prior capped/failed receipts.
5. Update this feature's HANDOFF, plan copy's rulings/execution note and existing ledger with the findings, corrections, causal proof, actual gates/qualifications. AC12 remains live, **paste check3bp**, including Figma Manual offset and actual iPhone behavior. Do not claim final acceptance or release. Commit passing owned changes on this branch using configured personal identity, plain commit with no AI trailer/author override. Check staged paths: no CLAUDE.md or debug JSON. End clean and ready-for-verify with exact HEAD.

## Execution isolation and handback

Create a fresh `mktemp -d` parent and `mkdir` without `-p` for your work area; never reuse another agent's scratch. Always explicit workdir. Keep each gate/capture/comparison's actual exit and full output. Track owned processes through their session handles; isolated exec namespaces can reuse PIDs, so do not signal invisible saved PIDs or globally terminate Chrome/Node. Distinguish observed controller exit from an unobserved child exit. No cleanup of durable evidence or other workers' files.

Setup sync remains read-only even with escalation; retain local records without bypass. Role model gpt-6.1-sol at xhigh. Return `{status: ready-for-verify|stopped, head, base, findings[{id,valid,fix,test,causal_proof,commit}], gates, ac_status, qualifications, found_else, skill_lessons[{skill,lesson,evidence}]}`. Empty lessons are normal. End `MAIN SESSION: check and save these skill_lessons now.`

## Final auditor handback and real acceptance check

- F1 / P2 / AC6, `src/core/style/hotspots.ts:80`: radius12, Instant timing, third dot at1440; move into its8px gap. At20ms the card remains opacity1/visible while photo overflow is hidden; center/bottom hits fail and the image clips. Auditor repro `round-3/crossing.ts`; `crossing.log`, `crossing-on-dot.png`, `crossing-gap.png`.
- F2 / P3 / AC1, `src/core/understand/hotspots.ts:20`: two distinct same-named Photo boxes create six correct cards but one final panel warning. Auditor `round-3/generic-cases.test.ts`, `generic-cases-final-panel.log`, `ac1.png`.
- All11 exact named head tests passed, so the named tests alone do not cover these combinations. AC2–5 and7–11 were accepted; AC1/6 rejected; AC12 live3bp. G1/G2/G3/G5 completed. Auditor's full head browser391/378pass/12fail/1skip/zero cancellation; base comparison incomplete and mapped gates unlaunched after requested early handback. Those missing runs are not passing proof.
- Actual ac-check with verifier4 and auditor3 receipts, canonical base5e2f98b and approved plan returned exit1: `AC1 NOT ACCEPTED: auditor did not accept it`; `AC6 NOT ACCEPTED: auditor did not accept it`; last line `NOT ACCEPTED: 2 of 12 ACs on e5ca6a2`. No schema/pin errors.
- Reusable hover-grace/ancestor-clipping lesson has been checked and folded into rendering-validation.md by the orchestrator; do not save it again. Cleanup status for the auditor's already-launched bounded browser runner will be appended before dispatch. Never touch its scratch/processes.

Cleanup follow-up settled: `auditor/round-3/cleanup-status.json` records natural base child exit1, 386 tests/373pass/12fail/1skip/zero cancellation and the controller's post-child final completion marker. The controller's exact exit was not directly recovered, so do not invent it. No later commands remain. No rerun or omitted gate was launched; original ac.json is unchanged. Your execution may now start in its own fresh scratch.
