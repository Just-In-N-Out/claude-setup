# media-reuse: a picture already in the site's Media is used from there

- **Job:** media-reuse (Full pipeline). **Date:** 2026-11-17. **Base:** main `7cd47756102e6b8cbf86d8a5e9c77ceb62ceb957` (Build 2026-11-17.5).
- **Builder copies this file to** `docs/plans/2026-11-17-media-reuse.md`. Ledger: `.superpowers/sdd/2026-11-17-media-reuse/progress.md`.
- **Evidence (planner):** `~/.hermes/plans/figma-to-bricks/evidence/media-reuse/planner/` (`README.txt` lists every file).
- **Both tools:** the Figma panel's "Pictures go: to WordPress" (`src/ui/`) and the importer's `site:upload`, `site:import`
  and importer app (`tools/lib/site-upload/`). One code path: the panel's uploader, which the command line already runs.
- **Every AC below is proposed** (the request stated none). "go" approves the plan, these ACs and the ⭐ answers.

## Questions for Justin (⭐ = what the builder takes under the standing auto-go)

- **Q1. What counts as "the exact same photo"?**
  ⭐ **A.** The same file (every byte equal, by SHA-256) made the same way (as it is, as AVIF at its own size up to
  2560 px, as AVIF shrunk to a given width…). The same name alone never counts; a resized, recropped or re-exported copy
  never counts; the same file at another "shrink" width is another picture (it would be blurrier or heavier than chosen).
  **B.** Also reuse a bigger copy of the same file for a smaller place (fewer uploads, heavier pages).
- **Q2. A reused picture whose Media item has no alt text at all.**
  ⭐ **A.** Fill it once, as today for a picture this computer uploaded: words typed in the design first, else the words
  alttext.ai wrote for it earlier (saved in the Figma file), else alttext.ai is asked now (1 credit, only in this case).
  **B.** Leave it empty: a reused picture is never described.
- **Q3. Words a person typed for the picture in the design (an annotation, the panel's Picture descriptions list,
  Decorative), when Media already has other words.**
  ⭐ **A.** They still replace Media's at the end of the run, as since 2026-10-07 (it is how a typed correction reaches
  WordPress). Only alttext.ai's words and guesses never replace words Media has. This narrows 2026-10-14's "alttext.ai's
  words replace whatever WordPress had" to new uploads and empty items.
  **B.** Never: a reused picture's alt in Media changes only through the list's Save.
- **Q4. Importer: this page's old site has other alt words for the picture than Media has.**
  ⭐ **A.** The page shows Media's alt (no Custom alt text is written), as today for a picture the record knows.
  **B.** The paste writes this page's words as Custom alt text on the Image.
- **Q5. Pictures uploaded before this build carry no mark.**
  ⭐ **A.** They stay as they are: found only through this computer's record or the Figma file's cache, as today. No
  existing item is renamed (that would be a write to items already in Media, which the uploader's rule forbids).
  **B.** A separate, later job: a one-time "mark my earlier uploads" he runs himself.
- **Q6. A reused copy that isn't in the format asked for** (the panel's original sent after the host refused WebP; the
  importer's as-served copy where no AVIF copy exists): ⭐ **A.** used as it is, as today for the record's own (media-avif-alt
  Q4); `--reupload-avif` still sends AVIF copies. **B.** Sent again in the format asked for.
- **Q7. Where the mark lives.** ⭐ **A.** In the media item's slug (`f2b-<32 letters>[-how]-image`): the uploader already
  writes the slug with every upload (no new write route), WordPress finds it by an exact, indexed match, and nothing a
  visitor sees changes but the attachment page's own address (`/f2b-…-image/`, which redirects to the file since WP 6.4).
  The file name and the title Media shows stay the picture's name. **B.** In the item's description (needs WordPress's
  text search: slow on thousands of items, never exact).

## Playback

Justin, 2026-11-17: "if we are uploading photos to media, if that exact same photo was uploaded via another page to media
we do not use alt text or upload that photo but read it from media via it being uploaded before by another page", for the
importer and the plugin. So: a picture about to go up that is already in that site's Media (put there for another page,
by either tool, from this computer or not) is used from Media (its id, address and the alt text Media has): no second
upload, no alttext.ai request. Everything else stays: one uploader, the typed `yes`, the password and key rules.

