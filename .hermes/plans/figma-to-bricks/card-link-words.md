# Card link words (card-link-words): a pill whose words carry a link becomes the link, never the whole card

**Approved by Justin 2026-10-21** ("go" = plan + D1 ⭐).

Planner, revised 2026-10-21 on main `9334c37` (build `2026-10-21.12`) with Justin's answers (A1, B1, **C2**, "Title").
**Builds only after text-link-followups (B7) merges**; plan on top of its changes (see Overlaps).

## Open questions (plan written as if ⭐)

Answered: **A1** (frame links and typed addresses follow one rule), **B1** (a Call/Email button whose words carry a
link goes where its words link), **C2** ("I only want learn more to be linked let's say not the whole card"),
**Title** (a card whose title words carry a link: only the title is linked). One new question, since the old plan
assumed the arrow pill disappears inside a linked card, and under C2 it no longer does:

**D. A "Learn more →" pill (words plus a drawn arrow) whose words carry a link**
- **D1 ⭐ The whole pill is one link** (a linked box: words and arrow plain inside it), exactly what a pill gets today when
  the designer gives it a Navigate click. It looks the same as drawn. Bricks' own Button can't hold a drawn arrow: it only
  takes an icon from Bricks' icon sets, so the arrow would have to be swapped or dropped.
- D2 A Bricks Button with the label only; the drawn arrow is dropped (or swapped for a Bricks icon that may look different).

## Playback

1. A designer links words in Figma (Cmd+K), to a web address or, since 21.5, to another frame.
2. When the words are a painted pill's label ("Learn more", "View pricing"), the pill stopped being a Button. Today it's a
   Div holding a linked text, so only the words are clickable.
3. You want the pill to be the link: a Bricks Button going where its words link, its words plain inside (no link in a
   link). The card around it is **not** linked whole.
4. A Call/Email button whose words carry a link goes there, not to the nearest number.
5. A card whose title words carry a link: only the title is linked, as today. Words' links never link a whole card.
6. Both kinds of link (frame and typed address) behave the same.

## Root cause (unchanged evidence, re-read on `9334c37`)

- `understand/widgets.ts:18` `buttonLabel` returns null when `tx.runs[0].link` is set, so a pill with a linked label is
  `role: box` (Div) and its text emits `<a>`.
- `normalise/contact-links.ts:21` `holdsLink` skips a Call/Email button whose label holds a run link, so it falls to the
  same Div with linked words.
- `normalise/page-links.ts:46` `linked()` counts a run link as the designer's link, so the card around it gets no
  whole-card link. **Under C2 and "Title" this is already the wanted behaviour; no change.**
- Since 21.5 frame links became `Run.link` too, so they hit the same guards typed addresses always hit.

## Approach: move the label's link up to its pill, in normalise

One small new normalise step, `src/core/normalise/label-links.ts` (about 50 lines), run in `normalise.ts` right before
`linkContacts` (`:260`). For every painted or outlined pill whose words all carry one link, it moves that link onto the
pill: `pill.link = run.link`, `pill.linkFrame = run.linkFrame`, and the label's runs drop it (`link = null`,
`linkFrame = null`). The pill is then exactly what a pill the designer linked with a Navigate/Open-link click is today.
Everything downstream already handles that, so no other source file changes:

- `buttonLabel` sees an unlinked one-run label in a linked frame → **Bricks Button** with `settings.link` (via
  `understand/node.ts:69` `ir.link = n.link`). The label emits as plain button text.
- An arrow pill (words + icons) → a linked box with plain words and arrow inside (D1), as a Navigate-linked pill today.
- Call/Email (B1): `contact-links.ts` `buttons()` returns at `n.link !== null`, so the words' link wins. No nearest-number
  note.
- The card (C2): `page-links.ts` `allowed()` sees a linked layer inside the card and links nothing whole, as today.
- Site check: `emit/page-addresses.ts:35` already lists an element whose `src.link` came with a `linkFrame`
  (`from: "figma"`, its id); typed addresses fail `checked()` and are never listed. `ui/site-pages.ts relink` already
  relinks element ids (`settings.link`).
- Titles, sentences and any other linked words: untouched, still linked words. A card's title link keeps the card
  unlinked (already true).

