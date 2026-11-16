# wave-code: on the About page Bricks held the drawer's Code elements with the wrong drawings (planner, Mini, bug; 2026-11-16, main 1d9a1f63, Build 2026-11-15.7)

## Verdict first

1. **The cause is in Bricks, not in our paste and not in the address the paste names.** Bricks 2.4.2's editor has its own window that lists unsigned code, with a **Sign all** button. When the server answers for one element, Bricks writes the answer (that element's whole settings: code, classes, signature) into **whichever element is active at that moment**, not into the element it asked about. Sign all stays pressable while it works, so a second or third press starts a second or third run, and each run's answers land in the element another run has just made active.
2. **Reproduced offline with Bricks' own code.** Bricks 2.4.2's signing routine, sliced from B-Dry staging's saved editor script and run on the five drawer Code elements: one press of Sign all leaves every drawing right; two presses 0.15 s apart leave three of the five wrong; three presses (at 0, 0.3 and 1.1 s, the server answering in 0.9 s) give **exactly what Justin copied out of the About page**: close, close, wave, wave, phone, with the signing seconds …384, …384, …385, …385, …386 his copy holds.
3. **Not proven: that Justin pressed Sign all more than once.** Nothing else in Bricks' editor writes one element's whole settings into another, and the pattern and the seconds fit, but only he can say (Q1). Anything else that changes the selected element while an answer is on its way does the same.
4. **No paste can stop it.** Bricks replaces the element's whole settings, so nothing we write in a Code element survives it. What we can change is what our tools tell the person to do: one sentence (below). The real fix is Bricks' (a report ready to send: Q3).

## What Justin does now

1. The About page: nothing. The header pasted at 08:49 is right, and it holds one Code element only (the upload turned the other four drawings into Icons), so nothing can be swapped there.
2. From now on, on every page: when Bricks' editor lists unsigned code after a paste, press **Sign all** one time only and take the hand off the mouse until that window closes by itself (about one second per Code element). Don't press it again and don't click anything else in Bricks meanwhile.
3. Or leave that window alone, save the page, and sign from **Bricks → Settings → Custom code → Regenerate code signatures** (signs on the server, element by element; no selected element is involved).
4. If a page ever shows one drawing in another's place: delete that pasted part, paste it again, sign with one press, save.

## Questions (⭐ = taken under the standing auto-go)

- **Q1 (only Justin can answer; nothing waits for it).** On the About page this morning, after pasting the header: did Bricks show its window of unsigned code, and did you press Sign all more than once (or again because nothing seemed to happen)?
- **Q2. Which words do our tools change?** A ⭐: the steps `site:import` and the importer app print after an upload, and one line under the app's Copy buttons (two files, no paste and no note changes by a byte). B: also the `Code:` line in every importer paste's notes (prototyped: it breaks three pinned tests, two of them sha256 sums of saved captures that must be remade and proven; the job is no longer Mini-small). C: no code, only the records.
- **Q3. Report it to Bricks?** ⭐ Yes, Justin sends it from his own account when he likes: the text is ready in `~/.hermes/plans/figma-to-bricks/evidence/wave-code/planner/bricks-bug-report.txt`. No agent sends it.
- **Q4. The Figma plugin's notes** (maps, lists, card arrows, the header spacer say "run … Regenerate code signatures"): ⭐ leave them in this job (they already name the safe route, and changing them breaks the plugin's pinned notes); a follow-up if Justin wants the sentence there too.

## Root cause, with evidence (Bricks 2.4.2, the editor script `builder-main-2.4.2.min.js`, one line long, so places are character offsets; sha256 f2ff33c1…0dde8, saved from B-Dry staging on 2026-11-09)