## What both tools do today (base 7cd47756), proven by stand-in runs

Code: the uploader keeps what it sent in a cache keyed `fingerprint(bytes) + "-" + how` (`src/ui/uploader.ts:57` uploadItem,
`:94` `opts.cache[v.fp] = entry`, `:104` the hit; `src/ui/files.ts:4` the 64-bit fingerprint; `src/ui/photos.ts:53`
`processing`: "" as it is, `avif-max2560`, `avif<width>` with shrink, `webp…`, `big<width>`). The panel's cache lives in
the Figma user's plugin storage per site; the command line's is `~/.config/figma-to-bricks/site-uploads.json` per
computer (`tools/lib/site-upload/flow.ts:83` pick, `record.ts`). They never meet. Nothing asks the site what it holds
except by the ids the cache names (`uploader.ts:201` checkHits; `prepare.ts:35` checkKnown). The upload's slug is the file
name (`src/ui/wordpress.ts:111`). alttext.ai is asked when the picture arrives (`src/ui/run.ts:125`), before anyone knows
whether it goes up; a cache hit then gets the AI's words written over Media's (`uploader.ts:223` syncAlts; rule of
2026-10-14).

Runs (`probe-panel.ts`, `probe-importer.ts` → `today-panel.json`, `today-importer.json`):

| Case | What happened |
| --- | --- |
| P1 panel, page 1 | 1 upload, 1 alttext.ai request |
| P2 panel, another page or Figma file, same computer | 0 uploads, but alttext.ai asked again (1 credit) and its new words written over Media's alt (`POST media/11`) |
| P3 panel, another computer (empty cache) | uploaded again (`truck-image-1.png`), alttext.ai asked again |
| P4 panel, same file later | no alttext.ai request, but the file's saved AI words written over Media's alt |
| I1 `site:upload`, page 1 | 5 uploads |
| I2 `site:upload`, another page, same computer | the shared logo reused through the record (4 uploads, "1 already in your library") |
| I3 `site:upload`, another computer (no record) | the logo uploaded again (`logo-120x40-image-1.png`) |
| I4 panel after `site:upload`, the very same bytes | uploaded again (the two caches never meet) |

So the duplicates are: another computer, the other tool, and (panel) a lost or other Figma user's cache; and even where
the upload is skipped the panel still spends a credit and rewrites the alt.

## What "the exact same photo" is, and where that is kept

- **The mark** = `f2b-` + the first 32 hex letters of the SHA-256 of the file's bytes (the file before the uploader
  changes it) + `-<how>` when the uploader changes it (`processing`'s word, the cache key's own) + `-image`. It is the
  cache key with a real hash in place of the short fingerprint, so the rule for "the same" is the one both tools already
  use on one computer. The command line's AVIF (made before the hand-over) is marked by its **source** file,
  `avifMark(source) = markOf(source, "avif-max2560")`, which is the panel's mark for the same file with "Photos as: AVIF"
  and no shrink: the two tools share AVIF copies. `src/ui/sha256.ts` (pure, already in the panel) hashes 1 MB in 21 ms,
  20 MB in 249 ms.
- **Kept in the media item's slug**, written with the upload itself: `POST wp/v2/media?slug=<mark>` (WordPress:
  `class-wp-rest-posts-controller.php` 1379-1380 takes `slug` into `post_name`; the uploader has always sent `slug`,
  until now the file's name). File name and title stay `<name>-image.<ext>`. The mark ends in `-image`, as every upload's
  slug must (an unattached upload owns `/<slug>/`).
- **Found by** `GET wp/v2/media?slug=<mark>,<mark>…&per_page=100&_fields=id,slug,source_url,mime_type,alt_text`
  (posts controller 258-260: `'slug' => 'post_name__in'`; 3054-3060: a list, each `sanitize_title`d; `class-wp-query.php`
  2225-2231: `post_name IN (…)`, the indexed column). Exact, never a search. Only an item whose slug **is** a mark asked
  for counts, with a whole id, an http(s) address and an image type; of two, the lower id. WordPress names a second item
  of one slug `<mark>-2` (`wp_unique_post_slug`): not the mark, never counted. A site that ignores `?slug=` and answers
  every item matches nothing.
