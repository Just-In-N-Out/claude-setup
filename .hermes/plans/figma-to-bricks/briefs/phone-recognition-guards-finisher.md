# phone-recognition-guards — FINISHER brief (written 2026-10-21 20:48 EDT)

Worktree ~/Documents/FigmaToBricksV2/.claude/worktrees/phone-recognition-guards, tip 5a5acc3, base main .22 5e32aec. Plan ~/.hermes/plans/figma-to-bricks/phone-recognition-guards.md (with the address.ts ownership clarification). Reviewer evidence: ~/.hermes/plans/figma-to-bricks/evidence/phone-recognition-guards/review/ (probe.ts).

## Fresh Opus xhigh review: changes requested (minor)
F1 (minor, regression vs main, P3A invariant), src/core/normalise/card-title.ts:35:
"nameLike drops rejected data only when it shows up in the raw text (rejectedIn(raw)). If an ID number has two or more spaces between its digit groups ("Order ID  0812  473  1900"), the raw text holds no candidate at all. The collapsed text reads it as an ID, so contactsIn(s) is empty too. On main, contactsIn(s) matched it, so the text could never be a title."
Evidence: (A) ID-only headline card + 'Learn more': main no link; feature invents pageLink /order-id-0812-473-1900/ and links the whole card. (B) same double-spaced ID as big/bold as 'Available parts': main links /available-parts/; feature ties, title lost, no link. (C) small double-spaced caption: same on both.
Suggested fix: also exclude rejectedIn(s) (the collapsed text) — matches main exactly because main's contactsIn(s) = feature's contactsIn(s) + rejectedIn(s). Reviewer's in-memory mutation '|| rejectedIn(s).length' kept 117/117 focused green and restored A and B. Add a double-spaced ID headline test and an equal-title test (RED first).
F2 info: Call-by-name tie change is not a regression for real designs — no action; record the reviewer's explanation in HANDOFF.
F3/F4 info: mutations all RED; gates green (check 1870+6, browser 187/187, in-process conversion of corpus + debug byte-identical vs main).

Pre-existing items (NOT to fix, already in found-else.md): date+time phone candidate, double-spaced 'View ID …' label guess, addressIn 'Order ID , …' forms.

## Do
1. Load figma-to-bricks (FINISHER), receiving-code-review, git-commit-rules, test-driven-development. Verify F1 yourself, fix it test-first in card-title.ts only.
2. Then the project skill's Step 3 item 7 and Step 4: rebase on current main, npm run check + npm run test:browser + npm run corpus (compare to baseline as before), merge lock (confirm completed exit 0), ff-only merge, BUILD bump, build, commit, push, verify, archive evidence, worktree/branch cleanup.
3. Paste check: next free number on main at merge time.
4. CLAUDE.md: earlier protected writes were denied; do not retry or bypass. Write your exact edits to ~/.hermes/plans/figma-to-bricks/phone-recognition-guards-claude-md-pending.md marked "apply after the older ones, in build order".
5. Close the found-else items this feature fixes (ID/date phone false positives per plan) with ~~…~~ ✅ fixed in build <BUILD>.
