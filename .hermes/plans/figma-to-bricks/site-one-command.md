# site-one-command: one command that asks for WordPress first, then scans, uploads and writes the paste (Mini)

Planner: Opus 5.5 high, 2026-11-10. Base: `main` `7ec16d6060a76b441e42581b78ad3a502461fd66` (Build 2026-11-10.7).
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
- **Q5. Which scans are refused before the upload?** ⭐ **A: what `npm run capture:check` refuses**: a range read
  without the site's styles (exit 2, its one line, as `site`, `site:upload` and `capture:check` refuse it) and any
  other problem `capture:check` names (exit 1, the problems named, "scan again with the same command"); a scan that
  failed or isn't the page itself (a bot check, an error page, a connection lost) stops before anything is listed
  (exit 1). B: only the unstyled range, as `site:upload` refuses today.
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
7. Stops with nothing listed or uploaded when the scan failed or isn't the page itself (exit 1), or isn't one
   `capture:check` calls ok (Q5 A).
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
2. **`tools/lib/site-upload/ask.ts`:** `line(question, o?: { fresh?: boolean })`. With `fresh`, the buffer is dropped
   before the question shows; on a terminal the input is first resumed for 150 ms and what arrives is dropped too
   (a line typed during the scan waits in the terminal until the tool reads). Without `fresh`, as today.
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
}
export function pick(capture: Snapshot, a: { part?: PartName; svg: boolean; elementor: boolean; basicText: boolean; record?: string }, site: Site): Picked;
export interface Login { index: SiteIndex; wp: WP; me: { name: string; restStyle: "pretty" | "query" }; guarded: GuardedFetch }
export async function logIn(site: Site, ask: Prompter, user: string | undefined, out: Out): Promise<Login>;
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
export function captureRun(chrome: Exclude<FoundChrome, { missing: string }>, say: (line: string) => void): HumanRun;
export function captureExtra(): Partial<CaptureOptions>;

// tools/lib/site-upload/summary.ts
export function pictureLines(items: ListedPicture[], kept: KeptPicture[], known: Map<string, number>): string[];

// tools/lib/site-import/args.ts
export interface ImportArgs { page: string; site: string; outDir: string; user?: string; record?: string; part?: PartName; dryRun: boolean; svg: boolean; elementor: boolean; basicText: boolean; owned: boolean; design: number; shots: boolean; windows: number }
export const IMPORT_USAGE: string; // "usage: npm run site:import -- <old page address> <https://your-wordpress-site> [--out <folder>] [--user <name>] [--dry-run] [--svg] [--elementor] [--part header|page|footer] [--basic-text] [--record <file>] [--owned] [--design <W>] [--no-shots] [--windows <n>]"
export function parseImportArgs(argv: string[], home?: string): { args: ImportArgs } | { error: string }; // the same refusals as args.ts (password-shaped flags named, extra words never printed); exactly 2 places
export function uploadLine(capture: string, a: ImportArgs): string; // npm run site:upload -- '<capture>' '<out>' <site> [--elementor] [--svg] [--part x] [--basic-text] [--record '<file>'] [--user '<name>']

// tools/lib/site-import/gate.ts
export function scanProblem(capture: Snapshot): { code: 1 | 2; line: string } | null;
// unstyledLine(capture) → { code: 2, line: `${it} Nothing was uploaded.` }; checkCapture(capture) not ok →
// { code: 1, line: `The scan isn't one npm run capture:check calls ok (${problems.join("; ")}): nothing was uploaded. Scan again with the same command.` }

// tools/lib/site-import/next.ts
export function copyCommand(file: string, platform?: NodeJS.Platform, wsl?: boolean): string; // clip.exe < '<file>' | pbcopy < '<file>' | "open <file> and copy all its text"
export function nextSteps(site: string, outDir: string, parts: PartName[], platform?: NodeJS.Platform, wsl?: boolean): string[];