- **Cost:** one request per 50 marks, only for pictures this computer's cache or record doesn't know; none in a dry
  run; none for a page whose pictures are all known. A library of thousands costs the same (an indexed lookup).
- **Fails safe:** no answer, a refused read, a renamed slug, an upload from before this build → not found → the picture
  goes up as today.

## Design (prototyped end to end; `prototype-src.diff.txt` applies on the base with `patch -p1`)

1. `src/ui/media-mark.ts` (new): `markOf`, `isMark`, `readMarked(wp, marks)`, `createFinder(wp)` (one per run: each mark
   asked once, marks asked in the same turn or while a read is out share a request of at most `MARK_BATCH = 50`; a
   failed read finds nothing and `error()` keeps the reason).
2. `src/ui/wordpress.ts` `uploadMedia(…, slug?)`; `src/ui/photos.ts` `Variant.mark?`.
3. `src/ui/uploader.ts`: options `finder?` and `markFor?`; `variantMark`; on a cache miss the finder is asked (found →
   cache filled, `stats.reused++`, `stats.found++`, no upload); a real upload sends its mark as slug; `add()` asks the
   finder at once so pictures added together share a read; the describer may be a function, called only when the
   picture really goes up or its Media item has no alt (`Words`); `syncAlts` rule below; `UploadResult.library` (Media's
   alt per reused picture, only from a run with a finder); `cancel()` also stops a picture whose read was out.
   Without `finder` the uploader's requests are byte for byte today's (site-media-upload's story pin stays green).
4. **Alt rule for a picture already in Media** (cache hit or found by mark), one rule for both tools: Media didn't
   answer → nothing; words a **person** typed in the design (`altTyped`, not equal to the saved AI words; Decorative
   too) → they replace Media's, as today; else Media has words → they stay, alttext.ai is not asked, saved AI words and
   guesses never replace them; else (empty) → the saved AI words, or alttext.ai's asked now, fill it.
5. `src/ui/run.ts`: `finder: createFinder(wp)`; the describer handed over as a function; the note says
   "(N found in your media library, put there by another page or computer: not uploaded again)"; `Outcome.library`.
   `src/ui/alts.ts` `altRows(pictures, described, library)`: a reused picture's row shows Media's words, not "missing",
   `library: true`; `src/ui/main.ts` tags it "Media".
6. Command line: `tools/lib/site-upload/in-media.ts` (new) `findInMedia(login, p, out)`, run right after `checkKnown`
   and before `makeFiles` in `several.ts` `beforeYes` and `tools/lib/site-import/after-scan.ts` (so no AVIF is made of
   a found picture). It asks, for each picture the record doesn't know, its AVIF mark and its as-served mark; fills
   `p.cache` (the record adopts it at the first save after the yes), `p.learn()`, drops found files from `p.waiting`,
   and prints **before the yes**:
   `N picture(s) already in Media, used as is (found in your library by its/their mark: another page, the Figma plugin or another computer put it/them there; not uploaded again, its/their alt text there stays):`
   then one line each `= <file> → media <id> (<file in Media>), alt in Media: "<words>"` or `none`. A failed read prints
   `Couldn't look in your library for pictures another page already put there (<why>): the ones this computer's record doesn't know go up as new.`
   The question then counts them "already in your library". `flow.ts`: `Login.finder`, `options(p, login)` with `finder`
   and `markFor`, `Picked.inMedia`. The existing after-upload step (`alt-ai.ts`) then describes only a found item whose
   alt is empty, unchanged code. The importer app runs `site:upload` itself (`tools/lib/importer-app/prompts.ts:15` reads
   only the question), so it shows the same lines.
7. `test/fixtures/wp-standin.ts`: `GET wp/v2/media?slug=` answers as WordPress (exact, lower case, citations in the
   code); options `ignoreSlug`, `marksRefused`, `redirectMarks`.

**Bricks-pro standard:** point 5 (pictures in the media library) is met better: one picture is one Media item whichever
page or tool brought it, its alt text is Media's (one place to change it), and no duplicate `-1` files pile up. No
paste's structure, classes or settings change.

## Acceptance criteria (all proposed)

- AC1 (proposed): Every picture either tool uploads carries its mark as its media item's slug (SHA-256 of the file and how it went up; the command line's AVIF by its source file); file name and title stay the picture's name.
  Test: `test/unit/ui-media-reuse.test.ts` → `AC1: every picture either tool uploads carries its mark in Media (its file's SHA-256 and how it went up); the file name and title stay`
