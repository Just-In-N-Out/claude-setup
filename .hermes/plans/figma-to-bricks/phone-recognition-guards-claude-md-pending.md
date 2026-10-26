# phone-recognition-guards — exact main CLAUDE.md edits pending

Target: `/Users/justin/Documents/FigmaToBricksV2/CLAUDE.md`
Release build: **2026-10-21.23** (`748dca8`, pushed); paste check **3aw owed**.

**Apply after the older ones, in build order** (.13 … .22 pending files, e.g. `pill-clip-`, `google-font-range-policy-`,
`list-panel-followups-`). **None of these edits landed, and none was attempted.** Earlier protected writes to CLAUDE.md
were denied, so per the brief this finisher made no write attempt and used no terminal/execute_code/main-chat route.
Rename to `-applied.md` only after all three edits land.

## Edit 1 — "Start here", new bullet directly after the list-panel-followups (21.22) bullet

```
- **Phone recognition guards (21.23, phone-recognition-guards):** P1A/P2A/P3A. A phone-shaped number right after a
  standalone same-line "ID" (optional one ":" or "#") or a whole calendar-valid +YYYY.MM.DD / +YYYY-MM-DD is data:
  no automatic dial link or Call target, and never a guessed page's name, a label's page or an inferred whole-card
  target (narrow exception to "any number written with +"). One scan in `normalise/contacts.ts` (`contactsIn` +
  `rejectedIn`); `card-title.ts` skips rejected data raw and collapsed; `page-words.ts` labels; `page-links.ts`
  `allowed()` vetoes; `address.ts` cuts rejected lines from addresses/map places as main did. Designer links, linked
  title words, pills and real phones unchanged. Fresh review F1 (spaced-out ID could name a card) fixed test-first.
  check 1877 + 6 performance; browser 187/187; corpus pastes/HTML and debug replay byte-identical to main .22.
  HANDOFF "Phone recognition guards"; paste check **3aw** owed. Already-pasted false dial links need a re-convert and
  re-paste.
```

## Edit 2 — "Where things stand", contact links section: new rule line next to "Shown numbers/emails link"

```
- **ID and date numbers are data, not phones (user, 2026-10-21, P1A/P2A/P3A):** `contactsIn` skips a candidate right
  after a standalone same-line "ID" word (horizontal space, one ":" or "#") or a whole calendar-valid +YYYY.MM.DD /
  +YYYY-MM-DD; `rejectedIn` returns them. Every consumer that excluded contacts must also exclude rejected data
  (titles raw and collapsed, labels, inferred card targets, addresses), or removing a false dial link unmasks a false
  page link. Real phones, designer links and pills are unchanged.
```

## Edit 3 — "Start here" build line (send last)

Replace the current-build line (whatever older pending files set it to, e.g. `**Current build `2026-10-21.22`.**`) with

```
**Current build `2026-10-21.23`.**
```

and in the **Checks** bullet the counts become: `npm run check` 1877/1877 unit/rule plus 6/6 serial performance;
browser 187/187.
