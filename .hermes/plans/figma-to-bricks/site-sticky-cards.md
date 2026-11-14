# site-sticky-cards: boxes the old site pins while the page scrolls paste as Bricks' own Position: Sticky (plan, Full, 2026-11-13)

Planner: Fable 5.2 high. Plan only: no source or test changed, nothing committed, no agent started, no live site
loaded, no WordPress written.
Evidence (`<E>` below): `~/.hermes/plans/figma-to-bricks/evidence/site-sticky-cards/planner/` (`README.md` lists every
file). Scratch trees: `~/.cache/ssc-pl/` (may be gone; every script takes its tree as an argument).
Measured on: importer-parity-build `48fe133c` (it holds site-shared-styles' `7b7501bd`, which holds site-no-div), with
main `7f54b0a5` (Build 2026-11-12.3), site-no-div-final `cf4f887d`, plugin-parity-build `89e41a0d` and
shared-palette-build `9070c50f` read for the shared files. The prototype (`<E>/proto/elementor-sticky.ts`) applies to
`48fe133c`.
The builder copies this file to `docs/plans/<date>-site-sticky-cards.md`.

## Playback

1. On bdryswi.com's 7 service pages, 3 to 5 big cards stop at the top of the window one after the other and stack
   while you scroll (23 cards in all; desktop and tablet; they are hidden on phones). Elementor Pro's script does it.
2. The importer pastes them as ordinary cards that scroll away: the script's work isn't in the site's CSS, so the
   paste never learns the cards are pinned (in the paste they are up to 900 px from where the old site shows them).
3. This plan makes the importer read Elementor's own setting on each such box and write Bricks' own
   **Position: Sticky** with **Top** on it (Style → Layout; a setting, no code), at the widths the old site pins it.
   A Bricks pro changes Top or turns it off in one field.

## Questions (⭐ = the answer taken unless you say otherwise; "go with recommended" takes them all)

1. **Where a pinned card lets go at the end of its stack.** Bricks' Sticky keeps a box inside its parent's content;
   Elementor's script lets it slide on into the parent's bottom padding. So in the paste each card starts to move up
   a little sooner: by the parent's bottom padding (50 px on every B-Dry stack). Everything before that point is
   identical (measured: 0 px apart at every scroll step).
   - ⭐ **A:** plain Position: Sticky; the notes say how many px sooner. One field to edit, no code.
   - B: an exact end with extra CSS on the parent and on every card (not prototyped; a pro who changes the padding
     breaks it).
2. **A pinned box with no z-index of its own.** Elementor gives it z-index 99 while it is pinned, so the content
   that scrolls past goes under it.
   - ⭐ **A:** the paste gives it z-index 99 at the widths it is pinned (always, not only while pinned: CSS can't tell).
     A box with its own z-index keeps its own (B-Dry's cards: 1, 2, 3, 5, 6).
   - B: no z-index: later boxes of the same parent would draw over the pinned one.
3. **Top for people logged in to WordPress.** Elementor adds the admin bar's height to the offset for logged-in
   users; visitors never see it.
   - ⭐ **A:** Top is the plain number (`2px`), what a pro expects to read. Logged in, a pinned card sits under the
     admin bar by its height.
   - B: `calc(2px + var(--wp-admin--admin-bar--height, 0px))`: right when logged in, but it lands in custom CSS.
4. **Sticky On lists only some screen sizes** (not B-Dry: its cards list every size).
   - ⭐ **A:** pinned exactly at the widths the old site pins it. Where those fall on Bricks' breakpoints (phones off:
     Elementor's 767 is Bricks' mobile landscape) Position and Top are settings at that breakpoint; where they don't
     (Elementor's tablet starts at 1024, Bricks' at 991) they go in the class's CSS. Exact wins (the standard, point 6).
   - B: round to Bricks' breakpoints: always settings, but between 992 and 1024 the paste differs from the site.
5. **Your Additional CSS line `html, body { overflow-x: hidden }`.** With it, a sticky box never sticks (measured:
   the first card is 322 px off). The header's own class already guards against it, but only on a page that holds the
   importer's header.
   - ⭐ **A:** a paste that pins a box carries one small helper class on its root with the same three guard lines the
     header's class has, so the cards pin with or without that line and with or without the header.
   - B: no helper class; a note tells you to take that line out of Additional CSS.
6. **What stays as today, each named once in the notes:** a box pinned without "Stay In Column" (it floats over
   everything after it to the page's end, which Sticky can't do), a box pinned to the bottom of the window, a pinned
   box inside a box that scrolls or hides its overflow (Sticky would never stick there), and a header's bars (they
   keep the stay class of Build 2026-11-11.7). ⭐ **A:** as today, named. B: paste them as Sticky anyway (they would
   let go at the wrong place).
7. **The Figma plugin.** Figma's "Fix position when scrolling" and Sticky are not carried today: debug files keep
   `scrollBehavior` and `numberOfFixedChildren`, but nothing reads them, and none of your real files holds one
   (`<E>/README.md`). By your rule "prove it on the plugin first" this is recorded as a follow-up, to be built with the
   same two settings once a real design shows it. ⭐ **A:** follow-up; the plugin changes by no byte in this job.
   B: build it now from Figma's typings alone.
8. **A site that isn't Elementor whose own script pins a box:** the scan would have to scroll and watch which boxes
   stay (a capture change). ⭐ **A:** follow-up. B: this job (bigger: the capture format changes).

## Root cause (file:line on `48fe133c`; the same on main unless said)

- Elementor Pro's Sticky is a script: it writes `position: fixed`, a px width and a hidden spacer copy
  (`<E>/elementor-pro/jquery.sticky.min.js`, `sticky-handler.js` L50-70). The capture leaves a script's values out of
  the site's code (`src/web/read/code.ts:155`, named in `scripted`), and the paste leaves the hidden copy out
  (`src/core/site/widgets.ts:2-9`). `src/core/site/stay.ts:1-6` says so for the header.
- Only a header gets something back: `stay.ts` `headerStays` reads the capture's `web.position: "fixed"` marks in the
  header part and `parts.ts:151` adds the stay class. No code in `src/core/site` reads an element's Sticky setting
  (`grep -rn sticky src/core/site`: only the header's class, the fold's refusals and the control table).
- The capture already holds what is needed: each Elementor element's `data-settings` is kept in `web.code` marks
  (`src/core/site/elementor-map.ts:14,28`: `settings`), with `sticky`, `sticky_parent`, `sticky_offset`, `sticky_on`.
- importer-parity made `position`, `top` and `z-index` Bricks settings (`controls-more.ts:18`), so once the
  declarations say `position: sticky`, the class builder writes Position: Sticky by itself.

## What Bricks and Elementor do (read, not guessed)

- **Bricks 2.2** (`<E>/bricks-2.2/base.php` L488-523): `_position` is a select (`setup.php` L1098-1104: static,
  relative, absolute, fixed, sticky) writing `position`; when it is `sticky` Bricks shows 'Set "Top" value to make
  this element "sticky".'; `_top` writes `top`; `_zIndex` (L567) writes `z-index`. No sample in `reference/bricks/`
  holds `sticky` (13 hold `relative` or `absolute`); the renderer prints all three keys already
  (`test/browser/render.ts:26-28`).
- **Elementor Pro** (`sticky-handler.js`): the script runs when the current device is in `sticky_on`; the offset is
  the device's `sticky_offset` (a device with none takes the next wider one's, Elementor's `getDeviceSetting`) plus
  the admin bar; Stay In Column (`sticky_parent: "yes"`) limits the box to its closest ancestor among `.e-container,
  .e-container__inner, .e-con, .e-con-inner, .elementor-widget-wrap`, and is ignored on a container whose parent is no
  container (`isParentContainer`, L55-63). `jquery.sticky.min.js` lets the box go when the parent's bottom edge (inside
  its border) reaches the box's bottom: the box slides through the parent's bottom padding.
