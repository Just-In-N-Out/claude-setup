# site-reviews: another company's widget pastes live (website importer)

Planner: fresh Opus 5.5 (high), 2026-11-09, Mini pipeline. Base: `main` `fd1986dcdbc8cf35f114b80be456e94279346743`
(Build 2026-11-09.3). Evidence: `~/.hermes/plans/figma-to-bricks/evidence/site-reviews/planner/` (`<E>` below).
The builder copies this file to `docs/plans/2026-11-09-site-reviews.md` in its first commit (repo rule: plans live in
git) and keeps its ledger in `.superpowers/sdd/2026-11-09-site-reviews/progress.md`.

## Amendments (planner, 2026-11-09, wording only; a fresh verifier or auditor reads this first)

Two fix rounds refined what three criteria state and added a rule (review 1 → fixer 1, review 2 → fixer 2; review 3 is
clean on head `6fb06ea2b1d3f451d3a3a6c51cd53915fca0b117`, where the verifier accepted every criterion). This amendment
brings the plan's words to that head and changes nothing else: no source, no test, no decision. No AC is added,
removed, renumbered or retagged; the live set is still the ninth criterion alone; every cited test name is unchanged.
Every changed or added line below carries *(amendment N)*.

- **Amendment 1 (review 1's R1-2, fixer 1; the third and eighth criteria, the general rule, one Variations line):** the
  pasted code is never "the snippet". The capture keeps a slot's own served markup apart, byte for byte, as
  `web.embeds[].slot` (how "slot" only), and the code method pastes that and nothing else of the page: the slot's own
  served markup, or the loader's own tag at its own place (amendment 4). The entry's `snippet` is that markup followed
  by whatever tags web-embeds rule 2 collects from elsewhere in the page (inline scripts naming the widget's host, such
  as its tracking tags); the code route never pastes those to run. An embed whose code was collected another way (how
  creator, host, frame, live, made) and an entry without `slot` (every capture before this build) keep the copy. In
  both criteria's own fixtures the snippet and the slot's markup are the same bytes (the unit fixture gives both the
  same text; B-Dry's stand-in page serves no other script: `evidence/site-reviews/fixer-1/gates/probe-bdry.txt`,
  "slot = snippet (365 chars)"), so their cited tests are unchanged and still prove the paste. The clause "nothing else
  of the page rides along" is proven by the supporting tests named under the third criterion: its cited test alone
  doesn't tell `slot` from `snippet` (the verifier's whole-snippet mutant, `verifier/gates/probe-track-mutant-U2.log`,
  is killed in the repo only by the R1-2 unit test, `verifier/gates/mutants/U2.log`).
- **Amendment 2 (the same fix; the first criterion):** its "snippet … byte for byte" clause holds on its fixture, where
  web-embeds rule 2 collects nothing from elsewhere in the page. The text that is always the slot's own served markup
  byte for byte, nothing added, is the entry's `slot`. The line says so; its cited test, which reads the snippet, is
  unchanged.
