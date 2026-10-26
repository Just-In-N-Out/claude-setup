# REVIEWER only: text-link-followups (B7)

Fresh reviewer. Load skill_view('figma-to-bricks') (REVIEWER) and skill_view('requesting-code-review') (report only); say you loaded them.

Worktree ~/Documents/FigmaToBricksV2/.claude/worktrees/text-link-followups, branch worktree-text-link-followups, tip 5530e82 (rebased on main 6d65aea / .13). Plan ~/.hermes/plans/figma-to-bricks/text-link-followups.md (Justin N1A), including the "Dispatcher ownership clarification". Review `git diff $(git merge-base main HEAD)...HEAD`.

Four items: (1) a phone number split across styled runs: every slice dials the complete number, styles/characters/designer links/frame-link indices preserved, no nested anchors; (2) recognised opening hours keep their line separators at every width (narrow schedule grammar, negative twins for prose mentioning weekdays/times); (3) N1A: a shared address's note names all distinct labels, counts stay per address; (4) marquee loop copies' inline anchors get tabindex=-1, originals stay Tab-reachable, Tab pauses the ticker.

Test-ownership changes to judge: (a) B3's style-phone-numbers cross-run case updated (authorised); (b) main chat applied 4 legacy expectation lines in convert-text-links.test.ts (31–33, 101, 112) and convert-page-links.test.ts (113–116) to add `labels` / the multi-label note subject (commit 5530e82). Check these are pure N1A consequences, not weakened tests; in particular `labels: ["Gallery"]` where `words: "Gallery Page Final"` — is a single-label list wanted there (plan says avoid an unnecessary list for single-label addresses if it keeps the shape)? Report if it's inconsistent.

Builder claims: 51/51 focused; check 1599/1599 + 6/6 perf (after 5530e82, verified by main chat); browser 157/157; corpus 5/5 pastes/HTML byte-identical, full lint/heights/fonts at 29 widths equal, same 17 identities. Evidence ~/.hermes/plans/figma-to-bricks/evidence/text-link-followups/ (builder-report.json, hours screenshots, Tab sequences).

Check hard: real Tab traversal; hours at actual widths (no overflow/clipping; separator visible; second entry never joins the first's last line); phone hrefs per slice in the final payload; B2 notes/cancel/payload guard and B3 punctuation/emergency wrap preserved; no page-specific logic. Run gates yourself, try mutations.

Change nothing: no commit/merge/push; restore anything; no live-site writes. Other agents (layout-floors, photo-hover-glass reviewer, csv-list-pdfs reviewer) are separate. card-link-words builds after this merges. Other bugs: found_else.

Output: verdict pass/request_changes, findings [{id, severity, introduced, claim, evidence}], found_else. Plain words.