- **Pro's CSS** (`sticky.min.css`): `.elementor-sticky--active { z-index: 99 }`, `.e-con.elementor-sticky--active
  { z-index: var(--z-index, 99) }`. Elementor sets `--z-index: revert` on every container
  (`elementor-_container.scss`); a CSS-wide keyword as a custom property's value leaves it unset for `var()`, so a
  container with no z-index of its own takes 99 while pinned (the fixture's capture reads `unset` unpinned, `99`
  pinned: `<E>/proto/probe-capture.log`).
- **CSS sticky** keeps the box's margin box inside its parent's content box, and sticks to the nearest ancestor whose
  overflow is anything but `visible` or `clip`. `clip` on html and body (site-scroll-lock) makes no scroll container.

## What I measured (prototype on `48fe133c`; fixture site on 127.0.0.1; Chrome; Bricks 2.4.2 and 2.3.9)

The fixture (`<E>/proto/fixture-elementor-sticky/`, a made-up page of the shape, real jQuery and Pro's own
`jquery.sticky.min.js`): a header bar the script keeps; a stack of three cards (Sticky Top, Stay In Column, offsets
2, 2, 3, z-index 1, 2, 3, hidden on phones) in a parent with 40 px bottom padding; a heading widget pinned on desktops
only at 120 px in a column with 20 px padding; three boxes the rule leaves (no Stay In Column, bottom, inside
`overflow: hidden`).

| What | Result | Where |
|---|---|---|
| The cards' classes | `{"_position":"sticky","_zIndex":"1","_top":"2px"}` (and 2/2px, 3/3px): settings only, no custom CSS for them, no Code | `proto/probe-paste.log` L15-21 |
| Cards' tops, site vs paste, every 200 px of scroll, 1440 / 1024 / 1000 / 992 / 768 | 0 px apart at every step until a card lets go (0, 400, 800 and 1200 included); from there the paste is exactly 40 px higher (the parent's bottom padding), 20 px for the widget | `probe-paste.log`, `probe-paste-tiers.log`, `tops*.json` |
| The same with the rule off (today) | up to 900 px (1440) and 780 px (1024) apart | same, "worst site - base" |
| Bricks 2.4.2 against 2.3.9 | 0 px at every width and step | same |
| Phones: 600, 478, 390 | the stack stays hidden, nothing is pinned, paste = site at every step, page height equal | same |
| Page height, site vs paste | equal at every width (5463 / 5251 / 5251 / 3441 …) | same |
| The header over the cards | the window shows the header 40 px under the top on site and paste at every step where a card is pinned (header z-index 99 on the site, 100 in the paste, cards 1–3) | `probe-paste.log` "onTop" |
| html and body `overflow-x: clip` (the scroll lock) | cards pin | `check/probe-additional.log` rows 1-2, 7-8 |
| Additional CSS `html, body { overflow-x: hidden }`, header + page + footer pasted | cards pin (the header's stay class guards) | rows 3-4 |
| The same, the page's paste alone | cards do **not** pin (first card at −320, pinned = 2) | rows 9-10 |
| The same with the three guard lines | cards pin | rows 11-12 |
| A box pinned on desktops and tablets only, shown on phones | `_position: sticky`, `_top: 120px`, `_position:mobile_landscape: relative`, `_top:mobile_landscape: 0px`; `z-index: 99` in class CSS from 768 up | `check/probe-widths.log` FINAL |
| A box pinned on desktops only (Elementor's 1025 up) | class CSS in bounded blocks (1024 is no Bricks breakpoint) | `probe-paste.log` L23-24 |
| `site:check --whole --elementor` on the fixture, rule on vs off | the same report byte for byte | `check/site-check-*.log` |
| Justin's 2026-11-11 home scan, both routes, rule on vs off | byte for byte the same (its only pinned elements are the header's bars) | `check/home-equal.txt` |
| The 608 hand-made pastes (site-no-div's list), rule on vs off | 0 differ | `check/pins-both.txt` |
| `npm run build` (the Figma plugin and panel), rule on vs off | `dist/code.js` and `dist/ui.html` byte for byte the same | sums in the README's run |
| Unit suite with the prototype | 3723 pass, 1 fails: the list of Elementor files in `test/unit/site-elementor-unchanged.test.ts:78` (it gains the new file) | `check/unit-proto.log` |
| `structure.txt` of the fixture, rule on vs off | the same | `check/fixture-paste-*` |

B-Dry by its saved pages (`<E>/bdry/cards-and-ancestors.txt`; no capture of a service page exists yet): 23 cards on 7
pages, each `sticky: "top"`, `sticky_parent: "yes"`, `sticky_on` all five sizes, offsets 2, 2, 3 / 50, 3, 3 / 50, 100,
161, 217, 3 / 2, 2, 2; each a container inside a top-level full-width container (`e-con`) with 50 px bottom padding,
`position: relative; z-index: 1`; own z-index on every card; no ancestor clips; 3 cards also play an entrance. Its
breakpoints in the home scan are `[2399, 1366, 1024, 767]` (five sizes), so every card is "pinned at every width" and
gets settings only. Not prototyped: a pinned card that also plays an entrance (Task 9 covers it).

## Design

### S. The rule (`src/core/site/elementor-sticky.ts`, new, pure; from `<E>/proto/elementor-sticky.ts`)

`pinned(capture, opts)` returns `{ capture, made, notes }`. With `opts.elementor` off, `opts.sticky === false`, or no
box to pin, it returns the capture it was given (the same object: nothing downstream changes by a byte). Otherwise it
returns a copy whose `web.code.nodes[path].decls` say, for each pinned box, what Bricks' Position: Sticky and Top do.
It reads Elementor's own markers and settings only (`elementor-map.ts` entries), never a name, a text or a size.

For each map entry whose `settings.sticky` is a non-empty string:

- S1. Skipped silently: a copy the script made (`~` in the path's last step) and anything inside the header part
  (`select.ts` `partRoot(capture, "header")`): the stay class owns the header.
- S2. Left as today, with one note (N2): `sticky` is not `"top"`.
- S3. Left, noted: `sticky_parent` is not `"yes"`, or the box is a container whose parent is no container (Pro ignores
  Stay In Column there).
- S4. Left, noted: its parent in the page has none of Pro's parent classes (the box Pro would limit it to is a
  further ancestor: Sticky can't be limited to that one).
- S5. Widths. `everywhere` = `sticky_on` lists as many sizes as the site has (breakpoints + 1). Else each device's
  widths come from the site's breakpoints when every one is an Elementor default (767 mobile, 880 mobile_extra, 1024
  tablet, 1200 tablet_extra, 1366 laptop, 2399 widescreen's start); a breakpoint that isn't: left, noted (the capture
  keeps the widths, not the names). A capture range that covers devices the list treats differently, or with two
  offsets: left, noted.
- S6. Offset per range: the device's `sticky_offset_<device>`, else the next wider device's, else `sticky_offset`,
  else 0 (Elementor's order), written `"<n>px"`.
- S7. Left, noted: an ancestor whose `overflow`, `overflow-x` or `overflow-y` is anything but `visible`, `clip`,
  `unset`, `initial` or `revert` at a range where the box is pinned and shown.
- S8. Written at each pinned range: `position: sticky`, `top: <offset>`, and `z-index: 99` where the box has none of
  its own there (undefined, `auto`, `unset`, `initial`, `revert`); its own z-index stays.
- S9. Written at each range where it is not pinned: `top: 0px` when the box is in the flow there (`position` static
  or relative) with no `top` or `bottom` of its own. It draws the same, and it lets Top be a setting at Bricks'
  breakpoint instead of falling into CSS (measured, `check/probe-widths.log`). Nothing else is written there.
- S10. The tail: per pinned box, its parent's bottom padding plus its own bottom margin at the widest pinned range,
  when both are plain px (read by whichever name the capture kept, physical or logical); the largest goes in note N1.

The declarations are re-encoded with `elementor-accordion.ts` `encode`, as that module does. Nothing else of the
capture changes (no layer, no mark, no range).

### W. Where it runs

- W1. `sitePage` (`parts.ts:70`) and `siteToBricks` (`convert.ts:647`) each call `pinned(capture, opts)` first and use
  the returned capture for everything after, so the fold (`elementor-fold.ts:191`, `fold-boxes.ts:132`: a positioned
  box and the wrapper around a sticky box are never folded away), the lift, the looks and the class builder all read a
  box that is sticky, like any site whose own CSS says so. One class builder writes the result: a property is a Bricks
  setting when every value is plain and every change falls on Bricks' breakpoints (importer-parity), else the class's
  CSS in bounded blocks (staging-fit-cancels; never `revert`).
- W2. `ConvertOptions.sticky` (`convert.ts:75`): on unless `false`; a test and diagnosis switch no command line sets
  (as `parity`, `looks`, `native`). `tools/site-check.ts` gains `--no-sticky` among its test-only flags.
- W3. Where the settings sit: on the class the class builder gives the box today (its own class beside the shared look
  class: `home__first-we__block-sxys {"_position":"sticky","_zIndex":"1","_top":"2px"}`). When look-grouping merges, a
  copy's own difference moves to the element's settings by that job's rule; this job writes declarations only, so it
  follows without a change.
- W4. A pinned widget keeps its own box (a Block labelled by its widget type, holding the Bricks element), which
  carries the settings: the fold already refuses a positioned widget. Folding the setting onto the element itself is a
  follow-up.

### G. The guard class (`stay.ts`)

- G1. The stay class's last three lines (`html:root, html:root > body { overflow-x: clip; }`,
  `html:root:has(> body.no-scroll) { overflow-y: hidden; }`, `html:root > body.no-scroll { overflow-y: visible; }`)
  become one exported constant both classes use; the stay class's bytes don't change.
- G2. `pinnedClass(page)`: `versioned(`${page}__site-pinned`, …)` holding exactly those three lines. It goes on the
  root of each part's paste and each one-section paste that holds at least one box the rule pinned, right after the
  scroll lock (through `rootClasses`, `parts.ts:153`, and `siteToBricks`' root classes), and in `classIdsOf`'s list only
  then. A paste with no pinned box holds no such class and keeps every id.
- G3. It writes no property of any element (document-level lines only), so no two classes write one property; where a
  page holds both the header's class and this one, both say the same three lines.

### N. Notes (`notes.txt`, the page part's, right after the Elementor step's own)

- N1. One line when at least one box is pinned: how many, that they are Bricks' own Position: Sticky with Top (Style →
  Layout → Position; no code), that each lets go when its parent's content ends, "up to <tail> px sooner than on the
  old site" (S10; no number when it can't be read), and the helper class's name with what it is for.
- N2. One line per box left as today: `Elementor <kind> <id>: the old site's script pins it while the page scrolls;
  <why>, so it scrolls with the page here as before (in Bricks: Style → Layout → Position)`, the why being S2–S7's.
- N3. `structure.txt` doesn't change (no element is added, removed, renamed or relabelled).

### F. The fixture site and the tests

- F1. `test/fixtures/web/sites/elementor-sticky/` from `<E>/proto/fixture-elementor-sticky/` (generic content; real
  jQuery 3.7.1 and Pro's `jquery.sticky.min.js` as byte copies with `SOURCES.txt` and `SHA256SUMS`, as
  `elementor-swiper8` does; `init.js` after Pro's handler). The builder adds to it: a pinned container inside a boxed
  parent (`e-con-boxed > e-con-inner`); a legacy `elementor-section > elementor-container > elementor-column >
  elementor-widget-wrap` with a pinned widget (the classic sticky sidebar); a box pinned on desktops and tablets only
  that shows on phones; one pinned card that also plays an entrance. Each new shape must pass the scroll test like the
  others; a shape that can't (after `systematic-debugging`) is left as today with its own N2 note and reported as a
  ruling, never shipped pinned at the wrong place.
- F2. Unit captures: `test/fixtures/site-sticky-code.ts` (hand-made, as `site-elementor-code.ts`; **not** added to
  `site-no-div-pins.ts` `sitePastes`, whose 608 keys earlier jobs pin).
- F3. No renderer change: `test/browser/render.ts` prints `_position`, `_top`, `_zIndex` (measured in Chrome).

### P. The plugin side

The plugin makes one sticky thing today: its own header bar (`understand/header-bar.ts:76` → `style/style.ts:98-99`,
custom CSS; plugin-parity adds its guard). It doesn't read Figma's Fixed or Sticky scroll behaviour
(`snapshot/schema.ts:22` keeps `scrollBehavior` and `numberOfFixedChildren`; nothing in `src/core` reads them; the
corpus files and the repo's debug files hold no `scrollBehavior`, every `numberOfFixedChildren` is 0). No file under
`src/plugin`, `src/ui`, `src/shared` or `src/core` outside `src/core/site/` changes, and the build is byte for byte
the base's (measured). The follow-up records the shape both tools then share: `_position: "sticky"` + `_top`.

## The standard, point by point ("built like a skilled Bricks builder made it by hand")

1. **Structure:** no element is added or removed; the cards stay the Blocks they are in their Section. No wrapper, no
   spacer copy, no Code element.
2. **Classes:** Position, Top and z-index sit on the class that already carries the box's own look (cards that differ
   in Top or z-index differ there already); one helper class on the root, named by its purpose, writing no element's
   property. No new class per element.
3. **Settings before custom CSS:** `_position`, `_top`, `_zIndex` are Bricks' own controls (read in 2.2's source). CSS
   only where the widths don't fall on Bricks' breakpoints (Q4) or a value has no control (`z-index` back to none).
4. **Bricks' own behaviour:** the browser's sticky through Bricks' Position control replaces Elementor's script: no
   Interaction and no Code needed.
5. **Editable content:** a pro opens the card → Style → Layout: Position "Sticky", Top "2px"; changing Top moves where
   it stops, Position "Relative" turns it off (criterion 8 proves the edit works in the drawing).
6. **Looks stay true:** identical to the site at every scroll step until a card lets go; the one difference (it lets
   go up to the parent's bottom padding sooner) is named in the notes with its px (Q1). What can't be done truly is
   left as today and named, never approximated.

## Acceptance criteria (all **proposed**)

"The fixture" is F1's site captured on 127.0.0.1; "the rule off" is `ConvertOptions.sticky: false`; "pinned boxes" are
the boxes S8 writes. Chrome tests draw with Bricks 2.4.2's front-end CSS and with 2.3.9's.

- AC1 (proposed): Given a hand-made Elementor capture holding a container set Sticky: Top with Stay In Column inside a container, pinned at every width, with offsets 2 and 3 and z-index 1 and none: with `--elementor` each box's class holds `_position: "sticky"`, `_top: "2px"` (and `"3px"`) and `_zIndex` (its own `"1"`; `"99"` where it had none) as settings, with no `position`, `top` or `z-index` in any custom CSS, no Code element and no added element, and the same tree, labels and element ids as with the rule off; a pinned widget's own box carries them; the one-section paste of that section holds the same classes. Test `test/unit/site-sticky-boxes.test.ts` "a box the site pins inside its parent is Position: Sticky with Top in its class's settings".
- AC2 (proposed): Given Sticky On lists, per-device offsets and breakpoints: a box pinned on desktops and tablets only (site breakpoints 1024 and 767) has `_position: "sticky"` and `_top` with `_position:mobile_landscape` its own position and `_top:mobile_landscape: "0px"`, and its `z-index: 99` only from 768 up; a box pinned on desktops only is pinned exactly from 1025 up in bounded blocks of its class's CSS with no `revert`; `sticky_offset_tablet` gives the tablet range its own Top and a device without one takes the next wider device's; a box with a `top` or `bottom` of its own at an unpinned width keeps it. Test `test/unit/site-sticky-boxes.test.ts` "a box is pinned at the widths Sticky On names, each with its own offset".
- AC3 (proposed): Given one box of each kind the rule leaves (Sticky: Bottom; no Stay In Column; a top-level container with Stay In Column; a parent with none of Pro's parent classes; Sticky On leaving a size out on a site with a breakpoint that is no Elementor default; one capture range covering sizes the list treats differently; an ancestor with `overflow: hidden`, `auto` or `scroll` at a pinned width), each pastes exactly as with the rule off and is named once in the notes with its reason; a box under an ancestor with `overflow: clip` or `visible` is pinned; a script-made copy is ignored; a header part's bars keep the stay class and nothing else. Test `test/unit/site-sticky-boxes.test.ts` "a box Sticky can't pin as the site does stays as before and is named once".
- AC4 (proposed): Given a capture with pinned boxes: the page part's notes hold one line with their count, "Position: Sticky", the largest tail in px (the parent's bottom padding plus the box's bottom margin; no number when it isn't plain px) and the helper class's name; the page's paste and a one-section paste holding a pinned box carry the helper class on their root right after the scroll lock with exactly the three guard lines, a paste without a pinned box holds none, the header's stay class is byte for byte as before, and `structure.txt` equals the rule-off one. Test `test/unit/site-sticky-boxes.test.ts` "the notes count the pinned boxes and their tail, and the paste that pins carries the guard class".
- AC5 (proposed): Given the fixture pasted whole (header, page, footer; `--elementor`) at 1440 and 1024: at scroll 0, 400, 800 and 1200 px every pinned box's top equals the old site's (0.5 px); over the whole page in 200 px steps no pinned box is lower than the site's nor more than its named tail higher (0.5 px), a box is higher only after the paste's box has let go, the page heights are equal, both Bricks versions agree (0.5 px), every shape of F1 is covered, and with the rule off the same check fails. Test `test/web/site-sticky-boxes.test.ts` "pinned boxes sit where the old site's do at every scroll step at 1440 and 1024".
- AC6 (proposed): Given the same paste at 1000, 992, 768, 600, 478 and 390 (a width in every Bricks tier and one between Bricks' and the site's tablet breakpoints): every box is where the old site's is at every 200 px step under the same rule as the 5th criterion, a box the site hides on phones stays hidden, nothing is pinned at a width where the site pins nothing, and the page never scrolls sideways. Test `test/web/site-sticky-boxes.test.ts` "phones and every Bricks tier: nothing is pinned that the old site doesn't pin".
- AC7 (proposed): Given the pinned cards under the kept header: at every step where a card is pinned, what the window shows 40 px under its top is the header, as on the old site; the cards pin with the scroll lock's `overflow-x: clip` on html and body; with `html, body { max-width: 100%; overflow-x: hidden; }` printed after the paste's CSS they pin in the whole paste and in the page's paste alone (the first card's top equals its Top after 800 px), and the page's paste alone without the helper class does not. Test `test/web/site-sticky-boxes.test.ts` "the header stays over the pinned cards, and they pin with overflow-x hidden in Additional CSS".
- AC8 (proposed): Given the fixture's paste with one pinned card's class edited as a Bricks pro would (Top `100px`; then Position `relative`): drawn, that card stops 100 px under the window's top and the other cards are unmoved; with Position `relative` it scrolls with the page; no other rule of the paste out-weighs either edit. Test `test/web/site-sticky-boxes.test.ts` "changing Top or Position in the card's class moves or unpins that card alone".
- AC9 (proposed): Given `npm run site:check -- <the fixture's capture> --whole --elementor`, every part-and-width row's worst px is no greater than the same run with `--no-sticky`, and no row is added or lost. Test `test/web/site-sticky-boxes.test.ts` "site:check reads no row worse with the rule than without it".
- AC10 (proposed): Given every hand-made code capture's pastes (site-no-div's list: each fixture maker × the Elementor step off and on × both text modes × both picture modes × the whole page and every section; none holds a box pinned inside its parent), each is byte for byte the same with the rule on and off, and without `--elementor` the unit captures of F2 paste the same too. Test `test/unit/site-sticky-off.test.ts` "a capture with no box pinned inside its parent pastes the same with the rule on and off".
- AC11 (proposed): Given the rule off, every paste of that list is byte for byte the paste the job's base made, by sums recorded on a `git archive` of the base in Task 1 (`test/fixtures/site-sticky-pins.json`; named only, `F2B_PIN_BASE=1`). Test `test/unit/site-sticky-off.test.ts` "with the rule off every paste is byte for byte the base's".
- AC12 (proposed): Given the base tree (`F2B_STORY_PINS=1`, `F2B_BASE_TREE`): no file under `src/plugin`, `src/ui`, `src/shared`, `src/web` or `src/core` outside `src/core/site/` differs from the base, and `npm run build` gives `dist/code.js` and `dist/ui.html` byte for byte the base's, so every Figma paste and the panel are as before. Test `test/unit/site-sticky-figma.test.ts` "the Figma plugin and the panel build byte for byte as on the base".
- AC13 (proposed) (live): Justin, on B-Dry staging: he scans one service page of bdryswi.com with the new build (`npm run site:import -- https://bdryswi.com/basement-waterproofing/ <staging> --elementor`), pastes header, page and footer into an emptied page; on a desktop and at tablet width the three cards stop at the top one after the other and stack as on bdryswi.com (they start to move up about 50 px sooner at the end, as the notes say); on a phone the cards are not there, as on the site; in Bricks he clicks the first card → Style → Layout: Position reads Sticky and Top 2px; he sets Top to 100px and that card alone stops lower; he sets it back. The plugin has no check owed (it changes by no byte).