**Which pills** (structure only, no names or texts): a frame (not the page or a section, as `contact-links.ts:83`), a
`labelBox` (label-box.ts), `painted || outlined`, exactly one flow text (not absolute, not a form field: `fieldText`),
any other flow children icons, 24–120px tall, at least 1.5× as wide, at most 640px (the `buttonLabel`/`pillBox` sizes;
normalise can't import `understand/widgets.ts`). **Its words all carry one link:** every non-blank run has the same
non-null `link` (blank runs may have none). A pill already linked itself (`n.link`), or inside a linked layer, is left
alone (its own link wins). Two different links in one label: left alone.

**Not needed any more:** the old `wordsLink` field, the precedence change in `node.ts`, the `buttonLabel` change, the
`holdsLink` change, the `page-addresses.ts` change and the `card-scope.ts` pure move (no card logic is touched).
That keeps this feature clear of every file B7 edits.

## Tasks (test first, each its own commit)

1. **Refresh and baseline.** Confirm B7's merge commit is an ancestor of main; re-read its final
   `emit/page-addresses.ts` (labels list) and `contact-links.ts` (cross-run phone slicing), and check:
   - **check first:** that `page-addresses.ts`'s element path (`src.link === url ? src.linkFrame`) still lists a linked
     element and B7's `labels` collects its words (the label text is the Button's visible words). If B7 changed it, adapt
     the test, not the rule.
   - **check first:** that a frame given `link` + `linkFrame` in normalise reaches `settings.link` on a Button and on a
     linked box, and that the Button's text comes out with no `<a` (emit uses the label's plain words).
   - **check first:** what a Navigate-linked arrow pill emits today (expected: a linked Div/Block, `tag: a`, words plain).
   - `npm run check`, `npm run test:browser`, `npm run corpus` (save the report and every `bricks.json`), and the old
     probe `~/.hermes/cache/scratch/ftl-review/button.ts <base> <main>` output into the ledger (if pruned, rebuild it
     from the new fixture).
2. **RED → GREEN, the move:** generic fixture `test/fixtures/card-link-words.ts` (`builders.ts` + `text-links.ts`, nothing
   from his files). New `test/unit/normalise-label-links.test.ts`:
   - a painted pill whose one run links to a frame → `pill.link === "/pricing/"`, `pill.linkFrame` set, run link null;
   - the same with a typed `https://` address → `pill.link` the address, `linkFrame` null;
   - an outlined pill; a pill with an arrow icon; a label of two styled runs both linked the same;
   - stay as they are: a link inside a sentence; two different links in one label; a label partly linked; a pill already
     linked; a pill inside a linked layer; a plain text (no box); a card title; a form field; a box too tall/wide.
3. **RED → GREEN, the paste:** new `test/unit/convert-card-link-words.test.ts`:
   - a pill with a frame-linked label in a card → element `button`, `settings.link.url` the page, its text has no `<a`;
     the card is a plain Div/Block (no `tag: "a"`, no link);
   - the same with a typed address;
   - an arrow pill → one linked box, no `<a` inside it (no nesting);
   - a card whose title words link → the title text keeps its `<a>`, the card isn't linked (Title ruling);
   - a pill outside any card → a Button with the link;
   - a form's send button with a linked label (`understand/form.ts:170` uses `buttonLabel`) stays a Bricks Form's button.
4. **RED → GREEN, Call/Email (B1):** a "Call us" pill (on a page that shows a number) whose words link to a frame → a
   Button linking to that page, not `tel:`; no nearest-number note; the card not linked whole. Same for "Email us" with a
   typed address.
5. **RED → GREEN, site check:** `pageAddresses` lists the Button's id for a frame-linked label (`from: "figma"`, no `runs`
   entry, B7's labels include its words); a typed address isn't listed. An end-to-end `relink` (as frame-text-links
   task 5) moves the Button's href to the site's page; a missing page takes it off and names it.
6. **Probe re-run:** main vs the copy, frame and url. Expected: `button link=/pricing/` (or the URL), card `link=-`,
   no `<a` inside the Button. Ledger text proof (links only, no look change, so no shots).
