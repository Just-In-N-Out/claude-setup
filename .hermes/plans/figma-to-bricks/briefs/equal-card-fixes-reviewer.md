# Brief: REVIEWER (review only) for figma-to-bricks feature "equal-card-fixes" (B4)

- Worktree `~/Documents/FigmaToBricksV2/.claude/worktrees/equal-card-fixes`, branch `worktree-equal-card-fixes`, tip `6816663`. Review `git diff main...HEAD`.
- Plan `~/.hermes/plans/figma-to-bricks/equal-card-fixes.md` (Justin: Q1A — R5 is NOT in this batch, it's layout-floors'; Q2A — centred row cards keep their drawn bottom padding). The recheck this answers: equal-card-heights items R1–R7 in `~/.hermes/plans/figma-to-bricks/found-else.md`. Planner's tools/probes: `~/.hermes/plans/figma-to-bricks/equal-card-fixes-tools/`.
- Builder's claims to verify: Justin's pages (hydraulics, Services, Repairs on-disk debug copy, inspo-brainstorm) byte-identical to main; design gets one flex-grow 0 on a Button at tablet, nothing moves; check 1325; browser 134/137 (3 known stale panel tests); 26 mutations caught, S3/B14 named equivalent; four dead checks deleted with proofs (its rulings).
- Load `skill_view('figma-to-bricks')` (REVIEWER role; `references/rules-summary.md`, then only the CLAUDE.md sections on equal cards, rows stacking, bottoms, size.unpin). Load `skill_view('requesting-code-review')` (report only; never apply auto-fix). Say you loaded both.
- Run the gates yourself, replay Justin's files and cmp, measure the probe designs in Chrome at 1200/990/768, try mutations; check the deleted guards really are unreachable. Don't trust summaries.
- Parallel: cta-label-wrap is building (adapt/layout.ts, least.ts, unpin.ts); layout-floors builds after this (shares adapt/rules/rows.ts).
- Change nothing: no commit, push or merge; restore anything you touch. Other bugs: `found_else`.
- Output: verdict, findings[{id, severity, introduced, claim, evidence}]. Plain words.