## Touched files (base: main after the five jobs in flight; paths as on `48fe133c`)

New: `src/core/site/elementor-sticky.ts` (~130 lines); `test/fixtures/site-sticky-code.ts`;
`test/unit/site-sticky-boxes.test.ts`; `test/unit/site-sticky-off.test.ts`; `test/unit/lib/site-sticky-pins.ts`;
`test/fixtures/site-sticky-pins.json`; `test/unit/site-sticky-figma.test.ts`;
`test/fixtures/web/sites/elementor-sticky/` (`index.html`, `style.css`, `init.js`, `jquery.min.js`,
`jquery.sticky.min.js`, `SOURCES.txt`, `SHA256SUMS`); `test/web/site-sticky-boxes.test.ts`;
`docs/plans/<date>-site-sticky-cards.md` and its ledger.

Changed: `src/core/site/parts.ts` (the call, the notes, the root class); `src/core/site/convert.ts`
(`ConvertOptions.sticky`, `siteToBricks`' call and root class); `src/core/site/stay.ts` (the guard constant,
`pinnedClass`); `tools/site-check.ts` (`--no-sticky`, test only); `test/unit/site-elementor-unchanged.test.ts:78` (the
list of Elementor files gains `elementor-sticky.ts`: it must import only its own folder and the snapshot types, which
the prototype does); earlier jobs' named-only pins that list files a later job may change (`media-avif-untouched`'s
`LATER_JOBS` and the like: add this job's new file, nothing else); `reference/bricks/README.md`; `docs/HANDOFF.md`.

