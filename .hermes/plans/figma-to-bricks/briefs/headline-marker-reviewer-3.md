# REVIEWER 3 — headline-marker, fresh focused review after AUD-F1

You are a fresh independent reviewer, report only; do not change the worktree, commit, merge, push, bump BUILD or spawn agents.

Expected clean HEAD: `a364eb54fc8a825e4600481cdc08f788c8d47fcf`.
Expected base/current main: `27b787b78d88850cbb9863bb31fcfc840406331c`.
Correction delta starts at `df32227868452ae93562ad99cad7246e9bc7a52f`.

## Scope and inputs

- Worktree `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/headline-marker`, branch `worktree-headline-marker`.
- Approved immutable plan `/home/justin/.hermes/plans/figma-to-bricks/evidence/headline-marker/plan-approved.md`; read its AC1–AC13 and the committed plan's review-fix amendments. AC13 alone is live paste check 3bo (use any consistently renumbered final record).
- Fresh focused review of the complete AUD-F1 correction delta from df32227 to the supplied final HEAD, and confirm the whole `main...HEAD` feature still holds. This does not replace the later independent verifier or blind audit.
- Fixer brief `/home/justin/.hermes/plans/figma-to-bricks/briefs/headline-marker-fixer-3.md`; fixer evidence `/home/justin/.hermes/plans/figma-to-bricks/evidence/headline-marker/fixer-3/`. Its exact handback/disposition must be added below before dispatch.
- Audit evidence `/home/justin/.hermes/plans/figma-to-bricks/evidence/headline-marker/integration-df32227/auditor/`, especially `counterexample-ac9-turned-edge.log`, `counterexample-ac9-turned-edge.test.ts`, and `edge-overflow-turned-last-320.png`.
- Your evidence only `/home/justin/.hermes/plans/figma-to-bricks/evidence/headline-marker/reviewer-3/`; fresh task-owned `mktemp -d` and `mkdir` without `-p`. Never reuse another role's scratch or mutate the feature worktree for probes; use isolated exports/overlays.
- You are not alone in the codebase. Other chats own unrelated worktrees/evidence/processes and main releases. Never touch them or revert their changes. Observe relevant integration drift, and report it without taking over the other release.

## Skills

Load the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, `references/rules-summary.md` and `references/rendering-validation.md`, then `engineering-best-practices`, `requesting-code-review`, `code-review-practice`, and `mutation-testing-discipline`. Use systematic-debugging for unexpected failures. You are the independent reviewer: skip skill steps that would spawn another reviewer or automatically fix code; main owns those roles.

## Finding and approved contract

AUD-F1 (medium), verbatim: “AC9 fails when a turned ring marks words at a right-aligned heading edge. Viewports 390/375/360/320 produce scroll widths 393/378/363/323. Fresh controls removing only the ring’s rotation fit exactly. The gutter rule must account for rotation, and the named browser test needs this combination.” Reported locations: `src/core/adapt/rules/mark.ts:29`, `src/core/emit/marks.ts:20`.

The named AC9 browser test previously passed despite this combination failing. Root ac-check rejected AC9. Review the defect class, not only the supplied witness. The approved criteria still require the ink to surround its words (or underline below), preserve Figma paint order and supported drawing timing, avoid splitting marked words where they fit, and avoid sideways scroll throughout the approved width sweep. A clipped/missing drawing must not be accepted solely because scrollWidth fits. Keep original/design-width and unmarked behavior as contracted; do not invent product changes or new AC wording.

Chrome 156 can retain stale scrollWidth after a live pseudo-element transform removal. Prove transformed/no-transform controls in separately loaded fresh documents; preserve live-style interventions as diagnostics. The rendering guide now includes this lesson.

Existing coverage notes: AC5's amended size guard and AC6's unchanged-HTML/link/phone containment clauses have companion tests with mutation proof; these were informational mappings, not reported behavior failures. The existing shared builders.ts split and unavailable legacy Mac corpus inputs remain deferred.

## Review work

1. Confirm source pins/cleanliness and the final integration base. Independently reproduce the old witness and execute the corrected named AC9 test; verify red/green causality with exact old source in your own isolated copy. Review the implementation for a general correction and for regressions in the feature's other approved patterns.
2. Run the required project/role gates yourself and preserve exact exits and raw reports. Include the headline-marker browser tests and approved widths (1440/1366/1200/1100/1024/768/390/375/360/320), named-test sensitivity to losing the fix, and appropriate structural/mutation/security/quality checks. Follow the project's corpus/full-browser baseline comparisons; existing 12 font failures and one Mac-only skip are not permission to waive a new difference. Three legacy Mac corpus inputs remain unavailable on WSL; available-file controls must remain honest.
3. Judge each fixer disposition independently. Distinguish introduced regressions, existing limits, unsupported diagnostic controls and actual unmet approved criteria. Report any valid concern with file:line, reproducer, severity and concrete evidence; apply no fix.
4. Finish with source still clean and unchanged. Record runtime paths/versions and only your own process ownership. Long gates need complete logs with explicit exits and actual completion; a wrapper's final copy/echo is not a passing test.

## Fixer handback

Fixer 3 returned ready-for-review. AUD-F1 was reproduced in four fresh phone controls and fixed in `1b2ebc8`; records committed in final clean `a364eb54fc8a825e4600481cdc08f788c8d47fcf`. It reports the old gutter cap bounded the unrotated box, after which rotation pushed corners past the viewport. The correction reserves rotation’s sideways reach before capping. AC9 now covers both edges at ±8°/±16° through all ten widths, with ink, paint order, stroke weight and design-width geometry preserved. AC9 failed on incoming source and passes with the fix; four targeted mutants killed, exact source restored; headline browser 4/4. Eight fixed phone captures cover both edges.

Gates reported: npm check exit 0; mapped unit head 2375 pass/36 skip, base 2339/36, zero failures; mapped performance both 3 pass/3 legacy skips; available corpus reports/fonts/payloads/HTML/screenshots exactly equal, commands exit 1 for unavailable legacy inputs; four replay pairs byte-identical, all eight commands exit 0. Browser base 364 pass/12 fail/1 skip. **Preserved raw head run had 366 pass/14 fail/1 skip**, including an extra Inter-load failure and its parent; a complete-file retry on unchanged source passed 30/30, and reconciled full names match base plus four passing headline tests. Independently verify that classification and raw/retry provenance; do not silently call the raw suite green.

Full report `/home/justin/.hermes/plans/figma-to-bricks/evidence/headline-marker/fixer-3/report.json`; all original/raw failures retained. No new rulings or skill lessons. Source and owned records committed clean. Another chat owns the shared merge lock as slider-autoplay; main remains at the stated base at admission. Do not touch its lock, worktree, evidence or release. Read-only review is authorized now; report relevant main drift if it actually occurs, and never treat another owner's half-finished main as an integration base.

## Report

Return `{verdict: approve|findings|integration-required, head, base, findings:[{id,severity,introduced,claim,evidence}], ac_status:[{ac,accepted,test,screenshot,evidence}], gates, evidence, skill_lessons:[{skill,lesson,evidence}]}`. Report only new reusable proven lessons, normally empty; never edit skills or memory. End with `MAIN SESSION: check and save these skill_lessons now.`
