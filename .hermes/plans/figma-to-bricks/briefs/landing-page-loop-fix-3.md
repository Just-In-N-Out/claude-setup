# landing-page-loop — fix3, transparent glyph acceptance

You are a fresh FIXER. Worktree `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/landing-page-loop`, branch worktree-landing-page-loop; starting reviewed head `ab3b5c4f4f207c3077275b247cdcc0afb51c3c7a`; story/merge-base `c67128c4cca8eff67afdf3f7e6e8b28a75294deb`, integration local main. Check clean identity first. You are not alone: preserve others' work. No agent spawning, rebase, merge, push, BUILD bump, main-folder edits, Figma/WordPress writes, or shared skill/memory edits.

Approved plan `/home/justin/.hermes/plans/figma-to-bricks/evidence/landing-page-loop/plan-approved.md` (SHA256 `541f68d6bfb8fa39a442cdfabc728bcea0aecd0186b7285cdef4db4b60c2ec77`). E is `/home/justin/.hermes/plans/figma-to-bricks/evidence/landing-page-loop`. Own E/fix-3/ and only the implicated test/browser/text-visibility.ts audit helper, its directly required generic test/fixture support and story inventory wiring/records within the existing plan. This finding is an acceptance-audit defect, not evidence that the ordinary plugin output currently hides text. Do not expand into unrelated production changes. If a genuine new owner/policy is needed, report evidence and scope before changing it.

Load project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, then engineering-best-practices, receiving-code-review, test-driven-development, mutation-testing-discipline and git-commit-rules from `/home/justin/.agents/skills/`. Load systematic-debugging for unexpected failures. Read worktree CLAUDE.md and review-loop.md. User/global/project instructions override conflicting defaults.

## Finding and referee

Read E/review-3/review.json and report.json, all cited probes, earlier review records and fix responses. Independently verify R3-1 before fixing it; provide evidence for any rejection. Root referee output, verbatim:

```
R3-1  P2  test/browser/text-visibility.ts:25  The strengthened text inventory still reports fully transparent glyphs as painted  (repeats R2-3)
REVIEW AGAIN: 1 P0-P2 finding(s) in review-3 at ab3b5c4: fix them, then review the fix commits
```

R3-1 is P2 at test/browser/text-visibility.ts:25, repeats R2-3 with a concrete new fact. The new helper correctly rejects opacity/visibility failures, but color:transparent, zero-alpha color and transparent text-fill still retain hit-tested Range area and are accepted as painted. An unchanged full landing_text_inventory passes all4,075 source/width rows under a phone-only transparent-paint mutation; independent actual browser observation shows missing text. The unmutated positive control passes. The reviewer explicitly requires genuine visible glyph paint while preserving supported outline/gradient text, rather than indiscriminately rejecting intentional transparent fills.

Review3 independently closed R2-1, R2-2 and R2-4 with three-tree/browser probes. Preserve those fixes and the earlier stationary artwork, transformed diagram, compact-menu and media-visibility fixes. Do not weaken the audit, skip invisible layers, replace the source file or add design-specific exemptions.

## Validation scope

Write meaningful generic failing controls before correcting the audit. Reproduce the current surviving transparent-paint mutation on the unchanged named AC, not only a new helper test. Prove the strengthened check rejects the failure for the intended reason, while unmodified source, supported intentionally transparent-fill painted text, legitimate inline runs and reachable responsive/slider copies remain accepted. Keep opacity/visibility/size/clipping and hit/reachability controls effective. Use actual browser glyph/paint evidence and relevant screenshots, not DOM existence or rectangle area alone.

Run the full positive named landing_text_inventory over the plan's25width matrix and all163texts/172runs, with source/config binding. Re-run the relevant existing visibility/inventory browser/unit checks and mutation controls, npm run check and the required available corpus comparison. This is a bounded audit-helper correction: choose browser coverage appropriate to what actually changes. Full-suite verification will run independently before finish; do not repeat unrelated completed gates merely to fill a report, and do not present prior receipts as fresh full-gate proof. If your changes broaden into shared capture/render behavior, first report scope and justify the broader checks. Required final-head checks must run after the source is frozen; preserve actual exits and inherited failures. A complete gate you did not rerun remains unproved in your report.

The latest completed fix2 baseline/head gates had the same3configured-check failures,10full-browser failures and1skip; performance6/6each and available-five corpus28cases each with identical lint. Review2's extra load timeouts did not recur in fix2, cause still unproved. Keep all failed receipts disclosed; never replace a failed complete run with a focused retry claim. Existing runtime list-font proof remains intact.

AC mapping remains unchanged:1navigation,2site-part ticks,3sticky nav,4links,5inset panels,6origins,7labelled diagrams,8review structure,9review interaction,10font measurement,11raw axes,12all text,13media,14geometry,15behavior,16regression gates,17effective font match,18live round trip. Read exact clauses and named tests in the approved plan. This fix directly addresses AC12's missing sensitivity; report other ACs as checked, retained-but-not-rerun, held or live accurately.

AC17 remains required NON-LIVE HELD: designer automatic-optical-size mode is unknown, raw opsz9 does not prove effective mode, and current delivered site fonts lack optical/custom axes. No Task9b implementation, guessed mode or waiver. AC18 remains user-owned live/not run. Free Estimate stays warned/unlinked, reviews stay honest placeholders without invented autoplay, local photos remain stand-ins, adjusted-background and historical-input limitations remain. Justin's keep-going instruction permits continued correction, not acceptance waivers or invented source facts.

## Environment and handback

Node22 `/home/justin/.local/node-v22.23.3/bin/node`; Chrome `/home/justin/.cache/chrome-for-testing/chrome-f2b`; owned wrappers clear DISPLAY/WAYLAND_DISPLAY and use established Linux flags. Read testing-pitfalls and corpus-paths-on-desktop memory. Store large artifacts/profiles in your disk-backed evidence folder, not RAM-backed /tmp. Do not mutate shared dependencies. Base/mutation work stays in isolated owned copies, never in a shared candidate during gates.

Available-five corpus means recovered configured hydraulics/GRO plus extra repairs/brainstorm/Services, never substitutes for three missing old-Mac originals. Historical v1 code/PNGs and Aswatama remain absent; default-path0cases is not coverage. Compare exact source/runtime/harness/input identity before any baseline reuse. Setup sync remains read-only; do not bypass it.

Commit the passing bounded correction and accurate ledger/audit/HANDOFF facts together, with plain git commit and no author overrides/AI trailers/CLAUDE.md staged. Keep the worktree clean and frozen for next review. Report `ready-for-next-review` only after required scope/checks finish; list any unrun complete gates accurately. Do not delay handback for optional scratch cleanup; name owned leftovers.

Write E/fix-3/report.md and report.json: verdict, starting/final head/base, finding verification/fix or rejection with test/evidence/commit, exact outcomes, all18 ac_status and remaining limitations. Return `skill_lessons: [{skill, lesson, evidence, enforce}]` (empty is normal), never edit skills/memory. End `MAIN SESSION: check and save these skill_lessons now.`
