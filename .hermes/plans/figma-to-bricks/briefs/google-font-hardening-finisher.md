# FINISHER: google-font-hardening (descriptor-only)

Worktree ~/Documents/FigmaToBricksV2/.claude/worktrees/google-font-hardening, branch worktree-google-font-hardening, tip 2949800. Plan ~/.hermes/plans/figma-to-bricks/google-font-hardening.md. Range emission stays OPEN/DEFERRED; don't touch it or claim it.

Load skill_view('figma-to-bricks') (FINISHER), receiving-code-review, git-commit-rules, test-driven-development; say you loaded them.

## Fresh Sol reviewer: request_changes, one finding (verbatim)
R1 — medium, introduced: "The new reserved-word check rejects valid unquoted multiword family names, introducing false missing-font claims."
- src/ui/fonts.ts:45–46 checks every identifier against reserved keywords, so Noto Serif, Example Serif and Example math are rejected because one word matches serif or math.
- Chrome's @font-face parser accepts unquoted Noto Serif and Noto Sans Math. For Noto Serif 800 the original loader returns confirmed supplied metadata, no missing face; 2949800 returns supplied: [] and missing: ["Noto Serif 800"]. Accepted CSS and the single GET unchanged.
- Reviewer's regression.test.mjs passes 3/3 on original source, fails 3/3 on 2949800. Evidence: ~/.hermes/plans/figma-to-bricks/evidence/google-font-hardening/reviewer/.
- Not seen in the six captured Google responses (they quote family names) but violates the plan's valid-unquoted-family requirement.
- Requested change: correct reserved-keyword handling without banning reserved words inside otherwise valid multiword names (CSS only reserves generic-family keywords / CSS-wide keywords as the WHOLE name or first identifier per spec — check CSS Fonts 4 §2.1.1 saved in planner evidence css-fonts-4.html). Add positive controls for these families; keep malformed-delimiter and genuinely invalid-family rejection.

Reviewer gates otherwise green: focused 149/149, check 1562/1562, browser 146/149 (3 stale, since fixed in .12), 6 validator mutations caught, 164 real Google blocks unchanged, corpus identical.

## Then finish
- Fix R1 test first (use the reviewer's regression cases as red tests), verify, commit.
- Main is now build 2026-10-21.12 (9334c37; test-cleanup fixed the 3 stale browser tests, so browser should be all green). Rebase, rerun npm run check, npm run test:browser, npm run corpus; compare full pastes/HTML/lint/heights/font status, not counts only.
- Merge lock, ff-only merge, BUILD bump from actual main (next after .12, check), npm run build, commit `Build <BUILD>: Google font hardening`, push main, verify main = origin. Release lock on every path.
- CLAUDE.md: standing permission; if the write is denied, don't retry: save exact edits to ~/.hermes/plans/figma-to-bricks/google-font-hardening-claude-md-pending.md (build line last). The main chat is applying older pending files (.9–.12) now: re-read before any edit, never overwrite them.
- found-else.md: re-read first, then mark ONLY the malformed descriptor line (google-partial-fonts reviewer section, "Low (pre-existing): fonts.ts:41–47 descriptor validation…") `~~…~~ ✅ fixed in build <BUILD> (google-font-hardening)`. Leave the range line open with a pointer to this plan.
- No paste check owed. Remove worktree/branch after merge; kill only orphaned Chrome.
- Other running work (layout-floors Opus, text-link-followups Sol, photo-hover-glass planner) is not yours.
Return status, build, last_commit, summary, closed_items, found_else, pending_docs. Plain words.
