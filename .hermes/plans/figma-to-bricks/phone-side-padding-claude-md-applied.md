# Pending CLAUDE.md edits: phone side padding (Build 2026-10-21.4)

The finisher's write to `~/Documents/FigmaToBricksV2/CLAUDE.md` was blocked (protected file, needs Justin's OK). Apply
these by hand or approve an agent to apply them. Re-read CLAUDE.md first: the emergency-cta-width, early-line-breaks and
font-weight-gaps finishers may have pending edits of their own (`*-claude-md-pending.md` beside this file).

## 1. "Start here": replace the build line (line 7)

Old:
```
**Current build `2026-10-21.2`.**
```
New:
```
**Current build `2026-10-21.4`.**
- **Phone side padding (21.4, phone-side-padding):** upright phones get a box's own (space.ramp) side padding back in
  writing after a sideways phone's squeeze (Justin's P1A; P2B: a tablet's squeeze still carries on to sideways
  phones). A row split by its items' own one-sided outlines (stats with a line between each) evens out once it
  breaks: the lines go, sides even to the row's smallest, the space they made becomes the gap, a wrapping row's items
  share each line (`adapt/divided.ts`). check 1309; HANDOFF "Phone side padding"; paste check 3ae owed.
```
(If 21.3's font-weights line went in first, keep it and put this one above it.)

## 2. "Start here" checks line (line 8)

Old: `- **Checks:** \`npm run check\` 1284 pass; browser suite (\`npm run test:browser\`) 131 of 134.`
New: `- **Checks:** \`npm run check\` 1309 pass; browser suite (\`npm run test:browser\`) 131 of 134.`

## 3. "Where things stand": the equal-card-heights entry's follow-ups (around line 625)

Old:
```
  - **Follow-ups:** link-hrefs' three panel tests (above); `space.ramp` writes no side where a phone's padding goes
    back to the drawn one, so the held-sideways cap carries on to upright phones (on main too); `style.ts` is 353
    lines; the footer's Opening Hours card keeps its 115px bottom.
```
New:
```
  - **Follow-ups:** link-hrefs' three panel tests (above); ~~`space.ramp` writes no side where a phone's padding goes
    back to the drawn one~~ (fixed for upright phones in 21.4, phone side padding); `style.ts` is 353 lines; the
    footer's Opening Hours card keeps its 115px bottom.
```

## 4. "Where things stand": a new entry after the equal-card-heights one (before "- **Paste checks:**")

```
- **Phone side padding (2026-10-21, build .4, phone-side-padding):**
  - **The report:** the hydraulics homepage's three Info cards under the logo marquee had 17px sides on an upright
    phone; Figma has 30.
  - **The cause:** `space.ts` wrote nothing at a tier where a box's side goes back to its designed value, and Bricks
    cascades tablet → sideways phones → upright phones, so the sideways phone's squeeze (cards three across,
    `sideCap` 17) stayed once they stacked.
  - **Justin chose:** P1A, upright phones get Figma's padding on the space ramp, written; P2B, upright phones only
    (a tablet's squeeze carrying on to sideways phones stays: GRO's "Let's talk →" keeps 22 there, the only case in
    the corpus). His point: "padding must look clean on any layout".
  - **Divided rows (the review's F1, Justin's standing ruling: do it if small and general):** a row of unpainted boxes
    split by their own one-sided outlines (no line on the row's ends, none above or below; `adapt/divided.ts`), from
    the tier where it breaks: the lines go (row.reflow), each item's sides even out to the row's smallest on every
    narrower tier (space.ramp), the space the padding and lines made between two items' words becomes the row's gap
    both ways on the gap ramp, and in a row that wraps each item grows to share its line. v1 did this (research §6).
    final-design's stats: 2 + 1 with the third centred at 360–478, one centred column 479–768, no lines; hydraulics'
    4 stats under the hero lose their lines on tablets.
  - **Rule:** a tier that goes back to the designed value writes it explicitly (Bricks cascades landscape → portrait);
    space.ramp's margin and gap steps decide upright phones against tablets only, guarded by a test that nothing
    writes a landscape-only one.
  - **My rulings, not yet confirmed:** a wrapping divided row shares each line (its lone last item sits centred); its
    gap is the space its padding and lines made, stepped (48 tablets / sideways phones, 32 upright for final-design).
  - **Checks:** corpus lint and the 17 "worse than v1" items unchanged; pastes change only in 14 upright-phone paddings
    (each its own Figma sides) and the two divided stat rows. check 1309, browser 131 of 134.
  - **Follow-ups:** the layout plan still counts a divided item's drawn sides after its row breaks (safe, low); a phone
    number in running text wraps at its inner space (hydraulics' "Call Us Now" card at 452–478).
  - Not yet pasted by the user (3ae).
```

## 5. Rule for the phone rules list ("Decisions the user made", "Phone rules" → "Section intro on phones")

Old: `where they can't slide. Stacked items' divider padding evens out.`
New: `where they can't slide. Stacked items' divider padding evens out; a row split by its items' own divider lines
    loses the lines once it wraps, goes two per row or stacks, its sides even out and the space becomes its gap.`
