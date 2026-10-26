# REVIEWER only: google-font-hardening

Load skill_view('figma-to-bricks') REVIEWER and skill_view('requesting-code-review') report-only, never auto-fix; say you loaded them. Fresh reviewer; never seen this code.

Worktree ~/Documents/FigmaToBricksV2/.claude/worktrees/google-font-hardening, branch worktree-google-font-hardening, tip 2949800ee02b2994ab0d2e5c53e7b3522cddf8a0. Plan ~/.hermes/plans/figma-to-bricks/google-font-hardening.md. Review git diff $(git merge-base main HEAD)...HEAD.

Scope: DESCRIPTOR-ONLY. Malformed family delimiters / style descriptors ('oblique nonsense', mismatched family quotes) must no longer certify coverage. Range emission (`font-weight: 100 900` reaching paste CSS) is explicitly DEFERRED and must remain open: do not count its absence as a finding, but do flag if the change claims to have fixed it or changes range CSS/metadata.

Builder claims: only src/ui/fonts.ts + new test/unit/ui-google-font-descriptors.test.ts (90 tests); original loader fails 46 new tests; focused 149/149; check 1562/1562; browser 146/149 (3 known stale upload-name tests, test-cleanup's); corpus 5 pastes/HTML byte-identical, full lint/heights/fonts equal across 29 widths, 17 known identities; CSS and GET counts unchanged (1→1, retries 3→3); site coverage still wins. Evidence ~/.hermes/plans/figma-to-bricks/evidence/google-font-hardening/builder/.

Check hard:
- No false-missing regressions: valid quoted/unquoted/Unicode families, escaped/opposite quotes inside a quoted string, normal/italic/bare oblique, valid oblique angles (signed, fractional, units deg/grad/rad/turn) still certify. Look at real Google CSS shapes (saved responses in planner/builder evidence; read-only public GET allowed) and confirm nothing Google actually returns is now rejected.
- Malformed block yields no supplied face but valid companion blocks in the same answer still count; raw CSS byte-identical; request counts unchanged; B8 coverage logic intact.
- Tests aren't tautological; try mutations on the validator.
- 90 tests for a small validator: check they aren't redundant noise or slow.

Change nothing: no commit/merge/push; restore mutations; no live-site writes. test-cleanup finisher and text-link-followups builder are running in other worktrees: leave them alone. Other bugs: found_else only.

Output: verdict pass/request_changes, findings [{id, severity, introduced, claim, evidence}], found_else, gate results. Plain words.
