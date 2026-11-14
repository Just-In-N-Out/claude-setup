# importer-app: a page on your own computer to scan a site, see it as Bricks will show it, copy the pastes and upload the pictures (plan, Full, 2026-11-13)

Planner: Fable 5.2 high. Plan only: no source or test changed, nothing committed, no agent started, no live site
loaded, no login, no WordPress written, alttext.ai never called.
Evidence (`<E>` below): `~/.hermes/plans/figma-to-bricks/evidence/importer-app/planner/` (`README.md` lists every
file and what it proves). Scratch trees: `~/.cache/iapp-pl/` (may be gone; every script takes its trees as
arguments).
Base: main `7f54b0a5` (Build 2026-11-12.3). Everything measured below ran on that commit; the one change to existing
code (`<E>/seam.diff`) was applied to a copy of it and its suites re-run.

## Playback

1. Today the website importer is typed commands (`npm run site:import …`): the pastes land in a folder as files, you
   copy each with another typed command, and you only see the page after pasting it in Bricks.
2. You asked for "a simple UI for the importer so we run the app, it pastes like the page and then we can copy either
   the header, body, or footer or all … plus a section where we can put the API for alt text": one page in your
   browser that scans a site, shows it as Bricks will draw it (desktop, tablet, phone), has four Copy buttons, opens
   scans you already made, uploads the pictures to your WordPress and keeps your alttext.ai key.
3. This plan adds `npm run importer`: it starts a small server on this computer only (`http://127.0.0.1:47812`) and
   opens that page. The page changes nothing about a paste: it presses the same commands you type today and shows
   what they write, so every paste is byte for byte the command line's.

## Questions (⭐ = the ruling taken; Justin wasn't asked, so each ⭐ is my best-reasoned answer after research. "go with recommended" takes them all)

**Q1. When does the app ask for WordPress: before the scan (as `site:import` does) or as its own step after it?**
- A ⭐ **After the scan, as its own step ("3 Pictures to WordPress"), run on the saved scan.** The scan stays on disk,
  so a wrong password costs seconds, never a scan; you look at the page and its notes first and upload only what you
  mean to paste; the password is in the computer's memory for the seconds of the login, never during the minutes a
  scan's Chrome runs; a scan made last week uploads the same way. It runs `site:upload`, the same uploader.
