# site-slider (website importer): a site's slider pastes as Bricks' Slider (Nestable) and plays like the site

Planner: site-slider planner, 2026-11-09. Base: main `fd1986dcdbc8cf35f114b80be456e94279346743` (Build 2026-11-09.3).
Evidence: `~/.hermes/plans/figma-to-bricks/evidence/site-slider/planner/` (scripts and their outputs; bdryswi.com
never loaded; staging and darksalmon read with GETs only).

## Amendments (planner, 2026-11-09; a fresh reviewer, verifier or auditor reads this first)

Every changed line below carries *(amendment N)*. The text before these amendments is
`git show 84e591db:docs/plans/2026-11-09-site-slider.md` (branch `site-slider-fix1`, base `fd1986dc`), byte for byte
the first approved copy `evidence/site-slider/plan-approved.md`. No criterion is added, removed, renumbered or
retagged, and every test name a criterion cites is unchanged (four of them now sit whole on one line, amendment 5).
Amendments 1 to 3 follow review 1 (`evidence/site-slider/review-1/review.json`, on `1b193b45`) and fixer 1 (`3ba7315c`
to `84e591db`, receipts `evidence/site-slider/fixer-1/`), taken under Justin's standing "go with recommended"
(2026-11-09): the tests at `84e591db` already hold the new expectations, and only this text was behind (review 2's
R2-5). Amendment 4 follows review 2 (`evidence/site-slider/review-2/review.json`, on `84e591db`; Justin's standing
words in `review-2/justin.json`) and was written ahead of `84e591db`, while fixer 2 was at work on it *(amendment
7: fixer 2 has returned; the next paragraph reads amendment 4 against its head)*. The supporting tests named
here are cited by no criterion: a verifier or auditor runs each beside the cited test of the line it supports and
names its log in that row's evidence (`ac-check.sh` proves only the cited one).

*(amendments 7 to 10; planner, 2026-11-09; wording only)* Amendments 7 to 10 follow review 3
(`evidence/site-slider/review-3/review.json`, clean, on `a97b102c`: R3-1, R3-2 and R3-3) and fixer 2 (`cb397e5c` to
`a97b102c`, branch `site-slider-fix2`, receipts `evidence/site-slider/fixer-2/`). The code and the tests at
`a97b102c` already hold what they say; only this text was behind, and nothing in the code or the tests changes with
them. Again no criterion is added, removed, renumbered or retagged, and no cited test name changes. The text before
them (amendments 1 to 6) is `~/.hermes/plans/figma-to-bricks/site-slider-amended.md`, byte for byte the approved copy
they amend (sha256 `2199618b5a0d710e10db0898b9de2db088ad41f1a9e421b71411eca3bb8509fb`). The first approved copy is
now `evidence/site-slider/plan-approved-v1-before-amendments.md`, and the repo's plan at `a97b102c`
(`git show a97b102c:docs/plans/2026-11-09-site-slider.md`) is still that first text (review 3's R3-4: the after-merge
finisher brings the repo's copy to the approved one).
Amendment 4, read against `a97b102c`: its wording on the restore class holds. Fixer 2 chose "scoped to weigh
nothing" (`:where(:where(.<name>, .<name> *).splide__slide img)`, since `ba98025b`); the class's text still holds
the reference file's 41 rules, and the fourth criterion's cited unit test asserts that and names the one rule. Its
sub-bullet on R2-3 is corrected by amendment 7, and its "one line to re-read" is settled by amendment 8.

*(amendment 11; planner, 2026-11-09)* Amendment 11 changes only which capture the ninth criterion's named-only test
reads (the stack finisher's finding on `7d9754ed`, branch `site-slider-stack1-fix3`). No criterion is added, removed,
renumbered or retagged, and no cited test name changes; the code and the tests change nothing. The text before it
(amendments 1 to 10) is the approved copy `evidence/site-slider/plan-approved.md` it amends (sha256
`73c5b576a6dd444eb96368b3eb9e63507467a633922d0a94d4f00995fb40627c`).

- **Amendment 1 (review 1's R1-3, P2; Question 4's answer A read another way; to be confirmed with Justin):** the plan
  said a Bricks tier takes "the site's value at each Bricks tier's widest width (991/767/478)". Swiper applies a
  breakpoint from its width up, and Elementor's own Swiper keys are 0/767/1024 (its `adjustConfig`), so the one sample
  at 767 read the tablets' values for the whole of 479-767: Elementor's default Image Carousel (3 slides in view on the
  desktop, 2 on tablets, 1 on phones) pasted 2 side by side from 479 to 766 where the site shows 1. Now each tier
  (768-991, 479-767, 320-478) takes what the site shows across most of its widths: a site key inside a tier cuts it
  in parts and the widest part wins, the wider screens' part when two are as wide; a site key under 320 is no tier's;
  the desktop value is what the site shows at the design width; a `perPage:<bp>` or `gap:<bp>` key is written only
  where a tier differs from the one wider than it. A tier the site cuts, and a site switch between 992 and the design
  width, are named in the slider's note with the part that wins. What still differs from the site for Elementor's own
  keys, both named in that note: at exactly 767 the paste shows the phones' count (1 for the default carousel) where
  the site already shows the tablets' (2), and at 992-1023 the desktop's (3) where the site shows the tablets' (2).
  Changed: Question 4's answer A, the rule's "Per view and gap" line, the Notes list, and the pointer in the settings
  criterion (the second). That criterion's cited test asserts it at `84e591db` in these rows (Swiper keys → Bricks'
  keys): 3/2/1 on 0/767/1024 → `perPage "3"`, `perPage:tablet_portrait "2"`, `perPage:mobile_landscape "1"`; the same
  with gaps 24/24/12 → also `gap "24"`, `gap:mobile_landscape "12"`; a switch at 700 (0/700/1024) → the tier's lower
  part (`perPage:mobile_landscape "1"`); at 480 (0/480/768/1200, 1/2/3/4) → its upper part (`perPage "4"`, tablets
  `"3"`, sideways phones `"2"`, upright phones `"1"`); two switches at 500 and 740 (0/500/740/992) → the middle part
  (the same four keys); a switch at 880 in 768-991 (0/600/880: two parts as wide) → the wider screens' (`perPage "3"`,
  no tablet key, sideways phones `"2"`, upright phones `"1"`); a key at 300 (0/300/768) → no tier's (`perPage "3"`,
  `perPage:mobile_landscape "2"`, no upright-phone key). Under the old reading the 3/2/1 row would have read
  `perPage:tablet_portrait "2"` and `perPage:mobile_portrait "1"` (2 slides across all of 479-767). Supporting tests:
  `test/unit/site-slider.test.ts` › "a Bricks tier takes what the site shows across it; a site switch inside a tier is named with the part that wins"
  `test/web/site-elementor-carousels.test.ts` › "Elementor's default Image Carousel shows the site's count of slides at every width"
  The second reads the site and the paste at 1440, 1100, 1024, 991, 800, 768, 766, 700, 600, 480, 479, 478, 390 and
  320: the same count of slides in the frame, the first slide within 2 px of the site's, and the note "its per view
  switches at Bricks' widths 991/767/478; the site switches at 767, 1024 (each from that width up): 992 and up takes
  what the site shows at 1440, 479-767 what it shows under 767"; 1000 and 767 are read for the record only.