- AC2 (proposed): Only the very mark counts: an item with the same file name, WordPress's `-2` copy or a non-picture carrying the mark is not the picture (it goes up); of two items with the mark the older is used.
  Test: `test/unit/ui-media-reuse.test.ts` → `AC2: only the very mark counts: a same-named file, WordPress's -2 copy and an item that is no picture are not the picture; of two the older is used`
- AC3 (proposed): Panel: a picture the panel put in Media from another computer (empty cache), under another layer name, is used from Media: 0 uploads, 0 alttext.ai requests, nothing written, the paste shows that item, the note says it was found.
  Test: `test/unit/ui-media-reuse.test.ts` → `AC3: a picture the panel put in Media from another computer is used from there: no upload, alttext.ai not asked, its alt text left`
- AC4 (proposed): Panel: a picture `site:upload` put in Media is used by the panel (the two tools share one mark).
  Test: `test/unit/ui-media-reuse.test.ts` → `AC4: a picture the command line put in Media is used by the panel`
- AC5 (proposed): `site:upload` on a computer with no record: a picture another computer's run put in Media is listed "already in Media, used as is" with its id, file and alt before the question, counted "already in your library", not sent; the pastes and `media.json` show it; the record takes it after the yes and the next run asks Media nothing.
  Test: `test/unit/site-upload-media-reuse.test.ts` → `AC5: a picture another computer's run put in Media is found before the yes, listed, not sent, and the pastes show it`
- AC6 (proposed): `site:upload` uses a picture the Figma panel put in Media, leaving Media's alt; an answer other than yes sends nothing and writes no record.
  Test: `test/unit/site-upload-media-reuse.test.ts` → `AC6: a picture the Figma panel put in Media is used by the command line; an answer other than yes sends and records nothing`
- AC7 (proposed): Default `site:upload` (AVIF): a picture another computer's run made into AVIF is found by its source file's mark; no AVIF is made of it and it isn't sent; only the new picture is made and sent.
  Test: `test/web/site-upload-media-reuse.test.ts` → `AC7: a picture another computer's run made into AVIF is found by its source file's mark: no AVIF is made of it and it isn't sent`
- AC8 (proposed): A run whose record was lost (stopped before it heard back) finds its uploads by their mark: one read, no file downloaded to compare, nothing sent twice.
  Test: `test/unit/site-upload-media-reuse.test.ts` → `AC8: a run stopped before it heard back finds its uploads by their mark: no file is read, none is sent twice`
- AC9 (proposed): Cost: 120 new pictures added together cost 3 reads of Media (50, 50, 20 marks), each picture asked once; the same pictures again on that computer cost none.
  Test: `test/unit/ui-media-reuse.test.ts` → `AC9: Media is asked once per 50 new pictures in a run and never about a picture this computer already knows`
- AC10 (proposed): The same name with other bytes, and the same file made at another size, are other pictures: each goes up under its own mark.
  Test: `test/unit/ui-media-reuse.test.ts` → `AC10: the same name, or the same file made another size, is not the same picture: it goes up`
- AC11 (proposed): Panel, same computer: a picture uploaded before whose Media item has alt text is not sent to alttext.ai again and Media's words stay (today: 1 credit and an overwrite).
  Test: `test/unit/ui-media-reuse.test.ts` → `AC11: a picture this computer uploaded before, whose Media item has alt text, is not sent to alttext.ai again and keeps Media's words`
