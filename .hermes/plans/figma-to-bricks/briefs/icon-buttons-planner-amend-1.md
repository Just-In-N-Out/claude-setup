# icon-buttons — Planner, amendment 1 (Justin's ruling on AC2)

**Role:** planner. Plan text only: no code, no tests, don't write into any worktree. Skills: `implementation-planning`.

**Input:** the approved plan `~/.hermes/plans/figma-to-bricks/evidence/icon-buttons/plan-approved.md` (read-only). The blind auditor's finding (`~/.hermes/plans/figma-to-bricks/evidence/icon-buttons/auditor/ac.json`, AC2 entry; screenshots `ac2-menu-open-{base,head}-768.png` there): rendering base's and head's output side by side, 48 of 49 Button/Div pairs match within 0.38px; the one that doesn't is hydraulics' header "Schedule Now" copy inside the opened phone-menu panel (Nav Nestable) at 768 and 990: same box (332×53), but its words and arrow are centred (icon at 1016 vs 951) because the Button writes `_justifyContent: center` where the stretched pill Div left its content at the left. At 390 base already centred it.

**Justin's ruling (2026-11-04, chose in a question):** "Centred" — accept it: a Button stretched wider than its content (a panel/full-width button) centres its words and icon, as Bricks Buttons do and as phones already did.

**Write** `~/.hermes/plans/figma-to-bricks/evidence/icon-buttons/plan-amended-1.md`: the full approved plan text, unchanged except:
- AC2's text: keep "within 1px of today's Div" for the Button's **box** everywhere and for the icon/words where the Div's content was not stretched; add that a Button stretched wider than its content centres its words and icon (Justin's ruling 2026-11-04), so its icon may move inside an unchanged box. Keep AC2's test name exactly as it is (`test/browser/icon-buttons.test.ts` "an icon Button sits where the pill Div sat") so existing receipts still name it, and keep its `(proposed)` tag.
- Add a short "Amendment 1" note at the top (date, ruling, the auditor's evidence path).
- The Risks line "never a layout shift (AC2)" gets "(box; a stretched Button centres its content — Justin 2026-11-04)".
Change nothing else: other ACs' text, test names and tags must stay byte-identical (the AC checker parses them).

**Return:** the path, the exact old and new AC2 lines, and `skill_lessons[{skill, lesson, evidence, enforce}]` (usually empty; never edit skills or memory). End with: `MAIN SESSION: check and save these skill_lessons now.`
