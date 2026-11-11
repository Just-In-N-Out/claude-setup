# site-menu-motion: a menu's list slides open and closed as on the site (Mini, a bug; website importer)

Planner: Fable 5.2 high, 2026-11-11, on `main` `02481763` (Build 2026-11-11.3). The builder copies this file to
`docs/plans/2026-11-11-site-menu-motion.md`. Evidence: `~/.hermes/plans/figma-to-bricks/evidence/site-menu-motion/planner/`.

## Playback (3 lines)

1. On B-Dry staging's phone menu, tapping the arrow beside "Services" makes its seven links appear at once.
2. On bdryswi.com the same list slides open (and closed) smoothly.
3. Wanted: every scanned site whose list slides open pastes with the same slide; lists that don't slide stay as they are.

## Questions (⭐ = taken under the standing auto-go unless Justin says otherwise)

- **Q1. How the paste makes the slide.**
  - **A ⭐ A small script of the plugin's own in one Code element** (the same thing the site does: the browser's Web
    Animations API on the list's height). Works in every browser the site slides in: Chrome, Edge, Firefox, Safari 13.1+
    (iPhone included). Costs: "Regenerate code signatures" after pasting (this header paste already needs it), and
    Bricks' editor doesn't run pasted scripts, so inside the editor the list still jumps; on the live page and Preview it
    slides. Without the signature the list simply opens as today.
  - B CSS only (`::details-content` with `interpolate-size: allow-keywords`): no script, also slides in the editor, but
    only Chrome, Edge and Android Chrome 131+ slide. iPhone Safari and Firefox would still jump (they know
    `::details-content` from Safari 18.4 / Firefox 143, but not `interpolate-size`, as far as I know: I couldn't test
    Safari on this PC). The `grid-template-rows: 0fr → 1fr` trick needs a wrapper the site's code doesn't have.
- **Q2. Today's scan (`~/Downloads/bdry-test`).**
  - **A ⭐ Scan bdryswi.com once more with the new build** (about 4 minutes): the slide is a new thing the scan records;
    today's scan pastes exactly as today.
  - B Also read Elementor's own "animation duration" setting out of today's scan (only with `--elementor`): no re-scan,
    but a second, Elementor-only rule beside the general one.
- **Q3. Which lists.**
  - **A ⭐ Lists inside a box a button opens (menus, drawers, pop-ups) now**; a list in the page itself (an FAQ built
    from `<details>`) is a named follow-up: the scan would have to press every closed list of the page under its own
    guard, which makes every scan slower.
  - B Both now (bigger than Mini).
- **Q4. Closing.** **A ⭐ It closes with the same time and curve it opens with** (the site's script uses one timing for
  both); a site that closes differently is a follow-up.

**Mini or Full:** bigger than a usual Mini (about 5 source files and one new field in the scan), but additive and
low-risk: a scan without the new field and every Figma design convert byte for byte as before. I'd keep Mini, as chosen.

## Root cause (evidence)

1. **The site slides the list with a script, not CSS.** "Services" is Elementor's Nested Accordion: a `<details>` whose
   widget says `n_accordion_animation_duration: 400 ms` (the scan's widget node, `bdry-evidence.json` →
   `capture.widget.marks["data-settings"]`; the same in the saved home, `…/bdry-2026-10-29/home.html`, element
   `21a0798`). Elementor's handler (public source, saved as `elementor/nested-accordion-v4.0.0.js`; identical in 3.35.0
   and main) cancels the click (`:129 event.preventDefault()`), sets `open`, and animates **the details' own height**
   with the Web Animations API: `:160 accordionItem.animate({ height: [start, end] }, { duration })`, no easing given,
   so linear; closing runs the same animation backwards (`:171–176`) and takes `open` off when it ends (`:197`). It is
   not jQuery `slideDown`.
2. **The scan never sees it.** It opens a closed `<details>` "by the `open` attribute alone (no click: the page's own
   handlers don't run)" (`src/web/readers/details.ts:5–8`, `openDetails` `:27–37`; called from
   `src/web/read/code.ts:79–89`). The motion it does record for an opened box is only the box's own entrance
   (`CodeOpen.motion`, `src/core/snapshot/web.ts:134`; here `fadeInRight` 0.75 s). The scanned details node holds no
   motion at all (`bdry-evidence.json` → `capture.details.keys`, `nodeKeysWithSlideOrMotion: 0`).