- AC12 (proposed): `site:upload` with AI alt text: of two found pictures, only the one whose Media item has no alt is sent to alttext.ai and filled; the one with words is never sent and keeps them; that one `POST media/<id>` is the run's only write.
  Test: `test/web/site-upload-media-reuse.test.ts` → `AC12: alttext.ai is asked only about a found picture whose Media item has no alt text; one with words is never sent and keeps them`
- AC13 (proposed): Panel: a reused picture whose Media item has no alt is described once and filled (Q2 A); words a person typed in the design still reach Media (Q3 A).
  Test: `test/unit/ui-media-reuse.test.ts` → `AC13: a reused picture whose Media item has no alt text is described once and filled; words a person typed in the design still reach Media`
- AC14 (proposed): The panel's Picture descriptions list shows, for a reused picture, the alt text Media has (marked "Media"), and doesn't count it missing.
  Test: `test/unit/ui-media-reuse.test.ts` → `AC14: the panel's Picture descriptions list shows the alt text Media has for a reused picture, and doesn't count it missing`
- AC15 (proposed): Where nothing is reused the command line is as before: the base's `site:upload` and this tree's, on the same scan and an empty library, write `media.json`, every paste and the notes byte for byte, print the same lines and send the same files with the same alt text (story pin against the base tree).
  Test: `test/unit/media-reuse-pins.test.ts` → `AC15: a run that reuses nothing writes media.json and the pastes byte for byte as the base's code, prints the same lines and sends the same files`
- AC16 (proposed): Reuse adds no write and no other site: a run that finds everything sends only GETs, every media item is as it was, the read names only marks, and a read answered with a redirect to another site is refused (that site never asked), named in one line, the pictures going up as new to the typed site.
  Test: `test/unit/site-upload-media-reuse.test.ts` → `AC16: reuse adds no write: what is found is only read, from the typed site only; a redirected read is refused and nothing is taken from it`
- AC17 (proposed): The password is in no request address, printed line, record or written file of a run that reuses pictures.
  Test: `test/unit/site-upload-media-reuse.test.ts` → `AC17: the password is in no request address, printed line, record or paste of a run that reuses pictures`
- AC18 (proposed): A dry run still asks no password and sends no request at all, whatever Media holds.
  Test: `test/unit/site-upload-media-reuse.test.ts` → `AC18: a dry run still asks no password, reads nothing and sends nothing, whatever Media holds`
- AC19 (proposed): A site whose Media list ignores `?slug=`, holding same-named, same-bytes files without marks (uploads from before this build): nothing is matched, every picture goes up as before.
  Test: `test/unit/site-upload-media-reuse.test.ts` → `AC19: a site whose Media can't be read by mark gets every picture as new, as before: nothing is matched by anything else`
- AC20 (proposed): `site:import` runs the same step: a page whose pictures another computer already sent is listed before the yes, the run only reads, Media holds no picture twice.
  Test: `test/web/site-import-media-reuse.test.ts` → `AC20: site:import looks in Media the same way: a page whose pictures another computer already sent is listed before the yes and nothing goes up`
