# panel-embed-code: the panel's website route pastes only a widget's own code

Planner, 2026-11-10. Base: `main` at `f708dfb659049db50bb45df8026faabee2ee0ad7` (Build 2026-11-10.2, site-reviews merged;
its source equals `cd13abf3` but `src/shared/build.ts`). This came from the site-reviews blind auditor's report, not from
Justin. **Justin decides whether to build it.** Website importer: the review limit is one real-bug review per job (CLAUDE.md).
Planner evidence: `~/.hermes/plans/figma-to-bricks/evidence/panel-embed-code/planner/` (probe scripts, summaries, logs, and
a working prototype as two patches that apply cleanly to `f708dfb6`: `prototype-test.diff`, `prototype-src.diff`).

## Amendments (planner, 2026-11-10, after fix pass 3; wording only)

Approved with the ⭐ answers on Justin's "Panel widget code go" (2026-11-10). The build, three fix rounds, three reviews
and Justin's answer to review 2 ("Safe rule (Recommended)", `evidence/panel-embed-code/review-2/justin.json`) refined
what some criteria state. Set against head `ca7d6046` (branch `panel-embed-code-fix3`, on `f708dfb6`). No criterion is
added, removed or renumbered; every cited test name is as approved, each whole on one line (the approved copy wrapped
none). Every changed or added line ends with its mark `[A<n>]`. The pre-amendment text is the read-only
`evidence/panel-embed-code/plan-approved.md`, also `git show ca7d6046:docs/plans/2026-11-10-panel-embed-code.md` (the
same bytes).

- A1. A floating widget's own code (Q4 A, the third criterion's wording, the seventh criterion, "What changes for
  Justin", Approach, the code sketch's comments): Justin's safe rule as head builds it. Code is pasted only when (a) the
  file that drew the box is a script tag the old page's server sent (kept as served; served twice: both tags) and (b)
  that file drew it by itself: no other file, no code that belongs to no served file (an injected inline script, `eval`,
  `new Function`, a timer given a string, a `javascript:`, `data:` or `blob:` script) and none of the page's own code on
  the stack when the box is made (read 200 frames deep; a stack cut at that depth counts as not alone; the browser's
  own frames and the tracker's don't count). Otherwise nothing is pasted and the capture records why (`ownWhy`:
  `started`, `page`, `frame`, `unread`). A box another host's file drew with the site's own code on its stack is the
  site's own box, rebuilt, only when it holds nothing of another host and a link to the site or a picture of its own.
  Fix pass 1's reading (a starter script's chain; files skipped as "libraries") was withdrawn after review 2 and
  Justin's answer; a chat started by a starter script is listed, by his choice.
- A2. R1-7 (the builder's ruling, upheld by review 1): with a code reading in the capture, an embed with no `how` is
  "unproven" (add it by hand), not "older" (capture again), because `how` (web-embeds) predates the code reading
  (web-code-proof). The code sketch is now head's `src/core/snapshot/embed-code.ts`, which never had
  `e.how === undefined ? "older"`.
- A3. The notes' words: every quoted note is as head prints it (`src/core/understand/embeds.ts`,
  `src/core/normalise/floating.ts`): the pasted floating widget's note ends "It runs <host>'s own file as the old page
  did, with whatever else that file loads: remove the Code element if that isn't wanted" (R3-2); the `page` note's new
  words for a box drawn through another host's file (R3-6); an unread served page ends "capture the page again (a new
  capture may paste it)" ("… paste it live" for an embed); no note but the pasted widgets' lines names "your <host>
  account".
- A4. A capture this build doesn't know (R3-4): a reason value this build doesn't know falls through to the unproven
  note (no snippet: the no-code note), never an error; said where the plan speaks of older and newer captures.
- A5. A new reason for embeds: a widget in a capture whose served page couldn't be read (`web.embeds[].unread`) gives
  "unread" ("capture the page again"), in the first criterion's reason list and the Approach (fix pass 1, kept).
- A6. Open, "to be confirmed with Justin": R3-2 (paste a self-drawing served file's code at all, or always list) and the
  builder's ruling of A2. New section after Questions.
- A7. Known limits as the reviews left them: a list under Risks, one line each with its finding id; the paste-check id is
  "the next free id at the merge" (3dr and 3ds were taken by site-slider and staging-fit-renderer).
- A8. Records: Task 1's sketch, Task 3's branch and Task 5's `own` line show head's code; the Tests section names the
  tests the fix rounds added or changed; "Also (supporting, never the cited test)" lines name supporting test files.
- Receipts that encode an old expectation, and the sorter that tells the job's heads apart, are under "Evidence"
  ("Receipts after the amendment"). [A1–A8]

## Questions (⭐ = recommended; under this repo's standing auto-go the builder takes the ⭐ answers unless Justin changes one)

- **Q1. Older embed kinds** (web-embeds' `how` host, creator, frame, live, and captures with no `how`; the Code elements
  they have pasted since Build 2026-11-03.2):
  - **A ⭐** Paste only code proven to be the widget's own: the slot's own served markup (how slot), a served frame's
    own markup (how iframe), a frame a script made, as it showed (how made, and for the other kinds the one frame the
    capture's code reading has at the slot: the same markup the code method pastes for it). Anything else becomes an
    empty box of its size with a note naming the widget, its host and what to do.
  - B Keep today's snippet and add a warning note. The tracking still runs once the code is signed, and a note doesn't
    stop that.
- **Q2. Older captures** (made before site-reviews' fix 1 they keep no `slot`; before web-code-proof they keep no code
  reading; before this build a floating widget keeps no `own`):
  - **A ⭐** Empty box of its size (a floating widget: listed, not pasted) with a note "capture the page again with this
    build". Nothing collected is ever pasted. A capture takes 3–4 min since capture-speed.
  - B For an older how-slot entry, cut the snippet at the slot's first element (by construction that element is the
    served slot markup) and paste that. This is a text cut over saved data and needs a second HTML reader in `src/core`.
  - C Keep the snippet for older captures, with a warning note. The risk stays.
- **Q3. Should the panel list what each Code element will run before Convert?**
  - **A ⭐** No new list. After Convert, the panel's notes say for each widget whether it pastes its own code live or
    stays an empty box, and why. The panel already lists those notes, and before Convert it already says "Embedded:
    widget from <host>".
  - B Extend the pre-Convert "Embedded:" lines with what each will paste (`captureSummary`; `test/unit/ui-capture.test.ts`
    pins those lines).
  - C A full list of every script each Code element runs, before Convert (new panel UI).
- **Q4. Another company's floating extras** (a chat bubble pasted at the end of the footer part):
  - **A ⭐** The capture keeps the served tags of the very file that made the box apart (a new field `own`), and the
    panel pastes only those. A box whose file isn't served, where the snippet was guessed from its host or its frame's
    host, and every capture made before this build, is listed and not pasted. B-Dry's reCAPTCHA badge is one of these.
    - As refined by Justin's safe rule (his answer to review 2, 2026-11-10: "paste a floating widget's code only when the
      exact file that drew it is a tag the old page served; anything started by a starter script, a tag manager or the
      page's own script is listed with a plain note: add its install code by hand in one Code element"): `own` holds
      that file's served tags only when it also drew the box by itself (no other file, no code that belongs to no
      served file, none of the page's own code on its stack); else `own` is null and `ownWhy` says why. A box the site's
      own script drew through another host's file is the site's own box when it holds only the site's own content. [A1]
  - B Never paste a floating widget: list it ("add its code from your <host> account"). No capture change, but the chat
    bubble web-embeds pastes today is lost.
- **Q5. The safe output on the panel route.** The capture keeps no layers inside a widget's slot (`src/web/map/node.ts:141`:
  the slot is one empty frame, `children: []`), so the panel has no still copy to fall back on.
  - **A ⭐** The empty box of its size, as for a widget without code or holding `<?` today, named in the notes.
  - B Make the capture keep the widget's layers too, so the panel can paste a still copy. This is a capture change, it
    helps only new captures, and the panel's website route is the one being retired for websites (CLAUDE.md, "The
    website importer copies the site's own code").

