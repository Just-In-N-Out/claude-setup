# font-reporting-tests — fresh REVIEWER brief (2026-10-21 20:37 EDT)

Review only. Worktree ~/Documents/FigmaToBricksV2/.claude/worktrees/font-reporting-tests, tip 1e29966. Review `git diff main...HEAD` (main 5e32aec, build .22) against the approved plan ~/.hermes/plans/figma-to-bricks/font-reporting-tests.md and briefs/font-reporting-tests-builder.md.

## Built
- Metadata reader in fonts.ts/google-faces.ts now reuses the shared typed declaration scanner instead of a first-match regex (it falsely reported 400 where Chrome uses 700): validates every present weight, takes the last supported repeat.
- Projection stays strict (duplicate/escape/raw-text safeguards, .13 validation, .21 raw/executable no-range safeguards); accepted static CSS and request policy unchanged.
- Readable comment-range confirmation now emits only covered requested numeric copies — check this is within the approved plan and does not unblock unapproved range faces.
- Isolated unit tests + built-panel browser tests; approved stale-test updates.
- Builder gates: check 1875+6, browser 205/205, focused 261/261, corpus/debug identical, 11 mutants killed + 1 documented equivalent.

## Check
1. The real rebuilt panel's rows, notes, copied payload and request trace — not just Node metadata.
2. Comment-hidden / fake-first-match descriptors, escaped names, !important, repeated weights.
3. Stale-test updates only remove the old parser limitation, nothing else.
4. No parser dependency, run/main/renderer/loader-dedup/font-provision changes.

Known, NOT a finding of this feature: Garamond Condensed missing on main and branch (pre-existing font gate; release hold is handled separately). Never substitute or narrow the expected font set.

Change nothing: no commit, push or merge; restore anything you touch. Stagger heavy Chrome runs (other agents active).
