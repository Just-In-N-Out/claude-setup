# standin-drift: "main draws the B-Dry stand-in worse than 7b7501bd did" — not real; the offline run had no fonts

Planner, 2026-11-17. Investigated on main `7cd47756102e6b8cbf86d8a5e9c77ceb62ceb957` (Build 2026-11-17.5) and on
`7b7501bd` (Build 2026-11-12.1). Nothing in the repo was changed. Evidence:
`/home/justin/.hermes/plans/figma-to-bricks/evidence/standin-drift/planner/` (`rows.txt` holds every comparison below;
`reports/`, `logs/`, `scripts/`, `gmirror/`, `prototype/`, `tests/`).

## Questions (⭐ = my answer; all for Justin or the orchestrator, none blocks the verdict)

- **Q1. Build the small checker fix below (job "standin-drift", Mini)?** ⭐ **A: yes.** `site:check` says when a font it
  asked for didn't load. Two files and two tests; no paste changes by a byte. B: no; only the note for agents (how to
  draw offline with fonts, section 7).
- **Q2. When a font didn't load, does `site:check`'s exit code change?** ⭐ **A: no.** One line and one report field; the
  exit code stays the measurement's own (22 test files run the command, and a fixture family Google lacks would turn
  them red). B: a new exit code 3, "not comparable".
- **Q3. `site:check` takes `F2B_FONT_SOURCE` (a css2-style address asked instead of Google Fonts), as `npm run capture`
  does?** ⭐ **A: yes.** The new tests need a local font source to stay off the internet. B: no; then AC2's test asks
  Google Fonts for a made-up family.
- **Q4 (orchestrator). How do agents draw a capture offline from now on?** ⭐ **A: keep the no-network namespace and add
  the local Google Fonts mirror** (section 7; proven here). B: run `site:check` outside the namespace (its own Chrome
  resolves no host but 127.0.0.1, localhost and Google Fonts: `tools/lib/site-chrome.ts:8`).

## 1. Playback

1. The short-class-names mover recorded AC15's base rows again on main `7cd47756` and saw them far worse than the
   builder's rows on `7b7501bd` (2026-11-14): the header link 10.5–11.3 px off at every width from 768 up (0 before),
   the page's worst 907 px (64 before), the footer up to 211 px (0.11 before).
2. Both sets of rows are `npm run site:check -- <capture> --all --no-shots` on the same file: the B-Dry stand-in capture
   the builder made on `7b7501bd` (`short-class-names/builder/base-rows/standin-capture.json`, sha256 `77ecea38…`).
3. The question: did main get worse at drawing it, and if so which build did it?

## 2. Verdict

