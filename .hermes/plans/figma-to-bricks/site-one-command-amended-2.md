# Amendments (2026-11-10, wording only; planner, at the coordinator's request; A1-A6 on builder head `f4a7dc8a`, A7-A11 on review 1's head `e0e62e0c`)

- **A1:** the base is main `11e885fd` (Build 2026-11-10.8), onto which the branch was rebased; the story pins' base tree is its archive, and the line naming their environment no longer starts with a list marker followed by an AC id.
- **A2:** AC11 names the one existing test case the move changes (`test/unit/capture-chrome.test.ts`, the launch-line pin) and why; its cited test is unchanged.
- **A3:** decision (a): the pin follows the line. Task 1 says what the case must prove (both commands find Chrome with `findChrome`, launch it only through the one shared launch in `captureRun` with its path and arguments, and print the helper's line when none is found) and gives its exact shape on this head, proven on a scratch head with six mutants; Overlaps says how the case, `tools/capture.ts` and `tools/lib/capture-run.ts` join with site-menu's `launchCaptureChrome` in either merge order. No other test reads a moved file as text.
- **A4:** Interfaces as built: `logIn` takes the Prompter or a function that makes it, `Login` carries `prompter`, `Picked` carries `parts`, `captureRun` takes any `FoundChrome`, `scanStop` gives `heard()` and the capture's lines go unsaid after a stop.
- **A5:** the fresh drop's 150 ms settle is on a terminal only.
- **A6:** the Prompter driver lives in `test/fixtures/drivers/`.
- **A7:** Q5 is Justin's answer (2026-11-10, "Only real failures (Recommended)"): after the scan the one command stops only for what `site:upload` refuses with that capture (a failed scan, a page that isn't the site's page, a width range read without the site's styles, a capture its conversion can't make); every smaller problem `capture:check` names is a plain warning before the found list, and the run goes on. AC6 states the rule; **AC6's cited test is renamed** (the old words are now false): from "AC6 a scan capture:check would refuse is refused before anything is listed or sent" to "AC6 after the scan only a real failure stops the run and every smaller problem is a warning before the list", in the same file `test/unit/site-import-gate.test.ts`. The Interfaces' `scanProblem`, the order's step 7, the sketch, Task 3, the tests' notes and the Risk that leaned on "B-Dry's re-capture is ok" follow (review 1 R1-3).
- **A8:** the fresh drop reads the terminal in raw mode, so letters typed before a question shows go whether or not Enter followed them, and Enter alone at the question is "not yes" (review 1 R1-1, P1). AC3's sentence says so and its cited test gains that case; the owned question is asked fresh too, in this fix (R1-5).
- **A9:** `--no-shots` stays and works: its missing layer pictures are one warning line, never a stop (review 1 R1-2).
- **A10:** review 1's R1-4 to R1-10, each with what the fixer does: R1-6, R1-7, R1-9 fixed now (a line or two in this job's own files, no AC changes); R1-4, R1-8, R1-10 recorded follow-ups.
- **A11:** a cosmetic slip in the sketch (an `[amended A4]` tag written as a `//` comment in the middle of the `upload(...)` line, which hid its second branch) is moved to the line's end.

No AC is added, removed or renumbered; one cited test name changes (AC6's, A7); every other cited test name is unchanged.

# site-one-command: one command that asks for WordPress first, then scans, uploads and writes the paste (Mini)

Planner: Opus 5.5 high, 2026-11-10. Base: `main` `11e885fda5d08863a5875f939085350c007ac732` (Build 2026-11-10.8; the plan was written on `7ec16d60`, Build 2026-11-10.7, whose file:line evidence below still holds for the files this job touches). [amended A1]
Pipeline: **Mini** (Justin's pick). The builder copies this file to `docs/plans/2026-11-10-site-one-command.md` as Task 0.
Evidence: `~/.hermes/plans/figma-to-bricks/evidence/site-one-command/` (planner probes in `planner/`).

## Questions (⭐ = taken under the standing auto-go unless Justin changes it)

- **Q1. When is the Application Password asked?** ⭐ **A: once, at the start, before the scan** (Justin's own
  expectation: "i expected it to ask me for the applicaiton password"), tested with a read at once, then kept only in
  the tool's own memory through the scan (about 4 minutes) and the upload. B: asked again right before the upload.
  Plain trade-off: A finds a wrong password in seconds and asks once, but the password sits in the tool's memory a few
  minutes longer (it is never given to Chrome, the scan or any file: AC2 proves it); B keeps it in memory only for
  the upload but asks twice, and a mistyped second password fails after the 4-minute scan. Not a real risk difference
  on his own computer, so A, as he expected.
- **Q2. What does `--dry-run` do in the one command?** ⭐ **A: it scans, lists every picture (name, type, size, alt,
  where it shows, would go up / already in your library / stays and why), asks no password and sends nothing at all
  to WordPress** (as `site:upload --dry-run` does today); it writes only the capture file, and its last line is the
  `npm run site:upload` command that uploads that very scan without scanning again. B: it also logs in (a read) to
  look in the library for pictures an earlier stopped run sent.
- **Q3. Can a second run reuse the scan just made?** ⭐ **A: no new flag: every ending that didn't upload everything
  (a dry run, not `yes`, pictures that didn't go up, a stop during the upload) prints the exact `npm run site:upload --
  '<capture>' '<out>' <site> …same flags` line that finishes from that scan** (the same uploader and record, so no
  file goes up twice); running `site:import` again scans again. B: a `--capture <file>` flag on `site:import` that
  skips the scan.
- **Q4. Where do the files go by default?** ⭐ **A: `~/Downloads/<page name>/`** (from the address typed, as
  `npm run capture` names its file: `https://bdryswi.com/` → `~/Downloads/bdryswi-com-home/`, holding
  `bdryswi-com-home.f2b-capture.json`, `media.json`, `header.json`, `page.json`, `footer.json`, their sources and
  `notes.txt`); `--out <folder>` picks another. B: `~/Downloads` itself, as `capture` does (the pastes then sit among
  his downloads).
- **Q5. Which scans are refused before the upload?** **Justin's answer (2026-11-10, asked in a question: "Only real [amended A7]
  failures (Recommended)"; it replaces the planner's ⭐ A):** after the scan the one command stops only for what the [amended A7]
  upload command already refuses: a scan that failed, a page that isn't the site's page (a bot check, an error page), [amended A7]
  or a width range read without the site's styles (and, as `site:upload`, a capture its conversion can't make). Every [amended A7]
  smaller problem `capture:check` names (a picture the old site didn't send, a missing layer picture) is listed as a [amended A7]
  plain warning before the picture list, and the run goes on to the list and the `yes` question: he sees the warnings [amended A7]
  before he types `yes`. AC6 states the rule exactly. [amended A7]
- **Open, not this job's to settle:** site-media-upload's **Q12** (a refused picture type stops the run, as built, or is
  skipped and named): this command uses the uploader as built, so whatever Justin decides there applies here too.

None of these needs Justin before the build; Q1 A is what he said he expected.

## Playback (plain words)

1. Justin scanned bdryswi.com with `npm run capture`, passed the "I am human" check, and expected the command to ask
   for his WordPress Application Password and put the pictures into his media library: it didn't ask, because the
   scan and the upload are two commands today (`capture`, then `site:upload`).
2. He chose one command, Mini: it asks for his WordPress site, user name and Application Password first (as the
   plugin's panel connects to WordPress first), checks them, then scans the page, shows what it found and what his
   media library already holds, uploads the pictures after he types `yes`, and writes the pastes, saying what to do
   next. The two separate commands stay as they are.
3. It is a thin command over the code that exists: the same scan, the same uploader, the same record, the same
   refusals and the same scrubbed lines; nothing new is written to WordPress beyond what `site:upload` writes.

## The command

```
npm run site:import -- <old page address> <https://your-wordpress-site> [--out <folder>] [--user <name>] [--dry-run]
  [--svg] [--elementor] [--part header|page|footer] [--basic-text] [--record <file>] [--owned] [--design <W>]
  [--no-shots] [--windows <n>]
```

Justin will type (on the Windows desktop, in Ubuntu):
`cd ~/Documents/FigmaToBricksV2 && npm run site:import -- https://bdryswi.com/ https://bdry.staging.growithgro.com --elementor`

What it does and asks, in order (a real run):
1. Refuses at once (exit 2, one line, nothing sent) when its input isn't a terminal and the WordPress address isn't this
   computer's own (`site:upload`'s rule), or the address isn't https (http only for 127.0.0.1/localhost), holds a login,
   `?` or `#`. Finds Chrome (exit 1 with the helper's line when none), before any question.
2. Reads the WordPress site's public REST index with no password and prints `WordPress site: <title> at <address>`
   (a redirect, a bot check or a WordPress naming another address is refused, named: `guard.ts` `readIndex`).
3. Asks `WordPress user name: ` (unless `--user`), then `Application Password (WordPress → Users → Profile; nothing
   shows as you type or paste): ` at the hidden prompt.
4. Tests the login with one read (`wordpress.ts` `testConnection`: GET `users/me`): a wrong one stops here with one
   line `Couldn't log in: <WordPress's reason>`, exit 2, before any Chrome starts or the old site is asked anything.
   Right: `Connected to <address> as <name>. Nothing goes up before you type yes after the scan.`
5. Asks `Is <old host> your client's own site? (y/n) ` only when this computer hasn't been told (`owned.ts`, as
   `capture` asks; `--owned` says yes), before the scan: a "no" stops with exit 3 and nothing scanned.
6. `Scanning <old page>: a few minutes. If the site asks you to prove you're human, a Chrome window opens: pass the
   check there.` then the capture's own lines (`Capturing …`, `Switch points found: …`, … `File: …`, `Took …`).
7. Stops with nothing listed or uploaded only when the scan failed or isn't the page itself (exit 1), or read a width [amended A7]
   range without the site's styles (exit 2), each with what to type next (AC6); every smaller problem [amended A7]
   `capture:check` names is printed as a `Warning: …` line here, before the list, and the run goes on (Q5, Justin). [amended A7]
8. Looks in the library (reads only) for files an earlier stopped run sent without hearing back (`sent.ts`), then
   prints `What the scan found on <old page>:` and the dry run's list (each picture: name, type, size, alt, where it
   shows, `would go up` or `already in your library (media N, in this computer's record)`; the pictures that stay on
   their old addresses with the reason; the counts line).
9. Asks `Upload N new pictures (M already in your library) to <address> as <name>? Type yes: ` and takes only what is
   typed after that question shows (anything typed during the scan is thrown away). Not `yes`: `Not yes: nothing was
   uploaded.` plus the `site:upload` line to upload that scan later, exit 2.
10. Uploads with the panel's uploader as `site:upload` does (record, stop handling, `Pictures: n of N`, scrubbed
    lines), writes `media.json` and the pastes in the out folder, prints `site:upload`'s summary, then numbered next
    steps: copy each part (`clip.exe < '<out>/header.json'` on the Windows desktop, `pbcopy < …` on a Mac), paste it
    into a page on that site with Bricks in the order header, page, footer (Accept "Import classes" if asked), save,
    Bricks → Settings → Custom code → Regenerate code signatures, and purge the site's page cache if it has one.