7. **Gates:** `npm run check`, `npm run test:browser`, `npm run corpus` (pastes `cmp`-equal: no corpus file has a
   text link), his debug file replayed byte-identical from a scratch copy (`~/.hermes/cache/scratch/clw-debug.json`;
   it's build 20.6 with no text links). Prove each new test fails with `label-links.ts`'s call reverted.
8. **Docs & records** (below).

## Tests (generic)

Built from structure only: any words, any address, any colours. Both link kinds; painted and outlined pills; with and
without an arrow; inside a card and out; Call/Email; title-linked card; sentence link; two links; partly linked; an
already-linked pill; a form button.

## Risks

- **Mutating runs in normalise.** Contact-links does the same (it writes `Run.link`); this only clears a link it moved
  onto the pill, so it's never lost. Keep the step pure on SceneNodes, before `linkContacts`/`linkPages`, deterministic.
- **A pill's label of two styled runs** moves the link but stays a linked Div (`buttonLabel` needs one run). Same as an
  unlinked two-style pill today; fine, but say so in HANDOFF.
- **The arrow after an unboxed "Learn more →"** (no painted pill) isn't linked: only its words are. Justin's "only learn
  more linked" allows it; note it in HANDOFF, not fixed here.
- **Shared `buttonLabel` with forms** (`understand/form.ts:78,83,170`): a form's linked send button now passes; task 3
  checks the form stays a Bricks Form.
- **B7 lands first** and may move `page-addresses.ts`/`contact-links.ts` lines; this plan edits neither, but its tests
  read them. Refresh line numbers at task 1.

## Files touched

- New `src/core/normalise/label-links.ts`; `src/core/normalise/normalise.ts` (one import, one call before
  `linkContacts`; 274 → about 276 lines).
- Read only (behaviour relied on): `normalise/label-box.ts`, `normalise/contact-links.ts`, `normalise/page-links.ts`,
  `understand/widgets.ts`, `understand/node.ts`, `understand/form.ts`, `emit/page-addresses.ts`, `ui/site-pages.ts`.
- Tests: `test/fixtures/card-link-words.ts`, `test/unit/normalise-label-links.test.ts`,
  `test/unit/convert-card-link-words.test.ts` (new files).

## Overlaps (and order)

- **text-link-followups (B7, building on Sol):** edits `normalise/contact-links.ts`, `emit/page-addresses.ts`,
  `understand/page-links.ts`, `emit/elements.ts`, `ui/site-pages.ts`. **This plan edits none of them** (only reads), so
  there's no source conflict. It still builds after B7 merges, as dispatched: its site-check test reads B7's `labels`.
  Both touch `docs/HANDOFF.md` and the paste-check number: take the next free one at merge.
- **layout-floors, google-font-hardening (worktrees open):** no shared file expected; `normalise.ts` only if either
  edits it (check at rebase).

## Docs & records (last task)

- Plan copied to `docs/plans/2026-10-21-card-link-words.md` (actual build-start date if later); ledger to
  `docs/plans/<dated-plan>-ledger.md`.
- `docs/HANDOFF.md`: section "Card link words", the probe's before/after links, the two limits from Risks, and the paste
  check owed (next free number): a card whose "Learn more" pill links to a frame → the pill is a Button going to that
  page and the card isn't clickable elsewhere; a card whose title links → only the title is a link; a pill with a typed
  address → a Button to that address.
- `BUILD` bumped by the finisher.
- **Main `CLAUDE.md`** (finisher, after the merge; re-find each anchor, lines are from `9334c37`):
  - "Start here", "Words linked to another frame" (~line 50–54): replace "Behaviour change for Justin to confirm: …"
    with **Justin's ruling (2026-10-21, A1 B1 C2, "Title")**: a pill whose words carry a link (a frame's or a typed
    address) is that link (a Button; with an arrow, one linked box), a Call/Email button whose words carry one goes
    there, and a card is never linked whole because of words' links (a linked title stays linked words).
  - "Where things stand" → "Words linked to another frame" (~line 786–789): replace the "Behaviour change, not yet
    confirmed by Justin (review F4)" bullet with the same ruling.
  - "Decisions the user made" → "A link never opens a picture" (~line 1361–1364): the same replacement for "…their card
    gets no whole-card link and a pill whose label…".
  - "Native Buttons by shape alone" (~line 1221): "linked or not, its label's own link included (it moves to the Button)".
  - "Call and email links" (~line 1334): "a call or email button whose words carry a link goes there".
  - "Links to pages" → "The whole card is the link" (~line 1350): "never because words carry a link: a linked title or
    pill keeps the link to itself".
- Rules summary (`references/rules-summary.md`), the "Frame-linked words" line: "a pill whose words carry a link becomes
  that link (Button); words' links never link a whole card".

## Other things found

- His on-disk debug file is build 20.6 (before 21.5) with no text links, so it can't show this; a re-export would.
- The old plan's `card-scope.ts` split of `page-links.ts` (279 lines, near the 300 limit) isn't needed here. It stays a
  candidate tidy-up for whichever feature next grows `page-links.ts`.

## Justin's answers (2026-10-21)
- A1, B1, **C2** ("I only want learn more to be linked let's say not the whole card"), Title ("Title": only the title is
  linked). Revised to the narrow plan above; D is new.

- **go** (2026-10-21 ~11:40): plan + **D1** ⭐ (a linked "Learn more →" pill is one link with words and drawn arrow inside). Builds after text-link-followups merges.
