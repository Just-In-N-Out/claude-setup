# multi-page-scan: the importer scans up to 3 pages in one go (Full, website importer)

Planner, 2026-11-16 21:00. Base: main `b2a05be9` (Build 2026-11-16.6). Plan only: nothing in the repo was changed, no
live site was loaded, nothing was sent to any WordPress. Evidence:
`~/.hermes/plans/figma-to-bricks/evidence/multi-page-scan/planner/` (index at the end).

## Questions for Justin (⭐ = what the builder takes under the standing auto-go)

- **Q1. How the three pages are scanned.**
  - ⭐ **A. One after another, in one run.** The app starts one scan command for all the addresses; it reads page 1,
    then 2, then 3. If the site asks "I am human", you press it once in the one Chrome window that opens, and the
    later pages are read in that same window (measured on the check stand-in: pressed once for two pages). Three of
    your pages take about 15–45 minutes this way (your own scans today took 5–16 minutes each); you can walk away
    after the first check.
  - B. Side by side (three scans at once). About three times faster, but up to 12 Chrome windows at once, three
    "I am human" windows to press, about 13 GB of memory at the peak on a computer capped at 20 GB (one home-page
    scan measured 4.4 GB), and three times the load on the old site, which already refuses some requests at 4
    windows. Not recommended.
- **Q2. Pictures to WordPress for several pages.**
  - ⭐ **A. One upload for all.** In Saved scans you tick up to 3 scans (the pages of a scan of several are ticked
    for you). "Log in and check" then covers all of them: the password typed once, one question, one typed yes; a
    picture that is on several pages (the logo, the footer photos) goes up once; each page's pastes are written in
    its own folder. Copy stays per page (open the page, Copy all).
  - B. One upload per page, as today (three logins, three yeses).
- **Q3. The command line.**
  - ⭐ **A. `npm run capture` and `npm run site:upload` take up to 3** (the app runs exactly these, so they must);
    `npm run site:import` stays one page per run.
  - B. `site:import` takes up to 3 pages too (`site:import -- <page 1> <page 2> <page 3> <https://your-site>`): one
    more round of building and checks, added after this job.