3. **The paste holds the bare `<details>`.** Scripts of the site are never pasted; the list is a Div with
   `tag: custom, customTag: details` and its summary likewise (`src/core/site/kinds.ts:60`; `header.json` elements
   `oqrqvk`, `rvjsjx` in `bdry-evidence.json`; site-menu's Q5 A: "stays the site's `details`"), and no Code element of
   the paste carries a script (`paste.scriptsInPaste: false`). Bricks 2.4.2 has no handler for `<details>` (its saved
   front-end names it only in its CSS reset), so the browser's own toggle shows the content in one frame: the jump.
4. **Reproduced in Chrome 156** (`probe.ts`, `probe.log`): the same details (a) with Elementor's handler: one
   script-made animation, 400 ms, linear, `open` kept until the closing ends; opened by the attribute as the scan does:
   0 animations; (b) as pasted today: 0 animations, full height at once; (c) with the planned script: one animation,
   400 ms, linear, half-way height exactly between closed (48) and open (168), closes the same way, no inline style
   left; under reduced motion: no animation, opens and closes at once.

## The fix (general rule; nothing names Elementor, a site or a menu)

**Rule:** where a script of the site animates a `<details>`' own height when its summary is pressed, the scan records
that animation's duration and easing, and the paste plays the same animation on the same element when its summary is
pressed, open and close. A details no script animates, and every scan without the record, paste as today. The pasted
structure doesn't change: the same Div `details` › Div `summary` inside the same Offcanvas; one Code element is added.

**Scan (records, under the press guard that is already on):**
- `src/core/snapshot/web.ts`: `export interface CodeSlide { duration: number; easing: string; frameEasing: string }`
  (ms; the effect's easing; the first keyframe's easing) and `CodeNode.slide?: CodeSlide` (absent: none recorded). No
  version change (as `CodeOpen` came).
- `src/web/readers/details.ts`: a new in-page `slideOf(path, ms, { findPath })`: waits (frames, with a 50 ms timer
  beside each frame, at most `ms` = 600) for an animation on the details itself that is neither a `CSSAnimation` nor a
  `CSSTransition` and whose keyframes hold `height`; returns its `getComputedTiming()` duration and easing and its first
  keyframe's easing, then `finish()`es it and waits a frame; `null` when none came or the duration isn't a finite number
  above 0. (The probe's `READ` in `probe.ts` is this function's proven core.)
- `src/web/read/opens.ts`, in `readOpens` right after the box is read (`:165`) and only when `proves(target)` (the page
  load that proves how the box closes: the design width's, else the widest showing an opener): for each closed details
  under the box (`closedDetails(at.root)`) whose summary has a box, remember every details' `open`, press the summary
  through the existing `press(w, …)` with `pressPath` on the summary (so the guard watches it; a press that tried to
  send something counts for nothing), `slideOf` as its wait, then finish every script-made height animation under the
  box and put every details back as it was. Results go on the reading as `slides: Record<path, CodeSlide>`.
  `assembleOpens` (`:231`) sets `nodes[path].slide` from the proven reading, its paths moved under the box's root as the
  closers' are.
- A capture note per box: "1 list in a box slides open (400 ms): the paste slides it too" (so a scan that recorded none
  is visible in `notes`).

**Paste:**
- New `src/core/site/slide.ts` (pure): `slideMarker(page, s)` = `versioned(`${page}__slide`, () => `${s.duration}
  ${s.easing} ${s.frameEasing}`).name` (one marker per distinct timing); `usable(s)`: duration finite, 0 < d ≤ 10000,
  both easings match `^[a-z0-9(),.\s-]+$` (anything else: no slide, as today); `slideScript(list)` = the script below
  with its list filled by `JSON.stringify`.
- `src/core/site/open-paste.ts` `withBoxes` (`:36–58`): for each box, the details elements whose site node
  (`b.pl.open.nodes[own.sources[id]]`) has a usable `slide` get the marker appended to `_cssClasses`; when there is at
  least one, one Code element (`{ name: "code", settings: { executeCode: true, javascriptCode, _display: "none" } }`,
  the shape of `reference/bricks/code-element.json` and `src/core/emit/elements.ts:126`; id from
  `assignIds(["open:<target>:slide"], taken)`) is the Content Block's second child. That part's notes get the `SIGN`
  line (`src/core/site/convert.ts:37`) when they don't hold it yet, and "N list(s) slide open and closed as on the site
  (a script in one Code element)". No class in `classes.ts`, nothing in `convert.ts`.
- The script (kept in `slide.ts` as a string; no `<!--`, `-->` or `import(`; proven in `probe.ts` as
  `slide-script.js`). It listens once on the document, so a list inside a closed Offcanvas works; a second copy in
  another part sees `defaultPrevented` and leaves the press alone; under reduced motion, or without a match, the
  browser's own toggle runs:

```js
(() => {
  const T = __SLIDES__; // [[".<page>__slide-<4>", ms, easing, frameEasing], …]
  const still = matchMedia("(prefers-reduced-motion: reduce)");
  const run = new WeakMap();
  document.addEventListener("click", (e) => {
    const s = e.target instanceof Element ? e.target.closest("summary") : null;
    const d = s ? s.parentElement : null;
    if (!d || d.tagName !== "DETAILS" || e.defaultPrevented) return;
    const t = T.find((x) => d.matches(x[0]));
    if (!t || still.matches || !d.animate) return;
    e.preventDefault();
    const h = () => getComputedStyle(d).height;
    const was = run.get(d);
    const opening = was ? !was.opening : !d.open;
    const from = h();
    if (was) was.a.cancel();
    d.style.overflow = "hidden";
    d.open = opening;
    const to = h();
    d.open = true;
    const a = d.animate([{ height: from, easing: t[3] }, { height: to }], { duration: t[1], easing: t[2] });
    run.set(d, { a, opening });
    a.onfinish = () => { d.open = opening; d.style.overflow = ""; run.delete(d); };
  });
})();
```

**Not in this job (follow-ups, named in HANDOFF):** a list in the page's own parts (Q3); a site that closes with
another timing (Q4); a slide a script makes on another element than the details, or by writing inline heights each
frame (jQuery `slideDown`): stays a jump; Elementor's "only one item open"; a list left open when the drawer is closed
and opened again (Elementor rebuilds its pop-up closed).

## Overlap with the jobs running now

Their plans aren't written yet (only briefs). **site-sticky-header** works on the header part (likely
`src/core/site/convert.ts`, `classes.ts`, `parts.ts`, the renderer); **site-scroll-lock** on page-wide CSS (likely
`src/core/site/classes.ts`, `convert.ts`). This job stays out of `convert.ts` and `classes.ts` on purpose. Shared for
sure: `docs/HANDOFF.md` (a new section each), the paste-check number (the finisher takes the next free one after
3dy), `CLAUDE.md` Status (finisher). Possibly shared: the file that gathers a part's notes with its boxes' (the caller
of `withBoxes`), `test/fixtures/site-no-revert-main.json` if a new fixture site is swept into it. The header paste of
all three lands in one `header.json`: after the three merge, one fresh B-Dry scan and paste checks them together.

## Acceptance criteria (all **proposed**)

- AC1 (proposed): Given the new fixture site `site-slide` (a ☰ pop-up holding three closed lists: one a script slides
  over 400 ms with no easing given, one over 250 ms `ease-out`, one no script touches), when it is captured, then in
  `web.code.opens` the first two details nodes carry `slide` `{400, linear, linear}` and `{250, ease-out, linear}`, the
  third none; every details is closed again; the fixture server got no request but GETs; `capture:check` names nothing.
  Test: `test/web/capture-slide.test.ts` "a list a script slides open is recorded with its duration and easing"
- AC2 (proposed): Given a capture whose box holds details with recorded slides, when converted, then each such details
  element carries its timing's marker in `_cssClasses`, the Offcanvas's Content holds exactly one Code element shaped as
  `reference/bricks/code-element.json` (`executeCode`, `javascriptCode` listing each marker once with its timing), the
  part's notes hold the signature line and the slide note, and a slide with an unusable duration or easing gives neither.
  Test: `test/unit/site-slide.test.ts` "a recorded slide pastes as a marker and one script"
- AC3 (proposed): Given the rendered paste of the `site-slide` capture beside the site at 1440 and 390, when "Services"
  is pressed (a click, and Enter from the keyboard), then a height animation runs on the pasted details with the site's
  duration and easing, at half its time the list's height is within 2 px of the site's at half its time, `open` stays
  until a closing ends, and after closing the list is as before it opened (within 1 px, no inline style left).
  Test: `test/web/site-slide-proof.test.ts` "the list slides open and closed as on the site"
- AC4 (proposed): Given the same paste under `prefers-reduced-motion: reduce`, when the summary is pressed, then no
  animation runs and the list opens, and closes, at once.
  Test: `test/web/site-slide-proof.test.ts` "under reduced motion the list opens and closes at once"
- AC5 (proposed): Given a list half-way through its slide, when the summary is pressed again it turns back from the
  height it has (no jump); and when Escape is pressed instead the drawer closes as before, with no script error, and
  opens again with the list usable.
  Test: `test/web/site-slide-proof.test.ts` "a second press turns the slide back and Escape still closes the drawer"
- AC6 (proposed): Given a capture with no recorded slide (the same capture with its `slide` fields taken out; the third
  list of the fixture; every older capture), when converted, then no element carries a slide marker and no Code element
  carries a script, and the paste differs from the one with slides by exactly the markers, the one Code element (and its
  id in its parent's children) and the two notes. Justin's scan of today converts byte for byte as on `main` (named-only
  receipt, `F2B_SITE_SLIDE_BDRY=<capture>`); Figma designs byte for byte (`npm run check`, `npm run corpus`).
  Test: `test/unit/site-slide.test.ts` "a capture with no recorded slide pastes as before"
- AC7 (proposed) (live): Justin scans bdryswi.com again with the new build, pastes the header on B-Dry staging,
  regenerates code signatures, and on his phone the Services list slides open and closed as on bdryswi.com.

## Touched files

Source: `src/core/snapshot/web.ts`, `src/web/readers/details.ts`, `src/web/read/opens.ts`, `src/core/site/slide.ts`
(new), `src/core/site/open-paste.ts` (plus the notes line where `withBoxes`' caller gathers a part's notes).
Tests and fixtures: `test/fixtures/web/sites/site-slide/` (new: `index.html`, `style.css`, `popup.js` copied from
`site-menu`, `slide.js`), `test/web/capture-slide.test.ts`, `test/web/site-slide-proof.test.ts`,
`test/unit/site-slide.test.ts`. Docs: `docs/HANDOFF.md`, `docs/specs/web-capture.md` ("opens"), the ledger.

## Tasks (test first, one commit each)

1. **Baseline.** In the copy: `npm run check` and `npm run corpus`; `node --test test/web/capture-opens.test.ts
   test/web/site-opens-proof.test.ts test/unit/site-opens.test.ts`; record the tallies in the ledger (the planner ran
   none of them).
2. **The paste, on hand-built input** (`slide.ts`, `web.ts` types, `open-paste.ts`): write `test/unit/site-slide.test.ts`
   (both tests; build the capture as `test/unit/site-opens.test.ts` does and set `slide` on its details node), see them
   fail for the missing marker and script, then build. The byte receipt for the sixth criterion: convert a copy of
   `~/Downloads/bdry-test/bdryswi-com-home.f2b-capture.json` (copy it into the evidence folder; `~/Downloads` is
   read-only) with `main` and with the head, plain and `--elementor`, and compare sums.
3. **The fixture and the scan** (`details.ts`, `opens.ts`): `site-slide`'s `slide.js` follows Elementor's handler step
   for step (`elementor/nested-accordion-v4.0.0.js:128–211`: cancel the click, fix the height, set `open`, on the next
   frame `animate` the height, clear on finish), with the duration and easing read from each list's own data attribute;
   the fixture's lists are plain blocks (in a flex column with `overflow: hidden` the handler's end height is short of
   the natural one: the probe's (a) ended at 139 of 168). Test `capture-slide.test.ts` first (fails: no `slide`), then
   build. Run `test/web/capture-opens.test.ts`, `capture-opens-guards.test.ts`, `capture-matched-once.test.ts` again.
4. **The Chrome proof** (`site-slide-proof.test.ts`, three tests; helpers in `test/web/lib/motion-check.ts` and
   `opens-check.ts`; the renderer already prints `javascriptCode`, `test/browser/render.ts:260`): hold the paste's and
   the site's animation at half their duration and compare heights; `page.emulateMedia` for reduced motion. Prove each
   test catches its bug (`git checkout HEAD~1 -- <fix files>`). Pictures: site | paste at half-way, 1440 and 390.
5. **Gates:** `npm run check`, `npm run test:web`, `npm run test:browser`, `npm run corpus`; if a test that sweeps every
   fixture site trips on `site-slide`, follow that test's own instruction (a golden made again on this tree), never edit
   another fixture.
6. **Docs & records:** HANDOFF section (what changed in plain words, what Justin does: scan again, paste, regenerate
   signatures; the ⭐ answers "not yet confirmed"; the follow-ups above), `docs/specs/web-capture.md` "opens" (`slide`),
   the ledger; stop at `ready-for-review`.

**Stop and escalate to Full** if the scan side needs the guard outside `readOpens`, or more than about 6 source files.
