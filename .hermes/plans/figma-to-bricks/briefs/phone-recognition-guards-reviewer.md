# phone-recognition-guards — fresh REVIEWER brief (2026-10-21 20:35 EDT)

Review only. Worktree ~/Documents/FigmaToBricksV2/.claude/worktrees/phone-recognition-guards, tip 5a5acc3. Review `git diff main...HEAD` (main 5e32aec, build .22) against the approved plan ~/.hermes/plans/figma-to-bricks/phone-recognition-guards.md (including Justin's P1A/P2A/P3A answers and the 'Ownership clarification — address.ts' section) and the project rules.

## What was built
- Shared classifier: accepted contacts vs rejected ID/date ranges, used by four normalise owners: contacts, card-title, page-words, page-links. Rejected data must not create phone links, guessed page addresses, whole-card links, or displace real titles/labels.
- address.ts: withoutContacts also cuts rejected ranges, restoring main's address/map output (builder: 0 differences vs main over 5,400 addressIn cases).
- Builder gates on 5a5acc3: check 1870+6, browser 187/187, corpus pastes/HTML byte-identical to .22, debug replay byte-identical.

## Look hard at
1. Call-by-name caption tie change (contact-links.ts:71 eligibility): ID text now counts as caption words; 'Call Sales' improves, ambiguous 'Call order desk' falls to the first number. Is this a regression vs main for real designs? Do not redesign; report.
2. Explicit designer links, pills, B7 phones, true-number grouping/offsets unchanged.
3. No new guessed whole-card links or page addresses; no nested anchors; deterministic output.
4. Tests actually fail on the pre-fix code (mutations), and the address tests fail on 9495238.
5. Phone widths 375/360/320 where relevant.

Change nothing: no commit, push or merge; restore anything you touch. No live-site writes. Other builders/reviewers run in parallel; stagger heavy Chrome runs. Known pre-existing (not a finding): same-line '• Order ID' kept in an address on main too.