// tools/lib/site-import/scan-stop.ts: SIGINT/SIGTERM/SIGHUP during the scan close the run's Chrome (run.close()),
// print "Stopped during the scan: nothing was uploaded." and exit 128+n (130 for Ctrl+C); dispose() before the upload,
// whose own listenForStop (stop.ts) then takes over
export function scanStop(run: HumanRun, out: Out): { dispose(): void };

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
  const owned = (host: string) => confirmOwned(host, { owned: a.owned, ask: (q) => ask.line(q) });
  await owned(new URL(a.page).host);                             // NotOwned → exit 3, before any Chrome
  out.say(`Scanning ${a.page}: a few minutes. If the site asks you to prove you're human, a Chrome window opens: pass the check there.`);
  const run = captureRun(chrome, out.say);
  const stop = scanStop(run, out);                               // SIGINT/SIGTERM/SIGHUP during the scan: closes Chrome, says "Stopped during the scan: nothing was uploaded.", exits 128+n
  let r;
  try {
    r = await capturePage(run, a.page, { url: a.page, out: a.outDir, owned: a.owned, list: false, all: false, limit: 1, design: a.design, shots: a.shots, windows: a.windows }, { log: out.say, error: out.error }, { ...captureExtra(), confirm: owned });
  } finally { stop.dispose(); await run.close(); }
  if (r.done !== "ok" || !r.snapshot || !r.file) { out.error("Nothing was uploaded: the scan didn't give the page (named above)."); return 1; }
  return afterScan({ file: r.file, snapshot: r.snapshot }, a, site, login, ask, out);
}