- **Amendment 2 (review 1's R1-1, P2):** arrows, dots and the loop were read only from Elementor core's keys
  (`navigation`, `arrows`, `infinite`). Pro's carousel base (Media, Testimonial and Reviews Carousels) prints
  `show_arrows`, `loop`, `slides_per_view` and `space_between` instead, and Elementor prints no key at all for a
  switch that is off, so a Testimonial Carousel pasted with no arrows (the site's removed, Bricks' never switched on)
  and ran back to its first slide where the site loops. Now each of the three is on when a key of either family says
  so (the loop also by Swiper's own `loop` param where the capture holds it), or, where no key names it, when the
  captured page shows it: an arrow element or the dots' row shown at some width, Swiper's copies of the slides in the
  row. A part read off the page is named ("its settings don't say, the page shows: …"). A missing key is never read
  as "off" by itself and never takes Bricks' or the widget panel's default; autoplay and its pause are the exception
  (nothing on the page shows them: on only when their key says so). Without Swiper's params, per view is
  `slides_to_show` or `slides_per_view` and the gap `image_spacing_custom` or `space_between`. A missing speed or
  autoplay delay takes Swiper's own default (300 ms, 3000 ms), named (was "leave Bricks' default and name it"). A
  widget whose settings aren't in the page at all doesn't play by itself, and its arrows, dots and loop are as the
  page shows them. Site arrows or dots that no key names and the page never shows are left out with Bricks' off
  ("never shown on the page"). Changed: the rule's Structure line on arrow and dot elements, "Where each value comes
  from", the builder's source line, Loop, "Per view and gap", Controls and Notes, and the pointer in the settings
  criterion. That criterion's cited test asserts it at `84e591db` in these rows: Pro's Testimonial Carousel
  (`show_arrows`, `loop`, bullets, autoplay 5000 + 500 with its pause, `space_between` 10) → `{height "auto", gap
  "10", autoplay true, interval "5500", speed "500", pauseOnHover true, pauseOnFocus true, arrows true, pagination
  true}`; Pro's base with arrows, loop and pause off (no key printed) → `{height "auto", autoplay true, interval
  "5500", speed "500", type "slide", rewind true, pagination true}`; `show_arrows` and `loop` alone → `{height "auto",
  speed "400", arrows true}`; no Swiper params: `slides_per_view "2"` with `space_between` 16, or `slides_to_show "2"`
  with `image_spacing_custom` 8 → `perPage "2"` and `gap "16"` or `"8"`; settings naming none of the three with all
  three on the page → `{height "auto", speed "300", arrows true, pagination true}`; only arrows on the page → arrows
  with `type "slide"`, `rewind true`; only dots → pagination with `type "slide"`, `rewind true`; only Swiper's loop
  copies → `{height "auto", speed "300"}`; no settings at all with arrows and loop copies on the page → `{height
  "auto", speed "300", arrows true}`; no settings and nothing on the page → `{height "auto", speed "300", type
  "slide", rewind true}`; Swiper's `loop: true` param alone → `{height "auto", speed "300"}`. Supporting tests:
  `test/unit/site-slider.test.ts` › "a carousel printing Pro's keys, or none, keeps the arrows and the loop its page shows"
  `test/unit/site-slider.test.ts` › "a part the settings don't name is decided from what the page shows, and named"
  `test/unit/site-slider.test.ts` › "dots the settings don't name are the page's too"
  `test/web/site-elementor-carousels.test.ts` › "a Testimonial Carousel printing Pro's keys pastes with its arrows and its loop"
  The last one draws it: settings `{height "auto", gap "10", speed "600", arrows true}`, Next shows slide 2, Previous
  on slide 1 shows slide 3, and Next on the last slide keeps the row moving left on to slide 1 (Splide's type `loop`).
- **Amendment 3 (review 1's R1-2, P2):** Bricks reads a slider's checkboxes with `isset()` (Bricks 2.2's GPL
  `includes/elements/slider-nested.php` `render()`, the newest public source: `'pauseOnHover' => isset(
  $settings['pauseOnHover'] )`, the same for `autoHeight`, `autoplay`, `pauseOnFocus`, `arrows` and `pagination`), so
  a key stored `false` counts as ticked. The builder wrote `pauseOnHover: false, pauseOnFocus: false` for a carousel
  that autoplays without pause on hover: on a live page it would stop under the pointer where the site keeps moving.
  Now a Bricks checkbox key (`autoplay`, `pauseOnHover`, `pauseOnFocus`, `rewind`, `arrows`, `pagination`) is written
  only when true and left out otherwise, the pause keys only where the site autoplays, and the site renderer reads
  each slider checkbox as Bricks' PHP does (a stored value, `false` too, is ticked; `rewind` is printed only when the
  type isn't a loop). Changed: the rule's Autoplay and Controls lines, Task 1's renderer line, and the pointer in the
  settings criterion (its own words, "no hover pause → … `arrows` unset", already fit). That criterion's cited test
  asserts at `84e591db`, over every row, that no boolean other than `true` is written, and these rows: the fixture's
  image carousel (autoplay 800 + 400, fade, dots, no pause key printed) → `{height "auto", autoplay true, interval
  "1200", speed "400", type "fade", rewind true, pagination true}`; not looping, autoplay 3000 + 500, `navigation
  "both"` → `{height "auto", autoplay true, interval "3500", speed "500", type "slide", rewind true, arrows true,
  pagination true}`; the Slides widget's `transition_speed` 900 with autoplay 1000 → `{height "auto", autoplay true,
  interval "1900", speed "900"}`; a pause on hover printed without autoplay → `{height "auto", speed "300"}`. Up to
  `1b193b45` the first three of these rows also held `pauseOnHover false, pauseOnFocus false`. Supporting tests:
  `test/unit/site-slider.test.ts` › "the site renderer reads a slider's checkboxes as Bricks does: a stored false counts as ticked"
  `test/web/site-elementor-slider.test.ts` › "a carousel without pause on hover keeps playing under the pointer and with the focus in it"
  The second: the image carousel's settings hold no key starting `pauseOn`, its `data-splide` prints `autoplay true,
  pauseOnHover false, pauseOnFocus false`, and it starts at least one move in 3 s under the pointer and at least one
  in 3 s with the focus in it.
- **Amendment 4 (review 2's R2-2, P2; fix round 2, under way: set this line against fixer 2's head before the next
  review):** the plan's restore class was "at weight (0,1,0) … the site's own classes printed later beat them", and
  the reset criterion (the fourth) said its text "equals the scoped … `splide-layer.min.css`". As built, each rule is
  scoped `:where(.<name>, .<name> *)<selector>` and keeps its own selector's weight, so `.splide__slide img {
  vertical-align: bottom }` (0,1,1) changes a picture the site leaves on the baseline: Elementor's default Image
  Carousel pastes 7 px shorter than the site (277 px on the site and in main's paste, 270 px at `84e591db`), past
  site:check's 2 px. The rule now: the restore class brings back what Bricks' layered Splide CSS needs for the slider
  to work, and no restored rule changes what a slide's own content computes against the site; a rule that would is
  left out or scoped to weigh nothing (fixer 2's choice between review 2's two fixes; this wording holds for both).
  Changed: the rule's "Splide restored under the reset" lines and the "equals" clause of the fourth criterion. Its
  cited unit test keeps its name; at `84e591db` it still asserts all 41 rules of the reference file, the picture rule
  among them, so its expected rule list changes with fixer 2's commit.
  - **R2-1 and R2-3 change no criterion.** The third, fifth and sixth criteria cover them as written (the first
    slide's box within 2 px of the site's first slide; each arrow's drawing box within 2 px of the site's; the dots'
    row within 2 px of the site's), and the rule's own sentence on places ("copied only when the arrow's containing
    block has the slider root's box at every captured width") is what R2-3 asks for: the code refused the site's
    places whenever the Swiper root wasn't positioned, which the plan never said. Both passed only because the
    fixtures lacked the shape (Elementor's own static Swiper root; a Slides widget whose slide takes its height from
    its class alone, which Splide's inline `height: auto` cancelled: 0 px tall). Fixer 2 adds that fixture; its new
    tests are supporting tests of those three criteria.
    *(amendment 7)* Corrected: R2-3 still changes no criterion, but the rule's sentence on places quoted here was
    not what R2-3 asks for, and it is reworded (the Look list's arrows and dots lines). *(amendment 8)* R2-1 changes
    no criterion either; it adds a line to the Look list ("A slide's own height").
  - **One line to re-read when fixer 2 returns:** the rule's `height: "auto"` and the B-Dry criterion's `height
    "auto"` stand as written if the fix keeps that setting and carries the site's slide height in the slider's look;
    if it writes a height into the setting instead, those two lines need an amendment of their own.
    *(amendment 8)* Re-read at `a97b102c`: both stand as written. The fix keeps `height: "auto"` in the setting
    and carries a slide's own height in the slider's look.
- **Amendment 5 (editorial):** four cited test names were wrapped across two lines in the approved copy (those of
  the first, second, third and seventh criteria). `ac-check.sh` matches plan lines one by one, so each now sits whole
  on one line. No word of a name changed.
- **Amendment 6 (the builder's reading, raised by no review; reconciled here because the settings criterion's cited
  test asserts it):** the plan said "fade → `type: "fade"`"; a fade is written only where one slide is in view at
  the design width, because Elementor's handlers set the effect only then (the row `effect "fade"` with Swiper's
  `slidesPerView 2` → `{height "auto", speed "400", perPage "2"}`; the builder's mutant M7). Changed: the rule's Loop
  line.
- **Amendment 7 (review 3's R3-2, P3; fixer 2's fix of R2-3 as built, `b6565996`):** the plan said an arrow's place
  values are copied "only when the arrow's containing block has the slider root's box at every captured width", and
  amendment 4 called that sentence what R2-3 asks for. It isn't what the head does
  (`src/core/site/elementor-slider.ts` `placedLike`). The site's place values of the arrows, and of the dots' row,
  are copied whenever the box the part answered to on the site is the box Bricks' own part answers to in the paste.
  On the site that is the nearest positioned box above the part (a `position` other than `static`, or a transform).
  In the paste Bricks' arrows and dots sit inside the slider, so it is the slider itself where it is positioned there
  (the site's root positioned, or declaring no position at all: the restore class's `.splide { position: relative }`
  then holds), else the nearest positioned box above the root. Elementor makes the Swiper root `position: static` on
  its Image Carousel and on every Pro main swiper, so there both sides answer to the widget's box, whatever its size,
  and the site's places are copied as they are. The two are one box when they are the same element, or two elements
  the capture measured alike (within 0.5 px) at every width of the range; a box the capture folded into its only
  child is read through that child. It is judged in every kept range where the part is placed (`position:
  absolute`); a part fixed to the window in any range, or one with no positioned box above it, never has its places
  copied: it gets Bricks' places, named. Was, up to `ba98025b`: Bricks' places for every root that wasn't positioned
  (on a default Image Carousel the arrows 10 px nearer each side and 11.5 px lower than the site's, the dots' row
  17 px off). A padded widget (its box 60 px wider than the root), arrows outside the pictures and margins on the
  widget container all keep the site's places, 0 px from the site (review 3, `~/.cache/ssl-r3/out/r3a.log` and
  `r3m.log`). Changed: the Look list's arrows and dots lines, the Notes list (the two notes' words), Task 3's
  pointer, the Risks line on arrow places and amendment 4's sub-bullet. The fifth and sixth criteria say nothing on
  which box a part answers to and stand as written (the sixth's words on the dots' count are amendment 9's).
  Supporting tests:
  `test/unit/site-slider.test.ts` › "arrows whose box isn't the slider's keep Bricks' places, named"
  `test/unit/site-slider.test.ts` › "a root that isn't positioned: the arrows and dots answer to the box above it on the site and in the paste alike, and keep the site's places"
  `test/unit/site-slider.test.ts` › "a root that declares no position is positioned in the paste (Splide's own rule, restored): parts placed above it on the site keep their places only where that box is the root's"
  `test/unit/site-slider.test.ts` › "a part fixed to the window, or with no positioned box above it, keeps Bricks' places, named"
  `test/unit/site-slider.test.ts` › "an arrow placed in a box the capture folded into its only child reads that child's box (B-Dry's widget box)"
  `test/web/site-elementor-swiper8.test.ts` › "the arrows and dots sit where the site puts them when they answer to the box Bricks' own answer to"
  The last one reads the site and the paste at 1440, 1100, 800, 600 and 390 on a page laid out by Elementor's own
  code (Pro's Slides and two default Image Carousels, their roots not positioned): every arrow and dots' row within
  2 px of the site's, and no note saying a part sat in another box.
- **Amendment 8 (fixer 2's fix of review 2's R2-1 as built, `7feeeb3d`; fixer 2's ruling, to be confirmed with
  Justin):** the Look list had no line for a slide's own height. Bricks hands the slider's Height (`auto`) to Splide,
  which writes it inline on every slide (`style="height: auto"`), so a height a slide's own class sets never applies:
  Elementor Pro's Slides sizes its slides only that way (`.swiper-slide { height: 400px }`, nothing in a slide in
  flow) and pasted 0 px tall. Now a height a site slide declares itself (anything but `auto` or a keyword that means
  it; a percentage too) is repeated `!important` on the slider's class per run of kept ranges: on every slide where
  the slides agree, else on each slide by its own class (slides sharing a class share one rule). The row's own
  height, but Swiper's `100%`, is written on Splide's list (without `!important`: Splide writes no height there).
  Slides the site sizes by their content get no rule and keep `height: "auto"`. The setting itself stays `height:
  "auto"`, so the rule's settings line and the B-Dry criterion's `height "auto"` stand as written: that settles
  amendment 4's "one line to re-read". The ruling to confirm: the height is carried in that `!important` CSS line
  because it is exact at the site's own widths and per slide, where the slider's Height setting is one value for
  every slide and switches only at Bricks' tiers; the price is that it is edited in that line of the slider's class
  CSS (or by deleting the line and setting the Slider's Height), not in the slide's own Height control. Changed: the
  Look list (a new line), the settings line on `height` (a pointer), Task 3's pointer and amendment 4's last
  sub-bullet. Supporting tests:
  `test/unit/site-slider.test.ts` › "a slide keeps the height the site gives it: on the slider's class, !important, per run of ranges"
  `test/unit/site-slider.test.ts` › "slides whose heights differ each keep their own, by their own class (Splide's copies of a slide carry it)"
  `test/unit/site-slider.test.ts` › "the row's own height is Splide's list's (slides that fill a row of a set height)"
  `test/web/site-elementor-swiper8.test.ts` › "Pro's Slides widget is as tall as the site's: a slide keeps the height its own class gives it"
  The last one: the site's slider and first slide are 400 px tall at 1440, 1100, 800, 600 and 390, and the paste's
  are within 2 px of them (0 px tall at `84e591db`).
- **Amendment 9 (review 3's R3-3, P3; review 2's R2-4, deferred):** the sixth criterion said the dots appear "one per
  real slide". Its cited test proves that on its carousel, which shows one slide at a time: 3 dots at 1440 and at
  390, the site's 3 bullets. Splide draws one dot per page of slides, so a carousel showing several slides at once
  gets fewer dots than the old site, which drew one per slide (review 2, six pictures: 6 dots on the site at every
  width, 2 in the paste at 1440 and 1100, 3 at 800, 6 on phones). The dots are left as Bricks draws them (one per
  slide would need Splide's `perMove` or a custom pagination: its own decision), and since `0059fc45` the paste's
  note names it wherever a slider with dots shows more than one slide at the design width or at a Bricks tier.
  Changed: the sixth criterion's words (it now says where "one per real slide" holds and names the difference; its
  cited test name is unchanged), the Look list's dots line and the Notes list. Supporting tests:
  `test/unit/site-slider.test.ts` › "dots on a carousel showing several slides at once are named: Bricks draws one per page of slides"
  `test/web/site-elementor-swiper8.test.ts` › "a carousel showing several slides at once: Bricks' dots are one per page of slides, named"
- **Amendment 10 (review 3's R3-1, P3; amendment 1's named difference; to be confirmed with Justin):** amendment 1
  named the two places where, on Elementor's own keys, the paste shows another count of slides than the site:
  exactly 767, and 992-1023. `site:check --all --elementor` reads both, because 992 and 767 are among the capture's
  own widths. On a default 3 / 2 / 1 carousel whose pictures fill their slides, at 992 the paste shows the desktop's
  count (3) where the site shows the tablets' (2), and at 767 the phones' count (1) where the site shows 2. The
  carousel's height then differs and the check fails with two red rows, every other width within 0.01 px. Measured
  in review 3 on `a97b102c`: at 992 the paste is 26 px a carousel shorter with 360 px pictures and 100 px with
  800 px ones; at 767 it is 225 px taller with 800 px pictures, and no different where the pictures are narrower
  than half the row (`~/.cache/ssl-r3/out/check-360-head.log`, `check-big-head.log` and `r3big.log`; fixer 2's
  `fixer-2/probes/rows-360px-pictures-r21-r22-fixed.txt`). It was so at `84e591db` too: it is amendment 1's ruling,
  not a regression. No criterion's fixture has that shape: the seventh criterion's fixture and B-Dry's hero show one
  slide at every width, and the pictures of `test/fixtures/web/sites/elementor-swiper8` are 300 px wide so that its
  own check stays green (its comment says so). That fixture proves fixer 2's three fixes, not that a photo carousel
  passes the check on a real site. Exact site switch widths would need Splide's own `breakpoints` through Bricks'
  custom options, a change of Question 4's answer A: Justin's call. Changed: Question 4's answer A (one marked
  sentence). HANDOFF and the fixture's comment at `a97b102c` name 992 only (the merge finisher adds 767).
- **Left as written (fixer 2, `0059fc45`):** `site:check` now reads a looping slider's real slide, never Splide's
  copy of it (`test/web/lib/site-check.ts`: a copy keeps its content's ids and comes first in the page where several
  slides show). No line of this plan says which element the check reads inside a slider (the seventh criterion, root
  cause 3(c) and Task 5 speak only of holding the slider on its first slide), so nothing is added.
- **Amendment 11 (the ninth criterion's input only; the stack finisher's finding, `evidence/site-slider/stack-1/`):**
  since Build 2026-11-09.4 (staging-fit-capture, main `3cfc54ac`) `npm run site`, `site:check`, `capture:check` and
  the panel refuse Justin's saved 2026-11-09 capture: it read widths 768–991 from page loads without the site's
  stylesheets. The refusal is right and stays. The ninth criterion now reads a clean B-Dry capture: Justin's
  re-capture made with Build 2026-11-09.4 or later once it exists, the stand-in named there until then. Its three
  clauses and its cited test name are unchanged; changed are the line naming the file (and main's paste and report,
  remade from the same file), "the capture's 48 widths" (every width the capture read) and "on the saved capture".
  The "outside 768–991" clause stands: the test's own code compares only those widths (a fixed filter), and on a
  clean capture it still compares exactly what the clause says. The code changes nothing.
  - The clean captures on this machine, each checked with `7d9754ed`'s own `capture:check` and `unstyledRanges`
    (`~/.cache/ssl-pa3/capture-check.log`, `t1.log`): none is refused (no exit 2, no styleless range); each fails
    `capture:check`'s other checks (16 shown pictures without bytes, 15 nodes without a stored picture: the saved
    page's), which `site`, `site:check` and the test don't refuse on. All are code version 3 (the version the head
    reads), 12 ranges, 38 widths, one Swiper of 3 slides, and give the hero AC9's exact settings, its 3 Blocks, no
    Elementor arrow element and the pause note: `evidence/elementor-phone-fit/planner/bdry-standin.f2b-capture.json`
    (build stamp 2026-11-08.1, captured 2026-11-08T21:14Z, no sheets record; chosen),
    `~/.cache/sm-b/bdry-standin-v3.f2b-capture.json` and `-v3b` (2026-11-07.1), site-menu's
    `fixer-1/bdry-dryrun/*/standin-menu.f2b-capture.json` (2026-11-09.3, made by site-menu's unmerged tree, with
    its extra `web.code.opens`), and `~/.cache/sfx-b/caps/bdry-standin-head.f2b-capture.json` (2026-11-09.4 stamp,
    sheets recorded, made by staging-fit-cancels' unmerged tree `b0fd064a`). The chosen one sits in an evidence
    folder (the others are in scratch caches or carry another job's capture fields) and is the stand-in earlier B-Dry
    jobs proved on; site-native-structure's fixer 1 holds no capture.
  - Not needing a fixer: the test's code doesn't assume the styleless ranges except its fixed 768–991 filter in the
    second test, which on a clean capture only leaves those widths out. A scratch probe with the filter removed
    (`~/.cache/ssl-pa3/probe-every-width.log`) measured 3 elements, worst 0 px at every width of the stand-in,
    768–991 included; widening the clause is a follow-up, not part of this amendment. The test's header comment
    (Justin's 2026-11-09 capture, "48 widths") and HANDOFF's site-slider lines ("all 48 widths", the 768–991 known
    limit) are records the merge finisher brings up to date.
- **Receipts that still encode the old expectations** (all under `evidence/site-slider/`). Sorted by
  `git show <head>:test/unit/site-slider.test.ts | grep -c '768: { slidesPerView'` (the old tier row, on a Swiper key
  768 Elementor never prints: 1 from `23c05e21` to `1b193b45`, 0 from `3ba7315c` on),
  `grep -c 'speed: "[0-9]*", pauseOnHover: false'` (the rows pinning a stored `false`: 3 up to `1b193b45`, 0 from
  `3ba7315c` on) and `git show <head>:test/browser/render-slider.ts | grep -c isset` (0 up to `1b193b45`, 7 from
  `3ba7315c` on):
  - Amendments 1 and 3, the settings criterion's cited test passing on the old rows (a tier sampled at its top, on
    keys 0/768/1024; three rows with both pauses `false`): `builder/logs/final-ac-unit.log`, `check-head.log` and
    `unit-head.tap` (`a9617cbc`); `builder/cont/logs/final-ac-unit.log`, `check-head.log` and `unit-head.tap`
    (`6e3094cc`); the terminal shots `builder/shots/ac2-terminal.png` and `builder/cont/shots/ac2-terminal.png`; the
    unmutated controls `builder/mutation/control.log`, `builder/mutation2/control.log`,
    `builder/cont/mutation/control.log` and `builder/cont/mutation-final/control.log`; `fixer-1/logs/green-unit-wip.log`
    (a dirty tree on `1b193b45`). `fixer-1/logs/red-unit-1b193b45.log` and `red-unit.log` are the RED (the new rows on
    `1b193b45`'s converter, the old behaviour by design). `fixer-1/logs/unit-compare.txt` shows the expected
    difference by name: five tests "— → pass", every other result the same. The current receipts are
    `fixer-1/logs/final-ac-unit.log` and `unit-head.tap` (`7170a5a3`; the two commits after it hold only the ledger).
  - The builder's mutants killed through that test (`builder/cont/mutation-final/results.json`: M4 interval, M5
    pauseOnFocus as pauseOnHover, M6 not looping → slide, M7 a fade only with one per view, M8 the gap): M5 died on
    the nested carousel's and B-Dry's rows, whose expected values are unchanged, so it stays valid; M6's guard now
    also reads Pro's `loop`, Swiper's param and the page (fixer 1's A22 is its successor); M4, M7 and M8 were run
    again by fixer 1. No builder mutant touched the tier sample. Fixer 1's run (`fixer-1/mutation/`, 71 mutants on
    `7170a5a3`: 69 killed by an assertion; M33 and M18 crash kills, as its ledger says) is the current proof: A1 to
    A25 for amendment 2, B1 to B8 for amendment 3, C1 to C14 for amendment 1.
  - Amendment 3 in the browser: every run of `test/web/site-elementor-slider.test.ts` up to `1b193b45`
    (`builder/logs/final-ac-fixture.log`, `builder/cont/logs/final-ac-fixture.log`, the builder's `gates/head-web`
    logs of that file) drew the image carousel from a paste storing both pauses `false`, with a renderer that read
    `false` as off; no assertion read it, so they prove nothing about a carousel without a pause. The builder's M32
    (`builder/cont/mutation-pause-1/M32.log`, `mutation-final/M32.log`: the mutant `pauseOnHover: false`, judged by
    that renderer) is no longer a mutant that removes the pause: a stored `false` is ticked. Fixer 1's B6 (the pause
    where the site has it, the builder's M32 again), B1f and B2f (a stored `false` stops the slider) replace it;
    `fixer-1/logs/red-fixture.log` is the RED and `final-ac-fixture.log` the GREEN.
  - Amendment 2 has no earlier passing receipt (no row or fixture printed Pro's keys before `3ba7315c`):
    `fixer-1/logs/red-carousels.log` is the RED and `final-carousels.log` the GREEN.
  - Amendment 4: every pass of the fourth criterion's unit test up to `84e591db` asserts the picture rule among the
    41 (`grep -c 'SPLIDE_RULES.length, 41'` is 1 at every head from `23c05e21` to `84e591db`), fixer 1's
    `logs/final-ac-unit.log` included, and the builder's M3 (the track rule) is unaffected. Review 2's readings are
    outside the evidence folder (`~/.cache/ssl-r2/out/real-head.json`, `real-base.json`, `real-head-valign.json`).
  - HANDOFF at `84e591db` already states amendments 1 to 3 (its "Settings" sub-bullets and "The ⭐ answers" line) and
    amendment 6 ("a fade (one per view only)"); it lists R1-4, the same rule as R2-2, under "Deferred", which fixer 2
    takes out.
  - *(amendments 7 to 10)* These four are wording only: the tests at `a97b102c` already assert them, so no receipt
    on `a97b102c`, or on `b9a084ad` (fixer 2's final receipts: `fixer-2/logs/final-*.log`, `ac9-final.log` and
    `unit-head.tap`; the one commit after it holds only the ledger), encodes an old expectation. Fixer 2's
    `green-unit-r2*.log` and `wip-*.log` ran on dirty trees and are receipts for no head. Earlier heads are sorted
    with `git show <head>:test/unit/site-slider.test.ts | grep -c "sat in a box other than the slider's"` (the old
    places note: 2 from `a9617cbc` to `ba98025b`, 0 from `b6565996` on), `grep -c 'height: 400px !important'` (0 up
    to `cb397e5c`, 2 or more from `7feeeb3d` on), `grep -c 'dot per page'` (0 up to `b6565996`, 4 from `0059fc45` on)
    and `grep -c ':where(:where('` (0 up to `7feeeb3d`, 3 from `ba98025b` on).
  - Amendment 7: every pass of the unit file from `a9617cbc` to `84e591db` (the builder's and fixer 1's
    `unit-head.tap`, `check-head.log` and `final-ac-unit.log`) holds the supporting test "arrows whose box isn't the
    slider's keep Bricks' places, named" with the old note, "its arrows sat in a box other than the slider's: Bricks'
    places (its sides, the middle)". Its case (a positioned root whose arrows answered to a box measured otherwise)
    gets Bricks' places under both wordings; only the note's words changed, to "its arrows were placed in another box
    than the one Bricks places its arrows in". No receipt before `cb397e5c` reads a root that isn't positioned (no
    fixture had the shape). The fifth and sixth criteria's cited tests are in a file that is the same at `84e591db`
    and `a97b102c` (`test/web/site-elementor-slider.test.ts`), and pass at both (`fixer-1/logs/final-ac-fixture.log`,
    `fixer-2/logs/final-ac-fixture.log`). `fixer-2/logs/red-swiper8.log` and `red-unit.log` are the RED (`b9a084ad`'s
    tests and fixture on `84e591db`'s converter: the old behaviour by design), `final-swiper8.log` and
    `final-ac-unit.log` the GREEN. Fixer 2's mutants, run again on `b9a084ad` (`fixer-2/mutation-head/`: 48, none
    survived), are the current proof.
  - Amendment 8: no receipt before `7feeeb3d` asserts anything on a slide's own height (that commit's tests are the
    first), and the B-Dry criterion's `height "auto"` is the same at every head.
  - Amendment 9: the sixth criterion's cited test asserts 3 dots against the site's 3 bullets at `84e591db` and at
    `a97b102c` alike; no receipt before `0059fc45` reads dots on a carousel showing several slides at once, and none
    asserts a dot per slide there.
  - Amendment 10: no receipt asserts that `site:check` passes on a 3 / 2 / 1 carousel whose pictures fill their
    slides. `fixer-2/swiper8-check/head.log` and `fixer-2/logs/final-swiper8.log` pass on 300 px pictures, by design.
  - Amendment 4 against `a97b102c`: `grep -c 'SPLIDE_RULES.length, 41'` is still 1 at every head, so it no longer
    sorts them; `grep -c ':where(:where('` does. The fourth criterion's cited unit test passes on the old expected
    text (every selector at its own weight, the picture rule too) up to `7feeeb3d`, fixer 1's
    `logs/final-ac-unit.log` and `unit-head.tap` included; `fixer-2/logs/final-ac-unit.log` (`b9a084ad`) is the
    current receipt.
  - *(amendment 11)* Every B-Dry receipt up to and including the stack's `7d9754ed` ran on the capture main now
    refuses (`/home/justin/f2b-test/bdryswi-com-home.f2b-capture.json`, sha256 `2aab92b7…56b94`, styleless ranges
    922-991, 835-921, 769-834 and 768-768), with main's pastes and report made from it
    (`builder/bdry/base-*`, `builder/bdry-check-base/report.json`, from `fd1986dc`): `builder/logs/ac9-head2.log`
    and `ac9-final.log`, `builder/cont/logs/ac9-final.log` and `red-main-ac9.log`, `builder/mutation4/M2g.log`, the
    builder's and fixer 1's `gates/head-web/driver.log`, `fixer-1/logs/ac9-final.log`, `fixer-2/logs/ac9-final.log`
    and `fixer-2/gates/head-web/site-slider-bdry.test.log`, review 3's run (`~/.cache/ssl-r3/out/bdry-test.log`) and
    the stack finisher's `stack-1/logs/test_web_site-slider-bdry.test.ts-ac9-named.log`,
    `stack-1/logs/ac9-site-check-output.log` and `stack-1/first-pass-12fc9848/`. The difference now expected: the
    same three tests on the clean capture, with base inputs remade from it; the third no longer stops at
    `ENOENT … report.json`. The first two convert the capture with `siteParts` themselves (no refusal there), so
    they passed on the refused file too; only the third runs `tools/site-check.ts`, which refuses it (exit 2). Those
    receipts stay valid as records of the refused file, never as AC9's receipt for a head. The planner's check of
    the stand-in on `7d9754ed` (`~/.cache/ssl-pa3/`, outside the evidence tree, no receipt for any role): all three
    tests pass (`ac9-all-epf.log`: one heading in the frame at all 38 widths, 768–991 included; 3 elements, worst
    0 px; new failing rows inside the hero slider 0; `EXIT=0`), with main's paste and report made by `3cfc54ac`.

## Questions (the standing auto-go takes the ⭐ answers)

- **Q1. Which pastes get the working slider?**
  - **A ⭐ The Elementor route (`--elementor`), for every Elementor widget holding a slider the capture lists**
    (`web.sliders`: Elementor's Nested Carousel, Image/Media/Testimonial Carousel, Slides, Loop Carousel all use
    Swiper). Its settings come from Elementor's own widget settings, which every capture already keeps
    (`data-settings`), so Justin's saved capture works without a new capture. The plain route stays byte-identical,
    with your 2026-11-06 "Keep all its slides" static slider.
  - B. Both routes. A slider that isn't in an Elementor widget would also convert, but its timing would have to come
    from the slider library itself. Today's capture cuts that record at 60 keys and loses autoplay, loop, effect,
    navigation and pagination (`src/web/readers/libraries.ts:84`). So B needs a capture change and a new capture, and
    it rewrites your 2026-11-06 ruling's tests on the plain route.
- **Q2. How the slides glide.**
  - **A ⭐ On the site's own timing curve:** the row's own `transition-timing-function`, or `ease` when the site sets
    none, as Swiper does. That is one CSS line on the slider's class
    (`.<cls> > .splide__track > .splide__list { transition-timing-function: … !important }`), because Splide writes
    its curve inline.
  - B. Splide's default curve (`cubic-bezier(0.25, 1, 0.5, 1)`). At 2.5 s it visibly starts faster and settles
    longer than the site.
- **Q3. The arrows.**
  - **A ⭐ The site's own drawing, place, size and colour.** Bricks' arrows (`arrows: true`) are used, but their
    look comes from the site's arrow elements as custom CSS on the slider's class: each arrow's own declarations per
    range, and its SVG as a CSS mask in its colour, with Splide's default SVG hidden. Bricks' "Prev/Next arrow" icon
    controls stay empty.
  - B. Bricks' own arrow icon (Splide's chevron) in the site's colour and size at the site's place, editable in the
    slider's Arrow controls. The chevron is drawn a little differently from the site's.
- **Q4. A slider that shows a different number of slides, or a different gap, at some widths.**
  - **A ⭐ Bricks' per-breakpoint keys** (`perPage:<bp>`, `gap:<bp>`). *(amendment 1, to be confirmed with Justin)*
    Each Bricks tier (768-991, 479-767, and 478 down to 320) takes what the site shows across most of that tier's
    widths: a site switch inside a tier cuts it in parts and the widest part wins, the wider screens' part when two
    are as wide; the desktop value is what the site shows at the design width. Was: "using the site's value at each
    Bricks tier's widest width (991/767/478)", which read the tablets' values for every sideways phone on Elementor's
    own keys (0/767/1024). The switch happens at Bricks' widths, and the note names the site's own widths
    *(amendment 1)* and every tier the site cuts, with the part that wins. For Elementor's default 3 / 2 / 1 carousel
    the paste shows 3 from 992 up, 2 at 768-991 and 1 from 767 down; the site shows 2 at 767 itself and at 992-1023,
    both named. *(amendment 10, to be confirmed with Justin)* `site:check --all --elementor` reads both, at the
    capture's own widths 992 (the paste shows the desktop's count) and 767 (the paste shows the phones' count): on
    such a carousel whose pictures fill their slides it fails at those two widths and passes at every other.
    `gap:<bp>` is proven (`card-row-and-phone-slider.json`). `perPage:<bp>` isn't: it waits for the "Slider with
    slides per view changed for phones" sample (README "Still wanted"). Live data-splide printing of `height:<bp>` under
    `breakpoints` (darksalmon home, 2026-11-09) shows Bricks prints per-breakpoint options that way.
  - B. One value, the design width's, with a note.

B-Dry's hero needs none of Q4: it shows 1 slide with a 10 px gap at every width.

## Playback (what Justin asked)

1. On B-Dry staging (`/homev2/`, pasted from `whole.json` of build 2026-11-09.3 with `--elementor`), the hero slider
   (basement photo, "The Tri-State's Waterproofing Experts", ‹ › arrows) stands still. Its arrows do nothing.
2. At 990 in the Bricks editor its three slides show stacked, one under another (images/9.png).
3. He wants a site's slider (Elementor's carousels / Swiper and the like) to become Bricks' Slider (Nestable). It
   should show one slide at a time and play like the site at every width: its slides, autoplay timing, transition,
   arrows, dots and pause on hover.

## What the site does (capture `/home/justin/f2b-test/bdryswi-com-home.f2b-capture.json`, build 2026-11-09.1)

- `web.sliders[0]` is a Swiper (`library: "swiper"`). Its root is
  `…/article:0/div:0/div:0/div:0/div:0/div:0/div:0`, the `.e-n-carousel.swiper` element. It lists 3 real slides,
  `…/div:0/div:{0,1,2}`, and the loop copies `div~0`/`div~1` are script-made (`evidence/…/sliders.txt`, `tree.txt`).
- It sits in Elementor widget `1a9321c`, `elementor-widget-n-carousel`, whose `data-settings` is in the capture's
  marks (`settings.txt`). The settings are: `speed 2500`, `autoplay "yes"`, `autoplay_speed 5000`,
  `pause_on_hover "yes"`, `pause_on_interaction "yes"`, `infinite "yes"`, `arrows "yes"`, no `pagination`,
  `slides_to_show(_tablet/_mobile) "1"`, `image_spacing_custom 10px`.
- Swiper's own params as captured: `speed 2500`, `spaceBetween 10`, `slidesPerView 1`, and breakpoints 0/767/1024/1366/2400,
  all at 1 per view. The record stops after 55 keys (`libraries.ts:84` `.slice(0, 60)` on the params' entries,
  functions and elements dropped), so `autoplay`, `loop`, `effect`, `navigation` and `pagination` are missing from it.
- The arrows are `elementor-swiper-button-prev/next` Divs (role button) beside the swiper root inside the widget's
  holder. Each holds Elementor's chevron SVG (`viewBox 0 0 1000 1000`, `fill hsla(0,0%,93.3%,.9)`, 1em), 25 × 25,
  at the slider's left and right edge, about the middle (`boxes.txt`).
- The timing: Swiper 8.4.5's autoplay (`evidence/…/swiper/autoplay8.js:104-118, 133-146, 191-195`) starts its delay
  only at the slide's `transitionend` (`waitForTransition`, default true). So one slide stays still for 5000 ms and
  then slides for 2500 ms: a new move starts every 7500 ms. Splide counts its `interval` from a move's start
  (README "interval … Splide counts it from a change's start"), so Bricks' interval is 7500.
- In the capture's 768–991 ranges the page was read with no styles (staging-fit's finding,
  `/tmp/claude-1000/sf-forward.txt`). 922–991 drops 1,141 nodes' declarations (`ranges.mjs` output), the swiper row's
  `display:flex`/`overflow:hidden` among them. That is why the slides stack at 990. Job staging-fit-capture fixes the
  capture.

## What the paste does (proof)

- `whole.json` has **no `slider-nested`**. The widget's 82 elements are 60 Div, 13 Block, 3 Image, 3 Heading, 1 Text
  and 2 Code (`paste.txt`).
  - The swiper root, its row and its slides are plain Divs and Blocks with the captured Swiper CSS (`row-vpfc`
    overflow hidden, `row-funi` flex with `transform: translate3d(0px,0,0)`).
  - The arrows are Divs with an SVG, and nothing is bound to them.
  - Under `@media (max-width: 991px)` the row's class reverts `display`/`transform` (`row-funi … display: revert`,
    the styleless range), so the slides stack.
- Staging's saved page `evidence/staging-fit/planner/staging/homev2-2.html` has `brxe-slider-nested` 0 times.
- `notes.txt`: "kept as page code: nested-carousel 1a9321c".

## Root cause (file:line)

1. **No slider is ever made on the site route.**
   - `src/core/site/elementor-fold.ts:276-277`: a widget with no `BODIES` entry, which includes nested-carousel, is
     "kept as page code".
   - `src/core/site/widgets.ts:10,23-27` keeps every real slide in place and leaves out only the loop copies: "(the
     Bricks Slider is a later job)".
   - The code route pastes no scripts, so nothing moves the row and nothing listens on the arrows.
2. **Stacked at 768–991:** the styleless capture reading (staging-fit-capture). A native slider no longer depends on
   the captured Swiper CSS: Splide lays the slides out, so one slide shows even from today's capture.
3. Hidden traps the fix must cover. Each is proven, and none is visible to today's checks:
   - **(a) The reset cancels Splide's CSS.** Bricks prints Splide's CSS inside `@layer bricks`: `splide-layer.min.css`
     (2.3.9 and staging's 2.4.2 are byte-identical, `bricks-assets/`, sha256 3874131…) and the slider's element block
     in `post-<id>.min.css` (darksalmon `ds-post-10.min.css`). The site route's unlayered reset
     (`src/core/site/classes.ts:26`, `all: revert`) cancels all of it: the track's `overflow:hidden`, the list's flex
     row, the arrows' places, the dots. This is the trap `site-accordion` already fixes for the accordion
     (`classes.ts:148-153`).
   - **(b) The renderer can't see that.** `test/browser/render.ts:347-350` loads Splide's core CSS from jsdelivr
     unlayered and mounts `new Splide(e)` itself. It uses neither Bricks' layered CSS nor `bricksSplide()`, so
     `bricksData.splideInstances` stays empty and nothing can pause it.
   - **(c) A playing paste moves under `site:check`.** `site:check` holds nothing still on the paste side
     (`test/web/lib/site-check.ts`; only `test/web/lib/sliders.ts` `stopSliders` knows `bricksData.splideInstances`).
     So a paste that plays would move between readings.

## The rule (general; Elementor's own markers and Swiper's record only, never a site's ids, words or class names)

On the Elementor route, an Elementor widget whose subtree holds the root of a `web.sliders` record with 2 or more real
slides becomes one **Slider (Nestable)**, as long as all its slides are children of one element (the row) under the
root:

- **Structure.** The library root becomes the `slider-nested` element (its own class; `bare` settings). The row and
  every element between the root and the row are left out, because Bricks prints `splide__track`/`splide__list`
  itself. Each real slide becomes a **Block** in order, holding what it holds today. The loop copies stay out as now.
  - The root's other children are left out and named: they would become slides inside Bricks' list. Script-made ones
    (`~`, e.g. Swiper's live region) are named in one line.
  - The site's arrow and dot elements (Swiper/Elementor's framework classes `swiper-button-prev|next`,
    `elementor-swiper-button-prev|next`, `swiper-pagination`, read from marks) are left out. Bricks' arrows and dots
    replace them. *(amendment 2)* Site arrows or dots that no key names and the page never shows at any width are
    left out too, and Bricks' stay off, named ("never shown on the page").
  - The widget's own wrappers stay as today (not folded; site-native-structure may fold them later).
  - A vertical slider (`direction: vertical`), a slider within a slider, slides under two parents, or 1 real slide:
    kept as today, with a note saying why.
- **Settings** (Bricks' keys and value types from `reference/bricks/slider-autoplay-documented.json` and
  `slider-nested-schema.json`; number controls as strings).
  - **Where each value comes from:** Swiper's captured params where present (`speed`, `spaceBetween`,
    `slidesPerView`, `breakpoints`, `direction`). Elementor's widget settings for the rest: `autoplay`,
    `autoplay_speed`, `pause_on_hover`, `pause_on_interaction`, `infinite`, `arrows` or `navigation` (both / arrows /
    dots / none), `pagination` (bullets…), `effect` or `transition` (slide / fade), and `speed` or `transition_speed`
    when the params lack it. *(amendment 2)* Elementor prints a carousel's settings under two families of keys, and
    both are read: core's Image Carousel and Pro's Slides, Nested and Loop Carousels print `navigation` or `arrows`,
    `infinite`, `slides_to_show`, `image_spacing_custom`; Pro's carousel base (Media, Testimonial and Reviews
    Carousels) prints `show_arrows`, `loop`, `slides_per_view`, `space_between`. Swiper's own `loop` param counts
    where the capture holds it. Elementor prints no key for a switch that is off, so a missing key is never read as
    "off": arrows, dots and the loop are on when a key of either family says so, or, where no key names the part,
    when the captured page shows it (an arrow element or the dots' row shown at some width; Swiper's copies of the
    slides in the row). Autoplay and its pause are on only when their key says so: nothing on the page shows them.
  - The builder reads each widget type's keys and defaults from Elementor's source, not from memory: core
    `includes/widgets/image-carousel.php` and `assets/dev/js/frontend/handlers/` on GitHub (GPL). For Pro widgets, use
    the keys visible in a capture's `data-settings`, and if a key is missing, leave Bricks' default and name it.
    *(amendment 2)* Pro's keys are read from its public GPL copy as well (`modules/carousel/widgets/base.php`,
    `base/base-carousel-trait.php`). A missing speed or autoplay delay takes Swiper's own default (300 ms, 3000 ms),
    named; a missing yes/no is decided as the line above says, never by Bricks' default or the widget panel's. Was:
    "if a key is missing, leave Bricks' default and name it".
  - `height: "auto"` (CLAUDE.md, never `autoHeight`); `gap` = the site's spacing (B-Dry `"10"`). *(amendment 8)* A
    height a slide declares itself is kept in the look ("A slide's own height", below), never in this setting.
  - **Autoplay:** `autoplay: true`; `interval` = delay + speed when Swiper waits for the transition (default, true for
    Elementor); `speed` = the move's ms; `pauseOnHover` = the site's pause on hover; `pauseOnFocus` = the same
    (keyboard users get what mouse users get, as the Figma route's R4). For B-Dry: interval `"7500"`, speed `"2500"`,
    both pauses true. *(amendment 3)* A Bricks checkbox key (`autoplay`, `pauseOnHover`, `pauseOnFocus`, `rewind`,
    `arrows`, `pagination`) is written only when true and left out otherwise, never `false`: Bricks reads a checkbox
    with `isset()`, so a stored `false` counts as ticked. A carousel that autoplays without pause on hover holds
    neither pause key; one that doesn't autoplay holds no `autoplay`, `interval` or pause key (its `speed` stays).
  - **Loop:** loop → Bricks' default type (key unset); not looping → `type: "slide"`, `rewind: true` (Swiper's
    autoplay returns to the first slide; `type: "slide"` is printed live on darksalmon); fade → `type: "fade"`,
    `rewind: true` (as the Figma route). *(amendment 2)* It loops when `infinite` or `loop` is "yes", when Swiper's
    own `loop` param is true, or, where none of them is printed, when the row holds Swiper's copies of the slides.
    *(amendment 6)* A fade only where one slide is in view at the design width (Elementor's handlers set the effect
    only then); with more in view the slides slide.
  - **Per view and gap:** per view `perPage` (written only when it isn't 1) and gap per Q4. *(amendment 1)* As Q4's
    answer A now reads: each Bricks tier takes what the site shows across most of its widths, the desktop what it
    shows at the design width, and a `perPage:<bp>` or `gap:<bp>` key is written only where a tier differs from the
    one wider than it. *(amendment 2)* Without Swiper's params, per view is `slides_to_show` or `slides_per_view` and
    the gap `image_spacing_custom` or `space_between`.
  - **Controls:** `arrows: true` when the site shows arrows; `pagination: true` when it shows bullets (fraction and
    progress bar pagination become dots, named). *(amendment 2)* "Shows" is a key of either family or, where no key
    names the part, the page itself. *(amendment 3)* Neither key is written when it isn't true.
  - **Not written** (Bricks' defaults kept, as on the Figma route): `keyboard`, `direction`, `perMove`, `start`.
- **Look (custom CSS on the slider's class, after naming, as the accordion's open look is appended).**
  - **The arrows (Q3 A).** Each Bricks arrow takes the site arrow's own declarations per kept range at
    `.<cls> > .splide__arrows > .splide__arrow--prev|next`. *(amendment 7)* Their place values are copied whenever
    the box the arrow answered to on the site is the box Bricks' own arrow answers to in the paste; otherwise Bricks'
    default places are used, named. On the site that box is the nearest positioned box above the arrow. In the paste
    Bricks' arrows sit inside the slider, so it is the slider where it is positioned there (the site's root
    positioned, or declaring no position: Splide's restored `.splide { position: relative }` then holds), else the
    nearest positioned box above the root (Elementor makes the root `position: static` on its Image Carousel and on
    every Pro main swiper: both sides then answer to the widget's box, whatever its size). The two are one box when
    they are the same element, or two the capture measured alike at every width of the range (a box the capture
    folded into its only child is read through that child: B-Dry's widget box). Never for an arrow fixed to the
    window, or with no positioned box above it. Was: "copied only when the arrow's containing block has the slider
    root's box at every captured width (B-Dry: holder = root at every measured width)", which gave Bricks' places to
    every root that isn't positioned. The drawing is the site's SVG markup as a `mask` in
    `currentColor` on `::before`, sized as the site's SVG is, with the Splide SVG hidden. The previous arrow's
    transform is the site's own, so Bricks' `scaleX(-1)` flip (layered, and beaten by unlayered CSS) never mirrors
    the site's left chevron.
  - **The dots:** the site's bullet and active bullet declarations on `.splide__pagination__page` and `.is-active`,
    and the bullets' row place on `.splide__pagination`. *(amendment 7)* The row's place is copied by the arrows'
    rule (the box the row answered to on the site is the box Bricks' own row answers to in the paste); otherwise
    Bricks' place (under the slides, centred), named. *(amendment 9)* Splide draws one dot per page of slides: a
    slider showing one slide at a time has one per slide, as the site; one showing several at once has fewer than
    the site's one per slide, left as Bricks draws them and named (review 2's R2-4, deferred).
  - **The glide (Q2 A):** the row's timing function, as above.
  - **A slide's own height** *(amendment 8; fixer 2's ruling, to be confirmed with Justin)*: Bricks hands the
    slider's `height: "auto"` to Splide, which writes it inline on every slide, so a height a slide's own class sets
    never applies. A height a site slide declares itself (anything but `auto`, a percentage too) is repeated
    `!important` on the slider's class per run of kept ranges: on every slide where the slides agree
    (`.<cls> > .splide__track > .splide__list > .splide__slide`), else on each slide by its own class. The row's own
    height (but Swiper's `100%`) goes on Splide's list. Slides the site sizes by their content keep `height: "auto"`.
    The height is then edited in that CSS line of the slider's class, not in the slide's own Height control.
- **Splide restored under the reset:** a new shared class **`site-slider-<4>`**, named after its rules
  (`classes.ts versioned`, like `site-reset-<4>`), on every pasted slider.
  - It holds Bricks' `splide-layer.min.css` rules, scoped `:where(.site-slider-<4>)…`. At weight (0,1,0), printed
    right after the reset, they beat the reset, and the site's own classes printed later beat them. It also holds the
    button resets Bricks' front end gives arrows and dots (border 0, transparent background), which `all: revert`
    turns back into UA buttons. *(amendment 4; fix round 2, R2-2)* As built, each selector is scoped
    `:where(.<name>, .<name> *)<selector>` and keeps its own weight (was "At weight (0,1,0)"), after Bricks' button
    rules. No restored rule may change what a slide's own content computes against the site: one that would (today
    `.splide__slide img { vertical-align: bottom }`, which takes the site's baseline gap from every picture in a
    slide) is left out or scoped to weigh nothing.
  - Bricks' element block (slide centring, previous-arrow flip) is **not** restored: the slide keeps the site's own
    look.
  - The constant is generated text, and a unit test proves it equals the scoped transform of the byte copy in
    `reference/bricks/frontend-2.3.9/`, so a Bricks upgrade can't drift unseen. *(amendment 4)* Less only what the
    line above takes out or weakens, each such rule named in that test.
- **Notes**, one per slider:
  - "<widget> <id>: Bricks' Slider (Nestable), N slides, plays every X s (pauses under the mouse)".
  - When the site stopped for good after a click (`pause_on_interaction`): "after a visitor uses its arrows the old
    site stopped playing; Bricks plays on (Bricks has no such setting)".
  - What was left out.
  - *(amendment 1)* Where its per view or spacing switches: "its per view switches at Bricks' widths 991/767/478; the
    site switches at 767, 1024 (each from that width up): 992 and up takes what the site shows at 1440, 479-767 what
    it shows under 767" (the site's own widths, and each tier the site cuts with the part that wins).
  - *(amendment 2)* A part read off the page: "its settings don't say, the page shows: arrows, dots, a loop (Swiper's
    copies of its slides)". A widget with no settings in the page: "its Elementor settings aren't in the page: it
    doesn't play by itself; its arrows, dots and loop are as the page shows them".
  - *(amendment 7)* A part whose places aren't copied, the arrows' note and the dots':
    "its arrows were placed in another box than the one Bricks places its arrows in: Bricks' places (its sides, the middle)"
    "its dots were placed in another box than the one Bricks places its dots in: Bricks' place (under the slides, centred)"
  - *(amendment 9)* A slider with dots that shows several slides at once, at the design width or at a Bricks tier:
    "it shows several slides at once: Bricks draws one dot per page of slides, the old site one per slide"
- **Unchanged:** the plain route (Q1 A), every paste without a slider, and the Figma route (no file under
  `src/core/{understand,style,adapt,emit}` or `src/plugin` changes).

Reduced motion: Splide 4.1.4's own `reducedMotion` (autoplay paused, speed 0) applies as in any Bricks slider. This is
a ruling, not yet confirmed.

## Acceptance criteria (all proposed)

- **AC1 (proposed):** On the Elementor route, a captured Elementor carousel pastes as one `slider-nested` at its
  Swiper root's place. It holds exactly its real slides as Blocks in order, with no row element, no loop copy, no
  site arrow or dot element, and one note naming it. The plain route still pastes the same capture byte-identically.
  Test *(amendment 5: its name whole on one line)*: `test/web/site-elementor-slider.test.ts`
  "a captured Elementor carousel pastes as one Slider (Nestable) holding its own slides"
  (generic fixture `test/fixtures/web/sites/elementor-slider/`; RED on main: no `slider-nested`).
- **AC2 (proposed):** The settings are as the rule says for both fixture carousels:
  - **Nested carousel:** loop, autoplay delay 600 + speed 300 → `interval "900"`, `speed "300"`, `pauseOnHover` and
    `pauseOnFocus` true, `arrows` true, `gap "10"`.
  - **Image carousel:** fade, dots, `navigation "dots"`, no hover pause → `type "fade"`, `rewind` true,
    `pagination` true, `arrows` unset.

  Each table row of Elementor settings maps to the expected Bricks settings, and every written key and value type is
  valid in `slider-nested-schema.json`. *(amendments 1 to 3 and 6)* "The rule" is the rule as amended: the table's
  rows include Elementor's own Swiper keys at every Bricks tier, both families of keys and a page that shows what no
  key names, and no row writes a checkbox key `false` (the image carousel holds no pause key at all).
  Test *(amendment 5: its name whole on one line)*: `test/unit/site-slider.test.ts`
  "Elementor's carousel settings become Bricks' slider settings"
  (RED on main: the module doesn't exist).
- **AC3 (proposed):** In the site renderer, now running Bricks' own `splide-layer.min.css`, Splide 4.1.4,
  `bricksSplide()` and the slider element block, the fixture's paste does three things:
  - At 1440, 991, 767, 390 and 300 it shows exactly one slide inside the slider's frame at rest, and the first slide's
    box is within 2 px of the site's first slide.
  - It moves to slide 2 within interval ± 250 ms and stays still while the pointer is over it.
  - Next shows slide 2, and Previous on slide 1 shows the last slide.

  Test *(amendment 5: its name whole on one line)*: `test/web/site-elementor-slider.test.ts`
  "the pasted slider shows one slide, plays on the site's timing, pauses under the mouse and its arrows move it"
  (RED on main).
- **AC4 (proposed):** Under the site reset, the Bricks parts of a pasted slider compute what they compute in a plain
  Bricks page without the reset: the track's `overflow`, the list's `display`/`flex-wrap`, the slide's `flex-shrink`,
  the arrows' `position`/`border`/`background`, the dots' `display`/`position`. Without `site-slider-<4>` the test
  fails, and the class's text equals the scoped `reference/bricks/frontend-2.3.9/splide-layer.min.css`
  *(amendment 4; fix round 2, R2-2)*, less only a rule that would change what a slide's own content computes against
  the site (today `.splide__slide img { vertical-align: bottom }`): such a rule is left out or scoped to weigh
  nothing, and the unit test names it. Was: "equals the scoped … `splide-layer.min.css`", every rule. Tests:
  `test/web/site-slider-reset.test.ts` "Splide's own CSS survives the site reset" (RED on main: the parts revert) and
  `test/unit/site-slider.test.ts` "site-slider restores exactly Bricks' splide-layer rules, scoped".
- **AC5 (proposed):** At every capture width of the fixture, each pasted arrow's drawing box is within 2 px of the
  site's arrow SVG box. A pixel at the chevron's ink matches the site's colour (±8 per channel), and the previous
  arrow points left (its ink's leftmost column is in the drawing's left half, as on the site). Test:
  `test/web/site-elementor-slider.test.ts` "the slider's arrows are the site's, where the site draws them" (RED on
  main).
- **AC6 (proposed):** The image carousel's dots appear: one per real slide *(amendment 9)* (it shows one slide at a
  time: 3 dots, as the site's 3 bullets), the active one in the site's active colour and the others in the site's
  colour, and their row's box within 2 px of the site's bullets' row at 1440 and 390. *(amendment 9)* A carousel
  showing several slides at once is outside this criterion: Splide draws one dot per page of slides where the old
  site drew one per slide, the dots are left as Bricks draws them, and the paste's note names it (review 2's R2-4,
  deferred). Was: "one per real slide", with no word on where it holds.
  Test: `test/web/site-elementor-slider.test.ts` "the slider's dots look like the site's" (RED on main).
- **AC7 (proposed):** `site:check` holds every paste slider on its first slide before reading. The fixture's
  `site:check --all --elementor` passes at every width with the slider playing, and fails when that hold is removed
  (mutant). Test *(amendment 5: its name whole on one line)*: `test/web/site-check-settle.test.ts`
  "a pasted slider is held on its first slide while site:check reads"
  (RED on main: slide 2 in place after the interval).
- **AC8 (proposed):** Nothing else changes.
  - Every plain-route paste of the site fixtures (`pageCode`, `elementorCode`, `elementorBand`, the code-page site
    with its two Swipers) and every Elementor-route paste of a fixture with no slider is byte-identical to main's
    goldens, written in task 0 from main `fd1986dc`.
  - `npm run corpus` and `npm run replay` of the root debug file are byte-identical to main.
  - The class-name checks (`test/web/lib/class-names.ts` `bareNames`/`sharedNames`) pass with `site-slider-<4>`
    allowed.

  Test: `test/unit/site-slider-unchanged.test.ts` "pastes without an Elementor slider are byte-identical" (passes on
  main by construction; its mutant: the slider step run on the plain route fails it).
- **AC9 (proposed):** B-Dry, named-only, on a clean capture *(amendment 11)*: `F2B_BDRY_CAPTURE` is Justin's
  re-capture of bdryswi.com's home made with Build 2026-11-09.4 or later once it exists (one that `npm run
  capture:check` doesn't refuse: no exit 2); until then the saved stand-in
  `~/.hermes/plans/figma-to-bricks/evidence/elementor-phone-fit/planner/bdry-standin.f2b-capture.json` (sha256
  `3c238957cea09ba6ac78027600d76eea53f29cd2981a85a3a9cdcbf774686dda`). The stand-in is a capture of the saved
  2026-10-29 home served locally, not the live site; the live proof is the tenth criterion's. `F2B_BDRY_BASE` and
  `F2B_BDRY_BASE_REPORT` are main's paste and main's `site:check --all --elementor` report of that same file, made
  with the base commit's code (`git merge-base HEAD main`). The verifier and the auditor of one head read the same
  file and name it with its sha256 in their evidence. Was:
  `F2B_BDRY_CAPTURE=/home/justin/f2b-test/bdryswi-com-home.f2b-capture.json`, the capture main now refuses.
  - The `--elementor` whole paste has exactly one `slider-nested` (the hero) holding 3 Blocks, with settings
    `autoplay true, interval "7500", speed "2500", pauseOnHover true, pauseOnFocus true, arrows true, gap "10",
    height "auto"` and no `type`/`perPage`. The two `elementor-swiper-button` Divs are gone, and the pause-on-interaction
    note is present.
  - Rendered at every width the capture read *(amendment 11)* (48 on Justin's 2026-11-09 capture, 38 on the
    stand-in), exactly one of the three slide headings shows inside the hero frame, 768–991 included. Was: "at the
    capture's 48 widths".
  - Outside 768–991, the first slide's heading and buttons are within 2 px of today's paste. *(amendment 11)* On a
    clean capture 768–991 is read with the site's styles too; the test still compares only the widths outside it
    (its fixed filter, `test/web/site-slider-bdry.test.ts` line 98), each element's box against the page root's in
    head's paste and in main's paste of the same capture, so the clause stands as written.
  - `site:check --all --elementor` on that capture *(amendment 11; was: "on the saved capture")* gives no new
    failing row against main's report, except inside the hero slider's subtree.

  Test: `test/web/site-slider-bdry.test.ts` "B-Dry's hero is one Slider (Nestable) of 3 slides playing every 7.5 s"
  (RED on main).
- **AC10 (proposed) (live):** Justin re-pastes the `--elementor` whole page on `https://bdry.staging.growithgro.com/homev2/`
  (after staging-fit-capture's re-capture if it has merged).
  - On the live page (and in the editor at 990) the hero shows one slide at a time at 1440, 990, 767 and 390. It
    slides to the next every 7.5 s with a 2.5 s glide, pauses under the mouse, and its ‹ › arrows move it, looking
    like the site's.
  - A later agent may also read the page logged out with `?f2b=<random>`: `data-splide` holds `autoplay:true,
    interval:7500, speed:2500, pauseOnHover:true`, the slider has `is-initialized`, and one slide is in view.

## Tasks (test-first; commit after each passing task; ledger `.superpowers/sdd/site-slider/progress.md`)

0. **Setup.**
   - Copy this plan to `docs/plans/2026-11-09-site-slider.md`.
   - Run `npm run corpus` (baseline).
   - Write AC8's goldens from main: the plain-route and no-slider Elementor-route pastes of the site fixtures, as
     `test/fixtures/site-slider-base/*.json`, the same way as `site-motion-base`.
1. **Bricks' Splide in the reference and the renderer (AC4 RED first).**
   - Add byte copies to `reference/bricks/frontend-2.3.9/` from `evidence/…/bricks-assets/`: `splide-layer.min.css`,
     `splide.min.js` (Bricks' copy of Splide 4.1.4) and `el-slider-nested.min.css` (the slider block of darksalmon's
     `post-10.min.css`). Record their SHA256SUMS lines, plus a README paragraph naming the source and the 2.4.2
     match.
   - `renderPage` in site mode (`bricksCss`): print those layered, run `bricksSplide` from `bricks.min.js` (with
     `bricksData.splideInstances` and `i18n` prev/next strings), and keep today's jsdelivr path for Figma pages.
     *(amendment 3)* In site mode it reads each slider checkbox as Bricks' PHP does (`isset()`: a stored `false` is
     ticked; `test/browser/render-slider.ts` `splideSiteOptions`); Figma pages keep reading only `true` as on.
   - Write `site-slider-reset.test.ts` and see it RED.
2. **`src/core/site/elementor-slider.ts` (AC1, AC2 units RED first).**
   - Recognise the slider, give the picks (root → `slider-nested` with shared `site-slider-<4>` and `bare`; slides →
     `block`), the leave-outs, the settings from Elementor + Swiper, and the notes.
   - The `site-slider` CSS constant in `src/core/site/slider-css.ts`, generated and tested against the reference copy.
   - Hook into `foldElementor` beside the accordion branch: count it as mapped, and remove the row from the root's
     children in the folded nodes, as `fold` rewrites children.
   - Add to `SHARED_CSS` and allow it in `class-names.ts`.
3. **The look (AC5, AC6 RED first).** The arrows' and dots' CSS and the glide line (Q2/Q3), appended to the slider's
   class after naming (`convert.ts`, as `lookCss` for accordions), with the containing-block check. *(amendment 7)*
   That check is the Look list's: the box each part answered to on the site against the box Bricks' own part answers
   to in the paste. *(amendment 8)* A slide's own height is part of this look.
4. **Generic fixture `elementor-slider` (AC1, AC3, AC5, AC6).**
   - Two `main` sections (testing-pitfalls: a lone section breaks `sectionsOf`).
   - (1) An `elementor-widget-n-carousel` with 3 slides holding `data:` background pictures and headings, Elementor
     arrows with inline chevron SVGs, `data-settings` with autoplay 600/300, pause on hover, infinite.
   - (2) An `elementor-widget-image-carousel` with fade, dots, `navigation "dots"`, no hover pause.
   - A small script gives each `.swiper` a Swiper-like instance: `params` with speed, spaceBetween, slidesPerView and
     breakpoints; `slides`; `slideTo`; `autoplay.stop`. It also adds loop copies and script-made bullets, as
     `code-page/slider.js` does.
   - Capture it in the test, convert with `--elementor`, render, and assert.
5. **`site:check` holds paste sliders (AC7)** in `test/web/lib/site-check.ts` `settle`/reading: pause and `go(0)`
   every `bricksData.splideInstances`, the same code as `test/web/lib/sliders.ts`. Write the mutant.
6. **B-Dry named-only (AC9)** and AC8's unchanged test; the full gates (`npm run check`, browser site tests file by
   file, `npm run corpus`, mutants per `mutation-testing-discipline` under `systemd-run … MemoryMax=4G`, B-Dry under
   8G).
7. **Records.** The HANDOFF section (the rule, rulings Q1–Q4 not yet confirmed, the pause-on-interaction ruling, the
   reduced-motion ruling, known limits), paste check `<site-slider id at merge>` for AC10 with steps in the end-of-run
   list, and the ledger.

## Proof widths

The capture's 48 widths, plus 300 (one width under the narrowest; testing-pitfalls) and the laptop widths
1300/1200/1100 for the arrows' place.

## Overlaps with the other five jobs (merge order)

- **staging-fit / staging-fit-capture (merge first).**
  - It fixes the 768–991 styleless reading. Until it merges, AC9 asserts one slide in view at 768–991 but not 2 px
    there.
  - It may also change the renderer's Bricks model (2.4.2 prints class controls as `.cls.brxe-<el>`, 0,2,0) in
    `test/browser/render.ts` / `test/web/lib/site-check.ts`, the same files as tasks 1 and 5. Rebase this job onto
    it; the slider's CSS is custom CSS, so control weight doesn't touch it.
  - Their capture files (`src/web/…`) aren't touched here under Q1 A.
- **site-faq:** shares the insertion points `elementor-fold.ts` (widget branches), `classes.ts SHARED_CSS`,
  `convert.ts` (appended looks) and the renderer's Bricks script list (`bricksAccordion` + `bricksSplide`). These are
  small textual conflicts; keep each widget in its own module.
- **site-menu:** the same insertion points (it may add an Offcanvas/popup emitter and a Bricks script). Same advice.
- **site-reviews:** Trustindex isn't a `web.sliders` record (it scrolls by `scrollLeft`). If that job makes the
  reviews a Bricks slider, it should reuse this job's settings writer, `site-slider-<4>` restore class and renderer
  support rather than write its own. Merge this job first in that case.
- **site-native-structure:** it may change which element the widget's wrappers become (Section/Block/Div folds). This
  job's slider stays at the Swiper root's place with Block slides either way. If native-structure folds the widget's
  box and holder into the slider, the slider's class gains their declarations, and the arrows' containing-block check
  then compares against the folded root. Nothing in the settings changes. If it changes what a slide's content
  becomes, the slides still hold it.
- Shared files touched by this job: `src/core/site/{elementor-fold,classes,convert,widgets}.ts` (small hooks), new
  `src/core/site/{elementor-slider,slider-css}.ts`, `test/browser/render.ts`, `test/browser/render-slider.ts`,
  `test/web/lib/{site-check,class-names}.ts`, `reference/bricks/frontend-2.3.9/` (new files only).

## Bricks samples

- Not needed to build. `slider-autoplay-documented.json` (schema 2.4.3 + live `data-splide`) covers every key written.
  `type: "slide"` is printed live on darksalmon (2026-11-09, `bricks-assets/ds-home.html`).
- Wanted (already in README "Still wanted"): Justin's own Slider (Nestable) copy with Autoplay, Interval 7500, Speed
  2500, Pause on hover and focus, Arrows and Gap 10, and one with "Items to show" changed for phones (Q4 A's
  `perPage:<bp>`).

## Risks

- **Arrow places:** B-Dry's measured arrow top (549 at 1440 in a hero 78–997) doesn't match a naive reading of
  `calc(50% − 15px)` + `translate(-50%)` (510), so the arrows' containing block may be the widget box, not the root.
  AC5 catches any shift. If the boxes differ, the rule falls back to Bricks' places, named. *(amendment 7)* Which
  boxes are compared is the Look list's arrows line: a box the capture folded into its only child (B-Dry's widget
  box) is read through that child.
- **Splide `visibility: hidden` until mounted** (restored with the rest): a page whose Splide never mounts shows no
  slider. That is Bricks' own behaviour.
- **The editor:** Bricks runs Splide in the editor, so the editor shows one slide. This is AC10's live check.
- **Follow-up:** the slider-library record's 60-key cut (`libraries.ts:84`) and Q1 B for non-Elementor sliders.
