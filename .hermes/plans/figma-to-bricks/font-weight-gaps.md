# Header font lost, and font weights read wrong on upload (font-weight-gaps)

**Approved under Justin's away auto-go 2026-10-21** (⭐ answers 1A 2A 3A 4A).

Planner: Hermes, 2026-10-21. Main at build `2026-10-20.15`. Plan only: no copy, code or commit made.
Builds **after emergency-cta-width merges** (same files; its copy already has 4 commits in `src/ui/site-fonts.ts`).

## Open questions (the plan is written as if each ⭐ was chosen)

1. **The header's "SCHEDULE NOW" asks for weight 800, but that doesn't come from the plugin.** Your Theme Style sets all body text to Saira 800, and the header button (in your Bricks header template, not in any paste) sets no weight of its own, so it takes 800. Figma draws it at 600. Once this fix is in, it shows IBM Plex Mono Bold (700), the heaviest weight Google has.
   - **A ⭐ You set that button's font weight to 600 in the header template.** One setting in Bricks; I'll send the steps. It then matches Figma.
   - B. Leave it. It shows as Bold (700).
2. **The two Saira Condensed files already on your site went up as 250 and 275. How should they be fixed?**
   - **A ⭐ When converting, the plugin reads them as 100 and 200 from their file names ("-Thin", "-ExtraLight").** Nothing changes on the site.
   - B. On your next font drop, the plugin deletes them and adds them again with the right weights. That's a write to your font library.
   - C. Leave them. Google's copies keep drawing those two weights.
3. **When do you paste the 8 pages again?** (You already said you'd do this for the Emergency button fix.)
   - **A ⭐ Once, after this fix merges too.** It lands right after the Emergency button fix, and one paste covers both.
   - B. Paste after each fix: twice.
4. **What should the plugin do when a design uses a weight Google doesn't have?** (This wasn't the cause here, see below.)
   - **A ⭐ Keep today's way.** The panel names the weight and offers a font drop, and the browser shows the nearest weight. I checked: this doesn't break the page's other fonts, because Google skips a missing weight when the font has others.
   - B. Also say in the panel note which weight shows instead (e.g. "shows as 700").
   - C. Write the nearest weight into the paste.

## The request, played back

1. On Home and Repairs, the header's "SCHEDULE NOW" button (IBM Plex Mono) shows in Times Bold. The other agent's guess was that Google has no IBM Plex Mono 800. Find out first whether it comes from the plugin's paste or from your header template. If it's the plugin's, decide what it should do with a weight Google doesn't have.
2. Saira Condensed Thin and ExtraLight went up to your site as weights 250 and 275 (the numbers inside the font files), not 100 and 200. So a design using 100 or 200 doesn't find them. Find where the weight is read on upload and plan the switch to the standard CSS weight.
3. General logic only, built on top of the emergency-cta-width fix.

## Root causes (proven)

### 1. Times Bold in the header: the plugin's paste breaks Bricks' Google Fonts link for the whole page

**What Chrome draws** (`CSS.getPlatformFontsForNode` on the live pages, read only):
- Home, Repairs, Services: `SCHEDULE NOW` (`#brxe-gdeklp`, `font-family: "IBM Plex Mono"`, weight 800) is drawn with **Times-Bold**. No IBM Plex Mono face exists on the page at all.
- Gallery: the same header button is drawn with **IBMPlexMono-Bold**.

**Why:** Bricks loads every Google font (header, footer, Theme Style, page) through one link, `bricks-google-fonts-css`.
- On Home, Repairs, Services, About and Contact, that link answers **HTTP 400**. Google refuses the whole link, so no font in it loads, IBM Plex Mono included.
- On Gallery it answers 200.
- The difference is in the link itself. On the broken pages, Archivo, Saira and Saira Condensed each carry three extra weights: `100 900`, `250` and `275`.
- Tested against Google one change at a time:
  - **`100 900` is what breaks it.** It's malformed for Google, and any link holding it gets 400.
  - 250, 275 and 800 are harmless in a link that also asks for real weights: Google just skips them. That's why "Google has no 800" is not the cause.