- AC21 (proposed): Nothing else changes: no file under `src/core`, `src/plugin`, `src/shared`, `src/web` differs from the base (the plugin's conversion = replay holds, every Figma paste byte for byte), nor the password, key, guard, record or scrub code; under `src/ui` and `tools` only the files this plan names (story pin).
  Test: `test/unit/media-reuse-pins.test.ts` → `AC21: nothing the Figma conversion, the capture, the password, the key or the typed-site guard is made of changes; only the named upload files do`
- AC22 (proposed) (live): Justin's own check, paste check **3fn** (take the next free id if 3fn is used by then). (1) `npm run importer` from his terminal: a B-Dry page not yet imported that shares pictures (the logo, the badges) with one imported with this build → Pictures to WordPress → Log in and check: the list says "N pictures already in Media, used as is" before the yes, Media shows no picture twice, their alt text there is unchanged, the paste shows them. (2) In Figma, Pictures to WordPress on darksalmon: convert a page, then another page or file holding one of its photos: the notes say "1 found in your media library … not uploaded again" (or reused), Media shows it once, its alt text is unchanged, the Picture descriptions row is tagged "Media". Pictures uploaded before this build aren't found by mark (Q5): the first run with this build may send them once more.

## Tasks (test first; one commit a task; `npm run check` green at each commit)

The complete code of every task is the prototype: `prototype-src.diff.txt` (source) and `prototype-tests.diff.txt`
(tests, fixture, stand-in) in the evidence folder, both made against 7cd47756 and proven to apply with
`patch -p1 --dry-run`. Type the hunks of the files a task names (or apply them with `patch -p1` and `git add` by file);
re-read each hunk against the code you see, the diff is the starting point, not a substitute for the tests.

0. **Setup.** Copy this plan to `docs/plans/2026-11-17-media-reuse.md`; start the ledger; `npm run check` and
   `npm run corpus` on the untouched branch, tallies in the ledger. Make the base tree for the story pins:
   `git archive --format=tar -o ~/.cache/media-reuse-builder/base.tar <merge-base>`, unpack, link `node_modules`.
1. **The stand-in answers `?slug=` as WordPress does.** `test/fixtures/wp-standin.ts`: the `slug` filter on
   `GET wp/v2/media` (exact, lower-cased list; cite posts:258-260, 3054-3060, query:2225-2231) and the options
   `ignoreSlug`, `marksRefused`, `redirectMarks`. Add `test/fixtures/media-reuse.ts`. No behaviour of the tools changes;
   the existing suites stay green.
2. **The red tests.** Add `test/unit/ui-media-reuse.test.ts`, `test/unit/site-upload-media-reuse.test.ts`,
   `test/unit/media-reuse-pins.test.ts`, `test/web/site-upload-media-reuse.test.ts`,
   `test/web/site-import-media-reuse.test.ts`. Run them: expected red by assertion, as `red-on-base.txt` shows for each
   (the upload's slug is the file name; uploads 1 ≠ 0; no "already in Media" line; alttext.ai asked 1 ≠ 0; the list row
   missing). The tests for the criteria numbered 15, 17, 18, 19 and 21 pass already: they pin what must not change.
   Commit the tests with the task that turns them green if the repo's "each commit green" rule is applied strictly:
   then keep this step's red run as a ledger receipt (the log), not a commit.
3. **The mark.** `src/ui/media-mark.ts` (new), `src/ui/wordpress.ts` (`slug?`), `src/ui/photos.ts` (`Variant.mark?`).
   Nothing calls them yet: `npm run check` stays green. The helpers' own tests (`test/unit/media-mark.test.ts`: the
   mark's shape and equality across tools, `readMarked`, `createFinder`'s batches) land with Task 6, since they also
   use the uploader's `variantMark` and the command line's `avifMark`; they import new modules, so they are helper
   tests, never a behaviour RED.
