# site-motion: a captured site's animations, hovers and entrances move in the code-method paste (Full plan, website importer)

Planned 2026-11-07 on `worktree-agent-a4ba74dabc0342a54` (from `main` `9b248818`, Build 2026-11-07.1). **Builds on
elementor-map** (accepted, being merged now: branch `worktree-agent-a93c32bbf9bbc5ed4`, head `1a79e642`, plan
`docs/plans/2026-11-06-elementor-map.md`): every code excerpt below is written against that head, which changes the
same files (`src/core/site/convert.ts`, `classes.ts`, `parts.ts`, `tree.ts`, `src/web/code.ts`, `test/browser/render.ts`,
`test/web/lib/site-check.ts`). Evidence: `~/.hermes/plans/figma-to-bricks/evidence/site-motion/` (`planner/` holds the
inventories of both captures, the CSS scan of the saved bdryswi.com page, the probes and their scripts, the base unit
tally). No agent loads bdryswi.com; nobody logs in anywhere; nothing is written to any WordPress site; nothing paid.

## Amendments (planner, 2026-11-08; a fresh verifier or auditor reads this first)

Every changed line below carries *(amendment N)*. The text before these amendments is
`git show 85a1f2fe:docs/plans/2026-11-07-site-motion.md` (head `85a1f2fe`, branch `worktree-agent-acb4df7f943f7bd4c`,
base `7ff9ba4a`) and the first approved copy `evidence/site-motion/plan-approved.md` (which ends with the main session's
"Amendment 1" paragraph, folded into amendment 1 here). No AC is added, removed, renumbered or retagged; every test
name an AC cites is unchanged.

- **Amendment 1 (review 2's R2-1; Justin: "Fix it, then merge (Recommended)", `review-2/justin.json`):** Bricks' PHP
  prints `data-interaction-hidden-on-load` only for a Start animation whose type holds "In" (`includes/interactions.php`,
  `stripos`), and Bricks' `animate.min.css` hides an armed element only while its `data-animation` holds a capital "In"
  (`.brx-animated[data-animation*=In]`), so an entrance named without one (`rise`, `fadeUp`) showed at rest and then
  blinked out to its first frame. Now an entrance that starts hidden (the frame it starts on, its first keyframe or its
  last when it plays in reverse, laid over its rest look, has opacity 0 or visibility hidden) whose site name holds no
  capital "In" takes the Interaction type `<paste name>In` (`home__rise-abcdIn`: under the page's name it is never an
  animate.css name), its frames playing by `.c.brx-animate-<paste name>In`; an entrance whose site name holds "In", or
  that starts shown, keeps the site's name. Changed: the entrance criterion's binding and `animationType` (the AC4
  line); the live check reads the hidden-on-load mark only where Bricks prints it (the AC14 line and Task 14); the
  Design's reduced-motion block (`T` is the Interaction's type; the hidden-on-load override Task 12 added, `f7209b9d`); Task 7's
  and Task 10's code excerpts are superseded by head's tests; the first risk. The reduced-motion criterion (the AC7
  line) names no type, so its text stands; its unit test now reads `brx-animate-<paste name>In`. Supporting tests
  (not cited by an AC):
  `test/unit/site-motion.test.ts` › "R2-1 an entrance that starts hidden takes a type Bricks hides on load, never an animate.css name";
  `test/web/site-motion-proof.test.ts` › "R2-1 an entrance named without In that starts hidden waits hidden and never shows before it plays".
- **Amendment 2 (the verifier's AC11 finding; Justin: "Accept, fix 7.59 px later (Recommended)",
  `verifier/justin-ac11.json`, 2026-11-08):** the still-frame clause of the bdryswi.com criterion (the AC11 line, and
  Task 13) becomes: the code method's still frames within 2 px at 1440, 768 and 390; the `elementor` route's still
  frames no worse than the same `elementor` paste without motion (the capture read as version 2: no keyframes, looks or
  entrances) at each width where a row is over 2 px. B-Dry's page part is 7.59 px off at 390 on base `7ff9ba4a` too
  (elementor-map's own converter; `verifier/supporting/ac11-still-probe.log`); a separate job brings it within 2 px.
  This is what `test/web/site-motion-bdry.test.ts` (lines ~259–272) has asserted since Task 13 (`b70e5419`).
- **Amendment 3 (out-of-date wording, no decision):** the capture criterion's keyframe list (the AC1 line, and Task 3's
  excerpt) gains `appear` (the fixture's `#held`, review 1's R1-1, from `56eb0ff6`) and `fadeUp` (the fixture's `#up`,
  R2-1, from `55d18ba3`), as `test/web/capture-motion.test.ts` asserts at head.

**Receipts that still encode the old expectation** (sorted with `git show <head>:<test file> | grep '<old value>'`):
- Amendment 1: every AC4/AC7 unit receipt on a head before `eec3129a` asserts `animationType: "rise"` / `"fade"` and
  `.c.brx-animate-rise` (now `` `${name}In` `` / `` `${fade}In` `` and `.c.brx-animate-<paste name>In`):
  `builder/task7/ac4-unit.green.tap`, `builder/task7/unit.tap`, `builder/task10/*.tap`, the unit runs in
  `builder/gates/` and `builder/gates-rebased/` (heads up to `cfb0aa33`), and `fixer-1/check.log`, `green.log`,
  `red.log` (heads up to `13a336a0`); `fixer-2/red-unit.log` (on `242c0f60`) is R2-1's RED by design. The AC14 tool
  receipts `builder/task14/site-motion-live.tap` and `dryrun.log` expect the mark on every entrance element (now only
  where the type holds In). A mutant receipt whose failing assertion is unchanged stays valid (the rest rules naming no
  animation, `runOnce`, `paused`). The verifier's `verifier/ac4-85a1f2f.log` and `ac7-85a1f2f-unit.log` already read
  the new expectation.
- Amendment 2: no receipt encodes the old "both routes within 2 px" (the test never asserted it); the verifier's
  `verifier/ac11-85a1f2f.log` (both routes pass; code route worst 1.02 px, `elementor` route 7.59 px at 390, as without
  motion) meets the amended clause.
- Amendment 3: `builder/task3/ac1-capture-motion.green.tap` and the builder's gate runs (heads up to `cfb0aa33`) assert
  six names; fixer 1's runs (`13a336a0` to `eec3129a`) seven (with `appear`); from `55d18ba3` eight (the verifier's
  `verifier/ac1-85a1f2f.log`).

## Questions (⭐ = taken under the standing auto-go)

