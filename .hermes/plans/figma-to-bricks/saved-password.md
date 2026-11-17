# saved-password: the WordPress Application Password is saved, so it isn't typed again

Planner: Fable 5.2 high, 2026-11-16. Base: `main` = c8f73363; checked again on 22d71de4 (Build 2026-11-16.7, one
commit later: none of the files this job touches changed). Full pipeline, website importer. Plan only: nothing in
the repo was changed. The builder's copy of this plan goes in `docs/plans/2026-11-16-saved-password.md`. Evidence:
`~/.hermes/plans/figma-to-bricks/evidence/saved-password/planner/` (list at the end).

## Questions for Justin (⭐ = what the builder takes unless you say otherwise)

- **Q1. Where is it saved?**
  - ⭐ A. In one file only you can read, `~/.config/figma-to-bricks/site-passwords.json`, beside the alttext.ai
    key's file and protected the same way. The same code on the desktop and the Mac. The password sits in that file
    as plain text.
  - B. The system keyring. This desktop has none (WSL Ubuntu: no `secret-tool`, no keyring service on the session
    bus; probe in `keyring-probe.txt`), so it would still be a file here; only the Mac has one (Keychain). Two ways to
    build and test, and the Mac's can't be tested from this desktop.
- **Q2. One saved password per site and user name?**
  - ⭐ A. Yes: one entry for each WordPress site and user name. B-Dry staging's is never used for, or sent to,
    darksalmon or any other address.
  - B. One password for everything (wrong as soon as there are two sites).