- **Q4. A 4th address.**
  - ⭐ **A. Refused before anything starts,** with one plain line ("Up to 3 pages in one go: take 1 address out and
    scan it next"). The same for a 4th tick in Saved scans.
  - B. Queued: any number of addresses, scanned in groups of 3 in one long job.

## Playback

Justin: "Can we make it so that the importer can allow for up to 3 different pages to get scanned?" Today, in the
importer app, he does one page at a time: Scan a page → Pictures to WordPress (List pictures, Log in and check, type
yes) → Copy all → paste, and he has a list of every B-Dry page to do. After this job he types up to 3 addresses (one
per line), presses Scan once, and gets three saved scans, each in its own folder with its own pastes; then one
"Log in and check" and one typed yes send the pictures of all three; then he copies and pastes each page.

**The Bricks-pro standard:** no paste changes. Each page's pastes are the files `npm run site` / `site:upload` write
for that page today, byte for byte; this job only changes how many pages one run covers.

## How a scan runs today (measured)

- **The app** (`tools/lib/importer-app/`): one job at a time (a second is refused, 409). Scan = three commands in a
  chain (`chains.ts` `scanChain`): `tools/capture.ts <address> --out <scans>/<page name> …` → `tools/capture-check.ts
  <capture>` → `tools/site.ts <capture> <folder> …`, then `importer.json` (the scan's record). Pictures to WordPress
  = one `tools/site-upload.ts <capture> <folder> <site> --user <name> …`; the password goes once to the command's
  own prompt (`jobs.ts` `look`), the yes is typed in the job panel. The saved-scans list is every folder of
  `~/Downloads` holding a capture (`scans.ts`).
- **capture** reads a page's width ranges in up to 4 Chrome windows (`--windows`); a site's person check closes the
  hidden Chrome and opens one visible window that is kept for the rest of the run (`src/web/human-run.ts`:
  `capture --all`'s pages already share it). The press guard and the socket gate are per Chrome
  (`launchCaptureChrome`).
- **site:upload / site:import**: one login, one typed yes per run; the record
  (`~/.config/figma-to-bricks/site-uploads.json`) keeps each file once per site, so a second page's run already
  skips what the first sent.
- **His five scans of 2026-11-16** (Build 2026-11-16.2, read from each capture's `web.timings`, 4 windows;
  `his-scans-2026-11-16.json`): About Us 5.1 min, Basement Waterproofing 6.7, Contact Us 11.6, Egress Windows 13.5,
  Home 15.8 (10–16 ranges, captures 8–42 MB). Between a scan's file and its upload's pastes: 1–7 minutes. Their
  five `media.json` files name 54 different pictures; 6 are on every page, and each page shares 7–12 of its 9–35
  with another page. Three of the five folders hold a `.f2b-refused.json`: the site refused something on the way
  with one scan's 4 windows.
- **One offline scan, measured** (`measure-*.json`): a small fixture through the real commands: capture 9.5 s (3
  ranges in 3 windows), 0.73 GB at the peak (the command's whole process tree), 1 Chrome with up to 11 renderer
  processes; `capture:check` 0.3 s; `site` 0.3 s. The saved B-Dry home stand-in (offline Chrome, 4 windows, no
  screenshots, other measures running beside it): 7.8 min, 10 ranges, **4.4 GB at the peak**, 1 Chrome with up to
  13 renderer processes.
- **Prototype, no repo file changed** (`proto-multi.json`): three fixture pages read one after another through one
  run, each into its own folder, are each the capture of that page scanned alone (no difference but the times); on
  the person-check stand-in two pages cost one press and two Chrome launches (the hidden try, then one visible
  window for both pages).

## Proposal (with the ⭐ answers)

### 1. `npm run capture` takes up to 3 addresses

`npm run capture -- <address> [<address 2> [<address 3>]] [--folders] [--out …] [--owned] [--design W] [--no-shots]
[--windows n]`

- The pages are read one after another through the run the command already makes (`captureRun`), so every Chrome
  still launches through `launchCaptureChrome`, the press guard and the person check are as today, and a passed
  check's window serves the later pages.
- `--folders`: each page's file goes into `<out>/<page name>/` (the name `site:import` and the app use:
  `captureName(address)` without its ending). Without it every file goes into `--out`, as `--all` writes them.
- Each host is asked about (client's own site) before the first page is read.
- **When a page fails** (its stylesheets never came, it kept reloading, it isn't the page itself: that one's file
  is still written for a look, as today, and shows in Saved scans as "no pastes yet") the next page is read; when nobody passes a check in 5 minutes or the site can't be reached, the rest are not tried (as `--all`).
  With more than one address, or `--folders`, each page ends with its own line, printed as soon as it is known
  (`Page scanned: <address> in <file>` or `Page failed: <address>`), so a run stopped half-way has already said
  which pages are done; the run ends with a `Page not tried: <address>` line for each page it never read and
  `Pages: 2 of 3 scanned`. Exit 0 only when every page was scanned, else 1.
- Refused with one line and exit 2, nothing read: a 4th address ("At most 3 pages in one run"), two addresses that
  are the same page, several addresses with `--list` or `--all`.
- One address without `--folders`: the same code path as today (`capturePages`), the same lines, the same file.

### 2. The app's Scan takes 1–3 addresses

- The address box becomes three lines tall: "The pages' addresses (up to 3, one per line)". One line sends today's
  request (`address`); two or three send `addresses`.
- One job. It runs `tools/capture.ts <a1> <a2> <a3> --out <scans> --folders …` once, then for each page that was
  scanned, in order: `capture-check` and `site` into that page's folder and its `importer.json`, exactly the steps
  a one-page scan runs after its capture (one shared function). The job panel says which page it is on.
- **One page fails:** its lines stay in "All lines", the others get their pastes, and the closing line names
  which pages are ready and which failed ("scan it again by itself"); the job's state then reads "failed", so the
  line is not missed. A range read without the site's styles on one page stops only that page.
- **Stop** ends the scan command and every Chrome, as today. Pages scanned before the stop keep their capture
  (no pastes yet): the closing line names them ("open it under Saved scans and press Make pastes").
- The saved-scans list shows every page; after a scan of several the pages are ticked for one upload (below).
- Refused before any command starts (400, one plain line, no value repeated): more than 3 addresses, the same page
  twice, an address that isn't http(s); `--folders` and `--also` as options ("set by the app itself").

### 3. `npm run site:upload` takes up to 3 scans in one run

`npm run site:upload -- <capture> <outDir> <https://your-site> [--also <capture 2> <outDir 2>] [--also <capture 3>
<outDir 3>] [the flags as today]`

- One site, one login, one alttext.ai key question, **one typed yes**. The flags (`--elementor`, `--svg`,
  `--fonts`, `--part`, `--colours`, `--record` …) hold for every scan of the run.
- Before the yes, for each scan under a heading line (`Scan 2 of 3: <outDir>`): what a one-scan run does there
  today (the library's word on known files, the AVIF files, files an earlier run sent, the fonts and forms lines).
  Then one question that counts each new file once across the scans:
  `Upload 21 new pictures (33 already in your library) to <site> as <name>, for 3 pages, 18 as AVIF…? Type yes: `.
- After the yes the scans go one after another with the same uploader and **one shared record**: before each
  scan's upload the tool learns again what the record holds, so a picture an earlier scan of this run sent is not
  sent again; each scan's `media.json`, `forms.json` and pastes are written in its own folder as a one-scan run
  writes them. Each scan ends with its own line (`Scan done: <outDir>` or `Scan with pictures missing:
  <outDir>`); a scan the run never reached gets `Scan not started: <outDir>` at the end.
- **One page's pictures fail** (a refused type, a file over the limit): the other scans go on; exit 1, named.
  **A stop** (Ctrl+C, the app's Stop): the scan in hand writes what went up (as today), later scans are not
  started and their folders stay as they were; the next run sends only what is missing.
- Refused before anything is read, asked or sent (exit 2): a third `--also`, `--also` without its two values, the
  same capture or folder twice. "Not yes": nothing uploaded for any scan.
- Without `--also`: the same statements in the same order as today, no new line printed.
- Not built now: a picture on several scans is made into its AVIF file once per scan before the yes (time only;
  it goes up once). Named as a follow-up.

### 4. The app's Pictures to WordPress covers the ticked scans

- Each row of Saved scans gets a tick box ("Upload together"); at most 3 can be ticked. With ticks, step 3 says
  "For 3 pages together: …" and both buttons (List pictures, Log in and check) cover the ticked scans; with none
  ticked it is the opened scan, as today.
- The request is today's (`POST /api/scans/<id>/upload`) with `also: [<id 2>, <id 3>]`; the app starts one
  `site-upload.ts … --also <capture> <folder>` and writes each folder's `importer.json` when that folder's
  `media.json` was written. The paste options sent hold for all (one command, one set of flags); a scan whose
  recorded options differ is named in one line.
- **The password and the key:** nothing new. The password still comes once in the request's body, goes once to the
  one prompt of the one command, and is held nowhere else; the yes is still typed after the question shows. The
  new arguments are only file paths. `site:upload` still asks before every run; no flag skips the yes.

### What stays byte for byte

- A one-page scan from the app: the same request, the same three commands with the same argument lists, the same
  files in the scan's folder (pinned: AC17).
- `npm run capture -- <one address>` and `npm run site:upload` without `--also`: the same lines, requests and
  files. `site:import`, `capture:check`, `site`, `site:check`, `site:live`, the helper, the Figma plugin and panel:
  untouched (nothing under `src/` changes; the builder checks `git diff --stat main -- src/` is empty).

## Acceptance criteria (all **proposed**: the request states none)

- AC1 (proposed): `npm run capture -- <a> <b> <c> --out <dir> --folders --owned` on the `listing` fixture reads the three pages one after another in one run (in the site's request log every load of page 1 comes before the first load of page 2, and every load of page 2 before the first of page 3), writes each capture into `<dir>/<page name>/`, each equal to that page scanned alone apart from `web.capturedAt` and `web.timings`, prints a `Page scanned:` line naming each file as its page ends and `Pages: 3 of 3 scanned` last, exit 0. Test: `test/web/capture-pages-many.test.ts` "AC1 three addresses are read one after another in one run, each into its own folder and equal to the page scanned alone".
- AC2 (proposed): With three addresses whose second is one the fixture answers with 404, pages 1 and 3 are scanned and page 2 is `Page failed:`, exit 1; with a second address at a closed port (`F2B_RETRY_MS=100,100`, as `capture-unreachable` sets it), page 1 is scanned, page 2 failed and page 3 is `Page not tried:`, exit 1. Test: `test/web/capture-pages-many.test.ts` "AC2 a page that fails is named and the next is read; a site that can't be reached leaves the rest not tried".
- AC3 (proposed): On the person-check stand-in (`serveCheckSite({ mode: "check" })`) two pages read through the command's own run (`captureMany` with `humanRun`) cost one press: one hidden Chrome is launched and closed, one visible Chrome is launched, both pages are the site's real pages. Test: `test/web/capture-pages-check.test.ts` "AC3 a person check is pressed once and the later page is read in that same window".
- AC4 (proposed): `npm run capture` exits 2 with one plain line and reads nothing for a 4th address, for two addresses that are the same page, and for several addresses with `--list` or `--all`; its usage line still starts `usage: npm run capture -- <address> `. Test: `test/web/capture-pages-many.test.ts` "AC4 a fourth address, the same page twice and several addresses with --list or --all are refused before anything is read".
- AC5 (proposed): From the app's page, three addresses typed one per line and Scan pressed once run one job to the end: each page's folder holds its capture and the paste files byte for byte what `npm run site -- <that capture> <folder> [the same options]` writes, its `importer.json` names its own address; the saved-scans list shows the three and all three are ticked for one upload; the closing line names the three. Test: `test/web/importer-app-scan-many.test.ts` "AC5 three addresses scanned in one go give three saved scans, each with exactly the files npm run site writes".
- AC6 (proposed): From the app, three addresses whose second fails: pages 1 and 3 have their pastes and `importer.json` and are listed, page 2 has no paste file, the job's closing line names page 2 as failed and the other two as ready, and only pages 1 and 3 are ticked. Test: `test/web/importer-app-scan-many.test.ts` "AC6 when one page fails the others get their pastes and the failed one is named".
- AC7 (proposed): `POST /api/scan` starts no command and answers 400 with one plain line that repeats no value for: 4 addresses, the same page twice, a list holding an address that isn't http(s), `addresses` that isn't a list of 1–3 strings, and `--folders` or `--also` among the options; one address sent as `addresses: [a]` starts the same command line as `address: a`. Test: `test/unit/importer-app-scan-many.test.ts` "AC7 more than three addresses, a repeated page, a bad address or a flag the app sets itself start nothing".
- AC8 (proposed): Stop pressed while page 2 of 3 is being read (a stub `capture.ts` that wrote page 1's capture and waits) ends the command's process group, starts no further command, writes no paste, and the closing line names page 1 as scanned without pastes. Test: `test/unit/importer-app-scan-many.test.ts` "AC8 Stop during a scan of several ends the command, makes no paste and names the pages already scanned".
- AC9 (proposed): Against the WordPress stand-in, `site:upload <c1> <o1> <site> --also <c2> <o2> --also <c3> <o3>` (three captures that share one picture) asks the user name once, the password once and one question naming 3 pages whose count is the number of different new files; after `yes` the stand-in got exactly one `POST wp/v2/media` per different file and no DELETE, PUT or PATCH; each folder holds `media.json` and pastes byte for byte what `npm run site -- <its capture> <folder> --media <its media.json>` writes; the record holds each file once; exit 0. Test: `test/unit/site-upload-many.test.ts` "AC9 three scans go up with one login and one typed yes, each file once, each folder with its own pastes".
- AC10 (proposed): With three scans where the stand-in refuses one picture of scan 2, scans 1 and 3 end as a one-scan run ends, scan 2's folder holds the pictures that went up and its line says pictures are missing, the closing lines name each scan, exit 1. Test: `test/unit/site-upload-many.test.ts` "AC10 a picture refused on one scan leaves the other scans whole and is named".
- AC11 (proposed): With three scans and a SIGINT while scan 2's pictures go up: scan 1's folder is complete, scan 2's holds what went up, scan 3's folder is as it was before the run and its line is `Scan not started:`, exit 130; the same command run again sends only the files not yet in the library (no file is POSTed twice over both runs) and ends 0. Test: `test/unit/site-upload-many.test.ts` "AC11 a run of several stopped half-way keeps what went up, leaves the scan not started alone, and the next run sends only the rest".
- AC12 (proposed): `site:upload` exits 2 before any request, prompt or file for a third `--also`, an `--also` with one value, and the same capture or folder twice (its line repeats no word typed); an answer other than `yes` to the one question uploads nothing and writes no `media.json` in any folder. Test: `test/unit/site-upload-many.test.ts` "AC12 a fourth scan, a half-given --also, the same scan twice or an answer that isn't yes send nothing".
- AC13 (proposed): `site:upload … --also … --dry-run` prints each scan's list under its `Scan <i> of <n>:` heading, asks no user name or password, sends no request with a login and writes nothing. Test: `test/unit/site-upload-many.test.ts` "AC13 a dry run of several lists each scan and sends nothing".
- AC14 (proposed): From the app's page with three saved scans ticked: List pictures shows the three lists; Log in and check with the password typed once shows one question; `yes` typed once ends with each folder's pastes byte for byte what `npm run site -- <capture> <folder> --media <media.json>` writes, each `importer.json` recording the upload, the stand-in holding each different file once, and next steps naming the three pages; the password box is empty once sent. Test: `test/web/importer-app-upload-many.test.ts` "AC14 three ticked scans upload with one login and one typed yes and each folder gets site:upload's files".
- AC15 (proposed): `POST /api/scans/<id>/upload` starts no command and answers with one plain line for: `also` with 3 ids, an id twice or the first scan's own id, an id that isn't listed, a loose capture among them; with no person at a terminal and a site that isn't this computer it is refused as today (403). A request without `also` starts today's argument list. Test: `test/unit/importer-app-upload-many.test.ts` "AC15 a fourth scan, a repeated or unknown scan or a loose capture start no upload, and one scan starts today's command".
- AC16 (proposed): During and after an upload of three ticked scans from the app, the made-up Application Password in every form `secretForms` lists, and the alttext.ai stand-in's key, are in no command's argument list or environment (every descendant's `/proc`), no file under the scans folder, HOME, TMPDIR or the record, no job line, no line the app logs and no request's address; the password prompt shows once and is answered once. Test: `test/web/importer-app-secret-many.test.ts` "AC16 an upload of several scans keeps the password and the key out of every argument, variable, file and line".
- AC17 (proposed): Named-only story pin (`F2B_STORY_PINS=1`, `F2B_BASE_TREE=<the base>`): the app of the base tree and of this tree each scan the same fixture page from one address and upload it to a fresh WordPress stand-in on the same port; every file in the scan's folder is the same byte for byte (the capture apart from `web.capturedAt` and `web.timings`, `importer.json` apart from its dates), and the commands were started with the same argument lists. Test: `test/web/multi-page-scan-one-same.test.ts` "AC17 a one-page scan and upload from the app write the base tree's files byte for byte".
- AC18 (proposed) (live): Paste check **3fj**, Justin's own. `npm run importer` from his terminal; type three B-Dry pages not yet done (one per line), Elementor and "This is my client's site" ticked, Scan; pass the "I am human" check once; when it ends the three pages are in Saved scans, ticked; Pictures to WordPress → Log in and check → type yes once; then for each page: open it, Copy all, paste into the Bricks page of the same name on B-Dry staging, save. Each page looks as on bdryswi.com at 1440 and 390, and Media shows no picture twice.

## The base today (run on `b2a05be9`, logs in the evidence folder)

- `test/unit/importer-app-*`, `site-upload-*`, `site-import-*`: 97 tests, 94 pass, 3 skipped (story pins), 0 fail.
- `test/web/importer-app-*`, `capture-cli`, `human-once`: 30 tests, 28 pass, **2 fail on the base already**, both
  in the app's own tests and neither this job's doing (the builder compares its runs with the base by test name):
  - `test/web/importer-app-notes.test.ts:46` (fails every time, 3 of 3 runs): it expects a scan folder's other
    files to be `palette.json` and `structure.txt`; `npm run site` now also writes `styles.txt`. A stale test.
  - `test/web/importer-app-page.test.ts:124` (failed in the subset and in 1 of 2 runs alone, so it comes and
    goes): after Scan is pressed the job panel's title sits below the window (top 924 px in a 900 px window).
    Cause not looked into here.
  Both are outside this job (a report about another part is its own job): named to the main session as one small
  quick fix. This job's builder doesn't fix them; if the quick fix lands first, the builder rebases on it.

## Tasks (test first; one commit a task, each green)

Before Task 1 and at the close: `npm run corpus`; the ledger in `.superpowers/sdd/multi-page-scan/progress.md`; the
plan copied to `docs/plans/2026-11-16-multi-page-scan.md`. Tests that scan launch only fixture sites
(`serveFixture`, `serveCheckSite`), `test/fixtures/wp-standin.ts` and the alttext.ai stand-in; no test reaches the
internet (`launchOffline` / `offlineFetch` wherever a test launches Chrome itself).

1. **capture, several addresses.** `tools/lib/capture-pages.ts`: `PAGES_MAX = 3`; `folderFor(out, url)`;
   `pageLine(done, url, file?)` and `readPageLines(lines)` (the three page lines and their reader, one place);
   `captureMany(run, urls, o & { folders }, print, extra)`: each url through `capturePage` with `out` its folder
   when `folders`, its page line printed as it ends, a `stopped` page ending the loop, then a `Page not tried:`
   line for each page left and `Pages: k of n scanned`, returning 0 or 1. `tools/capture.ts`: `parse` collects up
   to 3 addresses and `--folders`; the three refusals (one line each before the usage line, exit 2); every host
   confirmed before the run starts; one address without `--folders` calls `capturePages` exactly as now. RED/GREEN: the tests of AC1, AC2, AC4, then AC3. Keep `capture-cli`'s
   usage pin (`^usage: npm run capture -- <address> .*\[--windows <n>\]`).
2. **The app's scan of several.** `commands.ts`: `RESERVED` gains `--folders` and `--also`; `checkAddresses(list)`
   (1–3, each through `checkAddress`, no two with one `pageName`); `scanManyArgs`. `routes.ts` `startScan`: `address`
   as today, or `addresses`; each folder checked as today; `/api/state` gains `pagesMax`. `chains.ts`: the steps
   after a capture (`capture-check`, `writePastes`, the sidecar) move into one function both chains call;
   `scanManyChain` (the one capture command, `readPageLines`, then that function per scanned page, the closing
   lines). `jobs.ts`: `JobView.scans` (the folders whose pastes were made). Page: `index.html` (the box, its label
   and help), `main.ts` (lines → `address` or `addresses`; more than 3 lines says the line and sends nothing),
   `job.ts`. RED/GREEN: AC7, AC8 (stub repo, no Chrome), then AC5, AC6.
3. **site:upload, several scans.** `tools/lib/site-upload/args.ts`: `--also <capture> <outDir>` (at most twice;
   `UploadArgs.also` absent when none; the refusals). `flow.ts`: `pick(capture, a, site, shared?)` takes a record
   already loaded. New `tools/lib/site-upload/several.ts`: `sharedRecord` (one `loadRecord`, `record.sites[key]
   ??= {}` so every pick holds the same cache object), `beforeYes(login, p, outDir, out)` (the steps
   `tools/site-upload.ts` runs between the login and the question today, moved whole), `yesQuestionSeveral`
   (different new files counted once by their record key; starts `Upload `, ends `? Type yes: `),
   `scanHeading`, `scanLine` and `readScanLines`, `uploadSeveral` (`p.learn()` before each scan's `upload`; a
   signal exit ends the loop; the worst exit code). `tools/site-upload.ts`: one scan runs today's statements in
   today's order (through `beforeYes`); several run the loop. RED/GREEN: AC12, AC13, AC9, AC10, AC11. Run the
   one-scan pins after each commit: `test/unit/site-upload-*.test.ts`, `test/web/importer-app-commands-same.test.ts`,
   `test/web/site-upload-avif.test.ts`, `test/web/media-avif-as-served.test.ts`.
4. **The app's upload of several.** `commands.ts` `uploadArgs` (`also` appended last, so one scan's list is
   today's); `routes.ts` `startUpload` (`also`: ids through the index, the refusals, the line for a scan whose
   recorded options differ); `chains.ts` `uploadChain` (a stamp of each folder's `media.json` before and after, a
   sidecar per folder that wrote, closing line and next steps naming each page; one scan: today's words). Page:
   new `page/together.ts` (the ticks, at most `pagesMax`, ticked after a scan of several from `JobView.scans`),
   `views.ts` (a tick box beside each row's button: the row keeps exactly one `button`), `upload.ts` (`also` in
   the request, the "For …" line still starting `For `), `app.css`. RED/GREEN: AC15, then AC14, AC16.
5. **The one-page pin.** `test/web/multi-page-scan-one-same.test.ts` (AC17), named-only, on the pattern of
   `importer-app-commands-same.test.ts` (a fresh stand-in on the same port for each tree). The builder runs it
   with `F2B_BASE_TREE` = a `git worktree` or `git archive` copy of the base and records its log.
6. **Words and records.** The usage lines of `capture` and `site:upload` and their header comments; the app page's
   help under the address box and step 3; `docs/HANDOFF.md` section (what changed, Q1–Q4 ⭐ not yet confirmed,
   paste check 3fj, follow-ups: `site:import` with several pages, AVIF made once per run, a queue past 3). For
   the finisher, CLAUDE.md lines: the Status line; in the importer-app rule, "`capture` takes up to 3 addresses
   and `site:upload` up to 3 scans (`--also`); the app starts one command for all"; in the one-uploader rule,
   "one run may cover up to 3 scans of one site: still one login and one typed yes".

Gates at the close: `npm run check`, `npm run test:web` (the branch touches `test/web/`), `npm run corpus`.

## Other jobs touching the same files

- **saved-password (being planned):** it changes where the app (and maybe the commands) get the Application
  Password. It fits: a run of several scans still has exactly one login (`logIn` once, one `job.login`, one
  prompt), so whatever saved-password feeds that one prompt covers all three pages; this job adds no second place
  a password passes through. Shared files: `tools/lib/importer-app/routes.ts` (`startUpload`), `jobs.ts`,
  `page/upload.ts`, `page/index.html` (step 3), `tools/site-upload.ts`, `tools/lib/site-upload/flow.ts` (`logIn`),
  `test/web/importer-app-upload.test.ts`, `importer-app-secret.test.ts`, CLAUDE.md's uploader rule. To keep the
  overlap to a few lines this job puts its page code in `page/together.ts` and its `startUpload` part in one
  helper. Whichever merges second rebases; the second one's secret test (AC16 here) is run again on the joined head.
- **internal-links (in review):** adds `findPages` beside `findForms` in `tools/site-upload.ts` and `flow.ts`, and
  `--pages <folder>/pages.json` in `commands.ts` `siteArgs` / `routes.ts`. Shared: `tools/site-upload.ts`,
  `tools/lib/site-upload/flow.ts`, `tools/lib/importer-app/commands.ts`, `routes.ts`, `chains.ts`,
  `test/fixtures/wp-standin.ts`, `test/unit/site-upload-cli.test.ts`, `test/web/importer-app-upload.test.ts`.
  **The join matters:** this job moves the steps before the yes into `beforeYes`. If internal-links merges first,
  the builder moves its `findPages` line with the rest. If this job merges first, internal-links' rebase conflicts
  in `tools/site-upload.ts`, and its line goes into `beforeYes` (taking this side's hunk alone would drop the pages
  read); then a run of several is checked for `pages.json` in every folder.
- **tier-spacing (in review):** `tools/lib/site-write.ts` only; not edited here. **photo-image-all (verifying):**
  no shared file.
- **Paused:** short-class-names edits `tools/lib/site-upload/args.ts`, `flow.ts`, `tools/site-upload.ts`,
  `site-import.ts` and their tests (shared: the first three); fewer-kept-boxes and clean-values share no tool file;
  link-keeps-name has only a planner brief.
- Every job: `docs/HANDOFF.md`, CLAUDE.md Status.

## Risks and limits

- **The person check may come back** on a later page (a pass that expires). Then the window waits 5 minutes for
  him as today; unanswered, that page fails and the rest are not tried, named. Only his live check (3fj) shows
  how long bdryswi.com's pass holds.
- **A long job:** three pages can take 45 minutes; the app does one job at a time, so nothing else can be started
  meanwhile (the first page can't be uploaded while the third is read).
- **A scan of several makes pastes only after the last page is read** (one capture command); a Stop leaves the
  pages already read without pastes (one press of Make pastes each).
- **Moved code:** `scanChain`'s steps after the capture and `site-upload.ts`'s steps before the yes move into
  shared functions; the one-page pins (AC17, the existing `importer-app-scan`, `importer-app-upload`,
  `importer-app-commands-same`, `site-upload-cli` tests) hold them.
- `test/unit/importer-app-prompts.test.ts` reads `flow.ts` for the question's ending: `yesQuestion` stays there.

## Evidence index (`evidence/multi-page-scan/planner/`)

- `his-scans-2026-11-16.json`: the five saved scans' times, sizes, options and shared pictures (read from copies
  under `~/.cache/mps-pl/`; `~/Downloads` was only read).
- `measure-cmd-elementor-natives.json` / `.log`, `measure-standin-home.json`: one offline scan's time, memory and
  Chrome processes (`measure.ts`, run through `run.sh` under an 8 GB cap).
- `proto-multi.json` / `.log` (`proto-multi.ts`): several pages through one run equal the pages scanned alone; the
  person check pressed once.
- `base-probes.txt`: on `b2a05be9`, `capture` with two addresses, `site:upload --also` and `site:import` with two
  pages each exit 2 today (the new tests' RED).
- `base-unit-subset.log`: `test/unit/importer-app-*`, `site-upload-*`, `site-import-*` on the base: 97 tests, 94
  pass, 3 skipped (story pins), 0 fail. `base-web-subset.log`: the app's web tests, `capture-cli` and `human-once`
  on the base: 30 tests, 28 pass, 2 fail (named under "The base today"); `base-two-failures-run1.log`, `-run2.log`:
  those two files run alone, twice.