// tools/lib/site-import/after-scan.ts afterScan(scan, a, site, login, ask, out), with r = scan:
  const bad = scanProblem(r.snapshot);
  if (bad) { out.error(bad.line); return bad.code; }
  const p = pick(r.snapshot, a, site);
  if (!login) { /* dry run */ for (const l of [`Dry run: nothing was sent to ${site.root} and no password was asked; the scan is saved at ${r.file}.`, "", ...pictureLines(p.items, p.kept, p.known), ...(p.waiting.length ? [waitingLine(p.waiting.length)] : []), "", `To upload them without scanning again: ${uploadLine(r.file, a)}`]) out.say(l); return 0; }
  await lookForSent(login, p, out);
  for (const l of [`What the scan found on ${a.page}:`, "", ...pictureLines(p.items, p.kept, p.known), ""]) out.say(l);
  const answer = (await ask.line(yesQuestion(p, login), { fresh: true })).trim();
  if (answer !== "yes") out.refuse(`Not yes: nothing was uploaded. To upload this scan later without scanning again: ${uploadLine(r.file, a)}`);
  const parts = a.part ? [a.part] : PARTS.filter((x) => siteHas(r.snapshot, x)); // the parts writePastes wrote
  return upload(login, p, a.outDir, out, { after: (ok) => (ok ? nextSteps(login.index.url, a.outDir, parts) : ["", `To finish without scanning again: ${uploadLine(r.file, a)}`]) });
}
// tools/site-import.ts: main().then(…) with the catch of site-upload.ts:332-338, plus NotOwned → its message, exit 3
```

(`siteHas`: the builder takes the written parts from `writePastes`' own result inside `upload()` instead if simpler:
`after` then receives the parts; either way the steps name exactly the files written.)

## Acceptance criteria (all proposed; Justin's "go" approves them)

The tests run only against local fixture sites (`test/fixtures/web/serve.ts`) and the WordPress stand-in
(`test/fixtures/wp-standin.ts`, 127.0.0.1), with a made-up password (`abcd EFGH ijkl MNOP qrst UVWX`), a temp HOME,
record, `F2B_CAPTURE_CONFIG` and TMPDIR, Chrome from `CHROME_PATH`.

- AC1 (proposed): A real run asks in this order: prints `WordPress site: … at …` (the index read with no password), asks the user name, then the Application Password, tests the login with a read and prints `Connected to … as …`, and only then asks the owned question, before any Chrome starts; a wrong password stops with one line `Couldn't log in: …`, exit 2, no Chrome started (no `f2b-chrome-*` profile in the run's TMPDIR), the old site asked nothing (the fixture server's request log empty), the stand-in received only GET requests, and nothing written in the out folder; a "no" to the owned question stops with exit 3 the same way.
  Test: `test/unit/site-import-order.test.ts` "AC1 the WordPress login is asked and tested before the scan, and a wrong password stops it in seconds"
- AC2 (proposed): The password (as typed, without its spaces, and inside the Basic `user:password` base64 in its standard, JSON-escaped, base64url and URL-encoded forms) is in no file the run leaves (the out folder: capture, `media.json`, pastes, sources, notes; the record; the owned-sites file; HOME; TMPDIR), not in the tool's standard output or error (a run that uploads, and a refused login), not in the tool's `/proc/<pid>/cmdline` or `environ` (read while it waits at the `yes` question), not in the `cmdline` or `environ` of any Chrome process the scan started (read while the scan runs), and the stand-in received it only as the `Authorization` of requests to itself.
  Test: `test/web/site-import-secret.test.ts` "AC2 the password reaches no file, output, argument, environment or Chrome process"
- AC3 (proposed): Before a `yes` typed after the upload question shows, the stand-in receives only GET requests; in a real terminal a `yes` typed during the scan and a `yes` given as the answer to the owned question are never taken as the upload's `yes` (the question still waits; answering `no` then gives `Not yes: nothing was uploaded.`, exit 2, no POST, no `media.json`), and the `Not yes` line names the `npm run site:upload` command that uploads that scan.
  Test: `test/web/site-import-yes.test.ts` "AC3 only a yes typed after the question uploads, and nothing but reads goes before it"
- AC4 (proposed): `npm run site:import -- … --dry-run` scans, asks no password, sends no request at all to the stand-in (its request log empty), writes only the capture file in the out folder (the record unchanged), and prints `Dry run: nothing was sent …`, every picture once with its name, type, size, alt (or decorative / none), where it shows and whether it would go up, is already in this computer's record or stays on its address and why, the same picture lines `npm run site:upload -- <that capture> … --dry-run` prints, and the `npm run site:upload` line that uploads that scan.
  Test: `test/web/site-import-dry-run.test.ts` "AC4 a dry run scans and lists the pictures with their alt text, and sends nothing to WordPress"
- AC5 (proposed): A scan that fails uploads nothing: a page answered as a bot check (fixture `challenge`: "Not the page itself"), a site that can't be reached (a closed port, `F2B_RETRY_MS` short) and a page whose stylesheet never arrives (`F2B_STYLE_RETRY_MS` short) each end with the capture's own line and `Nothing was uploaded: …`, exit 1, no `yes` asked, no POST to the stand-in, no `media.json` or paste written.
  Test: `test/web/site-import-scan-fails.test.ts` "AC5 a scan that fails or isn't the page uploads nothing"
- AC6 (proposed): After the scan, a capture `npm run capture:check` would refuse is refused before anything is listed or sent: handed to `afterScan` with a login to the stand-in, a capture holding a range read without the site's styles ends with exit 2 and `unstyledLine`'s sentence plus `Nothing was uploaded.`, a capture `checkCapture` fails (a part's root missing; a shown picture without bytes) ends with exit 1 naming each problem, neither asks the `yes` question nor sends the stand-in any request, and a clean capture goes on to the list; on each hand-made capture the code matches `capture:check`'s exit code run on the same file.
  Test: `test/unit/site-import-gate.test.ts` "AC6 a scan capture:check would refuse is refused before anything is listed or sent"
- AC7 (proposed): Stopped in a real terminal (Ctrl+C typed as a key): at the password prompt it ends with 130, the terminal's echo back on, nothing but the index read sent; during the scan it says `Stopped during the scan: nothing was uploaded.`, ends with 130, no Chrome process of the run is left after 5 s, no POST, no `media.json`; at the `yes` question it ends with 130 and nothing uploaded; during the upload it does what `site:upload` does (no new upload starts, the ones going answer, the record, `media.json` and the pastes are written, `Stopped. N of M pictures …`, 130) and then names the `npm run site:upload` line; running that line sends only the pictures the library lacks (no file twice).
  Test: `test/web/site-import-stop.test.ts` "AC7 a stop at each stage uploads nothing before the yes and loses nothing after it"
- AC8 (proposed): With no person at the terminal (stdin a pipe), any WordPress address but this computer's own is refused at once, dry run too: one line naming why, exit 2, no request sent, no Chrome started, no question asked, nothing written; for 127.0.0.1 the run goes on (the tests' stand-in).
  Test: `test/unit/site-import-no-person.test.ts` "AC8 no person at the terminal: refused for any site but this computer's own"
- AC9 (proposed): For one fixture page (media-page, one fixture server) and two fresh stand-ins, `npm run site:import -- <page> <stand-in B> --elementor` writes `media.json`, every paste, every sources file and `notes.txt` byte for byte as `npm run capture -- <page>` then `npm run site:upload -- <that capture> <out> <stand-in A> --elementor` write, once each stand-in's address is replaced by one name (only their ports differ), and the two capture files are equal but for `web.timings` and `web.capturedAt`; the same holds without `--elementor`.
  Test: `test/web/site-import-same.test.ts` "AC9 one command writes what capture then site:upload write for the same page"
- AC10 (proposed): A run against the stand-in prints, before the `yes` question, `What the scan found on <page>:` and exactly the picture lines `site:upload --dry-run` prints for that capture (with a record that knows one file: `already in your library`), then the question naming the new and known counts, the site's address and the user's name; after the upload, `site:upload`'s summary and numbered next steps naming each pasted file of the out folder in the order header, page, footer with the copy command for this computer, the site's address, Save, Regenerate code signatures and the cache purge; exit 0.
  Test: `test/web/site-import-run.test.ts` "AC10 a run shows what it found, uploads after yes and says what to do next"
- AC11 (proposed): The four existing commands behave as before: on the base tree (`F2B_BASE_TREE`) and on this head, `npm run capture` (one page of a fixture, `--list`, a refused owned question), `npm run capture:check` (a clean and a refused capture), `npm run site` (whole page, `--elementor`, `--media`) and `npm run site:upload` (dry run, a run, a second run, a refused login, not `yes`, a stop during the upload) print the same stdout and stderr, exit with the same codes and write the same files, after paths, the fixture's and the stand-in's ports and the capture's timings are normalised; and every existing test of those commands passes unchanged.
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
2. **`Prompter.line(q, { fresh })` and `confirmOwned`'s `ask`.** Supporting tests first, each RED on the base for the
   behaviour (not for a missing function: write them against the existing exports and options, so on base the
   typed-ahead line is taken and the owned answer leaks, as probe 1 showed): `test/unit/site-upload-ask-fresh.test.ts`
   (through `test/fixtures/pty-run.py`, a tiny driver script under `test/fixtures/`: a line typed before a fresh
   question is dropped; without `fresh` it is read as today; in a pipe a line written after the question is read) and
   `test/unit/web-owned.test.ts` gains a case (with `ask`, the question goes through it and stdin is never read;
   without it, as before). Then the code. Commit.
3. **`args.ts`, `gate.ts`, `next.ts`, `after-scan.ts`, `scan-stop.ts`** with their unit tests: AC6's test (its
   `capture:check` half, run as a command on the same hand-made captures, passes on base and is the oracle; its
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
  missing; its `capture:check` half passes on base (that's the oracle). AC11 and AC12 are preservation tests: green on
  base against base and on the head; their proof is that they fail when a printed byte of `site:upload` or a byte of
  `dist/` is changed on purpose (one mutant each, recorded in the ledger).
- AC11's and AC12's tests run only with `F2B_STORY_PINS=1 F2B_BASE_TREE=<a git archive of 7ec16d60 with
  node_modules linked>`; without them they skip, and a skip is never counted as a pass (the verifier and the auditor
  set both).
- Mutants the builder runs and records (each must fail its AC test): drop `fresh: true` (AC3); call `confirmOwned`
  without `ask` (AC3); move `logIn` after the scan (AC1); pass the password into Chrome's environment
  (`process.env.X = wp.pass` before `captureRun`; AC2); skip `scanProblem` in `afterScan` (AC6); drop the
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
first, then scans, uploads and writes the pastes (Justin, 2026-11-10, \"One command, Mini\"; site-one-command Q1–Q5 ⭐
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
- **The yes question's 150 ms settle** is a heuristic for lines waiting in the terminal: a line typed in the instant
  the question appears may be dropped (Justin types again); never taken early. AC3 proves the typed-ahead case.
- **A Chrome left after Ctrl+C during the scan:** the tool's handler closes it; AC7 checks no Chrome of the run is
  left after 5 s.
- **`checkCapture`'s Figma conversion** runs on every scan (seconds on B-Dry's page); a site whose capture the Figma
  route refuses but the code route pastes would now be refused here (Q5 A). B-Dry's re-capture is `ok` (HANDOFF 3do).
- **`site:upload` keeps today's `yes` reading** (AC11: byte for byte): a `yes` typed into its terminal before its
  question shows (seconds after the password, while it logs in) still counts there. A follow-up for HANDOFF
  "Deferred": give its question `fresh: true` too, once Justin is asked.
- **The record** is shared with `site:upload` (same file, same keys): a scan via `site:import` then `site:upload` of
  the same capture sends no file twice (AC7's last clause).

## Overlaps with unmerged jobs

- **site-menu (`site-menu-fix6`)** changes `tools/capture.ts` lines 17-18 and 57 (`launchCaptureChrome` from
  `src/web/capture.ts`, `sockets: true`) and `tools/lib/site-upload/pictures.ts` (`uploadList`'s kept filter). This job
  moves `capture.ts:57`'s launch into `tools/lib/capture-run.ts`: whichever merges second resolves the conflict in
  `capture.ts` by putting `launchCaptureChrome` in `capture-run.ts` (so both commands get it; AC9's capture equality
  then still holds). `pictures.ts` isn't edited here: `site:import` inherits site-menu's change through `uploadList`.
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