4. **The uploader.** `src/ui/uploader.ts` as designed (points 3 and 4). In the same commit, the two tests that pin the
   old rule or the old request count through the uploader: `test/unit/ui-uploader.test.ts` (see "Tests that pin the old
   behaviour"). Green now: the criteria numbered 2 and 10 need Task 5's finder in the panel; run them after Task 5.
5. **The panel.** `src/ui/run.ts`, `src/ui/alts.ts`, `src/ui/main.ts`; `test/unit/ui-run.test.ts`'s three edits in the
   same commit. Green: every test of `ui-media-reuse.test.ts` but the first and the fourth (they also run the command
   line: Task 6).
6. **The command line.** `tools/lib/site-upload/in-media.ts` (new), `flow.ts`, `several.ts`,
   `tools/lib/site-import/after-scan.ts`; `test/unit/site-upload-stop.test.ts`'s two edits,
   `test/web/site-upload-avif.test.ts`'s one and `test/unit/media-mark.test.ts` in the same commit. Green:
   all of `ui-media-reuse`, `site-upload-media-reuse`, `media-mark`, both web files, the story pins
   (`F2B_STORY_PINS=1 F2B_BASE_TREE=<base tree> node --test test/unit/media-reuse-pins.test.ts`).
7. **Guards can fail** (`mutation-testing-discipline`, each run under `systemd-run --user --scope -p MemoryMax=4G -p
   MemorySwapMax=0`): one reversal mutant per guard, each killed by assertion by the named test: `readMarked` takes any
   item of the reply (drop `asked.has(slug)`) → the tests of criteria 2 and 19; the image-type check dropped → 2;
   `markOf` ignores `how` → 10; the lower-id rule reversed → 2; `syncAlts` writes the AI's words over Media's → 11 and
   3; the describer called eagerly in `run.ts` → 3; `findInMedia` moved after `makeFiles` → 7; its lines not printed →
   5; `finder` left out of `options()` → 5 and 8; `guardFetch`'s redirect refusal bypassed for the read → 16.
8. **Gates.** `npm run check`; `npm run corpus` (must equal Task 0's); the upload commands' web suites one file at a
   time (`node --test --test-concurrency=1 test/web/site-upload-*.test.ts test/web/site-import-*.test.ts
   test/web/importer-app-upload*.test.ts test/web/media-avif*.test.ts`), compared with the same run on the base tree
   (the planner's run: `web-tally.txt`); `F2B_STORY_PINS=1 node --test --test-name-pattern="AC12"
   test/unit/site-upload-panel-unchanged.test.ts` (green on the base and on the prototype, unedited). One terminal
   capture per criterion into the evidence folder; for the list's "Media" tag a screenshot of the panel's row if the
   panel can be drawn, else the capture.
9. **Docs & records.** `docs/HANDOFF.md`: a "media-reuse" section (what it does in both tools, the mark, the alt rule,
   Q1–Q7 ⭐ not yet confirmed, limits below, paste check 3fn, follow-ups). Move the ledger at the finish. Leave for the
   finisher, in the ledger, the CLAUDE.md lines: the Status line; in "One uploader writes to WordPress": "fills the
   empty alt text of an item it uploaded itself **(in its record, or carrying its mark)** whose file still matches" and
   "besides the media routes it reads … **and the media list by mark (GET `wp/v2/media?slug=`)**"; a standing rule:
   "A picture is looked for in the site's Media by its mark before it goes up (`src/ui/media-mark.ts`); never matched by
   name; a picture already in Media keeps Media's alt text: alttext.ai is asked only where Media has none"; in
   Decisions, Q8 A of site-media-upload ("no alttext.ai") and 2026-10-14's overwrite as narrowed by this job. No
   `reference/bricks` file changes. `skill_lessons` in the report.

## Tests that pin the old behaviour (edited in the task that changes it; the prototype's diff holds each edit)

- `test/unit/ui-run.test.ts:34` "pictures upload while Figma is still exporting the others, and the paste shows them": counts uploads (requests with a body), since the read of Media by mark now comes first.
- `test/unit/ui-run.test.ts:75` "a run that stops keeps what uploaded and says why": its handler answered by request number; it answers the read with `[]` and counts uploads.
- `test/unit/ui-run.test.ts:85` "a conversion that fails stops the uploads that haven't started": the read answers at once, uploads counted (3).
- `test/unit/ui-uploader.test.ts:318` "an earlier upload gets the AI's words in WordPress, even over alt text typed there": the rule this job changes; rewritten as "an earlier upload keeps the alt text WordPress has: the AI's words go only where it has none".
- `test/unit/site-upload-stop.test.ts:69` "R1-1 a stop the tool hears (Ctrl+C, a closed window, a kill) loses no upload it sent; the next run sends each file once": still no list read by name; it now also expects the one read by mark.
- `test/unit/site-upload-stop.test.ts:148` "R1-1 a stop the tool can't hear (kill -9): the next run finds the uploads that went in, by reads only, and sends no file twice": its items are given file-name slugs first (uploads from before this build), so `lookForSent`'s search by name and bytes stays tested; the marked case is criterion 8's test.
- `test/web/site-upload-avif.test.ts:269` "AC5 a stopped AVIF run keeps what went up and the next run sends only the rest": part (b) expects `lookForSent`'s line; the same edit (file-name slugs on the three items before the next run). Found by the planner's web run (`web-tally.txt`: 62 tests, 60 pass, this 1 fail, 1 story pin skipped); it passes alone after the edit.

Not edited: `test/unit/site-upload-panel-unchanged.test.ts` (story pin; green unedited because `library` comes only from
a run with a finder), `test/fixtures/later-jobs.ts`, `test/unit/media-avif-untouched.test.ts`,
`test/unit/site-import-figma-unchanged.test.ts` (the last two are red on main already against their own base 56b5076b:
`file-list-pins-on-main.txt`; not this job's to repair), `test/web/media-avif-as-served.test.ts` (media-avif-alt's
story pin against its own base 02481763, the command line before AVIF and the saved password: not a pin of this base;
this job's own "as before" pin is criterion 15's, against the merge-base).

## Base tallies (planner, git-archive scratch trees; the builder records the worktree's own)

- Unit suite, base: 4178 tests, 4030 pass, 7 fail (corpus and debug files a git archive lacks), 141 skipped. Prototype:
  4198 tests, 4049 pass, 8 fail (the same 7 and one load flake that passes alone), 141 skipped (`unit-tally.txt`).
- Typecheck (`tsc --noEmit -p .` and `-p tsconfig.sandbox.json`) clean on the prototype.
- New tests on the base's source (`red-on-base.sh`): 16 red by assertion (the criteria numbered 1–14, 16, 20), 5 pass
  by design (15, 17, 18, 19, 21: they pin what must not change); on the prototype all 21 pass (`red-on-base.txt`).
- Story pin `site-upload-panel-unchanged` (its uploader half) green on the base and on the prototype, unedited.
- Web suites of the upload commands on the prototype: 62 tests, 60 pass, 1 fail (the pin of old behaviour named above,
  green after its edit), 1 story pin skipped (`web-tally.txt`).

## Files shared with jobs in flight (hunks are elsewhere in each file; imports adjoin)

- **short-class-names** (`short-class-names-on-main8`, a06bb029): `src/ui/main.ts`, `tools/lib/site-upload/flow.ts`
  (it changes `pick`'s signature and an import), `tools/lib/site-upload/several.ts`,
  `tools/lib/site-import/after-scan.ts`, `docs/HANDOFF.md`. Whichever merges second re-runs both jobs' AC tests
  (`AC15`'s pin compares against the merge-base, so it follows a rebase by itself).
- **fewer-kept-boxes** (`fewer-kept-boxes-on-main9`, 1cb96456): `docs/HANDOFF.md` only.

## Security (unchanged rules, each with its test)

- No new write route: the only writes stay `POST wp/v2/media` (a new item, its slug now the mark) and
  `POST wp/v2/media/<id>` `{alt_text}` on an empty alt (criteria 12, 16). No item's slug, file or title is ever changed.
- Reads: one more GET, `wp/v2/media?slug=`, through the same guarded fetch (the typed site's origin only, no redirect
  followed; criterion 16), after the login, before the typed `yes`; found items are listed before the question
  (criterion 5); a dry run sends nothing (criterion 18). The typed `yes` is still asked, also when nothing is new.
- Password and alttext.ai key: no code that holds them changes (criterion 21 pins the files); the read carries no
  secret in its address (criterion 17). Agents test only against the stand-ins; only Justin runs it on his sites.

## Limits and risks (for HANDOFF)

- Uploads from before this build carry no mark (Q5): another computer or the other tool sends them once more.
- A person who changes an item's slug in Media, or a plugin that rewrites slugs, makes it unfindable: it goes up again.
- A file replaced in Media with a "replace media" plugin keeps its mark: the replaced picture is used (as today for a
  cached id). The panel's own slug repair (`src/ui/site-media.ts:72`) renames only a media item sitting on a page's
  address; a mark never does.
- Two computers sending the same new picture in the same minute both upload it (the second becomes `<mark>-2`); later
  runs use the older.
- The importer's dry run can't say what Media holds (it asks no password).
- The panel's alt rule change is visible: a re-run no longer refreshes Media's alt with new alttext.ai words (Q2/Q3).

## Completion and report

Stop at `ready-for-review` with: every criterion's test green (story pins run with their variables), the seven edited
tests named, Task 7's mutant table, the gates' tallies against Task 0's, one capture per criterion, the rulings taken
(Q1–Q7 ⭐), follow-ups, and `skill_lessons`.
