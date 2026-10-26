# Emergency Call button too wide on the site (emergency-cta-width)

**Approved by Justin 2026-10-21** (answers E1A E2A E3A).

Planner: Hermes, 2026-10-21. Main at build `2026-10-20.15`. Plan only: no copy, code or commit made.

## Open questions (the plan is written as if each ⭐ was chosen)

1. **Where did the button look too long?**
   - **A ⭐ On a computer or tablet: the words float in a pill that's too wide for them.** This is what I measured on your live Home page, and it's what this plan fixes.
   - B. On a phone: the pill fills the whole screen width. That comes from your own rule of 2026-10-01 ("every CTA button is full width on phones"). Changing it would be a separate small rule change, not this plan.
   - C. Both.
2. **How should the 8 pages you already pasted get fixed?** Each one carries the bad font lines (see the root cause): Home, Hydraulic Cylinder Repairs Final, Remanufactured, Contact, Core Exchanges, Rods, Services, About. Gallery is clean.
   - **A ⭐ Convert each one again (WordPress connected) and paste it again.** The fixes the other agents are building land at the same time.
   - B. A one-off CSS patch I write for you to put in Bricks → Settings → Custom code. Quick, but it's made by hand for these three fonts only.
   - C. Leave them as they are.
3. **Should a button also shrink to its words when the site draws them narrower than Figma?**
   - **A ⭐ No. Fix the fonts, and buttons keep the width Figma draws.**
   - B. Yes, as a safety net. The catch: it changes every button on every page and would hide font problems like this one.

## The request, played back

1. On your pasted hydraulics homepage, the "Emergency Call 24/7" button looks too long and loose next to Figma, where the pill fits its icon and words tightly.
2. You want it as compact as in Figma, and the fix has to work for any design, not just this button.

**Which button (about 85% sure):** the outlined "Emergency Call 24/7" pill with the phone icon. It appears twice on Home, in the hero beside "Call Us Now" and in the closing band. It's also in the hero row of the Repairs page and the other service pages. It's the only CTA whose words mention an emergency call, and every copy of it shows the problem.

The other candidates, ruled out:
- The Info card line "EMERGENCY CALL 24/7 · (800) 457-3160" is plain text, not a button, and the site draws it correctly.
- The "Call Us Now" buttons are drawn correctly.

## Root cause (proven on the live page)

**What you see:** on the live Home page at 1728, 1440 and 768, the button is 279px wide. Figma draws it 281px, so the width itself is right. But its words are only **142px** wide on the site, against 194.5px in Figma (196px in the renderer). That leaves about 55px of empty pill on each side of the words, where Figma has 27px of padding.