**Where the extra weights come from:** the plugin's own `@font-face` lines for the site's font files (build 20.11, `src/ui/font-sources.ts` `siteFaceCss`, lines 34–43).
- They write the Saira variable file as `font-weight: 100 900` (line 39 writes `face.weight` as it is), and the Saira Condensed Thin and ExtraLight files as 250 and 275.
- In the Home page's CSS (`post-10.min.css`, read over HTTP), `100 900`, `250` and `275` appear **only inside those @font-face lines**: 3 times each, never anywhere else.
- They turn up in Bricks' link only for the three families those lines name, and only on pages that carry them. A fresh, uncached Gallery render is still clean.
- So Bricks copies the font weights it finds beside a Google font in the page's custom CSS into its link. A Bricks forum thread shows the same failure from a Theme Style weight of `bolder`.

**The 800 itself is not the plugin's:**
- Theme Style: `body {font-family: "Saira"; font-weight: 800}`.
- The header template's button CSS sets only `font-family: "IBM Plex Mono"`. It uses `var(--amber)`, which no paste uses, so the template was made outside the plugin.
- Figma: SemiBold 600. Both `corpus/files/hydraulics-home.json` and the debug file have "SCHEDULE NOW" as IBM Plex Mono SemiBold, `fontWeight 600`.

**emergency-cta-width alone won't fix it:**
- After that fix, Saira keeps its own variable face, so its `100 900` stays.
- I rebuilt the link Bricks would make after it: still **400**.
- The link with only single, standard weights: **200**.

**Why the tests didn't catch it:** `test/unit/ui-font-sources.test.ts` line 19 expects `font-weight: 100 900`. It locks the bug in.

### 2. Thin and ExtraLight went up as 250 and 275

- I downloaded the live files (public GETs) and ran the plugin's own reader, `readFontInfo` (`src/ui/sfnt.ts`), on them:

| File | Its OS/2 weight | Its style name | Uploaded as |
|---|---|---|---|
| SairaCondensed-Thin.woff | 250 | "Thin" | "250" |
| SairaCondensed-ExtraLight.woff | 275 | "ExtraLight" | "275" |
| SairaCondensed-Light.woff … Black | 300 … 900 | Light … Black | same |

- Some font makers write 250 and 275 for Thin and ExtraLight (an old Windows habit). CSS and Figma call them 100 and 200.
- **Where it's read:**
  - `sfnt.ts` line 102 takes OS/2 `usWeightClass` as it is. Only the 1–9 scale and 0 are corrected (lines 103–104).
  - `font-files.ts` `named` (lines 62–63) turns it into the face's weight.
  - `site-fonts.ts` `createFace` (line 101) sends it as `fontWeight`.
- **What it costs:**
  - A design asking for 100 or 200 doesn't match these faces exactly, so the panel calls the weight "missing".
  - For a font Google doesn't have, the browser would draw 200 with the Thin file (250 is the next heavier).
  - A second drop of the same files is reported "Already on your site", so nothing ever corrects it.

## Approach

1. **Never write a weight range in the paste.**
   - A variable face from the site becomes one `@font-face` line per weight the design uses inside its range, each with a single weight and the same file.
   - I checked in Chrome with the real Saira variable file: each weight 100–900 draws exactly the same width either way, so the look doesn't change.
   - Every weight the plugin's lines show Bricks is then a plain number the design itself uses, and Bricks' link stays valid.
