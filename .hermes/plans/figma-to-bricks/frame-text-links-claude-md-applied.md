# Pending CLAUDE.md edits: frame-text-links (build 2026-10-21.5)

The finisher's first `patch` on `~/Documents/FigmaToBricksV2/CLAUDE.md` was denied by Hermes's guard
("protected agent-instruction file … denied"), so **none of these edits went in**. Apply all five, in this order
(the build line last). Line numbers are as of 2026-10-21 after build .4; re-read before patching.

## 1. Decision "A link never opens a picture" (~line 1243, under "Decisions the user made" → "Links to pages")

Replace:

```
    documents (PDF) stay; Figma text links to another frame wait for their own fix.
```

with:

```
    documents (PDF) stay. Words linked to another frame in Figma link to that frame's page (user, 2026-10-21, F1A
    F2A F3A, build `2026-10-21.5`): a part of a frame goes to its top frame's page, a frame gone from the file leaves
    the words plain and named, and the site check sends them to the site's page as it does Navigate links. Such words
    count as the designer's link, like typed-address ones: their card gets no whole-card link and a pill whose label
    carries one is a Div with a linked text, not a Button (review F4, not yet confirmed by the user).
```

## 2. "Start here" link-hrefs entry (~line 80; review F5)

Replace:

```
    to a picture or video file is dropped and named; text links to frames later.
```

with:

```
    to a picture or video file is dropped and named; text links to frames came in 21.5 (frame-text-links).
```

## 3. "Where things stand": new entry, inserted right before `- **Phone side padding (2026-10-21, build .4, phone-side-padding):**` (~line 686)

```
- **Words linked to another frame** (build `2026-10-21.5`, branch `worktree-frame-text-links`, HANDOFF of the same
  name; plan and ledger `docs/plans/2026-10-21-frame-text-links*`):
  - **The ask:** in Figma, words can link to a web address or to another frame; frame links were dropped, so the
    words came out plain in Bricks. Justin chose F1A (no page yet: the guessed address, noted by the site check), F2A
    (a part of a frame: its top frame's page), F3A (a deleted frame: plain words, named).
  - **Code:** extract `plugin/extract/link-frames.ts` (snapshot `linkFrames: { <id>: { frame, inside } }`, the layer
    under the Figma page, the file or a canvas section); `normalise/text.ts` `hyperlinkOf`/`frameLink` (`Run.linkFrame`;
    notes `goneFrameNote`, `unnamedFrameNote`, `partFrameNote` in `normalise/links.ts`, the part note naming no
    address); `emit/page-addresses.ts` `runLinks` (`PageAddress.runs: [{ id, at }]`, the link's place among its
    text's `<a>`s; the front page and typed addresses never listed); panel `ui/site-pages.ts` `relink` (a text's
    listed links, last first) and `ui/text-links.ts` `relinkText` (changes a link only while its href is still the
    conversion's; a function replacement, so a `$` in an address is written as it is).
  - **Rule:** every link kind (an element's link or a text run's) goes through `emit/page-addresses.ts` and
    `ui/site-pages.ts` `relink`; addresses typed in Figma are never changed.
  - **Behaviour change, not yet confirmed by Justin (review F4):** frame-linked words count as the designer's link,
    as typed-address words already did: a card whose title or "Learn more" carries one gets no whole-card link, a
    painted pill whose label carries one is a Div with a linked text (not a Button), and a Call/Email button whose
    label carries one keeps it instead of the nearest number. Kept; reversing it for both kinds is its own fix.
  - **My rulings, not yet confirmed:** the new `linkFrames` key (not `targets`); the part note names the part and the
    frame, no address; a canvas section counts as a page holder; frame links in text are `from: "figma"` (no
    "make sure that page exists" note without WordPress, as Navigate links); a text's link found by its place.
  - **Checks:** check 1330, browser 131 of 134 (the 3 known stale panel tests); corpus pastes byte-identical to main
    (no corpus file has a text hyperlink), lint and the 17 items unchanged. Reviewed on opus (approve, 5 low), all
    fixed test first or recorded.
  - Not yet pasted by the user (3ag).
```

## 4. "Start here": new entry, inserted right after the **Checks:** bullet (before `- **Phone side padding (21.4, …`), and the Checks count

In the **Checks:** bullet replace `` `npm run check` 1309 pass `` with `` `npm run check` 1330 pass ``.

Insert:

```
- **Words linked to another frame (21.5, frame-text-links):** words a designer links to another frame in Figma (Cmd+K
  → a frame's link) link to that frame's page, a part of a frame to its frame's page, and with WordPress connected
  the panel sends them to the site's page named like it (or takes them off where only a picture is at the address);
  a deleted frame's words stay plain, named. Behaviour change for Justin to confirm: such words, like typed-address
  ones, keep their card from becoming a whole-card link and a pill from being a Button. check 1330; HANDOFF "Words
  linked to another frame"; paste check 3ag owed.
```

## 5. Build line (line 7), last

Replace `**Current build `2026-10-21.4`.**` with `**Current build `2026-10-21.5`.**`
