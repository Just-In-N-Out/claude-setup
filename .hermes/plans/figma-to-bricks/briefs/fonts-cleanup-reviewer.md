# Brief: REVIEWER (review only) for figma-to-bricks feature "fonts-cleanup" (B1)

- Worktree `~/Documents/FigmaToBricksV2/.claude/worktrees/fonts-cleanup`, branch `worktree-fonts-cleanup`, tip `e074aaa`. Review `git diff main...HEAD`.
- Plan `~/.hermes/plans/figma-to-bricks/fonts-cleanup.md` (Justin: 1B 2A, then "move on": item 1, the duplicate Google loading, is deferred and NOT in this build). In scope: item 2 (missing-weight notes name what the paste supplies, no substitution), item 3 (a static upload skipped when a site variable face covers it), item 4 (regression tests that each text keeps its Figma weight against a body weight).
- Builder's claims to verify: check 1335; browser 133/136 (3 known stale panel tests); corpus pastes byte-identical; covered static upload POSTs 1→0; evidence in `~/.hermes/plans/figma-to-bricks/evidence/fonts-cleanup/`; its ruling: Google Fonts off keeps the "not checked" rows.
- Load `skill_view('figma-to-bricks')` (REVIEWER role; `references/rules-summary.md`, then only the CLAUDE.md sections on fonts / site fonts / font weights). Load `skill_view('requesting-code-review')` (report only; never apply auto-fix). Say you loaded both.
- Check the test stand-ins answer the way WordPress/Google really do (not what the code expects), the notes never promise a weight the paste doesn't supply, and no weight range is ever written. Run the gates yourself, try mutations on the new guards.
- Note: frame-text-links (merging now) also took paste check 3ag; the finisher will renumber this one.
- Change nothing: no commit, push or merge; restore anything you touch. Never write to the live site. Other bugs: `found_else`.
- Output: verdict, findings[{id, severity, introduced, claim, evidence}]. Plain words.