Not touched: `src/web/` (the capture), `src/plugin`, `src/ui`, `src/shared`, every other `src/core` folder, the
renderer, `controls.ts`, `controls-more.ts`, `class-source.ts`, `elementor-fold.ts`, `fold-boxes.ts`, `lift.ts`,
`widgets.ts`, `site:upload`, `site:import`, `site:live`.

## Tasks (test first; commit after each passing task; `engineering-best-practices`, `test-driven-development`)

**Milestone 0: the base.**
- Task 0. `claude -w site-sticky-cards` on main once site-no-div, site-shared-styles, importer-parity, plugin-parity
  and shared-palette are merged. Read `figma-to-bricks/references/repeat-mistakes.md` and
  `feature-dispatch/references/repeat-mistakes.md`. `npm run check`, `npm run corpus`; start the ledger
  (`.superpowers/sdd/site-sticky-cards/progress.md`).
- Task 1. Record the base: a `git archive` of the base under `~/.cache/`, `test/unit/lib/site-sticky-pins.ts` (as
  `site-parity-pins.ts`: `sitePastes(root, { sticky: false })`) writes `test/fixtures/site-sticky-pins.json`; the
  base's `dist/` sums for the 12th criterion; the tallies of `npm test` by test name.

**Milestone 1: the rule (unit).**
- Task 2. `test/fixtures/site-sticky-code.ts` and the 1st criterion's test, RED; then `elementor-sticky.ts` S1, S8, S10
  from the prototype, the call in `sitePage` and `siteToBricks` (W1), `ConvertOptions.sticky` (W2), the Elementor
  files list (`site-elementor-unchanged.test.ts`). GREEN.