`--no-shots` (as `npm run capture`'s: no layer pictures, a faster scan) works: its missing layer pictures are one [amended A9]
warning line at step 7, and the pastes are the same (the code route reads no layer pictures). [amended A9]

`--dry-run`: steps 1, 5, 6, 7 and the list of step 8 (from this computer's record only), no WordPress request at all,
no password asked, only the capture file written; it ends with the `site:upload` line (Q2 A, Q3 A).

## The current flow, with evidence (base `7ec16d60`)

- **Two commands today.** `tools/capture.ts:49-67`: finds Chrome, asks the owned question (`confirmOwned`, line 56),
  runs `humanRun` with `launchChrome` (line 57) and `capturePages` (line 63), which writes the capture
  (`tools/lib/capture-pages.ts:59-90` `one()`: `captureName(finalUrl)`, `File: …`, `Took …`, "Not the page itself"
  exit 1). It never touches WordPress. `tools/site-upload.ts:196-328` then reads a capture file, refuses an unstyled one
  (line 205-206), lists the pictures (209-211), loads the record (212-224), does the dry run (226-230), reads the index
  (233-234), asks user and password (235-241), guards `env.fetch` (242-244), tests the login (246-251), looks for files
  sent without an answer (252-260), asks `yes` (261-263), uploads (265-312) and writes `media.json` and the pastes
  (313-327). Both files run `main()` at load, so neither can be imported: their bodies must move into `tools/lib/` to be
  shared (this job's one refactor).
- **Where the password lives today** (`site-upload.ts`): returned by `Prompter.hidden` (`ask.ts:87-114`, a local
  `typed` string), kept in the `wp` object (`site-upload.ts:239`), handed to `testConnection`, `findSent` and the
  uploader (`opts(wp)`, line 216, 275), turned into the `Authorization: Basic …` header only inside `wpFetch`
  (`src/ui/wordpress.ts:64`), and its forms kept in the scrubber (`scrub.ts:237-247`). Requests go only through
  `guardFetch` (`guard.ts:150-164`: the typed origin only, no redirect followed). It is never in an argument
  (`args.ts:24-28` refuses password-shaped flags and extra words, never printing them), an environment variable (nothing
  sets one), the record (`record.ts`: fingerprints, media ids, file names), `media.json` (`pictures.ts:79-87`: site and
  pictures), the pastes (made from the capture and the media map) or a printed line (every line through the scrubber).
  JavaScript can't wipe a string: "cleared" means the tool's process ends on every path (done, refused, failed,
  stopped), which every path here does (`process.exit`).
- **The scan never sees it.** The capture code doesn't use the panel's `env.fetch` (no `src/web` file imports
  `src/ui/env.ts`), so the guarded fetch set at step 4 doesn't reach the scan. Chrome is spawned with
  `chromeArgs(profile, opts)` (`test/browser/chrome.ts:333-338`: switches only) and inherits the tool's environment
  (`chrome.ts:353`), which holds no password; pages run in Chrome's own processes and never reach the tool's memory.
  So the new command must only never hand the login to the scan, to Chrome or to a file; AC2 proves it on every
  artefact, the tool's and Chrome's `/proc/<pid>/cmdline` and `environ`.
- **Two hazards found by probe** (`planner/probe1-stdin.jsonl`, the base `Prompter` and `confirmOwned` on one stdin in a
  real terminal, `test/fixtures/pty-run.py`):
  1. The owned question's `readline` (`owned.ts:54-63`) and the `Prompter` (`ask.ts:53-58`, a `data` listener kept on
     stdin) both receive the owned answer: answering the owned question `yes` was also taken as the upload's `yes`
     (`"owned":"yes","yes":"yes"` while the test then typed `no`), and `y` left `y` as the upload's answer.
  2. A `yes` typed in the terminal during the scan (stdin paused, the line waiting in the terminal) was taken as the
     upload's answer the moment the question showed (`"yes":"yes"` with nothing typed after the question).
  So the owned question goes through the same `Prompter` (`owned.ts` gains an optional `ask`), and the `yes`
  question takes only what is typed after it shows (`Prompter.line(q, { fresh: true })`).
- **Scans are repeatable** (`planner/probe3-twice/run.log`): `npm run capture` twice on one fixture server
  (media-page) gives capture files equal but for `web.timings` and `web.capturedAt`, and byte-identical
  `npm run site --elementor` pastes (each capture about 10 s).
- **Base tallies** (base archive, this machine): `test/unit/site-upload-*.test.ts`, `web-owned.test.ts`,
  `wp-standin.test.ts`: 38 tests, 36 pass, 0 fail, 2 skipped (the story pins AC12/AC13 of site-media-upload,
  `F2B_STORY_PINS=1`) (`planner/base-unit-upload.tap`); the web files capture-cli 6/6, human-check 7 + 1 skipped,
  capture-unreachable 2/2, site-upload-page 1/1 (`planner/base-web/`).

## Approach (what moves, what is new)

Move as little as possible; nothing in `src/core`, `src/plugin`, `src/ui`, `src/shared` changes, so `dist/` is
byte-identical (AC12).

1. **`tools/lib/site-upload/flow.ts` (new, moved, not rewritten):** `site-upload.ts`'s body split at its natural
   seams into exported functions, each the same lines in the same order: `scrubbedConsole()` (lines 191-194),
   `pick()` (207-224 plus the `learn` closure), `logIn()` (232-251), `lookForSent()` (252-260), `yesQuestion()`
   (the text of 261-262), `upload()` (265-327 and `stoppedBy`, 330). `tools/site-upload.ts` keeps its usage, order,
   `main().then(…)` catch and every printed byte; it only calls them.
2. **`tools/lib/site-upload/ask.ts`:** `line(question, o?: { fresh?: boolean })`. With `fresh`, what the Prompter read
   already is dropped before the question shows, and only on a terminal the input is also put in raw mode and resumed [amended A8]
   for 150 ms (`SETTLE_MS`), and everything that arrives then is dropped: finished lines and letters typed with no [amended A8]
   Enter alike (in line mode the terminal holds an unfinished line back, so a `yes` typed during the scan without Enter [amended A8]
   would be read once Enter is pressed at the question: review 1 R1-1, 7 POSTs). Line mode is put back in a `finally`; [amended A8]
   a Ctrl+C among the dropped keys ends the tool with 130, as at any prompt. A pipe gets no wait (the tests write each [amended A8]
   answer after its question). Without `fresh`, as today. [amended A8]
3. **`src/web/owned.ts`:** `AskOptions.ask?: (question: string) => Promise<string>`: when given, the question is
   asked through it (terminal or not) instead of `readline`. Without it, byte for byte as today (`capture`, the helper,
   `panel-address.test.ts`).
4. **`tools/lib/capture-pages.ts`:** `one()` exported as `capturePage()`, returning `{ done, file, snapshot }`
   (`file`/`snapshot` null when nothing was written); `capturePages` uses `.done`. Its lines are unchanged.
5. **`tools/lib/capture-run.ts` (new):** `captureRun(chrome, say)` (the `humanRun(…launchChrome…)` of
   `capture.ts:57`) and `captureExtra()` (the font source and `F2B_RETRY_MS`/`F2B_STYLE_RETRY_MS` of
   `capture.ts:60-63`); `capture.ts` calls both, so the two commands launch Chrome the same way (site-menu's
   `launchCaptureChrome` then lands in one place: see Overlaps).
6. **`tools/lib/site-upload/summary.ts`:** `pictureLines(items, kept, known)` = `dryRunLines` without its first two
   lines; `dryRunLines` = those two lines + `pictureLines` (same bytes).
7. **New:** `tools/lib/site-import/args.ts` (parse, usage, `uploadLine`, default out folder),
   `tools/lib/site-import/gate.ts` (`scanProblem`), `tools/lib/site-import/next.ts` (`nextSteps`, `copyCommand`),
   `tools/lib/site-import/after-scan.ts` (`afterScan`: everything after the scan, so a unit test can hand it a
   hand-made capture and a login to the stand-in), `tools/lib/site-import/scan-stop.ts` (`scanStop`),
   `tools/site-import.ts` (the order above, up to the scan), `package.json` `"site:import": "node tools/site-import.ts"`.

Seven small edits to existing files and eight new small files (the command and its helpers): above Mini's "1-3 files" guide, but no design decision and no new
behaviour towards WordPress (only existing modules reached in a new order). It stays Mini; the one review should read
the password and `yes` paths closely (AC2, AC3, AC7). If the builder finds `site-upload.ts` can't move without a
printed byte changing, stop: `escalate to full`.

## Interfaces (exact)

```ts
// tools/lib/site-upload/flow.ts
export interface Out { say(line: string): void; refuse(why: string): never; error(line: string): void; scrub: Scrubber }
export function scrubbedConsole(): Out; // say → console.log(scrub.clean), error → console.error(scrub.clean), refuse → console.error(scrub.clean) + process.exit(2)
export interface Picked {
  capture: Snapshot; o: WriteOptions; items: ListedPicture[]; kept: KeptPicture[];
  files: Array<{ l: ListedPicture; vs: Variant[] }>; known: Map<string, number>; learn(): void; waiting: Waiting[];
  record: UploadRecord; recordFile: string; key: string; cache: UploadCache;
  parts: PartName[];   // the parts the pastes are written for (writePastes' choice), header, page, footer order [amended A4]
}
export function pick(capture: Snapshot, a: { part?: PartName; svg: boolean; elementor: boolean; basicText: boolean; record?: string }, site: Site): Picked;
export interface Login { index: SiteIndex; wp: WP; me: { name: string; restStyle: "pretty" | "query" }; guarded: GuardedFetch; prompter: Prompter } // [amended A4]
// ask: the run's one Prompter (site:import), or a function that makes it once the index has answered (site:upload, [amended A4]
// which builds its Prompter after the index read, as today, so its bytes and order hold) [amended A4]
export async function logIn(site: Site, ask: Prompter | (() => Prompter), user: string | undefined, out: Out): Promise<Login>; // [amended A4]
export async function lookForSent(login: Login, p: Picked, out: Out): Promise<void>;
export function yesQuestion(p: Picked, login: Login): string; // "Upload N new picture(s) (M already in your library) to <url> as <name>? Type yes: "
// after(ok): lines printed after the summary (site:import's next steps or its site:upload line); site:upload passes none
export async function upload(login: Login, p: Picked, outDir: string, out: Out, o?: { after?: (ok: boolean) => string[] }): Promise<number>;

// tools/lib/site-upload/ask.ts
line(question: string, o?: { fresh?: boolean }): Promise<string>;

// src/web/owned.ts
export interface AskOptions { path?: string; owned?: boolean; input?: Readable; output?: Writable; interactive?: boolean; now?: () => string; ask?: (question: string) => Promise<string> }

// tools/lib/capture-pages.ts
export async function capturePage(run: HumanRun, url: string, o: PagesOptions, print: Print, extra?: Partial<CaptureOptions>): Promise<{ done: "ok" | "failed" | "stopped"; file: string | null; snapshot: Snapshot | null }>;

// tools/lib/capture-run.ts
// chrome: any FoundChrome; a missing one makes each launch fail with the helper's line (capture --list needs no Chrome, [amended A4]
// as capture.ts:57 does today) [amended A4]
export function captureRun(chrome: FoundChrome, say: (line: string) => void): HumanRun; // [amended A4]
export function captureExtra(): Partial<CaptureOptions>;

// tools/lib/site-upload/summary.ts
export function pictureLines(items: ListedPicture[], kept: KeptPicture[], known: Map<string, number>): string[];

// tools/lib/site-import/args.ts
export interface ImportArgs { page: string; site: string; outDir: string; user?: string; record?: string; part?: PartName; dryRun: boolean; svg: boolean; elementor: boolean; basicText: boolean; owned: boolean; design: number; shots: boolean; windows: number }
export const IMPORT_USAGE: string; // "usage: npm run site:import -- <old page address> <https://your-wordpress-site> [--out <folder>] [--user <name>] [--dry-run] [--svg] [--elementor] [--part header|page|footer] [--basic-text] [--record <file>] [--owned] [--design <W>] [--no-shots] [--windows <n>]"
export function parseImportArgs(argv: string[], home?: string): { args: ImportArgs } | { error: string }; // the same refusals as args.ts (password-shaped flags named, extra words never printed); exactly 2 places
export function uploadLine(capture: string, a: ImportArgs): string; // npm run site:upload -- '<capture>' '<out>' <site> [--elementor] [--svg] [--part x] [--basic-text] [--record '<file>'] [--user '<name>']

// tools/lib/site-import/gate.ts
export function scanProblem(capture: Snapshot, o: { shots: boolean; file: string }): { stop: { code: 1 | 2; line: string } | null; warnings: string[] }; // [amended A7]
// stop (Justin's Q5): notThePage(capture) not empty → { code: 1, line: `Not the page itself: ${why.join("; ")}. Nothing was uploaded; the scan is saved at ${o.file} for a look. Run the same command again.` }; [amended A7]
// unstyledLine(capture) → { code: 2, line: `${it} Nothing was uploaded: run the same command again.` }; else null. [amended A7]
// warnings: checkCapture(capture)'s other problems, one line per kind, in this order, each starting "Warning: " [amended A7]
// (k counted, the plural written out): [amended A7]
//   shown pictures without bytes → `Warning: the scan holds no file of ${k} picture(s) the page shows (the old site didn't send it/them: broken, blocked or too slow). The list below names each one the pastes keep on its old address.` [amended A7]
//   layers without a stored picture, with shots → `Warning: ${k} layer picture(s) the Figma panel would draw from this scan weren't taken; the website pastes this command writes don't use them.` [amended A7]
//   the same with --no-shots → `Warning: no layer pictures were taken (--no-shots), so the Figma panel can't draw ${k} layer(s) of this scan; the website pastes this command writes don't use them.` [amended A7] [amended A9]
//   any other problem p (no parts, a part's root missing, no switch points, rule collisions, the Figma route can't convert it) → `Warning: npm run capture:check names this: ${p}.` [amended A7]
// (src/core/site reads no web.renders: the code route's pastes are the same with or without layer pictures; review 1 [amended A7]
// memory-vs-file.log, noshots-offline.log) [amended A7]

// tools/lib/site-import/next.ts
export function copyCommand(file: string, platform?: NodeJS.Platform, wsl?: boolean): string; // clip.exe < '<file>' | pbcopy < '<file>' | "open <file> and copy all its text"
export function nextSteps(site: string, outDir: string, parts: PartName[], platform?: NodeJS.Platform, wsl?: boolean): string[];

// tools/lib/site-import/scan-stop.ts: SIGINT/SIGTERM/SIGHUP during the scan close the run's Chrome (run.close()),
// print "Stopped during the scan: nothing was uploaded." and exit 128+n (130 for Ctrl+C); dispose() before the upload,
// whose own listenForStop (stop.ts) then takes over; heard(): a stop came, after which the capture's own lines go [amended A4]
// unsaid (the capture failing as its Chrome closes isn't news) and the tool waits for the handler's exit [amended A4]
export function scanStop(run: HumanRun, out: Out): { dispose(): void; heard(): boolean }; // [amended A4]

// tools/lib/site-import/after-scan.ts: steps 7-10 (login null = dry run). Returns the exit code; refusals go through
// out.refuse (exit 2) as in site:upload
export async function afterScan(scan: { file: string; snapshot: Snapshot }, a: ImportArgs, site: Site, login: Login | null, ask: Prompter, out: Out): Promise<number>;
```

`tools/site-import.ts`, the order (the builder writes it from this; every line printed goes through `out`):

```ts
async function main(): Promise<number> {
  const parsed = parseImportArgs(process.argv.slice(2));
  if ("error" in parsed) { out.error(parsed.error); out.error(IMPORT_USAGE); return 2; }
  const a = parsed.args;
  const site = siteOf(a.site);                                   // Refused → exit 2 (the catch below)
  if (!process.stdin.isTTY && !site.loopback) out.refuse(`Run this in your own terminal window: it asks for your Application Password and a typed yes there (${site.root} isn't uploaded to without a person at the keyboard)`);
  const chrome = findChrome();
  if ("missing" in chrome) { out.error(chromeMissingText(chrome.missing)); return 1; }
  const ask = new Prompter({ input: process.stdin, output: process.stdout });
  const login = a.dryRun ? null : await logIn(site, ask, a.user, out);      // index, user, hidden password, testConnection
  if (login) out.say(`Connected to ${login.index.url} as ${login.me.name}. Nothing goes up before you type yes after the scan.`);
  const owned = (host: string) => confirmOwned(host, { owned: a.owned, ask: (q) => ask.line(q, { fresh: true }) }); // [amended A8] R1-5
  await owned(new URL(a.page).host);                             // NotOwned → exit 3, before any Chrome
  out.say(`Scanning ${a.page}: a few minutes. If the site asks you to prove you're human, a Chrome window opens: pass the check there.`);
  const run = captureRun(chrome, out.say);
  const stop = scanStop(run, out);                               // SIGINT/SIGTERM/SIGHUP during the scan: closes Chrome, says "Stopped during the scan: nothing was uploaded.", exits 128+n
  let r;
  try {
    r = await capturePage(run, a.page, { url: a.page, out: a.outDir, owned: a.owned, list: false, all: false, limit: 1, design: a.design, shots: a.shots, windows: a.windows }, { log: out.say, error: out.error }, { ...captureExtra(), confirm: owned });
  } finally { stop.dispose(); await run.close(); }
  if (r.done !== "ok" || !r.snapshot || !r.file) { out.error(`Nothing was uploaded: the scan didn't give the page (named above). Run the same command again${r.file ? `; the scan is saved at ${r.file} for a look` : ""}.`); return 1; } // [amended A10] R1-6
  return afterScan({ file: r.file, snapshot: r.snapshot }, a, site, login, ask, out);
}

// tools/lib/site-import/after-scan.ts afterScan(scan, a, site, login, ask, out), with r = scan:
  const g = scanProblem(r.snapshot, { shots: a.shots, file: r.file });                  // [amended A7]
  if (g.stop) { out.error(g.stop.line); return g.stop.code; }                          // [amended A7]
  if (g.warnings.length) for (const l of [...g.warnings, ""]) out.say(l);              // [amended A7] before the list, dry run too
  const p = pick(r.snapshot, a, site);
  if (!login) { /* dry run */ for (const l of [`Dry run: nothing was sent to ${site.root} and no password was asked; the scan is saved at ${r.file}.`, "", ...pictureLines(p.items, p.kept, p.known), ...(p.waiting.length ? [waitingLine(p.waiting.length)] : []), "", `To upload them without scanning again: ${uploadLine(r.file, a)}`]) out.say(l); return 0; }
  await lookForSent(login, p, out);
  for (const l of [`What the scan found on ${a.page}:`, "", ...pictureLines(p.items, p.kept, p.known), ""]) out.say(l);
  const answer = (await ask.line(yesQuestion(p, login), { fresh: true })).trim();
  if (answer !== "yes") out.refuse(`Not yes: nothing was uploaded. To upload this scan later without scanning again: ${uploadLine(r.file, a)}`);
  return upload(login, p, a.outDir, out, { after: (ok) => (ok ? nextSteps(login.index.url, a.outDir, p.parts) : ["", `To finish without scanning again: ${uploadLine(r.file, a)}`]), stopped: (n, m) => `Stopped. ${n} of ${m} picture${m === 1 ? " is" : "s are"} in your media library; to finish without scanning again, run the line below.` }); // [amended A4] [amended A10] [amended A11]
}
// tools/site-import.ts: main().then(…) with the catch of site-upload.ts:332-338, plus NotOwned → its message, exit 3
```

(The parts come from `Picked.parts`, the parts `writePastes` writes for that capture and `--part`, so the steps name [amended A4]
exactly the files written. `afterScan`'s `ask` is the same Prompter as `login.prompter`.) [amended A4]

## Acceptance criteria (all proposed; Justin's "go" approves them)

The tests run only against local fixture sites (`test/fixtures/web/serve.ts`) and the WordPress stand-in
(`test/fixtures/wp-standin.ts`, 127.0.0.1), with a made-up password (`abcd EFGH ijkl MNOP qrst UVWX`), a temp HOME,
record, `F2B_CAPTURE_CONFIG` and TMPDIR, Chrome from `CHROME_PATH`.

- AC1 (proposed): A real run asks in this order: prints `WordPress site: … at …` (the index read with no password), asks the user name, then the Application Password, tests the login with a read and prints `Connected to … as …`, and only then asks the owned question, before any Chrome starts; a wrong password stops with one line `Couldn't log in: …`, exit 2, no Chrome started (no `f2b-chrome-*` profile in the run's TMPDIR), the old site asked nothing (the fixture server's request log empty), the stand-in received only GET requests, and nothing written in the out folder; a "no" to the owned question stops with exit 3 the same way.
  Test: `test/unit/site-import-order.test.ts` "AC1 the WordPress login is asked and tested before the scan, and a wrong password stops it in seconds"
- AC2 (proposed): The password (as typed, without its spaces, and inside the Basic `user:password` base64 in its standard, JSON-escaped, base64url and URL-encoded forms) is in no file the run leaves (the out folder: capture, `media.json`, pastes, sources, notes; the record; the owned-sites file; HOME; TMPDIR), not in the tool's standard output or error (a run that uploads, and a refused login), not in the tool's `/proc/<pid>/cmdline` or `environ` (read while it waits at the `yes` question), not in the `cmdline` or `environ` of any Chrome process the scan started (read while the scan runs), and the stand-in received it only as the `Authorization` of requests to itself.
  Test: `test/web/site-import-secret.test.ts` "AC2 the password reaches no file, output, argument, environment or Chrome process"
- AC3 (proposed): Before a `yes` typed after the upload question shows, the stand-in receives only GET requests; in a real terminal nothing typed before the question shows counts, with or without Enter: a `yes` typed during the scan and Enter'd, a `yes` typed during the scan with no Enter, and a `yes` given as the answer to the owned question are never taken as the upload's `yes` (the question still waits; answering `no`, or pressing Enter alone, then gives `Not yes: nothing was uploaded.`, exit 2, no POST, no `media.json`), and the `Not yes` line names the `npm run site:upload` command that uploads that scan. [amended A8]
  Test: `test/web/site-import-yes.test.ts` "AC3 only a yes typed after the question uploads, and nothing but reads goes before it"
- AC4 (proposed): `npm run site:import -- … --dry-run` scans, asks no password, sends no request at all to the stand-in (its request log empty), writes only the capture file in the out folder (the record unchanged), and prints `Dry run: nothing was sent …`, every picture once with its name, type, size, alt (or decorative / none), where it shows and whether it would go up, is already in this computer's record or stays on its address and why, the same picture lines `npm run site:upload -- <that capture> … --dry-run` prints, and the `npm run site:upload` line that uploads that scan.
  Test: `test/web/site-import-dry-run.test.ts` "AC4 a dry run scans and lists the pictures with their alt text, and sends nothing to WordPress"
- AC5 (proposed): A scan that fails uploads nothing: a page answered as a bot check (fixture `challenge`: "Not the page itself"), a site that can't be reached (a closed port, `F2B_RETRY_MS` short) and a page whose stylesheet never arrives (`F2B_STYLE_RETRY_MS` short) each end with the capture's own line and `Nothing was uploaded: …`, exit 1, no `yes` asked, no POST to the stand-in, no `media.json` or paste written.
  Test: `test/web/site-import-scan-fails.test.ts` "AC5 a scan that fails or isn't the page uploads nothing"
- AC6 (proposed): After the scan the run stops only for what `npm run site:upload` refuses with that same capture, and every smaller problem `npm run capture:check` names is a warning (Justin's Q5): handed to `afterScan` with a login to the stand-in, a capture holding a range read without the site's styles ends with exit 2 and `unstyledLine`'s sentence plus `Nothing was uploaded: run the same command again.`, and a capture `notThePage` names ends with exit 1, `Not the page itself: …. Nothing was uploaded; the scan is saved at <file> for a look. Run the same command again.`, neither printing the list, asking the `yes` question or sending the stand-in any request; a capture `capture:check` fails only for smaller problems (a shown picture without bytes, a layer without a stored picture, a part's root missing) prints one `Warning: …` line per kind (Interfaces) before `What the scan found on …:` (and before the dry run's list, which prints them too), then the same list `npm run site:upload -- <that capture> … --dry-run` prints and the `yes` question, and what goes up and what stays on its old address is exactly that list's (the picture without bytes stays, named); a clean capture prints no warning. [amended A7]
  Test: `test/unit/site-import-gate.test.ts` "AC6 after the scan only a real failure stops the run and every smaller problem is a warning before the list"
- AC7 (proposed): Stopped in a real terminal (Ctrl+C typed as a key): at the password prompt it ends with 130, the terminal's echo back on, nothing but the index read sent; during the scan it says `Stopped during the scan: nothing was uploaded.`, ends with 130, no Chrome process of the run is left after 5 s, no POST, no `media.json`; at the `yes` question it ends with 130 and nothing uploaded; during the upload it does what `site:upload` does (no new upload starts, the ones going answer, the record, `media.json` and the pastes are written, `Stopped. N of M pictures …`, 130) and then names the `npm run site:upload` line; running that line sends only the pictures the library lacks (no file twice).
  Test: `test/web/site-import-stop.test.ts` "AC7 a stop at each stage uploads nothing before the yes and loses nothing after it"
- AC8 (proposed): With no person at the terminal (stdin a pipe), any WordPress address but this computer's own is refused at once, dry run too: one line naming why, exit 2, no request sent, no Chrome started, no question asked, nothing written; for 127.0.0.1 the run goes on (the tests' stand-in).
  Test: `test/unit/site-import-no-person.test.ts` "AC8 no person at the terminal: refused for any site but this computer's own"
- AC9 (proposed): For one fixture page (media-page, one fixture server) and two fresh stand-ins, `npm run site:import -- <page> <stand-in B> --elementor` writes `media.json`, every paste, every sources file and `notes.txt` byte for byte as `npm run capture -- <page>` then `npm run site:upload -- <that capture> <out> <stand-in A> --elementor` write, once each stand-in's address is replaced by one name (only their ports differ), and the two capture files are equal but for `web.timings` and `web.capturedAt`; the same holds without `--elementor`.
  Test: `test/web/site-import-same.test.ts` "AC9 one command writes what capture then site:upload write for the same page"
- AC10 (proposed): A run against the stand-in prints, before the `yes` question, `What the scan found on <page>:` and exactly the picture lines `site:upload --dry-run` prints for that capture (with a record that knows one file: `already in your library`), then the question naming the new and known counts, the site's address and the user's name; after the upload, `site:upload`'s summary and numbered next steps naming each pasted file of the out folder in the order header, page, footer with the copy command for this computer, the site's address, Save, Regenerate code signatures and the cache purge; exit 0.
  Test: `test/web/site-import-run.test.ts` "AC10 a run shows what it found, uploads after yes and says what to do next"
- AC11 (proposed): The four existing commands behave as before: on the base tree (`F2B_BASE_TREE`) and on this head, `npm run capture` (one page of a fixture, `--list`, a refused owned question), `npm run capture:check` (a clean and a refused capture), `npm run site` (whole page, `--elementor`, `--media`) and `npm run site:upload` (dry run, a run, a second run, a refused login, not `yes`, a stop during the upload) print the same stdout and stderr, exit with the same codes and write the same files, after paths, the fixture's and the stand-in's ports and the capture's timings are normalised; and every existing test of those commands passes unchanged but one case: `test/unit/capture-chrome.test.ts` › "npm run capture launches the Chrome findChrome finds and prints the helper's line when it finds none (amendment 2)" reads Chrome's launch line where it now lives (`tools/lib/capture-run.ts`, shared by `capture` and `site:import`) instead of `tools/capture.ts`, and pins both commands to it, every one of its old assertions kept (Task 1 gives the exact case). [amended A2]
  Test: `test/web/site-import-others-unchanged.test.ts` "AC11 capture, capture:check, site and site:upload print and write as on the base"
- AC12 (proposed): The Figma plugin and panel are untouched: no file under `src/core`, `src/plugin`, `src/ui`, `src/shared`, nor `manifest.json` or `build.mjs`, differs from the base, and `npm run build` gives `dist/code.js` and `dist/ui.html` byte for byte as the base tree's build.
  Test: `test/unit/site-import-figma-unchanged.test.ts` "AC12 the Figma plugin and panel build byte for byte as on the base"
- AC13 (proposed) (live): Justin runs `npm run site:import -- https://bdryswi.com/ https://bdry.staging.growithgro.com --elementor` in his own terminal: it shows B-Dry staging's name and asks his user name and Application Password before the scan (a deliberately wrong password first stops in seconds with `Couldn't log in`), scans (he passes the "I am human" check in the Chrome window), lists the pictures with their alt texts, uploads after his `yes` (or says they are already in his library from 3dt), and prints the numbered next steps; WordPress → Media shows the pictures with the old site's alt texts.
  Test: Justin's run (paste check at the merge, steps under "Justin's check")
- AC14 (proposed) (live): The pastes that run wrote, pasted into an emptied B-Dry staging page as its next steps say and saved, show every own picture from the staging site's media library (no grey placeholder, no bdryswi.com address but those the run named) and look as the `npm run site` paste did.
  Test: Justin's paste (same check)

## Tasks (in order; one commit a task, each green; ledger `.superpowers/sdd/site-one-command/progress.md`)

0. Copy this plan to `docs/plans/2026-11-10-site-one-command.md`; `npm run check` and `npm run corpus` on the copy
   before any change (keep the numbers); run the four web files of "Base tallies" there too.
1. **The refactor, no behaviour change.** Move `site-upload.ts`'s body into `tools/lib/site-upload/flow.ts` (exact
   interfaces above), `capture.ts`'s launch and extras into `tools/lib/capture-run.ts`, `one()` into the exported
   `capturePage()`, `dryRunLines`' body into `pictureLines`. Write AC11's story pin first (it runs both trees; on the
   base copy it passes base against base, so it is a preservation test, green before and after, never a RED); run
   it, the existing site-upload, owned, capture-cli, human-check, capture-unreachable, capture-not-the-page and
   site-upload-page tests: all pass unchanged. Commit.
   The one existing case the move breaks, and only that case, is replaced in `test/unit/capture-chrome.test.ts` [amended A3]
   (it regex-pins the launch line in `tools/capture.ts`'s text, line 36; no other test reads a moved file as text: [amended A3]
   `git grep` of `test/` for `tools/capture.ts`, `tools/site-upload.ts`, `capture-pages.ts`, `site-upload/ask.ts`, [amended A3]
   `site-upload/summary.ts` and `web/owned.ts` finds only spawns and imports). It keeps every old assertion where its [amended A3]
   line now is, and adds that both commands launch Chrome only through `captureRun` (title unchanged). [amended A3]
   What the case must prove, in any tree (this head, or joined with site-menu): `npm run capture` and [amended A3]
   `npm run site:import` each find Chrome with `findChrome()` and print the helper's line (`chromeMissingText`) and [amended A3]
   exit 1 when none is found; neither launches Chrome itself; both go through `captureRun`, whose one launch passes [amended A3]
   `findChrome`'s path and arguments with `visible` to the one launch every capture shares, and whose launch with no [amended A3]
   Chrome fails with the helper's line. The shared launch is `launchChrome` on this job's own head and [amended A3]
   `launchCaptureChrome` (`src/web/capture.ts`) once site-menu is in the same tree; the case names exactly the one [amended A3]
   the tree has, never both as alternatives. On this head: [amended A3]

   ```ts
   test("npm run capture launches the Chrome findChrome finds and prints the helper's line when it finds none (amendment 2)", () => {
     const read = (path: string) => readFileSync(new URL(path, import.meta.url), "utf8");
     const capture = read("../../tools/capture.ts");
     const imp = read("../../tools/site-import.ts");
     // the launch itself lives in tools/lib/capture-run.ts since site-one-command: capture and site:import share it
     const run = read("../../tools/lib/capture-run.ts");
     assert.match(run, /launchChrome\(\{ path: chrome\.path, args: chrome\.args, visible \}\)/);
     assert.match(run, /"missing" in chrome \? Promise\.reject\(new Error\(chromeMissingText\(chrome\.missing\)\)\)/);
     for (const [name, src] of [["capture", capture], ["site:import", imp]] as const) {
       assert.match(src, /const chrome = findChrome\(\);/, name);
       assert.match(src, /captureRun\(chrome, /, name);
       assert.doesNotMatch(src, /launch\w*Chrome\(/, `${name} launches Chrome only through captureRun`);
     }
     assert.match(capture, /console\.error\(chromeMissingText\(chrome\.missing\)\); return 1;/);
     assert.match(imp, /out\.error\(chromeMissingText\(chrome\.missing\)\); return 1;/);
     assert.equal(missingText("/x"), chromeMissingText("/x"));
   });
   ```

   Proven by the planner on a scratch copy of `f4a7dc8a` (`planner/amend1/`): the case as on main fails there (the [amended A3]
   held failure), this one passes 4/4 in the file, and each of six mutants fails it on an assertion: `capture.ts` [amended A3]
   launching Chrome itself again, `capture-run.ts` dropping `args: chrome.args`, `site:import` finding Chrome another [amended A3]
   way, either command going on without the helper's line, the run's own launch with no Chrome naming another line. [amended A3]
   Its behaviour twin stays `test/web/capture-cli.test.ts` › AC8 (the command run with and without `CHROME_PATH`). [amended A3]
2. **`Prompter.line(q, { fresh })` and `confirmOwned`'s `ask`.** Supporting tests first, each RED on the base for the
   behaviour (not for a missing function: write them against the existing exports and options, so on base the
   typed-ahead line is taken and the owned answer leaks, as probe 1 showed): `test/unit/site-upload-ask-fresh.test.ts`
   (through `test/fixtures/pty-run.py`, a tiny driver script under `test/fixtures/drivers/`, never `test/fixtures/` itself: [amended A6]
   four unit tests import every file there, and importing a driver that reads stdin hangs `npm test`; a line typed before a fresh
   question is dropped; without `fresh` it is read as today; in a pipe a line written after the question is read) and
   `test/unit/web-owned.test.ts` gains a case (with `ask`, the question goes through it and stdin is never read;
   without it, as before). Then the code. Commit.
3. **`args.ts`, `gate.ts`, `next.ts`, `after-scan.ts`, `scan-stop.ts`** with their unit tests: AC6's test (its
   oracle half, `capture:check` and `site:upload --dry-run` run as commands on the same hand-made captures, passes on [amended A7]
   base: `capture:check` names each problem, `site:upload --dry-run` lists what goes up and what stays; its [amended A7]
   `afterScan` half is RED on base only because the module is missing: a new helper, said plainly in the ledger; its
   behaviour proof is the mutant "skip `scanProblem` in `afterScan`", which must fail it), and supporting `test/unit/site-import-args.test.ts` (refusals as `args.ts`: a password-shaped flag named, extra words
   never printed, `--part` checked; the default out folder from the address; `uploadLine` quoting) and
   `test/unit/site-import-next.test.ts` (steps per platform, only the parts written). Commit.
4. **`tools/site-import.ts` and the `package.json` script**, test first: AC1 and AC8 (unit, no Chrome: AC1 stops at
   the owned question's "n" or the wrong password; their env sets `CHROME_PATH` to an existing file that isn't
   Chrome, such as `process.execPath`, so `findChrome` passes on any machine and a Chrome started by mistake fails
   loudly and leaves its `f2b-chrome-*` folder, which the test looks for; RED on base: the tool doesn't exist, the
   spawn exits 1 with "Cannot find module", so each prompt assertion fails), then AC10, AC9, AC4 (web). Commit after
   each green pair.
5. **The stops and the secrets:** AC3, AC7 (pty, `test/fixtures/pty-run.py`; the scan-stage stop handler), AC2, AC5.
   AC3's test types `yes` with no Enter once `Capturing` shows, then Enter alone at `Type yes: `: `Not yes`, exit 2, no [amended A8]
   POST (RED on `e0e62e0c`: 7 POSTs, review 1's `ahead-noenter-pty`); a supporting case in the same file types the [amended A8]
   password with a newline and one more Enter before the owned question shows: the question still waits (R1-5). [amended A8]
   Commit.
6. **The story pin for AC12** (`F2B_STORY_PINS=1 F2B_BASE_TREE=<base archive>`: builds both trees' `dist` and compares;
   checks `git diff --name-only <base> HEAD` touches none of the Figma folders). Commit.
7. **Docs and records:** HANDOFF section above the top `## ` heading ("One command scans a page into WordPress",
   build set at the merge, paste check: the next free id at the merge, "Justin's check" below as its end-of-run entry
   at the top of "End-of-run check list"); the ledger; `npm run check`, `npm run test:web` (file by file on the
   desktop), `npm run corpus` at the close. The finisher moves the ledger to
   `docs/plans/2026-11-10-site-one-command-ledger.md`, bumps `BUILD` at the merge, and writes the CLAUDE.md lines in
   "Standing-rule change" below.

## Tests and how each is proven

- Every AC test above, cited by its exact name. A web test's capture takes about 10 s (probe 3); AC7's and AC3's
  run through `test/fixtures/pty-run.py` (a real terminal: Ctrl+C reaches the foreground group, echo is checked
  after). The leak oracle (AC2) reuses `site-upload-cli.test.ts`'s forms of the password; Chrome's processes are found
  from `/proc/*/stat` by parent pid (the tool's children and theirs) while `Reading at` shows.
- RED on base for AC1-AC10: `tools/site-import.ts` is missing, so each spawned run exits 1 and the assertions on its
  prompts, lines and files fail (record the failing assertion, not a crash of the test file). AC6 RED: the module is
  missing; its oracle half (`capture:check` and `site:upload --dry-run` on the same captures) passes on base. [amended A7] AC11 and AC12 are preservation tests: green on
  base against base and on the head; their proof is that they fail when a printed byte of `site:upload` or a byte of
  `dist/` is changed on purpose (one mutant each, recorded in the ledger).
- The tests of AC11 and AC12 run only with `F2B_STORY_PINS=1 F2B_BASE_TREE=<a git archive of the base, 11e885fd, [amended A1]
  with node_modules linked>`; without them they skip, and a skip is never counted as a pass (the verifier and the auditor
  set both).
- Mutants the builder runs and records (each must fail its AC test): drop `fresh: true` (AC3); call `confirmOwned`
  without `ask` (AC3); move `logIn` after the scan (AC1); pass the password into Chrome's environment
  (`process.env.X = wp.pass` before `captureRun`; AC2); skip `scanProblem` in `afterScan`, and turn a warning back [amended A7]
  into a stop (AC6); drop raw mode from the fresh drop (AC3's no-Enter case); drop the [amended A8]
  `scanStop` handler (AC7's scan-stage stop: a Chrome left or no "Stopped during the scan" line); remove the TTY
  refusal (AC8); call `capture.ts`'s launcher in `site-import` instead of `captureRun` with a
  different switch (AC9's capture equality).
- Base tallies: unit files listed above 38/36/0/2 (story pins); the web files (`capture-cli`, `human-check`,
  `capture-unreachable`, `site-upload-page`), file by file on the base archive under a 4G scope: capture-cli 6/6,
  human-check 7 pass + 1 skipped (`F2B_VISIBLE_CHROME=1` opt-in), capture-unreachable 2/2, site-upload-page 1/1, no
  failure, no earlyoom kill (`planner/base-web/*.tap`). `capture-not-the-page.test.ts` was not run on the base by the
  planner: the builder runs it in Task 0.

## Standing-rule change (CLAUDE.md; the finisher writes it at the merge)

Replace the bullet "**One tool writes to WordPress: `npm run site:upload`** … never writes to a site." with exactly:

```
- **One uploader writes to WordPress, reached by two commands: `npm run site:upload` and `npm run site:import`**
  (Justin, 2026-11-10: a scanned page's pictures "upload to my Wordpress media library like how it is in the plugin",
  run "From the command line"; then "One command, Mini": WordPress asked first, then the scan, the upload and the
  paste). Both run the same code (`tools/lib/site-upload/`). It only adds media items (never changes, moves or deletes
  one; never touches pages, posts or settings), only on the site whose address was typed, after reading that site and
  a typed `yes` asked after everything it found is shown (no flag skips it; `site:import` takes only a yes typed after
  that question). The Application Password is typed at the hidden prompt (`site:import` asks it before the scan and
  keeps it only in its own memory through it) and never goes in an argument, a variable, a file, the record, the
  capture, the paste, a log, a printed line or the scan's Chrome. Only Justin runs either, in his own terminal, against
  his own site. Agents never run them against his site or any live site, never ask for or hold his password, and test
  them only against `test/fixtures/wp-standin.ts` and local fixture sites. Every other tool (capture, the helper, site,
  site:check, site:live, compare, replay) stays read-only; the helper still binds 127.0.0.1 only and never writes to a
  site.
```

In the decision bullet "**A scanned page's pictures go to WordPress from the command line**", replace "its own command
`site:upload` (Q1 A)" with "its own command `site:upload` (Q1 A), and one command `site:import` that asks for WordPress
first, then scans, uploads and writes the pastes (Justin, 2026-11-10, \"One command, Mini\"; after the scan it stops only for real failures and warns of the rest, Justin's Q5 \"Only real failures\"; site-one-command Q1–Q4 ⭐ [amended A7]
not yet confirmed)". Status: the build line and one feature line with its paste check.

## Justin's check (the paste check: the next free id at the merge)

In your own terminal window (Windows Terminal → Ubuntu), not through Claude:
1. `cd ~/Documents/FigmaToBricksV2`
2. `npm run site:import -- https://bdryswi.com/ https://bdry.staging.growithgro.com --elementor`
3. It prints "WordPress site: … at https://bdry.staging.growithgro.com": check it is B-Dry staging. Type your WordPress
   user name and press Enter, then type a wrong password on purpose and press Enter: within seconds it says
   "Couldn't log in: …" and stops (no Chrome window opens).
4. Run step 2 again. This time paste the real Application Password (WordPress → Users → Profile → Application
   Passwords; nothing shows as you paste it) and press Enter. It says "Connected to … as …".
5. If it asks "Is bdryswi.com your client's own site?", type `y` and press Enter.
6. Wait for the scan (a few minutes). Press **I am human** in the Chrome window when it asks.
7. It lists the pictures with their alt texts, then asks "Upload N new pictures (M already in your library) …? Type
   yes:". Type `yes` and press Enter. It counts the pictures up and prints the summary and the next steps.
8. WordPress → Media: open two of the new pictures (their names end in `-image`): their Alternative Text is the old
   site's.
9. Follow the printed next steps: copy `header.json`, paste into an emptied staging page with Bricks, then `page.json`,
   then `footer.json`; Save; Bricks → Settings → Custom code → Regenerate code signatures.
10. Open the page logged out: every picture shows (no grey box); right-click a photo → Copy image address: it is on
    `bdry.staging.growithgro.com`.
11. Reply *imported* + the page name.

## Risks

- **The refactor of `site-upload.ts`** could change a printed byte (the order of `say` calls, the scrubber's scope):
  AC11's story pin and the existing site-upload tests are the guard; stop with `escalate to full` if it can't hold.
- **The yes question's 150 ms settle** is a heuristic for keys waiting in the terminal: a key typed in the instant
  the question appears may be dropped (Justin types again); never taken early, typed with or without Enter (raw mode, [amended A8]
  A8). AC3 proves both typed-ahead forms. [amended A8]
- **A Chrome left after Ctrl+C during the scan:** the tool's handler closes it; AC7 checks no Chrome of the run is
  left after 5 s.
- **`checkCapture`'s Figma conversion** runs on every scan (seconds on B-Dry's page) only to name warnings now; it
  never stops the run (Justin's Q5). What is known of B-Dry: no capture of bdryswi.com made with the current capture [amended A7]
  code has been checked yet (HANDOFF 3do's "`capture:check` prints ok" is a check still owed to Justin, not a result). [amended A7]
  The saved B-Dry stand-in (`~/.cache/soc-r1/real/bdry-standin.f2b-capture.json`, a local replay of the saved home made [amended A7]
  2026-11-10 without shots) fails `capture:check` (16 shown pictures without bytes, 15+ layers without a stored [amended A7]
  picture), while `site:upload --dry-run` takes it: 29 would go up, 6 stay on their old addresses (no file in the [amended A7]
  capture). Review 1's other two: a page with one picture answering 404 (capture:check FAIL, a shown picture without [amended A7]
  bytes; site:upload: 7 up, 4 stay, the 404 one among them) and the repo's `code-page` fixture with default flags [amended A7]
  (FAIL, no stored picture for node w11; site:upload: 8 up, 0 stay); `planner/amend2/three.log`, on an archive of [amended A7]
  `e0e62e0c`, nothing sent. Under Justin's rule all three run to the list with warnings. [amended A7]
- **`site:upload` keeps today's `yes` reading** (AC11: byte for byte): a `yes` typed into its terminal before its
  question shows (seconds after the password, while it logs in) still counts there. A follow-up for HANDOFF
  "Deferred": give its question `fresh: true` too, once Justin is asked.
- **Review 1's other findings, as the fixer treats them** (`evidence/site-one-command/review-1/review.json`): [amended A10]
  - R1-4 (follow-up, HANDOFF "Deferred"): a record that can't be read ends the run after the login and the scan; read [amended A10]
    it before the login, as `site:upload` does, in a later job. [amended A10]
  - R1-5 (fixed now, A8): the owned question is asked fresh, so a password pasted with a newline plus an Enter no [amended A10]
    longer answers it "no" for good. [amended A10]
  - R1-6 (fixed now, `tools/site-import.ts`): a failed scan's last line says what to type next ("Run the same command [amended A10]
    again", and where the scan is saved when it was written), and the capture's own lines printed through [amended A10]
    `site:import` say `run the same command again` where the panel's words say `press Capture to try again` [amended A10]
    (`([Pp])ress Capture to try again` → `Run`/`run` + ` the same command again`); `npm run capture`'s own lines stay. [amended A10]
  - R1-7 (fixed now, `tools/lib/site-upload/flow.ts` and `after-scan.ts`): `upload()` takes an optional [amended A10]
    `stopped(inLibrary, total)` line; `site:import` passes "Stopped. N of M pictures are in your media library; to [amended A10]
    finish without scanning again, run the line below." (AC7's `Stopped. N of M pictures …` holds); `site:upload` [amended A10]
    passes none and prints `stoppedLine` as today, byte for byte (AC11). [amended A10]
  - R1-8 (follow-up): `scanStop` writes its line with no `error` listener on stdout or stderr; a terminal window closed [amended A10]
    during the scan may end the tool with a write error instead of 129 (Chrome is closed first either way). [amended A10]
  - R1-9 (fixed now): the header comments of AC11's and AC12's tests name the base `11e885fd`; AC2's test names the [amended A10]
    leaked form by its kind ("as typed", "base64url", …), never by its text, in its failure message. [amended A10]
  - R1-10 (follow-up, base behaviour in `site:upload` too): a password typed or pasted before its prompt shows is echoed [amended A10]
    by the terminal; turning echo off from the start is a change to both commands, for Justin to choose. [amended A10]
- **The record** is shared with `site:upload` (same file, same keys): a scan via `site:import` then `site:upload` of
  the same capture sends no file twice (AC7's last clause).

## Overlaps with unmerged jobs

- **site-menu (`site-menu-fix6`)** changes `tools/capture.ts` lines 17-18 and 57 (`launchCaptureChrome` from
  `src/web/capture.ts`, `sockets: true`) and `tools/lib/site-upload/pictures.ts` (`uploadList`'s kept filter). This job
  moves `capture.ts:57`'s launch into `tools/lib/capture-run.ts`: whichever merges second resolves the conflict in
  `capture.ts` by putting `launchCaptureChrome` in `capture-run.ts` (so both commands get it; AC9's capture equality
  then still holds). `pictures.ts` isn't edited here: `site:import` inherits site-menu's change through `uploadList`.
  **The launch and its pin, joined in either order** (site-menu `site-menu-fix6` `86fc5546`: every Chrome a capture [amended A3]
  starts goes through `launchCaptureChrome` in `src/web/capture.ts`, which adds the WebSocket gate; its commit [amended A3]
  `7094a7d4` points the same case of `test/unit/capture-chrome.test.ts` at `launchCaptureChrome(…)` in [amended A3]
  `tools/capture.ts`). The joined tree is the same whichever merges second: `tools/capture.ts` calls only [amended A3]
  `captureRun` (no launcher import, no launch of its own); `tools/lib/capture-run.ts` imports `launchCaptureChrome` [amended A3]
  from `../../src/web/capture.ts` (not `launchChrome` from `test/browser/chrome.ts`) and calls [amended A3]
  `launchCaptureChrome({ path: chrome.path, args: chrome.args, visible })`; the test keeps this job's case with its [amended A3]
  `capture-run.ts` assertion naming `launchCaptureChrome\(\{ path: chrome\.path, args: chrome\.args, visible \}\)` [amended A3]
  plus one assertion that `capture-run.ts` imports `launchCaptureChrome` from `../../src/web/capture.ts`. [amended A3]
  site-menu first: this job's rebase conflicts in `tools/capture.ts` (take this job's `captureRun` call, drop the [amended A3]
  `launchCaptureChrome` import) and in the test (take this job's case, then the join above); `capture-run.ts` is a [amended A3]
  new file, so git shows no conflict there: the swap to `launchCaptureChrome` must be made by hand (or `site:import` [amended A3]
  and `capture` lose the socket gate silently). site-one-command first: site-menu's rebase conflicts in [amended A3]
  `tools/capture.ts` (its launch line is gone: port `launchCaptureChrome` into `capture-run.ts`) and in the test [amended A3]
  (keep this job's case, then the join). Either way, after the join: `git grep -n -E 'launch(Capture)?Chrome\(' -- [amended A3]
  tools/capture.ts tools/site-import.ts` prints nothing, `tools/lib/capture-run.ts` holds exactly one [amended A3]
  `launchCaptureChrome(`, the case passes, and site-menu's socket-gate tests and AC9 pass on the joined head. [amended A3]
- **footer-icon-list** (`src/web/read/code*.ts`), **control-weight** (`src/core/site/inline-own.ts`, `convert.ts`),
  **site-native-structure** (`convert.ts`, `parts.ts`, `elementor-fold.ts`, `tools/lib/site-measure.ts`,
  `tools/site-check.ts`): no file in common. A job that changes pastes by design keeps AC9 and AC10 green (both sides
  of each comparison run the same tree); AC11's base comparison is a story pin (`F2B_STORY_PINS=1`): record the
  four-tree table once and move on, as the skill says for merged story pins.
- **HANDOFF** top section and check list (every job): this job's section first, the others' as main has them.
- **`package.json`**: one new script line; after a rebase, `grep -c '"site:import"' package.json` is 1.

## Completion

The builder stops at `ready-for-review` with every task committed, AC1-AC12 green with their RED/mutant receipts in
the ledger, `npm run check`, `npm run test:web` and `npm run corpus` as on the base, and AC13-AC14 (live) owed to
Justin through "Justin's check". No agent runs `site:import` or `site:upload` against any address but 127.0.0.1.