**Why the words are narrow:** the site draws them in the wrong font.
- Chrome's own report of which font file it used (`CSS.getPlatformFontsForNode`, read-only, live Home page): "EMERGENCY CALL 24/7" (`font-family: Archivo; font-weight: 500`) is drawn with **SairaCondensed-Medium**, a condensed font.
- Other texts are hit too:
  - Saira Condensed 600 ("Learn More", the service card's "Call Us Now") is drawn with **Archivo-SemiBold**. That's wider: 94px against Figma's 66px.
  - Saira 400 (the hero paragraph) is drawn with Archivo-Regular.
  - Archivo 800 (the phone number) is drawn with SairaCondensed-ExtraBold.
- Archivo 600 ("Call Us Now") and Archivo 400 happen to come out right. That's why only the Emergency button stood out.

**Where the wrong font comes from:** the paste's own `@font-face` lines. These are the fonts feature of build 20.11, `src/ui/font-sources.ts` `siteFaceCss`, lines 34–43.
- The Home page's CSS (`wp-content/uploads/bricks/css/post-10.min.css`, read over HTTP) lists **the same 13 font files, in the same order, under each of the design's three families**: "Archivo", "Saira" and "Saira Condensed". That's 9 Saira Condensed statics, the Saira variable font, and Archivo Light, Regular and SemiBold.
- So under "Archivo", weight 500 points at `SairaCondensed-Medium.woff`. The plugin puts the site's lines after Google's, and of two lines for the same weight the last one wins (font-sources.ts lines 2–4).

**Why every family gets every file:** `src/ui/site-fonts.ts` `facesOf`, lines 54–57.
- It asks WordPress for `wp/v2/font-families/<id>/font-faces` and keeps every face in the answer.
- WordPress answers that address with **every font face on the site**, whatever the family:
  - `WP_REST_Font_Faces_Controller::get_items` only checks that the family exists, then hands over to `WP_REST_Posts_Controller::get_items`.
  - That one narrows by parent only through a `parent` setting that exists for hierarchical post types, and `wp_font_face` isn't hierarchical. I read this in WordPress's own code, trunk.
- The page's CSS confirms it independently: three different family ids gave back the same 13 faces.

**Why the tests didn't catch it:** the test stand-in for WordPress (`test/fixtures/panel.ts`, lines 196–199) answers that address with only the family's own faces. Real WordPress doesn't.

**The same bug causes two more problems:**
- `fontPlan` says a weight is "on your site" when only another family has it, so the panel never warned that Archivo 500 was missing.
- `addFonts` (site-fonts.ts line 127) treats a dropped face as "Already on your site" when any family has that weight. That's probably why Archivo Medium never went up.

**What else I checked and ruled out:**
- The usual sizing causes don't apply. On the live page and in the renderer, the button's computed width equals its min-width (279px), with `flex-grow: 0` and `align-self: auto`.
- The equal-heights change of build 20.15 only sets the hero and closing rows' heights.
- On phones the pill fills the screen because of the `cta.fullWidth` rule (your decision), not because of this bug.
- `npm run snap` on `corpus/files/hydraulics-home.json` draws the button at 280px with its words at 197px: correct, because the renderer never loads the site's fonts.

**Which pages are affected:** 8 live pages carry the bad lines (each page's post CSS, read over HTTP): Home, Hydraulic Cylinder Repairs Final, Remanufactured, Contact, Core Exchanges, Rods, Services, About. Gallery has none.

## Approach

1. Read each family's faces as WordPress really answers. Ask for each face's `parent` too, and keep only the faces whose parent is that family. If an answer has no `parent` (an old WordPress or a proxy), keep a face only when its own `fontFamily` names the family. Read the face list page by page, since a site's full list can pass 100.
2. Make the test stand-in answer like WordPress: every face on the site, each with its `parent`. Then today's code fails the tests, and the fix makes them pass.
3. No change to `src/core`, so every corpus paste stays byte-identical. The fix changes only the font lines the panel adds after Convert.
4. Pages already pasted are fixed by converting and pasting them again (question 2, A).

General logic: no font names, file names or weights are keyed on. It works for any two or more families on any WordPress site.

## Tasks (test first; ledger in `.superpowers/sdd/emergency-cta-width/progress.md`)

0. **Baseline.**
   - Run `npm run check` and `npm run corpus`; save the report and copies of `corpus/out/v2/*/bricks.json`.
   - **Before proof:** a scratch script imports the main folder's `src/ui/site-fonts.ts` and `font-sources.ts`, with `env.fetch` stubbed. The stub serves a font library rebuilt from the live `post-10.min.css`: three families, 13 faces, each face with its parent, answered the way WordPress answers. The script prints the `@font-face` list for each family (today: 13 under each).
   - **Before pictures:** render `corpus/files/hydraulics-home.json` (via snap's `renderPage`), adding the old `@font-face` lines that point at the live site's public font files. Shoot the **Hero** button row and the **Brands / closing** button row at **1728 and 768**.
1. **Make the stand-in honest (red).**
   - `test/fixtures/panel.ts` `fontLibrary`: the faces address returns every face of every family, each with `parent`, and honours `per_page` and `page`.
   - New test in `test/unit/ui-site-fonts.test.ts`: two generic families ("Sample Sans" with 400 and 600, "Grot Condensed" with 500 and 600). `siteFonts` gives each family only its own faces. It fails on main.
   - Re-check the existing font tests against the honest stand-in. Any that now fail have found the same bug.
2. **Fix `facesOf` (green).**
   - In `src/ui/site-fonts.ts`, ask for `_fields: "id,parent,font_face_settings"`, read page by page (100 at a time, at most `MAX_READS` reads, stopping at a short page or `rest_post_invalid_page_number`), and keep the faces whose `parent` is this family's id.
   - Without `parent`, keep a face only when `familyKey(firstFamily(fontFamily))` is this family's key.
   - Keep the file under about 300 lines.
3. **Tests for what follows from it.** Each one is written first and fails on main.
   - `test/unit/ui-font-sources.test.ts`: `siteFaceCss` writes each family only its own files. Of two families that both have 600, each keeps its own file.
   - `fontPlan` says "from Google Fonts", not "on your site", for a weight that only another family has.
   - `ui-site-fonts.test.ts`: `addFonts` uploads a dropped Sample Sans 500 when only Grot Condensed has 500 on the site, instead of reporting it as already there.
   - A face without `parent` that names another family is left out. A site with more than 100 faces still finds a family's own faces on the second page.
4. **One end-to-end panel check**, in whichever test already drives `run.ts`'s font CSS (`ui-fonts.test.ts`, or the panel browser test): a Convert with WordPress connected and two site families copies a paste whose CSS gives each family only its own files.
5. **After proof and pictures.**
   - Run the same scratch script on the copy's `src/ui` (each family gets only its own files) and render the same two rows at 1728 and 768.
   - Copy the pictures to `~/.hermes/plans/figma-to-bricks/shots/emergency-cta-width/`: `before-hero-1728.png`, `after-hero-1728.png`, `before-closing-768.png`, `after-closing-768.png`.
   - Before: the words float with wide gaps. After: Archivo Medium fills the pill, 27px on each side.
   - Add a phone picture at 390 too, to show the full-width rule is unchanged.
6. **Close.**
   - `npm run check` and `npm run test:browser` pass.
   - `npm run corpus`: every `corpus/out/v2/*/bricks.json` is byte-identical to the baseline (`cmp`), and the lint lines and the "Worse than v1" list are unchanged.
   - One review on opus, then one fix pass.
7. **Docs & records.**
   - Copy the plan to `docs/plans/2026-10-21-emergency-cta-width.md`.
   - Move the ledger to `docs/plans/2026-10-21-emergency-cta-width-ledger.md`.
   - Add a `docs/HANDOFF.md` section, "Fonts from the site's library mixed between families". It records the cause, the fix, the 8 pages to paste again, and **paste check 3ac** (the next free number after 3ab; the finisher renumbers it if a parallel merge took 3ac).
   - The paste check: on Home, the hero and closing "Emergency Call 24/7" words are 196px (±2) at 1728 and 768, and Chrome reports Archivo (Google) drawing them, not SairaCondensed. "Learn More" is drawn with Saira Condensed.
   - The finisher bumps `BUILD` at merge and updates main `CLAUDE.md` "Start here" and "Where things stand".
   - New `CLAUDE.md` rule (under "Working in this repo"): **WordPress's `font-families/<id>/font-faces` answers every face on the site; keep only the faces whose `parent` is the family.** Stand-ins for WordPress must answer as WordPress does, read from its code or a real answer.

## Tests (test first, generic fixtures)

- **The stand-in:** WordPress's real face list (every family's faces, each with `parent`, in pages).
- `ui-site-fonts`: own faces only; no `parent` → matched by name; more than 100 faces; a drop not counted as "already" because another family has the same weight.
- `ui-font-sources`: `siteFaceCss` and `fontPlan`, as in task 3.
- One end-to-end Convert check (task 4).
- **Proof each test catches the bug:** with the fix committed, run `git checkout HEAD~1 -- src/ui/site-fonts.ts`, see the new tests fail, then restore the file.

## Choices (with the ⭐ answers)

- **1A:** fix the loose pill on computers and tablets. The phone full-width rule stays.
- **2A:** convert and paste the 8 affected pages again. Nothing on the site can be repaired through REST: the bad lines live inside each page's Bricks data. The font library itself looks correctly filed (the mix-up happens when reading it), so it needs no repair.
- **3A:** no shrink-to-words safety net. Buttons keep Figma's width as their minimum.
- My rulings, not yet confirmed:
  - When `parent` is missing, faces are matched by their `fontFamily` name.
  - Faces are read per family, not once for all, so it stays right on a WordPress that does filter by parent.

## Risks

- **Re-paste needed:** pages already pasted keep the wrong fonts until each is converted and pasted again (8 pages). A Convert alone repairs nothing there.
- **Library state not seen:** I couldn't read your font library itself (it needs an Administrator password). Its filing is inferred from the identical 13-face lists. If faces really sit under the wrong family there too, the panel's Fonts rows will show it after the fix, and a clean-up step follows.
- **Hosts without `parent`:** a host that strips `parent` from the answers falls back to name matching. A face uploaded in WordPress's admin under another family name would then be missed, and Google's copy is used, as before build 20.11.
- **Changed test expectations:** the honest stand-in may change what some existing font tests expect. The reviewer checks they still test the same thing.
- **Skewed measurements elsewhere:** until the pages are pasted again, the other agents' measurements on the live pages (line breaks, padding) are made with the wrong fonts.

## Pipeline parts it touches

- Panel only: `src/ui/site-fonts.ts` (reading the site's font library), and through it `src/ui/font-sources.ts`'s output (its code is unchanged unless the end-to-end test needs a helper). `src/ui/run.ts` is unchanged.
- Tests: `test/fixtures/panel.ts` (`fontLibrary`), `test/unit/ui-site-fonts.test.ts`, `test/unit/ui-font-sources.test.ts`, maybe `test/unit/ui-fonts.test.ts`.
- **No `src/core` change**: extract, normalise, understand, style, adapt and emit are untouched, so the corpus pastes are byte-identical.

## Overlaps with the other planners

- **early-line-breaks (card text breaking too early in the Info cards):** no shared files, but **probably a shared cause**. On the live pages, Saira 400 is drawn with Archivo-Regular and Saira Condensed 600 with Archivo-SemiBold, both wider than Figma, so lines break early. That planner should measure with the right fonts (the renderer, or a page pasted again after this fix) before changing any text logic.
- **frame-text-links (`normalise/text.ts`, `ui/site-*`):** different files (`site-read.ts` and `site-pages.ts`, against my `site-fonts.ts`). Both might edit `test/fixtures/panel.ts`, in different functions; easy to rebase.
- **test-cleanup (stale panel browser tests, row-stretch tests, splitting `style.ts`):** no shared source files. It might touch `test/fixtures/panel.ts` too; low risk.
- **phone-side-padding (adapt/rules spacing):** no overlap.
- This fix can be built in parallel with all four.

## Other things found (not fixed here)

- **Medium:** the Info card "Call Us Now" button wraps its words onto 2–3 lines on narrow screens. It's 81.6px tall at 768 and 106px at 480 (live and renderer), because the card is 101–163px wide and the label gets `_widthMin:tablet_portrait: 0`.
- **Low (tool):** `npm run snap --sides` pairs Figma's sections with the built ones in layer order, not top to bottom (`tools/snap.ts`, the `kept` list near line 85). On hydraulics-home, the hero's side picture shows Figma's logo marquee beside the built hero.
- **Low:** live header "SCHEDULE NOW" (`IBM Plex Mono` 800) is drawn with Times-Bold on Home and Repairs. Google's IBM Plex Mono has no 800. I didn't check whether it comes from the paste or from your header template.
- **Low:** Saira Condensed Thin and ExtraLight went up as weights 250 and 275 (the files' own weight numbers), not 100 and 200 (`post-10.min.css`). A design using Saira Condensed 100 or 200 wouldn't find them on the site and would use Google's copy.


## Justin's answers (2026-10-21)

E1A, narrowed: "on computer desktop only" (the too-wide look was on desktop; phones are fine under his full-width rule). E2A: he converts and re-pastes the 8 pages himself. E3A: fix the fonts, keep Figma's button width. All recommended.