- **Q1 How an entrance plays** (a section that fades up as it comes into view: Elementor's `fadeInUp`, a script adds
  the classes once the box is in view). ⭐ **A: Bricks' own Interaction, "Enter viewport → Start animation", once**,
  on the element's class, with the site's own keyframes and timing bound to the class Bricks adds while it plays: by the
  clock, once, when the box first comes into view, hidden until then, exactly what bdryswi.com does; Bricks' own script
  runs it (no signed code); the team sees and edits it in Bricks' Interactions panel. Proved offline with Bricks
  2.3.9's own `bricks.min.js` and `animate.min.css` (Discovery 5). B: CSS only, tied to the scroll (`animation-timeline:
  view()`, as the Figma route's Motion): it follows the scroll position, so it can't be the site's 1.25 s, and Firefox
  plays it on load. C: copy the keyframes only: every entrance plays on load, long before a visitor scrolls to it (the
  page looks as still as today).
- **Q2 Where hovers and focus looks are read.** ⭐ **A: at the design width only** (one range: two extra reading passes,
  about 2 minutes on bdryswi.com's 40-minute capture), written for every width: B-Dry's hover rules are the same at
  every width. B: at every range (about 30 minutes more on bdryswi.com).
- **Q3 Which states.** ⭐ **A: hover, focus, focus-visible and focus-within** (all that B-Dry's CSS uses: buttons
  `:hover, :focus`, the grow `:hover, :focus`, flip boxes `:hover, :focus-within, :focus-visible`); `:active` (a click's
  instant) and `:visited` are left out. B: `:active` too.
- **Q4 Visitors who ask for reduced motion** (the project's website rule). ⭐ **A: the paste stands still**: endless
  animations hold their first frame, entrances show at rest as they come into view, transitions are instant; a hover's
  end look still applies (Elementor does the same for its own transitions). B: move as the site does (B-Dry's shimmer
  ignores reduced motion).
- **Q5 The hero slider** (Elementor's nested carousel, Swiper: 3 slides, speed 2500). ⭐ **A: its own job, planned now in
  parallel** (`site-slider`: Elementor's `nested-carousel` → Bricks' Slider (Nestable) on the Elementor step, as
  elementor-map made its accordion; it changes the tree, Splide's track and list replace the site's row, and the
  arrows become Splide's). This job leaves the slider as today (every own slide, the first showing). B: this job's last
  phase.
- **Q6 A capture made before this build** (Justin's 11-04 and 11-07 captures hold no hover looks and no keyframes).
  ⭐ **A: it pastes byte for byte as today**, with one note to capture again. B: take endless animations' keyframes
  from the freeze's raw record (`web.motion`) so an old capture shimmers (no hovers, no entrances).

## Playback

1. Justin pasted bdryswi.com's whole page from his own capture (2026-11-07): "honestly it does not look bad. The only
   issue really is the animation like the FAQ sections and animations for buttons and all."
2. The code method (`src/core/site/`, `npm run site`) pastes the site's elements, classes and CSS, but nothing moves:
   - no `@keyframes` reaches a paste, so every animation the site's CSS names stands still at its un-animated value:
     B-Dry's header bar and its "Our Services" and "THE BDry® SYSTEM" bands show navy where the site shimmers teal; the
     sections that fade and slide into view (Elementor's `fadeIn`, `fadeInUp`, `fadeInLeft`) never play; the hotspot
     dots don't beat;
   - no hover or focus look reaches a paste: buttons don't change colour or grow, cards don't lift their shadow, the
     six flip boxes never turn, links don't change colour, though the paste carries the site's transitions;
   - what scripts drive stays as captured: the hero slider (Q5), the FAQ (elementor-map), the reviews.
3. This job makes the paste move as the site moves, for any captured site, by its own CSS: the keyframes its rules
   name, its hover and focus looks, its entrances played when they come into view (Bricks' own Interaction), and
   stillness for visitors who ask for less motion. The FAQ that opens and closes is elementor-map's (`--elementor`);
   both routes get this job's motion.

**What Justin can do when it lands:** capture bdryswi.com again (`npm run capture`), paste the header, page and footer
as before (with `--elementor` for the FAQ), and see the header and bands shimmer teal, the sections rise and slide in
as he scrolls, the dots beat, every button change colour and grow under the pointer, the cards lift, the flip boxes
turn, and the FAQ open (elementor-map). Not yet: the hero slider playing (Q5), the hotspot tooltips, the "60 Years"
circle drawing itself, the reviews sliding.

## Motion inventory (bdryswi.com's home: Justin's 11-07 capture, 11-04's agrees)

Read offline from `/home/justin/Downloads/bdryswi-com-home.f2b-capture.json` (code v2, Build 2026-11-07.1; a wifi drop
made 1024, 769–834, 361–412 unreadable) and `evidence/web-code-page/planner/capture.json` (11-04, code v1), with the
saved 2026-10-29 page's CSS (`evidence/web-code-proof/planner/inputs/bdry-2026-10-29/`): `planner/inventory-1107.txt`,
`inventory-1104.txt`, `widgets-1107.txt`, `css-scan.txt` (scripts `planner/scripts/`). The 11-07 capture's whole page was
pasted with today's code (`planner/paste-1107/`, counted in `planner/paste-grep-1107.txt`).

| # | Kind | On B-Dry's home | Today's paste | Should |
|---|---|---|---|---|
| 1 | Endless keyframe animation on a `::after` | `shimmerGradient` (8 s linear infinite; `0% {background-position: 100% 100%} 50% {0% 0%} 100% {100% 100%}`, the page's inline CSS `.bg:after`): header bars `header:0/div:0`, `div:1`, the "Our Services" band (page `div:3`), "THE BDry® SYSTEM" (`div:7`) | the `::after` rule names `animation-name: shimmerGradient` (`classes.ts:111-112` writes it) but no `@keyframes` exists anywhere: `src/web/read/code.ts:70-96` never reads DevTools' `cssKeyframesRules` (declared at `src/web/cdp.ts:75`, read by nothing); page.json: 14 `animation-name`, 0 `@keyframes`. The `::after` sits at `background-position: 0% 0%`: navy | the keyframes in the class, renamed `home__shimmer-gradient-abcd`; plays from load; teal at its first frame |
| 2 | Endless keyframe animation on an element | `e-hotspot-soft-beat` (0.7 s alternate infinite, `scale(1) → scale(1.1)`, Elementor's CSS) on 3 hotspot dots (`div:13/…/a:0..2/div:0`) | still | beats as on the site |
| 3 | Finite entrance (a script adds the classes in view) | Elementor `animated` + `fadeIn` ("Over 60 Years", `div:1`), `fadeInUp` (`div:3` Our Services; `div:4` its tablet copy), `fadeInLeft` (their headings `div:3/div:0`, `div:4/div:0`), 1.25 s (`animated-slow` 2 s), `ease`; markers `data-settings` `animation`/`_animation` | the capture reads them as revealed (`src/web/readers/libraries.ts:22-23` drops `elementor-invisible`; the freeze finishes them, `freeze.ts:92-109`): `animation-name: fadeInUp` with no keyframes: shown still | hidden until the box comes into view, then the site's keyframes once, by the clock (Q1 A) |
| 4 | Self hover/focus looks | 22 Elementor buttons (`.elementor-button:hover, :focus { background-color: var(--e-global-color-d8599e5) }`, transitions 0.3 s), 17 `elementor-animation-grow` (`:hover, :focus { transform: scale(1.1) }`, 0.3 s), 13 heading links (`.elementor-heading-title a:hover, :focus { color }`), 6 service cards (`:hover { box-shadow: 1px 2px 34px 19px rgba(0,0,0,.5) }`), footer icon lists (`transition: color .3s`) | the reader reads only the rules that match at rest (`code.ts:70`, `ruleLists` `:50-51`): page.json carries 126 `transition-property` declarations (they reach the paste, `controls.ts:114-118`) but 0 `:hover`/`:focus` rules: nothing changes | `.c:hover {…}` (`:focus`, `:focus-visible`, `:focus-within` as the site) in the class, after its own rules; the site's transitions animate them |
| 5 | A look an ancestor's state sets | 6 flip boxes (`.elementor-flip-box:hover / :focus-within / :focus-visible .elementor-flip-box__back { transform: none }`, the front `rotateY(-180deg)`; layers `transition: all .6s ease-in-out`) | static: the front only | the box turns on hover and keyboard focus: `.<flip class>:hover .<back class> {…}` |
| 6 | The capture's own freeze | `#f2b-still` `transition: none !important` (`freeze.ts:102-106`) | version 2 never reads it (`code.ts:146-160` `ownSheets`); version 1 drops it (`still.ts`) | unchanged |
| 7 | The hero slider (Swiper) | `nested-carousel.default`, 3 slides, speed 2500 | every own slide, the first showing (`widgets.ts:10,23`) | Q5 A: its own job |
| 8 | The FAQ (ElementsKit accordion) | 5 questions | the code method: static; elementor-map: Bricks' Accordion that opens and closes (`--elementor`) | elementor-map; its titles' hover looks and transitions come with this job |
| 9 | The "60 Years" circle drawing itself | `elementor-headline-dash` (1.2 s once) on an svg path inside the highlighted headline (a Code element's markup) | the reader writes the path's computed paint (web-code-page R1-1): drawn whole, still | follow-up (an svg part's animation inside markup, started by Elementor's script) |
| 10 | Hotspot tooltips, the reviews carousel, the sticky bar, the ☰ pop-up | Elementor's and Trustindex's scripts | static as captured | follow-ups / other jobs (unchanged here) |

## Discovery (planner, 2026-11-07)

1. **The paste today** (11-07 capture, `planner/paste-grep-1107.txt`): header 2 `animation-name` (shimmer), page 14
   (fadeIn, fadeInUp, fadeInLeft, shimmerGradient, e-hotspot-soft-beat, one `revert`), footer 0; `@keyframes` 0
   everywhere; `transition-property` 18 / 126 / 94; `:hover` 0, `:focus` 0, `prefers-reduced-motion` 0.
2. **The site's CSS** (saved 2026-10-29 page, `planner/css-scan.txt`): 311 `@keyframes`, 36 names used by rules (the
   page names five); 237 `:hover`, 155 `:focus`, 41 `:focus-visible`, 30 `:focus-within`, 20 `:active` rules; no
   `(hover)`/`(pointer)` media queries; Elementor's own `@media (prefers-reduced-motion: reduce)` rules (`.animated {
   animation: none }`, `html * { transition-duration: 0s }`). The page-specific hover rules are listed at the end of
   that file.
3. **DevTools gives the keyframes** (`planner/probe-cdp.json`, local page): `CSS.getMatchedStylesForNode` answers
   `cssKeyframesRules` for the element's own animation, as written (each keyframe's text and declarations with source
   ranges), the rule in effect at that width (a `@media`-wrapped `@keyframes` answers at 500 px, the plain one at
   1200); a `::after`'s animation comes only with the pseudo element's own node (`DOM.describeNode` depth 1 →
   `pseudoElements` → `DOM.pushNodesByBackendIdsToFrontend` → its own matched styles): the host's answer lists none.
4. **Forced states work and are cheap** (`probe-cdp.json`, `probe-cdp2.json`): `CSS.forcePseudoState` on every element
   at once (0.55 ms a call); the matched rules then hold `.card:hover .title` on the title, `.btn:hover, .btn:focus`
   with `matchingSelectors` naming the one that matched, `.b:hover::after` in the host's `pseudoElements`, an inline
   `<a>`'s `p a:hover`, and the keyframes a hover-only `animation` names; a `:not(:hover)` rule stops matching. A
   forced state also answers `Element.matches(":hover")` true (`probe-bricks.json`), so the trigger test (which element's
   state sets a look) runs with no state forced: marking the element and its ancestors from the element up, the
   highest one where the rule's selector (its state written as the mark) still matches is the trigger (`.card:hover
   .title` on the title: title ✓, wrap ✓, card ✓, body ✗ → the card).
5. **Bricks' own Interaction plays a site's keyframes once as the box comes into view** (`probe-bricks.json`, local
   page with Bricks 2.3.9's `reference/bricks/frontend-2.3.9/bricks.min.js` and darksalmon's `animate.min.css`,
   sha256 `8c647b66…cbe`, saved `evidence/entrance-timing/planner/live-animate.min.css`): an element printed as live
   Bricks prints a class interaction (`data-interactions='[{"id","trigger":"enterView","action":"startAnimation",
   "animationType":"fadeInUp","animationDuration":"1.25s","runOnce":true}]' data-interaction-id data-interaction-hidden-
   on-load="1"`, read on darksalmon's home, `evidence/entrance-timing/planner/fetch-live-bricks.txt`) is opacity 0 out of
   view; scrolled in, Bricks adds `brx-animated brx-animate-fadeInUp` and an inline `animation-duration: 1.25s`, and the
   class rule `.home__band.brx-animate-fadeInUp { animation-name: home__fadeinup-abcd }` plays the site's own keyframes
   (opacity 0.80, translateY 39.5 px at 50 % with `ease`); at its end Bricks takes `brx-animate-fadeInUp` away (the box
   at rest, opacity 1); scrolled away and back it doesn't play again (`runOnce`); under reduced motion Bricks' own
   `animate.min.css` makes it 1 ms (shown at once). The same mechanism was the hand-made B-Dry paste's ⭐ choice in
   services-band-speed (2026-10-29), never pasted live: `enterView` and `runOnce` are proved only in Bricks' code (a
   live check, AC14).
6. **Cost:** today's code read is 64–114 s a range on bdryswi.com (`web.timings["code <range>"]`, 1419 nodes); two
   forced passes at one range add about two reads (~2–3 minutes) to its ~40-minute capture.
7. **The unit suite on the base** (elementor-map's head `1a79e642`, archived, Node 22.23.3,
   `planner/base-unit/done.txt`): 3420 tests, 3352 pass, 0 fail, 68 skipped.
8. **The converter half is proved on the plan's own text** (`planner/proto/`, scripts `planner/scripts/proto-*.sh`,
   `base-red.sh`): the plan's fenced blocks pulled by a script into a `git archive` of `1a79e642` (Tasks 5–10's fixture,
   unit tests, `motion.ts`, `states.ts`, `customCss`, `keep`, `prepare`'s block, `nameClasses`, `withStates` calls):
   on the clean base AC3, AC4, AC5, AC6, AC7 and AC12 fail by assertion (`red-final.tap`); with the code, 6 of 6 pass
   (`green2.tap`), the whole unit suite gives 3426 tests, 3358 pass, 0 fail, 68 skipped (the base's 3420 / 3352 plus the
   six) and `tsc --noEmit` both configs exit 0. The reader (Tasks 3–4), the renderer (Task 11) and the browser proofs
   are not prototyped beyond Discovery 3–5's probes.
9. **Tests that pin what changes** (on `1a79e642`): `test/web/capture-code.test.ts:51`,
   `test/web/capture-code-page.test.ts:62`, `test/web/site-page-bdry-paint.test.ts:74` assert `code.version === 2`
   (a fresh capture is 3 now: those three lines may change, only to 3). No fixture site the web tests capture has a
   `:hover`, `:focus` or `transition` rule but `basic` (`.fade { animation: rise … }`), `facts` (`.spin`), `builder`
   and `reveal`; no unit fixture is version 3, so every unit golden (`test/fixtures/site-basic-golden.json`) and every
   hand-made capture converts byte for byte (Q6 A).

## How it meets elementor-map

- **Start point:** `main` once elementor-map has merged (it is being merged now). If it hasn't when the builder starts,
  build on `worktree-agent-a93c32bbf9bbc5ed4`'s head and rebase onto `main` when it lands; every excerpt here is written
  against that head (`prepare` with `elementor`, `nameClasses` with `nameFor`, `withLooks`, `bricksScript` in
  `test/browser/render-nav.ts`, `settle` in `test/web/lib/site-check.ts`).
- **The FAQ** opens and closes with elementor-map's Accordion and Bricks' own script; this job adds the site's hover and
  focus looks of its titles and icons where the site has them, and the site's transitions then animate them; the open
  look (`withLooks`, `.brx-open` rules) is elementor-map's and is untouched.
- **Names:** on the Elementor route every class is named after its rules (`nameFor`: `versioned(base, rules)`); this
  job's state rules, keyframes and Interaction are part of `spec.key`, so they are part of that fingerprint. On the code
  method's route (numbered names) a class with a look is a different key from one without, so it is its own class.
- **The fold:** a widget's wrapper whose own look changes under a state keeps its box (a fold would lose the look;
  AC15); a look whose trigger is a folded wrapper is set by the element the fold merged it into.
- **Both pastes:** `withStates` runs right after `withLooks` in `siteToBricks` and `siteParts`.

## Design

**Capture format (version 3, `src/core/snapshot/web.ts`).** Two new blocks, both read with `web.code`:
- `web.code.keyframes`: every `@keyframes` an element, its `::before`/`::after`, an inline element or a state look
  names, by the site's name: `{ frames: [{ at: "0%", decls: { "background-position": "100% 100%" } }, …], range,
  differs? }` (as written, var() resolved; read in the widest range naming it; `differs`: narrower ranges whose rule of
  that name reads otherwise).
- `web.code.nodes[path].states`: the element's looks under a state, read at `web.code.statesAt` (the design width's
  range): `[{ state: "hover" | "focus" | "focus-visible" | "focus-within", trigger: "" (itself) | <an ancestor's path>,
  part: "" | "::before" | "::after" | <an inline element's index path>, decls: { …only what the state changes } }]`.
- `web.code.unplacedStates`: how many looks a state sets through another element (`:has(:hover)`, a neighbour's
  state), not kept.

**Reader.** `src/web/read/code.ts` `readCode(s, range, { states })` keeps, per thing it reads (element, pseudo,
inline element), the keys of the rules it matched at rest, collects the keyframes the final declarations name
(`src/web/read/code-keyframes.ts`), and at the design width's range runs `readStates` (`src/web/read/code-states.ts`:
two forced passes, the cascade per longhand with each declaration's rule, the trigger test with no state forced).
`src/web/code.ts` `assembleCode` writes version 3, `keyframes`, `statesAt`, `states`, `unplacedStates`.
`src/web/capture.ts` asks for states at the design width's range and notes the unplaced count.

**Converter** (`src/core/site/`, version 3 captures only; an older one converts as today with one note, Q6 A):
- `motion.ts` (new): `motionOf` names every captured `@keyframes` `versioned("<page>__<kebab name>", frames)`
  (`home__shimmer-gradient-abcd`: page-prefixed per amendment 4, named after its frames like `classes.ts` `versioned`,
  so two pages or two captures of other frames never share a name) and writes its text (rem in px of its range's root
  size); `renameDecls` renames `animation-name` values; `entranceOf` finds an element's own finite animation (every
  iteration count a number at every range it animates); `interactionOf` writes Bricks' Interaction; `withoutAnimation`
  and `bindingOf` split its `animation-*` from its rules; `keyframesFor` lists a class's `@keyframes`.
- `states.ts` (new): `looksOf` turns a node's looks into the class's self rules and its ancestor-set looks;
  `withStates` writes the ancestor-set ones once the classes are named (`.<trigger class>:<state> .<class>`).
- `classes.ts` `customCss`: after the class's own, pseudo and inline rules: the entrance binding
  (`.<c>.brx-animate-<type>{self} { animation-*… }`), the state rules (`.<c>{self}:<state>`, `:<state>::after`, an
  inline element's `… > :nth-child(k):<state>`), the `@keyframes`, the reduced-motion block (`stillCss`). Nothing
  changes for a class without motion (byte for byte).
- `controls.ts` `controlsFor(…, { keep })`: a property any state of the element changes stays in the class's custom
  CSS (Bricks prints a class's tier controls after its custom CSS, `test/browser/render-order.ts`, so a control's tier
  rule would beat the hover).
- `convert.ts` `prepare`: renames, splits an entrance, reads looks, keys every class by its motion too; `nameClasses`
  writes the class's `_interactions` (id `shortId("interaction:<name>")`); `siteToBricks` calls `withStates`.
  `parts.ts` `siteParts` calls `withStates`. `elementor-fold.ts` `foldable`: a wrapper with a look of its own isn't
  folded.

**No script, nothing to sign:** nothing this job adds is code Bricks signs: an Interaction is a class setting Bricks'
own front-end script runs, and the keyframes, state rules and reduced-motion block are class CSS. The paste's Code
elements (drawings, the map frame) still need Bricks → Settings → Custom code → Regenerate code signatures after
pasting, as today (the paste check's step 7).

**Reduced motion** (`stillCss`, Q4 A), for every class with motion: `@media (prefers-reduced-motion: reduce) { .c, .c *,
.c::before, .c::after { animation-play-state: paused !important; transition: none !important; } .c.brx-animate-T {
animation: none !important; } }` (`{self}` after `.c` for a flat Rich Text or a Code element). `T` is the Interaction's
type (`<paste name>In` for an entrance that starts hidden, amendment 1), and an entrance Bricks holds hidden on load
also gets `.c:not(.brx-animated)[data-interaction-hidden-on-load] { opacity: 1 !important; }` in the block, so nothing
stays hidden *(amendment 1)*.

**Test renderer** (`test/browser/render.ts`, site mode, new option `bricksMotion`): an element whose classes carry a
`startAnimation` Interaction prints `data-interactions`, `data-interaction-id`, `data-interaction-hidden-on-load="1"`
as live Bricks prints them; the page loads Bricks 2.3.9's `animate.min.css` (copied to
`reference/bricks/frontend-2.3.9/animate.min.css`) and runs Bricks' own `bricksInteractions()` (`bricksScript`). Without
`bricksMotion` nothing changes: the 1:1 checks see the rest look as today.

**Checker** (`test/web/lib/motion-check.ts`, new): reads the same motion on a site page and its paste: an animation
held at a fraction of its duration, a transition held halfway after Chrome's own mouse moved onto the element, the
keyboard's Tab, values compared number by number.

## Acceptance criteria (proposed; Justin gave none)

- AC1 (proposed): A capture keeps every `@keyframes` the page uses: given the generic fixture `site-motion` captured
  with code, `web.code.version` is 3 and `web.code.keyframes` holds exactly `shimmer`, `beat`, `wiggle` (named only by a
  hover rule), `fadeInUp`, `fadeInLeft`, `fadeIn`, `appear` and `fadeUp` *(amendment 3)* (never `unused`, which no rule
  names), each frame as the fixture writes it (`shimmer`: `0%` `background-position: 100% 100%`, `50%` `0% 0%`, `100%` `100% 100%`). Test:
  `test/web/capture-motion.test.ts` › "AC1 keeps every @keyframes the page's elements, their ::after and their hover
  looks name".
- AC2 (proposed): A capture keeps each element's hover and focus looks with the element whose state sets them: at
  `web.code.statesAt` (the range holding 1440) `#go` has `hover` and `focus` looks, trigger `""`, `background-color:
  #e73a3a`; `#call` also `transform: scale(1.1)`; each menu link `hover` `color: #ffcc00`; the hero paragraph's inline
  link (part `"0"`) `hover` `color: #e73a3a`; each card `hover` `box-shadow`; `#front` and `#back` `hover` and
  `focus-within` looks whose trigger is `#flip`'s path (`transform: rotateY(-180deg)` / `none`); `#more`
  `focus-visible` outline longhands; the logo's `hover` the `animation` longhands naming `wiggle`; no other node has a
  look; and the rest of the capture is what a capture without code reads (nothing is left hovered or focused). Test:
  `capture-motion.test.ts` › "AC2 reads hover and focus looks at the design width, with their trigger".
- AC3 (proposed): Endless animations run as on the site: in the paste of a version 3 capture every class whose rules
  name a captured animation holds its `@keyframes`, named `<page>__<name>-<4 letters>` after its frames, and its
  `animation-name` renamed (unit: two classes using one keyframes write the same name; other frames give another
  name); in Chrome, the fixture's header bar and band `::after` and the dot, held at 0, 25, 50 and 75 % of their
  duration on the site page and on the paste, have equal `background-position` / `transform`, and the band's patch of
  shimmer is the site's colour (within 10 per channel) at 0 % and 50 %. Tests: `test/unit/site-motion.test.ts` › "AC3
  a named animation's @keyframes go with the class that uses it, under the page's name"; `test/web/site-motion-proof.test.ts`
  › "AC3 endless animations run as on the site (frames at 0, 25, 50 and 75 %)".
- AC4 (proposed): An entrance plays once as it comes into view: an element's own finite animation leaves its rules for
  `.c.brx-animate-<type> { … }` (its delay set to 0 s) and its class carries one Interaction `{ id, trigger:
  "enterView", action: "startAnimation", animationType: <type>, animationDuration: <site's>, animationDelay
  (only when not 0), runOnce: true }`, where `<type>` is the site's name, except for an entrance that starts hidden (the
  frame it starts on, laid over its rest look, has opacity 0 or visibility hidden) whose site name holds no capital
  "In": its type is its paste name with In after it (`home__rise-abcdIn`) *(amendment 1)*; in Chrome, with Bricks 2.3.9's own script and `animate.min.css`, `#enter`,
  `#enter-title` and `#late` are invisible before they come into view, start when they do (`#late` after its 0.3 s),
  run the site's duration and easing, equal the site's opacity and transform at 25, 50 and 75 %, end at rest within
  2 px of the site's boxes, don't play again when scrolled away and back, and at 390 px `#enter-title` plays the
  phone range's `fadeIn` as the site does. Tests:
  `site-motion.test.ts` › "AC4 a finite animation becomes an Enter viewport interaction with the site's frames";
  `site-motion-proof.test.ts` › "AC4 entrances wait out of view, play the site's frames once as they come in, and end at rest".
- AC5 (proposed): Hover and focus look as on the site: a look the element's own state sets is `.c:hover {…}` (`:focus`,
  `:focus-visible`, `::after`, an inline element's `:nth-child(k):hover`) after the class's own rules, and its
  properties are never Bricks controls; in Chrome, with Chrome's own mouse on `#go`, `#call`, the first menu link, a
  card, the hero's inline link and the logo, each changed property of the element equals the site's halfway through
  its transition (held) and at its end, boxes within 2 px; with the keyboard's Tab on `#go` its focus look equals the
  site's. Tests: `site-motion.test.ts` › "AC5 a state look is a rule after the class's own, never a Bricks control";
  `site-motion-proof.test.ts` › "AC5 buttons, cards and links hover and focus as on the site (halfway and at the end)".
- AC6 (proposed): A look an ancestor's state sets follows the ancestor: `#back`'s class holds `.<flip class>:hover
  .<back class> { transform: none; }` and the `:focus-within` one (the flip box's class named, never an id); in Chrome
  the flip box turns under the mouse and when Tab reaches `#more`: `#front` and `#back` transforms equal the site's
  halfway and at the end, the outline of `#more` equals the site's, and it turns back when the mouse leaves. Tests:
  `site-motion.test.ts` › "AC6 a look an ancestor's state sets names the ancestor's class"; `site-motion-proof.test.ts`
  › "AC6 the flip box turns on hover and on Tab as on the site".
- AC7 (proposed): Reduced motion: every class with motion holds the reduced-motion block; in Chrome with
  `prefers-reduced-motion: reduce`, no animation or transition of the paste runs (none in `running` after load, after
  each hover of AC5 and after each entrance of AC4 comes into view), the shimmer holds its first frame, each entrance
  is at rest and visible within 200 ms of coming into view, and the hovered looks still apply. Tests:
  `site-motion.test.ts` › "AC7 every class with motion stands still under reduced motion"; `site-motion-proof.test.ts`
  › "AC7 reduced motion: nothing moves, nothing stays hidden".
- AC8 (proposed): Still frames stay 1:1: the `site-motion` fixture's three pastes (rich and basic) match the fixture
  page within 2 px at every width its capture read plus 2560, 1920, 1440, 1024, 768, 390 and 320, motion held as
  `settle` holds it; web-code-page's AC7 (`site-page-proof.test.ts`, the `code-page` fixture) passes unchanged. Tests:
  `site-motion-proof.test.ts` › "AC8 the motion page, pasted in three parts, matches the fixture within 2 px at every
  width"; `test/web/site-page-proof.test.ts` (unchanged).
- AC9 (proposed): An older capture pastes byte for byte: a version 1 or 2 capture (every hand-made unit capture, and
  with `F2B_SITE_MOTION_OLD` set Justin's 11-04 and 11-07 captures) gives exactly the pastes `main` gave before this job
  (recorded in Task 0), rich and basic, pictures by address and as data, with and without `elementor`, and its notes
  gain only "this capture predates hovers and animations…" when its code names an animation. Test:
  `test/unit/site-motion-old.test.ts` › "AC9 a capture made before this build pastes as before, with one note" (the
  real captures named-only).
- AC10 (proposed): Figma designs convert byte for byte: the five replays' `bricks.json` and `warnings.txt` are
  identical to the base's, `npm run corpus` is no worse than the base, and `test/unit/site-isolation.test.ts` passes.
  Test: Task 15's replay receipt and `test/unit/site-isolation.test.ts`.
- AC11 (proposed): bdryswi.com's saved home moves as the page does (named-only, `F2B_CODE_PROOF_BDRY`): captured
  fresh from the saved 2026-10-29 page served offline, its pastes (code method and `elementor`) run the header and band
  shimmer (frames at 0, 25, 50, 75 % equal; the band's patch the site's colour within 10 per channel at 0 and 50 %,
  where today's paste is still), the three hotspot dots' beat, every
  button's hover colour and grow, every service card's shadow, and the six flip boxes turn under the mouse, each as on
  the page; at 1440, 768 and 390 the code method's still frames stay within 2 px and the `elementor` route's are no
  worse than the same `elementor` paste without motion (B-Dry's page part is 7.59 px off at 390 on base `7ff9ba4a` too;
  a separate job brings it within 2 px) *(amendment 2)*. Test:
  `test/web/site-motion-bdry.test.ts` › "AC11 bdryswi.com's saved home: shimmer, beat, buttons, grow, cards and flip boxes move as on the page".
- AC12 (proposed): Names stay apart: no class name and no `@keyframes` name of any paste is bare (every one starts with
  the page's name but the plugin's four), the same fixture captured at `/` and at `/services/` shares no `@keyframes`
  name, and an Interaction's id is six letters, the same in every paste of one capture. Tests: `site-motion.test.ts` ›
  "AC12 keyframes and classes are never bare; interaction ids are stable"; `test/web/lib/class-names.ts` `bareNames`
  reads `@keyframes` names too (every caller of it).
- AC13 (proposed) (live): Justin captures bdryswi.com again and pastes the header, page and footer into B-Dry staging
  (paste check steps in HANDOFF); side by side with bdryswi.com at 1440 and on his phone: the header bar and the "Our
  Services" band shimmer teal, the sections rise and slide in once as he scrolls, the dots beat, the buttons change
  colour and grow under the pointer, the cards lift, the flip boxes turn; with Reduce motion on (Mac: System Settings →
  Accessibility → Display) nothing moves and nothing stays hidden. Test: HANDOFF paste check <id> steps 1–9.
- AC14 (proposed) (live): Bricks keeps it: after Justin's paste and save, B-Dry staging's page (read only, over HTTP)
  prints `data-interactions` with `enterView` and `runOnce` on the entrance elements and `data-interaction-hidden-on-load`
  on those whose type holds In (every entrance that starts hidden) *(amendment 1)*, links Bricks' `animate.min.css`, and its class CSS holds the `@keyframes` and the `:hover` rules. Test:
  `tools/site-motion-live.ts <page URL> <paste dir>` (read-only GETs) › "Bricks kept the interactions, keyframes and
  hovers".
- AC15 (proposed): The Elementor step keeps the motion: with `elementor: true` every AC3–AC7 rule holds (AC11 runs both
  routes), and a widget wrapper with a look of its own under a state is never folded (`not folded: … its <role>
  changes under hover`), its look kept. Test: `test/unit/site-elementor-fold.test.ts` › "AC15 a wrapper with a look of
  its own under a state keeps its box".

## Architecture (files)

| File | New / changed | What |
|---|---|---|
| `src/core/snapshot/web.ts` | changed | version 3: `CodeState`, `CodeStateLook`, `CodeKeyframes`, `CodeNode.states`, `WebCode.keyframes`, `statesAt`, `unplacedStates` |
| `src/web/read/code-keyframes.ts` | new | `framesOf`, `pseudoNodeId` |
| `src/web/read/code-states.ts` | new | `readStates` (forced passes, cascade with rules, trigger test `triggersOf`) |
| `src/web/read/code.ts` | changed | rest rule keys per target, keyframes, `opts.states` |
| `src/web/code.ts` | changed | version 3 assembly |
| `src/web/capture.ts` | changed | states at the design width's range; unplaced note; `timings["states <range>"]` |
| `src/core/site/motion.ts` | new | keyframe names and text, rename, entrances, Interaction, old-capture note |
| `src/core/site/states.ts` | new | `looksOf`, `withStates` |
| `src/core/site/classes.ts` | changed | `ClassCss` fields, `inlineSel`, `partSel`, `stillCss`, `customCss` |
| `src/core/site/controls.ts` | changed | `keep` |
| `src/core/site/convert.ts` | changed | `prepare`, `Prepared.specs`, `nameClasses` (`_interactions`), `siteToBricks` |
| `src/core/site/parts.ts` | changed | `withStates` |
| `src/core/site/elementor-fold.ts` | changed | a wrapper with a look of its own isn't folded |
| `reference/bricks/frontend-2.3.9/animate.min.css` | new | byte copy, `SHA256SUMS` line, README line |
| `test/browser/render.ts` | changed | `bricksMotion` |
| `test/web/lib/site-check.ts` | changed | `renderSitePaste(…, { motion })` |
| `test/web/lib/motion-check.ts` | new | the motion oracle |
| `test/web/lib/class-names.ts` | changed | `@keyframes` names |
| `test/fixtures/web/sites/site-motion/` | new | `index.html`, `style.css`, `enter.js` |
| `test/fixtures/site-motion-code.ts` | new | hand-made version 3 code |
| tests | new | `test/unit/site-motion.test.ts`, `site-motion-old.test.ts`, `test/web/capture-motion.test.ts`, `site-motion-proof.test.ts`, `site-motion-bdry.test.ts` |
| `tools/site-motion-live.ts` | new | AC14 (read-only) |

## Tasks

Every task: test first (RED on the base, shown in the ledger), the smallest code to green, `npm run typecheck` (the
worktree's `node_modules` has no `.bin`: `node node_modules/typescript/bin/tsc --noEmit -p .` and `-p
tsconfig.sandbox.json`, or link `.bin/tsc`), commit the task's files by name. Ledger: `.superpowers/sdd/2026-11-07-site-
motion/progress.md`, committed with each task. Machine: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH,
`TMPDIR=~/.cache/sm-b/tmp` (at most 38 characters), `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`,
one Chrome job of your own at a time, heavy runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`,
waits under 115 s (poll a Write-made script), SIGTERM/143/137 may be earlyoom (check `journalctl -u earlyoom`).
Never edit the main folder, never bump `BUILD`, never push, never bare `git stash`, never load bdryswi.com.

### Task 0: Baselines on the base (the copy still equals `main` with elementor-map merged)

1. `git log --oneline -3` names elementor-map's merge build; else stop and say which head you're on.
2. In a `git archive` tree of the base (`git archive -o <E>/base.tar HEAD` as its own call, `tar -xf` in another; link
   `node_modules`): `npm run check` (record the unit tally: the planner read 3420 / 3352 pass / 0 fail / 68 skipped on
   `1a79e642`), the five replays (`bricks.json`, `warnings.txt` sha256 per file), `npm run corpus` (keep
   `corpus/report-v2.json` and every `corpus/out/v2/*/bricks.json`), and these web files one by one (`node --test
   --test-concurrency=1 --test-reporter=tap <file>`, one log each): `capture-code.test.ts`, `capture-code-page.test.ts`,
   `site-page-proof.test.ts`, `site-code-proof.test.ts`, `code-markup-paint.test.ts`, `site-check-settle.test.ts`,
   `site-elementor-proof.test.ts`, `site-elementor-svg-icons.test.ts`, `site-elementor-pbox.test.ts`,
   `site-elementor-grid.test.ts`, `capture-hidden-parts.test.ts`, `tracker-style.test.ts`; and `test/browser/render*.test.ts`.
3. AC9's base pastes: a scratch script (`<E>/scripts/old-pastes.ts`) importing the archive's `src/core/site/parts.ts`
   and `convert.ts` writes, for Justin's two captures (`/home/justin/Downloads/bdryswi-com-home.f2b-capture.json`,
   `~/.hermes/plans/figma-to-bricks/evidence/web-code-page/planner/capture.json`), every paste (`siteParts`: rich and
   basic × address and data × elementor false and true) as `<E>/base/old/<capture>/<variant>-<part>.json` plus
   `notes.json`; and for every hand-made capture export of `test/fixtures/site-code.ts`, `site-page-code.ts`,
   `site-parts.ts`, `site-media.ts`, `site-elementor-code.ts` the same into `test/fixtures/site-motion-base/<name>.json`
   (committed: AC9's goldens; small). `E` = `~/.hermes/plans/figma-to-bricks/evidence/site-motion/builder/`.
4. Ledger: the tallies and hashes. Commit: `site-motion task 0: base pastes of the hand-made captures (AC9's goldens)`.

### Task 1: The generic fixture `site-motion`

`test/fixtures/web/sites/site-motion/index.html`:

```html
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width">
<title>Motion Co</title>
<link rel="stylesheet" href="/style.css">
</head>
<body>
<header class="bar">
  <div class="bar__glow">
    <a class="logo" id="logo" href="/">Motion Co</a>
    <nav class="menu"><a class="menu__link" id="about" href="/about/">About us</a><a class="menu__link" id="work" href="/work/">Our work</a></nav>
    <a class="btn btn--grow" id="call" href="/contact/">Call us today</a>
  </div>
</header>
<main class="page">
  <section class="hero">
    <h1 class="hero__title">Moving parts, kept moving</h1>
    <p class="hero__lead" id="lead">Words with an <a class="inline" href="/more/">inline link</a> that changes colour under the pointer.</p>
    <a class="btn" id="go" href="/start/">Get started</a>
  </section>
  <section class="band" id="band"><h2 class="band__title">Our services shimmer</h2></section>
  <section class="cards">
    <div class="card" id="card1"><h3 class="card__title">Card one</h3><p class="card__text">Lifts its shadow under the pointer.</p></div>
    <div class="card" id="card2"><h3 class="card__title">Card two</h3><p class="card__text">The same card again, the same lift.</p></div>
    <div class="dot" id="dot"></div>
  </section>
  <section class="flips">
    <div class="flip" id="flip">
      <div class="flip__front" id="front"><h3 class="flip__title">Turn me over</h3></div>
      <div class="flip__back" id="back"><p class="flip__text">The back of the card.</p><a class="flip__link" id="more" href="/more/">Read more</a></div>
    </div>
  </section>
  <div class="spacer"></div>
  <section class="enter is-hidden" id="enter" data-enter="fadeInUp"><h2 class="enter__title is-hidden" id="enter-title" data-enter="fadeInLeft">Rises into view</h2><p class="enter__text">As a page builder's entrance does, once.</p></section>
  <section class="enter enter--late is-hidden" id="late" data-enter="fadeIn"><p class="enter__text">Fades in a little later.</p></section>
</main>
<footer class="foot"><p class="foot__text">Motion Co, <a class="foot__link" href="/privacy/">privacy</a></p></footer>
<script src="/enter.js"></script>
</body>
</html>
```

`style.css`:

```css
* { box-sizing: border-box; }
body { margin: 0; font-family: Arial, Helvetica, sans-serif; color: #222; line-height: 1.4; }
.bar { background: #0b2545; }
.bar__glow { position: relative; display: flex; align-items: center; justify-content: space-between; gap: 24px; padding: 16px 32px; }
.bar__glow::after { content: ""; position: absolute; inset: 0; z-index: 0; pointer-events: none; background-image: linear-gradient(-120deg, #004774 0%, #0080cd 25%, #00408a 50%, #000d5a 90%, #004774 100%); background-size: 200% 200%; animation: shimmer 8s linear infinite; }
.logo, .menu, .btn { position: relative; z-index: 1; }
.logo { display: inline-block; color: #fff; font-weight: 700; font-size: 20px; text-decoration: none; }
.logo:hover { animation: wiggle .5s ease-in-out 1; }
.menu { display: flex; gap: 20px; }
.menu__link { color: #fff; text-decoration: none; transition: color .3s ease-out; }
.menu__link:hover { color: #ffcc00; }
.btn { display: inline-block; padding: 12px 24px; border-radius: 4px; background-color: #0080cd; color: #fff; text-decoration: none; transition: background-color .3s ease, transform .3s ease; }
.btn:hover, .btn:focus { background-color: #e73a3a; }
.btn--grow:hover, .btn--grow:focus { transform: scale(1.1); }
.hero { padding: 48px 32px; }
.hero__title { margin: 0 0 16px; font-size: 40px; }
.hero__lead { margin: 0 0 24px; font-size: 18px; }
.inline { color: #0080cd; transition: color .3s ease; }
.inline:hover { color: #e73a3a; }
.band { position: relative; padding: 64px 32px; background: #00408a; }
.band::after { content: ""; position: absolute; inset: 0; pointer-events: none; background-image: linear-gradient(-120deg, #004774 0%, #0080cd 25%, #00408a 50%, #000d5a 90%, #004774 100%); background-size: 200% 200%; animation: shimmer 8s linear infinite; }
.band__title { position: relative; z-index: 1; margin: 0 0 0 40%; color: #fff; font-size: 32px; }
.cards { display: flex; gap: 24px; align-items: center; padding: 48px 32px; }
.card { flex: 1 1 0; padding: 24px; background: #fff; box-shadow: 0 0 0 0 rgba(0, 0, 0, 0); transition: box-shadow .3s ease; }
.card:hover { box-shadow: 1px 2px 34px 19px rgba(0, 0, 0, .5); }
.card__title { margin: 0 0 8px; }
.card__text { margin: 0; }
.dot { flex: none; width: 24px; height: 24px; border-radius: 50%; background: #e73a3a; animation: beat .7s ease infinite alternate; }
.flips { padding: 48px 32px; }
.flip { position: relative; width: 320px; height: 200px; perspective: 1000px; }
.flip__front, .flip__back { position: absolute; inset: 0; padding: 24px; backface-visibility: hidden; transform-style: preserve-3d; transition: transform .6s ease-in-out; }
.flip__front { background: #0b2545; color: #fff; }
.flip__back { background: #e73a3a; color: #fff; transform: rotateY(180deg); }
.flip:hover .flip__front, .flip:focus-within .flip__front { transform: rotateY(-180deg); }
.flip:hover .flip__back, .flip:focus-within .flip__back { transform: none; }
.flip__title { margin: 0; }
.flip__text { margin: 0 0 12px; }
.flip__link { color: #fff; }
.flip__link:focus-visible { outline: 3px solid #ffcc00; outline-offset: 2px; }
.spacer { height: 1600px; }
.enter { padding: 48px 32px; background: #f2f5f9; }
.enter__title { margin: 0 0 12px; }
.enter__text { margin: 0; }
.is-hidden { visibility: hidden; }
.animated { animation-duration: 1.25s; animation-fill-mode: both; }
.enter--late.animated { animation-delay: .3s; }
.fadeInUp { animation-name: fadeInUp; }
.fadeInLeft { animation-name: fadeInLeft; }
.fadeIn { animation-name: fadeIn; }
.foot { padding: 32px; background: #0b2545; color: #fff; }
.foot__text { margin: 0; }
.foot__link { color: #fff; }
@keyframes shimmer { 0% { background-position: 100% 100%; } 50% { background-position: 0% 0%; } 100% { background-position: 100% 100%; } }
@keyframes beat { from { transform: scale(1); } to { transform: scale(1.1); } }
@keyframes wiggle { 0%, 100% { transform: rotate(0deg); } 50% { transform: rotate(3deg); } }
@keyframes fadeInUp { from { opacity: 0; transform: translate3d(0, 100%, 0); } to { opacity: 1; transform: none; } }
@keyframes fadeInLeft { from { opacity: 0; transform: translate3d(-100%, 0, 0); } to { opacity: 1; transform: none; } }
@keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
@keyframes unused { from { opacity: 0; } to { opacity: 1; } }
@media (max-width: 767px) {
  .bar__glow { flex-direction: column; align-items: flex-start; }
  .cards { flex-direction: column; align-items: stretch; }
  .flip { width: 100%; }
  .fadeInLeft { animation-name: fadeIn; }
}
```

`enter.js` (a page builder's entrance, as builders make one; nothing here is any builder's code):

```js
// A box waits hidden (is-hidden) until it comes into view, then its animation's classes (animated + the name in
// data-enter) play it once
(function () {
  var io = new IntersectionObserver(function (entries) {
    entries.forEach(function (e) {
      if (!e.isIntersecting) return;
      io.unobserve(e.target);
      e.target.classList.remove("is-hidden");
      e.target.classList.add("animated", e.target.getAttribute("data-enter"));
    });
  });
  document.querySelectorAll("[data-enter]").forEach(function (el) { io.observe(el); });
})();
```

Check before committing: served by `serveFixture("site-motion")` it loads in Chrome at 1440 and 390 with no console
error, the entrances end visible after scrolling through, and `captureSite` (code on) finishes with no error (one
probe run, its log in the ledger). Commit: `site-motion task 1: the generic motion fixture (shimmer, beat, entrances,
hovers, focus, a flip box)`.

### Task 2: Capture format version 3 (types)

`src/core/snapshot/web.ts`, after `CodeNode`'s `scripted` field add `states?: CodeStateLook[];`; change `WebCode` to
`version: 1 | 2 | 3` with three optional fields; add the types:

```ts
// version 3 (site-motion): a state a look changes under, as the site's CSS names it
export type CodeState = "hover" | "focus" | "focus-visible" | "focus-within";
// a look a state gives an element, read at web.code.statesAt's range only: trigger "" the element itself (for a part, its
// host; for an inline element, itself), else the path of the ancestor whose state sets it; part "" the element,
// "::before", "::after" or an inline element's index path ("1", "1/0"); decls only what the state changes, as declared
// (var() resolved in the state, shorthands expanded)
export interface CodeStateLook { state: CodeState; trigger: string; part: string; decls: CodeDecls }
// an @keyframes the code names, as written (each keyframe's selector text and declarations, var() resolved), read in the
// widest range naming it; differs: narrower ranges whose rule of that name reads otherwise (a media query's)
export interface CodeKeyframes { frames: Array<{ at: string; decls: CodeDecls }>; range: string; differs?: string[] }
```

```ts
export interface WebCode {
  version: 1 | 2 | 3; rootFontSize: Record<string, number>; ranges: string[]; context: CodeByRange; nodes: Record<string, CodeNode>;
  capped?: Array<{ path: string; name: string; length: number }>;   // amendment 1: markers left out for their size
  keyframes?: Record<string, CodeKeyframes>;   // version 3: by the site's name
  statesAt?: string;                           // version 3: the range the state looks were read at (the design width's)
  unplacedStates?: number;                     // version 3: looks a state sets through another element, not kept
}
```

Typecheck only (no behaviour). Commit with Task 3.

### Task 3: The capture keeps the keyframes (AC1)

RED: `test/web/capture-motion.test.ts` (its `before` captures the fixture once; AC2's test joins it in Task 4):

```ts
// AC1, AC2 (site-motion): a version 3 capture keeps every @keyframes the page's code names and, at the design width,
// each element's hover and focus looks with the element whose state sets them
import { after, before, test } from "node:test";
import assert from "node:assert/strict";
import type { Snapshot } from "../../src/core/snapshot/schema.ts";
import type { CodeStateLook, WebCode } from "../../src/core/snapshot/web.ts";
import { captureSite } from "../../src/web/capture.ts";
import { pathOf } from "../../src/web/read/page-reader.ts";
import { hasChrome, launchChrome, type Browser } from "../browser/chrome.ts";
import { standIn } from "../fixtures/web/capture.ts";
import { serveFixture, type Fixture } from "../fixtures/web/serve.ts";

const skip = hasChrome() ? false : "Google Chrome not installed (set CHROME_PATH)";
const IDS = ["logo", "about", "work", "call", "lead", "go", "band", "card1", "card2", "dot", "flip", "front", "back", "more", "enter", "enter-title", "late"];
let browser: Browser, fx: Fixture, snap: Snapshot, plain: Snapshot;
let paths: Record<string, string>;
before(async () => {
  if (skip) return;
  browser = await launchChrome();
  fx = await serveFixture("site-motion");
  const page = await browser.newPage();
  await page.setViewport(1440, 900);
  await page.goto(fx.site + "/");
  paths = await page.evaluate(`(() => { const pathOf = ${pathOf.toString()}; return Object.fromEntries(${JSON.stringify(IDS)}.map((i) => [i, pathOf(document.getElementById(i))])); })()`);
  await page.close();
  snap = await captureSite({ url: fx.site + "/", fontSource: standIn(fx), browser, shots: false });
  plain = await captureSite({ url: fx.site + "/", fontSource: standIn(fx), browser, shots: false, code: false });
});
after(async () => { if (fx) await fx.close(); if (browser) await browser.close(); });
const code = (): WebCode => snap.web!.code!;

test("AC1 keeps every @keyframes the page's elements, their ::after and their hover looks name", { skip }, () => {
  assert.equal(code().version, 3);
  const k = code().keyframes ?? {};
  assert.deepEqual(Object.keys(k).sort(), ["appear", "beat", "fadeIn", "fadeInLeft", "fadeInUp", "fadeUp", "shimmer", "wiggle"]); // amendment 3
  assert.deepEqual(k.shimmer.frames, [
    { at: "0%", decls: { "background-position": "100% 100%" } },
    { at: "50%", decls: { "background-position": "0% 0%" } },
    { at: "100%", decls: { "background-position": "100% 100%" } },
  ]);
  assert.deepEqual(k.beat.frames.map((f) => f.at), ["from", "to"]);
  assert.deepEqual(k.wiggle.frames.map((f) => f.at), ["0%, 100%", "50%"]);
  assert.equal(k.shimmer.range, code().ranges[0]);
  assert.equal(k.fadeIn.range, code().ranges[0]);
});
```

On the base it fails at `version` (2). Then:

`src/web/read/code-keyframes.ts`:

```ts
// The @keyframes a captured element names (site-motion, Discovery 3): DevTools answers them with an element's matched
// styles (cssKeyframesRules: the rule in effect at this width, as written); a ::before/::after animation's come only
// with the pseudo element's own node. Each keyframe's written declarations, as code.ts reads a rule's.
import type { Page } from "../../../test/browser/chrome.ts";
import type { CssProperty } from "../cdp.ts";

export interface KeyframesRule { animationName: { text: string }; keyframes: Array<{ keyText: { text: string }; style: { cssProperties: CssProperty[] } }> }
export type Frames = Array<{ at: string; decls: Array<{ name: string; value: string }> }>;

export function framesOf(rule: KeyframesRule): Frames {
  return rule.keyframes.map((k) => ({
    at: k.keyText.text.trim(),
    decls: k.style.cssProperties
      .filter((p) => (p as CssProperty & { range?: unknown }).range && !p.disabled && p.parsedOk !== false && !p.name.startsWith("--") && p.value.trim() !== "")
      .map((p) => ({ name: p.name, value: p.value.replace(/\s*!important\s*$/i, "").trim() })),
  }));
}

// the names an animation-name value lists (top-level commas; none and the CSS-wide keywords aren't names)
const KEYWORDS = new Set(["none", "initial", "inherit", "unset", "revert", "revert-layer"]);
export const animationNames = (v: string | undefined): string[] => (v ?? "").split(",").map((s) => s.trim()).filter((s) => s && !KEYWORDS.has(s.toLowerCase()));

// the node id of an element's ::before or ::after (0: it has none)
export async function pseudoNodeId(page: Page, nodeId: number, kind: "before" | "after"): Promise<number> {
  const d = await page.cdp<{ node: { pseudoElements?: Array<{ pseudoType: string; backendNodeId: number }> } }>("DOM.describeNode", { nodeId, depth: 1 }).catch(() => null);
  const p = d?.node.pseudoElements?.find((x) => x.pseudoType === kind);
  if (!p) return 0;
  const pushed = await page.cdp<{ nodeIds: number[] }>("DOM.pushNodesByBackendIdsToFrontend", { backendNodeIds: [p.backendNodeId] }).catch(() => null);
  return pushed?.nodeIds[0] ?? 0;
}
```

`src/web/read/code.ts` (`readCode`): (a) `CodeReading` gains `keyframes?: Record<string, Array<{ at: string; decls: Decls }>>`;
(b) in the element loop keep each response's keyframes: `const kfAt = new Map<number, KeyframesRule[]>()`, `kfAt.set(at,
(m.cssKeyframesRules ?? []) as KeyframesRule[])` after `matchedStyles(…ids[at])`, and the same for each inline element's
`im`; (c) after the url() step (before `delete window[…]`), the keyframes every target's final declarations name:

```ts
  // @keyframes (site-motion): every name a target's final animation-name lists, as the rule in effect here writes it;
  // a ::before/::after's from its own node; values var()-resolved with that target's custom properties
  const keyframes: Record<string, Array<{ at: string; decls: Decls }>> = {};
  for (const t of targets) {
    const names = animationNames(t.out["animation-name"]).filter((n) => !keyframes[n]);
    if (!names.length) continue;
    let rules = t.pseudo === "" ? kfAt.get(t.at) ?? [] : [];
    if (t.pseudo !== "") {
      const id = await pseudoNodeId(s.page, ids[t.at], t.pseudo === "::before" ? "before" : "after");
      rules = id ? (((await matchedStyles(s.page, id))?.cssKeyframesRules ?? []) as KeyframesRule[]) : [];
    }
    for (const r of rules) {
      const name = r.animationName.text.trim();
      if (!names.includes(name) || keyframes[name]) continue;
      const frames = framesOf(r);
      const want = [...new Set(frames.flatMap((f) => f.decls.flatMap((d) => [...d.value.matchAll(/var\(\s*(--[\w-]+)/g)].map((v) => v[1]))))];
      const props = want.length ? (await s.run<{ vars: Array<Record<string, string>> }>(codeAsks, [{ vars: [[t.at, t.pseudo, want]], props: [] }])).vars[0] : {};
      keyframes[name] = frames.map((f) => ({ at: f.at, decls: Object.fromEntries(f.decls.map((d) => [d.name, resolveVar(d.value, props)]).filter((e): e is [string, string] => e[1] !== null)) }));
    }
  }
```

and return `...(Object.keys(keyframes).length ? { keyframes } : {})`. (Each `t` there is a `Target`, whose `at`/`pseudo`
the loop already sets; inline targets carry their `inlineAt` index as `at` with pseudo `""`, so `kfAt` holds theirs.)

`src/web/code.ts` `assembleCode`: `version: 3` and, after the nodes:

```ts
  // @keyframes by name, from the widest range naming each (site-motion); a narrower range reading another rule of that
  // name is listed
  const keyframes: Record<string, CodeKeyframes> = {};
  rangeIds.forEach((r, i) => {
    for (const [name, frames] of Object.entries(list[i].keyframes ?? {})) {
      const had = keyframes[name];
      if (!had) keyframes[name] = { frames, range: r };
      else if (JSON.stringify(had.frames) !== JSON.stringify(frames)) (had.differs ??= []).push(r);
    }
  });
```

returning `...(Object.keys(keyframes).length ? { keyframes } : {})` beside `capped`. Update the three version pins
(Discovery 9) to 3 and nothing else in them. GREEN: AC1; `capture-code.test.ts` and `capture-code-page.test.ts` pass
(file by file). Commit: `site-motion task 3: the capture keeps every @keyframes the page's code names (AC1)`.

### Task 4: The capture keeps the hover and focus looks (AC2)

RED: add to `capture-motion.test.ts`:

```ts
const looks = (id: string): CodeStateLook[] => code().nodes[paths[id]]?.states ?? [];
const one = (id: string, state: string, part = ""): CodeStateLook | undefined => looks(id).find((l) => l.state === state && l.part === part);
test("AC2 reads hover and focus looks at the design width, with their trigger", { skip }, () => {
  const W = snap.web!.ranges.find((r) => 1440 >= r.min && (r.max === null || 1440 <= r.max))!.id;
  assert.equal(code().statesAt, W);
  for (const s of ["hover", "focus"]) assert.deepEqual(one("go", s), { state: s, trigger: "", part: "", decls: { "background-color": "#e73a3a" } });
  assert.deepEqual(one("call", "hover")?.decls, { "background-color": "#e73a3a", transform: "scale(1.1)" });
  assert.deepEqual(one("about", "hover")?.decls, { color: "#ffcc00" });
  assert.deepEqual(one("lead", "hover", "0")?.decls, { color: "#e73a3a" });
  for (const c of ["card1", "card2"]) assert.match(one(c, "hover")?.decls["box-shadow"] ?? "", /34px 19px/);
  for (const s of ["hover", "focus-within"]) {
    assert.deepEqual(one("front", s), { state: s, trigger: paths.flip, part: "", decls: { transform: "rotateY(-180deg)" } });
    assert.deepEqual(one("back", s), { state: s, trigger: paths.flip, part: "", decls: { transform: "none" } });
  }
  // a shorthand comes as the browser expands it (CSSOM writes its colour as rgb())
  assert.deepEqual(one("more", "focus-visible")?.decls, { "outline-color": "rgb(255, 204, 0)", "outline-style": "solid", "outline-width": "3px", "outline-offset": "2px" });
  assert.equal(one("logo", "hover")?.decls["animation-name"], "wiggle");
  const withLooks = Object.entries(code().nodes).filter(([, n]) => n.states?.length).map(([p]) => p).sort();
  assert.deepEqual(withLooks, ["logo", "about", "work", "call", "lead", "go", "card1", "card2", "front", "back", "more"].map((i) => paths[i]).sort());
  // the rest look at the design width is the rest look, and nothing else of the capture changed (nothing left hovered):
  // snap against plain exactly as capture-code.test.ts's "no other field of the capture changes" test compares them
  assert.equal((code().nodes[paths.go].decls[code().ranges[0]] as Record<string, string>)["background-color"], "#0080cd");
  const strip = (s: Snapshot) => ({ ...s, web: { ...s.web!, code: undefined, timings: undefined, capturedAt: undefined } });
  assert.deepEqual(strip(snap), strip(plain));
});
```

Then `src/web/read/code-states.ts`:

```ts
// site-motion (Q2 A, Q3 A, Discovery 4): what the page's elements look like under a state, read at one width (the design
// width's range). Every element, its ::before/::after and its words' inline elements are read again with a state forced
// on every element at once (CSS.forcePseudoState: hover; then focus, focus-visible and focus-within, as a keyboard's focus
// gives them), and a declaration is the state's when it wins the cascade, longhand by longhand, from a rule the target
// didn't match at rest. Which element's state sets it is found with no state forced (a forced state answers
// Element.matches() too): the rule's matching selector with each state written as a mark, marked on the target and its
// ancestors from the target up, as far as the selector still matches (`.card:hover .title`: the card; `.btn:hover`: the
// button). A look set through another element (`:has(:hover)`, a neighbour's state) has no such element and is counted.
import type { CodeState, CodeStateLook } from "../../core/snapshot/web.ts";
import { matchedStyles, type CssProperty } from "../cdp.ts";
import { resolveVar } from "../map/stretchy.ts";
import type { Session } from "../session.ts";
import { expandAll } from "./code-expand.ts";
import { codeAsks } from "./code-facts.ts";
import type { KeyframesRule } from "./code-keyframes.ts";
import { pathOf } from "./page-reader.ts";

export const PASSES: CodeState[][] = [["hover"], ["focus", "focus-visible", "focus-within"]];
// the first state a selector names (`:focus` never inside `:focus-visible`)
export const stateIn = (selector: string): CodeState | null => (/:(hover|focus-visible|focus-within|focus)(?![\w-])/.exec(selector)?.[1] as CodeState | undefined) ?? null;

type Style = { cssProperties: CssProperty[]; range?: unknown };
export type StateRule = { rule: { origin: string; styleSheetId?: string; selectorList?: { text: string; selectors?: Array<{ text: string }> }; style: Style }; matchingSelectors?: number[] };
type Matched = { matchedCSSRules?: StateRule[]; attributesStyle?: Style; inlineStyle?: Style; pseudoElements?: Array<{ pseudoType: string; matches: StateRule[] }>; cssKeyframesRules?: KeyframesRule[] };
// a rule as the same rule in another answer: its sheet and its place in it
export const ruleKey = (r: StateRule): string => `${r.rule.styleSheetId ?? ""}\u0000${JSON.stringify(r.rule.style.range ?? r.rule.selectorList?.text ?? "")}`;
export const rulesOf = (m: Matched | null, pseudo: string): StateRule[] => ((pseudo === "" ? m?.matchedCSSRules : m?.pseudoElements?.find((p) => "::" + p.pseudoType === pseudo)?.matches) ?? []).filter((r) => r.rule.origin === "regular");

// one thing read: an element (pseudo ""), its ::before/::after, or an inline element of its words (at: its index in
// window[Symbol.for("f2b.code")]); path: the element's path; part: "" | "::before" | "::after" | the inline element's
// index path; rest: the keys of the rules it matched at rest (code.ts)
export interface StateTarget { at: number; pseudo: "" | "::before" | "::after"; path: string; part: string; rest: Set<string> }
export interface StatesReading { looks: Record<string, CodeStateLook[]>; keyframes: KeyframesRule[]; unplaced: number }

type Item = { name: string; value: string; important: boolean; key: string; selectors: string[] };
const written = (s: Style | undefined): CssProperty[] => {
  const all = s?.cssProperties ?? [];
  const w = all.filter((p) => (p as CssProperty & { range?: unknown }).range);
  return (w.length ? w : all).filter((p) => !p.disabled && p.parsedOk !== false && !p.name.startsWith("--") && p.value.trim() !== "");
};
const itemsOf = (s: Style | undefined, key: string, selectors: string[]): Item[] =>
  written(s).map((p) => ({ name: p.name, value: p.value.replace(/\s*!important\s*$/i, "").trim(), important: !!p.important || /!important\s*$/i.test(p.value), key, selectors }));

export async function readStates(s: Session, ids: number[], targets: StateTarget[], own: (r: StateRule) => boolean, known: ReadonlySet<string>): Promise<StatesReading> {
  const looks: Record<string, CodeStateLook[]> = {};
  const keyframes: KeyframesRule[] = [];
  let unplaced = 0;
  const live = [...new Set(targets.map((t) => ids[t.at]).filter((id) => id > 0))];
  const force = async (classes: string[]) => { for (const id of live) await s.page.cdp("CSS.forcePseudoState", { nodeId: id, forcedPseudoClasses: classes }).catch(() => undefined); };
  for (const pass of PASSES) {
    // under the state: each target's declarations with their rules, var() resolved and every shorthand expanded
    type Won = { t: StateTarget; name: string; value: string; selectors: string[] };
    const won: Won[] = [];
    await force(pass);
    try {
      const answers = new Map<number, Matched | null>();
      const found: Array<{ t: StateTarget; items: Item[] }> = [];
      for (const t of targets) {
        if (!answers.has(t.at)) answers.set(t.at, (await matchedStyles(s.page, ids[t.at])) as Matched | null);
        const m = answers.get(t.at)!;
        if (!m) continue;
        if (t.pseudo === "") keyframes.push(...(m.cssKeyframesRules ?? []));
        const rules = rulesOf(m, t.pseudo).filter((r) => !own(r));
        if (!rules.some((r) => !t.rest.has(ruleKey(r)))) continue;
        found.push({ t, items: [
          ...(t.pseudo === "" ? itemsOf(m.attributesStyle, "attrs", []) : []),
          ...rules.flatMap((r) => itemsOf(r.rule.style, ruleKey(r), (r.matchingSelectors ?? []).map((i) => r.rule.selectorList?.selectors?.[i]?.text ?? ""))),
          ...(t.pseudo === "" ? itemsOf(m.inlineStyle, "inline", []) : []),
        ] });
      }
      const asks: Array<[number, string, string[]]> = found.map((f) => [f.t.at, f.t.pseudo, [...new Set(f.items.flatMap((d) => [...d.value.matchAll(/var\(\s*(--[\w-]+)/g)].map((v) => v[1])))]]);
      const props: Array<Record<string, string>> = [];
      for (let k = 0; k < asks.length; k += 300) props.push(...(await s.run<{ vars: Array<Record<string, string>> }>(codeAsks, [{ vars: asks.slice(k, k + 300), props: [] }])).vars);
      const resolved = found.map((f, i) => f.items.map((d) => ({ ...d, value: resolveVar(d.value, props[i] ?? {}) })).filter((d): d is Item => d.value !== null));
      const pairs = [...new Map(resolved.flat().map((d) => [`${d.name}\u0000${d.value}`, [d.name, d.value] as [string, string]])).values()];
      const longhands = new Map<string, Record<string, string>>();
      for (let k = 0; k < pairs.length; k += 300) (await s.run<Array<Record<string, string>>>(expandAll, [pairs.slice(k, k + 300)])).forEach((g, j) => longhands.set(`${pairs[k + j][0]}\u0000${pairs[k + j][1]}`, g));
      found.forEach((f, i) => {
        // the cascade, longhand by longhand (normal declarations in order, then !important ones)
        const win = new Map<string, Item>();
        const list = resolved[i];
        for (const d of [...list.filter((x) => !x.important), ...list.filter((x) => x.important)]) {
          const lh = longhands.get(`${d.name}\u0000${d.value}`);
          for (const [k, v] of Object.entries(lh && Object.keys(lh).length ? lh : { [d.name]: d.value })) win.set(k, { ...d, name: k, value: v });
        }
        for (const d of win.values()) if (!f.t.rest.has(d.key) && d.key !== "attrs" && d.key !== "inline") won.push({ t: f.t, name: d.name, value: d.value, selectors: d.selectors });
      });
    } finally {
      await force([]);
    }
    // which element's state sets each, with no state forced
    const asked = new Map<string, number>();
    const pairs: Array<[number, string]> = [];
    const ask = (at: number, sel: string) => { const k = `${at}\u0000${sel}`; if (!asked.has(k)) { asked.set(k, pairs.length); pairs.push([at, sel]); } return asked.get(k)!; };
    const todo = won.map((w) => { const sel = w.selectors.find((x) => { const st = stateIn(x); return st !== null && pass.includes(st); }); return sel ? { w, sel, i: ask(w.t.at, sel) } : null; });
    const answers: Array<{ self: boolean; path: string | null } | null> = [];
    for (let k = 0; k < pairs.length; k += 300) answers.push(...(await s.run<Array<{ self: boolean; path: string | null } | null>>(triggersOf, [pairs.slice(k, k + 300)], { pathOf })));
    const lost = new Set<string>();
    for (const x of todo) {
      if (!x) { unplaced++; continue; }
      const a = answers[x.i];
      const trigger = !a ? null : a.self ? "" : a.path;
      if (trigger === null || (trigger !== "" && !known.has(trigger))) { const k = `${x.w.t.at}\u0000${x.sel}`; if (!lost.has(k)) { lost.add(k); unplaced++; } continue; }
      const state = stateIn(x.sel)!;
      const list = (looks[x.w.t.path] ??= []);
      let look = list.find((l) => l.state === state && l.trigger === trigger && l.part === x.w.t.part);
      if (!look) list.push((look = { state, trigger, part: x.w.t.part, decls: {} }));
      look.decls[x.w.name] = x.w.value;
    }
  }
  return { looks, keyframes, unplaced };
}

// In the page: for each [target index, matching selector], the element whose state the selector names: marked (with
// its ancestors) from the target up, the highest one at which the selector, its states written as the mark, still
// matches; self when that is the target. Pseudo elements are left off the selector (matches() takes none). null: no
// such element (a look set through another element). Self-contained; pathOf given as a helper.
export function triggersOf(pairs: Array<[number, string]>, helpers: { pathOf: (el: Element) => string | null }): Array<{ self: boolean; path: string | null } | null> {
  const els = (window as unknown as Record<symbol, Element[]>)[Symbol.for("f2b.code")] ?? [];
  const MARK = "data-f2b-state";
  const clear = () => { for (const e of document.querySelectorAll(`[${MARK}]`)) e.removeAttribute(MARK); };
  return pairs.map(([at, selector]) => {
    const d = els[at];
    if (!d) return null;
    const plain = selector.replace(/:(hover|focus-visible|focus-within|focus)(?![\w-])/g, `[${MARK}]`).replace(/::?(before|after)\s*$/i, "");
    let found: Element | null = null;
    try {
      for (let t: Element | null = d; t && t !== document.documentElement; t = t.parentElement) {
        clear();
        for (let u: Element | null = t; u; u = u.parentElement) u.setAttribute(MARK, "");
        if (!d.matches(plain)) break;
        found = t;
      }
    } catch { found = null; } finally { clear(); }
    return found ? { self: found === d, path: found === d ? null : helpers.pathOf(found) } : null;
  });
}
```

`src/web/read/code.ts`: `Target` gains `path: string; part: string; rest: Set<string>` (set at each `targets.push`:
the element's `f.path`, part `""` / `"::before"` / `"::after"` / `inline[k]`, and `new Set((rules).map(ruleKey))` of the
regular rules it matched, the capture's own included); `readCode(s, rangeId, opts: { servedStyle?: boolean; states?:
boolean })`; before `delete window[…]`:

```ts
  // site-motion: the looks a state gives (Q2 A: only where asked, the design width's range)
  let states: StatesReading | null = null;
  if (opts.states) {
    states = await readStates(s, ids, targets.map((t) => ({ at: t.at, pseudo: t.pseudo as "" | "::before" | "::after", path: t.path, part: t.part, rest: t.rest })), own.is as (r: StateRule) => boolean, new Set(read.facts.filter((f) => f.at >= 0).map((f) => f.path)));
    for (const [path, list] of Object.entries(states.looks)) if (nodes[path]) nodes[path].states = list;
    // the keyframes the looks name (a hover's animation), as the forced answers gave them
    for (const r of states.keyframes) {
      const name = r.animationName.text.trim();
      if (keyframes[name] || !Object.values(states.looks).some((l) => l.some((x) => animationNames(x.decls["animation-name"]).includes(name)))) continue;
      keyframes[name] = framesOf(r).map((f) => ({ at: f.at, decls: Object.fromEntries(f.decls.map((d) => [d.name, d.value])) }));
    }
  }
```

(`own.see` must have seen every rule of the forced answers: call it in `readStates` for each answer's rules before
`own(r)`, or pass `own.see` in and await it; the capture's own sheets are the same sheets at rest and under a state.)
`CodeReadingNode` gains `states?: CodeStateLook[]`; `CodeReading` gains `states?: true; unplacedStates?: number` (set
when `opts.states`). `src/web/code.ts` `assembleCode`: `node.states = <the reading with states>.nodes[path].states` when
present; `statesAt` the range id of that reading; `unplacedStates` its count when non-zero. `src/web/capture.ts`: `await
readCode(s, r.id, { servedStyle: …, states: r === wRange })`, `timings["states " + r.id]` around the states pass (or
inside readCode's result), and when `unplacedStates` is non-zero `rnote(\`${n} hover or focus look${n === 1 ? "" : "s"}
a state sets through another element (:has(), a neighbour's state) ${n === 1 ? "isn't" : "aren't"} kept\`)`.
`docs/specs/web-capture.md` "The site's own code": version 3's fields. GREEN: AC2, AC1; `capture-code.test.ts`,
`capture-code-page.test.ts`, `tracker-style.test.ts`, `capture-hidden-parts.test.ts` pass. Commit: `site-motion task 4:
the capture keeps each element's hover and focus looks with their trigger at the design width (AC2)`.

### Task 5: Hand-made version 3 code for the converter's tests

`test/fixtures/site-motion-code.ts`:

```ts
// A hand-made version 3 capture (site-motion) built on site-code.ts's page: S1's photo box draws a shimmering ::after,
// its widget box lifts its shadow on hover and holds a paragraph whose inline element changes colour, S2's heading
// rises into view (a finite animation, 1.25 s), its paragraph fades in at phones; keyframes as a capture keeps them.
import type { Snapshot } from "../../src/core/snapshot/schema.ts";
import type { CodeKeyframes, CodeStateLook } from "../../src/core/snapshot/web.ts";
import { code, PATHS, RANGES, S1, S2 } from "./site-code.ts";

export const SHIMMER: CodeKeyframes = { range: RANGES[0], frames: [
  { at: "0%", decls: { "background-position": "100% 100%" } }, { at: "50%", decls: { "background-position": "0% 0%" } }, { at: "100%", decls: { "background-position": "100% 100%" } }] };
export const RISE: CodeKeyframes = { range: RANGES[0], frames: [{ at: "from", decls: { opacity: "0", transform: "translate3d(0, 2rem, 0)" } }, { at: "to", decls: { opacity: "1", transform: "none" } }] };
export const FADE: CodeKeyframes = { range: RANGES[0], frames: [{ at: "from", decls: { opacity: "0" } }, { at: "to", decls: { opacity: "1" } }] };

export function motionCode(over: { keyframes?: Record<string, CodeKeyframes>; states?: Record<string, CodeStateLook[]>; version?: 1 | 2 | 3 } = {}): Snapshot {
  const shimmer = { "content": '""', position: "absolute", "animation-name": "shimmerGradient", "animation-duration": "8s", "animation-iteration-count": "infinite", "animation-timing-function": "linear", "background-size": "200% 200%" };
  const s = code({
    decls: {
      [PATHS.PHOTO]: { [RANGES[0]]: { position: "relative", "min-height": "200px" } },
      [PATHS.WIDGET]: { [RANGES[0]]: { "background-color": "#ffffff", "box-shadow": "none", "transition-property": "box-shadow", "transition-duration": "0.3s" } },
      [PATHS.H2]: { [RANGES[0]]: { "animation-name": "rise", "animation-duration": "1.25s", "animation-fill-mode": "both" } },
      [PATHS.LEAD]: { [RANGES[0]]: {}, [RANGES[2]]: { "animation-name": "fade", "animation-duration": "1.25s" } },
    },
    patch: { [PATHS.PHOTO]: { pseudo: { after: { [RANGES[0]]: shimmer } } } },
  });
  const c = s.web!.code!;
  c.version = over.version ?? 3;
  c.keyframes = over.keyframes ?? { shimmerGradient: SHIMMER, rise: RISE, fade: FADE };
  c.statesAt = RANGES[0];
  const looks = over.states ?? {
    [PATHS.WIDGET]: [{ state: "hover", trigger: "", part: "", decls: { "box-shadow": "1px 2px 34px 19px rgba(0, 0, 0, 0.5)", "background-color": "#f2f5f9" } }],
    [PATHS.P1]: [{ state: "hover", trigger: PATHS.WIDGET, part: "", decls: { color: "#e73a3a" } }],
    [PATHS.LEAD]: [{ state: "hover", trigger: "", part: "0", decls: { color: "#e73a3a" } }, { state: "focus", trigger: "", part: "0", decls: { color: "#e73a3a" } }],
  };
  for (const [p, l] of Object.entries(looks)) c.nodes[p] = { ...c.nodes[p], states: l };
  return s;
}
export { S1, S2, PATHS, RANGES };
```

(`PATHS.LEAD` holds `<strong>` as its inline element `0`.) Commit with Task 6.

### Task 6: Keyframes, renaming and endless animations in the paste (AC3, unit)

RED: `test/unit/site-motion.test.ts`:

```ts
// AC3–AC7, AC12 (site-motion), the converter on hand-made version 3 code (test/fixtures/site-motion-code.ts)
import { test } from "node:test";
import assert from "node:assert/strict";
import { settingsOf, type Settings } from "../../src/core/emit/payload.ts";
import { siteToBricks } from "../../src/core/site/convert.ts";
import { siteParts } from "../../src/core/site/parts.ts";
import { motionCode, PATHS, S1, S2, FADE } from "../fixtures/site-motion-code.ts";

// the element's own class (its last), with its settings as an object
const classOf = (r: ReturnType<typeof siteToBricks>, path: string): { name: string; settings: Settings } => {
  const id = Object.entries(r.sources).find(([, p]) => p === path)![0];
  const el = r.payload.content.find((e) => e.id === id)!;
  const g = (settingsOf(el)._cssGlobalClasses as string[]).map((c) => r.payload.globalClasses!.find((x) => x.id === c)!).at(-1)!;
  return { name: g.name, settings: settingsOf(g) };
};
const css = (r: ReturnType<typeof siteToBricks>, path: string): string => String(classOf(r, path).settings._cssCustom ?? "");

test("AC3 a named animation's @keyframes go with the class that uses it, under the page's name", () => {
  const r = siteToBricks(motionCode(), { section: { path: S1 } });
  const photo = css(r, PATHS.PHOTO);
  const name = /@keyframes (home__shimmer-gradient-[a-z]{4}) \{/.exec(photo)?.[1];
  assert.ok(name, photo);
  assert.match(photo, new RegExp(`::after \\{[^}]*animation-name: ${name};`));
  assert.ok(photo.includes(`@keyframes ${name} { 0% { background-position: 100% 100%; } 50% { background-position: 0% 0%; } 100% { background-position: 100% 100%; } }`));
  assert.doesNotMatch(photo, /shimmerGradient/);
  // other frames, another name; the same frames at another page, another name
  const other = siteToBricks(motionCode({ keyframes: { shimmerGradient: { ...FADE }, rise: FADE, fade: FADE } }), { section: { path: S1 } });
  assert.notEqual(/@keyframes (\S+)/.exec(css(other, PATHS.PHOTO))?.[1], name);
  // rem in a frame goes out in px of its range's root size
  const s2 = siteToBricks(motionCode(), { section: { path: S2 } });
  assert.match(css(s2, PATHS.H2), /@keyframes home__rise-[a-z]{4} \{ from \{ opacity: 0; transform: translate3d\(0, 32px, 0\); \}/);
});
```

On the base it fails (`motionCode` builds, `siteToBricks` writes no `@keyframes`). Then `src/core/site/motion.ts`:

```ts
// A captured site's motion in its code-method paste (site-motion), for a version 3 capture only (an older one pastes as
// before, with OLD_NOTE: Q6 A): every @keyframes a class's rules name goes in that class's custom CSS, named after the
// page and its frames (<page>__<kebab name>-abcd, classes.ts versioned: two pages, or two captures of other frames, never
// share a name), the class's animation-name renamed; an element's own finite animation is an entrance (Q1 A): Bricks'
// Interaction "Enter viewport → Start animation", once, plays it when the element comes into view, its frames and timing
// bound to the class Bricks adds while it plays (.c.brx-animate-<type>), so it no longer plays by the clock on load;
// endless ones play from load (Discovery 5).
import { shortId } from "../emit/ids.ts";
import type { CodeDecls, WebCode } from "../snapshot/web.ts";
import { versioned, type ClassCss } from "./classes.ts";
import type { Settings } from "./controls.ts";
import { parse, serialize, toPx } from "./value.ts";

export const OLD_NOTE = "this capture predates hovers and animations (made before this build): nothing changes under the pointer and its animations stay still; capture the page again with this build";
export const entranceNote = (n: number): string => `${n} element${n === 1 ? " plays its entrance as it comes" : "s play their entrance as they come"} into view (Bricks Interactions: Enter viewport → Start animation, once)`;

const KEYWORDS = new Set(["none", "initial", "inherit", "unset", "revert", "revert-layer"]);
export const namesIn = (v: string | undefined | null): string[] => (v ?? "").split(",").map((s) => s.trim()).filter((s) => s && !KEYWORDS.has(s.toLowerCase()));
const kebab = (s: string): string => s.replace(/([a-z0-9])([A-Z])/g, "$1-$2").toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(/^-+/, "").slice(0, 24).replace(/-+$/, "");

// names: the site's name → the paste's; text: the paste's name → its @keyframes
export interface Motion { names: Map<string, string>; text: Map<string, string> }
export function motionOf(code: WebCode, page: string): Motion {
  const names = new Map<string, string>(), text = new Map<string, string>();
  for (const site of Object.keys(code.keyframes ?? {}).sort()) {
    const k = code.keyframes![site];
    const root = code.rootFontSize[k.range] ?? 16;
    const body = (n: string) => `@keyframes ${n} { ${k.frames.map((f) => `${f.at} { ${Object.entries(f.decls).map(([p, v]) => `${p}: ${serialize(toPx(parse(v), root))};`).join(" ")} }`).join(" ")} }`;
    const v = versioned(`${page}__${kebab(site) || "motion"}`, body);
    names.set(site, v.name);
    text.set(v.name, v.css);
  }
  return { names, text };
}

// animation-name with the paste's names (a name the capture kept no keyframes of stays as it is)
export function renameDecls(d: CodeDecls, names: Map<string, string>): CodeDecls {
  const v = d["animation-name"];
  if (v === undefined || !v.split(",").some((s) => names.has(s.trim()))) return d;
  return { ...d, "animation-name": v.split(",").map((s) => names.get(s.trim()) ?? s.trim()).join(", ") };
}

// does any element of the code name an animation (an older capture's note)
export const namesAnimation = (code: WebCode): boolean => Object.values(code.nodes).some((n) =>
  [n.decls, n.pseudo?.before, n.pseudo?.after, ...Object.values(n.inline ?? {})].some((b) => Object.values(b ?? {}).some((d) => namesIn(d?.["animation-name"]).length)));

// an element's own animation that ends: at every kept range where it names captured keyframes, every count a number;
// type: the site's first name where it first animates (widest first), as Bricks' class takes it (an ident), else the
// paste's name; its duration and delay as written there (Bricks reads "s" and "ms")
export interface Entrance { type: string; duration: string; delay: string | null }
const first = (v: string | undefined): string | undefined => v?.split(",")[0]?.trim();
export function entranceOf(states: CodeDecls[], motion: Motion): Entrance | null {
  let at: CodeDecls | null = null;
  for (const d of states) {
    if (!namesIn(d["animation-name"]).some((n) => motion.names.has(n))) continue;
    if ((d["animation-iteration-count"] ?? "1").split(",").some((c) => c.trim() === "infinite")) return null;
    at ??= d;
  }
  if (!at) return null;
  const site = namesIn(at["animation-name"]).find((n) => motion.names.has(n))!;
  const delay = first(at["animation-delay"]);
  return { type: /^[A-Za-z][A-Za-z0-9_-]*$/.test(site) ? site : motion.names.get(site)!, duration: first(at["animation-duration"]) ?? "0s", delay: delay && !/^0(\.0*)?m?s$/.test(delay) ? delay : null };
}
const ANIM = (p: string): boolean => p.startsWith("animation-");
export const withoutAnimation = (d: CodeDecls): CodeDecls => Object.fromEntries(Object.entries(d).filter(([k]) => !ANIM(k)));
// the entrance's own animation as Bricks starts it: its longhands, its delay left to the Interaction (Bricks waits it out)
export function bindingOf(d: CodeDecls): CodeDecls {
  const out = Object.fromEntries(Object.entries(d).filter(([k]) => ANIM(k)));
  if (out["animation-name"] !== undefined) out["animation-delay"] = "0s";
  return out;
}
// Bricks' Interaction (reference/bricks/cta-button-interactions.json's shape; enterView and runOnce from bricks.min.js
// 2.3.9: `case"enterView"`, `once: t.runOnce`)
export const interactionOf = (name: string, e: Entrance): Settings => ({
  id: shortId(`interaction:${name}`), trigger: "enterView", action: "startAnimation", animationType: e.type, animationDuration: e.duration,
  ...(e.delay ? { animationDelay: e.delay } : {}), runOnce: true,
});

// the @keyframes a class's rules (and extra declarations: the looks an ancestor's state sets) name, in the order first named
export function keyframesFor(css: ClassCss, motion: Motion, extra: CodeDecls[] = []): string[] {
  const decls = [...css.own, ...(css.before ?? []), ...(css.after ?? []), ...css.inline.flatMap(([, b]) => b), ...(css.entrance?.blocks ?? [])].map((b) => b.decls)
    .concat((css.states ?? []).map((s) => s.decls), extra);
  const out: string[] = [];
  for (const d of decls) for (const n of namesIn(d["animation-name"])) { const t = motion.text.get(n); if (t && !out.includes(t)) out.push(t); }
  return out;
}
```

`src/core/site/classes.ts`: `ClassCss` gains `states?: StateCss[]; entrance?: { type: string; blocks: Block[] };
keyframes?: string[]; still?: boolean` and `export interface StateCss { state: CodeState; part: string; decls: CodeDecls }`;
`customCss` uses two exported selector helpers and appends the new parts (a class without them is byte for byte as
before):

```ts
// an inline element of the class's words (`> :nth-child(k)` per element-child step, 1-based; past asTyped's <wbr>)
export const inlineSel = (name: string, at: Where, path: string): string =>
  `.${name}${at.words}${path.split("/").map((i) => ` > :nth-child(${Number(i) + 1}${at.skipWbr ? " of :not(wbr)" : ""})`).join("")}`;
// the class's element, its ::before/::after or an inline element, under a state of its own
export function partSel(name: string, at: Where, part: string, state = ""): string {
  const s = state ? `:${state}` : "";
  if (part === "") return `.${name}${at.self}${s}`;
  if (part.startsWith("::")) return `.${name}${at.self}${s}${part}`;
  return `${inlineSel(name, at, part)}${s}`;
}
// reduced motion (site-motion Q4 A, the website rules): endless animations hold their first frame, an entrance shows at
// rest at once, transitions are instant; a hover's end look still applies
export function stillCss(name: string, at: Where, entrance: string | null): string {
  const sel = `.${name}${at.self}`;
  return `@media (prefers-reduced-motion: reduce) { ${sel}, ${sel} *, ${sel}::before, ${sel}::after { animation-play-state: paused !important; transition: none !important; }${entrance ? ` .${name}.brx-animate-${entrance}${at.self} { animation: none !important; }` : ""} }`;
}
export function customCss(name: string, css: ClassCss, at: Where = ON_ELEMENT): string {
  const sel = `.${name}${at.self}`;
  return [
    ...rules(sel, css.own),
    ...(css.before ? rules(`${sel}::before`, css.before) : []),
    ...(css.after ? rules(`${sel}::after`, css.after) : []),
    ...css.inline.flatMap(([path, blocks]) => rules(inlineSel(name, at, path), blocks)),
    // site-motion: an entrance bound to Bricks' animation class, the looks the element's own states give, the @keyframes
    // its rules name, reduced motion
    ...(css.entrance ? rules(`.${name}.brx-animate-${css.entrance.type}${at.self}`, css.entrance.blocks) : []),
    ...(css.states ?? []).map((s) => rule(partSel(name, at, s.part, s.state), s.decls)),
    ...(css.keyframes ?? []),
    ...(css.still ? [stillCss(name, at, css.entrance?.type ?? null)] : []),
  ].join("\n");
}
```

`src/core/site/convert.ts` `prepare` (on elementor-map's head): the block from `const specs: Prepared["specs"] = new
Map();` through the end of its `for (const t of tree.nodes)` loop becomes the block below, as it stands after Task 9
(the planner ran it with the unit tests of Tasks 6–10 in a scratch copy of elementor-map's head: Discovery 8). Task 6 lands its `motion`, `named`, `keyframes` and `still`
lines (the rest as on the base), Task 7 its entrance lines, Task 8 its looks and `keep`, Task 9 its `triggered` key part.
Imports: `bindingOf, entranceNote, entranceOf, interactionOf, keyframesFor, motionOf, namesAnimation, OLD_NOTE,
renameDecls, withoutAnimation, type Entrance` from `./motion.ts`; `looksOf, NO_LOOKS, withStates` from `./states.ts`;
`CodeStateLook` from the snapshot types; `Prepared.specs` values gain `entrance?: Entrance; triggered?: CodeStateLook[]`.

```ts
  // site-motion (version 3): the page's @keyframes under the paste's names; an older capture as before, named (Q6 A)
  const motion = code.version >= 3 ? motionOf(code, pageSlugOf(finalUrl || capture.web!.url)) : null;
  if (!motion && namesAnimation(code)) note(OLD_NOTE);
  let entrances = 0;
  const specs: Prepared["specs"] = new Map();
  for (const t of tree.nodes) {
    if (!t.site || !t.own) continue;
    const drawn = weightsOf(code, pr, t.path);
    const named = (d: CodeDecls): CodeDecls => (motion ? renameDecls(d, motion.names) : d);
    const kept = (b: CodeByRange): Block[] => blocksOfStates(fix(statesOnKept(rewrite(b, t.path), code, pr), drawn.self).map(named), pr.ranges);
    const own = boxLook(t.node, statesOnKept(rewrite(t.node.decls, t.path), code, pr));
    const full = fix(t.parent === 0 ? withInherited(code, pr, t.path, own) : own, drawn.parent);
    // an element's own animation that ends plays as it comes into view (Q1 A): its animation-* leave its rules for the
    // binding to Bricks' animation class
    const entrance = motion ? entranceOf(full, motion) : null;
    if (entrance) entrances++;
    const states = (entrance ? full.map(withoutAnimation) : full).map(named);
    const at = code.statesAt;
    const looks = motion && at ? looksOf(t, (d) => named((rewrite({ [at]: d }, t.path)[at] ?? {}) as CodeDecls)) : NO_LOOKS;
    const blocks = blocksOfStates(states, pr.ranges);
    // a class on the site's element inside a flat wrapper writes no Bricks control (it would land on the wrapper); what a
    // state changes stays custom CSS (site-motion)
    const split = t.place === "inner" ? { settings: {}, custom: blocks.filter((b) => Object.keys(b.decls).length) } : controlsFor(blocks, t.name, { families, keep: looks.keep });
    const pseudo = t.node.pseudo ?? {};
    const css: ClassCss = {
      own: split.custom,
      before: pseudo.before ? kept(pseudo.before) : undefined,
      after: pseudo.after ? kept(pseudo.after) : undefined,
      inline: Object.keys(t.node.inline ?? {}).sort(byIndexPath).map((k): [string, Block[]] => [k, kept(t.node.inline![k])]),
      ...(looks.self.length ? { states: looks.self } : {}),
      ...(entrance ? { entrance: { type: entrance.type, blocks: blocksOfStates(full.map(bindingOf).map(named), pr.ranges) } } : {}),
    };
    if (motion) {
      const frames = keyframesFor(css, motion, looks.triggered.map((l) => l.decls));
      if (frames.length) css.keyframes = frames;
      if (frames.length || entrance || looks.self.length || looks.triggered.length) css.still = true;
    }
    const where = whereOf(t, text);
    // a class with an entrance or a look an ancestor's state sets is keyed by them too (an ancestor's spec is set: it
    // comes first in document order); a class with neither keeps today's key, so its name doesn't move (the Elementor
    // route's names are fingerprints of the key)
    const extra = entrance || looks.triggered.length ? [entrance, looks.triggered.map((l) => [l.state, l.part, specs.get(l.trigger)?.key ?? l.trigger, l.decls])] : [];
    specs.set(t.path, { key: JSON.stringify([split.settings, customCss("\u0000", css, where), ...extra]), settings: split.settings, css, where, ...(entrance ? { entrance } : {}), ...(looks.triggered.length ? { triggered: looks.triggered } : {}) });
  }
  if (entrances) note(entranceNote(entrances));
```

GREEN: AC3 (unit); the whole unit suite, `site-basic-golden.json` untouched. Commit: `site-motion task 6: a named
animation's @keyframes go with its class under the page's name; endless animations play (AC3 unit)`.

### Task 7: Entrances (AC4, unit)

*(amendment 1)* The excerpt below is the first build's: since `eec3129a` the AC4 test asserts ``animationType: `${name}In` `` and
`` .c.brx-animate-${name}In `` for `rise`, and `` `${fade}In` `` for the phone-only `fade` (both start
from opacity 0 and hold no In); head's `test/unit/site-motion.test.ts` is the test of record.

RED, in `site-motion.test.ts`:

```ts
test("AC4 a finite animation becomes an Enter viewport interaction with the site's frames", () => {
  const r = siteToBricks(motionCode(), { section: { path: S2 } });
  const h2 = classOf(r, PATHS.H2);
  assert.ok(Array.isArray(h2.settings._interactions), "the heading's class holds an Interaction");
  assert.deepEqual(h2.settings._interactions, [{ id: (h2.settings._interactions as Array<{ id: string }>)[0].id, trigger: "enterView", action: "startAnimation", animationType: "rise", animationDuration: "1.25s", runOnce: true }]);
  assert.match((h2.settings._interactions as Array<{ id: string }>)[0].id, /^[a-z]{6}$/);
  const text = String(h2.settings._cssCustom);
  const name = /@keyframes (home__rise-[a-z]{4})/.exec(text)![1];
  assert.ok(text.includes(`.${h2.name}.brx-animate-rise { animation-delay: 0s; animation-duration: 1.25s; animation-fill-mode: both; animation-name: ${name}; }`), text);
  // its rules at rest name no animation, so nothing plays by the clock on load
  assert.doesNotMatch(text.split("\n").filter((l) => !l.includes("brx-animate") && !l.startsWith("@keyframes") && !l.startsWith("@media (prefers")).join("\n"), /animation-/);
  // an animation only at phones: the binding's base is empty, its phone block names it
  const lead = classOf(r, PATHS.LEAD);
  assert.equal((lead.settings._interactions as Array<{ animationType: string }>)[0].animationType, "fade");
  assert.match(String(lead.settings._cssCustom), /@media \(max-width: 767px\) \{ \.[a-z0-9_-]+\.brx-animate-fade > p \{ animation-delay: 0s; animation-duration: 1.25s; animation-name: home__fade-[a-z]{4}; \} \}/);
  assert.ok(r.notes.includes("2 elements play their entrance as they come into view (Bricks Interactions: Enter viewport → Start animation, once)"), r.notes.join(" | "));
});
```

(`PATHS.LEAD` is a `p`: a flat Rich Text, so its rules land on `> p`; the builder confirms the selectors against
`whereOf`.) Code: Task 6's block's entrance lines (`entranceOf`, `withoutAnimation`, `css.entrance` from `bindingOf`,
`entrances`, `entranceNote`, the `extra` key part for an entrance: a class without one keeps today's key). In
`nameClasses`, where a new name's settings are set:

```ts
        const custom = customCss(name, spec.css, spec.where);
        const settings = spec.entrance ? { ...spec.settings, _interactions: [interactionOf(name, spec.entrance)] } : spec.settings;
        settingsOf.set(name, custom ? { ...settings, _cssCustom: custom } : settings);
```

GREEN: AC4 (unit). Commit: `site-motion task 7: an element's own finite animation plays once as it comes into view
through Bricks' Interaction, its frames bound to Bricks' animation class (AC4 unit)`.

### Task 8: The element's own state looks (AC5, unit) and controls

RED:

```ts
test("AC5 a state look is a rule after the class's own, never a Bricks control", () => {
  const r = siteToBricks(motionCode(), { section: { path: S1 } });
  const w = classOf(r, PATHS.WIDGET);
  assert.equal((w.settings as Record<string, unknown>)._background, undefined, "background-color changes on hover: custom CSS, not the Background control");
  const text = String(w.settings._cssCustom);
  const lines = text.split("\n");
  const base = lines.findIndex((l) => l.startsWith(`.${w.name} {`));
  const hover = lines.findIndex((l) => l === `.${w.name}:hover { background-color: #f2f5f9; box-shadow: 1px 2px 34px 19px rgba(0, 0, 0, 0.5); }`);
  assert.ok(base >= 0 && hover > base, text);
  assert.match(lines[base], /background-color: #ffffff;/);
  const s2 = siteToBricks(motionCode(), { section: { path: S2 } });
  const lead = String(classOf(s2, PATHS.LEAD).settings._cssCustom);
  assert.match(lead, /> p > :nth-child\(1 of :not\(wbr\)\):hover \{ color: #e73a3a; \}/);
  assert.match(lead, /> p > :nth-child\(1 of :not\(wbr\)\):focus \{ color: #e73a3a; \}/);
});
```

Code: `src/core/site/states.ts`:

```ts
// The looks a state gives a site element (site-motion, Q2 A, Q3 A): the element's own (its :hover, :focus, … and its
// ::before/::after's and inline elements' under its own state) are rules of its class (classes.ts customCss); a look an
// ancestor's state sets is written once the classes are named (withStates). keep: what the element's own box changes
// under any state, kept out of Bricks controls (a class's tier controls print after its custom CSS)
import type { CodeDecls, CodeStateLook } from "../snapshot/web.ts";
import type { StateCss } from "./classes.ts";
import type { TreeNode } from "./tree.ts";

export interface Looks { self: StateCss[]; triggered: CodeStateLook[]; keep: Set<string> }
export const NO_LOOKS: Looks = { self: [], triggered: [], keep: new Set() };
// rewrite: a look's declarations as the paste writes them (rem in px, pictures, animation names)
export function looksOf(t: TreeNode, rewrite: (d: CodeDecls) => CodeDecls): Looks {
  const self: StateCss[] = [], triggered: CodeStateLook[] = [], keep = new Set<string>();
  for (const l of t.node.states ?? []) {
    const decls = rewrite(l.decls);
    if (!Object.keys(decls).length) continue;
    if (l.part === "") for (const k of Object.keys(decls)) keep.add(k);
    if (l.trigger === "") self.push({ state: l.state, part: l.part, decls });
    else triggered.push({ ...l, decls });
  }
  return { self, triggered, keep };
}
```

`controls.ts`: `ControlOptions` gains `keep?: ReadonlySet<string>` and `isControl` starts `if (opts.keep?.has(p)) return
false;`. `prepare`: Task 6's block's `looks`, `keep` and `states` lines. GREEN: AC5 (unit). Commit: `site-motion task 8: an element's own
hover and focus looks are rules of its class after its own, never Bricks controls (AC5 unit)`.

### Task 9: Looks an ancestor's state sets (AC6, unit) and the Elementor fold (AC15)

RED:

```ts
test("AC6 a look an ancestor's state sets names the ancestor's class", () => {
  const r = siteToBricks(motionCode(), { section: { path: S1 } });
  const w = classOf(r, PATHS.WIDGET), p = classOf(r, PATHS.P1);
  assert.ok(String(p.settings._cssCustom).split("\n").includes(`.${w.name}:hover .${p.name} > p { color: #e73a3a; }`), String(p.settings._cssCustom));
  assert.doesNotMatch(JSON.stringify(r.payload.globalClasses), /#brxe-/);
  // the same capture pasted whole names the same rule in the page's paste
  const parts = siteParts(motionCode());
  assert.match(JSON.stringify(parts.page!.payload.globalClasses), /:hover \.[a-z0-9_-]+ > p \{ color: #e73a3a; \}/);
});
```

`states.ts` gains:

```ts
import type { Settings } from "./controls.ts";
import type { Prepared } from "./convert.ts";
import { partSel } from "./classes.ts";

// the paths from `from` down to `to` (to's ancestors at or below from, then to)
const down = (from: string, to: string): string[] => {
  if (from === to) return [to];
  if (!to.startsWith(from + "/")) return [];
  const steps = to.slice(from.length + 1).split("/");
  return [from, ...steps.map((_, i) => `${from}/${steps.slice(0, i + 1).join("/")}`)];
};
// each look an ancestor's state sets, once the classes are named: `.<trigger class>:<state> <the element's part>` appended
// to the element's class (lines it already holds aren't repeated); the trigger is the element at the look's trigger path
// or, where the paste has none there (a wrapper the Elementor step folded), the first element below it on the way to the
// element; the element itself: its own state; none: named
export function withStates(p: Prepared, names: Map<string, string>, settingsOf: Map<string, Settings>): void {
  for (const t of p.tree) {
    const spec = p.specs.get(t.path), name = names.get(t.path);
    if (!t.site || !name || !spec?.triggered?.length) continue;
    const add: string[] = [];
    for (const l of spec.triggered) {
      const trig = down(l.trigger, t.path).find((q) => names.has(q));
      if (!trig) { if (!p.notes.includes(LOST)) p.notes.push(LOST); continue; }
      const at = p.specs.get(trig)!.where;
      const sel = trig === t.path ? partSel(name, spec.where, l.part, l.state) : `${partSel(names.get(trig)!, at, "", l.state)} ${partSel(name, spec.where, l.part)}`;
      add.push(`${sel} { ${Object.keys(l.decls).sort().map((k) => `${k}: ${l.decls[k]};`).join(" ")} }`);
    }
    if (!add.length) continue;
    const settings = settingsOf.get(name)!;
    const have = String(settings._cssCustom ?? "").split("\n").filter(Boolean);
    settingsOf.set(name, { ...settings, _cssCustom: [...have, ...add.filter((l) => !have.includes(l))].join("\n") });
  }
}
export const LOST = "a hover or focus look set by an element the paste doesn't hold (above the pasted part) is left out";
```

(`withStates` and `withLooks` both append to `_cssCustom`; withStates runs after withLooks.) `prepare`: Task 6's block's
`triggered` spec field and key part (the trigger's own key: an ancestor comes first in document order, so its spec is
set) and `keyframesFor`'s extra declarations. `siteToBricks`: `withStates(p, nameOf[0], settingsOf)` after `withLooks`;
`parts.ts` `siteParts`: `prepared.forEach((p, i) => { withLooks(p, nameOf[i], settingsOf, pr); withStates(p, nameOf[i],
settingsOf); })`.

AC15 RED in `test/unit/site-elementor-fold.test.ts` (on its own fixture `test/fixtures/site-elementor-code.ts`): a
heading widget whose widget box has `states: [{ state: "hover", trigger: "", part: "", decls: { "background-color":
"#e73a3a" } }]` converted with `elementor: true` keeps its widget box and notes `not folded: heading <id>: its widget
changes under hover`, and its class holds `:hover { background-color: #e73a3a; }`; the same widget without the look folds
as before. Code, `elementor-fold.ts` `foldable`, in the first loop over the wrappers:

```ts
    const look = n.states?.find((l) => l.part === "" || l.part.startsWith("::"));
    if (look) return `${name(i)} changes under ${look.state}`;
```

(`foldElementor`'s merged node must keep the body's `states`: check `merge`'s caller copies the body node's other fields;
if it builds a new node, carry `states` from the body.) GREEN: AC6, AC15 (unit); the Elementor unit files. Commit:
`site-motion task 9: a look an ancestor's state sets names the ancestor's class; a wrapper with a look of its own isn't
folded (AC6, AC15 unit)`.

### Task 10: Reduced motion, names, older captures (AC7, AC12, AC9 unit)

*(amendment 1)* In the excerpt below the reduced-motion stop reads `.c.brx-animate-${rise}In` since `eec3129a` (and
the hidden-on-load override since `f7209b9d`); head's `test/unit/site-motion.test.ts` is the test of record.

RED:

```ts
test("AC7 every class with motion stands still under reduced motion", () => {
  const r = siteToBricks(motionCode(), { section: { path: S1 } });
  for (const p of [PATHS.PHOTO, PATHS.WIDGET]) {
    const c = classOf(r, p);
    assert.ok(String(c.settings._cssCustom).includes(`@media (prefers-reduced-motion: reduce) { .${c.name}, .${c.name} *, .${c.name}::before, .${c.name}::after { animation-play-state: paused !important; transition: none !important; } }`), c.name);
  }
  const h2 = classOf(siteToBricks(motionCode(), { section: { path: S2 } }), PATHS.H2);
  assert.ok(String(h2.settings._cssCustom).includes(` .${h2.name}.brx-animate-rise { animation: none !important; } }`));
  // a class with no motion holds none
  assert.doesNotMatch(String(classOf(r, PATHS.ROW).settings._cssCustom ?? ""), /prefers-reduced-motion/);
});
test("AC12 keyframes and classes are never bare; interaction ids are stable", () => {
  const a = siteParts(motionCode()), b = siteParts(motionCode());
  const all = JSON.stringify(a.page!.payload);
  assert.match(all, /@keyframes /, "the page's paste holds keyframes");
  for (const m of all.matchAll(/@keyframes ([^ ]+) /g)) assert.match(m[1], /^home__[a-z0-9-]+-[a-z]{4}$/);
  const ids = (x: typeof a) => x.page!.payload.globalClasses!.flatMap((g) => ((settingsOf(g)._interactions as Array<{ id: string }> | undefined) ?? []).map((i) => i.id));
  assert.deepEqual(ids(a), ids(b));
  const services = motionCode(); services.web!.finalUrl = "https://site.test/services/";
  const kf = (x: string) => new Set([...x.matchAll(/@keyframes ([^ ]+) /g)].map((m) => m[1]));
  const shared = [...kf(all)].filter((n) => kf(JSON.stringify(siteParts(services).page!.payload)).has(n));
  assert.deepEqual(shared, []);
});
```

`test/unit/site-motion-old.test.ts`:

```ts
// AC9 (site-motion): a capture made before this build (code version 1 or 2) pastes byte for byte as main's did (Task 0's
// goldens), its notes gaining only OLD_NOTE where its code names an animation. F2B_SITE_MOTION_OLD=<dir of Task 0's
// real-capture pastes> runs Justin's 11-04 and 11-07 captures too.
```

(For each hand-made capture export and variant: `siteParts(capture, opts)` JSON equal to
`test/fixtures/site-motion-base/<name>.json`'s entry; `motionCode({ version: 2 })` pastes no `@keyframes`, no `:hover`, no
`_interactions`, keeps `animation-name: shimmerGradient` as written, and notes `OLD_NOTE` once per part; with
`F2B_SITE_MOTION_OLD`, the two real captures' pastes equal the recorded files and their notes equal the recorded notes
plus `OLD_NOTE`.) `test/web/lib/class-names.ts` `bareNames`: also read every `@keyframes <name>` of each class's
`_cssCustom` into `names` (a name not under the page's name is bare; `invalid` as for classes). Code: `still` as Task 8
set it; nothing else should be needed. GREEN: AC7, AC9, AC12 (unit); the whole unit suite (compare by test name with
Task 0's tally). Commit: `site-motion task 10: reduced motion, never-bare keyframes, older captures byte for byte (AC7,
AC9, AC12 unit)`.

### Task 11: The test renderer plays Bricks' own Interactions (bricksMotion)

1. Copy `~/.hermes/plans/figma-to-bricks/evidence/entrance-timing/planner/live-animate.min.css` to
   `reference/bricks/frontend-2.3.9/animate.min.css` after checking its sha256 is
   `8c647b66e3079ff0bcca743f4d024d8156e526c070ae832d9b311cec11a2ccbe`; add its line to `SHA256SUMS`; one README line
   ("`animate.min.css`: Bricks 2.3.9's `wp-content/themes/bricks/assets/css/libs/animate.min.css` from Justin's darksalmon
   site, read 2026-10-29 by the entrance-timing planner (public GET, no login): `.brx-animated`, the hidden-on-load rule,
   reduced motion, animate.css keyframes").
2. `test/browser/render.ts`: `PageOptions.bricksMotion?: boolean` (site mode only). In `body(payload, site, motion)`: an
   element whose own settings or classes (`_cssGlobalClasses` → `globalClasses`) hold `_interactions` with a
   `startAnimation` entry prints ` data-interactions="${esc(JSON.stringify(list))}" data-interaction-id="${el.id}"
   data-interaction-hidden-on-load="1"` (as darksalmon's home prints a class's Interaction:
   `evidence/entrance-timing/planner/fetch-live-bricks.txt`); the head adds `<style>${asset("animate.min.css")}</style>`
   right after the Bricks CSS; the Bricks script list (elementor-map's composition of `NAV_CALLS` and `"bricksAccordion"`)
   gains `"bricksInteractions"` with `window.bricksData.interactions=[]` set before it and a ready flag
   `__f2bMotionReady`. Without `bricksMotion` nothing changes.
3. `test/web/lib/site-check.ts`: `renderSitePaste(payload, head = "", theme = HOSTILE_THEME, opts: { motion?: boolean } =
   {})` passes `bricksMotion: opts.motion`.
4. RED/GREEN: `test/browser/render-site-motion.test.ts` › "a class's Enter viewport interaction plays as Bricks plays it":
   the probe of Discovery 5 as a test (a hand-made payload: one Div with a class holding the Interaction and the binding
   rule, behind a 2000 px spacer): out of view opacity 0, scrolled in the class `brx-animate-fadeInUp` and the class's
   own keyframes run 1250 ms, at its end the class is gone and opacity 1, back in view no new animation; without
   `bricksMotion` the element prints no `data-interactions`. Run `test/browser/render*.test.ts` file by file. Commit:
   `site-motion task 11: the site renderer runs Bricks 2.3.9's own Interactions and animate.min.css when asked`.

### Task 12: The motion oracle and the fixture's browser proofs (AC3–AC8)

`test/web/lib/motion-check.ts` (test tooling; self-contained in-page functions sent with `page.evaluate`):

```ts
// site-motion: the same motion read on a site page and on its paste. An element is found by its site path (findPath)
// or its paste id (a Rich Text's site element is its p; an inline element by its index path in it); an animation is held
// at a fraction of its own duration and read; Chrome's own mouse moves onto an element (CDP Input) and its transitions
// are held at a fraction; the keyboard's Tab moves focus. Values are compared number by number.
import type { Page } from "../../browser/chrome.ts";
import { findPath } from "../../../src/web/read/page-reader.ts";

export interface Where { path?: string; id?: string; inner?: boolean; inline?: string }
const FIND = `((w) => { const findPath = ${findPath.toString()}; let e = w.path !== undefined ? findPath(w.path) : document.getElementById("brxe-" + w.id); if (e && w.inner) e = e.querySelector(":scope > p") || e; if (e && w.inline) for (const k of w.inline.split("/")) e = e ? [...e.children].filter((c) => c.tagName !== "WBR")[Number(k)] || null : null; return e; })`;

// the page scrolled (by its own scroller) so the element is in the middle of the window, then its centre in the window
export async function bringIn(page: Page, w: Where): Promise<{ x: number; y: number } | null> {
  await page.cdp("Page.bringToFront");
  return page.evaluate(`(() => { const e = ${FIND}(${JSON.stringify(w)}); if (!e) return null; const r0 = e.getBoundingClientRect(); window.scrollTo({ top: scrollY + r0.top + r0.height / 2 - innerHeight / 2, behavior: "instant" }); const r = e.getBoundingClientRect(); return new Promise((ok) => requestAnimationFrame(() => requestAnimationFrame(() => ok({ x: r.left + r.width / 2, y: r.top + r.height / 2 })))); })()`);
}
// its CSS animation (pseudo: "" or "::after"…) paused at fraction × its duration; its name and duration (null: none runs)
export async function holdAnimation(page: Page, w: Where, pseudo: string, fraction: number): Promise<{ name: string; duration: number; easing: string } | null> {
  return page.evaluate(`(() => { const e = ${FIND}(${JSON.stringify(w)}); if (!e) return null; const a = e.getAnimations({ subtree: true }).find((x) => x.animationName !== undefined && x.effect && x.effect.target === e && (x.effect.pseudoElement || "") === ${JSON.stringify(pseudo)}); if (!a) return null; const d = a.effect.getComputedTiming().duration; a.pause(); a.currentTime = Number(d) * ${fraction} + (Number(a.effect.getTiming().delay) || 0); return { name: a.animationName, duration: Number(d), easing: a.effect.getTiming().easing || getComputedStyle(e, ${JSON.stringify(pseudo || null)}).animationTimingFunction }; })()`);
}
// every transition running inside the element (itself and its subtree) held at fraction × its own duration; how many
export async function holdTransitions(page: Page, w: Where, fraction: number): Promise<number> {
  return page.evaluate(`(() => { const e = ${FIND}(${JSON.stringify(w)}); if (!e) return 0; const list = e.getAnimations({ subtree: true }).filter((x) => x.transitionProperty !== undefined); for (const t of list) { t.pause(); t.currentTime = Number(t.effect.getComputedTiming().duration) * ${fraction}; } return list.length; })()`);
}
export async function finishAll(page: Page): Promise<void> {
  await page.evaluate(`(() => { for (const a of document.getAnimations()) { try { if (a.effect && a.effect.getComputedTiming().iterations === Infinity) { a.pause(); a.currentTime = 0; } else a.finish(); } catch {} } })()`);
}
export async function values(page: Page, w: Where, pseudo: string, props: string[]): Promise<Record<string, string> | null> {
  return page.evaluate(`(() => { const e = ${FIND}(${JSON.stringify(w)}); if (!e) return null; const cs = getComputedStyle(e, ${JSON.stringify(pseudo || null)}); return Object.fromEntries(${JSON.stringify(props)}.map((p) => [p, cs.getPropertyValue(p)])); })()`);
}
export async function box(page: Page, w: Where): Promise<{ x: number; y: number; w: number; h: number } | null> {
  return page.evaluate(`(() => { const e = ${FIND}(${JSON.stringify(w)}); if (!e) return null; const r = e.getBoundingClientRect(); return { x: r.left + scrollX, y: r.top + scrollY, w: r.width, h: r.height }; })()`);
}
// Tab from the top of the page until the element has the keyboard's focus (at most max presses)
export async function tabTo(page: Page, w: Where, max = 60): Promise<boolean> {
  await page.evaluate(`(document.activeElement && document.activeElement.blur && document.activeElement.blur(), window.scrollTo(0, 0))`);
  for (let i = 0; i < max; i++) {
    await page.press("Tab");
    if (await page.evaluate<boolean>(`document.activeElement === ${FIND}(${JSON.stringify(w)})`)) return true;
  }
  return false;
}
// two computed values alike: the same words, every number within tol (absolute) or 1 %
export function alike(a: string, b: string, tol = 0.5): boolean {
  const num = /-?\d*\.?\d+(?:e-?\d+)?/gi;
  if (a.replace(num, "#") !== b.replace(num, "#")) return false;
  const x = a.match(num) ?? [], y = b.match(num) ?? [];
  return x.every((v, i) => Math.abs(Number(v) - Number(y[i])) <= Math.max(tol, Math.abs(Number(v)) * 0.01));
}
```

`test/web/site-motion-proof.test.ts`: `before` launches Chrome, serves `site-motion`, captures it (code on) once, makes
`parts = siteParts(cap)` (rich) and a map site path → paste `Where` (`sources` inverted; a flat Rich Text's site
element is `{ id, inner: true }`, an inline part adds `inline`); `site(w)` loads the fixture page fresh at width `w`;
`paste(part, w, motion = true, reduce = false)` sets the content of a fresh page to `renderSitePaste(pastePictures(part.payload,
cap), await fontsHead(cap), HOSTILE_THEME, { motion })` at width `w` (with `emulateMedia` for reduce). The tests:

- **AC3:** at 1440, the header bar's `.bar__glow` (`::after`), the band (`::after`) and the dot: for fractions 0, 0.25,
  0.5, 0.75, `holdAnimation` on both pages (the paste's name matches `home__shimmer-[a-z]{4}` / `home__beat-[a-z]{4}`,
  the durations equal), then `values(…, ["background-position"])` / `["transform"]` alike; the band's patch (a 16 × 16
  shot 8 px in from the `::after` box's top-left, `page.screenshot({ clip })` at `scrollY`) has the site's mean colour
  within 10 per channel at 0 and 0.5.
- **AC4:** at 1440 and 390, `#enter`, `#enter-title`, `#late`: before scrolling there the paste element's opacity is 0 and
  the site's visibility hidden; `bringIn` both; poll (≤ 2 s) until an animation runs on each (`#late`: none on the paste
  150 ms after coming in, one by 700 ms); paste name = the paste's name of the site's (`home__fade-in-up-xxxx` for
  `fadeInUp`; at 390 `#enter-title`'s is `fadeIn`'s, as the site's), durations equal (1250), easing equal; at 0.25, 0.5,
  0.75 `opacity` and `transform` alike; `finishAll`, then boxes within 2 px of the site's; scroll to the top and back:
  no animation runs on the paste element.
- **AC5:** at 1440, for `#go`, `#call`, `#about`, `#card1`, the hero's inline link, `#logo`: `bringIn` both, `page.mouseMove`
  to the centre on both, two frames, `holdTransitions(…, 0.5)` (or, for the logo, `holdAnimation(…, 0.5)`), then each
  property its look changes (from the capture's `states`) alike; `finishAll`, alike again, `box` within 2 px; then
  `tabTo` `#go` on both: `background-color` alike after `finishAll`.
- **AC6:** at 1440, `#flip`: mouse on its centre on both, `holdTransitions(#flip, 0.5)`, `#front` and `#back`
  `transform` alike; `finishAll`, alike (`#back` `none`); mouse to (2, 2), `finishAll`, both at rest alike; `tabTo`
  `#more`: after `finishAll` `#front`/`#back` `transform` and `#more`'s `outline-*` alike.
- **AC7:** the paste with reduce: after load + 300 ms no animation of the page is `running`; after the AC5 hovers (mouse)
  none `running` and the looks' end values already there; after bringing each entrance in, within 200 ms its opacity is
  1 and none `running`; the band's `::after` animation is `paused` at its first frame.
- **AC8:** `checkPage` (`test/web/lib/site-page-check.ts`) over the capture's widths plus 2560, 1920, 1440, 1024, 768,
  390, 320, rich and basic, every row within 2 px (as `site-page-proof.test.ts` does).

On the base every AC3–AC7 test fails (no keyframes, no looks, no Interactions: `renderSitePaste`'s fourth argument is
ignored there); AC8 passes on the base too (the still frames). Run it alone (one Chrome job). Commit: `site-motion task
12: the motion oracle and the fixture's browser proofs (AC3–AC8)`.

### Task 13: bdryswi.com's saved home (AC11, named-only)

`test/web/site-motion-bdry.test.ts`, run only with `F2B_CODE_PROOF_BDRY` (the saved 2026-10-29 files, as
`site-page-bdry.test.ts`); `F2B_SITE_MOTION_STANDIN=<file>` reuses a capture an earlier run saved
(`$TMPDIR/bdry-standin-v3.f2b-capture.json`; the first run captures the served stand-in as `site-page-bdry.test.ts`
does, about 35 minutes, and saves it). For both routes (`elementor: false`, `true`): the targets come from the capture,
never from B-Dry's ids or words: every node or `::after` whose declarations at 1440's range name an endless animation
with captured keyframes (B-Dry: the header bar and bands' `::after`, the hotspot dots), every node with a `hover` look
shown at 1440 (buttons, grow, cards; for each trigger once), and every trigger of an ancestor-set `transform` look (the
flip boxes). Each is held and compared as AC3, AC5 and AC6 do (the band's patch the site's mean colour within 10 per
channel at 0 and 50 %); `checkPage` at 1440, 768 and 390: the code method within 2 px; the `elementor` route within
2 px, or, at a width where a row is over 2 px, no worse than the same `elementor` paste without motion (the capture
read as version 2), row by row *(amendment 2)*. Write the per-target table to
`F2B_SITE_MOTION_OUT` when set. Commit: `site-motion task 13: bdryswi.com's saved home moves as the page does (AC11,
named-only)`.

### Task 14: The live check tool (AC14)

`tools/site-motion-live.ts <page URL> <paste dir>`: read-only GETs (`?f2b=<random>`) of the page, its linked CSS
(`uploads/bricks/css/post-<id>.min.css`, the inline class CSS in the page) and nothing else: lists, for each class of
the paste dir's `page.json` that holds `_interactions`, whether an element carrying it prints `data-interactions` with
`"trigger":"enterView"` and `"runOnce":true`, and `data-interaction-hidden-on-load` where Bricks prints it (a Start
animation on the element itself whose type holds In, any case) *(amendment 1)*; whether the page links
`animate.min.css`; whether every `@keyframes` name and every `:hover` selector of the paste's classes is in the page's
CSS. Exit 0 only when all hold; a missing piece is named. It writes nothing anywhere. A unit test runs its parser on a
saved page fragment (`test/unit/site-motion-live.test.ts`). Commit: `site-motion task 14: the read-only live check of
Bricks keeping the interactions, keyframes and hovers (AC14 tool)`.

### Task 15: Gates

On the head, compared with Task 0 by test name: `npm run check` (unit, typecheck, build, performance); the five
replays byte-identical (AC10); `npm run corpus` no worse (compare reports, not exit codes); the web files of Task 0
plus `capture-motion.test.ts`, `site-motion-proof.test.ts` one by one; `test/browser/render*.test.ts`; AC9 named with
`F2B_SITE_MOTION_OLD`; AC11 named once; the elementor-map named B-Dry files (`site-elementor-bdry.test.ts` with
`F2B_ELEMENTOR_STANDIN`) and web-code-page's AC9 (`site-page-bdry.test.ts`) with the fresh stand-in (both must still
pass: the still frames). Shots for the records: the fixture's band at 0/50 %, a button before/after hover, the flip box
at rest/halfway/turned, side by side site | paste, in `E/shots/` (never committed). Ledger: every receipt.

### Task 16: Docs & records

- this plan copied to `docs/plans/2026-11-07-site-motion.md` (it is) and the ledger moved by the finisher to
  `docs/plans/2026-11-07-site-motion-ledger.md` before the last premerge commit;
- `docs/HANDOFF.md`: a new section above the top `## ` heading ("A captured site's motion in its paste (site-motion,
  website importer; build <at merge>; paste check <id at merge> owed)": what changed, the ⭐ answers Q1–Q6, the
  follow-ups below, the tests, the limits: looks read at the design width only, a custom property's state change and
  `:has()`/neighbour looks counted not kept, `:active`/`:visited` left out, a ::before/::after's finite animation plays
  on load, keyframes that differ by width take the widest's), and its paste check at the top of "End-of-run check list"
  (the next free id at the merge: check main's HANDOFF, every local branch and the plan logs; elementor-map may take 3dj);
  the paste check's steps: 1 `npm run capture -- https://bdryswi.com/`; 2 `npm run site:check -- <capture> --all`; 3
  `npm run site -- <capture> ~/Downloads/bdry-paste --elementor`; 4–6 paste header, footer, page as web-code-page's 3di
  (Import classes: Accept, Reject and tell if a team name shows); 7 Regenerate code signatures; 8 compare beside
  bdryswi.com at 1440 and on the phone (AC13's list); 9 Reduce motion on, reload, nothing moves; 10 reply *pasted* (the
  checker runs `tools/site-motion-live.ts`, AC14);
- `docs/specs/web-capture.md`: version 3 (Task 4);
- `reference/bricks/README.md`: `animate.min.css` (Task 11);
- `BUILD` bumped by the finisher at the merge; main `CLAUDE.md` Status: the build line and one line for this feature with
  its paste check; one standing line under "Website captures" or the importer's rules: "A captured page's motion pastes
  as its own CSS: its @keyframes under the page's name, its hover/focus looks (read at the design width), its entrances
  through Bricks' Interaction Enter viewport → Start animation, once; it stands still under reduced motion" (if writing
  CLAUDE.md is refused: `~/.hermes/plans/figma-to-bricks/site-motion-claude-md-pending.md`).

## Tests and validation

| AC | Test | RED on the base |
|---|---|---|
| AC1 | `test/web/capture-motion.test.ts` "AC1 …" | version 2, no keyframes |
| AC2 | `capture-motion.test.ts` "AC2 …" | no `statesAt`, no looks |
| AC3 | `test/unit/site-motion.test.ts` "AC3 …"; `test/web/site-motion-proof.test.ts` "AC3 …" | no `@keyframes`; the paste's shimmer doesn't run |
| AC4 | `site-motion.test.ts` "AC4 …"; `site-motion-proof.test.ts` "AC4 …" | no Interaction; the entrance shows still |
| AC5 | `site-motion.test.ts` "AC5 …"; `site-motion-proof.test.ts` "AC5 …" | no `:hover`; the Background control holds the colour |
| AC6 | `site-motion.test.ts` "AC6 …"; `site-motion-proof.test.ts` "AC6 …" | the flip box doesn't turn |
| AC7 | `site-motion.test.ts` "AC7 …"; `site-motion-proof.test.ts` "AC7 …" | no reduced-motion block (the unit RED; the browser test's "nothing runs" passes vacuously on the base, so its RED is the unit's) |
| AC8 | `site-motion-proof.test.ts` "AC8 …"; `site-page-proof.test.ts` | green on the base too (a regression guard) |
| AC9 | `test/unit/site-motion-old.test.ts` "AC9 …" (+ named) | green on the base by construction except the note line (RED: `OLD_NOTE` missing) |
| AC10 | replay receipt; `test/unit/site-isolation.test.ts` | green on the base (a guard) |
| AC11 | `test/web/site-motion-bdry.test.ts` "AC11 …" (named) | nothing moves |
| AC12 | `site-motion.test.ts` "AC12 …"; `bareNames` | no keyframes to check (RED: the `@keyframes` count assertion `> 0` first) |
| AC13 | HANDOFF paste check steps (live, Justin) | — |
| AC14 | `tools/site-motion-live.ts` (live; its parser `test/unit/site-motion-live.test.ts`) | — |
| AC15 | `test/unit/site-elementor-fold.test.ts` "AC15 …" | the wrapper folds, its look lost |

Mutation checks (`mutation-testing-discipline`, each under the memory cap, on a scratch copy): drop the `keep` set
(AC5 unit fails), write the triggered rule without the trigger's class (AC6 fails), keep the entrance's animation in its
rest rules (AC4 unit fails; the browser AC4 sees it play on load), drop `runOnce` (AC4 browser "doesn't play again"
fails), drop the still block's `paused` (AC7 browser fails), force no state in `readStates` (AC2 fails), let the trigger
test run under the forced state (AC2's flip trigger reads the back itself: fails).

## Risks and trade-offs

- **Bricks' round trip is proved in code, not live:** `enterView` and `runOnce` come from `bricks.min.js` 2.3.9 (the
  sample has `contentLoaded`); that Bricks PHP prints `data-interaction-hidden-on-load` for an `enterView` start (as it
  does for `contentLoaded`, live on darksalmon) and loads `animate.min.css` on the page is AC14's. If it doesn't hide the
  box before it comes in, the entrance still plays, with a brief flash at the window's edge. Bricks prints that mark only
  for a type holding In, so an entrance that starts hidden takes `<paste name>In` (amendment 1).
- **Theme Style leaks on hover:** a Bricks Theme Style rule such as `a:hover { color }` (unlayered) beats a pasted link's
  rest colour where the site gives that link no hover look (the reset can't revert a state); a follow-up when a real
  paste shows it.
- **Looks read at one width** (Q2 A): a hover a site sets only on phones isn't pasted; a look a hover sets by changing a
  custom property (`.btn:hover { --c: red }` used by a child) isn't read (no rule of the child changes).
- **Capture time:** about 2–3 minutes more on bdryswi.com (two reads at one range); a page whose forced hover opens
  menus is read with them open only for matched rules (layout isn't read then).
- **Class churn on the code method's route:** a class that gains a look is a new key, so numbered names after it in its
  section can shift by one (`home__x__box-2` → `-3`); Import classes then lists this page's own `home__…` classes once
  (Accept, as web-code-page's 3di says).
- **convert.ts is over 300 lines** (334 on elementor-map's head): the new logic lives in `motion.ts` and `states.ts`;
  `prepare` grows by about 15 lines. A split of `nameClasses`/`withLooks` into their own file is a follow-up, not this job.

## Follow-ups (not this round)

- The hero slider as Bricks' Slider (Nestable) (Q5 A: its own job, `site-slider`, planned in parallel).
- Hotspot tooltips (Elementor's script opens them on hover or click).
- The "60 Years" circle drawing itself (an svg part's animation inside a Code element's markup, started by Elementor's
  script when in view).
- The reviews carousel (Trustindex's script), the sticky bar's effects, the ☰ pop-up (the menu job).
- Theme Style hover leaks; looks through custom properties, `:has()` and neighbours; `:active`, `:visited`; per-width
  looks (Q2 B); a pseudo element's finite animation as an entrance; keyframes that differ by width.

## Other open features touching the same files

- **elementor-map** (merging now): the base of this job (see "How it meets elementor-map").
- **site-slider** (Q5 A, to be planned): `src/core/site/tree.ts`, `kinds.ts`, `elementor-*.ts`, `widgets.ts`, the
  renderer's slider; it shares `convert.ts` with this job: build in sequence or rebase the second onto the first.

## Completion contract

The builder stops at `ready-for-review` with every task committed, the ledger committed, AC1–AC12 and AC15 green with
receipts (AC11 named, run once), AC13 and AC14 owed to Justin, no `BUILD` bump, no push. One fresh review (website
importer rule: real-site bugs only; edge cases to `follow-ups.md`), then the verifier, the blind AC auditor and
`ac-check.sh`; the finisher merges into local `main`.
