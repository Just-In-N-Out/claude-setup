# FIXER — photo-hotspots, blind-audit finding round 1

You are a fresh fixer. Verify the independent audit finding, then repair it test-first. Own only `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/photo-hotspots` on `worktree-photo-hotspots`, and your own `/home/justin/.hermes/plans/figma-to-bricks/evidence/photo-hotspots/fixer-audit-1/`. You are not alone in the repository: preserve others' edits and commits, do not touch sibling worktrees/evidence/processes, main, BUILD or the existing roles' receipt files. Do not spawn agents, push, rebase, stash or edit skills/memory. Always set workdir explicitly.

## Pins, plan and role skills

Candidate before this fix: `55f265aab4befefe9600dafc5c74a69adb25aab2`, base `388191d0a00c5cb6d1885b3b734db91acd3b49a7`. Confirm both and a fully clean status first. Approved plan: `/home/justin/.hermes/plans/figma-to-bricks/evidence/photo-hotspots/plan-approved.md`; current recorded acceptance/rulings: worktree `docs/plans/2026-10-26-photo-hotspots.md`, including review rounds 1 and 2. AC1–AC12 remain the criteria; AC12 stays live, paste check 3bp.

Load `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its rules summary plus rendering-validation reference, then `engineering-best-practices`, `receiving-code-review`, `systematic-debugging`, `test-driven-development`, `mutation-testing-discipline` and `git-commit-rules` from `/home/justin/.agents/skills/`. Follow architecture and general-logic rules; no hardcoded design values.

## Finding to verify

The blind auditor's status reports a non-live failure in **revised R11 / AC5**. All eleven named AC tests pass, but a calibrated generic flowing-text probe fails at 390 and 320, with and without clipping: a 457x304 photo, 425x192 flowing text that fits at design width. At 320, photo height 191.58 while words need 307; words bottom 415.39 exceeds photo bottom 287.97. A rounded clipping photo cuts those words. These dimensions are reproduction data only, never production selectors or constants.

R11 already says every hotspot photo keeps its drawn shape as a **floor**, and flowing words may grow it. Preserve that accepted behavior rather than weakening the criterion, changing fonts, shrinking the words or adjusting the oracle to conceal the failure. The named AC5 test needs coverage of this valid growing-content case.

Auditor receipts: `evidence/photo-hotspots/auditor/flow-floor-repro.log`, `flow-floor-measurements.json`, `flow-floor-12-320.png`. The orchestrator will append the final audit report and precise finding before dispatch; do not infer final audit acceptance from this preliminary status.

## Work and gates

1. Re-run the auditor's exact probe in your own fresh scratch area to verify the finding, recording the current failure and its source-level root cause. Preserve original receipts and archive your own reproducible script in your evidence folder.
2. Write meaningful generic regression coverage first, ensuring the **named AC5 test itself** exercises this failure. Prove RED before the fix, then GREEN after it; independently challenge the fix with a targeted scratch mutation. Preserve existing shape, placement, crop, card and interaction controls. Diagnose any new failure before patching.
3. Fix the general rule within the existing pipeline and typed CSS architecture. Keep ordinary designs and all prior review fixes intact, including clipping original photo paint while cards hang outside, nested media staying still, and overlay link guards. Split helpers if required by the small-module rule. Do not silently change approved semantics or add a live tag.
4. Run the authorized project gates on the final candidate: whole `npm run check`, `npm run corpus` with missing-path outcome qualified, hotspot browser file with zero skips, full browser suite compared by test name against the pinned base, adapted available corpus-backed checks in independent archive trees, and the four payload/warnings/full-HTML replay comparisons. Distinguish recorded baseline font failures and missing v1 files from new results. Do not claim standard corpus measured files when its Mac paths do not resolve. Record actual executable, runtime, full logs and each true exit.
5. Update HANDOFF, the plan copy's ruling clarification only if needed, and the existing ledger with the root cause, fix, RED/GREEN/mutation evidence, actual gates and live AC12. Commit passing feature-owned work with plain personal Git identity, no AI trailers/author overrides and no CLAUDE.md/debug JSON staged. Stop `ready-for-verify` with the exact new HEAD, fully clean.

## Isolation and reporting

Create a fresh scratch parent with `mktemp -d` and a `photo-hotspots-fixer-audit-1` child using `mkdir` without `-p`; never reuse another role's scratch. Use `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Track long gates with true exit markers and short polling calls; preserve complete receipts. Keep concise current-stage/status.txt progress in your evidence folder. Main owns the next fresh verifier and blind auditor.

Codex pipeline role: gpt-6.1-sol at xhigh. Setup sync is unavailable even with escalation because its repository is mounted read-only; preserve local records without bypassing it. If the finding is invalid, push back with reproducible evidence; do not change code to satisfy an invalid claim.

Return `{status: ready-for-verify|stopped, head, findings[{id, verdict, root_cause, change, evidence, commit}], gates, rulings, ac_status[], found_else[], skill_lessons[{skill, lesson, evidence}]}`. Empty skill_lessons is normal; never edit skills or memory yourself. End with `MAIN SESSION: check and save these skill_lessons now.`

## Final audit and acceptance result (authoritative dispatch addition)

The auditor has finished: verdict `findings`, sole finding **F1 (medium), AC5 / revised R11**, source `src/core/style/hotspots.ts:84`, "Flowing words cannot grow the hotspot photo". The valid paragraph fits at design width, but at 320 the photo remains 288x191.58 while its words need 307px and extend 127.42px below it. Rounded clipping cuts them. The auditor found that changing flex-wrap did not fix it; disabling aspect-ratio locally allowed the photo to grow to 331px. Treat that as diagnosis evidence, not a prescribed implementation. Named AC5 misses it because the existing flowing words are only "Spots to check".

Reproduce exactly: `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b node --test /home/justin/.hermes/plans/figma-to-bricks/evidence/photo-hotspots/auditor/flow-floor-repro.mjs`. Also read `flow-floor-diagnosis-measurements.json` with the other listed receipts.

Both reports are available: `/home/justin/.hermes/plans/figma-to-bricks/evidence/photo-hotspots/verifier/ac.json` and `/home/justin/.hermes/plans/figma-to-bricks/evidence/photo-hotspots/auditor/ac.json`. All other non-live ACs are accepted by both. Main's actual `ac-check.sh` result:

```text
AC5  NOT ACCEPTED: auditor did not accept it
AC12  NOT VERIFIED (live: the user checks it)
NOT ACCEPTED: 1 of 12 ACs on 55f265a
```

This is the first fix attempt for this newly discovered failure. The audit's full browser pair has identical twelve failures and one skip by name, with the five hotspot passes added; available hydraulics/GRO corpus reports and four replay pairs match. Skill lessons returned empty, so none was saved. Finish the scoped fix and full authorized gates, then return the committed clean candidate for a new independent verifier and blind auditor.
