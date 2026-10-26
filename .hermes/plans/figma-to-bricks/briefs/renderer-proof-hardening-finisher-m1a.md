# renderer-proof-hardening — FINISHER brief after M1A (2026-10-22 01:30 EDT)


## Justin's answer M1A (2026-10-22 ~01:30 EDT)
Justin's words: "Now for M1A, just go with A ... Just keep running them."
Release this feature with the Garamond Condensed font check marked explicitly: "UNVERIFIED — pre-existing on main (Times-Roman shown on both main and branch); genuine licensed font not available; no stand-in substituted, expected font set NOT narrowed". This waives ONLY the release hold on that one pre-existing font gate, for this release. Every other gate stays (rebase, check, test:browser, corpus vs baseline with loaded-family comparison, merge lock, ff-only, build, push, verify). Record the waiver in HANDOFF, ledger and the report. W-B (wrapped-row least) stays deferred: Justin unsure.

## Context
Worktree ~/Documents/FigmaToBricksV2/.claude/worktrees/renderer-proof-hardening. Main is now 29325e4 (build 2026-10-22.1); paste checks 3aw–3az taken, responsive-pill-planning holds provisional 3ba and merges after 02:20. Earlier briefs for this feature: ~/.hermes/plans/figma-to-bricks/briefs/renderer-proof-hardening-*.md and the plan renderer-proof-hardening.md. Three Sol finishers run at once (media-rename-collision, font-reporting-tests, renderer-proof-hardening): the merge lock serializes; rebase each time main moves; stagger heavy Chrome/corpus runs.

State: tip 9c91bed; review fixes recorded (R1 CSS family Unicode caseless, R2 all-current-files font gate); check 1797+6 / browser 181 / focused 91+34 at that base. Read briefs/renderer-proof-hardening-fixpass.md and -reviewer.md and the ledger first; confirm the fresh review's findings were all addressed before merging (if any remain unaddressed, stop with them).