- Task 3. The 2nd criterion's test, RED; S5, S6, S9. GREEN.
- Task 4. The 3rd criterion's test, one case per refusal, RED; S2, S3, S4, S7 and the header and copy skips. GREEN.
  For each refusal, show its test fails with that refusal taken out (the ledger keeps the run).
- Task 5. The 4th criterion's test, RED; N1–N3 and G1–G2. GREEN. Check the stay class's bytes against the base.

**Milestone 2: Chrome.**
- Task 6. The fixture site from the prototype with `SOURCES.txt` and `SHA256SUMS`; the 5th criterion's test on the
  prototype's shapes: RED with the rule off (`sticky: false`), GREEN with it.
- Task 7. The 6th and 7th criteria's tests (the 7th RED without the helper class: the page's paste alone with the
  Additional CSS line).
- Task 8. The 8th criterion's test (edit the class in the payload, draw, measure).
- Task 9. The fixture's four added shapes (F1), one at a time, each through the 5th and 6th criteria's tests. A shape
  that fails: `systematic-debugging` first; if Sticky can't match it, a new refusal with its note, its unit case in the
  3rd criterion's test, and a ruling in the ledger and the report.
- Task 10. `tools/site-check.ts` `--no-sticky` and the 9th criterion's test.

**Milestone 3: nothing else moved.**
- Task 11. The 10th, 11th and 12th criteria's tests (`F2B_PIN_BASE=1`; `F2B_STORY_PINS=1` with `F2B_BASE_TREE`); earlier
  jobs' file-list pins gain the new file.