## Open: to be confirmed with Justin [A6]

- R3-2 (review 3, P3; a decision, not a code fix): a served file that draws its box by itself is pasted by the rule he
  chose, and that file can be a tag manager inserting a button as plain markup (review 3's probe T2: its tag pasted,
  its tracking ran after a click on the new page); no stack rule tells it from a chat file drawing its own launcher.
  - Keep the rule (as built), with the honest note ("It runs <host>'s own file as the old page did, with whatever else
    that file loads: remove the Code element if that isn't wanted"). [A6]
  - Or never paste a floating widget's code: always listed, one hand step each. [A6]
- The builder's ruling on the first criterion (R1-7, A2): with a code reading, an embed with no `how` is "unproven" (add
  it by hand), not "older" (capture again). Upheld by review 1; HANDOFF records it as not yet confirmed. [A6]

## Playback (plain words)

1. A website capture records each widget of another company (a reviews strip, a booking frame, a chat bubble) as an
   "embed". For each one it keeps a **snippet**: the widget's slot as the server sent it, plus tags the capture
   **collected from elsewhere in the page** because they name the widget's host. Those can include the same company's
   tracking: an inline loader that adds a pixel, or a pixel tag in `<head>`.
2. The code route (`npm run site`) pastes only the slot's own served markup (`slot`, site-reviews R1-2). It never pastes
   the snippet.
3. The Figma panel's website route (Convert on a capture) pastes **the whole snippet** into a Code element with Execute
   code on. It does this for every embed kind, and for a floating widget at the end of the footer part.
4. So once Justin signs the code on the new Bricks site, the old site's tracking account starts loading its pixel there,
   on any page whose widget host also has tracking tags on the old page. Since site-reviews this also covers the new
   kind (a loader in a slot or at its own place). The older kinds have done it since Build 2026-11-03.2.
5. The fix, for every kind on both routes, is one rule: a pasted Code element may run only the widget's own code. Where
   the capture can't tell what that is, the paste is an empty box of its size (a floating widget is listed instead), and
   a note says why and what to do.

## Root cause (file:line on f708dfb6)

- **The paste takes the snippet as is.**
  - `src/core/normalise/embeds.ts:81-83` puts `e.snippet` into the scene embed's `code` (no-code and `<?` aside).
  - `src/core/understand/node.ts:77` turns any embed whose `code !== null` into a Code element.
  - `src/core/emit/elements.ts:132` writes `{ code: ir.embed.code, executeCode: true }`.
  - Floating widgets: `src/core/normalise/floating.ts:132-135` pastes `f.snippet` the same way.
- **The snippet holds collected tags by design** (web-embeds rule 2, `src/web/map/snippets.ts`):
  - Rule (a), line 64: the creating file's tags **plus every inline script naming its host**, wherever it sits in the
    page.
  - Rule (b), line 67: every served script of the host, plus inline scripts that load or call it.
  - Rule (c), line 72: the same for the frame's host.
  - `snippetOf` (line 96) joins the slot markup and those tags.
  - Floating boxes get `scriptsFor(…, skip: "")` (`src/web/read/floating.ts:170`).
  - The J1-era path (`src/web/assemble.ts:194`, `snippetFor`, `src/web/read/floating.ts:138`) takes every tag of the host
    and every tag containing its name. It is used only when a capture input has no embed facts (hand-made inputs and the
    oldest captures).
- **The code route already has the right rule.**
  - `src/core/site/live.ts:63,70,73` pastes `e.slot` only, for how slot only.
  - `src/web/assemble.ts:282` keeps `slot` apart only for how slot.
  - So the two routes disagree, and the panel route is the one that leaks.
- **There is no still copy on the panel route.** `src/web/map/node.ts:141` makes a widget's slot one empty frame with no
  children, so an embed the panel can't paste is an empty box (the existing no-code and php notes).

## Reproduced (planner's own probe; local fixture servers only, Chrome offline but 127.0.0.1/localhost)

- **The probe page** (`evidence/…/planner/scripts/probe-site-index.html`) is web-embeds' `embeds` fixture page plus
  site-reviews' cases, with the widgets' host's tracking in four places:
  - web-embeds' widgets: a badge and a gallery pasted where they go (how slot), a served booking frame (how iframe), a
    reviews frame that `reviews.js` makes (how creator), a chat bubble (floating), and three maps;
  - the auditor's cases: a loader in an unpainted slot (`#slot-a`) and one alone in a painted card (`#card-c`, its own
    place);
  - the tracking: an inline loader of `pixel.js` and a `pixel.js` tag in `<head>`, an inline call beside the slot, and
    an inline call at the end of `<body>`.
- **Captured and converted with main's code** (`scripts/probe.ts`, receipt `probe/main/summary.json`):
  - The panel route's page part holds **20 `<script>` tags**. Five Code elements carry the tracking: badge, gallery,
    reviews (creator), `#slot-a` and `#card-c`. Each holds the account's init, `pixel.js?from=head`, `?from=beside` and
    `?from=end`.
  - The panel route's footer part holds the chat bubble's Code element, with the same four tracking tags around
    `chat.js`.
  - The code route on the same capture holds 4 `<script>` tags and no tracking.
  - This matches the auditor's finding (8 tags in each of its two Code elements).
- **With the prototype** (`probe/proto/summary.json`):
  - The panel page part holds 4 `<script>` tags (one each in badge, gallery, `#slot-a` and `#card-c`). The reviews entry
    is now the frame `<iframe src=".../reviews.html" title="Reviews">`, and the footer holds `<script src=".../chat.js"
    async>` only. Tracking appears nowhere.
  - The code route is **byte for byte the same** on both probe captures, for every part, plain and `--elementor`
    (`logs/bytes-code-route.txt`).
- **Suites on the prototype:**
  - The whole unit suite is 3503 tests: 3433 pass, 0 fail, 70 skipped (base: 3498 tests, 3428 pass).
  - The embed web tests pass: `capture-embeds` 11/11 after the two planned test updates; `capture-floating`,
    `capture-wakers`, `site-widget-places`, `capture-live-widget`, `site-live-widget` and `panel-capture-alts` pass with
    no change.
  - The new web tests (AC5–AC7) pass on the prototype and fail on base.
  - Both typechecks are clean.

## Proposed acceptance criteria (one test each; base RED unless marked)

- AC1 (proposed): One shared pure rule (`src/core/snapshot/embed-code.ts`) gives each embed exactly its own code.
  - how slot gives `slot`; with no `slot` it gives nothing, "older".
  - how iframe and how made give the snippet (the frame's own markup).
  - Every other how (creator, host, frame, live, none) gives the one shown frame at the slot or under it, from the
    capture's code reading; with none, more than one, a hidden one or a sibling path, it gives nothing ("unproven", or
    "older" with no code reading).
    - With a code reading, a widget with no `how` is "unproven", not "older" (R1-7, the builder's ruling: `how`
      predates the code reading, so a new capture reads it the same). [A2]
    - A widget in a capture whose served page couldn't be read (`unread`) and with no such frame gives "unread". [A5]
  - A floating box gives `own`; null gives "unproven", absent gives "older".
  - Test `test/unit/embed-code.test.ts` "AC1 a widget's own code by how it was captured, and nothing collected from elsewhere". Base: the new module doesn't import (it is the module this job adds).