2. **Every weight the plugin handles is a standard CSS weight (100…900):**
   - on upload, a font's OS/2 weight that isn't a round hundred gives way to the weight its style name says (Thin → 100, ExtraLight → 200);
   - without a weight word, it goes to the nearest hundred (ties toward 400);
   - a round hundred stays as it is (today's rule); variable ranges stay ranges in the library.
3. **Faces already on the site (question 2, A):**
   - When the plugin reads the library, a single face with an in-between weight takes the weight its file name says (a trailing "-1" that WordPress adds is ignored).
   - A face whose name says nothing is left out, and Google fills that weight.
   - No write to the site.
4. Static faces still all go in the CSS, as today, now with standard weights.
5. **No `src/core` change:** corpus pastes stay byte-identical. The design's own weights in the paste are untouched.
6. **General:** nothing keys on a font name, a file name or a weight value. It works for any variable font, any font with an in-between OS/2 weight, and any site.

## Tasks (test first; ledger in `.superpowers/sdd/font-weight-gaps/progress.md`)

0. **Baseline and before proof.**
   - Run `npm run check` and `npm run corpus`; save the report and copies of `corpus/out/v2/*/bricks.json`.
   - Scratch proof script (text proof: the renderer loads neither Bricks' link nor site fonts, so pictures can't show this):
     - It imports the main folder's `src/ui/font-sources.ts` and `site-fonts.ts` with `env.fetch` stubbed.
     - The stub serves a font library rebuilt from the live `post-10.min.css`: 3 families, each with only its own faces and their `parent` (the state after emergency-cta-width), with weights stored as live (`100 900`, 250, 275).
     - It takes `result.fonts` from `npm run replay` of `corpus/files/hydraulics-home.json`.
     - It prints the paste's site @font-face weights, then builds the Google link from Gallery's live link plus each weight those lines name beside a family (Bricks' behaviour as seen live) and GETs it from Google. Expected now: **400**.
1. **Upload weights (red, then green).**
   - In `test/unit/ui-sfnt.test.ts`, using the generic `sfnt()` fixture:
     - OS/2 250 with style "Thin" reads 100; 275 with "ExtraLight" reads 200;
     - 350 with style "W3" reads 400; 600 with "Bold" stays 600;
     - the 1–9 scale and 0 behave as today; nameID 17 beats 2 for the style.
   - In `test/unit/ui-font-files.test.ts`: a dropped Thin with OS/2 250 becomes a `FontFile` of weight "100".
   - Fix: one small helper for the standard weight (from a number and a style name), in `src/ui/font-names.ts` or a new `src/ui/font-weight.ts`, used by `readFontInfo`.
2. **Faces already on the site (red, then green).**
   - Tests in `test/unit/ui-site-fonts.test.ts`, on the stand-in in `test/fixtures/panel.ts` storing in-between weights:
     - stored "250" with `…/Grot-Thin.woff` reads "100";
     - "275" with `…/Grot-ExtraLight-1.woff` reads "200";
     - "350" with `…/Grot.woff` is left out;
     - a range "100 900" stays;
     - `addFonts`: a dropped Thin (now 100) against the stored 250 Thin counts as "already", with no POST.
   - Fix: `faceOf` in `src/ui/site-fonts.ts` (as emergency-cta-width leaves it) uses the helper with the style words of the face's file name (`styleOfName` on the first `src`'s stem).
3. **The paste's site lines (red, then green).** In `test/unit/ui-font-sources.test.ts`:
   - Change the test at line 19, which expects `font-weight: 100 900`, to expect one line per design weight.
   - New tests:
     - every `font-weight:` that `siteFaceCss` writes is a single whole hundred;
     - a variable face covering design weights 300 and 500 gives two lines with the same file;
     - a design weight outside the range gives none;
     - an exact static face and a variable face both covering 400 give only the static's line for 400;
     - italics are handled apart from uprights.
   - `fontPlan`: the design's 100 shows "on your site" when the site holds a Thin stored as 250.
   - Fix: `siteFaceCss` in `src/ui/font-sources.ts`. Keep the file under about 300 lines.
4. **End to end (red, then green).** Extend emergency-cta-width's run test (`test/unit/ui-run.test.ts`): a Convert with WordPress connected and a site variable face gives a paste whose font CSS (Google's and the site's) has no `font-weight` with two numbers.
5. **After proof.**
   - Run the same scratch script on the copy's `src/ui`. Expected: single weights only, Saira Condensed Thin and ExtraLight at 100 and 200, and Google answers **200**.
   - Put the before/after text in the ledger and return it as `shots[]` text proof (no pictures: the look in the renderer doesn't change).
6. **Close.**
   - `npm run check` and `npm run test:browser` pass.
   - `npm run corpus`: every `corpus/out/v2/*/bricks.json` is byte-identical to the baseline (`cmp`), and the lint lines and the "Worse than v1" list are unchanged.
   - One review on opus, then one fix pass.
7. **Docs & records.**
   - Copy the plan to `docs/plans/2026-10-21-font-weight-gaps.md`.
   - Move the ledger to `docs/plans/2026-10-21-font-weight-gaps-ledger.md`.
   - Add a `docs/HANDOFF.md` section, "Weight ranges broke Bricks' Google Fonts link; font weights read as standard". It records the cause, the fix, the 8 pages to paste again, and the next free paste check number (the finisher renumbers it if another merge took it). The paste check, after the paste and LiteSpeed → Purge All:
     - on Home and Repairs, Bricks' `bricks-google-fonts-css` link answers 200 and holds no `100 900`;
     - Chrome draws "SCHEDULE NOW" with IBM Plex Mono (Bold, or SemiBold after 1A), not Times;
     - the page CSS has Saira Condensed Thin and ExtraLight at 100 and 200, and no `font-weight` with two numbers.
   - The finisher bumps `BUILD` at the merge and updates main `CLAUDE.md` "Start here" and "Where things stand" (fonts entry: the ruling changes from "every face of a used family goes in the CSS" to "every static face; a variable face once per design weight").
   - New `CLAUDE.md` rule (under "Working in this repo", Bricks facts): **Bricks copies every font weight it finds beside a Google font in the page, custom CSS included, into its one Google Fonts link. Google refuses the whole link for a malformed weight such as a range `100 900`, and every Google font Bricks loads on that page is lost (header, footer, Theme Style). The paste never writes a weight range or a non-number weight.** Also: **font weights the plugin uploads or reads are standard hundreds; a file's in-between OS/2 weight gives way to its style name.**

## Tests (test first, generic fixtures)

- `ui-sfnt`, `ui-font-files`: standard weights from in-between OS/2 values (task 1).
- `ui-site-fonts`: stored in-between weights read by file name, left out when the name says nothing, no duplicate upload (task 2).
- `ui-font-sources`: no ranges, one line per design weight, static before variable (task 3).
- `ui-run`: the whole font CSS of a Convert holds no two-number weight (task 4).
- **Proof each test catches the bug:** with the fix committed, run `git checkout HEAD~1 -- <fix files>`, see the new tests fail, then restore.

## Choices

- **1A:** you set the header button's weight to 600 yourself. Agents never write to the site.
- **2A:** faces already on the site are fixed by reading them, not by rewriting the library.
- **3A:** one paste of the 8 pages, after both fixes.
- **4A:** no change for weights Google lacks (proven harmless to the link).
- My rulings, not yet confirmed:
  - a round OS/2 hundred still wins over the style name (today's rule);
  - an in-between weight with no weight word goes to the nearest hundred on upload (ties toward 400) but is left out when read from the site;
  - a variable face is written only for the weights the design uses.

## Risks

- **Bricks' rule is inferred, not read in its code** (Bricks isn't open). The evidence is strong: those values exist only in the plugin's lines, only those families get them, only on pages carrying them, and the same happens on a fresh render. The paste check confirms it.
- **The fix needs the pages pasted again.** Until the 8 pages are pasted again, their header shows Times and their Bricks-loaded fonts stay off.
- **Reading by file name:** a face already on the site whose file name gives no weight is left out (Google's copy is used).
- **More lines for a variable font:** one per design weight, a few lines more. They draw the same (measured).
- **An intentional in-between weight** (a "Book" at 350) goes up as the nearest hundred. Figma's weights are hundreds, so that is what a design can match.

## Pipeline parts it touches

- Panel only:
  - `src/ui/sfnt.ts` (`readFontInfo` weight);
  - `src/ui/font-names.ts`, or a new small `src/ui/font-weight.ts` (the standard-weight helper);
  - `src/ui/site-fonts.ts` (`faceOf`, after emergency-cta-width);
  - `src/ui/font-sources.ts` (`siteFaceCss`).
- Tests: `test/unit/ui-sfnt.test.ts`, `ui-font-files.test.ts`, `ui-site-fonts.test.ts`, `ui-font-sources.test.ts`, `ui-run.test.ts`; `test/fixtures/panel.ts` (stored in-between weights).
- **No `src/core` change:** corpus pastes are byte-identical.

## Overlaps

- **emergency-cta-width:** same files (`site-fonts.ts`, `ui-font-sources`, `ui-site-fonts`, `ui-run` tests, `test/fixtures/panel.ts`). Build strictly after it merges. Its fix is needed but not enough for the header (tested: the link still answers 400 after it).
- **early-line-breaks:** no shared files. It measures live wraps, which also depend on fonts loading on the live pages.
- **test-cleanup:** may touch `test/fixtures/panel.ts`. Low risk.
- **phone-side-padding, frame-text-links:** no overlap.

## Other things found (not fixed here)

- **Site setting:** the Theme Style makes all body text Saira **800** (ExtraBold). Anything on the site without its own weight inherits it, like the header button (question 1).
- **Low (speed):** each pasted page loads its design's Google fonts twice: Bricks' link (every weight of each family, e.g. 18 for Archivo) and the paste's own @font-face copies.
- **Low:** the panel note for a weight Google lacks doesn't say which weight shows instead (question 4, B).