- `builder-main-2.4.2.min.js` @1876514 `generateCodeSignature`: sets `state.activeId = o.id`, sends `bricks_generate_code_signature` with that one element, and on the answer runs `i.$_state.activeElement.settings = n` (@1877750), `n` being the answer's settings. `activeElement` is read when the answer arrives, not when the request left. With Sign all (`r` true) it then calls itself for `state.unsignedCodeIds[0]`.
- @1878859 the Sign all button: `disabled: 0 === r.unsignedCodeElements.length` (only when the list is empty). @1879499 a row's own Sign code button: `disabled: o.isGeneratingCodeSignature`. So Sign all can be pressed again while a signing is on its way.
- @818478 `$u` (the watcher on `state.activeId`) makes `state.activeElement` the page's element of that id; @891939 `updateActiveElement` copies `activeElement`'s keys into it. So the write above lands in the page's real element.
- The server echoes the whole element with the signature added (Bricks 2.2's `includes/ajax.php` L169-185: `wp_send_json_success( [ 'element' => $elements[0] ] )`), which is why code **and classes** moved together in Justin's copy (the wave's Box held the ×'s code, the ×'s class `…svg-ryeh`, the ×'s signature and second).
- Signatures the server returns with a render or a save are safe: `applyAutoSignedCode` (@810134) writes only `signature`, `user_id`, `time`, and only where the id **and** the code match. `bricks_generate_code_signature` has one caller in the script (@1877244), the window above.
- Receipts (folder `~/.hermes/plans/figma-to-bricks/evidence/wave-code/planner/`): `bricks-2.4.2-sign-popup.txt` (the slices with their offsets), `popup-harness.cjs` (Bricks' own routines run with the browser, Vue's watchers and the server stood in; what is stood in is listed at its top), `popup-1-press.txt` (0 of 5 wrong), `popup-2-presses.txt` (3 of 5 wrong), `popup-3-presses-times.txt` (Justin's copy, seconds included), `codes.txt` (the two pastes and Justin's two copies, Code element by Code element), `about-paste-vs-copy.txt` and `home-paste-vs-copy.txt` (paste against Bricks' copy, element by element: only Code elements differ on About, none on home), `bricks-2.2-server-signing.txt`.

## Was it the paste's address (`https://www.figma.com` without an upload)? No

- Bricks' paste uses the paste's `sourceUrl` for two things only: it drops ids of internal links (@732167) and it swaps pictures that carry a media id for placeholders (@736400). The script names `sourceUrl` three times in all; the other two write it (the HTML import's own object, and Copy). Neither touches a Code element, and the old About paste had no picture with an id.
- Justin's re-test changed two things at once: the address **and** the number of Code elements. The header remade at 08:49 holds 1 Code element and 4 Icons (`imgs.txt`, its `notes.txt` line "4 Icons, 1 Code"); the first one held 5 Code elements. With one Code element nothing can be swapped.
- The home header names the site's own address, holds 5 Code elements, and went right: its five signatures carry the seconds …008 to …011, each element its own, as one run of Sign all gives.
- So a no-upload paste keeps naming `https://www.figma.com` (Bricks' picture rule needs it), and no refusal is planned.

## Who is at risk

Every paste that holds two or more Code elements, **uploaded or not, from the importer or the Figma plugin**, when its code is signed in the editor's own window and Sign all is pressed again while it works (or another element gets selected meanwhile). With one Code element in the page a second press only signs it twice. Signing from Settings → Custom code is not affected. The first About paste was not special: the home paste was exposed the same way.

## The change (ours: words only; nothing under `src/` changes)

- `tools/lib/site-import/next.ts`: the last-but-one step becomes `SIGN_STEP`: "Sign the pasted code: Bricks → Settings → Custom code → Regenerate code signatures. If you sign in Bricks' editor instead (its window listing unsigned code), press Sign all one time only and wait until that window closes by itself: a second press while it works makes Bricks put one element's code into another element." `site:import` prints it; the importer app shows it after an upload (`chains.ts` `uploadSteps` reads `nextSteps`).
- `tools/lib/importer-app/page/index.html`: under the Copy buttons, after `#media-line`, one always-shown line `<p id="sign-line" class="note">`: "After you paste: when Bricks lists unsigned code, press Sign all one time only and wait until its window closes by itself (a second press while it works makes Bricks put one element's code into another element), or sign from Bricks → Settings → Custom code → Regenerate code signatures." This is the place Justin stood in this morning (Scan, Copy header, no upload, no steps list).
- Bricks-pro standard: the pastes don't change; the paste Bricks holds stays the paste we wrote.
- Prototype (scratch export of main, `evidence/wave-code/planner/proto/`): `apply.cjs` makes the edits by anchor, `tests-hunk.ts` is the two tests; with only the tests applied 3 fail (`red.tap`: the two new ones and the pinned list), with the change 14 of 14 pass over `site-import-next`, `site-colours-out`, `importer-app-commands`, `importer-app-notes` (`green.tap`); `tsc --noEmit -p .` exit 0 (`typecheck.txt`). `test/web/site-import-run.test.ts:71` and `site-cli.test.ts:86` match `/Regenerate code signatures/`, still true.

## Acceptance criteria (all **proposed**)

- AC1 (proposed): Given `site:import`'s next steps for any parts, with and without a form, then exactly one step speaks of signing, after Save, and it is the sentence above word for word. Test: `test/unit/site-import-next.test.ts` "the signing step names the settings page and, for Bricks' own window, one press of Sign all and the wait"
- AC2 (proposed): Given the importer app, then its steps after an upload hold that same one step, and its page holds the `sign-line` sentence above between the Copy buttons and "Make pastes again". Test: `test/unit/site-import-next.test.ts` "the importer app says the same: in its steps after an upload and under its Copy buttons"
- AC3 (proposed): No paste changes by a byte: `git diff --name-only main...HEAD` names no file under `src/` and, of `tools/`, only `tools/lib/site-import/next.ts` and `tools/lib/importer-app/page/index.html`. Check (receipt, run when named): `git diff --name-only main...HEAD` saved in the evidence folder
- AC4 (proposed): The sentence is true of Bricks 2.4.2: Bricks' own signing routine run on five different Code elements leaves all five right after one press of Sign all, and at least one wrong after two presses 0.15 s apart. Check (receipt, run when named): `node popup-harness.cjs <builder-main-2.4.2.min.js> five-codes.json "0" 0.7` exits 0 and the same with `"0,0.15"` exits 1 (the planner's script and its generic fixture `five-codes.json`, copied into the checker's own folder; the Bricks script is `evidence/site-faq/planner/staging/builder-main-2.4.2.min.js`)
- AC5 (live): paste check **3fa**. Justin, on B-Dry staging: (a) his own importer app shows the line under the Copy buttons; (b) on a draft page he pastes `~/Downloads/bdryswi-com-home/header.json` (5 Code elements), signs with one press of Sign all, waits until the window closes, saves, and on the page at phone width ☰ shows the wave along the drawer's top, the two arrows by "Services" and the × in its corner; (c) if he wants the cause settled for good: on a second draft page the same paste, Sign all pressed three times quickly, then Structure → Offcanvas → Ctrl+C saved to a text file for us to read, and that draft deleted. He also answers Q1.

## Tasks (test first; `npm run check` green at each; `npm run corpus` before Task 1 and at the close)

1. Red: append `evidence/wave-code/planner/proto/tests-hunk.ts` to `test/unit/site-import-next.test.ts` and give the pinned list's line 35 the new words (`10. ${SIGN_WORDS}`); run `node --test test/unit/site-import-next.test.ts`: 3 fail.
2. Green: `SIGN_STEP` in `tools/lib/site-import/next.ts` (line 59 pushes it) and the `sign-line` paragraph in `tools/lib/importer-app/page/index.html`; the same command passes; then `npm run check`, and the app's page tests `node --test --test-concurrency=1 test/web/importer-app-page.test.ts test/web/importer-app-copy.test.ts test/web/importer-app-upload.test.ts test/web/site-import-run.test.ts` under `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0`. One commit.
3. The two receipts (the name list, the harness runs) into `~/.hermes/plans/figma-to-bricks/evidence/wave-code/`. Never bdryswi.com, staging or any live site; no login.
4. Docs & records: plan copied to `docs/plans/2026-11-16-wave-code.md`, the ledger; `docs/HANDOFF.md` section "wave-code" above the top heading (the cause in Bricks, the two places that say it, Q1–Q4 with ⭐ not yet confirmed, paste check 3fa at the top of the end-of-run list); `reference/bricks/README.md` gains a short paragraph "Signing code in the editor" (the window writes an answer into the active element; one press; the settings page is safe; offsets as above); at the merge the finisher's Status line and, in CLAUDE.md "The user's live site", after "Regenerate code signatures": "(in the editor's own window of unsigned code, Sign all one time only, then wait until it closes)"; `BUILD` as the repo's finish step says.

## Touched files and other jobs

- This job: `tools/lib/site-import/next.ts`, `tools/lib/importer-app/page/index.html`, `test/unit/site-import-next.test.ts`, `docs/HANDOFF.md`, `reference/bricks/README.md`, `docs/plans/`.
- photo-box-image, offcanvas-wave (`src/web/`), about-form (`src/core/site/elementor-fold.ts`), fewer-kept-boxes, link-keeps-name: `docs/HANDOFF.md` only.
- short-class-names (paused): its plan names `tools/lib/site-import/next.ts` (the "Import classes" words) and `reference/bricks/README.md`; clean-values (paused): `reference/bricks/README.md`. Different lines; whoever merges second keeps both.

## Size

Mini fits: two tool files, one test file, no design decision beyond Q2. With Q2 B it stops being Mini-small (`evidence/wave-code/planner/option-b-note-churn.txt`: `site-code-inventory`, `site-motion-old` and `site-slider-unchanged` break, the last two needing their sums remade and proven). With Q2 C nothing is built: only Task 4's records.
