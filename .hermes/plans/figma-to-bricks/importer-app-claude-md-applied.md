# importer-app: CLAUDE.md lines owed after the merge (plan Security S11, word for word)

The builder doesn't edit CLAUDE.md (brief). The finisher writes these into the main folder's `CLAUDE.md` after the
merge; if writing it is refused, they stay here. Source: `docs/plans/2026-11-13-importer-app.md` "S11. The CLAUDE.md
rule lines this job changes".

## 1. Status (the build line and one line for the job; build and paste check id set at the merge)

- **<BUILD> importer-app (website importer):** `npm run importer` opens a page on 127.0.0.1 (this run's key in the
  address, the Host/Origin checks, changes only by POST) that runs `capture`, `capture:check`, `site` and `site:upload`
  as typed and shows what they write (pastes byte for byte the command line's): Scan a page (the client's-site box,
  Elementor, More options), the saved scans of `~/Downloads` newest first, the drawing of header, body, footer or the
  whole page at the four widths in a locked frame (Bricks 2.4.2 or 2.3.9), Copy header/body/footer/all, the notes,
  Make pastes again, Pictures to WordPress (List pictures; Log in and check, the password sent once to the upload's
  own prompt, the typed yes after its question; started without a terminal, only to this computer), the alttext.ai key
  (saved only after it tests well, shown by its last four). Q1–Q9 ⭐ not yet confirmed. Paste check **<id>** (AC20,
  live: his own run of `npm run importer`, scan bdryswi.com with Elementor ticked, look at the four widths, Copy header
  into B-Dry staging's Header template, upload with his user name, Application Password and alttext.ai key, typing
  yes; the pastes copied after it show the library's pictures).

## 2. "Working in this repo", the uploader rule (only the changed sentences; the rest stays word for word)

- Heading: "**One uploader writes to WordPress, reached by two commands and the importer app: `npm run
  site:upload`, `npm run site:import` and `npm run importer`** (… Justin, 2026-11-13: "a simple UI for the
  importer … plus a section where we can put the API for alt text"). All three run the same code
  (`tools/lib/site-upload/`): the app starts `site:upload` itself and has no uploader of its own."
- Password: "The Application Password is typed at the hidden prompt (`site:import` asks it before the scan and
  keeps it only in its own memory through it), or in the app's password box, which sends it once in a request
  body to the app on 127.0.0.1, which writes it once to the upload command's input and holds it only in its own
  memory, never on disk; it never goes in an argument, a shell or environment variable, an address, a file, the
  record, the capture, the paste, a log, a printed line, the page's storage or the scan's Chrome."
- Key: "The alttext.ai key is asked once (at the prompt or in the app's key section, which shows a saved key only
  as its last four characters) and saved only in `~/.config/figma-to-bricks/alttext-key` (0600); it never goes in
  an argument, a shell or environment variable, an address, the record, the capture, the paste, a log, a printed
  line, a Chrome the tools start, or the page's storage, and is sent only to alttext.ai."
- Who: "Only Justin runs any of them against his own site: the commands in his own terminal, the app started from
  his own terminal and used in his own browser. Agents never run them against his site or any live site, never
  ask for, hold or type his password, and test them only against `test/fixtures/wp-standin.ts`, the alttext.ai
  stand-in and local fixture sites."

## 3. A new line after "The website importer's helper"

"**The importer app (`npm run importer`) listens on 127.0.0.1 only and answers only its own page:** this run's key on
every `/api` request, the Host and Origin checks, no CORS header, changes only by POST
(`tools/lib/importer-app/guard.ts`). It converts and uploads nothing itself: it runs `capture`, `capture:check`, `site`
and `site:upload` as typed and shows what they write, so a paste from the app is byte for byte the command line's. Its
preview is a locked frame that loads nothing but Google's fonts and can't reach the app. The app's own process sends
one kind of request off this computer: the key section's test to alttext.ai. A new option of those commands is added
to the app in `tools/lib/importer-app/commands.ts`."

## 4. Unchanged (the plan keeps to them)

The helper's rule (127.0.0.1:47811 and its pairing code), "The importer never hides that its Chrome is automated" (the
app never starts or touches a Chrome: the commands do), "Every Chrome a capture starts launches through
`launchCaptureChrome`", "`npm run site:live` only reads", "Setup … No runtime dependencies" (the app uses Node's
built-ins).