**Not real. Main draws the stand-in better than `7b7501bd`, not worse.** The two sets of rows were made in two
different setups: the builder's run could fetch the page's fonts from Google Fonts; the mover's run was inside the
no-network namespace (the agents' rule since 2026-11-15), where it could not, so every word was drawn with a fallback
font. The same thing happens on `7b7501bd`'s own code. No first bad build, no bad commit, nothing to bisect.

The stand-in drawn by each tree in the same setup (38 widths × 3 parts = 114 rows a route; both routes agree):

| Setup (all inside the no-network namespace) | `7b7501bd` worst (header / page / footer) | main `7cd47756` worst | Rows where main is worse |
|---|---|---|---|
| No fonts (as the mover ran it) | 11.27 / 983.84 / 210.99 px | 11.27 / 907.14 / 210.99 px | 0 of 114 (17 better) |
| Google's fonts, from a local mirror | 0.01 / 64 / 0.11 px | 0.01 / 0.01 / 0.11 px — **OK, within 2 px** | 0 of 114 (30 better) |
| The same, `--whole` | worst 64 px | worst 0.11 px — **OK** | 0 of 114 (30 better) |

- My no-fonts run of main equals the mover's record row for row (114 of 114, both routes): his numbers are the
  no-fonts numbers.
- `7b7501bd` with the mirror equals the builder's 2026-11-14 record row for row (114 of 114, both routes): the mirror
  reproduces the builder's setup, and the only difference between his run and the mover's is the fonts.
- With fonts, main is within 0.11 px at every width on both routes. `7b7501bd`'s 64 px was the hero heading set in
  "ADLaM Display": main asks the font source for it since site-fonts-match (Build 2026-11-12.2,
  `test/web/lib/site-check.ts:49`), `7b7501bd` did not.
- Without fonts, the 17 rows where the trees differ are the widths from 767 down, where main is closer: mobile-fit
  (Build 2026-11-17.2) leaves 33 filled boxes out of the comparison on purpose ("wider than the site on purpose").
- The short-class-names head `a06bb029` with the mirror: OK, worst 0.11 px, 114 of 114 rows equal to main on both
  routes. Its AC15 comparison (head against main, both without fonts) was a fair one; it only measured with the wrong
  font on both sides.

## 3. How it was reproduced

1. Two `git archive` trees (`7b7501bd`, `7cd47756`), `node_modules` linked, the same Chrome
   (`~/.cache/chrome-for-testing/chrome-f2b`), the same capture file, `--all --no-shots`, with and without
   `--elementor`, every run inside the no-network namespace under a 9G scope (`scripts/check-sdpl.sh`).
2. A font probe in that namespace (`scripts/fontprobe-sdpl.ts`, `logs/fontprobe-ns-plain.txt`): a line of words set in
   `Roboto, monospace` is exactly as wide as the same line in `monospace` (375.69 px at every weight) and the page holds
   no Roboto face: Google's stylesheet never arrives.
3. A local mirror of Google Fonts for the namespace: Google's own answers to the css2 requests `site:check` makes for
   these captures were fetched once with Node (`scripts/gmirror-sdpl.mjs`; no site of Justin's is touched, nothing of
   his is sent), then served inside the namespace on 127.0.0.1 by `scripts/gfont-sdpl.mjs`, with a Chrome wrapper that
   maps Google's two font hosts to it (`scripts/chrome-sdpl-fonts`, `scripts/nsf-sdpl.sh`). Every request is logged
   (`logs/*.fonts-asked.txt`). With it the probe line is 307.61 px at 400 and 311.05 px at 600: real Roboto.
4. An earlier try with three static Roboto files found on this computer (400, 500, 700; reports named `-fonts`) is
   superseded: without a 600 file the 600 words wrapped differently (footer 147 px on both trees). The `-gfonts`
   reports are the ones to read.

## 4. Root cause of the false alarm (file:line on main `7cd47756`)

1. The stand-in capture holds no font bytes: its four Roboto faces are `status: "loaded"`, `source: "site"`,
   `file: null` (measured with real Roboto when it was made on 2026-11-14).
2. For such faces `site:check` asks Google Fonts: `test/web/lib/site-check.ts:46` (`asked`: a loaded face with no
   bytes) and `:49` (the link, plus the failed faces the capture measured with a stand-in, `standInFaces` `:79`).
   Google's two font hosts are the only outside hosts its Chrome may reach (`tools/lib/site-chrome.ts:8`).
3. Inside the no-network namespace those requests fail. `site:check` never looks: it sets the page
   (`tools/site-check.ts:186`), waits for `document.fonts.ready` (`settle`, `test/web/lib/site-check.ts:381`) and
   measures. It prints nothing about fonts that didn't arrive, and its one fonts line even says the opposite
   (`tools/site-check.ts:148-149`, `failedFacesLine` `test/web/lib/site-check.ts:91`: "site:check draws them with the
   stand-in the capture measured with"), whether or not that stand-in loaded.
4. So a run without fonts looks like a run with a broken paste. The Figma route's corpus tool already guards against
   this ("EXPECTED FONTS NOT OBSERVED LOADED (non-comparable)", `test/browser/fonts.ts` `fontStatus`); the site route
   has no such check.

## 5. Justin's own scans (read-only copies, drawn offline, `--whole`, all widths)

His scans carry the bytes of every site font that loads, so they depend on Google only for the two faces the old site
fails to serve and the scan measured with Google's copy: "ADLaM Display" 400 and "Roboto" 600.

| Scan (2026-11-16) | Route | Rows | Main worse than `7b7501bd` | Main better |
|---|---|---|---|---|
| Home (48 widths) | Elementor | 144 | 0 | 39 |
| Home | plain | 144 | 0 | 34 |
| Basement Waterproofing (34 widths) | Elementor | 102 | 0 | 22 |
| Basement Waterproofing | plain | 102 | 0 | 22 |

- **A real paste does not worsen.** With the mirror, main's home page part is within 0.49 px at every width that
  compares (Elementor route).
- **But the same font gap bends agents' offline readings of his real scans:** main's `site:check` of the home scan in
  the plain namespace reads 39 of 144 rows worse than with the two fonts (up to 42.91 px on the page; `rows.txt` part
  9). Every "within 2 px" receipt an agent made offline on a scan with such faces since 2026-11-15 was measured with
  the wrong font for those words.
- Seen on both trees alike and not looked into here: the footer's 20 px rows on both scans with `--whole`, the home
  header's "nothing compared" at 8 phone widths, and the home page's "missing" at 878 and 340 (Elementor route).

## 6. Proposed fix: `site:check` says when a font it asked for didn't load (only if Q1 = A)

Nothing main pastes is wrong, so no conversion code changes and no paste changes by a byte (the Bricks-pro standard
is untouched: checker only). The fix is to the checker, so the next run without fonts says so itself.

### Acceptance criteria (all proposed)

- AC1 (proposed): Given a drawn page and the faces `site:check` asked a font source for, when they are read after the drawing, then a face is named exactly when no face of its family, weight and slant is loaded and the page either holds none (the stylesheet never arrived, or it lacks that weight or slant) or one of them failed; a face that loaded, a face a loaded weight range covers and a face no drawn word uses are not named; a face asked twice is named once. Test: `test/web/site-check-fonts-loaded.test.ts`, "AC1 an asked face that didn't arrive is named; one that loaded or that no word uses isn't".
- AC2 (proposed): Given a capture that lists a face it holds no bytes of and a font source that lacks it, when `npm run site:check` draws it, then one line starting `Fonts not loaded here:` names the family and weight before the OK/FAIL line, `report.json` lists it in `fontsNotLoaded`, the exit code is the measurement's own, and with `F2B_FONT_SOURCE` set that address is asked instead of Google Fonts. Test: `test/web/site-check-fonts-cli.test.ts`, "AC2 site:check names a font it asked for that didn't load, in its output and in report.json".
- AC3 (proposed): Given a capture whose asked faces all load, or that asks for none, when `npm run site:check` draws it, then no `Fonts not loaded here:` line is printed, `fontsNotLoaded` is an empty list, and the exit code and `ok` are as before. Test: `test/web/site-check-fonts-cli.test.ts`, "AC3 every asked font loaded, or none asked: no font line, an empty list, the same exit code".

No `(live)` criterion. Screenshots: a terminal capture of each test's run.

### Proven on a prototype (scratch copy of main, never the repo)

- The change: `prototype/site-check-fonts.diff.txt` (sha256 `0f381e6d…`, 2 files). The tests, complete:
  `tests/site-check-fonts-loaded.test.ts` (sha256 `cb7e9699…`) and `tests/site-check-fonts-cli.test.ts` (sha256
  `a9fc1f58…`).
- RED on main plus only the two test files, by assertion (`logs/test-red-*.txt`): the first fails `expected 'function',
  actual 'undefined'` (no `fontsNotLoaded`); the second fails both tests (no line; `report.fontsNotLoaded` undefined).
- GREEN on the prototype (`logs/test-green-*.txt`): 1 of 1 and 2 of 2.
- Regression on main and on the prototype alike: `test/web/site-check-cli.test.ts` 4 pass, 1 skipped;
  `test/unit/site-check-fonts.test.ts` 1 pass; `tsc --noEmit -p tsconfig.json` clean on the prototype.
- On the real inputs (`rows.txt` part 10): the stand-in without fonts prints `Fonts not loaded here: "Roboto" 400,
  500, 600, 700; "ADLaM Display" 400; "Roboto Flex" 400 …`, with the mirror nothing and `[]`; Justin's home scan
  without fonts prints `"ADLaM Display" 400; "Roboto" 600`, with the mirror nothing; the header part alone with the
  mirror prints nothing (the faces its words don't use stay unloaded and aren't named).

### Tasks (test first; one commit a task; base = main at the start, re-read HEAD first)

1. **The reading (AC1).** Copy `tests/site-check-fonts-loaded.test.ts` to `test/web/`. RED:
   `node --test --test-concurrency=1 --test-reporter=tap test/web/site-check-fonts-loaded.test.ts` fails with
   `expected 'function', actual 'undefined'`. Then, in `test/web/lib/site-check.ts`, as the prototype diff shows:
   export `type AskedFace`, `askedFaces(capture)` (what `fontsHead` asks: move lines 46 and 49's list into it and make
   `fontsHead` call it), `fontsNotLoaded(page, asked)` and `notLoadedLine(faces)`. That file is 481 lines already: the
   two new bodies may live in a new `test/web/lib/site-fonts-loaded.ts` as long as `site-check.ts` re-exports them
   (the tests read them there by name). GREEN: the same command, 1 of 1.
2. **The command (AC2, AC3).** Copy `tests/site-check-fonts-cli.test.ts` to `test/web/`. RED: both tests fail by
   assertion. Then in `tools/site-check.ts`: `fontsHead(capture, fontSource())` (`tools/lib/font-source.ts`, the
   capture's own `F2B_FONT_SOURCE` reader) with `fontsHead(capture, source?)` asking `source(family, faces)` once a
   family when given; after each page's widths are measured and before `page.close()`, add
   `fontsNotLoaded(page, askedFaces(capture))` to one list (each face once); write the list as `fontsNotLoaded` in
   both report shapes; print `notLoadedLine(list)` when it isn't null, before the OK/FAIL line. The line's words:
   `Fonts not loaded here: "<family>" <weights>; … (asked of the font source, Google Fonts unless F2B_FONT_SOURCE
   names another, which this run couldn't reach or which lacks them). Their words are drawn with the next font, so the
   numbers above are not the paste's: run it again where the font source answers`. Add `F2B_FONT_SOURCE` and the new
   line to the header comment of `tools/site-check.ts`. GREEN: 2 of 2.
3. **Gates.** `npm run check`; `npm run test:web` file by file, compared by test name with a base run of main (22 files
   run `tools/site-check.ts`; none may change); `npm run corpus` before Task 1 and at the close (no `src/` change, so
   equal). A receipt on the real input: `site:check --all --no-shots` of the stand-in capture inside the no-network
   namespace prints the new line naming Roboto 400, 500, 600 and 700.
4. **Docs & records.** The plan copied to `docs/plans/2026-11-17-standin-drift.md`; the ledger
   (`.superpowers/sdd/standin-drift/progress.md`) moved by the finisher to `docs/plans/2026-11-17-standin-drift-ledger.md`;
   a `docs/HANDOFF.md` section above the current top heading (what the line means, section 7's recipe, the finding of
   section 2; no paste check owed: no paste changes); no `BUILD` bump (a tool and tests only, as site-tests-offline);
   main `CLAUDE.md` Status: one line under site-tests-offline's; one new standing rule in "Working in this repo", word
   for word: **"A `site:check` run that prints `Fonts not loaded here:` (report.json `fontsNotLoaded`) drew those words
   with a fallback font: never compare its rows with the capture or with another run (standin-drift); offline, give it
   Google's fonts from a local mirror."**

### Rulings (mine, not yet confirmed) and risks

- R1: the older line ("site:check draws them with the stand-in the capture measured with") stays as it is; when the
  stand-in didn't arrive the new line right after it names those faces.
- R2: a weight no drawn word uses is not named (Chrome never asks for its file), so `--part header` doesn't name the
  page's fonts. A stylesheet that never arrived names every face asked of it, used or not.
- Risk: short-class-names (`a06bb029`, not merged) also edits `tools/site-check.ts` (28 lines added): whichever merges
  second rebases over the other. Both change the one import line from `../test/web/lib/site-check.ts` (it swaps
  `checkParts` for `checkOptions`, this job adds four names): one textual conflict, keep both sides' names. The rest
  is in different places of the file.
- Not planned (YAGNI): keeping Google's stand-in bytes inside the capture, a mirror shipped in the repo, a new exit
  code.

## 7. Drawing a capture offline with its fonts, today (for agents; proven here)

1. Once: `node scripts/gmirror-sdpl.mjs` (add the css2 requests your capture needs to its `ASKS`; a run's
   `*.fonts-asked.txt` lists any request answered 400, "not mirrored").
2. Each run: `bash scripts/nsf-sdpl.sh <tree> <log> tools/site-check.ts <capture> …`: it starts the mirror inside the
   namespace and points `CHROME_PATH` at `scripts/chrome-sdpl-fonts`.
3. Read the fonts log: every css2 request must be answered 200.
4. After the runs: `bash scripts/stop-mirrors-sdpl.sh` (the mirror outlives its run; the script ends each by its PID).

Copies of these scripts are in the evidence folder; the originals are in `~/.cache/sd-pl/` (the paths inside them
name that folder).

## 8. For the short-class-names job

Its AC15 gate holds: head and main agree on every row, with fonts (0.11 px, 114 of 114 rows on both routes) and
without. The base rows it recorded on main (`move-main8/names-base-main8/`) are no-fonts rows: fine as a base for
"no row worse", wrong as a statement about how main draws the page.