- B. WordPress first, then the scan (`site:import`'s order). That order exists so a typed command with a wrong
  password stops before a long scan; the app doesn't need it.

**Q2. May the preview load things from other sites?**
- A ⭐ **No: the preview loads nothing but Google's font files.** Pictures come from the scan's own bytes. A widget
  another company's script draws (the reviews carousel) shows as an empty labelled box, with one line saying so; a
  picture the scan holds no file of shows as a grey stand-in. So opening a preview never contacts the old site, a
  reviews service or a tracker from your computer, and never runs their code beside the app.
- B. Let those loaders run so the reviews show. Each preview would then contact another company from your computer
  and run its script next to a page that can start uploads.

**Q3. Where does the app look for saved scans?**
- A ⭐ **`~/Downloads`** (where `site:import` already writes `<page name>/`), listing every folder there that holds a
  scan, and loose scan files. `npm run importer -- --scans <folder>` opens another folder.
- B. A folder of the app's own (your earlier scans would not show).

**Q4. How is the saved alttext.ai key shown?**
- A ⭐ **Only "a key is saved, ending in …a1b2" (its last four characters), with Replace, Test and Remove.** The whole
  key never comes back to the page.
- B. A "show" button (the key would travel to the browser and could be read off the screen).

**Q5. One scan or upload at a time?**
- A ⭐ **One at a time.** A second Scan while one runs is refused with a plain line; looking at a saved scan and
  copying still work meanwhile. (Two scans would fight over Chrome windows and memory: one B-Dry scan opens 4.)
- B. A queue.

**Q6. Does the app remember the WordPress address and user name?**
- A ⭐ **Yes, per scan, in that scan's folder (`importer.json`): the site address and the user name of its last
  upload. Never the password**, which is typed each time (as today).
- B. Remember nothing (you retype the address and user each time).

**Q7. What does "Copy all" copy?**
- A ⭐ **One paste: header, body and footer joined in that order, each class once** (your 2026-11-07 "ONE paste" note;
  the same joining `site:check --whole` draws). Pasted into an empty page it gives the whole page. "Copy header",
  "Copy body" and "Copy footer" copy exactly `header.json`, `page.json`, `footer.json`.
- B. Three copies one after another (the clipboard only holds the last).

**Q8. Which Bricks does the preview draw with?**
- A ⭐ **Bricks 2.4.2's own CSS and scripts (what `site:check` uses), with a switch to 2.3.9.** The choice is kept in
  your browser.
- B. Always the newest only.

**Q9. Does the Elementor box start ticked?**
- A ⭐ **It starts as you left it last time (first time: empty), and a saved scan shows the route it was made with.**
  The app can't know a site is Elementor before it is scanned; "Make pastes again" switches the route without a new
  scan.
- B. Always ticked.

**Rulings I took as the builder's (not questions; reported at the end as "not yet confirmed"):**
- The app is importer only (no Figma debug files).
- The preview is `site:check`'s drawing as it is: entrance animations don't play (every element is in its final
  place), as in every importer receipt.
- This run's key travels in the address's `#` part (`http://127.0.0.1:47812/#<key>`): a browser never sends that part
  to a server, a log or another page.
- The page offers no way to type the options that hold a secret or point a command at another file (`--record`,
  `--media`, `--out`, `--new-ai-key`): the app sets those itself or leaves them to the command line.

## The screen

```
+---------------------------------------------------------------------------------------------------+
| Figma to Bricks: website importer        Build 2026-11-13.N         alttext.ai key: saved (…a1b2) v |
+----------------------+----------------------------------------------------------------------------+
| 1  Scan a page       |  B-Dry Home   scanned 13 Nov 2026 20:14   Build 2026-11-13.N                |
|  Address             |  Elementor route   Pictures: the old site's addresses                       |
|  [https://........ ] |  [Copy header] [Copy body] [Copy footer] [Copy all]        Copied: header   |
|  [x] Elementor site  |----------------------------------------------------------------------------|
|  [ ] This is my      |  Show:   (Whole page) (Header) (Body) (Footer)                              |
|      client's site   |  Width:  (Desktop 1440) (Tablet 991) (Phone sideways 767) (Phone 390)       |
|  More options >      |  Bricks: (2.4.2) (2.3.9)                                                    |
|  [ Scan ]            | +------------------------------------------------------------------------+ |
|                      | |                                                                        | |
| 2  Saved scans       | |        the page, drawn as Bricks will show it at that width            | |
|  > B-Dry Home        | |        (menus, sliders and FAQs work; links go nowhere)                | |
|    13 Nov, 12.4, E   | |                                                                        | |
|  > Fieldstone Home   | +------------------------------------------------------------------------+ |
|    no pastes yet     |  Notes v   Header (26)   Body (45)   Footer (15)                           |
|  Folder: ~/Downloads |    Structure: 493 elements, no Div: ...                                     |
|                      |    - nested-carousel: Bricks' Slider (Nestable), 3 slides ...               |
| 3  Pictures to       |----------------------------------------------------------------------------|
|    WordPress         |  Scan running   2:14    Reading at 14 widths: 6 of 14              [ Stop ] |
|  Site [https://... ] |  ! bdryswi.com asks you to prove you're human: press its button in the     |
|  User [........... ] |    Chrome window that just opened.                                          |
|  Password [******* ] |  > All lines                                                                |
|  [x] Describe with AI|                                                                            |
|  [ List pictures ]   |  (during an upload, here:)                                                  |
|  [ Log in and check ]|  Upload 31 new pictures (4 already in your library) to https://... as       |
|                      |  Justin? Type yes: [.....] [ Answer ]                                       |
+----------------------+----------------------------------------------------------------------------+
```

- Left column, top to bottom, is the order of work: 1 scan, 2 pick a scan, 3 upload. The right side is the scan you
  picked: its facts, the Copy buttons, the preview, its notes, and under them the job that is running.
- The key section opens from the top right: one masked box, **Save and test**, and, once a key is saved, **Test**,
  **Replace**, **Remove** and the line "ending in …a1b2, 412 credits left".
- Under 900 px of window the left column goes above the right side; nothing scrolls sideways.
- Every state has its own plain line: nothing scanned yet ("Type a page's address and press Scan, or pick a saved
  scan"), a scan with no pastes ("Make pastes"), a job running, a job waiting for you, a job that failed (the tool's
  own line, and what to press), stopped, done.

## What I measured (all local; `<E>/README.md` has each script)

- **The preview is cheap.** Justin's B-Dry scan (45 MB, `--elementor`): loaded in 0.2–0.3 s, parts made in 0.7–1.0 s,
  the whole page drawn in 0.2 s; 657 MB at its peak, so it runs in a short-lived child, never inside the server.
  Whole page: 712 elements, 450 classes, 1.34 MB of paste; the drawn HTML is 33.6 MB (pictures as data).
- **Bricks' own scripts run in a locked frame.** Served with `Content-Security-Policy: sandbox allow-scripts;
  default-src 'none'; …` the drawn page has no origin (`null`), can't read storage, and still: 5 Offcanvas, the slider
  and the accordion are ready, a click on the ☰ opens its Offcanvas at 390, no script error. The policy stopped the
  Trustindex loader, three of the old site's font files and one `i0.wp.com` picture.
- **The clipboard works on `http://127.0.0.1`.** It is a secure context: `navigator.clipboard.writeText` of 1.4 MB
  after a real click resolved and read back identical (headless Chrome, the desktop's build).
- **Windows reaches the app.** A server bound to 127.0.0.1 inside WSL answers Windows at `127.0.0.1:<port>` and
  `localhost:<port>`, Host unchanged.
- **Stop works by process group.** `tools/capture.ts` has no stop handler of its own; started in its own group and
  sent the terminal's Ctrl+C signal, it ended with all 15 of its processes (Chrome included) and wrote nothing.
- **The upload runs as a child exactly as typed.** Against the WordPress stand-in: the dry run lists with no
  password; the real run takes the password at its own prompt and `yes` only after its question; it wrote the same
  bytes `npm run site … --media` writes; the password was in no output or argument.
- **A paste with library pictures can still be drawn.** After an upload the pastes name the media library's
  addresses (in `image.url`, `image.full` and the classes' custom CSS). `media.json` maps each back to its old
  address, whose bytes the scan holds (30 of 35 on B-Dry; the other 5 show as stand-ins).
- **The seam changes nothing else.** `test/unit/site-upload-*` and `site-import-*`: 74 tests, 71 pass, 0 fail, 3
  skipped on the base and with the seam; `test/web/site-upload-secrets` and `site-upload-page` pass with it.

## Design

### D1. The app presses the commands; it has no converter and no uploader of its own

`npm run importer` (`node --disable-warning=ExperimentalWarning tools/importer.ts`) starts one HTTP server and runs
the existing tools as child processes with an argument list (never a shell string), in the repo's folder:

| In the page | The app runs | Then |
|---|---|---|
| **Scan** | `node tools/capture.ts <address> --out <scans>/<page name>/ [--owned] [scan options]` | `node tools/capture-check.ts <capture>` (exit 1: its lines shown as warnings, as `site:import` does; exit 2, a range read without the site's styles: the job fails with its line), then `node tools/site.ts <capture> <folder> [paste options]` |
| **Make pastes** / **Make pastes again** | `node tools/site.ts <capture> <folder> [paste options] [--media <folder>/media.json]` | `--media` only when that scan's last upload wrote one and the scan is unchanged since |
| **List pictures** | `node tools/site-upload.ts <capture> <folder> <site> --dry-run [paste options] [upload options]` | its numbered list is shown; no password, nothing sent |
| **Log in and check** | `node tools/site-upload.ts <capture> <folder> <site> --user <name> [paste options] [upload options] [--no-ai-alt]` | the app answers its password prompt once, shows its `Type yes:` question and passes on what Justin types |

A scan that ends with exit 1 (the capture's "not the page itself": a bot check, an error page) fails the job with the
tool's own line and makes no paste; its file stays for a look and is listed as "no pastes yet". Exit 3 (the site isn't
confirmed as the client's own) shows the tool's line and points at the box "This is my client's site", which adds
`--owned`.

`<page name>` is `captureName(address)` without `.f2b-capture.json` (`src/web/pages.ts`), the folder name
`site:import` uses (`defaultOut`). `--no-ai-alt` is added when no key is saved or "Describe with AI" is off, so the
command never asks for a key the page didn't offer.

Why children and not imports: (1) the bytes are the commands' by construction, on every route and after every later
job; (2) a later job's new option needs one line in the app (D5), not a second code path; (3) the uploader ends its
process to refuse, replaces the process-wide `env.fetch` with its guard and listens for stop signals: all correct for
a command, wrong inside a server; (4) a command that crashes or runs out of memory can't take the app or a second
scan with it; (5) Stop is the terminal's Ctrl+C, the path those tools already handle.

`tools/site-import.ts` is not run by the app and not changed (Q1 A).

### D2. The one seam in existing code (4 files, proven: `<E>/seam.diff`, `<E>/flow-proto.log`)

`site:upload` refuses a real site when its input isn't a terminal, and prints its progress only on a terminal. The
app's children have pipes. New file `tools/lib/site-upload/person.ts`, in full:

```ts
// Who is asking, and how progress is printed, when the command runs under the importer app (tools/importer.ts).
// The app sets F2B_ASKED_FROM only when it was itself started from a terminal: the person is at its page.
export const APP_MARK = "importer-app";
export const personAsks = (stdin: { isTTY?: boolean } = process.stdin, env: Record<string, string | undefined> = process.env): boolean =>
  !!stdin.isTTY || env.F2B_ASKED_FROM === APP_MARK;
export const progressLines = (env: Record<string, string | undefined> = process.env): boolean => env.F2B_PROGRESS === "lines";
```

- `tools/site-upload.ts` line 39: `!process.stdin.isTTY` becomes `!personAsks()` (same refusal words).
- `tools/lib/site-upload/flow.ts` `onProgress`: after the terminal branch, `else if (progressLines()) say(`Pictures: ${done} of ${total}`);`.
- `tools/lib/site-upload/prepare.ts`: after the terminal branch, `else if (progressLines()) out.say(`Making AVIF: ${i + 1} of ${avif.length}`);`.
- `tools/lib/site-upload/ai-key.ts`: `tried` and its `Tried` type gain `export` (two words), so the key section judges
  a key exactly as the prompt does (refused: 401, 403 or "refused the key").

Without the two variables the commands print and write what they do today (AC17). The mark is not a secret and the
terminal check never was a lock (a pseudo-terminal passes it): both stop an unattended script from uploading by
accident. The rule that only Justin uploads to a real site stays a rule (Security, S6).

### D3. The server (`tools/lib/importer-app/`)

`startImporterApp(o: { port: number; scans: string; build: string; person: boolean; repo?: string; env?: NodeJS.ProcessEnv; keyFile?: string; token?: string; tmp?: string; log?: (line: string) => void }): Promise<{ port: number; address: string; token: string; close(): Promise<void> }>`

- Listens on `127.0.0.1` only (never `0.0.0.0`, `::` or `localhost`'s other address), port 47812 (`--port <n>`; the
  panel's helper keeps 47811). A taken port stops with one line naming `--port`.
- `tools/importer.ts`: `npm run importer -- [--scans <folder>] [--port <n>] [--no-open]`. It prints
  `Importer app: http://127.0.0.1:47812/#<key>` and "Leave this window open; Ctrl+C here closes the app", then opens
  the browser (`open` on the Mac; `cmd.exe /c start "" "<address>"` on the desktop's WSL; `xdg-open` elsewhere;
  `--no-open` skips it). `person` is `process.stdin.isTTY === true`.
- The page: `GET /` (the shell, `index.html`), `GET /app/<name>` for a fixed list of files (`app.css`, `main.ts`,
  `api.ts`, `views.ts`, `copy.ts`, `preview.ts`, `upload.ts`, `key.ts`): a `.ts` file is served as JavaScript through
  `stripTypeScriptTypes` (`node:module`; proven on Node 22.23.3, `engines` is `>=22.18`), so the page needs no build
  step and its sources stay under `npm run typecheck`. No name outside the list is served; nothing is read by a path
  taken from a request.
- The page finds this run's key in `location.hash`, keeps it in `sessionStorage` (it survives a reload, not the tab),
  removes it from the address bar with `history.replaceState`, and sends it as the header `X-F2B-Token` on every
  `/api` request. With no key it shows one box: "Paste the address the terminal printed".

API (JSON; every `/api` path needs the key; bodies at most 16 KB; anything else is 404, `OPTIONS` is 405):

| Method and path | Does |
|---|---|
| `GET /api/state` | build, scans folder, whether the app can upload to a real site (`person`), the options this build knows (D5) |
| `GET /api/scans` | the saved scans (D6) |
| `GET /api/scans/<id>/paste/<header\|page\|footer\|all>` | that paste's text, exactly the file's bytes; `all` is the joined paste (D8) |
| `GET /api/scans/<id>/notes` | the notes by part (D11) |
| `GET /api/job?from=<n>` | the running or last job: state, step, lines from `<n>`, the open question (D4) |
| `GET /api/key` | `{ saved, ends }` (D10) |
| `POST /api/scan` | `{ address, owned, scan: [...], paste: [...] }` starts a scan |
| `POST /api/scans/<id>/pastes` | `{ paste: [...] }` makes the pastes again |
| `POST /api/scans/<id>/preview` | `{ part, bricks }` draws it, answers `{ ticket, notes: [...] }` (D7) |
| `POST /api/scans/<id>/upload` | `{ site, user, password?, dryRun, ai, upload: [...] }`: the only body that ever holds the password |
| `POST /api/job/answer` | `{ question, text }` answers the open question (D4) |
| `POST /api/job/stop` | stops the job |
| `POST /api/key`, `/api/key/test`, `/api/key/remove` | D10 |
| `GET /preview/<ticket>` | the drawn page, for the frame (no key header: a frame can't send one; the ticket is 32 random bytes, lives for this run, and names only a drawing) |

### D4. Jobs, their lines and their questions (`jobs.ts`, `prompts.ts`)

- One job at a time (Q5): a second start answers 409 "A scan is running: stop it or wait".
- A job is a chain of commands (D1). Each child is spawned `detached` (its own process group), `stdio` all pipes,
  with the app's environment plus `F2B_PROGRESS=lines`, and `F2B_ASKED_FROM=importer-app` only when `person`.
- Its stdout and stderr are split into lines; every line passes a `Scrubber` (`tools/lib/site-upload/scrub.ts`) that
  knows the job's password while it holds one, then goes to the job's list (the last 2,000 kept). The page asks
  `GET /api/job?from=<n>` once a second while a job runs and shows the last line as the step, the time since the
  start, and all lines under "All lines".
- What the page gets: `{ id, kind: "scan" | "pastes" | "upload", state: "running" | "asking" | "done" | "failed" | "stopped", step, lines, from, total, attention: null | "window", question: null | { id, kind: "yes" | "secret" | "text", text }, code, scan, elapsedMs }`.
- **The person check.** A line matching the capture's `waitingLine` ("asks you to prove you're human") sets
  `attention: "window"`: the page shows it as a banner above the lines and in the tab's title ("Waiting for you")
  until `passedLine` or the next step. The check itself is pressed by Justin in the visible Chrome the command
  opened, as today; the app never touches that window (the automated-Chrome rule is untouched).
- **Questions.** A command's question is text without a line end. `prompts.ts` holds the known ones by the tools' own
  exported words: the Application Password prompt (`secret`), `Type yes: ` (`yes`), `KEY_QUESTION` (`secret`),
  `WordPress user name: ` (`text`). A partial last line that is none of them and hasn't changed for 2 s while the
  child lives becomes a `secret` question (shown masked: an unknown question is treated as the most private kind).
- **The password** arrives in `POST …/upload`, sits in the job (one field, added to the job's `Scrubber`), is written
  once to the child's input when the password prompt shows, and the field is cleared in the same tick. If the command
  asks again it becomes a `secret` question the page shows masked.
- **`yes`.** The page shows the command's own question and one text box that starts empty when the question appears;
  what Justin types is sent to `POST /api/job/answer` with the question's id and written to the child as typed
  (the command decides: anything but `yes` uploads nothing). An answer when no question is open, or for another
  question's id, is 409 and reaches no command: `site:upload`'s own prompt would take an early line on a pipe, so the
  app is where "only a yes typed after the question shows" is kept (AC11).
- **Stop** sends the group `SIGINT` (`process.kill(-pid, "SIGINT")`), what Ctrl+C sends in a terminal; a second Stop
  sends `SIGKILL`. The job ends `stopped` with the tool's own stop line (an upload's "Stopped. N of M pictures are in
  your media library; run the same command again to finish", under which the page says "press Log in and check again
  to send the rest"). The app's own Ctrl+C (and SIGTERM, SIGHUP) stops the job the same way, deletes the previews'
  folder, closes the server and exits.
- After a scan's `site.ts` or an upload ends well, the app writes the scan's `importer.json` (D6).

### D5. Options: one table, each option reaching the command that takes it (`commands.ts`)

```ts
export interface Option { flag: string; valued: boolean; label: string; help: string; to: Array<"capture" | "site" | "upload">; check?: (v: string) => string | null }
export const OPTIONS: Option[] = [
  { flag: "--design", valued: true, to: ["capture"], label: "Design width", help: "the width the site was designed at (default 1440)", check: wholePx },
  { flag: "--windows", valued: true, to: ["capture"], label: "Chrome windows", help: "how many widths are read side by side (default 4)", check: oneToEight },
  { flag: "--no-shots", valued: false, to: ["capture"], label: "No screenshots", help: "a smaller, faster scan" },
  { flag: "--elementor", valued: false, to: ["site", "upload"], label: "Elementor site", help: "paste Bricks' own elements for an Elementor page" },
  { flag: "--basic-text", valued: false, to: ["site", "upload"], label: "Basic Text", help: "words as Basic Text instead of Rich Text" },
  { flag: "--svg", valued: false, to: ["upload"], label: "Upload SVGs too", help: "only if your site accepts SVG uploads" },
  { flag: "--as-served", valued: false, to: ["upload"], label: "Keep the files as served", help: "no AVIF copies" },
  { flag: "--reupload-avif", valued: false, to: ["upload"], label: "Send AVIF copies of pictures already uploaded as served", help: "" },
];
```

- `wholePx` and `oneToEight` are two small checkers in the same file (a whole number of px from 320 to 3840; 1 to 8),
  each returning a plain reason or `null`.
- The page draws "More options" from `GET /api/state`'s copy of this table (the Elementor box is the first row,
  shown outside the fold), so a new option appears in the page with no page change.
- `argsFor(kind, chosen)` builds each command's list: only table flags, each to the commands in `to`, valued flags
  checked. Anything else in a request is refused before any command starts: a flag not in the table, and by name
  `--out`, `--record`, `--media`, `--dry-run`, `--user`, `--part`, `--section`, `--path`, `--pictures`, `--owned`,
  `--list`, `--all`, `--limit`, `--new-ai-key`, `--no-ai-alt` (the app sets the ones it needs itself), any value that
  starts with `-`, and anything `flagHint` (`tools/lib/site-upload/media-flags.ts`) reads as a password or key. The
  address must parse as `http:` or `https:` and the WordPress site as the uploader's `siteOf` accepts.
- **Later jobs pass through with one line each** (the standard's tools stay one code path): short-class-names adds
  `--prefix <letters>` and `--new-class-names` (`to: ["site", "upload"]`; its `--class-names <file>` names a file, so
  the app leaves it to that job's default, the list beside the upload record); clean-values adds `--round <px>`,
  `--no-round`, `--no-clean` (its `--clean <file>` stays the default `clean.json`); shared-palette's `--colours`
  likewise. Each of those plans' Docs task gets the line "add the option to `tools/lib/importer-app/commands.ts`"
  (Overlaps). Until then the page simply doesn't offer them and the commands use their defaults, as when typed
  without them.
- Files those jobs write beside the pastes (`palette.json`, `styles.txt`, `structure.txt`, `sizes.txt`,
  `class-names.json`, `clean.json`) are listed under the notes as "Also in this folder", by name, never parsed.

### D6. Saved scans (`scans.ts`) and the scan's own record (`importer.json`)

- The scans folder (Q3: `~/Downloads`, or `--scans`). A saved scan is: (a) a direct subfolder holding an
  `importer.json`; (b) a direct subfolder holding one `*.f2b-capture.json` (made by `site:import` or by hand);
  (c) a loose `*.f2b-capture.json` in the folder itself, listed as "no pastes yet" (Make pastes writes to
  `<scans>/<page name>/`). One level only; nothing is searched deeper, nothing outside the folder is read.
- Each row shows: **the page** (the capture's page name, read from the file's first 4 KB, never the whole 45 MB),
  **the date** (the capture file's time), **the build** it was scanned with (the capture's `build`), **the parts**
  with a paste file (header, body, footer), **the route** (Elementor or plain, Rich or Basic text: from
  `importer.json`; a folder the command line made shows "made by the command line: options unknown" and offers Make
  pastes again), and **where its pictures sit** ("the old site's addresses" or "`<site>`'s media library", from
  `importer.json` or the presence of `media.json`). Newest first.
- An id is the first 16 hex characters of the SHA-256 of the folder's real path; the server keeps the id → path map
  from its own listing, so no request ever carries a path, and a path whose real location leaves the scans folder (a
  link pointing out) is not listed.
- `importer.json` (written by the app only, mode 0600, never read by any command):
  `{ "app": 1, "page": "<address>", "capture": "<file name>", "scan": ["--design", "1440"], "paste": ["--elementor"], "build": "<BUILD>", "pastedAt": "<ISO time>", "upload": null | { "site": "<address>", "user": "<name>", "at": "<ISO time>", "upload": ["--svg"] } }`.
  A new scan into the same folder sets `upload` back to `null` (the old `media.json` no longer belongs to it and is
  not passed on). No password, no key, no cookie, ever (AC12 reads the file).

### D7. The preview (`preview.ts`, `preview-child.ts`)

- **What is drawn: the paste files on disk**, so the preview is of exactly what the Copy buttons copy, whatever
  options made them. `node tools/lib/importer-app/preview-child.ts <folder> <capture> <header|page|footer|all> <bricks> <outFile>`
  reads the part's JSON (or joins the three with `wholePayload`), puts pictures back from the scan
  (`drawPictures(payload, capture)`), and draws with `renderSitePaste(payload, await fontsHead(capture), undefined, { bricks })`
  from `test/web/lib/site-check.ts`: the renderer `site:check` and every importer receipt already use (the hostile
  theme, Bricks' own front-end CSS and scripts for 2.4.2 or 2.3.9, the fonts class).
- **After an upload** the paste names the library's addresses: before `drawPictures`, the child maps each library
  address in `media.json` back to its old address, in every string of the payload that holds one (`image.url`,
  `image.full`, a `_background` image, the classes' custom CSS), on a copy in memory. A picture with no bytes in the
  scan is drawn as the renderer's stand-in and counted in the preview's notes.
- **A guard script** is added to the drawing's head: it cancels a click on a link that isn't a same-page `#` link and
  every form submit (a link would otherwise load the app's own address inside the frame, seen in the prototype), and
  posts `{ f2bPreview: { width, height } }` to the page for the frame's height. The page accepts that message only
  from its own frame's window and reads only two numbers from it.
- **Served** from a folder of the app's own (`mkdtemp`, mode 0700, deleted on exit), kept per `part | bricks | the
  files' times` so a second look is instant, under an unguessable ticket, with the locked policy of Security S4.
- **In the page**: `<iframe sandbox="allow-scripts" src="/preview/<ticket>">` at the exact CSS width of the chosen
  button (the capture's design width for Desktop, 1440 unless scanned with `--design`; 991; 767; 390), scaled down
  with a CSS transform when the window is narrower, its height from the guard's message. Changing the width only
  resizes the frame (the drawing's own media queries do the rest); changing the part or the Bricks version asks for
  another drawing.
- **Opened boxes**: Bricks' Offcanvas, Slider and Accordion scripts are in the drawing, so the ☰, a pop-up's button,
  the slider's arrows and a FAQ work in the preview as in Bricks' front end.
- **What the preview is not** (shown as one line under it): Bricks itself; the live widgets (Q2 A); a font the scan
  holds no file of falls to the next one. The live page stays the judge (the paste check).

### D8. Copy (`pastes.ts`, page `copy.ts`)

- When a scan is opened the page fetches the four texts once and keeps them in memory, so a click copies at once:
  browsers allow a clipboard write only straight after the click.
- `header`, `page`, `footer`: the file's bytes as they are. `all`: `ascii(JSON.stringify(wholePayload([header, page, footer])))`
  from `tools/lib/site-whole.ts` and `tools/lib/site-write.ts`, made on request, written nowhere. A part with no file
  has its button off with the reason ("this scan has no footer paste").
- On click: `navigator.clipboard.writeText(text)`; if it is missing or refuses, a hidden `<textarea>` is filled,
  selected and `document.execCommand("copy")` runs inside the same click; if that fails too, the button turns into
  "Download header.json" (a `blob:` link) with the line "Your browser didn't allow copying: download the file and
  copy its text". The page then says "Copied: header (714 KB)" in a live region.
- After an upload a line sits beside the buttons: "Pictures: in `<site>`'s media library. Paste on `<site>` only (on
  another site Bricks shows grey placeholders)" (the uploader's own warning, kept in view).

### D9. Pictures to WordPress in the page

1. **List pictures** (needs only the site address): the dry run's numbered list, with its "nothing is sent" line.
2. Justin types the user name and the Application Password (a `type="password"` box, `autocomplete="off"`, never
   prefilled) and presses **Log in and check**. The page sends them once, empties the password box at once and keeps
   no copy.
3. The command's own lines show: the site's name, the login, the pictures already in the library, AVIF being made
   (`Making AVIF: 3 of 31`).
4. Its question appears with a text box: "Upload 31 new pictures (4 already in your library) to … as Justin? Type
   yes:". Justin types `yes` and presses **Answer**. Anything else uploads nothing.
5. Progress (`Pictures: 12 of 31`), then the result lines, the new pastes (already drawn from `media.json` when he
   looks), and the next steps from `nextSteps(site, folder, parts)` (`tools/lib/site-import/next.ts`) without its
   "copy this file" command lines (the page has buttons for that).
- When the app wasn't started from a terminal (`person` false) and the site isn't this computer, step 2's button is
  off with "Start the app from your own terminal to upload to a real site", and the server refuses the request
  before starting anything.

### D10. The alttext.ai key section (`key.ts`)

- `GET /api/key` → `{ saved: boolean, ends: "<last 4>" | null }` from `readKey(keyFile())`.
- **Save and test** (`POST /api/key { key }`): `validKey`, then `tried(key)` (alttext.ai's `GET /account`, through
  `aiFetch(alttextBase())`, the uploader's own gate: alttext.ai's address only, no redirect followed); only a key
  alttext.ai accepts is saved, with `saveKey` (the same file, mode 0600, `~/.config/figma-to-bricks/alttext-key`);
  the answer is `{ saved, ends, left }` or the tool's own words ("alttext.ai refused that key"; "couldn't test that
  key (…): the key wasn't saved"). **Test** tests the saved key. **Replace** is Save and test over it. **Remove**
  deletes the file.
- The key travels browser → app once, in a POST body, and app → alttext.ai in that one request; it is never in an
  answer, a log line, an address or the page's storage. This is the only request the app's own process sends to
  another computer (its commands send the rest, as they do today). `F2B_ALTTEXT_API` (this computer only) stands in
  for alttext.ai in tests, as for the uploader.

### D11. The notes, and the standard

- `GET /api/scans/<id>/notes` reads `notes.txt` (what `writePastes` wrote) and splits it at its part headings
  (`Header (…):`, `Page (…):`, `Footer (…):`) into `{ header: [...], page: [...], footer: [...], other: [...] }`,
  lines as text. The page shows the chosen part's notes under the preview ("Whole page" shows all three, headed),
  with a part's `Structure:` line first and in bold when it has one (site-no-div writes it first already), then
  "Also in this folder" (D5). Text the page doesn't understand is shown as it is, never dropped: a later job's new
  kind of note appears without a change here.
- **The standard ("built like a skilled Bricks builder made it by hand").** The app writes no paste and changes none:
  every point of the standard is met or missed by `tools/site.ts`, and the app shows the result two ways: the drawing
  (point 6, looks stay true) and the notes with the Structure line (points 1 to 5: what became which Bricks element,
  what stayed a kept box or page code and why). The reviewers' question for this job, "would a Bricks pro find this
  logical and easy to change?", is asked of the paste the page shows unchanged, so the answer here is: the app must
  never hide, shorten or reorder a note, and AC3, AC4 and AC16 pin that.

### D12. The page itself (`page/`)

- Plain HTML, one stylesheet, small `.ts` modules (`main`, `api`, `views`, `copy`, `preview`, `upload`, `key`), no
  framework, no dependency. The policy allows no inline script or style, so the page uses classes and the CSSOM
  (`element.style.setProperty`) only, and builds every piece of tool text with `textContent`: no `innerHTML`,
  `insertAdjacentHTML`, `document.write`, `eval` or `new Function` anywhere (a unit pin reads the sources).
- Accessibility (WCAG 2.2 AA, the project's website rules): real `<button>`, `<label for>`, `<fieldset>` for the
  three steps; the width, part and Bricks choices are radio groups; the job's step and the Copy result are in
  `aria-live="polite"` regions, a question and the person-check banner in `role="alert"`; focus moves to a question's
  box when it appears; every control reached with Tab in reading order with a visible focus ring; text contrast at
  least 4.5:1; targets at least 24 px; `prefers-reduced-motion` and `prefers-color-scheme` followed.
- `localStorage` holds only conveniences (the Elementor box, the last width, the Bricks version), read in `try`.
  Never the run's key (session only), the password, the alttext.ai key or a paste.
- Words are the tools' own wherever a tool said them; the app's own lines say what happened and what to press.

## Security

`security-best-practices` applied to a small Node server with a browser page; the precedent in this repo is the
panel's helper (`src/web/helper/server.ts`: 127.0.0.1, Host check, 16 KB bodies, a constant-time code check).

### S1. What is protected, and from whom

| Protected | From | Defence | Proof |
|---|---|---|---|
| The Application Password | every place but the upload command's input | S5 | AC12 |
| The alttext.ai key | the page, logs, other sites | S7 | AC14 |
| Starting a scan, an upload or a `yes` on this computer | any other web page open in the same browser (a forged request, a rebinding name), any other device | S2, S3 | AC2, AC1 |
| The app page and its key | the scanned site's own markup and scripts, drawn in the preview | S4, S8 | AC6, AC19 |
| Files on the computer | a request naming a path, a flag naming a file | S9 | AC9, AC15 |
| Justin's WordPress site | an upload nobody at the keyboard asked for | S6 and the uploader's own rules, unchanged | AC11, AC13 |

Outside this defence, as for every tool here: another program already running as Justin on this computer (it can
read his files, his saved key and his keystrokes without the app).

### S2. Where it listens

`server.listen(port, "127.0.0.1")` only. No other interface, no IPv6 wildcard, no `--host` option. A phone or
another computer on the network can't connect.

### S3. Which requests it answers (`guard.ts`, one function every route goes through)

1. **Host**: exactly `127.0.0.1:<port>` or `localhost:<port>`, else 421. A hostile page that points its own name at
   127.0.0.1 (DNS rebinding) is refused before anything is read.
2. **This run's key** on every `/api` path: header `X-F2B-Token` equal (`timingSafeEqual`) to 32 random bytes made at
   start (`randomBytes(32).toString("base64url")`), else 401. It is never a cookie, so the browser never adds it to
   a request by itself; another site's form, image or link can't set a header; another site's `fetch` with a custom
   header needs a preflight, which gets 405 and no CORS header.
3. **Every POST** also needs: `Origin` equal to the app's own (`http://127.0.0.1:<port>` or
   `http://localhost:<port>`), `Sec-Fetch-Site: same-origin` when the browser sends that header,
   `Content-Type: application/json`, a body of at most 16 KB that parses to an object; else 403, 415, 413 or 400.
   Nothing changes on a GET.
4. **No CORS header is ever sent**, so no other origin can read an answer. No cookie is ever set.
5. Every answer: `Cache-Control: no-store`, `X-Content-Type-Options: nosniff`, `Referrer-Policy: no-referrer`,
   `Cross-Origin-Resource-Policy: same-origin`. The shell also: `Cross-Origin-Opener-Policy: same-origin` and
   `Content-Security-Policy: default-src 'none'; script-src 'self'; style-src 'self'; img-src 'self' data:; connect-src 'self'; frame-src 'self'; base-uri 'none'; form-action 'none'; frame-ancestors 'none'`.
6. A refused request starts nothing, reads no file and answers with a status and one short word, never a reason
   that helps a forger.

### S4. The preview can't reach the app

The drawing holds a stranger's markup and Bricks' scripts, so it is served as another, origin-less document:
`Content-Security-Policy: sandbox allow-scripts; default-src 'none'; script-src 'unsafe-inline'; style-src 'unsafe-inline' https://fonts.googleapis.com; font-src data: https://fonts.gstatic.com; img-src data:; media-src data:; connect-src 'none'; frame-src 'none'; child-src 'none'; worker-src 'none'; object-src 'none'; form-action 'none'; base-uri 'none'; frame-ancestors 'self'`
and framed with `sandbox="allow-scripts"` (no `allow-same-origin`, no `allow-top-navigation`, no `allow-popups`,
no `allow-forms`). So inside it: no storage, no cookie, no request to the app (it has no key and `connect-src` is
`none`), no request to any host but Google's two font hosts, no pop-up, no navigation of the app's page. Proven with
the B-Dry drawing (`<E>/sandbox-proto.log`). Inline scripts are allowed there because Bricks' own scripts and the
paste's Code elements are inline in the renderer; they run with nothing to reach. The page reads from the frame only
`{ f2bPreview: { width, height } }`, two numbers, from its own frame's window.

### S5. The Application Password's whole path

1. Typed into a `type="password"` box in the page (never prefilled, `autocomplete="off"`).
2. Sent once, in the JSON body of `POST /api/scans/<id>/upload` to 127.0.0.1 (never in an address, a header or a
   query); the page empties the box and drops its variable as the request leaves.
3. Held in one field of the job in the server's memory, and registered with the job's `Scrubber` so that no tool
   line that could hold it (in any of the forms `secretForms` lists: plain, without spaces, URL-encoded, base64
   with the user name) is ever kept or sent to the page.
4. Written once to the upload command's input when its own password prompt appears; the field is cleared in the
   same tick, and when the job ends for any reason.
5. From there on it is exactly today's `site:upload`: the command's own memory and its `Authorization` header to
   the typed site only (its `guardFetch`).
- It is never: in an address, an argument, an environment variable, `importer.json`, the upload record, the capture,
  a paste, `notes.txt`, a preview, a log line, an answer of the API, the page's storage, or any Chrome the tools
  start (no scan runs while an upload does: one job at a time, and the scan is a different, earlier process).
- A browser may offer to save a password typed in a page; `autocomplete="off"` asks it not to, and Justin can say no.
  (A known limit: a browser decides that, not a page.)

### S6. Who uploads to a real site

- The uploader's rules are untouched: the site read first, the typed `yes` after its question, only media items
  added, only on the typed site. The app adds no way around any of them and no second uploader.
- The command still refuses a real site without a person: a terminal, or the app's mark, which the app sets only
  when it was started from a terminal. Started any other way (a script, an agent's shell with no terminal) the app
  runs, scans, previews and copies, but its upload to anything except this computer is refused by the server before a
  command starts, and by the command itself (AC13).
- Agents test the upload only against `test/fixtures/wp-standin.ts` on 127.0.0.1 and never type a real password
  into the page. That stays a rule (below), not something code can prove.

### S7. The alttext.ai key

D10. Saved by the uploader's own `saveKey` (0600, the same file); judged by its own `tried`; sent only through its
own `aiFetch` gate; the API answers with `saved`, the last four characters and the credits left, never the key. The
page's key box is `type="password"`, emptied when sent.

### S8. Text from a site or a tool is text

Addresses, tool lines, notes and question words reach the page as JSON strings and the DOM as `textContent`. With
`script-src 'self'` and no inline handlers, markup in a scanned page's title or a note can't run even if a line were
ever put in as HTML (AC19; the source pin forbids the HTML sinks).

### S9. Files and commands

- No request carries a path: scans are named by ids from the server's own listing; app files come from a fixed
  list; previews from tickets.
- Children are started with an argument array (no shell), the address after the tool's name, options only from the
  table (D5), no option that names a file or holds a secret.
- `importer.json` is 0600, the previews' folder 0700 and deleted on exit.

### S10. Logs

The terminal shows only the app's start line, each job's start and end (kind, page, exit code), and refused requests
as `method path status`: never a body, a header, a query or the `#` part.

### S11. The CLAUDE.md rule lines this job changes (the finisher writes them; exact proposals)

1. "Working in this repo", the uploader rule. **Today:** "**One uploader writes to WordPress, reached by two
   commands: `npm run site:upload` and `npm run site:import`** … Both run the same code (`tools/lib/site-upload/`).
   … The Application Password is typed at the hidden prompt (`site:import` asks it before the scan and keeps it only
   in its own memory through it) and never goes in an argument, a variable, a file, the record, the capture, the
   paste, a log, a printed line or the scan's Chrome. The alttext.ai key is asked once and saved only in
   `~/.config/figma-to-bricks/alttext-key` (0600); it never goes in an argument, a variable, the record, the capture,
   the paste, a log, a printed line or Chrome, and is sent only to alttext.ai. Only Justin runs either, in his own
   terminal, against his own site. Agents never run them against his site or any live site, never ask for or hold his
   password, and test them only against `test/fixtures/wp-standin.ts` and local fixture sites."
   **Proposed (only the changed sentences; the rest of the rule stays word for word):**
   - Heading: "**One uploader writes to WordPress, reached by two commands and the importer app: `npm run
     site:upload`, `npm run site:import` and `npm run importer`** (… Justin, 2026-11-13: "a simple UI for the
     importer … plus a section where we can put the API for alt text"). All three run the same code
     (`tools/lib/site-upload/`): the app starts `site:upload` itself and has no uploader of its own."
   - Password: "The Application Password is typed at the hidden prompt (`site:import` asks it before the scan and
     keeps it only in its own memory through it), or in the app's password box, which sends it once in a request
     body to the app on 127.0.0.1, which writes it once to the upload command's input and keeps it nowhere; it never
     goes in an argument, an environment variable, an address, a file, the record, the capture, the paste, a log, a
     printed line, the page's storage or the scan's Chrome."
   - Key: "The alttext.ai key is asked once (at the prompt or in the app's key section, which shows a saved key only
     as its last four characters) and saved only in `~/.config/figma-to-bricks/alttext-key` (0600); it never goes in
     an argument, an environment variable, an address, the record, the capture, the paste, a log, a printed line or
     Chrome's storage, and is sent only to alttext.ai."
   - Who: "Only Justin runs any of them against his own site: the commands in his own terminal, the app started from
     his own terminal and used in his own browser. Agents never run them against his site or any live site, never
     ask for, hold or type his password, and test them only against `test/fixtures/wp-standin.ts`, the alttext.ai
     stand-in and local fixture sites."
2. A new line after "The website importer's helper": "**The importer app (`npm run importer`) listens on 127.0.0.1
   only and answers only its own page:** this run's key on every `/api` request, the Host and Origin checks, no CORS
   header, changes only by POST (`tools/lib/importer-app/guard.ts`). It converts and uploads nothing itself: it runs
   `capture`, `capture:check`, `site` and `site:upload` as typed and shows what they write, so a paste from the app is
   byte for byte the command line's. Its preview is a locked frame that loads nothing but Google's fonts and can't
   reach the app. The app's own process sends one kind of request off this computer: the key section's test to
   alttext.ai. A new option of those commands is added to the app in `tools/lib/importer-app/commands.ts`."
3. Unchanged, and the plan keeps to them: the helper's rule (it keeps 127.0.0.1:47811 and its pairing code), "The
   importer never hides that its Chrome is automated" (the app never starts or touches a Chrome: the commands do),
   "Every Chrome a capture starts launches through `launchCaptureChrome`", "`npm run site:live` only reads", "Setup …
   No runtime dependencies" (the app uses Node's built-ins).

### S12. Known limits (recorded, not hidden)

- The run's key is in the argument of the command that opens the browser for a moment, and in the terminal's
  scrollback: visible only to programs already running as Justin (outside the defence, S1).
- JavaScript can't wipe a string from memory: "cleared" means no reference is kept.
- A browser's own password manager and its history are the browser's (S5; the key is taken out of the address at
  once).
- The preview's `'unsafe-inline'` is deliberate and boxed (S4).

## Acceptance criteria (all proposed)

- AC1 (proposed): Given `npm run importer -- --no-open` on a free port, the app listens on 127.0.0.1 only (a connection to this computer's other addresses is refused), prints one line with its address and this run's key in the `#` part, and that address shows the page with its three steps and the build, the key gone from the address bar; a taken port stops with one line naming `--port`. Test `test/web/importer-app-start.test.ts` "the app starts on 127.0.0.1 only, prints its address with this run's key, and its page loads".
- AC2 (proposed): Given a running app, each of these is refused, starts no command and reads no scan: another Host (a rebinding name), an `/api` request without this run's key or with a wrong one, a POST with another Origin, with `Sec-Fetch-Site: cross-site`, with a form content type or a body over 16 KB, an `OPTIONS` preflight (no CORS header in any answer), a file name outside the page's list, an unknown path; and the same requests with the right Host, key and Origin are answered. Test `test/unit/importer-app-guard.test.ts` "a request from another page, another name or without this run's key is refused and starts nothing".
- AC3 (proposed): Given a local fixture site, a Scan from the page (address typed, the client's-site box ticked) runs to the end showing the tools' own lines and the time, and the scan's folder then holds the capture and the paste files, each byte for byte what `npm run site -- <that capture> <folder> [the same options]` writes, on the plain route (`media-page`) and the Elementor route (`elementor-natives`, Elementor box ticked); `importer.json` records the route; without the client's-site box the tool's own "isn't confirmed" line shows and nothing is written; a second Scan while one runs is refused. Test `test/web/importer-app-scan.test.ts` "a scan from the page writes exactly the files npm run site writes from that scan, on both routes".
- AC4 (proposed): Given an opened scan, a click on Copy header, Copy body and Copy footer puts exactly the bytes of `header.json`, `page.json` and `footer.json` on the clipboard, Copy all puts one paste that `assertPayload` accepts and equals `ascii(JSON.stringify(wholePayload([header, page, footer])))`, the page says what was copied, a missing part's button is off with its reason, and with `navigator.clipboard` refused the fallback copies the same text, and with both refused a Download link gives the same bytes. Test `test/web/importer-app-copy.test.ts` "Copy header, body, footer and all put exactly the paste files' text on the clipboard, all as one paste, and the fallback copies when the clipboard is refused".
- AC5 (proposed): Given an opened scan, the preview of the header, the body, the footer and the whole page at the four widths (the design width, 991, 767, 390) draws each part's root within 0.5 px of the same paste drawn by `renderSitePaste` alone at that width, with Bricks 2.4.2's CSS and, switched, 2.3.9's; at 390 a click on the fixture's ☰ opens its Offcanvas inside the preview; after an upload the pictures the scan holds are drawn from the scan, none requested from the library's address. Test `test/web/importer-app-preview.test.ts` "the preview draws each part and the whole page as site:check's renderer does at the four widths, and a menu opens in it".
- AC6 (proposed): Given a preview of a fixture page that holds a third-party loader, a link and a form, the frame has no origin and no storage, requests nothing from the app but its own ticket and nothing from any host but Google's fonts (not the loader, not the old site), a click on its link and a submit of its form leave the frame and the app's page where they are, a `fetch` of `/api/state` from inside it fails, a made-up ticket is 404, and the app's page can't be framed by another origin. Test `test/web/importer-app-preview-safe.test.ts` "the preview can't reach the app, another host or the old site, and a link in it goes nowhere".
- AC7 (proposed): Given a scan running from the page, Stop ends it within 10 s with the state "stopped", no process the scan started (its Chrome included) is left, no paste file and no `importer.json` is written, and a new Scan then starts; Ctrl+C in the app's terminal during a scan does the same, deletes the previews' folder and ends the app. Test `test/web/importer-app-stop.test.ts` "Stop ends the scan and every Chrome it started, writes no paste, and the app's own Ctrl+C does the same".
- AC8 (proposed): Given a scan whose command prints the capture's own waiting line for a person check, the page shows that line as a banner (`role="alert"`) and "Waiting for you" in the tab's title, takes both down when the command prints its passed line, and the app sends that command no input. Test `test/web/importer-app-person-check.test.ts` "while a scan waits for a person the page shows the tool's own line as a banner and in the tab's title, and takes it down when the check is passed".
- AC9 (proposed): Given a scans folder holding a folder the app made, a folder `site:import` made (no `importer.json`), a loose capture, a folder with no capture, a link pointing outside and a capture with a broken head, the list shows the first three newest first, each with its page, date, build, parts and route ("made by the command line: options unknown" for the second, "no pastes yet" for the third) and where its pictures sit, skips the others with one plain line each, reads only the first 4 KB of a capture, and no id resolves outside the scans folder. Test `test/unit/importer-app-scans.test.ts` "saved scans are listed with their page, date, build, parts and route, and nothing outside the scans folder is read".
- AC10 (proposed): Given a saved scan with its pastes, opening it from the list shows its facts, previews it and copies it with no job started and no Chrome launched by the app's commands; Make pastes again with another route rewrites the pastes as `npm run site` writes them for that route and the list shows the new route. Test `test/web/importer-app-saved.test.ts` "a saved scan previews and copies again with no scan started".
- AC11 (proposed): Given a saved scan and the WordPress stand-in, List pictures shows the dry run's list with no password asked and nothing sent; Log in and check with the user name and password shows the site's name, then the command's own question; an answer sent before the question shows is refused and reaches no command; `no` uploads nothing; `yes` typed after it uploads each picture once, shows the progress lines and the result, and leaves `media.json` and the pastes byte for byte what `npm run site -- <capture> <folder> --media <media.json>` writes; a wrong password shows the tool's own refusal with nothing uploaded; the next steps show without a copy command line. Test `test/web/importer-app-upload.test.ts` "an upload from the page lists, logs in, waits for a typed yes after its question, then writes exactly site:upload's files".
- AC12 (proposed): Given that upload against a stand-in that echoes its `Authorization` header, the password (plain, without spaces, URL-encoded, and base64 with the user name: `secretForms`) is in none of: any address the app was asked for, any child's arguments or environment, any API answer, any job line, the terminal's output, `importer.json`, the upload record, the capture, the pastes, `notes.txt`, the previews' folder, the page's text, `localStorage` and `sessionStorage`, or any process naming Chrome; and the password box is empty after sending. Test `test/web/importer-app-secret.test.ts` "the Application Password reaches only the upload command's input: no URL, argument, environment, file, log line, answer or page text holds it in any form".
- AC13 (proposed): Given an app started with no terminal, an upload request to a site that isn't this computer is refused before any command starts (no connection to that site) and the page's button is off with its reason, while scan, preview and copy work; `tools/site-upload.ts` run with no terminal and no mark against such a site refuses with its own line and makes no connection, and with the app's mark goes on to read the site. Test `test/unit/importer-app-person.test.ts` "only an app started from a terminal uploads to a real site: without one it refuses before any command runs, and the command refuses too".
- AC14 (proposed): Given the alttext.ai stand-in, the key section saves a key only after it tests well (file mode 0600, the uploader's own file), shows it back only as its last four characters and the credits left, refuses a key the stand-in refuses or one that isn't key-shaped without saving it, tests the saved key again, replaces it, removes it (the file is gone), and the whole key is in no API answer, job line, terminal line, page text or storage; the only host the app's own process contacts is the stand-in. Test `test/web/importer-app-key.test.ts` "the alttext.ai key is tested, saved for its owner only, replaced, tested again and removed, and is never shown back in full".
- AC15 (proposed): Given the options table, each option chosen in the page reaches exactly the commands its row names and no other, a saved scan's `importer.json` options are reused by Make pastes again and by an upload, `--no-ai-alt` is added when no key is saved or the box is off, and a request with a flag outside the table, a file-naming or secret-shaped flag, a value starting with `-`, or an address that isn't `http(s)` starts nothing. Test `test/unit/importer-app-commands.test.ts` "each option reaches the command that takes it, the sidecar's paste options are reused, and a flag the app doesn't know or that carries a secret starts nothing".
- AC16 (proposed): Given a scan whose `notes.txt` holds notes for three parts, the page shows under the preview the chosen part's notes, every line of that part in the file's order and none shortened, a part's `Structure:` line first when it has one, all three parts headed for "Whole page", where the pictures sit, and the other files of the folder by name. Test `test/web/importer-app-notes.test.ts` "each part shows its own notes from notes.txt with the Structure line first when there is one, and where its pictures sit".
- AC17 (proposed): Given `tools/site-upload.ts` run on a pipe against the stand-in, without the app's two variables its output holds no progress line and its files are byte for byte those of the run with them, and with `F2B_PROGRESS=lines` the only added lines are `Making AVIF: N of M` and `Pictures: N of M`. Test `test/web/importer-app-commands-same.test.ts` "without the app's two marks site:upload prints and writes exactly what it did before, and with the progress mark only the progress lines are added".
- AC18 (proposed): Given the page at 1280 and at 600 px wide, every control has an accessible name, all are reached with Tab in reading order with a visible focus ring, the job's step is in a polite live region and a question moves focus to its box, text contrast is at least 4.5:1 in the light and the dark scheme, and nothing scrolls sideways at 600. Test `test/web/importer-app-page.test.ts` "every control of the page has a name and is reached with Tab, a job's status is announced, and the page fits a narrow window".
- AC19 (proposed): Given markup (`<img src=x onerror=…>`, `<script>`) in a page address, a tool's line, a note and a saved scan's page name, the page shows each as text, no script of it runs and no element of it is made; and no page source holds `innerHTML`, `outerHTML`, `insertAdjacentHTML`, `document.write`, `eval` or `new Function`. Test `test/web/importer-app-text.test.ts` "markup in an address, a tool's line or a note shows as text and runs nothing".
- AC20 (proposed) (live): Justin, in his own terminal, runs `npm run importer`; in the page he scans `https://bdryswi.com/` with the Elementor box ticked (pressing "I am human" in the Chrome window if it asks); looks at the whole page at Desktop, Tablet, Phone sideways and Phone; presses Copy header and pastes it into B-Dry staging's Header template; then uploads the pictures with his own user name, Application Password and alttext.ai key (typing `yes`), and the pastes he copies after it show the library's pictures in Bricks. His own check: paste check, the next free id at the merge.

## Touched files

**New (the app):**
- `tools/importer.ts` (entry: arguments, start line, open the browser, Ctrl+C).
- `tools/lib/importer-app/server.ts` (routes, `startImporterApp`), `guard.ts` (S3), `jobs.ts` (D4), `prompts.ts`
  (the tools' questions and attention lines), `commands.ts` (D5, D1's argument lists), `scans.ts` (D6),
  `preview.ts` and `preview-child.ts` (D7), `pastes.ts` (D8), `notes.ts` (D11), `key.ts` (D10), `open.ts` (the
  browser opener by platform). Each under about 200 lines.
- `tools/lib/importer-app/page/index.html`, `app.css`, `main.ts`, `api.ts`, `views.ts`, `copy.ts`, `preview.ts`,
  `upload.ts`, `key.ts`.
- `tools/lib/site-upload/person.ts` (D2).

**Changed (existing code; D2, `<E>/seam.diff`):**
- `tools/site-upload.ts` (one condition, one import), `tools/lib/site-upload/flow.ts` (one branch, one import),
  `tools/lib/site-upload/prepare.ts` (one line, one import), `tools/lib/site-upload/ai-key.ts` (`export` on `tried`
  and `Tried`).
- `package.json`: `"importer": "node --disable-warning=ExperimentalWarning tools/importer.ts"`.
- `docs/HANDOFF.md`, the plan and ledger under `docs/plans/`; after the merge `src/shared/build.ts` and CLAUDE.md
  (finisher).

**New tests and fixtures:**
- `test/fixtures/importer-app.ts`: `startApp(o)` (the app as a child with `--no-open --port 0`, a temp scans folder
  and HOME, the address read from its start line; `F2B_ALTTEXT_API`, `encoderEnv()` and `importEnv` passed on),
  `openApp(app)` (the tests' Chrome with every host but 127.0.0.1 unresolvable, `test/fixtures/web/offline.ts`),
  `api(app, method, path, body, headers)`, `savedScan(dir, fixture, flags)` (a capture and pastes made by the real
  tools, cached per test file), `stubRepo(scripts)` (a temp folder whose `tools/*.ts` are the given stubs, for AC8).
- `test/unit/importer-app-guard.test.ts`, `-scans.test.ts`, `-person.test.ts`, `-commands.test.ts`, and supporting
  `-prompts.test.ts` (each known question and the unknown one; `waitingLine`/`passedLine`), `-notes.test.ts`
  (splitting), `-page-sources.test.ts` (the sink pin; each page module strips to JavaScript).
- `test/web/importer-app-start.test.ts`, `-scan`, `-copy`, `-preview`, `-preview-safe`, `-stop`, `-person-check`,
  `-saved`, `-upload`, `-secret`, `-key`, `-notes`, `-commands-same`, `-page`, `-text`.

**Not touched:** everything under `src/` (so the Figma plugin, `npm run replay`, the corpus and every paste are byte
for byte as before by construction), `tools/site.ts`, `tools/capture.ts`, `tools/site-import.ts`,
`tools/lib/site-write.ts`, `tools/lib/site-import/*`, `test/web/lib/site-check.ts`, `test/browser/render.ts`.

## Tasks

Every task is test first (`test-driven-development`): the named test red for the stated reason, then the code, then
green, then a commit of exactly those files. Chrome tests on the desktop run with
`CHROME_PATH=$HOME/.cache/chrome-for-testing/chrome-f2b` and a short `TMPDIR` (38 characters at most); a command that
dies with exit 137 or 143 is checked against the earlyoom log before it is read as a result. No test loads a live
site, and none uses Justin's scan: fixtures only (`media-page`, `elementor-natives`, `site-menu`, `live-widget`,
`challenge`).

**Milestone 0: records and the base's receipts**
1. Copy this plan to `docs/plans/2026-11-13-importer-app.md`; start the ledger
   (`.superpowers/sdd/2026-11-13-importer-app/progress.md`). Read `figma-to-bricks/references/repeat-mistakes.md` and
   `feature-dispatch/references/repeat-mistakes.md`. Note the base (`git log --oneline -1 main`).
2. On the base, before any change, tallies into the ledger: `npm run check`; `npm run corpus` (on the desktop the
   repo's corpus copies, memory `corpus-paths-on-desktop`);
   `node --test "test/unit/site-upload-*.test.ts" "test/unit/site-import-*.test.ts"` (on `7f54b0a5`: 74 tests, 71
   pass, 0 fail, 3 skipped); `node --test --test-concurrency=1 test/web/site-upload-secrets.test.ts test/web/site-upload-page.test.ts`
   (2 pass) and every other `test/web/site-upload-*` and `test/web/site-import-*` file by name.

**Milestone 1: the seam (D2)**
3. Write `test/web/importer-app-commands-same.test.ts` and the command half of
   `test/unit/importer-app-person.test.ts` (`personAsks`, `progressLines` as pure functions; `tools/site-upload.ts`
   run on a pipe against `https://127.0.0.2:<a listening port>` with and without the mark, counting connections, as
   `<E>/scripts/flow-proto.ts` does). Red: `person.ts` doesn't exist; no progress line on a pipe.
4. Apply `<E>/seam.diff` and the two `export`s in `ai-key.ts`. Green; step 2's suites again, same tallies;
   `npm run typecheck`.

**Milestone 2: the server's core**
5. `test/unit/importer-app-guard.test.ts` over a pure `judge(req: { method, path, headers }, o: { port, token }): { ok: true } | { status: number }`
   and over a started app with hand-made requests (`node:http`, any Host and Origin). Red: no module. Then
   `guard.ts` (S3). Green.
6. `test/web/importer-app-start.test.ts`. Red. Then `server.ts` (the shell, the app files through
   `stripTypeScriptTypes`, `GET /api/state`, the headers of S3.5), `open.ts`, `tools/importer.ts`, the `package.json`
   line, `page/index.html`, `app.css`, `main.ts`, `api.ts` (the key from `location.hash` to `sessionStorage`, the
   header on every call, the "paste the address" box). Green.

**Milestone 3: commands, jobs and scans**
7. `test/unit/importer-app-commands.test.ts`. Red. Then `commands.ts` (D5; D1's lists). Green.
8. `test/unit/importer-app-prompts.test.ts` (supporting): each known question by the tools' exported words, the
   unknown one after 2 s, `waitingLine` and `passedLine`. Then `prompts.ts`.
9. `jobs.ts` against stub commands (`stubRepo`): lines, steps, one job at a time, an answer only to the open
   question, the password written once and cleared, Stop by group, the chain stopping at the first failure.
   `test/web/importer-app-person-check.test.ts` and `test/web/importer-app-stop.test.ts` red, then green with the
   scan route and the page's job panel (`views.ts`).
10. `test/unit/importer-app-scans.test.ts`. Red. Then `scans.ts` (the list, ids, the head read, `importer.json`).
    Green.
11. `test/web/importer-app-scan.test.ts`. Red. Then `POST /api/scan`, the scan form (address, Elementor, the
    client's-site box, More options from the table), the list. Green on both routes.

**Milestone 4: copy, notes, saved scans**
12. `test/web/importer-app-copy.test.ts`. Red. Then `pastes.ts`, `page/copy.ts` (the three steps of D8; the test
    turns `navigator.clipboard` off through a Chrome permission and a stub to reach each fallback). Green.
13. `test/unit/importer-app-notes.test.ts` (supporting) and `test/web/importer-app-notes.test.ts`. Red. Then
    `notes.ts` and the notes view. Green.
14. `test/web/importer-app-text.test.ts` and `test/unit/importer-app-page-sources.test.ts`. They should pass as soon
    as written if tasks 6 to 13 kept to D12; if not, fix the sink, never the test. Prove the web test can fail: put
    one `innerHTML` in a scratch copy of `views.ts`, see it fail, drop the copy.
15. `test/web/importer-app-saved.test.ts` (opening and copying; its preview half goes green in task 17). Then
    `POST /api/scans/<id>/pastes` and "Make pastes again".

**Milestone 5: the preview**
16. `preview-child.ts`, test first on a hand-built payload and media map (the library address in `image.url`,
    `image.full`, a `_background` image and a class's custom CSS each mapped back; one with no bytes stood in), as
    `<E>/scripts/media-proto.ts` does.
17. `test/web/importer-app-preview.test.ts` and `test/web/importer-app-preview-safe.test.ts`. Red. Then `preview.ts`
    (tickets, the cache, S4's header, the guard script), `page/preview.ts` (the frame, the four widths, the scale, the
    Bricks switch). The sandboxed frame is its own Chrome target (it isn't in `Page.getFrameTree`): the tests attach
    to it through `Target.getTargets`, or open the ticket at top level in a window of that width, and read the
    guard's size message; `<E>/scripts/sandbox-proto.ts` shows both. Green; task 15's test green.

**Milestone 6: the upload**
18. `test/web/importer-app-upload.test.ts`. Red. Then `POST /api/scans/<id>/upload`, `POST /api/job/answer`,
    `page/upload.ts` (D9), `importer.json`'s `upload`, the next steps. Green.
19. `test/web/importer-app-secret.test.ts` (built on `secretForms`, `namedSecretForms`, `processesNaming`,
    `filesIn`, the stand-in's `echoAuth`). It must pass on task 18's code; prove it can fail three ways in scratch
    copies: the `Scrubber` not told the password, the field not cleared, the password added to the arguments.
20. The app half of `test/unit/importer-app-person.test.ts`. Red, then the `person` refusal in the route and the
    page's button state. Green.

**Milestone 7: the key section**
21. `test/web/importer-app-key.test.ts` (the alttext.ai stand-in through `F2B_ALTTEXT_API`). Red. Then `key.ts`,
    the three routes, `page/key.ts`. Green.

**Milestone 8: the page's quality**
22. `test/web/importer-app-page.test.ts`. Red where a name, an order or a contrast fails. Then the fixes; the empty,
    running, waiting, failed, stopped and done states each read once aloud in the ledger (one line each).
23. One screenshot per criterion into `<evidence>/builder/shots/` (the page in the tests' Chrome at 1280; a terminal
    capture for the ones with nothing to see: the 2nd, 9th, 13th, 15th and 17th).

**Milestone 9: close**
24. Mutation checks on the guards (`mutation-testing-discipline`; each run under
    `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`), one at a time in scratch copies, each must turn
    its test red: the Host check, the key check, the Origin check, the `Sec-Fetch-Site` check, the content-type
    check, the body limit (the 2nd criterion's test); the early-answer refusal (the 11th); the `person` refusal (the
    13th); the frame's `sandbox` attribute and the preview's `sandbox` header, one each (the 6th); the real-path
    check of a scan's folder (the 9th); the refusal of a flag outside the table (the 15th). A survivor is a missing
    assertion: add it, never weaken the mutant.
25. `npm run check`; `npm run corpus`; every new test by name; step 2's suites again (same tallies by test name).
    Ledger closed; stop at `ready-for-review`.

## Overlaps and order

- **Base.** Planned and measured on main `7f54b0a5`. The app reads other jobs' work only through the commands and
  the files they write, so it can be built now and rebased over whatever merges first. site-no-div merges next
  (Build 2026-11-12.4): it changes `tools/site.ts`'s output (the `Structure:` line first in `notes.txt`,
  `structure.txt`), which the app shows as written; nothing to merge by hand.
- **Shared files, all four with a one-line change here:**
  - `tools/site-upload.ts`: short-class-names (new options), site-shared-styles and shared-palette (their options)
    edit the argument handling; this job edits the terminal check on line 39. Different lines; on a conflict keep
    both.
  - `tools/lib/site-upload/flow.ts`: short-class-names, clean-values and site-shared-styles edit what is written
    after the upload; this job adds one branch to `onProgress`. Keep both.
  - `tools/lib/site-upload/prepare.ts`, `tools/lib/site-upload/ai-key.ts`: no other job in flight names them.
- **Not shared.** `tools/lib/site-import/next.ts` (site-shared-styles gives `nextSteps` a fourth argument,
  `o: { palette }`, and new words): the app calls it and never edits it; whichever lands second adds the argument at
  the app's one call (`server.ts`). `tools/lib/site-write.ts`, `args.ts`, `after-scan.ts`: read by nobody here.
- **Options of jobs in flight.** When short-class-names, clean-values, shared-palette or site-shared-styles merges
  after this job, its finisher adds its options to `tools/lib/importer-app/commands.ts` (one row each, D5) and its
  new files appear under "Also in this folder" by themselves. When this job merges after them, task 7 adds those
  rows (the builder reads each command's usage line on the base it builds on and lists in the ledger every option it
  left out, with the reason).
- **Paste check id.** `3ej` is already named by another plan in flight: the finisher takes the next free id at the
  merge (main's HANDOFF, every local branch's and the plans folder).
- **Order.** Any; no job waits for this one and this one waits for none.

## Risks and known limits

1. **`stripTypeScriptTypes` is marked experimental in Node 22.** It works on 22.23.3 and the repo already depends on
   Node's type stripping for every tool and test. If a Node update drops it, `server.ts` has one function to change
   (esbuild's `transform`, already a dev dependency, gives the same text). The unit pin strips every page module.
2. **Safari's clipboard on `http://127.0.0.1`** wasn't tested (no Mac here): the fallback and the Download link
   cover it; the live check says which path his browser took (the page names it: "Copied" or "Downloaded").
3. **Opening the browser from WSL** (`cmd.exe /c start`) may drop the `#` part: the page then asks for the address
   the terminal printed. Not proven either way here; both paths are tested (task 6).
4. **The preview isn't Bricks.** It is the renderer the importer's receipts use; the live widgets are empty boxes
   (Q2 A); a font with no file in the scan falls back. The page says so in one line; the paste check stays owed.
5. **A big page's drawing is big** (B-Dry: 33.6 MB of HTML, pictures as data, about 0.2 s to make): one file per part
   and Bricks version in a temp folder, deleted on exit. If a page ever takes seconds, the frame shows "Drawing…".
6. **The person check in a scan started by the app** is the command's own (a visible Chrome on the desktop needs
   WSLg, as today). The criterion's test uses a stub command for the banner; the real thing is in the live check.
7. **The terminal check is now a terminal or the app's mark** (D2): no weaker against a deliberate script than
   before (a pseudo-terminal passed), and the app itself refuses without a terminal.
8. **One job at a time** means a long scan blocks an upload of another scan until it ends or is stopped (Q5 A).
9. **Follow-ups, not built:** a scan's screenshots beside the preview; scanning several pages of a sitemap from the
   page (`--list`, `--all`); `site:live` from the page; drag a capture file onto the page; the Figma plugin's debug
   files.

## Docs & records

1. The plan copied to `docs/plans/2026-11-13-importer-app.md`; the ledger moved by the finisher to
   `docs/plans/2026-11-13-importer-app-ledger.md` before the final premerge commit and rebase.
2. `docs/HANDOFF.md`: a new section above the previous top heading ("The importer app"): how to start it and what
   each part of the screen does, in numbered plain steps; D1's table; the security rules S2 to S10 in short; Q1 to Q9
   and the builder's rulings as "not yet confirmed"; the limits and follow-ups above; the paste check owed for the
   live criterion (the next free id) with its entry at the top of "End-of-run check list".
3. `BUILD` bumped at the merge (never in the copy).
4. Main `CLAUDE.md` after the merge: the Status line (build, one line for this job with its paste check); the two
   rule changes of Security S11, word for word; in "Debugging a user's design" nothing. If writing it is refused:
   exactly those lines in `~/.hermes/plans/figma-to-bricks/importer-app-claude-md-pending.md`.
5. Proposed line for `figma-to-bricks/references/rules-summary.md` (the finisher returns it; the main session
   saves it): "Importer app (`npm run importer`): 127.0.0.1 only, per-run key + Host/Origin checks, runs the
   commands as typed (pastes byte for byte), preview in a locked frame; a new command option goes in
   `tools/lib/importer-app/commands.ts`."
6. Memory proposals for the main session (agents don't write memory): `importer-test-steps` gains "or `npm run
   importer`"; `importer-media-upload` gains "also from the app's step 3, started from his own terminal".

## Reporting (the builder's and every later role's report)

Status, the head, each criterion with its test's result, the tallies against the base by test name, rulings made
while building, `skill_lessons[{skill, lesson, evidence, enforce}]`, ending with
`MAIN SESSION: check and save these skill_lessons now.` Reviewers and auditors also answer: "would a Bricks pro
find this logical and easy to change?" (for this job: does the app show the paste and its notes whole and unchanged)
and "could another page, the scanned site or a script make the app upload or give up a secret?".
