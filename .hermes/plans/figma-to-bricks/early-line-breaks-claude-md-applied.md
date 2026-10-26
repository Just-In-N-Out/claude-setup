# Pending CLAUDE.md update for build 2026-10-21.2 (early-line-breaks)

The finisher's first edit went in: "Start here" now reads `**Current build `2026-10-21.2`.**` and Checks
`npm run check` 1284 pass. The next three writes to `~/Documents/FigmaToBricksV2/CLAUDE.md` were blocked (protected
agent-instruction file). Apply them once Justin approves; re-read the file first. Apply the emergency-cta-width pending
file (`emergency-cta-width-claude-md-pending.md`) first: its Start here entry goes in the same place, and its build and
check counts are superseded by the line already written.

## 1. "Start here": add right after the Checks bullet, before "Cards drawn the same height (20.15…)"
(after emergency-cta-width's "Site fonts kept per family (21.1…)" entry once that is applied)

```
- **Line breaks that only copy Figma's wrap (21.2, early-line-breaks):**
  - **The user:** in the hydraulics homepage's Info cards the words broke too early at full width ("…hurry? Give" /
    "us a call…", "Copco in" alone).
  - **The cause:** a website import left a typed `\n` where each line wrapped. It went out as `<br>`, hidden only
    below the design width (1728), but at 1728 the card is 363px in the 1440 Container (Figma 432), so the browser
    wrapped early and the `<br>` added a short line.
  - **The user chose (L1A L2A):** in a fixed-width text box such breaks become spaces, so the words wrap by the box on
    every screen; a text hugging its words keeps today's rule.
  - **What it does** (`style/rag.ts`): soft only for prose (`.!?` somewhere) whose breaks copy Figma's wrap, counted
    in letters (≤ 1 to spare on the longest line, which Figma's ink measures; ≤ a tenth of the guessed letters on a
    shorter line). Addresses, hours, headings and a designer's own break keep their `<br>`.
  - Reviewed on opus and fixed (letter count and prose only: my rulings under Justin's auto-go; leading spaces; FAQ
    placeholders). Corpus lint unchanged, hydraulics 0.5211 → 0.6039; design/final-design/GRO pastes byte-identical.
    HANDOFF "Line breaks that only copy Figma's wrap"; paste check 3ad owed (after 3ac's re-paste).
```

## 2. "Where things stand": add before "- **Paste checks:**" (after the "Cards drawn the same height" entry, and after
emergency-cta-width's "Site fonts kept per family" entry once that is applied)

```
- **Line breaks that only copy Figma's wrap** (build `2026-10-21.2`, branch `worktree-early-line-breaks`, HANDOFF of
  the same name; plan and ledger `docs/plans/2026-10-21-early-line-breaks*`):
  - **Code:** `style/rag.ts`: `ragBreaks` (the old `text.breaks` test: body ≤ 24px, no heading, no blank line, v1's
    rag), `softBreaks` (not hugging its words + prose + `copiesWrap`, the letters to spare: ≤ `FONT_SLACK` 1 on the
    longest line, ≤ `GUESS_ERROR` 0.1 × guessed letters on a shorter one); `typography.ts` `textHtml(…, soft)` writes
    a space and drops the next line's typed spaces; `style.ts` never holds a soft text as typed lines;
    `adapt/rules/breaks.ts` runs only for hug texts whose words aren't replaced.
  - **Tests:** `adapt-breaks.test.ts` (13, the boundaries pinned by mutation); `pages.ts` `pairPage`'s paragraph hugs
    its words; `faq.ts` takes an `answer`.
  - **On the user's files:** hydraulics' Info cards 3 lines at 1728 (main 4 with `hurry? Give` and `Copco in` alone),
    the same as main at 1440 and 390; design's footer address and the inspo file's "…growth⏎shouldn't live…" keep
    their breaks as on main.
  - **My rulings, not yet confirmed (under Justin's auto-go):** the letter count; prose only (an address with "St."
    counts as prose); a Truncate box counts as fixed width; a soft text gets Figma's line length.
  - **Follow-ups:** `style.ts` 356 lines (test-cleanup's split).
  - Not yet pasted by the user (3ad).
```

## 3. "Decisions the user made": add after the phone rules' last bullet ("- **Footer** last on the page and centred; …")
and before "- **Free-floating designs on phones**"

```
- **Typed line breaks** (user, 2026-10-21, L1A L2A): in a text box of fixed width (Figma's fixed or auto-height box),
  typed breaks that only copy Figma's own wrap go out as spaces, so the words wrap by the box on every screen, never
  by the screen's width. A text hugging its words keeps its breaks from the design width up and loses them below.
  Breaks that are the designer's (items like addresses and hours, a sentence a line, headings, a line the next word
  would have fitted on) stay. Only prose goes soft (finisher's ruling under the user's auto-go; `style/rag.ts`).
```