- AC2 (proposed): On the panel route (`convert()`), a Code element made from an embed of any kind holds only that
  embed's own code, and nothing the snippet collected. Neither the host's inline loader nor its pixel tag appears
  anywhere in the paste. An embed with no own code is an empty box, named "can't be told apart from the old page's other
  <host> tags … empty box of its size".
  - Test `test/unit/panel-embed-code.test.ts` "AC2 the panel's Code element holds only the widget's own code, for every kind".
- AC3 (proposed): A floating widget's Code element at the end of the footer part holds only `own` (the served tags of
  the file that made it). With `own` null there is no Code element, and the footer's notes name it ("… isn't pasted at
  the end of the footer").
  - `own` is what the capture records under the seventh criterion: the served tags of the file that drew the box, only
    when that file drew it by itself (Justin's safe rule); this criterion is the panel's side, given `own`. [A1]
  - Test `test/unit/panel-embed-code.test.ts` "AC3 a floating widget pastes only its own file's tags, or is listed".
  - Also (supporting, never the cited test): `test/unit/panel-floating-why.test.ts` (each `ownWhy` note in head's words,
    the pasted note's closing sentence, a reason this build doesn't know falling through to the unproven note) and
    `test/unit/web-embed-notes.test.ts` (the pasted footer line). [A3, A4, A8]
- AC4 (proposed): An older capture pastes nothing collected: a how-slot entry without `slot`, a creator entry without a
  code reading, and a floating widget without `own`. Each is an empty box (the floating one: listed), named "capture the
  page again with this build".
  - Test `test/unit/panel-embed-code.test.ts` "AC4 an older capture pastes no collected tag: its widgets are empty boxes named, capture again".
- AC5 (proposed): The captured fixture site `embeds-tracked` (the probe page above) holds the host's tracking in its
  embeds' and its chat's snippets. Converted by the panel's route (`captureData` → `resultOf`, as `src/plugin/capture.ts`
  runs it) for header, page and footer, with pictures inline and not, no pasted Code element and no other part of the
  paste holds that tracking.
  - Test `test/web/panel-embed-code.test.ts` "AC5 no tracking of the widget's host rides in any pasted Code element".
- AC6 (proposed): Drawn at 1440 with the other origin serving, the panel's page and footer pastes still work:
  - the badge shows its words and the gallery its tiles;
  - the booking frame and the reviews frame load from the other origin;
  - both carousels draw;
  - the chat's own file is at the footer's end;
  - `pixel.js` is never requested, and `window.audTrack` is undefined.
  - Test `test/web/panel-embed-code.test.ts` "AC6 every widget draws from its own code alone". Base: it fails, because the pixel is requested and the reviews entry pastes its placeholder and script, which draw only after a visitor's input.