- **Amendment 3 (review 1's R1-4, fixer 1; the fifth criterion, Q5, the general rule):** `site:check` no longer
  compares "nothing inside" a live slot. It stands in only for what the script made, at the size the capture read at
  each width, and compares the slot and every served box inside it (the capture keeps their boxes at every width in
  `web.embeds[].inside`; the paste carries their looks on the slot's class).
- **Amendment 4 (review 1's R1-3, review 2's R2-1 and R2-2, fixer 2's rule; the general rule's new second paragraph, one
  Variations line, the third criterion's own-place clause, supporting tests under the first three criteria):** a loader
  outside a served slot. A script tag alone is a widget's whole code only where the capture proves the tag draws it by
  itself; any doubt keeps the copy, which the paste's copied-elements note counts.
- **Amendment 5 (editorial):** the seventh criterion's second test name was wrapped across two lines in the approved
  copy (`ac-check.sh` matches plan lines one by one). It is whole on one line now; no word changed. The name:
  "AC7 B-Dry's 2026-11-09 capture is unchanged"
- **To be confirmed with Justin (the one thing the reviews left to him: review 2's R2-3).** By the own-place rule, any
  tag of another host that drew one visible thing beside itself pastes to run at its own place, a visible visit counter
  or an ad tag included. It is that tag alone, and the paste's note names its host ("another company's widget (<host>)
  pastes live where it showed"), so nothing rides along unseen. The head pastes such tags live; whether a counter or an
  ad should stay a still copy instead is his ruling. No criterion depends on it.
- **Unmarked sections.** The Questions' answers, Design, Tasks, Known limits and Overlaps are the text the builder
  worked from, unchanged but for the marked lines. Where Design 2 and 3 describe the first build (`liveWidgets`
  returning the snippet, "J5-era captures work too", one stand-in style on the slot's first element with nothing inside
  compared), the amended rule and criteria hold, and `docs/HANDOFF.md`'s section "Another company's widget pastes live
  (site-reviews, …)" describes the head.

**Receipts that still encode the behaviour before an amendment.** None needs a re-run for the head: the verifier's
receipts (`evidence/site-reviews/verifier/`) are all on `6fb06ea2`. No cited test's own assertions changed after the
builder's last head (`git diff 91a43d2d 6fb06ea2` over the cited tests' files only adds tests to the unit file and the
`slot` and own-place fields to its fixture), so an old pass line of a cited test doesn't show which behaviour ran. Sort
a head by its source, or by the supporting test it holds, never by a cited test's text. Each grep prints 0 on the old
side and 1 on the new (run on the base and all 24 commits `fd1986dc..6fb06ea2`):

- Amendments 1 and 2: `git show <head>:src/core/site/live.ts | grep -c 'code: e\.slot'`, or on the test side
  `git show <head>:test/unit/site-live-widget.test.ts | grep -c "R1-2 only the slot's own served markup is pasted to run"`:
  0 up to `812240f4`, 1 from `8cf5362e`. Old side: every builder receipt (`builder/**`, heads `8977a7b1` to `91a43d2d`)
  and `fixer-1/red/on-91a43d2d/`. There the Code element's code was the capture's whole snippet and no `slot` existed.
  Their cited-test pass lines hold at head too (the same bytes on those fixtures). What is expected now and wasn't then:
  a capture whose snippet holds tags from outside the slot pasted them all and now pastes the slot alone; an embed read
  how host, frame, creator, live or made pasted its snippet and now keeps the copy.
- Amendment 3: `git show <head>:tools/site-check.ts | grep -c 'liveStandIn('`: the same split (0 up to `812240f4`, 1
  from `8cf5362e`). Old side: `builder/ac5/`, `builder/cont/s3/`, `builder/cont/final-b0421110/`,
  `builder/cont/final-head/` and the stand-in mutants `builder/cont/mutants/S1.log` and `S3.log`: the check forced the
  slot's first element to the capture's height and compared nothing inside it. Expected now: the innermost served box
  takes that height and every served box inside the slot is compared (the `live-widget` fixture's `div.holder`). The
  two mutants failed on the cited test, which is unchanged, so they stay valid; at head the verifier's
  `gates/mutants/S1.log` and `S2.log` are the stand-in's receipts.
- Amendment 4, two greps: `git show <head>:src/web/read/embeds.ts | grep -c 'const ownPlace'` (0 up to `812240f4`: no
  own place, a loader in a painted or shared box was the copy; 1 from `8cf5362e`) and
  `git show <head>:src/web/read/embeds.ts | grep -c 'CODE\.test(e\.tagName)'` (0 up to `77bd97f5`: a tag beside one
  thing its file drew was an embed whatever else its box held; 1 from `339c8d82`: the three proofs). Between the two
  (fixer 1's heads `8cf5362e` to `77bd97f5`): `fixer-1/mutants/`, `fixer-1/gates/`, and on purpose
  `fixer-2/red/` (the new tests failing on `77bd97f5`) and `fixer-2/verify/p4-reviewed-head.log` (review 2's probe).
  Expected now and not then: an embed code of a placeholder its script replaces, or of a library's tag and an inline
  call, in a painted or shared box, and a strip a tag draws into `<body>`, are no embeds (there they were how "slot"
  embeds of the bare tag). Fixer 1's own tests and fixtures (`site-widget-places`, the unit R1-3 test) are unchanged by
  fixer 2 and pass on both sides. One mutant receipt changed meaning: fixer 1's `mutants/C17.log` (killed at
  `33c31235`) survives alone at head, because the place check refuses the same case; `fixer-2/mutants/C17N3.log` is the
  pair that is killed.
- A stamp caveat: some fixer receipts ran before their commit and say so in the stamp (`HEAD=812240f4… dirty=19` in
  `fixer-1/green/r1-234-*`; `dirty=7`, `dirty=11` and `dirty=12` elsewhere). Such a receipt holds the next commit's
  change: sort it by what its own log shows, not by the stamped commit (a unit log whose R1-2 line is `ok` is on the
  new side; `not ok` there is the new tests on the old source, as `fixer-1/red/on-91a43d2d/` stamps itself:
  `91a43d2d…+tests-of-33c31235`).

**The text before this amendment:** `evidence/site-reviews/plan-approved.md` (the read-only copy, until the session
moves it aside), and the same bytes in the repo: `git show 6fb06ea2:docs/plans/2026-11-09-site-reviews.md` (first
committed in `8977a7b1`).

**The regex check** (`ac-check.sh`'s `ac_start`, `bad_id` and `live`, run on the approved copy and on this file): on
both, the same nine ids on nine lines, no bad id, and the live set is the ninth alone. Of the nine cited test names
(the seventh criterion cites two) eight were whole on one line in the approved copy; all nine are here (amendment 5).

## Questions (the standing auto-go takes the ⭐ answers)

- **Q1 What a paste holds for another company's widget** (a reviews strip, a booking or a gallery widget drawn by a
  script of another host, pasted where it goes on the old site). ⭐ **A:** the widget's own code, live: one Bricks Code
  element where it showed, holding the slot's markup as the old site served it (its loader `<script>`), so it shows
  today's reviews, and its arrows, "Read more" and phone swipe work as on the site. The capture's copy of it is left
  out. B: live, plus the capture's copy kept hidden as a fallback that shows when the script doesn't run (doubles the
  widget's markup: 401 elements on B-Dry; and a visitor sees the stale copy flash while the loader starts). C: the copy
  as today (stale words, dead arrows).
- **Q2 The slot's markup.** ⭐ **A:** byte for byte as the old site served it (web-embeds ruling W2), the page
  builder's own class names and `data-*` on its wrappers included: a widget may find its place by them (an
  `elfsight-app-<id>` class is the widget's key), and they style nothing on a Bricks site. The site's styles of the
  slot itself come from the paste's own class on it (`<page>__…`), as for every element. B: strip `class`, `id`,
  `data-*` from the slot's elements (breaks widgets keyed on a class).
- **Q3 A capture that didn't take the widget's code** (every capture before this build, Justin's 2026-11-09 one
  included: it holds no loader address at all, `<E>/scan-capture.txt`). ⭐ **A:** pasted exactly as today (the copy),
  with the note saying so and "capture again with this build"; nothing guessed. B: refuse to convert.
- **Q4 Floating extras of another company** (a chat bubble) in the code method. ⭐ **A:** not this job (a follow-up):
  the code method doesn't paste floating extras yet, and B-Dry has none to paste (its reCAPTCHA badge belongs with the
  form, OneTap is a plugin). B: add them now.
- **Q5 site:check and a live widget.** ⭐ **A:** the check draws a live widget's slot at the size the capture read at
  each width (its script never runs there: the check's Chrome reaches no other host) and compares the slot's box,
  nothing inside it. *(amendment 3: since review 1 the served boxes inside the slot are compared too; only what the
  script made is stood in and left out.)* B: let the check load the widget (network, other content every day: never
  stable).
- **Q6 A widget a WordPress plugin renders on the old site** (server-side markup from a plugin's shortcode, its script
  served from the site's own `wp-content/plugins/…`). ⭐ **A:** out of scope: it is the site's own markup, copied as
  today; a follow-up names the plugin to install on the new site (as the floating extras' "install <plugin>" note does).
  Not B-Dry's case: bdryswi.com's reviews are Trustindex's hosted loader in an Elementor HTML widget (proof below), and
  B-Dry staging has no Trustindex plugin (`<E>/staging-homev2-2026-11-09.html`: no plugin folder named, no `loader.js`,
  43 `cdn.trustindex.io` picture addresses of the pasted copy). B: build a plugin-to-shortcode table now.

## Playback

Justin pasted the importer's whole page of bdryswi.com (capture build 2026-11-09.1, paste build 2026-11-09.3,
`--elementor`) on B-Dry staging `/homev2/`. The "Customer Reviews" strip (Trustindex: cards, ‹ › arrows, "224 reviews",
"Write a review") shows only the three reviews the capture read; on bdryswi.com › brings more; on a phone it shows one
card with a swipe bar that does nothing (images/6.png, images/8.png). The paste's notes say "401 elements a script made
are copied as the capture read them (another company's widget, such as reviews: the words of the capture day; its
controls do nothing)". web-embeds (build 2026-11-03.2) was meant to make such a widget a Code element holding only its
own script. He wants: paste once, and the reviews work like the site.

## What the site does and what the paste does (proof)

- **The site serves one line where the reviews go** (`<E>/served-slot.txt`, from the saved 2026-10-29 page
  `evidence/quote-button-hover/planner/bdryswi-home.html` offset 550581): an Elementor HTML widget `f414ab0` whose
  `elementor-widget-container` holds only
  `<script defer async src='https://cdn.trustindex.io/loader.js?0ba3c27414da21862f7681d05e9'></script>`.
- **The loader replaces its own script tag with the widget.** Planner probe (`<E>/probe-trustindex.ts`, run by
  `<E>/run-probe.sh`, output `<E>/probe-trustindex.json`): that exact slot served on 127.0.0.1 (never bdryswi.com),
  the capture's own `tracker` and `embedFacts`, the real loader from `cdn.trustindex.io` (GET only). After a mouse move
  the widget filled in 3.6 s with 20 `.ti-review-item`s; the container then holds `div.ti-widget` and a `style`, both
  marked made by `https://cdn.trustindex.io/loader.js?0ba3c…`, and **no `script[src]` is left anywhere in the page**;
  `embedFacts` returned `[]`. It also shows the widget renders on an address that isn't B-Dry's (127.0.0.1).
- **The 2026-11-09 capture took it as copied elements** (`<E>/scan-capture.txt`, `<E>/made-elements.txt`):
  `web.embeds` holds only the Google map (`w904`); under the footer's `div:8` 429 of 432 code nodes are script-made
  (`~`), 20 `ti-review-item`s, 140 pictures from `cdn.trustindex.io`, `lh3.googleusercontent.com`,
  `graph.facebook.com`; the capture holds no `loader.js` address anywhere (0 mentions). Its slot climb
  (`<E>/slot-climb.txt`): `ti-widget` → `elementor-widget-container` (paints nothing) → `f414ab0` (`position:
  relative`, allowed) → stops at `e-con-inner` (`padding-block: 10px`): **the slot is `f414ab0`**,
  `body/div:0/footer:0/div:8/div:0/div:0`.
- **The paste copies them; staging shows the copy.** `paste-el3/notes.txt` line 119 (401 elements copied, footer);
  the staging page today (`<E>/staging-homev2-2026-11-09.html`, read logged out with `?f2b=`) holds no `loader.js`
  and 43 `cdn.trustindex.io` picture addresses. The staging-fit planner (shared findings) also found site:check
  counting the reviews' script-made avatars as missing at every width.
- **Bricks prints a Code element holding that loader as is**: on 2026-10-29 staging `/homev2/` held an earlier hand
  paste `<div id="brxe-ahbbsg" data-script-id="ahbbsg" class="brxe-code"><script defer async
  src='https://cdn.trustindex.io/loader.js?0ba3c…'></script></div>` (`<E>/served-slot.txt`). Sample:
  `reference/bricks/code-element.json` (`code`, `executeCode: true`); no new sample needed.

## Root cause (two, both needed)

1. **Capture:** `src/web/read/embeds.ts:135-136`
   `const holds = [...slot.querySelectorAll("script[src]")].some((s) => madeBy(s) === undefined && bare(hostOf(s.src)) === host); if (!holds) continue;`
   counts a script widget only while its parser-made `<script src>` is still in the live slot. A loader that replaces
   its own tag (Trustindex; any `currentScript.replaceWith(…)` loader) leaves none, so the widget is never an embed and
   its elements are read as ordinary script-made code nodes. Proven by the probe (`embedFacts` → `[]`, `scripts: []`).
2. **Code method:** `src/core/site/convert.ts:134-136` (prepare) never reads `web.embeds`: every script-made element in
   the tree is copied and named in the "copied as the capture read them" note. This is web-code-page's ruling Q5 A
   (`docs/plans/2026-11-04-web-code-page.md:91`, "B: the widget's own loader script in a Code element … later job";
   its "Next jobs" item 3). `grep -rn embeds src/core/site` finds nothing. So even a capture with the embed would still
   paste the copy; and with fix 1 alone the old Figma route would change but not the code method Justin uses.

## The general rule

**Another company's widget pasted where it goes on the old site pastes live.** A capture records it as an embed when
its creating script's tag was served inside its slot, whether or not that tag is still there once the script ran (the
slot's served markup is the witness). *(amendment 1)* The capture keeps the slot's own served markup apart, byte for
byte, as the entry's `slot` (`web.embeds[].slot`, how "slot" only); the entry's `snippet` is that markup followed by
any tags web-embeds rule 2 collects from elsewhere in the page (inline scripts naming the widget's host, such as its
tracking tags). In the code method, an embed (kind widget, how "slot") whose slot holds script-made elements and whose
`slot` holds a script the browser runs becomes one Code element at the slot: its `code` the slot's own served markup
byte for byte and nothing else of the page (no tag from outside the slot is ever pasted to run on the code route), its
`executeCode` on, the slot's own class styling that markup's first element (the Code element is flat, `site-flat`, as
the code method's markup elements are); nothing under the slot is pasted. *(amendment 3)* The served boxes inside the
slot are in the pasted markup as the old site served them: their looks ride on the slot's class, each at its place in
that markup, and the capture keeps each one's box at every width (`web.embeds[].inside`), so `site:check` compares
them. *(amendment 1)* An embed whose code was collected another way (how creator, host, frame, live, made) and an entry
without `slot` (every capture before this build) keep the copy. Everything else converts as today: served
frames (maps, a booking iframe) keep the markup route; the site's own scripts' drawings (a slider's live region, a
drawn headline mark: `<E>/made-elements.txt` page part) stay copied; captures without the embed paste the copy (Q3).
Recognised by structure (who made an element, what the server sent), never by a host, class or site.

*(amendment 4)* **A loader outside a served slot pastes live at its own place, and only where its tag is proven to be
the widget's whole code.** A loader in a painted box, or beside other content (a heading, a line of words), has no
served box that holds only what it drew. The embed's layer is then what the loader made (its element path ends in a
script-made step) and its `slot` is the loader's own tag as served; the code method pastes one Code element at that
place holding the tag, with `site-flat` and no class of its own (the widget styles what it makes), the box around it
and its neighbours as they are. A script tag alone is a widget's whole code only where the capture proves the tag
draws it by itself (`src/web/read/embeds.ts` `ownPlace`):
- the box the drawn element sits in is served, its served children hold a `<script src>` the browser runs of the very
  file that made the element, and the element is the only shown thing that file made there (review 1's R1-3);
- the tag is all the code its box was served with: no other `<script>` of any kind, no `<style>`, `<link>` or
  `<template>`, at any depth (what a `<noscript>` holds doesn't count: it never runs where scripts do);
- the script replaced nothing: the box's other served elements are all still its children, in the served order;
- what it drew stands where the tag was served, between the same served neighbours (in the tag's place, or right
  beside a tag that stays).

Any doubt keeps the copy: no embed, the elements pasted as the capture read them and counted in the paste's "copied as
the capture read them" note. So an embed code made of a placeholder its script replaces, or of a library's tag and an
inline call, stays a copy in a painted or shared box (alone in an unpainted box the box as served is the slot, and it
pastes live), and a strip another company's tag draws into `<body>` is no embed (review 2's R2-1 and R2-2). To be
confirmed with Justin (review 2's R2-3): a visible visit counter or an ad tag that drew one thing beside itself passes
these proofs and pastes to run, named in the note by its host; live as the head has it, or a still copy.

## Acceptance criteria

- **AC1 (proposed)** *(amendment 2)* A widget whose loader replaces its own `<script>` with what it draws, served
  inside an unpainted slot, is captured as one `web.embeds` entry: kind `widget`, `how: "slot"`, its layer the slot,
  its snippet the slot's served markup byte for byte on this fixture (holding the loader tag; web-embeds rule 2
  collects nothing from elsewhere in the fixture's page), and nothing inside the slot is a layer. Where a page serves
  tags that rule collects (inline scripts naming the widget's host), they follow that markup in the snippet; the text
  that is the slot's own served markup byte for byte, nothing added, is then the entry's `slot` (the first supporting
  test).
  Test: `test/web/capture-live-widget.test.ts` "AC1 a self-replacing loader's widget is one embed" (new fixture site
  `live-widget`; RED on main: `web.embeds` has no entry).
  Supporting tests *(amendments 2 and 4)*, never a report's cited test (`slot` beside a longer snippet; a loader's tag
  taken as the whole code at its own place):
  - `test/web/site-widget-places.test.ts` "R1-2 R1-3 R1-4 each widget is one embed whose slot is its own served markup"
  - `test/web/capture-widget-alone.test.ts` "R2-1 a tag alone in its box, beside a noscript, or kept beside what it drew is the widget's whole code"
  - `test/web/site-widget-codes.test.ts` "R2-1 an embed code its tag alone can't draw is no embed; the code alone in its box and a loader at its own place are"
- **AC2 (proposed)** No new embeds: on the same fixture, a script of the site's own host that replaces its own tag in
  a slot stays ordinary layers, and another host's script served in `<head>` that draws into a page box stays layers;
  `test/web/capture-embeds.test.ts` passes unchanged.
  Test: `test/web/capture-live-widget.test.ts` "AC2 own-host and head-loaded scripts stay layers" + the existing file.
  Supporting tests *(amendment 4)*, never a report's cited test (what the own-place rule refuses stays ordinary layers):
  - `test/web/capture-widget-alone.test.ts` "R2-1 a box served with more than the tag, or drawn in away from its tag, keeps the copy"
  - `test/web/capture-widget-alone.test.ts` "R2-2 a strip drawn into <body> is no embed: its tag ends <body>, its bar starts it"
  - `test/web/capture-widget-alone.test.ts` "R2-2 a strip drawn into <body> is no embed: its tag is served in <head> after a noscript picture"
  - `test/web/site-widget-places.test.ts` "R1-3 no embed where the box holds no running tag of the file that drew one thing there"
- **AC3 (proposed)** *(amendments 1 and 4)* The code method pastes such an embed live: one Code element at the slot
  whose `code` is the slot's own served markup byte for byte (the entry's `slot`; in this criterion's fixture the
  snippet is the same text) and `executeCode: true`, carrying the slot's own class (its rules on `> :first-child`), the
  shared `site-flat`; for a loader outside a served slot (the general rule's second paragraph) the `code` is the
  loader's own tag as served, at its own place, with `site-flat` and no class of its own; nothing else of the page
  rides along (no tag the capture's snippet collected from outside the slot is in any part's paste); no element under
  the slot in the paste or in `sources`; the payload's `live` list names its id;
  the notes say the widget pastes live (host named) and the signing step; the "copied as the capture read them" note
  counts only script-made elements outside live widgets.
  Test: `test/unit/site-live-widget.test.ts` "AC3 an embed's slot is one live Code element" (generic hand-made page
  code, `test/fixtures/site-page-code.ts` plus a slot of script-made cards and its embed entry; RED on main).
  Supporting tests *(amendments 1 and 4)*, never a report's cited test (they prove the two clauses the cited test's
  fixture can't show: nothing else rides along, and the loader's own tag at its own place):
  - `test/unit/site-live-widget.test.ts` "R1-2 only the slot's own served markup is pasted to run"
  - `test/unit/site-live-widget.test.ts` "R1-3 a loader in a painted or shared box pastes live at its own place"
  - `test/web/site-widget-places.test.ts` "R1-2 R1-3 R1-4 the paste holds each slot's own markup and nothing else to run"
  - `test/web/site-widget-places.test.ts` "R1-2 R1-3 the pasted widgets draw and page at their places; the old site's tracking never runs"
  - `test/web/site-widget-codes.test.ts` "R2-1 the paste holds the post and the form as copies, the controls live, and its notes say which"
  - `test/web/site-widget-codes.test.ts` "R2-1 the pasted page shows the post and the form where the site did; the controls draw live"
- **AC4 (proposed)** The pasted widget works: the `live-widget` fixture captured and converted (`siteParts`, with and
  without `elementor`), drawn by the renderer with the other origin serving: the widget's cards come from the other
  origin inside the slot, a click on its › control shows a card the first view didn't, at 390 (touch) a tap on its
  next control moves to the next card; the elements before and after the slot are within 2 px of the capture at 1440
  and 390.
  Test: `test/web/site-live-widget.test.ts` "AC4 the live widget pages and swipes in the paste" (RED on main: the
  paste holds the copy and the control does nothing).
- **AC5 (proposed)** *(amendment 3)* `npm run site:check` on the fixture capture is OK within 2 px at every width: only
  what a live widget's script made is stood in, at the size the capture read at each width (the innermost served box
  of its slot takes the capture's height there, the slot itself when it holds none; at a loader's own place its tag
  stands as a block of the box and margins of what it made), and left out of the comparison; the slot and every served
  box inside it are compared as boxes with the capture's.
  Test: `test/web/site-check-live-widget.test.ts` "AC5 site:check stands in for a live widget" (proven by a mutant:
  without the stand-in the elements after the slot move and it FAILs).
  Supporting tests *(amendment 3)*, never a report's cited test (a served box inside a slot is held to the capture: its
  rules dropped, the check FAILs naming it; a copy is measured as elements):
  - `test/web/site-widget-places.test.ts` "R1-3 R1-4 site:check stands in only for what the script made and holds the boxes inside a slot"
  - `test/web/site-widget-codes.test.ts` "R2-1 site:check measures the copies as elements and stands in for the three live widgets only"
  - `test/unit/site-live-widget.test.ts` "R1-4 the served boxes inside a live slot keep their look"
- **AC6 (proposed)** A capture without the widget's embed (every capture before this build) pastes byte for byte as on
  main, the note saying the copy is the capture day's and to capture again with this build.
  Test: `test/unit/site-live-widget.test.ts` "AC6 no embed: the copy as before" (the AC3 fixture without its embed
  entry; payload byte-identical to the fixture on main's code).
- **AC7 (proposed)** Nothing else changes: Figma designs (`npm run corpus`, `test/unit/plugin-convert.test.ts`), the
  code method's fixtures without another company's widget (`code-page`, every `elementor-*`, `site-page-code.ts`
  pastes) and Justin's 2026-11-09 capture's three parts (`--elementor` and plain) are byte-identical to main; only the
  notes' wording of the copied-elements note may change.
  Test: `test/unit/site-live-widget.test.ts` "AC7 pastes without a live widget are unchanged" (fixtures; golden JSON
  of main's output written in Task 0) +
  `test/web/site-live-widget-bdry.test.ts` "AC7 B-Dry's 2026-11-09 capture is unchanged" *(amendment 5: whole on one line)*
  (named-only `F2B_BDRY_CAPTURE`) + `npm run corpus`.
- **AC8 (proposed)** *(amendment 1)* B-Dry, named-only (network to `cdn.trustindex.io` only, GET): the saved 2026-10-29
  home page served as the code-proof stand-in on 127.0.0.1 with its one Trustindex `<script>` kept, captured with this
  build, has the reviews as one embed at `f414ab0` whose own served markup holds that loader tag byte for byte (the
  stand-in page serves no other script, so the entry's snippet and its `slot` are the same text, and the test reads the
  snippet); its `--elementor` footer paste holds one Code element there with that markup, nothing else of the page in
  its code, and none of the `ti-` elements; drawn with the network
  allowed to `cdn.trustindex.io`, the widget fills the slot with more than three reviews and › shows a review that
  wasn't showing. Test: `test/web/site-live-widget-bdry.test.ts` "AC8 B-Dry's reviews paste live" (named-only:
  `F2B_CODE_PROOF_BDRY`, `F2B_CODE_PROOF_CAPTURE`, `F2B_LIVE_WIDGET_NET=1`).
- **AC9 (proposed) (live)** Justin re-captures bdryswi.com with this build (together with staging-fit-capture's
  re-capture: one capture for both), runs `npm run site -- <capture> <out> --elementor`, pastes the whole page on B-Dry
  staging `/homev2/`, saves, runs Regenerate code signatures and LiteSpeed Purge All. Logged out (`?f2b=<random>`):
  "Customer Reviews" shows Trustindex's live widget, › brings reviews beyond the first three, "224 reviews" (or
  today's count) and "Write a review" as on bdryswi.com; on his iPhone one card shows and swiping moves to the next.
  The Bricks editor shows the Code element without the reviews (Bricks' editor runs no pasted code). Test: Justin's
  paste check (the next free HANDOFF id at the merge).

`(live)`: AC9 only. Figma designs byte-identical (AC7); the code method changes only where a capture holds another
company's widget embed whose slot a script filled (AC3/AC6).

## Design

### 1. Capture (`src/web/read/embeds.ts`, in-page)

In the "another company's boxes" loop (lines 129-139), a pick also counts when the slot's **served** counterpart holds
a `<script src>` of the creating host that the browser runs as JavaScript:
- compute the slot's path (`helpers.pathOf(slot)`) and `servedAt(path, slot)` (already defined at line 84; reuse it,
  and keep its result on the pick so the output loop doesn't parse twice);
- parse its markup with `DOMParser` and test its `script[src]` elements: host equal (`bare(hostOf(src))`), and a
  JavaScript type as web-embeds rule 2 reads it (no or empty `type`, a JavaScript MIME type in any case with
  parameters, `module`; no `type` and a `language` naming JavaScript). The function closes over nothing: write the
  type test inline (or pass `scriptTags` from `src/web/map/snippets.ts` as a helper only if it closes over nothing).
- `holds = live parser-made tag (as today) || served tag`. Nothing else changes: the slot climb, `liveOf`, the outermost
  filter, `snippetOf` (the served slot holds the loader, so `scriptsFor` answers `how: "slot"`).
The embed layer then follows (`map/tree.ts:97`: the slot's layer becomes the empty `embed` frame), so the old Figma
route also pastes it as a Code element (web-embeds' AC13 intent).

### 2. Code method (`src/core/site/`)

- New `src/core/site/live.ts`: `liveWidgets(capture, rootPath): Map<string, { snippet: string; host: string }>` (slot
  path → its code). For each `web.embeds` entry with `kind === "widget"` and a non-null snippet: its slot path is its
  layer's `web.source.path` (walk `capture.roots` for `id === nodeId`; no schema change, so J5-era captures work too);
  kept when the slot is `rootPath` or under it, `code.nodes[slot]` is shown, some shown code node under it has a `~`
  step, and `scriptTags(snippet)` (`src/web/map/snippets.ts`, pure) has a `js` tag. A served frame's embed has no `~`
  under it, so it stays on the markup route. Pure; about 50 lines.
- `prepare` (`convert.ts`): before `scan`, `const live = liveWidgets(original, rootPath)`; add every code node path
  under each slot to `skipped` (so `scan` and `buildTree` never visit them: no hidden-copy, markup or REBUILT notes
  from inside); delete each slot from `picks.choice` and `picks.pasteHidden` (the fold's choice never overrides it);
  pass `live: (path) => live.get(path)?.snippet ?? null` in the `KindContext`.
- `kinds.ts` `elementFor`: first line, `const own = ctx.live?.(path); if (own != null) return { name: "code", settings:
  { code: own, executeCode: true }, place: "inner", shared: [FLAT_SHARED], own: true };` (the same shape as the
  markup route at line 93, so `whereOf` puts the slot's class on `> :first-child`, the snippet's slot element).
- Notes (`convert.ts:134-136`): `made` counts only tree nodes outside live slots (unchanged count when there is none);
  its wording becomes "… copied as the capture read them (another company's widget a capture before build
  <BUILD of this merge> couldn't take live, or the site's own script's drawing: the words of the capture day; its
  controls do nothing; capture again with this build)"; one note per live widget: "another company's widget (<host>)
  pastes live where it showed: its own code in a Code element (today's content; it works on the live page, not in
  the Bricks editor)". `SIGN` already follows from the Code element.
- `SiteResult` / `PartResult` get `live: string[]` (the Code elements' ids); `tools/site.ts` writes them into
  `sources-<part>.json` as a sibling file `live-<part>.json` (keep `sources` unchanged in shape).
- If a slot's path isn't in the tree after the fold (a future fold merging it away), the copy route stays and a note
  names it (no crash); with today's fold an HTML widget is page code, so B-Dry's slot is kept.

### 3. site:check (`tools/site-check.ts`)

Read `live-<part>.json` (or `siteParts(...).live`). For each width, before reading, inject one style
`#brxe-<id> > :first-child { box-sizing: border-box; height: <capture box h at w>px; overflow: hidden }` per live Code
element (the slot's capture box at that width, `captureBoxes`). The slot stays in the compared items; nothing under
it is in `sources`. (The check's Chrome reaches no other host: `tools/lib/site-chrome.ts` SITE_OFFLINE.)

### Variations considered

- Loader tag left in place (badge.js style): unchanged path (live tag). Loader removed/replaced: new served path.
- *(amendment 4)* A loader in a painted parent, or beside other content: the climb stops at what the loader made (no
  served box holds only the widget), so the embed is at the loader's own place, its code the loader's own tag, where
  the capture proves the tag draws the widget by itself (the general rule's second paragraph); else the copy. (Was:
  "Slot climbs to a painted parent: stops there as today; the Code element's first child is the slot", which review 1's
  R1-3 showed the first build never did.)
- The slot itself script-made (`how: "live"`): its snippet is the live markup without the other host's elements plus
  its scripts; *(amendment 1)* the old Figma route still makes it a Code element, the code method keeps the copy (only
  a slot's own served markup is pasted to run). (Was: "still a Code element".)
- Two widgets of one host in two slots: one embed each (outermost slots, as today); each snippet holds only its own
  tag (rule 2 a).
- Phones: the slot's class carries its per-range rules; the widget lays itself out (Trustindex: one card + swipe).
- A capture cut to one part (`capture-part.ts`): layers kept, so `nodeId` lookup works.

## Tasks (test first; commit after each passing task; don't bump BUILD; never load bdryswi.com)

Gates per task: `npm run check`; `npm run corpus` before Task 1 and at the close; the touched `test:web` files
(Chrome: `TMPDIR` ≤ 38 chars, its own per job; close every Chrome; heavy runs under
`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`, B-Dry 8G).

0. **Base.** Record `npm run check`, `npm run corpus`, `test:web` tallies on the base. Write the AC7 goldens: main's
   `siteParts`/`siteToBricks` JSON for `pageCode()`, the `elementor-*` unit fixtures, and (named-only, outside the
   repo) Justin's capture's three parts plain and `--elementor` (`<evidence>/builder/golden/`).
1. **Fixture (AC1, AC2, AC4).** `test/fixtures/web/sites/live-widget/index.html`: header, a section "What clients say"
   whose unpainted `div.html-block > div.holder` holds only `<script defer async src="{{OTHER}}/carousel.js?k=demo">`
   inside a padded section box; a section of the site's own `selfswap.js` (same origin, replaces its tag with a box);
   a page box filled by `{{OTHER}}/headfill.js` loaded in `<head>`; a footer after the slot.
   `test/fixtures/web/third-party/carousel.js`: finds its own tag (`document.currentScript`, else
   `script[src*="carousel.js"]`), builds `div.cw > .cw-track` of 8 cards (3 per view above 767, 1 below), ‹ › buttons
   that page by `scrollLeft` on an `overflow:hidden` track, and on touch a next button; injects its own `<style>`;
   then `me.replaceWith(widget)`. No input wait (deterministic). Generic names only.
2. **Capture (AC1, AC2).** RED tests in `test/web/capture-live-widget.test.ts`; fix `embeds.ts` as Design 1;
   `capture-embeds.test.ts` green unchanged.
3. **Code method (AC3, AC6, AC7 unit).** RED tests in `test/unit/site-live-widget.test.ts` on `pageCode()` plus a
   slot (`${MAIN}/section:3/div:0`) of `~` cards and a `web.embeds` entry whose `nodeId` names a root layer with that
   `web.source.path`; build `live.ts`, the `prepare`/`kinds.ts`/notes/`live` changes. Prove AC3's test catches the bug
   (`git checkout HEAD~1 -- src/core/site` → RED).
4. **Paste works (AC4).** `test/web/site-live-widget.test.ts`: capture the fixture (`captureFixture("live-widget")`),
   `siteParts` plain and `elementor: true`, draw with `renderSitePaste` in a page whose Chrome reaches the fixture's
   two origins (as `capture-embeds.test.ts` AC3 does), click ›, tap at 390, measure before/after boxes.
5. **site:check (AC5).** `tools/site.ts` writes `live-<part>.json`; `tools/site-check.ts` stand-in; test runs the CLI
   on the fixture capture; mutant without the stand-in FAILs.
6. **B-Dry (AC7 named, AC8).** `test/web/site-live-widget-bdry.test.ts`: AC7 against the Task 0 goldens; AC8 with
   `buildStandIn(..., { keepScriptHosts: ["cdn.trustindex.io"] })` (a new option in
   `test/web/code-proof/standin.ts`: keep a `<script>` whose `src` host is listed, drop the rest as today) and a Chrome
   whose host rules also EXCLUDE `cdn.trustindex.io`; the capture must wake the loader (a first input: if the capture's
   wakers don't, record it and move the mouse over the slot in the test before reading, as the planner's probe did).
   Evidence: shots of the slot before/after ›, at 1440 and 390, in `<evidence>/builder/ac8/`.
7. **Records.** HANDOFF section "Another company's widget pastes live (site-reviews)" with Q1–Q6 rulings (⭐, not yet
   confirmed), the proof, limits (below), the paste check id for AC9 with Justin's steps in the end-of-run list
   (re-capture, `npm run site -- … --elementor`, paste whole, Cmd+S, Regenerate code signatures, Purge All, check
   logged out at 1440 and on iPhone); ledger to `docs/plans/2026-11-09-site-reviews-ledger.md` at finish.

## Known limits (HANDOFF)

- The live widget's content and height are another company's: site:check stands in at the capture's size (Q5 A); the
  live page is the judge (AC9).
- The Bricks editor doesn't run pasted code, so the reviews show only on the live page or Preview (CLAUDE.md).
- Trustindex (or any host) may refuse an address it wasn't set up for; the probe showed this widget drawing on
  127.0.0.1, so B-Dry staging is expected to work.
- WordPress-plugin widgets (Q6) and floating third-party extras (Q4) stay follow-ups.

## Overlaps with the other five jobs

- **staging-fit-capture** (`src/web/capture.ts`, `session.ts`, `styled.ts`, `src/core/site/blocks.ts`,
  `styled-ranges.ts`, `tools/site.ts`, `tools/site-check.ts`): both change the capture and both need Justin's
  re-capture: merge both before he re-captures, one capture for AC9 and theirs. Files shared: `tools/site.ts` (I add a
  `live-<part>.json` write) and `tools/site-check.ts` (I add a per-width style): small, separate hunks; either order.
- **staging-fit-renderer** (`test/browser/render*.ts`, `tools/site-check.ts`, `tools/lib/site-chrome.ts`,
  `tools/site-live.ts`): `site-check.ts` again (rebase keeps both hunks). If it changes SITE_OFFLINE, AC5's premise
  (no other host) must hold; a `site-live` staging measure will see the live widget's height (expected to differ).
- **site-native-structure** (element types in `kinds.ts`/`tree.ts`/`convert.ts`): the live widget is a Bricks **Code**
  element either way (Bricks has no native element for another company's widget). If native-structure adds fields to
  `KindContext` or reorders `elementFor`, the `ctx.live` check must stay its **first** line, before any native choice;
  if it moves the markup route's Code shape (`place`, `shared`), the live Code element takes the same shape. Merge
  either order; the later one resolves `kinds.ts`.
- **site-slider** (`widgets.ts` loop copies, Elementor n-carousel → Bricks Slider, maybe `convert.ts` notes): the
  slider's own script-made copies (`swiper-slide-duplicate`, `swiper-notification`) are the site's own scripts, never
  an embed: they stay in that job. Shared hunk: the copied-elements note at `convert.ts:134-136` (both may touch it);
  keep both meanings.
- **site-faq** (`elementor-accordion.ts`): no overlap.
- **site-menu** (popups capture, Offcanvas): no shared file expected; if it adds popups to the capture in
  `capture.ts`, no conflict with `embeds.ts`.

## Bricks samples

None needed: `reference/bricks/code-element.json` (Code with `code` and `executeCode`) is the shape, and staging
printed exactly such a Code element with this loader on 2026-10-29.