- **Q3. Saved without asking?**
  - ⭐ A. Yes: the first time WordPress accepts the login it is saved, and one line says where and how to forget it
    (as the alttext.ai key: "Ask once, save it").
  - B. Ask "Save it on this computer?" each time a new password was typed (the app: a ticked box "Remember on this
    computer").
- **Q4. How do you forget it?**
  - ⭐ A. A **Forget** button in the app beside "saved (ends in WXYZ)", and `--forget-password` on the command line.
    Forgetting only removes it from this computer: it still works in WordPress until you revoke it there (Users →
    Profile → Application Passwords).
  - B. Only by deleting the file.
- **Q5. The user name too?**
  - ⭐ A. On the command line, when exactly one login is saved for the site and you gave no `--user`, that name is
    used and said, and no user name is asked (`--user <name>` logs in as someone else). The app keeps filling its
    user name box as today.
  - B. The command line always asks the user name.
- **Q6. A saved password WordPress refuses (revoked, changed)?**
  - ⭐ A. The run says so and asks once at the usual prompt. The one you type replaces the saved one as soon as
    WordPress accepts it. Until then the old entry stays in the file (a security plugin's passing refusal doesn't
    throw your password away).
  - B. A refused saved password is deleted at once.

One thing to know before you say go (not a choice, the price of what was asked): see "Risks" 1 and 2. In short: today
nobody and no program can upload to your site without you typing the password. Once it is saved, any program that
runs as you on that computer can read the file, and that password has your WordPress user's full rights (an
Administrator's on B-Dry staging), not only Media.

## Playback

1. You asked (2026-11-16): "Make it that the importer, the application password for photos is saved and doesn't
   need to be re-entered."
2. Today every "Log in and check" in the importer app, and every `site:upload` or `site:import`, asks for the
   Application Password again.
3. After this job you type it once for a site and user name. The next upload to that site asks only the typed
   **yes**. Forget removes it; a revoked one is asked again once.
4. This replaces your 2026-11-10 ruling (site-media-upload Q2 A: "the password at a hidden prompt each run, never
   saved"). Every other place the password may never go stays forbidden, and the tests prove it.

What it lets you do at the end: run "Pictures to WordPress" twice on B-Dry staging; the second time no password is
asked (paste check **3fk**).

## How the password is handled today (c8f73363)

- **The prompt.** `tools/lib/site-upload/flow.ts:129-150` `logIn`: reads the site's public index with no password
  (`guard.ts` `readIndex`), asks the user name (`--user` skips that), asks the password at the hidden prompt
  (`ask.ts:84-112` `hidden`: raw mode, nothing echoed; "Nothing is stored", `ask.ts:4`), adds it to the run's
  scrubber (`scrub.ts` `Scrubber.add`: as typed, without spaces, the Basic base64 forms, URL-encoded), and tests it
  with one read (`src/ui/wordpress.ts:86` `testConnection`, `GET wp/v2/users/me`). A refusal is one line, exit 2. The
  password lives only in the `wp` object in that process's memory (`flow.ts:135-136`).
- **Only the typed site.** `guard.ts` `guardFetch`: every request goes to the typed site's origin, no redirect
  followed. `siteOf`: https only (plain http for 127.0.0.1 alone), no login inside the address.
- **site:upload** (`tools/site-upload.ts:61`) and **site:import** (`tools/site-import.ts:51`, before the scan) call
  that one `logIn`. A dry run asks nothing. With no terminal only 127.0.0.1 is accepted (`person.ts` `personAsks`).
  The typed yes follows (`site-upload.ts:76-77`, `site-import/after-scan.ts:50-51`).
- **The app.** The page's password box (`page/index.html:81-82`) is sent once in the body of
  `POST /api/scans/<id>/upload` and emptied (`page/upload.ts:42-45`, `:56`); `routes.ts:139-143` requires it;
  `jobs.ts:58-61` `Job.login` holds it and adds it to the job's scrubber; `jobs.ts:118-122` writes it once when the
  command shows `PASSWORD_PROMPT` and clears the field in the same tick. The app has no uploader of its own.
- **What is saved today, and how.** The alttext.ai key: `ai-key.ts` `readKey`/`saveKey`
  (`~/.config/figma-to-bricks/alttext-key`, 0600, a plain file only, made 0600 if others could read it, a new file
  renamed over the old), saved only after alttext.ai accepts it (`ai-key.ts:84-87`, the app's `key.ts` `saveTested`),
  shown by its last four (`key.ts:21-26` `keyView`), Remove deletes the file. The upload record
  (`record.ts`, `site-uploads.json`, 0600) holds no password.
- **Tests that prove "nowhere".** `test/unit/site-upload-cli.test.ts` AC8, `test/unit/site-upload-scrub.test.ts`,
  `test/web/site-upload-secrets.test.ts` (which already lets the key's own file hold the key: lines 102 and 106),
  `test/web/site-import-secret.test.ts`, `test/web/importer-app-secret.test.ts`.

## What each computer has for a keyring (Q1)

- **This desktop (WSL Ubuntu, probed, `keyring-probe.txt`):** a D-Bus session bus exists, but nothing on it answers
  as `org.freedesktop.secrets` (none running, none activatable); `secret-tool`, `gnome-keyring-daemon`, `keyctl`,
  `pass` are not installed (only the libsecret library). A keyring here means installing and unlocking a keyring
  daemon in WSL with no desktop session: a new dependency, and a locked keyring at every start.
- **The Mac (known, not probed from here):** Keychain through the `security` command, already on every Mac. Writing
  through it without the password in an argument needs `security -i` fed on its input; reading prints it on the
  command's output. It protects a file copied off the disk; it does not stop a program running as you, since the
  program can call `security` too once access is allowed.
- **Picked (⭐ Q1 A):** the 0600 file on both. No new runtime dependency (Node built-ins only, as the project rule
  says), one code path, fully testable against the stand-in, and the same protection the alttext.ai key has today.

## The proposal

Prototyped on a copy of c8f73363 (`proto/saved-login.ts`, `proto/tools.diff`): the probe
`probe-saved.test.ts` fails on the base by assertion ("the first accepted login is saved") and passes on the
prototype (`probe-base.log`, `probe-proto.log`).

**D1. The file.** `~/.config/figma-to-bricks/site-passwords.json`, mode 0600, its folder made 0700 when new:
`{ "version": 1, "logins": { "<site key>": { "<user name>": { "password": "<as typed>", "savedAt": "<ISO time>" } } } }`.
The site key is the upload record's (`src/ui/settings.ts` `siteKey`: the site's address, lower case). New module
`tools/lib/site-upload/saved-login.ts` (the prototype's file, whole): `passwordsFile(home)`, `SavedLogins`
(`problem()`, `users(site)`, `get(site, user)`, `save(site, user, password)`, `forget(site, user?)`), `endsIn`,
`savedView`, `validPassword`. Rules:
- Read fresh at every call (the commands and the app share it); written whole as a new 0600 file renamed over it; the
  file is removed when its last entry goes.
- A file that is a link or a folder, belongs to another user, isn't JSON or isn't version 1 is **never read into a
  login and never written over**: the run says one line naming why, asks as with nothing saved, and saves nothing.
- A file others could read is made 0600 when read.
- A password is kept as typed, one line, at most 4096 characters, no control character.
- Shown only by `endsIn`: the last four characters without spaces, and nothing at all for a password under 12
  characters (four of a short one would be most of it).

**D2. The login** (`flow.ts` `logIn(site, ask, user, out, o: { saved?: SavedLogins; fresh?: boolean } = {})`, the
prototype's code):
1. The site's index is read with no password, as today.
2. The user name: `--user`, else the one saved name for this site (said: "Logging in as <name>: the user name saved
   on this computer for this site (--user <name> logs in as someone else)."), else asked as today.
3. With a saved password for this site and user name (and no `--new-password`): it goes into the scrubber first,
   one line says "Using the Application Password saved on this computer for <name> (it ends in WXYZ).
   --new-password replaces it; --forget-password forgets it.", and it is tested with the same one read.
   - Accepted: the run goes on; nothing was asked.
   - WordPress's own refusal (HTTP 401): "WordPress refused the Application Password saved on this computer for
     <name> (it may have been revoked in WordPress → Users → Profile): type the one to use now." and step 4, once.
   - Anything else (the site down, a redirect, a user who can't upload): today's "Couldn't log in: …", exit 2, no
     prompt, the file untouched.
4. The hidden prompt, exactly today's words. Refused: "Couldn't log in: …", exit 2, nothing saved, the file as it
   was. Accepted: saved, and one line: "Saved on this computer in <file> (only you can read it): the Application
   Password for <name> on <site> won't be asked again. --new-password replaces it; --forget-password forgets it."
5. **A caller that passes no `saved` reads and writes no file and asks as today.** Only `tools/site-upload.ts` and
   `tools/site-import.ts` pass `new SavedLogins()`. Two unit tests call `logIn` in their own process
   (`test/unit/site-import-gate.test.ts:100`, `site-upload-forms.test.ts:192`): with a default store they would write
   the tests' made-up password into the developer's real `~/.config`.

**D3. The flags** (both commands; new `tools/lib/site-upload/password-flags.ts`, used by both `args.ts`):
- `--new-password`: the saved one isn't read; the prompt asks; the typed one replaces it once WordPress accepts it.
  With `--dry-run` it is refused (a dry run asks no password).
- `--forget-password`: an action of its own, `npm run site:upload -- --forget-password <https://your-site>
  [--user <name>]` (the same on `site:import`). It removes that site's saved login (every user name's without
  `--user`), sends nothing, reads nothing else, exits 0, and says which names were forgotten, or that none was
  saved, and "It still works in WordPress until you revoke it there (Users → Profile → Application Passwords)."
  Any other word or flag beside it: exit 2 with the usage, nothing forgotten.
- A dry run reads no saved file. `flagHint`'s words stay.

**D4. The app** (no uploader of its own, as today: the command reads and saves the password itself):
- `server.ts` `Ctx.passwords`: the file's path (`passwordsFile(env.HOME || homedir())`, as `keyFile`).
- `routes.ts`: `POST /api/password/look` `{ site, user }` → `{ saved, ends }` and `POST /api/password/forget`
  `{ site, user }` → `{ saved: false, ends: null, line }`. Never the password. Both behind the app's guard like every
  `/api` route; a site that isn't an address or a user name that isn't one line → 400 repeating no value; no terminal
  and a site that isn't this computer → 403 (today's `NOT_HERE`).
- `startUpload`: the request's `password` may be absent only when one is saved for that site and user name (else
  today's 400 "Type your Application Password"). Absent: the job is told the saved one for its scrubber only (new
  `Job.knows(user, password)`: `scrub.add`, nothing held for a prompt), and the command reads the file itself.
  Present (none saved, or Replace): `job.login` as today and the command gets `--new-password`
  (`commands.ts` `uploadArgs`, `chains.ts` `UploadPlan.newPassword`), so the typed one is asked for, tested and saved.
- A saved password WordPress refuses: the command's refusal line, then its password prompt, which the job panel asks
  as a masked question (`knownQuestion` already calls `PASSWORD_PROMPT` a secret), once.
- The page (`page/index.html` step 3, new `page/password.ts`, `page/upload.ts`): when one is saved for the site and
  user name in the boxes, the password box gives way to "Application Password: saved on this computer (ends in
  WXYZ)" with **Replace** (the box again; the typed one replaces the saved one once WordPress accepts it) and
  **Forget**. It asks `/api/password/look` when the site or user name box changes (300 ms after the last key), when
  a scan is opened and when a job ends. The page keeps nothing new: no password in its text, boxes, `localStorage`
  or `sessionStorage`; with one saved, the upload request's body holds no password at all.

**D5. What stays exactly as it is.** The typed `yes` after everything found is shown (no flag skips it; a saved
password never does). Only the typed site's origin gets any request, with no redirect followed. A run with no
terminal uploads only to 127.0.0.1. The record, the capture, the pastes, `media.json`, `importer.json`, logs and
printed lines hold no password. The pastes: byte for byte what they are today (this job changes no conversion; the
Bricks-pro standard isn't touched).

## Acceptance criteria (all proposed)

Every test runs offline against `test/fixtures/wp-standin.ts` on 127.0.0.1 with a HOME of its own and the made-up
login of `test/fixtures/site-import.ts`. A test that expects no password prompt ends the run the moment one shows
(`runTool`'s `watch`), so it fails on the base by assertion, never by a hang.

- AC1 (proposed): With nothing saved, `site:upload` shows today's three questions in today's order and words (user name, Application Password, the yes question), and once WordPress accepts the login `~/.config/figma-to-bricks/site-passwords.json` exists with mode 0600 holding exactly one entry, under that site's address and that user name, with the password as typed; one new line names the file. Test: `test/unit/site-upload-saved-password.test.ts` "AC1 the first login WordPress accepts is saved for that site and user name in a file only its owner can read".
- AC2 (proposed): A second `site:upload` to the same site with the same HOME asks no user name and no password, says it uses the saved password naming only its last four characters, and still uploads only after a typed `yes`: with `no` typed it exits 2 and the stand-in got no POST. Test: `test/unit/site-upload-saved-password.test.ts` "AC2 a second run asks no user name and no password and uploads only after a typed yes".
- AC3 (proposed): With nothing saved, a run asks, sends and writes as on main: against the base tree, the same capture and a fresh HOME each, the head's output is the base's but for the one "Saved on this computer" line, the stand-in's requests are the same (method, path, query, body), and the files written are the same but for `site-passwords.json`. Test (named only, `F2B_STORY_PINS=1 F2B_BASE_TREE=<main>`): `test/unit/site-upload-saved-password.test.ts` "AC3 with nothing saved a run asks, sends and writes as on main but for the saved line and the saved file".
- AC4 (proposed): A login WordPress doesn't accept is never saved: a wrong password, a user who can't upload media, and a site answering HTTP 500 each end with exit 2 and no `site-passwords.json`; with one already saved, the file is byte for byte as it was. Test: `test/unit/site-upload-saved-password.test.ts` "AC4 a login WordPress does not accept is never saved".
- AC5 (proposed): A password saved for one site and user name is never used for, or sent to, another: with site A's saved, a run against site B (another stand-in) asks for B's password and B's request log holds no Authorization but the one typed for B; a run against A with `--user` naming a second user asks that user's password; the file then holds three entries and each stand-in only ever got its own. Test: `test/unit/site-upload-saved-password.test.ts` "AC5 a password saved for one site and user name is never used for or sent to another".
- AC6 (proposed): A saved password WordPress refuses (the stand-in's user given a new one) is said in one line and asked for once at the usual prompt: the right one typed is accepted and replaces the saved one (the old one is in the file no more, and exactly one request carried it); a wrong one typed ends with exit 2, no second question and the file as it was; with the site answering HTTP 500 or a redirect instead, the run ends with "Couldn't log in", asks nothing and leaves the file as it was. Test: `test/unit/site-upload-saved-password.test.ts` "AC6 a saved password WordPress refuses is asked for once and the accepted one replaces it".
- AC7 (proposed): `--new-password` asks at the prompt though one is saved; the typed one replaces the saved one only once WordPress accepts it (a wrong one: exit 2, the saved one stays); `--new-password --dry-run` exits 2 before anything is read or asked. Test: `test/unit/site-upload-saved-password.test.ts` "AC7 --new-password asks again and replaces the saved password only once WordPress accepts the new one".
- AC8 (proposed): `site:upload -- --forget-password <site> --user <name>` removes that one entry, without `--user` every entry of that site and no other site's, sends no request (the stand-in's log is unchanged), exits 0 and says what it forgot or that nothing was saved; the next run asks for the password again; the file goes with its last entry; any other word or flag beside it exits 2 and forgets nothing; `site:import -- --forget-password` does the same. Test: `test/unit/site-upload-saved-password.test.ts` "AC8 --forget-password forgets one site's saved password, sends nothing, and the next run asks again".
- AC9 (proposed): The saved file is only its owner's and only this tool's: a link, a folder, text that isn't JSON, another version or shape make the run say one line naming why, ask as with nothing saved, save nothing and leave that file byte for byte; a file others could read is 0600 after a read; a save leaves no temp file; a user name such as `__proto__` is kept as a name; `endsIn` gives the last four characters without spaces and nothing for a password under 12 characters. Test: `test/unit/saved-login.test.ts` "AC9 the saved file is only its owner's, never read or written over when it is not this tool's, and a password shows only by its last four".
- AC10 (proposed): `logIn` called with no saved logins (as the tests that call it in their own process do) reads and writes no file under HOME and asks as today, though the same login is accepted. Test: `test/unit/saved-login.test.ts` "AC10 a caller that passes no saved logins reads and writes no file".
- AC11 (proposed): `site:import` asks the password before the scan as today and saves it as soon as the login is accepted (it is in the file while the scan runs); a second `site:import` to that site asks nothing but the yes after the scan; `--dry-run` reads no saved file and asks nothing; while the second run scans, no process it started (its Chrome too) has the password in its arguments or environment. Test: `test/web/site-import-saved-password.test.ts` "AC11 site:import saves the login it tested before the scan and a second run asks only for the yes".
- AC12 (proposed): In the app's page: after one "Log in and check" with the password typed and `yes`, step 3 shows "saved on this computer (ends in UVWX)" and no password box; the next "Log in and check" sends an upload request whose body holds no password, the job asks only the yes question, and `yes` uploads; **Forget** brings the box back, an upload request with no password is then refused (400) and the next login asks again; **Replace** with another accepted password leaves that one saved. Test: `test/web/importer-app-saved-password.test.ts` "AC12 the app's second upload asks no password, Forget makes it ask again and Replace saves the new one".
- AC13 (proposed): The app's two password routes answer only `saved` and `ends` (no form of the password in any answer), are refused like every `/api` route without the run's key, with another Origin or Host, or as a GET, answer 400 with a line repeating no value for a site that isn't an address or a user name that isn't one line, and 403 for a site that isn't this computer when the app has no terminal; a saved password the stub command refuses is asked of the page once as a masked question. Test: `test/unit/importer-app-password.test.ts` "AC13 the app's saved-password routes say only whether one is saved and its last four, behind the app's guard".
- AC14 (proposed): On the command line a saved password is in the saved file and nowhere else: across a first run, a run that reads it, a refused one, `--new-password` and `--forget-password`, every form of it `namedSecretForms` lists is in no printed line (an echoing stand-in's refusal of a run that read it from the file comes out as `[hidden]`), not in the tool's arguments or environment, the record, `media.json`, the pastes, the notes or any other file under HOME, the out folder or TMPDIR; the stand-in got it only as the Authorization of requests to itself. Test: `test/unit/site-upload-saved-password.test.ts` "AC14 a saved password is in the saved file and nowhere else: no line, argument, environment, record, paste or other file".
- AC15 (proposed): In the app a saved password is in the saved file and nowhere else: during and after an upload that read it, every form of it is in no address the page asked for, no request body, no answer the page got, not in the page's text, boxes, `localStorage` or `sessionStorage`, no line of the app's terminal, no argument or environment of any process the app started (the upload command, its Chrome), and no file but `site-passwords.json`; a stub command that prints every form of the saved login reaches the page with each hidden. Test: `test/web/importer-app-saved-password.test.ts` "AC15 a saved password reaches no address, body, answer, page storage, process or file but the saved file".
- AC16 (proposed): The files a run writes don't depend on where the password came from: the pastes, `media.json` and the notes of a run that read the saved password are byte for byte those of a run that typed it (same capture, same record state, a stand-in each). Test: `test/unit/site-upload-saved-password.test.ts` "AC16 a run with the saved password writes the same files as a run that typed it".
- AC17 (proposed) (live): Paste check **3fk**, Justin's own. `npm run importer` from your terminal; pick a saved scan; Pictures to WordPress on B-Dry staging with your user name and Application Password; type yes. Run it again: step 3 shows "saved on this computer (ends in …)", no password is asked, only the yes. Press Forget: the box is back and the next "Log in and check" asks for the password.

## Base tallies and what the prototype breaks

- Base, `test/unit/importer-app-*`, `site-upload-*`, `site-import-*`: 97 tests, 94 pass, 3 skipped (story pins), 0
  fail (`base-unit-subset.log`).
- Prototype (the commands read and save; no app change), same subset (`proto-cli-unit-subset.log`): **7 red, all
  because a test logs in twice with one HOME and waits for a password prompt that no longer shows, or reads HOME for
  the password.** The builder edits each in the commit that makes `logIn` save (they can't stay green without it):
  - `test/unit/site-upload-cli.test.ts` "AC8 the password reaches no file…" (the wrong-password second run; and
    HOME now holds the saved file: let that one file hold it, as `site-upload-secrets` does for the key's).
  - `test/unit/site-upload-cli.test.ts` "AC9 a second run uploads nothing new…", "AC10 the tool refuses another
    site…", "AC11 a run stopped half-way…" (second runs: no prompt to answer).
  - `test/unit/site-upload-forms.test.ts` "the form's number is read…" (the same).
  - `test/unit/site-upload-scrub.test.ts` "R1-2 … no file holds it" (HOME's saved file).
  - `test/unit/site-upload-stop.test.ts` (the whole file hung with no time limit of its own, killed by hand after
    13 minutes: its next-run steps wait for the prompt).
  The usual edit: the second run's steps drop the login (or the run gets `--new-password` where the test is about
  typing one), and a files check excludes exactly `home/.config/figma-to-bricks/site-passwords.json`, asserting
  that file holds it. No assertion about requests, files or lines elsewhere is loosened.
- Web tests that log in (`test/web/site-upload-*`, `site-import-*`, `importer-app-*`) on the prototype and the base:
  `proto-cli-web-subset.log`, `base-web-subset.log` (see "Evidence": written by `run-web.sh`; the planner's note on
  them is in `web-findings.txt`). Known before running: `site-upload-secrets.test.ts`, `site-import-secret.test.ts`
  and `importer-app-secret.test.ts` read every file under HOME and must let the one saved file hold the password;
  multi-page-scan's base tally names two web tests red on main already (`importer-app-notes.test.ts:46`,
  `importer-app-page.test.ts:124`), not this job's.

## Tasks (test first; one commit a task, each green)

0. In the copy: `npm run corpus` before Task 1 (the project's rule), and the two base tallies above run again.
1. **The stand-in can change a password.** `test/fixtures/wp-standin.ts:155`: `users` read at each request
   (`o.users ?? []`), so `configure({ users })` is "the Application Password was revoked and a new one made"
   (WordPress answers the old one 401 `incorrect_password`, as the stand-in already does). No test changes outcome.
2. **The store.** `tools/lib/site-upload/saved-login.ts` as in `proto/saved-login.ts`, with
   `test/unit/saved-login.test.ts` (the store's own cases of the ninth criterion: these are helper tests, kept with
   their helper).
3. **The login reads and saves.** `flow.ts` `logIn` as in `proto/tools.diff` (the fifth argument; the user-name line
   reworded as D2 step 2 says); `tools/site-upload.ts` and `tools/site-import.ts` pass `{ saved: new SavedLogins() }`.
   RED first on the base's behaviour: the tests of AC1, AC2, AC4, AC5, AC6, AC10, AC14, AC16. In the same commit the
   seven unit tests above are edited (expected red otherwise). `ask.ts`'s "Nothing is stored" stays true of that
   file; the headers of `flow.ts`, `site-upload.ts`, `site-import.ts`, `args.ts` and `site-import/args.ts` say where
   the password is saved.
4. **The flags.** `tools/lib/site-upload/password-flags.ts`: `PASSWORD_USAGE`, `forgetAsked(argv)` (the
   `--forget-password` action's own parse: one address, an optional `--user`), `forget(site, user, out)`;
   `--new-password` a switch in both `args.ts` (`newPassword`), refused with `--dry-run`; both usage lines. RED/GREEN:
   the tests of AC7 and AC8. Existing usage and argument tests (`site-import-args.test.ts`,
   `site-upload-media-flags.test.ts`) take the new usage words.
5. **site:import.** The web test of AC11; `test/web/site-import-secret.test.ts` and
   `site-upload-secrets.test.ts` let the one saved file hold the password; every other web test the web run names.
6. **The app's server.** `server.ts` (`Ctx.passwords`, `passwordsFile` option for tests), `routes.ts` (the two
   routes, `startUpload`), `jobs.ts` (`knows`), `commands.ts` (`uploadArgs` `newPassword`), `chains.ts`
   (`UploadPlan.newPassword`). RED/GREEN: the test of AC13; `importer-app-commands.test.ts` takes the new argument.
7. **The app's page.** `page/index.html`, new `page/password.ts`, `page/upload.ts`, `page/main.ts` (wire it),
   `app.css` if a class is needed (no inline style: the page's CSP drops it). RED/GREEN: the tests of AC12 and AC15;
   `test/web/importer-app-secret.test.ts`, `importer-app-upload.test.ts` and
   `test/unit/importer-app-page-sources.test.ts` updated where they pin the page or HOME's files.
8. **The pin against main.** The named-only test of AC3 (as `site-import-same.test.ts` reads `F2B_BASE_TREE`).
9. **Docs and records.** `docs/HANDOFF.md`: a section "The Application Password is saved" (the six rulings, the
   risks below in plain words, paste check 3fk in the end-of-run list); the ledger. For the finisher: the CLAUDE.md
   lines below. For the main session: memory `importer-media-upload` says "password at a hidden prompt each run";
   it needs the new line.
10. **Gates at the close:** `npm run check`, `npm run test:web` (the branch touches `test/web/`), `npm run corpus`.

Guards this job adds need `mutation-testing-discipline` (the builder's brief): at least these mutants must die: save
before the login test; read the saved password for another site's key; `logIn` with a default store; the 401-only
fallback widened to any failure; the scrubber told of the saved password after the first request instead of before;
`startUpload` accepting no password with none saved; the look route answering the password; `--forget-password`
deleting the whole file.

## CLAUDE.md lines that change (for the finisher, exact words)

1. **"One uploader writes to WordPress…"**, replace the sentence that starts "The Application Password is typed at
   the hidden prompt" and ends "the page's storage or the scan's Chrome." with:

   > The Application Password is typed once for each site and user name, at the hidden prompt (`site:import` asks it
   > before the scan) or in the app's password box, which sends it once in a request body to the app on 127.0.0.1,
   > which writes it once to the upload command's input. Once WordPress accepts the login the upload command saves it
   > in `~/.config/figma-to-bricks/site-passwords.json` (0600, one entry per site and user name; Justin, 2026-11-16:
   > "saved and doesn't need to be re-entered"), and later runs of all three read it from there, for that site and
   > user name only (`tools/lib/site-upload/saved-login.ts`; shown only by its last four characters; `--new-password`
   > or the app's Replace replaces it, `--forget-password` or the app's Forget removes it, one WordPress refuses is
   > asked for again once). Besides that one file it never goes in an argument, a shell or environment variable, an
   > address, another file, the record, the capture, the paste, a log, a printed line, the page's storage or the
   > scan's Chrome, and a saved password never skips the typed `yes`.

2. **The same paragraph**, in "Agents never run them against his site or any live site, never ask for, hold or type
   his password", add after "his password": ", never read, copy or print `~/.config/figma-to-bricks/site-passwords.json`
   or `alttext-key` (their names, modes and sizes only)".

3. **Decisions, "A scanned page's pictures go to WordPress from the command line"**, replace "the password at a
   hidden prompt each run, never saved (Q2 A);" with: "the password typed once for each site and user name, then
   saved on that computer in a file only he can read (Q2 A reversed by saved-password, Justin, 2026-11-16: "saved
   and doesn't need to be re-entered"; its ⭐ answers Q1–Q6 not yet confirmed);".

4. **Working in this repo**, one new line: "**A test never logs in through the real HOME** (saved-password):
   `logIn` reads and saves a password only when its caller passes the saved logins (`site-upload.ts`,
   `site-import.ts`); a test that starts a tool gives it a HOME of its own, and a files check lets only
   `site-passwords.json` hold the password."

5. **Status**: the build line, and one line for the feature: "saved-password (website importer): the Application
   Password is saved per site and user name in `~/.config/figma-to-bricks/site-passwords.json` (0600) once WordPress
   accepts it; `site:upload`, `site:import` and the app then ask only the typed yes; shown by its last four;
   `--new-password`/Replace, `--forget-password`/Forget; a refused one asked again once; pastes byte for byte as
   before. Q1–Q6 ⭐ A not yet confirmed. Paste check **3fk** (AC17, live)."

If a copy of this file is kept at `~/.claude/project-docs/`, the project's own file is the one to edit (`sync.sh`
writes the copy).

## Other jobs touching the same files

- **multi-page-scan (being planned):** up to 3 pages scanned in one go, one login and one yes for all. It fits with
  no extra work: a run of several scans still calls `logIn` once, so the one saved password covers all three pages,
  and the app still starts one upload command with at most one typed password. Shared files:
  `tools/lib/importer-app/routes.ts` (`startUpload`: this job changes only the password check and one argument; its
  job keeps its part in one helper), `jobs.ts`, `commands.ts` (`uploadArgs`), `chains.ts` (`UploadPlan`),
  `page/upload.ts`, `page/index.html` (step 3), `tools/site-upload.ts` (this job: one line, the `logIn` call),
  `tools/lib/site-upload/args.ts`, `flow.ts` (`logIn` only; its `beforeYes` and `yesQuestion` are untouched here),
  `test/web/importer-app-upload.test.ts`, `importer-app-secret.test.ts`. Whichever merges second rebases; the second
  one's secret test (its AC16, this job's AC15) runs again on the joined head, and its several-scan upload test gets
  one case with the password saved.
- **internal-links (in review):** adds a pages read after the login (`findPages` beside `findForms`). It reads with
  `login.wp`, wherever the password came from: nothing to join but lines. Shared: `tools/site-upload.ts`,
  `tools/lib/site-upload/flow.ts`, `tools/lib/importer-app/commands.ts`, `routes.ts`, `chains.ts`,
  `test/fixtures/wp-standin.ts` (this job: line 155 only), `test/unit/site-upload-cli.test.ts`,
  `test/web/importer-app-upload.test.ts`.
- **tier-spacing (in review):** `tools/lib/site-write.ts` and `src/core/site` only. No shared file.
- **Paused:** short-class-names edits `tools/lib/site-upload/args.ts`, `flow.ts`, `tools/site-upload.ts`,
  `site-import.ts` and their tests (all four shared: different lines); fewer-kept-boxes, clean-values and
  link-keeps-name share no tool file.
- Every job: `docs/HANDOFF.md`, CLAUDE.md Status.

## Risks and limits (plain words)

1. **Plain text, readable by anything that runs as you.** The file's lock (0600) keeps other users of the computer
   out. It does not keep out a program you run: a script, a browser extension's helper, an AI agent with a shell on
   this desktop. Until now the password existed only while a run was going. An Application Password has your
   WordPress user's full rights through the REST API (an Administrator's on B-Dry staging: pages, users, settings),
   not only Media. What limits it: one file, Forget, and revoking it in WordPress (Users → Profile) ends it at once.
   If you want less at stake you can make the Application Password under a WordPress user with a lower role
   (an Author can upload media; the WPForms number read and the Font Library need an Administrator and would then be
   left out, named).
2. **"Only Justin runs it" stops being enforced by the password.** The typed yes and the terminal check stay, but a
   program can type yes. The rule that agents never run the uploader against your site, and never read this file,
   stays a rule (CLAUDE.md line 2 above). A guard that enforces it (a Claude Code hook refusing agent reads of the
   two secret files and agent runs of `site:upload`, `site:import` and `importer` with a site that isn't 127.0.0.1)
   is offered as its own small job, not built here.
3. **Backups and copies.** Whatever backs up your home folder (Time Machine, a Windows backup of the WSL disk) takes
   the file with it. The setup sync does not: it tracks nothing under `~/.config` (probed: 0 files), and this file
   must never be added to it (its secret scan would not recognise an Application Password).
4. **Each computer asks once.** The desktop's saved password isn't on the Mac.
5. **A keyring would not change 1 or 2** (a program running as you can ask an unlocked keyring too); it would only
   protect a copied disk or backup. Q1 B stays open to you.
6. **A wrong user name is remembered too** (Q5 A): with one saved login the command line uses it without asking;
   `--user` or Forget changes that.
7. **Two runs saving at the same moment:** the last one wins; the other login is asked again next time.
8. **Tests:** seven unit tests (and the web tests the web run names) log in twice with one HOME and are edited; none
   of their checks on requests, files or lines is loosened. The app's page test is slow (Chrome); AC12 and AC15 share
   one file to keep it to two page runs.
9. **Not built:** a "don't save this time" switch (Q3 B would add the question); showing or exporting saved logins;
   an expiry.

## Evidence (`~/.hermes/plans/figma-to-bricks/evidence/saved-password/planner/`)

- `keyring-probe.txt`: what this desktop has (no keyring), the config folder's names, modes and sizes (no contents
  read), the setup repo tracking nothing under `~/.config`.
- `base-unit-subset.log`, `proto-cli-unit-subset.log`: the unit tallies above.
- `probe-saved.test.ts`, `probe-base.log` (red by assertion), `probe-proto.log` (green).
- `proto/saved-login.ts` (the store, whole), `proto/tools.diff` (the prototype's change to `flow.ts`,
  `site-upload.ts`, `site-import.ts`).
- `run-web.sh`, `proto-cli-web-subset.log`, `base-web-subset.log`, `web-findings.txt`: the web tests that log in.

## Report contract

The builder stops at `ready-for-review` with one test and one terminal capture (or page screenshot for AC12, AC15)
per AC in `~/.hermes/plans/figma-to-bricks/evidence/saved-password/`, the ledger in
`.superpowers/sdd/saved-password/progress.md`, and `skill_lessons`. No agent runs any of the three tools against a
real site, asks for or holds Justin's password, or reads the saved file or the key file on this computer.