- AC7 (proposed): The capture records a floating widget's `own` as the served tags of the very file that made it,
  JavaScript only, in page order, only when that file drew the box by itself (Justin's safe rule): no other file, no
  code that belongs to no served file and none of the page's own code on the stack when the box is made. [A1]
  It records null when that file isn't served or didn't draw the box by itself, with `ownWhy` saying why when the
  capture knows (`started`, `page`, `frame`, `unread`). The snippet is unchanged and still holds the collected tags,
  kept for the record. How-slot embeds keep `slot` as before. [A1]
  - Test `test/web/panel-embed-code.test.ts` "AC7 the capture keeps a floating widget's own file apart from the tags that name its host".
  - Also (supporting, never the cited test): `test/web/panel-floating-chain.test.ts` (site `embeds-chained`: every
    box's record, what both routes paste, the pasted footer drawn and clicked), `test/web/tracker-stack.test.ts` (the
    stack's depth, the cut marker, code with no file), `test/web/floating-holds.test.ts` (what a box holds) and
    `test/unit/floating-origin.test.ts` (the record from each stack and holding, the unread page). [A1, A8]
- AC8 (proposed): The code route is unchanged. `liveWidgets` takes its code from the shared rule, which gives `slot`
  byte for byte. Only how-slot widgets with `slot` paste live; every other embed keeps the copy.
  - Test `test/unit/site-live-widget.test.ts` "only another company's live widget pastes live: every other embed keeps the copy, byte for byte" (existing). Base-exempt: a preservation criterion.
  - Receipt: base and head convert the same saved probe capture, every part plain and `--elementor`, byte for byte
    alike (`scripts/bytes.ts`).
- AC9 (proposed): Pastes without another company's code are byte for byte what main's code made, Figma designs and
  captures alike:
  - the corpus files hydraulics and gro (`convert`);
  - the hand-made captures (`captureFixture` default, three cards with alts, a drawing and fonts, a fixed header);
  - the embeds capture with its widget code removed;
  - every part through the panel route, both picture modes.
  - Test `test/unit/panel-embed-unchanged.test.ts` "AC9 pastes without another company's code are byte for byte main's" (named only: `F2B_UNCHANGED_SUMS=1`; sums written from main's code at Task 0). Base-exempt: preservation.
  - Also: `npm run corpus` no worse than base, and `test/unit/plugin-convert.test.ts` passes.
- AC10 (proposed): Code Figma runs uses only the language's built-ins. `npm run typecheck` passes (`tsconfig.sandbox.json`
  included), and a capture with every embed kind converts in a sandbox like Figma's exactly as in Node.
  - Test `test/unit/sandbox-convert.test.ts` "AC10 a capture with every kind of widget converts in Figma's sandbox as in Node". Base-exempt: a preservation criterion; the fixture helper it uses is new.
- AC11 (proposed) (live): In Figma desktop, Justin opens a capture made with this build in the panel (bdryswi.com's
  home, captured once with `npm run capture -- https://bdryswi.com/ --owned`) and checks the paste on staging:
  1. Choose Page, then Convert and copy, and paste into an empty test page on B-Dry staging.
  2. Run Bricks → Settings → Custom code → Regenerate code signatures.
  3. Logged out at 1440, the "Customer Reviews" strip draws today's reviews.
  4. The Code element holds only Trustindex's `<script src>` loader, as the code route's does.
  5. Do the same for the Footer part: it pastes no reCAPTCHA Code element, and the panel's notes list it.

## What changes for Justin

- **New captures, panel route:**
  - A widget pasted where it goes (a badge, a reviews strip, a gallery) pastes exactly the code route's code: the
    slot's own markup.
  - A frame (booking, video, a reviews frame a script makes) pastes as that frame alone, filling its box.
  - A floating chat whose own loader file is served pastes that file's tag alone, when that file draws the chat by
    itself. A chat whose served tag is a starter script (it loads the bundle that draws the launcher, the common shape),
    or that a tag manager or the page's own script starts, is listed with one hand step: "add the widget's install code
    from <host> in a Code element by hand" (Justin's safe rule; fix pass 1's starter-script chain was withdrawn). [A1]
  - What can't be told apart becomes an empty box of its size, named in the notes. Rare cases: a script widget found by
    its host (how host or creator with no frame), or a widget with no served counterpart (how live). The same applies to
    a floating box made by a file the page doesn't serve, such as B-Dry's reCAPTCHA badge, whose site key is bound to
    the old domain anyway (J9's open question).
    - An embed with no `how` in a capture with a code reading is one of these ("unproven", R1-7); a widget in a capture
      whose served page couldn't be read says "capture the page again". Listed floating boxes are not rare (above);
      B-Dry's reCAPTCHA badge is listed `started`. [A1, A2, A5]
  - A box the site's own theme draws through another host's file (a back-to-top link made with a CDN library) is
    rebuilt as the site's own box only when it shows the site's own link or picture and nothing of another host;
    otherwise it is listed `page`, and the library is never pasted. [A1]
- **Older captures, panel route:**
  - Script widgets (how slot) in captures made before Build 2026-11-10.2 become empty boxes with "capture the page again
    with this build". They used to paste the snippet, tracking included.
  - Served frames and frames as shown (iframe, made) paste byte for byte as before.
  - Frames a script made (how creator, host or frame) paste the frame from the capture's code reading when the capture
    has one (captures since 2026-11-04.7). Otherwise they become an empty box with "capture again".
  - Floating widgets in captures made before this build are listed with "capture again".
  - A capture made by a later build, or by fix pass 1's build (`ownWhy: "shared"`, only in reviewers' caches), may carry
    a reason this build doesn't know: that widget gets the unproven note (no snippet: the no-code note), never an
    error that would fail the whole part's conversion (R3-4). [A4]
  - Captures saved before the fix rounds hold no `ownWhy` or `unread`: they convert through the same branches, and only
    the note words differ. [A3]
- **The code route** (`npm run site`): nothing changes.
- **Figma designs, and captures without another company's code:** nothing changes, byte for byte.
- **What the panel shows:** before Convert, the capture box's "Found" list as today ("Embedded: widget from <host>",
  "Floating on every page…"). After Convert, the notes list gives one line per widget:
  - "its own code, in a Code element where it showed. After pasting, run … Regenerate code signatures…" (as today), or
  - one of the new lines, as head prints them: [A3]
    - "`"the <host> widget": this capture can't tell the widget's own code from the old page's other <host> tags (a tracking tag of the same company could ride along), so it stays an empty box of its size: capture the page again with this build, which pastes it live when it can tell`" [A3]
    - "`"the <host> widget": its own code can't be told apart from the old page's other <host> tags (a tracking tag of the same company could ride along), so it stays an empty box of its size: add the widget's install code from <host> in a Code element by hand`" [A3]
    - "`"the <host> widget": the page as the server sent it couldn't be read when it was captured, so its own <host> code isn't known and it stays an empty box of its size: capture the page again (a new capture may paste it live)`" [A3, A5]
  - Floating widgets get the same lines ending "… so it isn't pasted at the end of the footer: …" (the unread one ends
    "capture the page again (a new capture may paste it)"), plus, when the capture says why (`ownWhy`): [A3]
    - `page`: "`"the <host> widget": the old page's own script draws it through a file from <host>, so it isn't pasted at the end of the footer: if it is the site's own button, rebuild it in Bricks; if it is a widget, add its install code by hand`" (R3-6) [A3]
    - `started`: "`"the <host> widget": another script starts it (a starter script, a tag manager or the old page's own script), and pasting that script could run more than the widget (its tracking too), so it isn't pasted at the end of the footer: add the widget's install code from <host> in a Code element by hand`" [A3]
    - `frame`: "`"the <host> widget": the old site's own script draws it around a <host> frame, so there is no <host> code of its own to paste at the end of the footer: add the widget by hand`" [A3]
  - A pasted floating widget's line is "its own code, in a Code element at the end of the footer, so it shows on every
    page. After pasting, run … Regenerate code signatures, or it stays empty; if it still shows nothing, add your new
    site's address in your <host> account. It runs <host>'s own file as the old page did, with whatever else that file
    loads: remove the Code element if that isn't wanted" (R3-2). No other note names "your <host> account": the
    unproven, `page` and `started` notes send Justin to no host's account (R1-6, R3-6). [A3]

## Approach

- **One pure rule, `src/core/snapshot/embed-code.ts`**: `embedCode(embed, web, slotPath)` and `floatingCode(floating)`,
  returning `{ code, frame }` or `{ code: null, why: "older" | "unproven" }`. It lives in `src/core/snapshot/` because
  both routes read the snapshot.
  - As built: `embedCode` also gives `why: "unread"` for a widget whose capture couldn't read the served page
    (`WebEmbed.unread`, fix pass 1), and "older" only for a capture without a code reading, whatever the `how` (R1-7);
    `floatingCode` gives "older" or "unproven" (type `FloatingCode`). [A2, A5]
  - `src/core/site/live.ts` takes its code from it. For how slot that is `slot`, byte for byte, so the code route is
    unchanged.
  - `src/core/normalise/embeds.ts` and `src/core/normalise/floating.ts` use it in place of `snippet`.
- **The one frame at the slot comes from `web.code.nodes`.** Under the slot's path, the iframe node that shows has an
  `html` holding the element's own markup (no class, style, `data-*` or `on*`; `src/core/snapshot/web.ts` CodeNode). The
  code method pastes exactly this for that frame.
- **One small capture change (Q4 A):**
  - `creatorTags()` in `src/web/map/snippets.ts` gives the served tags of the creating file (the same filter rule (a)
    uses).
  - `classifyFloating` stores them as `own` (`src/web/read/floating.ts`).
  - `assembleCapture` writes `own` on third-party floating boxes (`src/web/assemble.ts`).
  - `WebFloating.own?` (`src/core/snapshot/web.ts`).
  - The snippet and every other capture field are as before.
  - As built through fix pass 3 (Justin's safe rule; `src/web/read/tracker.ts`, `src/web/read/floating.ts`): the
    tracker keeps, for each element a script makes, every script file on the stack, innermost first, read 200 frames
    deep from the caller of the tracker's own wrapper with the page's own `Error.stackTraceLimit` put back; a stack that
    fills 200 frames ends with `about:stack-cut`; a frame of code that belongs to no served file adds
    `about:inline-code` (the browser's own frames, printed `(<anonymous>)` with no line, add nothing). [A1]
  - `classifyFloating` writes `own` only when the drawing file (the innermost, `made`) is alone on that stack and is
    a served tag; else `own` null with `ownWhy` (`started`, `page`, `frame`, `unread`; `WebFloating.ownWhy?`), written
    by `assembleCapture`. The in-page reader records what each box holds (`holds`: another host's content, the site's
    own link or picture, or neither), which decides the site's-own-box exception. [A1]
  - `src/core/normalise/floating.ts` gives a reason the capture knows its note first, only for `page`, `started`,
    `frame` and `unread`; any other value falls through to the unproven note (R3-4). [A4]
  - Taken out again by fix pass 2: fix pass 1's chain of script loads, the library skip, the per-file record of what
    each file did, its wrapping of `fetch`, `XMLHttpRequest.open` and `sendBeacon`, `ownWhy: "shared"` and the
    `ownLoads` note. [A1]
- **No change** to the PHP guard (it now tests the code that is actually pasted), `payloadProblems`, the code route's
  admission, or any Figma design path. `embedPlans` returns early without `web`, and so does the floating path.
- **Architecture rules hold:**
  - pure core, no `URL`;
  - no stage edits an earlier stage's output (normalise decides the code once, as today);
  - deterministic;
  - no hosts, classes or sites named: recognised by how the capture found the code and by structure (paths, the one
    shown frame).
  - the floating rule reads the stack, which files are the site's own host, and what a box holds; it never names a
    host, class, file or site. [A1]

## Tasks (ordered; one commit per green task; consumer guards before the producer)

Work in `.claude/worktrees/panel-embed-code` (branch `worktree-panel-embed-code`, from `main` f708dfb6). Use a short
TMPDIR (`~/.cache/pec-b/tmp`), run with `CHROME_PATH` set as on this desktop (memory "Checks on the desktop"), and cap
every run (`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 …`). The planner's prototype patches are the
reference for exact bytes. You may apply the test patch hunk by hunk per task (`git apply --include=<path>`), but each
behaviour's RED must be seen before its source hunk.

**Task 0: baseline and sums.**
1. `npm run check` (green on base), and record `npm run corpus` numbers in the ledger
   `.superpowers/sdd/2026-11-10-panel-embed-code/progress.md`.
2. Add `test/unit/panel-embed-unchanged.test.ts` (the prototype's file, in `prototype-test.diff`).
3. Run `F2B_UNCHANGED_SUMS=write node --test test/unit/panel-embed-unchanged.test.ts` on the unchanged code, then
   `F2B_UNCHANGED_SUMS=1 …`, which must pass. Check that the default run skips it.
4. Commit the test with `test/fixtures/panel-embed-unchanged.json`.

**Task 1: the shared rule (AC1).**
1. Add `test/unit/embed-code.test.ts` (prototype). RED: it can't import `src/core/snapshot/embed-code.ts`.
2. Add `src/core/snapshot/embed-code.ts` exactly as below, plus `own?` on `WebFloating`
   (`src/core/snapshot/web.ts`, after `place?`):
   `own?: string | null;   // third-party (panel-embed-code): the served tags of the very file that made it, all a Code element may run; null: that file isn't served; absent: a capture made before this build`.
   - As built through fix pass 3, `src/core/snapshot/web.ts` reads (the comment and the new `ownWhy?` field): [A1, A8]
     `own?: string | null;   // third-party (panel-embed-code): the served tags of the file that drew it, when that file drew it by itself (fixer 2, Justin's safe rule), all a Code element may run; null: none proven; absent: a capture made before this build` [A1]
     `ownWhy?: "page" | "started" | "frame" | "unread";` (page: the old page's own code was on its stack; started: the file that drew it isn't served, or another file was on its stack; frame: no file of its host made it, only its frame marks it; unread: the served page couldn't be read) [A1]
   - The block below is head's `src/core/snapshot/embed-code.ts` (`ca7d6046`), byte for byte; the approved copy's block
     (the builder's starting point, with `e.how === undefined ? "older"`, R1-7) is in `plan-approved.md`. [A2, A8]
3. GREEN.

```ts
// What a pasted Code element may run for another company's widget (panel-embed-code): only the widget's own code, never
// tags the capture collected from elsewhere in the page because they name the widget's host (web-embeds rule 2's
// snippet, map/snippets.ts, keeps those for the record: a tracking pixel of the same company is one). One rule for both
// routes: the code method (site/live.ts) and the panel's Figma route (normalise/embeds.ts, normalise/floating.ts).
// - how "slot": the slot's own served markup, kept apart by the capture (`slot`, site-reviews R1-2); a capture made
//   before it keeps none ("older").
// - how "iframe": a served frame's own markup (its live address written in): the snippet holds nothing else.
// - how "made": the frame a script made, as it showed: the snippet holds nothing else.
// - any other how (creator, host, frame, live, none): the one frame shown at the slot or under it, as the capture's code
//   reading keeps it (web.code: the element's own markup, the same the code method pastes for it); none there: a
//   widget whose own code can't be told apart ("unproven"), or a capture without that reading ("older": one made before
//   web-code-proof, which also predates every other way of telling).
// - a floating box of another company: the served tags of the file that drew it, only when that file drew it by itself
//   (`own`, the capture's: Justin's safe rule, fixer 2); null: none proven ("unproven"; the capture's `ownWhy`, which the
//   panel's note gives first, says why when it knows: the old page's own script starts it, another script starts it,
//   only another company's frame marks it, the served page couldn't be read); absent: a capture made before this build
//   ("older").
// - a widget read when the served page couldn't be read (`unread`): "unread" (a new capture may paste it).
// Pure; no URL class (Figma's sandbox has none).
import type { WebCapture, WebEmbed, WebFloating } from "./web.ts";

export type OwnCode = { code: string; frame: boolean } | { code: null; why: "older" | "unproven" | "unread" };
export type FloatingCode = { code: string; frame: false } | { code: null; why: "older" | "unproven" };

// the one frame shown at the slot or under it, by the capture's code reading; null: none, or more than one
function slotFrame(web: WebCapture, slotPath: string | null): string | null {
  const nodes = web.code?.nodes;
  if (!nodes || slotPath === null) return null;
  const frames = Object.entries(nodes).filter(([p, n]) => (p === slotPath || p.startsWith(slotPath + "/")) && n.tag === "iframe" && n.shown.length > 0 && typeof n.html === "string" && n.html.trim() !== "");
  return frames.length === 1 ? frames[0][1].html! : null;
}

export function embedCode(e: WebEmbed, web: WebCapture, slotPath: string | null): OwnCode {
  if (e.how === "slot") return e.slot ? { code: e.slot, frame: false } : { code: null, why: "older" };
  if (e.how === "iframe" || e.how === "made") return e.snippet && e.snippet.trim() ? { code: e.snippet, frame: true } : { code: null, why: "unproven" };
  const frame = slotFrame(web, slotPath);
  if (frame !== null) return { code: frame, frame: true };
  return { code: null, why: e.unread ? "unread" : web.code ? "unproven" : "older" };
}

export function floatingCode(f: WebFloating): FloatingCode {
  if (f.own === undefined) return { code: null, why: "older" };
  return f.own && f.own.trim() ? { code: f.own, frame: false } : { code: null, why: "unproven" };
}
```

**Task 2: the panel's embeds take only their own code (AC2, AC4's embed cases).**
1. Add `trackedWidget`, `TRACK`, `PIXEL` and `OWN_FRAME` to `test/fixtures/web/embeds.ts`, and import `CodeNode`,
   `WebCode` and `WebEmbed` there (prototype hunk).
2. Add `test/unit/panel-embed-code.test.ts` with AC2 and AC4 (AC3 comes in Task 3). RED on the current code: "how slot:
   the slot's own served markup: pasted the host's tracking …" and "no slot: nothing collected pasted".
3. Change `src/core/normalise/embeds.ts`:
   - import `embedCode`;
   - record each layer's `web.source.path` in the existing walk (`pathOf`);
   - replace lines 77-83 with:

```ts
    // only the widget's own code runs (snapshot/embed-code.ts); a frame's own markup fills its Code element
    const code = embedCode(e, web, pathOf.get(e.nodeId) ?? null);
    const frame = e.how === "iframe" || e.how === "made" || (code.code !== null && code.frame);
    const label = `the ${host} ${e.kind === "map" ? "map" : e.kind === "video" ? "video" : frames.has(e.nodeId) || frame ? "frame" : "widget"}`;
    const base: SceneEmbed = { code: null, host, label, ownSite: own, ...(own ? { src: e.src } : {}), ...(frame ? { frame: true as const } : {}) };
    if (e.snippet === null || !e.snippet.trim()) plans.set(e.nodeId, { embed: { ...base, why: "no-code" } });
    else if (code.code === null) plans.set(e.nodeId, { embed: { ...base, why: code.why } });
    else if (runsAsPhp(code.code)) plans.set(e.nodeId, { embed: { ...base, why: "php" } });
    else plans.set(e.nodeId, { embed: { ...base, code: code.code } });
```

   (The label keeps `e.how === "iframe" || "made"` so a frame without code is still named "frame":
   `test/unit/web-embed-notes.test.ts` pins it. The prototype's first draft dropped that and failed there.)
4. `src/core/normalise/scene.ts`: `SceneEmbed.why?: "php" | "no-code" | "older" | "unproven"`.
5. `src/core/understand/embeds.ts`: the two notes `older` and `unproven` (wording under "What changes for Justin"), and
   the two `else if` branches after `no-code` in `noteEmbeds` (prototype hunk).
6. Update `test/web/capture-embeds.test.ts`, test "AC3 each widget is a Code element holding its own code where it
   showed". This is web-embeds' approved assertion, changed by Q1 A:
   - its reviews row looks the Code element up by `reviews.html` (it now holds the frame);
   - it asserts `code === embedCode(entry, snapshot.web!, layer.web!.source.path).code` in place of `entry.snippet`;
   - the drawing assertions are unchanged and still pass (the frame loads from the other origin).
7. GREEN: the new unit tests, `test/unit/web-embed-*.test.ts`, `capture-embeds` (11/11).

**Task 3: floating widgets take only their own file's tags (AC3, AC4's floating case).** This is the consumer; the
producer comes in Task 5.
1. Add AC3 to `test/unit/panel-embed-code.test.ts`. RED: "its own file's tag, nothing else".
2. `src/core/normalise/floating.ts`:
   - import `floatingCode`;
   - add the notes `older` and `unproven` (prototype hunk);
   - replace lines 132-136 with:

```ts
    // only its own code runs (snapshot/embed-code.ts): the served tags of the file that made it
    const own = floatingCode(f);
    if (!f.snippet) add(footer.rootId, note(f.id, label, floatingNotes.noCode(label, where), true));
    else if (own.code === null) add(footer.rootId, note(f.id, label, floatingNotes[own.why](label, host, where), true));
    else if (runsAsPhp(own.code)) add(footer.rootId, note(f.id, label, floatingNotes.php(label, where), true));
    else {
      if (snippets.has(own.code)) continue;
      snippets.add(own.code);
      add(footer.rootId, { id: f.id, label, node: null, code: own.code, host, sides, sidesIn: others, hiddenAtDesign, hiddenIn: f.node?.web?.hiddenIn ?? [], note: floatingNotes.code(label, host, where), footer: true });
    }
```

3. Update `test/unit/web-embed-safety.test.ts` (web-embeds' PHP guard). The test must put the bad code where the paste
   reads it:
   - `Object.assign(entryOf(s, "badge-slot")!, { snippet: bad, slot: bad })`;
   - `Object.assign(<the third-party floating box>, { snippet: bad, own: bad })`.
   Its assertions are unchanged.
4. GREEN: the whole unit suite.
   - As built (the builder's ledger, Task 3): the whole unit suite could only go green with Task 5's producer, since
     two older tests build their capture through the real `classifyFloating`; they went green in Task 5. [A8]
5. As built through fix pass 3, the branch in `src/core/normalise/floating.ts` (head `ca7d6046`, lines 149-161) reads a
   reason the capture knows first, only one this build knows (R3-4), and pastes `own` only when the capture proved it: [A1, A4, A8]

```ts
    // only its own code runs (snapshot/embed-code.ts): the served tags of the file that drew it by itself; a reason the
    // capture knows comes first (a page it couldn't read has no snippet either)
    const own = floatingCode(f);
    // fixer 3 (R3-4): only a reason this build knows; another (fix pass 1's "shared", one a later build adds) falls through
    if (own.code === null && f.ownWhy && WHY.includes(f.ownWhy)) add(footer.rootId, note(f.id, label, floatingNotes[f.ownWhy](label, host, where), true));
    else if (own.code === null && !f.snippet) add(footer.rootId, note(f.id, label, floatingNotes.noCode(label, where), true));
    else if (own.code === null) add(footer.rootId, note(f.id, label, floatingNotes[own.why](label, host, where), true));
    else if (runsAsPhp(own.code)) add(footer.rootId, note(f.id, label, floatingNotes.php(label, where), true));
    else {
      if (snippets.has(own.code)) continue;
      snippets.add(own.code);
      add(footer.rootId, { id: f.id, label, node: null, code: own.code, host, sides, sidesIn: others, hiddenAtDesign, hiddenIn: f.node?.web?.hiddenIn ?? [], note: floatingNotes.code(label, host, where), footer: true });
    }
```

**Task 4: the code route reads the same rule (AC8).** In `src/core/site/live.ts`:
- import `embedCode`;
- the loop's guard becomes `if (e.kind !== "widget" || e.how !== "slot") continue;`;
- right after `const slot = pathOf.get(e.nodeId);` add `const mine = embedCode(e, web, slot ?? null); if (mine.code === null) continue;`;
- `runsScript(e.slot)` becomes `runsScript(mine.code)`, and `code: e.slot` becomes `code: mine.code`.

GREEN: `test/unit/site-live-widget.test.ts`, plus the web tests `site-live-widget`, `site-widget-places`,
`site-widget-codes`, `site-check-live-widget`, `capture-live-widget` and `capture-widget-alone`, unchanged. Receipt:
`scripts/bytes.ts` on a saved capture of the `embeds-tracked`, `live-widget` and `live-widget-places` fixtures, base tree
against head tree; every `code …` row must read "same".

**Task 5: the capture keeps a floating widget's own file (AC7).**
1. Add the fixture site `test/fixtures/web/sites/embeds-tracked/` (`index.html` from the prototype, and `wp-content/`
   copied from `embeds/`).
2. Add `test/web/panel-embed-code.test.ts` with AC5, AC6 and AC7 (prototype). RED on the current capture: AC7
   (`own` undefined).
3. `src/web/map/snippets.ts`: add `creatorTags(html, creator, base)` (prototype hunk, above `scriptsFor`).
4. `src/web/read/floating.ts`: import it; the third-party push adds the own file's tags (null when none):
   `own: (scriptHost && bare(scriptHost) !== site ? creatorTags(html, f.made!, finalUrl).join("\n") : "") || null`.
   - As built through fix pass 3 (Justin's safe rule; head `src/web/read/floating.ts` lines 217-222), `own` needs the
     drawing file alone on its stack, and `ownWhy` says why when it is null (`alone`, `bySite` and `siteBox` are read
     from the tracker's stack and the box's `holds` just above): [A1, A8]

```ts
    if (foreign) {
      const own = (madeElsewhere && alone ? creatorTags(html, drew!, finalUrl).join("\n") : "") || null;
      const why = own !== null || (madeElsewhere && !stack) ? undefined : !madeElsewhere ? "frame" as const : alone ? (html ? "started" as const : "unread" as const) : bySite ? "page" as const : "started" as const;
      out.push({ ...base, kind: "third-party", part: "footer", host: foreign, snippet: scriptsFor(html, { creator: drew || null, frameHost, base: finalUrl, skip: "" }).tags.join("\n") || null, own, ...(why ? { ownWhy: why } : {}) });
      continue;
    }
```

   First rename that function's local `own` (the site's bare host, `src/web/read/floating.ts:149`, used at lines 167-168)
   to `site`, so the property and the host can't be confused (the prototype kept the old name).
5. `src/web/assemble.ts`: `FloatingIn` gains `own?: string | null`, and the floating map writes
   `...(f.kind === "third-party" ? { own: f.own ?? null } : {})` after `snippet`.
6. GREEN: AC5, AC6 and AC7, plus `capture-floating`, `capture-embeds`, `capture-wakers`, `capture-stable` and
   `capture-steady`.

**Task 6: the sandbox (AC10).** Add the AC10 case to `test/unit/sandbox-convert.test.ts` (prototype hunk, before "the
sandbox has no URL"). Run `npm run typecheck` (both configs).

**Task 7: gates.**
1. `npm run check`.
2. `npm run corpus`, no worse than Task 0.
3. `npm run test:browser`.
4. `npm run test:web` (whole; compare by test name with a base run, and name base-only failures).
5. `F2B_UNCHANGED_SUMS=1` AC9.
6. The byte receipt for AC8.
7. The probe summary (`scripts/probe.ts` against the copy).
8. Mutants (`mutation-testing-discipline`, capped), each run against the named tests; every one must fail them:
   - M1: `normalise/embeds.ts` pastes `e.snippet` again (AC2, AC5);
   - M2: `normalise/floating.ts` pastes `f.snippet` again (AC3, AC5);
   - M3: `slotFrame` accepts two frames, or a sibling path's prefix (AC1);
   - M4: `embedCode` gives the snippet for how undefined (AC4);
   - M5: `creatorTags` also keeps inline scripts naming the host (AC7);
   - M6: `live.ts` reads `e.snippet` (`test/unit/site-live-widget.test.ts`'s R1-2 case killed this mutant for the
     site-reviews auditor, as P1).
9. Before/after text proof (no visual change beyond the widgets): the probe's per-Code-element lists, base and head.

**Task 8: Docs & records.**
- The plan copied to `docs/plans/2026-11-10-panel-embed-code.md`, and the ledger moved by the finisher to
  `docs/plans/2026-11-10-panel-embed-code-ledger.md`.
- A new `docs/HANDOFF.md` section above the top `## ` heading, with the next free paste check at the top of "End-of-run
  check list" (the next free id at the merge; 3dr and 3ds are taken by site-slider and staging-fit-renderer). [A7]
  The section holds:
  - the rule, the ⭐ answers as "taken under the auto-go, not yet confirmed", what changes for older captures, and the
    known limits.
- web-embeds' and site-reviews' HANDOFF lines that this job changes get one line each, pointing here:
  - "The old Figma route's Code elements (web-embeds) are as before" (site-reviews R1-2);
  - "another company's (a chat bubble) as its own code" (web-embeds).
- `docs/specs/web-capture.md`: `WebFloating.own`.
  - As built: also `ownWhy`, the stack the tracker keeps and its two markers, and what a box holds (rule 3). [A1, A8]
- `BUILD` is bumped at the merge.
- The main `CLAUDE.md` Status gets one line. Add one standing rule under "Website captures": "**A pasted Code element
  runs only a widget's own code** (panel-embed-code): the slot's own served markup, a frame's own markup, a floating
  widget's own file's tags; what a capture can't tell apart is an empty box (a floating one: listed), named; both routes
  read `src/core/snapshot/embed-code.ts`."
  - As built, the rule's floating clause reads "a floating widget's own file's tags, only when the old page served that
    file and it drew the box by itself (Justin's safe rule)". [A1]

## Tests (RED on base → GREEN on head; checked on the prototype)

| AC | Test (file) | Base | Prototype |
|---|---|---|---|
| 1 | `test/unit/embed-code.test.ts` | import failure (new module) | pass |
| 2, 3, 4 | `test/unit/panel-embed-code.test.ts` | fail (tracking pasted, collected snippet pasted) | pass |
| 5, 6, 7 | `test/web/panel-embed-code.test.ts` | fail ×3 (`logs/base-pec-web.log`) | pass (`logs/proto-pec-web.log`) |
| 8 | `test/unit/site-live-widget.test.ts` (existing) + bytes receipt | pass (preservation) | pass; bytes "same" |
| 9 | `test/unit/panel-embed-unchanged.test.ts` (named only) | sums written there | pass |
| 10 | `test/unit/sandbox-convert.test.ts` | preservation | pass; typecheck clean |
| 11 | live, Justin | – | – |

Tests whose assertions this plan changes, both web-embeds':
- `test/web/capture-embeds.test.ts` (AC3's reviews row and its code equality);
- `test/unit/web-embed-safety.test.ts` (where the bad code is put).

No other existing test changed on the prototype.

The fix rounds added or changed (supporting tests; none is a cited test, and no cited test changed after the build): [A8]
- added: web `test/web/panel-floating-chain.test.ts` (fixture site `embeds-chained`), `test/web/tracker-stack.test.ts`
  (site `tracker-stack`), `test/web/floating-holds.test.ts` (site `float-holds`), unit
  `test/unit/floating-origin.test.ts` and `test/unit/panel-floating-why.test.ts`; fixture files under
  `test/fixtures/web/third-party/`. [A8]
- changed: `test/unit/web-embed-notes.test.ts` (the pasted footer line gains R3-2's closing sentence) and
  `test/fixtures/web/embeds.ts` (the chat's facts carry the stack a real capture holds; `notesCapture`'s second box has
  `own: null`). [A8]

## Risks

- **A widget that needs inline settings or a second script** loses them: a frame made by a script now pastes as the
  frame alone, and a floating chat with an inline config gets only its loader file. It pastes but may draw less. That is
  the price of Q1/Q4 A; the note's wording tells Justin to add the code from the vendor account when it shows nothing.
  - As built: a floating chat that anything but its own served file starts (an inline config's init, a starter script,
    a tag manager) is listed, not pasted (Justin's safe rule; one hand step). [A1]
- **How iframe and how made trust the capture's construction** (`snippetOf`, `src/web/map/snippets.ts:166-171`, adds no
  tags for frames; pinned by `test/unit/web-embed-snippets.test.ts`). A served frame's slot markup may hold a script
  inside the slot. That is the slot's own markup, the same standard site-reviews accepted (R2-6). A frame whose `srcdoc`
  holds a script runs it, as before.
- **Older captures lose live widgets on the panel route** until they are re-captured (Q2 A). The notes say so.
- **B-Dry's footer on the panel route loses the reCAPTCHA Code element** (Q4 A): its creator file isn't served. It was
  bound to the old domain's key anyway (J9). As built it is listed `started`. [A1]
- **Capture field `own`**: it is additive and optional. Saved captures without it read as "older". The capture-stable
  and capture-steady tests compare two captures of the same tree, so they are unaffected.
  - `ownWhy` and `WebEmbed.unread` are additive and optional too. A reason value this build doesn't know (a newer
    capture's, or fix pass 1's `"shared"`) gives the unproven note, never an error (R3-4). [A4]
- `slotFrame` picks the frame by structure: one shown iframe at the slot or under it. A widget whose box holds two frames
  is an empty box (safe).

### Known limits, as the reviews left them [A7]

- Listed `started`: a starter script that loads several chunks of its own (one tag inserting three bundle files), like
  any chat a starter script starts, by Justin's choice (R1-1). [A7]
- A vendor function handed directly as a handler (`addEventListener("load", Vendor.start)`) has only the vendor's file on
  its stack: its tag pastes and draws nothing; the note is the plain pasted one (R2-3's fix, fixer 2). [A7]
- A served SDK the page inits that draws after an `await` has only its own file on the stack: its tag pastes without
  the page's init call and draws nothing (R3-3). [A7]
- A vendor file that builds its templates with `eval` or `new Function`, or draws from a timer given a string, is listed
  `started` though it drew by itself (R3-1's fix, the safe side). [A7]
- A served file that draws its box by itself is pasted whatever else it does, a tag manager inserting markup included
  (R3-2; open, to be confirmed with Justin). [A7]
- The site's own CDN-made box with no site link or picture (a back-to-top `<button>`, a cookie bar linking another
  host) is listed `page`, not rebuilt (R2-3's fix, R3-6's words). [A7]
- A vendor box the site's script starts that links only to the site's own pages and loads nothing of another host is
  rebuilt as the site's own still box (R2-3's fix, the wrong side, rare). [A7]
- A vendor file drawing through the site's own jQuery is the site's own box, as on base (R1-2's shape, fixer 2). [A7]
- Content inside a shadow root isn't read for what a box holds (null): such a box the site's script started is listed
  (fixer 2, R2-3's fix). [A7]
- A site whose own files come from its own CDN host reads that host as another company's, as before (fixer 1). [A7]
- R1-3: a tracker hand-placed in the same unpainted wrapper as a widget or a served frame pastes as the slot's own
  markup (the accepted R2-6 standard); for a served frame the panel pastes the wrapper. [A7]
- R1-4: a visible 1×1 tracking frame a widget's served file adds pastes as its own frame embed on both routes. [A7]
- R1-5: the code route pastes a live slot holding `<?` with Execute code on (`npm run site` never runs
  `payloadProblems`; byte for byte as before by the eighth criterion). [A7]
- R1-6, left: the pasted widgets' lines (web-embeds' and the floating one's) still say "your <host> account", for a
  host that may have none (pinned by `test/unit/web-embed-notes.test.ts`). [A7]
- R3-5: the stack read costs about 6–20 µs per element a script makes at 0–30 frames deep, 56–60 at 100, 109–115 at 250;
  unnoticeable in a capture of minutes. [A7]
- A page that leaves an `Error.prepareStackTrace` returning call sites makes the tracker's stack read throw inside
  `createElement` during capture, as on main (review 3's side note; its own small job). [A7]
- A custom element's constructor run while a wrapped `innerHTML` parses leaves the tracker's frames on the stack, read
  as code with no file: listed, the safe side (fixer 3). [A7]

## Overlaps with unmerged jobs (files; checked against main f708dfb6)

- **site-menu** (`site-menu-fix3`) edits `src/core/snapshot/web.ts` at `WebCode` (line 88, `opens?`) and after
  `WebSheets`. This job edits `WebFloating`: separate hunks. It doesn't touch `src/web/read/floating.ts`, `assemble.ts`'s
  floating map, or `src/core/normalise/`.
- **staging-fit-renderer** (`staging-fit-renderer-stack1-fix5`): its `src/core/site/live.ts` and `src/web/read/embeds.ts`
  equal main's (site-reviews' stacked commits). This job edits `live.ts` (Task 4, 4 lines). A conflict is possible only
  if it later changes `liveWidgets`' loop.
- **site-slider** (`site-slider-stack3`), **staging-fit-cancels**, **site-native-structure**: `src/core/site/` styling
  and fold files only (`classes.ts`, `controls.ts`, `convert.ts`, `elementor-*.ts`, `slider-*.ts`, `blocks.ts`,
  `motion.ts`, `tree.ts`, `parts.ts`). No overlap.
- All of them share `docs/HANDOFF.md` (section insert, paste-check ids) and the named-only goldens/sums tests. This job's
  sums are its own file, and its change doesn't touch the code route's pastes, so other jobs' code-route goldens stay
  valid.
- The site-reviews follow-ups (R1-5…R2-6) aren't touched.

## Pipeline recommendation: **Full** (with the importer's one-real-bug-review limit)

- About 10 source files across capture and core (`snapshot/embed-code.ts` new, `snapshot/web.ts`, `normalise/embeds.ts`,
  `normalise/floating.ts`, `normalise/scene.ts`, `understand/embeds.ts`, `site/live.ts`, `web/map/snippets.ts`,
  `web/read/floating.ts`, `web/assemble.ts`).
- One capture field, and product decisions (Q1, Q4) that change behaviour web-embeds' approved ACs pinned.
- A security-class guard: code running on Justin's live sites, which calls for mutants.
- Mini's limits (1–3 files, no design decision) don't hold.
- The prototype makes the build itself small and low-risk; most of the work is the gates and receipts.

## Evidence (planner)

Folder: `~/.hermes/plans/figma-to-bricks/evidence/panel-embed-code/planner/`
- `scripts/`: the probe (`probe.ts`), the byte comparison (`bytes.ts`), the web-test runner (`webtests.sh`) and the probe
  page.
- `probe/main/summary.json` and `probe/proto/summary.json`.
- `logs/`:
  - unit suites `base-unit-all.log` (3498 tests: 3428 pass, 70 skipped) and `proto-unit2.log` (3503 tests: 3433 pass, 70
    skipped);
  - `proto-web.log` and `proto-embeds2.log`;
  - `proto-pec-web.log` and `base-pec-web.log`;
  - `bytes-code-route.txt`.
- `prototype-src.diff` and `prototype-test.diff` (`git apply --check -p1` clean on f708dfb6).
- Scratch trees: `~/.cache/pec-p/`.

### Receipts after the amendment [A1–A8]

The cited tests (and `test/fixtures/panel-embed-unchanged.json`) are byte for byte the same on all four job heads, so a
receipt of a cited test keeps its assertion; each must still be re-run on the final head. The receipts below encode an
expectation the amendment changed. Sorter (source lines only; a grep on the cited test files is constant across the
heads), run on the job's heads, output in `~/.cache/pec-pa/sorter.log`: [A8]

```bash
for h in 4d6c6403 4cfc7003 6b115d3f ca7d6046; do
  a=$(git show $h:src/core/understand/embeds.ts | grep -cF 'account in a Code element by hand')
  b=$(git show $h:src/web/read/floating.ts | grep -c 'chainOf')
  c=$(git show $h:src/web/read/floating.ts | grep -cF 'const alone = !!stack && stack.length === 1')
  d=$(git show $h:src/web/read/tracker.ts | grep -c 'about:inline-code')
  e=$(git show $h:src/core/normalise/floating.ts | grep -cF 'with whatever else that file loads')
  f=$(git show $h:src/core/normalise/floating.ts | grep -cF "if it is the site's own button, rebuild it in Bricks")
  g=$(git show $h:src/core/normalise/floating.ts | grep -cF 'WHY.includes(f.ownWhy)')
  echo "$h builder-notes=$a chain-rule=$b safe-rule=$c no-file-code=$d r3-2-note=$e r3-6-page-note=$f r3-4-guard=$g"
done
```

- `4d6c6403` (builder): builder-notes=1, every other 0. `4cfc7003` (fixer 1): chain-rule=2. `6b115d3f` (fixer 2):
  safe-rule=1, no-file-code=0. `ca7d6046` (fixer 3): safe-rule=1, no-file-code=2, r3-2-note=1, r3-6-page-note=1,
  r3-4-guard=1. [A8]
- The builder's receipts (`evidence/…/builder/`, `4d6c6403`): the unproven and older notes' old words ("add the
  widget's code from your <host> account", "… with this build to paste it live"), printed by mutants M4d, M4e and M7c.
  The assertions those mutants failed on (the regexes in `test/unit/panel-embed-code.test.ts`) are unchanged, so the
  kills hold; now expected: head's words (A3). [A3, A8]
- Fixer 1's receipts (`evidence/…/fixer-1/`, `4cfc7003`): the withdrawn chain rule (a starter script's served tag
  pasted, `ownWhy: "shared"`, the `ownLoads` note). Now expected: a starter script's chat listed `started`, no `shared`,
  no `ownLoads` (A1). [A1, A8]
- Fixer 2's receipts (`evidence/…/fixer-2/`, `6b115d3f`): a served tag manager whose rule draws through code with no
  file (review 3's T1, T3) pasted; the `page` note's old words ("add the widget's install code from <host>") and the
  pasted note without its closing sentence; a reason this build doesn't know throwing. Now expected: T1, T3 listed
  `started`, head's notes (A3), the unproven note for an unknown reason (A4). [A1, A3, A4, A8]