- Task 12. Gates: `npm run check`, `npm run corpus`, `npm run test:web` (the new file and `site-sticky-header`,
  `site-native-structure`, `site-no-div-elementor`, `site-elementor-proof`), `test/unit/site-no-revert.test.ts`. Tallies
  against Task 1 by test name. Any command that dies with SIGTERM, 143, 137 or "Killed": check earlyoom before reading
  it as a result (global CLAUDE.md); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`.

**Milestone 4: records.** Task 13: "Docs & records" below. Stop at `ready-for-review`.

Agents never load bdryswi.com, B-Dry staging or any live site, never run `site:upload` or `site:import` against a
real site, and never ask for or hold a password; Chrome only on 127.0.0.1 fixtures.

## Overlaps and order

Build after the five jobs in flight are on main. What this job assumes from each:

| Job | Shared files | Assumed | If it isn't there |
|---|---|---|---|
| importer-parity (`48fe133c`) | `convert.ts`, `parts.ts`, `controls.ts`, `controls-more.ts`, `class-source.ts` | `position`, `top`, `z-index` become `_position`, `_top`, `_zIndex` when plain and on Bricks' breakpoints (`controls-more.ts:18`); K2 keeps them CSS only on a part's top element (a pinned box never is one: its parent is a container) | the same declarations land in the class's custom CSS: still pinned, but the 1st and 2nd criteria fail. Don't build before it |
| site-shared-styles (`7b7501bd`) | `parts.ts`, `convert.ts`, `classes.ts` | a box's own difference sits on its own class beside the shared look class; root classes go through `rootClasses` and `classIdsOf` | keep both lists on a rebase: the new class joins after the lock |
| site-no-div (`cf4f887d`) | `parts.ts`, `convert.ts`, `fold-boxes.ts`, `elementor-fold.ts`, `site-no-div-pins.ts` | a wrapper around a sticky box isn't folded (`fold-boxes.ts:132`), a positioned widget keeps its box (`elementor-fold.ts:191`); `sitePastes` is the list of pastes to pin | — |
| site-native-structure, site-sticky-header (on main) | `parts.ts`, `lift.ts`, `stay.ts` | a part's root that draws nothing is left out and its top Sections carry the root classes; the stay class's text and name | G1 keeps the stay class's bytes: check them |
| plugin-parity (`89e41a0d`) | none (`src/core/style`, `emit`; its switch `asBefore.sticky` is the plugin's `ConvertOptions`, another type) | — | — |
| shared-palette (`9070c50f`) | `convert.ts`, `parts.ts` (colours) | — | rebase keeps both |

Planned jobs with no branch yet that touch the same files (whoever merges second rebases; no rule conflicts):
short-class-names (renames `<page>__site-pinned-<4>` like the stay class: add it to its helper table as
`<p>-sticky-boxes`), look-grouping (moves a copy's own difference to the element: W3), clean-values, native-widgets
(`parts.ts`, `convert.ts`). page-faq-slide: no shared rule.

## Risks and known limits

- **The end of the stack** differs by the parent's bottom padding (Q1); named in the notes.
- **z-index 99 at all times** on a pinned box with none of its own (Q2): it makes a stacking context even while the
  box isn't pinned. B-Dry's cards have their own.
- **Logged in**, a pinned box sits under the admin bar by its height (Q3).
- **Safari before 16** has no `overflow: clip`; the scroll lock falls back to `hidden` there and nothing sticks, the
  header included (site-scroll-lock's known limit).
- **A box in Bricks around the cards set to Overflow: hidden** later unpins them; the note N1 says Sticky needs every
  box around it to leave overflow visible.
- **A card pinned at the top of the page when the scan loads** was already pinned by the script: its box is the
  script's then (`scripted`), `site:check` doesn't compare it, and its captured z-index may read 99; the rule gives the
  same result.
- **The look Elementor switches to after scrolling** (`sticky_effects_offset`) isn't copied (as the header's note says).
- **Not prototyped:** a boxed parent, a legacy column, an entrance on a pinned card (Task 9 proves or refuses each).

## Follow-ups (recorded, not built)

1. The Figma plugin: Figma's Fixed and Sticky scroll behaviour as `_position` + `_top`, once a real design shows it.
2. A site that isn't Elementor whose script pins a box (the scan scrolls and records which boxes stay).
3. An Elementor bar pinned without Stay In Column outside the header (a sub-menu): Sticky inside the page would hold it
   until the page's content ends.
4. Sticky: Bottom.
5. The capture records Elementor's device names with its breakpoints, so a partial Sticky On pins on a site with
   custom breakpoints.
6. The exact end of a stack (Q1 B).
7. A pinned widget whose box adds nothing: the setting on the Bricks element itself, the box folded.
8. Top with the admin bar's height for logged-in users (Q3 B).

## Docs & records

1. The plan copied to `docs/plans/<date>-site-sticky-cards.md`; the ledger moved by the finisher to
   `docs/plans/<date>-site-sticky-cards-ledger.md` before the final premerge commit and rebase.
2. `docs/HANDOFF.md`: a new section above the previous top heading ("Boxes the old site pins while scrolling are
   Position: Sticky"): the rule S1–S10, the guard class, the eight rulings as "not yet confirmed", the follow-ups, the
   builder's rulings (Task 9), and the paste check owed for the live criterion (the next free id at the merge: the
   finisher checks main's HANDOFF, every local branch's and the plan folder), its entry at the top of "End-of-run
   check list".
3. `reference/bricks/README.md`: "Position: Sticky": `_position: "sticky"` with `_top` (and `_zIndex`), read in Bricks
   2.2's `base.php` L488-523 and `setup.php` L1098-1104; no sample of Justin's holds it yet (ask for one when he next
   copies from Bricks).
4. `BUILD` bumped at the merge (never in the copy).
5. Main `CLAUDE.md` after the merge: the Status line (build, one line for this job with its paste check); in "Working
   in this repo": "a box a page builder's script pins inside its parent pastes as Bricks' Position: Sticky with Top
   (`src/core/site/elementor-sticky.ts`), never a Code element; a paste that pins a box carries the guard class, since
   `overflow-x: hidden` on html and body stops every sticky box"; in "Known open bugs and limits" nothing new beyond
   HANDOFF.
6. Proposed line for `figma-to-bricks/references/rules-summary.md` (the finisher returns it; the main session saves
   it): "Elementor Sticky Top + Stay In Column → `_position: sticky` + `_top` on the box's class
   (`elementor-sticky.ts`); everything else pinned by a script is left and named."

## Reporting (the builder's and every later role's report)

Status, the head, each criterion with its test's result, the tallies against the base by test name, rulings made
while building (Task 9's above all), `skill_lessons[{skill, lesson, evidence, enforce}]`, ending with
`MAIN SESSION: check and save these skill_lessons now.` Reviewers and auditors also answer: "would a Bricks pro find
this logical and easy to change?"
