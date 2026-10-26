# font-reporting-tests — FINISHER brief after M1A (2026-10-22 01:30 EDT)


## Justin's answer M1A (2026-10-22 ~01:30 EDT)
Justin's words: "Now for M1A, just go with A ... Just keep running them."
Release this feature with the Garamond Condensed font check marked explicitly: "UNVERIFIED — pre-existing on main (Times-Roman shown on both main and branch); genuine licensed font not available; no stand-in substituted, expected font set NOT narrowed". This waives ONLY the release hold on that one pre-existing font gate, for this release. Every other gate stays (rebase, check, test:browser, corpus vs baseline with loaded-family comparison, merge lock, ff-only, build, push, verify). Record the waiver in HANDOFF, ledger and the report. W-B (wrapped-row least) stays deferred: Justin unsure.

## Context
Worktree ~/Documents/FigmaToBricksV2/.claude/worktrees/font-reporting-tests. Main is now 29325e4 (build 2026-10-22.1); paste checks 3aw–3az taken, responsive-pill-planning holds provisional 3ba and merges after 02:20. Earlier briefs for this feature: ~/.hermes/plans/figma-to-bricks/briefs/font-reporting-tests-*.md and the plan font-reporting-tests.md. Three Sol finishers run at once (media-rename-collision, font-reporting-tests, renderer-proof-hardening): the merge lock serializes; rebase each time main moves; stagger heavy Chrome/corpus runs.

Review findings: fresh Sol high APPROVE 1e29966; one low nit: extra EOF blank line in docs/plans/2026-10-21-font-reporting-tests-ledger.md:36 makes `git diff --check main...HEAD` exit 2 — remove it. Evidence evidence/font-reporting-tests-review/.
