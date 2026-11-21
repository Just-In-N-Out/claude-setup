# tennis-booking: a small site where she books the next game and gets it by email

Plan written 2026-11-21 10:49 EST by the planner. Amended 2026-11-21 by the planner (revise mode) for Justin's answer Q1 = C, no domain. Plan only: nothing is built, no repo exists yet.
New repo (the builder creates it): `/home/justin/tennis-booking`. Personal identity, not Leorna.
Evidence folder: `~/.hermes/plans/tennis-booking/evidence/tennis-booking/`.

## Amendments (2026-11-21, for Q1 = C: no domain)

In one line: the site now emails **you** (the Resend account's own address) with her address and the booking in it, and you forward it to her. Everything else is as approved.

1. **Questions:** the heading and Q1 are marked answered (C); the note under Q1 is rewritten.
2. **Playback:** one paragraph added, "As answered (Q1 = C)".
3. **Acceptance criteria:** five changed, ids kept, all still proposed.
   - Changed AC2: the confirmation says the invite will follow, and never that an email was sent to her. Test name unchanged.
   - Changed AC5: `to` is `OWNER_EMAIL` alone, no `cc` or `bcc`, `reply_to` is her address, both bodies name her address. Test renamed to `AC5 a valid booking sends one email to the owner naming her address`.
   - Changed AC12: Resend's public test sender `onboarding@resend.dev` is allowed in tracked files (it is `EMAIL_FROM`'s value in `.env.example`). The five variable names are unchanged. Test name unchanged.
   - Changed AC13 (live): the email lands in your inbox and reaches her address when forwarded.
   - Changed AC14 (live): the calendar file is opened from the forwarded email.
   - Unchanged: AC1, AC3, AC4, AC6, AC7, AC8, AC9, AC10, AC11.
4. **Approach:** the tree's `lib/email.js` line; in "The endpoint", the Resend call and the "server-made text" paragraph; new paragraph "A domain later"; in "The page", the confirmation sentence.
5. **The words:** the email label, the Confirmation row and the Email body row (a desk note with her address); one line added under the table.
6. **What you do yourself:** steps 2, 4 and 5 rewritten (no DNS step); step 6 added (forward each booking).
7. **Tasks:** 2, 4, 5, 10 and 13 each gained a clause.
8. **Tests and gates:** the last bullet names the forward.
9. **Choices made:** the `cc` bullet is replaced; "One mode, not two" added.
10. **Risks:** the first two bullets are replaced by four; the leaked-link and "her address" bullets are reworded.
11. **Docs & records:** the README bullet and the last bullet.


## Questions for Justin (all answered 2026-11-21: every recommended answer, except Q1 = C; the plan below is written for those answers)

**Q1. The sender address. This one decides whether she can get the email at all.** Answered: **C**.
Checked in Resend's docs today: the test sender `onboarding@resend.dev` only delivers to the address the Resend account was made with. Any other recipient gets a 403 ("You can only send testing emails to your own email address"). To mail her, Resend needs a domain you own, verified with DNS records. A `*.vercel.app` address can't be verified (you don't control its DNS).
- A. I own a domain: verify it in Resend **(recommended)**
- B. I don't: buy a cheap one (about $10 a year), verify it
- C. No domain: emails go only to me and I forward them **(chosen)**

With C the site still works, but she never gets an email from it directly. The plan below is amended for that: the email goes to you with her address in it, you forward it, and the two live checks follow that path.

**Q2. Framework**
- A. Static page plus one Vercel function, no framework **(recommended)**
- B. Next.js App Router
- C. Astro with one API route

Why A: one page and one endpoint. No build step, two dev-only packages, nothing to keep updated.

**Q3. How slots work**
- A. Next 14 days, fixed daily times from a config file **(recommended)**
- B. Different times per weekday (your availability)
- C. Free date and time picker, anything goes

**Q4. Are bookings stored, and do you get a copy?**
- A. No store; the email is the record and you are copied **(recommended)**
- B. No store, and you get no copy
- C. Store bookings (Upstash) and show taken slots

With A nothing stops the same slot being booked twice; you would both just get two emails. C adds a database, an account and a second page state, and makes this a Full-pipeline job.

**Q5. Calendar invite**
- A. Attach a calendar file (.ics) to the email **(recommended)**
- B. Plain email only
- C. An "Add to Google Calendar" link instead

**Q6. Who can use the site (the endpoint is public and sends email)**
- A. Private invite link with a key in it **(recommended)**
- B. Only pre-approved email addresses (a list you set)
- C. Open to anyone, throttled only

Why A: without the key, the site sends nothing, so a stranger who finds the URL can't use it to email people. She just opens the link you send her. With C anyone could make your domain email any address.

**Q7. Times, timezone and game length (all editable later in one file)**
- A. This PC's timezone, six daily times, 90-minute games **(recommended)**
- B. I'll give my own times and timezone before the build
- C. The same defaults, but 60-minute games

The six default times: 08:00, 10:00, 12:00, 17:00, 18:30, 20:00.

**Q8. Pipeline size**
- A. Switch to Full (two full reviews) **(recommended)**
- B. Stay Mini, and drop the builder's 3-file stop rule

By the Mini rules this is not a Mini job: it is a new project of about 20 files with design choices and a public endpoint that sends email. The risk is still low (a personal site, nothing stored, no accounts). If you stay Mini, the builder's brief must not carry the "more than about 3 source files → escalate" rule, or it stops at once.

## What you asked for (playback)

A small website for the friend you play tennis with. She picks a day and a time for the next game, types her email, and gets the booked game by email. Choosing should be a little funny: dry, understated lines, nothing loud or cheesy. Hosting on Vercel, email through Resend. Deploying and the Resend account are your steps.

**As answered (Q1 = C):** with no domain the site can't email her directly. It emails you, with her address and the booking in it, and you forward it to her. The page tells her the invite will follow; it never says an email has reached her.

## Acceptance criteria (all proposed: none were given; "go" approves them)

Each AC has one test, named whole on its line. `e2e/` tests run in a real browser against the local server with Resend faked; `test/` tests call the endpoint's handler directly with Resend faked. No test sends a real email.

- AC1 (proposed): Given the page opened with a valid invite link, when she picks a day and then a time, then the summary line shows that day and time, and at most one aside from the copy file is shown, in a polite live region. Test: `AC1 choosing a day and a time shows the summary and one aside` in `e2e/booking.spec.js`.
- AC2 (proposed): Given a day, a time and a valid email, when she presses "Book it", then the button is disabled while sending, exactly one request reaches `/api/book` even on a double click, and the confirmation shows the day, the time, her email and the copy file's "the invite will follow" line (it never says an email was sent to her), with focus on its heading. Test: `AC2 booking shows the confirmation and sends one request` in `e2e/booking.spec.js`.
- AC3 (proposed): Given the send fails, when she presses "Book it", then a plain error message shows, her day, time and email are still filled in, and pressing again after the fault clears books it. Test: `AC3 a failed send keeps her choices and a retry works` in `e2e/booking.spec.js`.
- AC4 (proposed): Given the page opened without a key in the link, then it shows the invitation-only notice, shows no booking form, and makes no request to `/api/book`. Test: `AC4 without the invite key the page shows the notice and no form` in `e2e/booking.spec.js`.
- AC5 (proposed): Given a valid request with the right key, then the endpoint answers 200 `{ok:true}` and makes exactly one Resend request: `from` is `EMAIL_FROM`, `to` is `OWNER_EMAIL` alone, there is no `cc` and no `bcc`, `reply_to` is her address, the subject carries the day and time, both bodies carry the day, the time and her address, the Bearer key is `RESEND_API_KEY`, and the `Idempotency-Key` is the same for the same email, day and time and differs when any of the three differs. Test: `AC5 a valid booking sends one email to the owner naming her address` in `test/api.test.js`.
- AC6 (proposed): The email carries one attachment `tennis.ics` whose event starts at the chosen day and time in the configured timezone, written in UTC, and ends one game length later; this holds on a summer date and a winter date in a timezone with daylight saving, and lines end in CRLF. Test: `AC6 the calendar file has the right start and end in UTC` in `test/api.test.js`.
- AC7 (proposed): Every invalid request is refused with its 4xx status and stable error code, and no Resend request is made: a non-POST method (405), a non-JSON content type (415), a body over 2 KB (413), broken JSON, a missing, extra or non-string field, a malformed email (each listed shape), a date that is not a real day, a day before today, a day past the 14-day window, a time not in the slot list, and a slot today that has already passed (400 each). Test: `AC7 every invalid request is refused and nothing is sent` in `test/api.test.js`.
- AC8 (proposed): Given a wrong key or an empty key, then the answer is 403 `bad_key`; given the server's `BOOKING_KEY` is unset or shorter than 16 characters, then every request gets 500 `not_configured`; in all four cases no Resend request is made. Test: `AC8 a wrong key or an unset server key sends nothing` in `test/api.test.js`.
- AC9 (proposed): Every way the send can fail (Resend answers 403, 429 or 500, the network call throws, the call passes its 8-second limit) returns 502 `send_failed`, and neither the response nor anything logged holds the API key, the Resend error text or her address. Test: `AC9 every send failure returns send_failed without leaking` in `test/api.test.js`.
- AC10 (proposed): Within one running instance, the sixth accepted booking inside ten minutes gets 429 `rate_limited` with a `Retry-After` header and no Resend request, and a booking after the ten minutes pass is accepted again. Test: `AC10 the sixth booking inside ten minutes is refused` in `test/api.test.js`.
- AC11 (proposed): At a 375-pixel-wide screen the page has no sideways scroll, the whole booking can be done with the keyboard alone, the response carries the security headers from `vercel.json` with no CSP error in the console, and an axe scan of the form and of the confirmation finds no serious or critical issue. Test: `AC11 keyboard-only booking at phone width passes axe` in `e2e/booking.spec.js`.
- AC12 (proposed): No tracked file and no file served from `public/` holds a Resend-shaped key or an email address other than an `example.com` placeholder or Resend's public test sender `onboarding@resend.dev`; `.env.example` names exactly `RESEND_API_KEY`, `EMAIL_FROM`, `OWNER_EMAIL`, `BOOKING_KEY`, `COURT_LOCATION` with placeholder values (`EMAIL_FROM` is the test sender); `.gitignore` ignores `.env` files. Test: `AC12 no key or address is in tracked or served files` in `test/repo.test.js`.
- AC13 (proposed) (live): On the deployed Vercel site, a booking made through the invite link with an address that is not the Resend account's own arrives in the Resend account's inbox (yours), names that address, the day and the time, and carries `tennis.ics`; forwarded from there, it reaches that address with the calendar file still attached. Check: you book once with a second address of yours (or hers), find the email in your inbox (look in spam too), see that Reply addresses the second address, then forward it and see it arrive there with the attachment.
- AC14 (proposed) (live): The calendar file from the forwarded email opens on her phone or in Gmail and adds the game at the right local time and length. Check: open the attachment from the forwarded AC13 email and compare the calendar entry with the booking.

## Approach

One static page and one server function. No framework, no build step, no database.

```
/home/justin/tennis-booking/
  package.json           "type": "module", engines node 22.x, scripts, two dev packages
  package-lock.json
  vercel.json            security headers for every response
  .gitignore             node_modules, .env*, !.env.example, test-results, .vercel
  .env.example           the five variable names with placeholder values
  README.md              setup, local run, tests, deploy steps
  api/book.js            the Vercel function: wires real env + fetch into the handler
  lib/handler.js         request -> response, every check in order
  lib/validate.js        body shape, email, day and time rules
  lib/email.js           subject, text and HTML bodies (values escaped), and who the email goes to
  lib/ics.js             the calendar file
  lib/resend.js          the one call to Resend
  lib/throttle.js        the per-instance send limit
  public/index.html      the page
  public/styles.css      all styling (no inline styles: the CSP drops them)
  public/app.js          page behaviour
  public/shared/config.js  timezone, locale, days ahead, game length, slot list
  public/shared/rules.js   day list, timezone maths, "has this slot passed"
  public/shared/copy.js    every word on the page and in the email, in one place
  scripts/dev-server.mjs   local only: serves public/ with vercel.json's headers, routes /api/book
  playwright.config.js
  test/api.test.js  test/repo.test.js  test/rules.test.js
  e2e/booking.spec.js  e2e/app-server.js
```

**How Vercel runs it (checked in Vercel's docs today).** With no framework, files in `public/` are served as the site and each file in `api/` becomes a function. `api/book.js` uses the web-standard form `export default { fetch(request) { … } }`, which receives every HTTP method, so the handler itself answers 405. `"type": "module"` in `package.json` keeps the files as real ES modules. Helpers live in `lib/`, outside `api/`, so they don't become functions of their own. `public/shared/*.js` is imported by both the page and the function, so the rules and the words can't drift apart.

**The handler is built for testing.** `lib/handler.js` exports `createBookingHandler({ env, fetchImpl, now, log })` and returns `async (request) => Response`. `api/book.js` passes `process.env`, the global `fetch`, the real clock and `console`. Tests pass fakes. There is no "API base URL" setting in production code.

**Local server.** `scripts/dev-server.mjs` exports `startServer({ env, fetchImpl, now, port })`: it serves `public/`, applies the headers from `vercel.json`, and turns a Node request for `/api/book` into a web `Request` for the same handler. `npm run dev` runs it with a fake sender that prints the email to the terminal unless `.env` holds a real key. The browser tests start it in-process (`e2e/app-server.js`) with a recording fake Resend, so they can count requests and make the send fail.

### The endpoint

`POST /api/book`, `Content-Type: application/json`, body at most 2 KB, exactly four string fields:

```json
{ "date": "2026-11-28", "time": "10:00", "email": "her@example.com", "key": "<invite key>" }
```

Every response is JSON with `Cache-Control: no-store`. Success: `200 {"ok":true,"booking":{"date":"…","time":"…"}}`. Failure: `{"ok":false,"error":{"code":"…","message":"…"}}`.

Checks, in this order:

| Step | Refusal |
|---|---|
| Method is POST | 405 `method_not_allowed`, `Allow: POST` |
| Content type is JSON | 415 `unsupported_media_type` |
| Body is at most 2 KB | 413 `too_large` |
| Body parses as JSON | 400 `invalid_json` |
| Exactly `date`, `time`, `email`, `key`, all strings | 400 `invalid_request` |
| Server has `RESEND_API_KEY`, `EMAIL_FROM`, `OWNER_EMAIL`, and a `BOOKING_KEY` of 16+ characters | 500 `not_configured` (fails closed: no key never means open) |
| `key` equals `BOOKING_KEY` (SHA-256 both, then `crypto.timingSafeEqual`) | 403 `bad_key` |
| `email`: 3 to 254 characters after trimming, one `@`, a dot in the domain, no spaces, control characters, commas, semicolons or angle brackets | 400 `invalid_email` |
| `date` is a real `YYYY-MM-DD` day, from today to today + 14 in the configured timezone | 400 `invalid_date` |
| `time` is in the slot list | 400 `invalid_time` |
| The slot has not already passed | 400 `slot_passed` |
| Fewer than 5 sends in the last 10 minutes in this instance | 429 `rate_limited`, `Retry-After` |
| Resend answers 2xx within 8 seconds | 502 `send_failed` |

The Resend call (`lib/resend.js`): `POST https://api.resend.com/emails`, `Authorization: Bearer <RESEND_API_KEY>`, `Idempotency-Key: booking-<first 32 hex of SHA-256(email|date|time)>` (Resend keeps keys 24 hours, so the same booking sent twice is one email), body `{ from, to: [OWNER_EMAIL], reply_to: <her address>, subject, text, html, attachments: [{ filename: "tennis.ics", content: <base64> }] }`, with no `cc` and no `bcc`. `from` is whatever `EMAIL_FROM` holds; with no domain that is Resend's test sender, `Court Desk <onboarding@resend.dev>`, which delivers only to the Resend account's own address, so `OWNER_EMAIL` must be that address. `recipientsFor(herEmail, ownerEmail)` in `lib/email.js` is the one place that decides `to` and `reply_to`. The builder confirms the exact spelling of `reply_to` and the attachment's content-type field in Resend's API reference before writing the test (two fetches of that page today lost those names; `filename`, `content` as Base64, `cc`, `bcc` and the 24-hour `Idempotency-Key` were confirmed). On failure it logs the status and Resend's error `name` only: never the key, the error text or her address.

The email holds only server-made text: the day and time come from the validated values, the place from `COURT_LOCATION`, and her address is the validated one (escaped in the HTML body). There is no free-text note field, so the site can't be used to send someone else's words.

**A domain later (not built now).** If you verify a domain in Resend one day, the site can email her directly. That is a small job of its own, not just a setting: `EMAIL_FROM` changes to an address on the domain (env var only), `recipientsFor` returns `{ to: [her], cc: [owner], reply_to: owner }` instead of `{ to: [owner], reply_to: her }`, the Confirmation line and the desk note in the copy file change, and AC5 and AC13 go back to the direct wording. About ten lines of code plus the tests. There is no switch for it today: a second mode would need its own setting, tests and words for something that may never happen.

The calendar file (`lib/ics.js`): `VERSION:2.0`, `METHOD:PUBLISH`, one `VEVENT` with a stable `UID` (hash of the booking), `DTSTAMP`, `DTSTART` and `DTEND` in UTC (`…Z`), `SUMMARY:Tennis`, `LOCATION` when set (commas, semicolons, backslashes and line breaks escaped), CRLF line ends, lines folded at 75 bytes. The local-to-UTC step is `zonedToUtc(date, time, timezone)` in `public/shared/rules.js`, done with `Intl.DateTimeFormat` (no date library).

### The page

One screen, phone first (she will open it from a message). A real `<form>`: a "Day" group of 14 radio buttons, a "Time" group of slot radio buttons, an email field with a visible label, one button. Below the choices, a summary line and at most one aside, in an `aria-live="polite"` region. On success the form is replaced by the confirmation (which says the invite will follow, not that it has been sent to her), focus moves to its heading, and "Book another" brings the form back with the email kept. Errors are shown next to the button in plain words and announced. The key is read from the link's fragment (`https://<site>/#k=<key>`): a fragment is never sent to the server when the page loads, so it stays out of Vercel's request logs; the page sends it only in the booking request's body. With no key the page shows the invitation-only notice and no form. A `<noscript>` line says the page needs JavaScript.

Look: clean and quiet. Chalk-white background, deep court green for text and the button, optic yellow only as a fill behind dark text for the chosen day and time (never yellow text on white), thin court-line rules as dividers, system fonts (the CSP allows nothing from other sites). The chosen state is also marked by border weight and a tick, not colour alone. Targets are at least 44 px. One short transition, off under reduced motion. Light theme only.

### The words (the copy file; "go" approves them, and they are easy to change later)

Rules: at most one aside on screen; many choices get no aside at all; error messages never joke.

| Where | Text |
|---|---|
| Small heading | Court desk |
| Title | Book the next match |
| Under the title | Pick a day and a time. The rest is paperwork. |
| Group labels | Day / Time |
| Email label | Where should the invite go? |
| Email hint | Only used to send this booking. |
| Summary, nothing chosen | Nothing chosen yet. The court is patient. |
| Summary, chosen | Sat, Nov 28 at 10:00 AM. |
| Aside: today | Today. No time to practise, then. |
| Aside: tomorrow | Tomorrow. Just enough time to find the racket. |
| Aside: Saturday or Sunday | A weekend. Sensible. |
| Aside: Monday | A Monday. Brave. |
| Aside: before 9:00 | Early. Optimistic, but noted. |
| Aside: 11:00 to 2:59 | Midday. Sunscreen is not optional. |
| Aside: 5:00 to 6:59 | After work. A reasonable way to end a day. |
| Aside: 7:00 or later | Under the lights. They forgive a lot. |
| Button / while sending | Book it / Sending… |
| Confirmation | Booked. / Sat, Nov 28 at 10:00 AM. / The invite will follow at (her email). It is sent by hand, so allow a little time. / It's in writing now. / Book another |
| Footer | To change a booking, reply to the email. |
| Error: nothing chosen | Pick a day and a time first. |
| Error: email | That email doesn't look right. Check it and try again. |
| Error: slot passed | That time has already passed. Pick a later one. |
| Error: send failed or no connection | The email didn't go out, so nothing is booked yet. Try again. |
| Error: too many | Too many bookings in a row. Give it a few minutes. |
| No key or wrong key | This court is invitation-only. Ask for the link. |
| Email subject | Tennis: Sat, Nov 28 at 10:00 AM |
| Email body | It's official. / When: Saturday, November 28 at 10:00 AM (90 minutes) / Where: (the place, when set) / The calendar file is attached, so forgetting is off the table. / To change it, reply to this email. / Desk note: booked by (her email). Forward this to that address and the calendar file goes with it. |

Once a time is chosen its aside replaces the day's aside.

The email is written to read well forwarded as it is: the desk note sits last, and "reply to this email" works both ways (your Reply on the original goes to her, her Reply on the forward comes to you).

## What you do yourself

1. **Before the build, once, in the Ubuntu window** (the test browser on this PC can't start: see "Other things found"):
   `sudo apt-get update && sudo apt-get install -y libnss3 libnspr4 libasound2t64`
2. **Resend:** make the account with the address you want bookings to land in. That address becomes `OWNER_EMAIL`: the test sender delivers to it and to no other. Add no domain (so there is no DNS step). Make an API key with sending access only.
3. **The invite key**, in the Ubuntu window: `openssl rand -hex 16`. Keep the output.
4. **Vercel:** either say "push" so the repo goes to a private GitHub repo and import it in Vercel (preset "Other", no build command), or install the CLI (`npm i -g vercel`, `vercel login`, then `vercel --prod` in the folder). Set these for Production:
   - `RESEND_API_KEY`: the key from step 2
   - `EMAIL_FROM`: `Court Desk <onboarding@resend.dev>` (Resend's test sender; no other sender works without a domain)
   - `OWNER_EMAIL`: the exact address your Resend account was made with (with any other address every booking fails with "The email didn't go out")
   - `BOOKING_KEY`: the output of step 3
   - `COURT_LOCATION`: optional, the place shown in the email
5. **The two live checks** (the criteria numbered 13 and 14): open `https://<your-site>.vercel.app/#k=<key>`, book once with a second address of yours, find the email in your Resend-account inbox (and spam), forward it to the second address, check it arrives with `tennis.ics`, and open the calendar file there. Then send her the link.
6. **For each booking after that:** forward the email to the address in its desk note. Use Forward, not Reply: a reply drops the calendar file.

## Tasks (test first, one commit each on `feat/tennis-booking`, no `Co-Authored-By` lines, no push)

Forecast for the build: 60 to 90 minutes of agent work, medium confidence; the browser setup is the main unknown.

1. **Start the repo.** `git init -b main /home/justin/tennis-booking`; check `git -C /home/justin/tennis-booking config user.email` shows the personal identity (never set it). Commit only `.gitignore` on `main`: this is the base commit every AC test must fail against. Then `git -C … switch -c feat/tennis-booking`.
2. **Tooling and the repo check (the test for AC12).** `package.json` (`"type": "module"`, `"engines": {"node": "22.x"}`, scripts `test`, `test:e2e`, `dev`, `check`), dev packages `@playwright/test` and `@axe-core/playwright` at exact versions, `npx playwright install chromium`, `playwright.config.js` (screenshots go to `process.env.EVIDENCE_DIR`, default `test-results/`, so later roles never overwrite the builder's receipts). Prove first that a browser launches; if it can't, stop and report the `ldd` output and the one-line fix. Write `test/repo.test.js` red, then `.env.example` and the rest until green. The test builds its key-shaped sample from parts, never as one literal, so `gitleaks` stays clean. Its address check allows `example.com` placeholders and `onboarding@resend.dev`, nothing else.
3. **Shared rules and config.** `public/shared/config.js` (timezone from `timedatectl show -p Timezone --value` unless Justin answered Q7 otherwise) and `public/shared/rules.js`: `todayInZone`, `listDays`, `zonedToUtc`, `slotHasPassed`. Unit tests in `test/rules.test.js` (supporting, not AC tests), with a summer and a winter date in `Europe/Paris` and `America/New_York`.
4. **The calendar file** (`lib/ics.js`) and the email text (`lib/email.js`, `public/shared/copy.js`), including the desk note with her address: the test for AC6 red, then green.
5. **The handler's happy path** (`lib/handler.js`, `lib/resend.js`, `api/book.js`, and `recipientsFor` in `lib/email.js`): the test for AC5 red, then green. It checks that `to` deep-equals `[OWNER_EMAIL]`, that the request body has no `cc` or `bcc` key, and that `reply_to` is her address.
6. **Refusals** (`lib/validate.js`): the test for AC7, written as one top-level test that loops over every case and checks the fake Resend saw nothing.
7. **The key guard:** the test for AC8.
8. **Send failures:** the test for AC9, with a fake logger whose captured lines are searched for the key, the error text and the address.
9. **The throttle** (`lib/throttle.js`): the test for AC10, with an injected clock.
10. **Guard sensitivity.** With `mutation-testing-discipline`, break each guard by hand in turn (key compare, the fail-closed config check, each validation rule, the throttle count, and the recipient rule: putting her address in `to` must turn the AC5 test red) and confirm its AC test goes red; record the table in the evidence folder. Run anything heavy under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`.
11. **The local server and headers:** `scripts/dev-server.mjs`, `e2e/app-server.js`, `vercel.json` with `Content-Security-Policy: default-src 'none'; script-src 'self'; style-src 'self'; img-src 'self' data:; connect-src 'self'; base-uri 'none'; form-action 'self'; frame-ancestors 'none'`, `X-Content-Type-Options: nosniff`, `Referrer-Policy: no-referrer`, `X-Robots-Tag: noindex`.
12. **The page, choosing:** `public/index.html`, `styles.css`, `app.js` up to the summary and aside: the test for AC1.
13. **The page, booking:** submit, pending state, confirmation, "Book another": the test for AC2. It compares the confirmation with the copy file's line with the values filled in, and checks the text holds neither "sent to" nor "on its way to".
14. **The page, failure and no key:** the tests for AC3 and AC4.
15. **Phone width, keyboard, axe, visual pass:** the test for AC11; look at the 375 px and 1280 px screenshots with your own eyes and fix what looks off.
16. **Docs & records** (below), then the full gate, then stop at `ready-for-review`.

Every AC test is one top-level `test(...)` whose name starts with its id, so its own pass line shows in the log. Each agent-checked AC gets one screenshot in the evidence folder: a browser shot for the `e2e/` ones, a terminal capture of the run for the `test/` ones.

## Tests and gates

- One endpoint test: `node --test --test-name-pattern="^AC5 " test/` (swap the id).
- One browser test: `npx playwright test -g "AC1 "` (the trailing space keeps AC10 and AC11 out).
- Everything: `npm run check` = `node --test test/` then `npx playwright test`.
- Secrets: `gitleaks git --no-banner /home/justin/tennis-booking` exits 0.
- Old-code check: each AC test fails (or can't load) on the base commit, which holds only `.gitignore`.
- A command that dies with SIGTERM, exit 143 or 137, or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` before reading it as a result.
- Not run by agents: the Vercel deploy, any real email and the forward. Those are the two live checks.

## Choices made (and why)

- **No framework.** The smallest thing that does the job; Next.js would add a build, a dependency tree and updates for one form.
- **Resend through plain `fetch`, no SDK.** Zero runtime packages, and the call is trivial to fake in tests.
- **The email goes to you alone, with `reply_to` set to her address.** Without a domain Resend delivers to the account's own address and no other, so `to` is `OWNER_EMAIL` and there is no `cc`. Forward is how she gets it, because a forward keeps the calendar file. `reply_to` is for the quick word back: the sender is Resend's shared test address, so without it your Reply would go to an inbox nobody reads; with it, Reply reaches her and you retype nothing.
- **One mode, not two.** Emailing her directly needs a domain and is written up as a later step ("A domain later"). No switch for it is built now.
- **The key lives in the link's fragment**, so it never reaches server logs on page load.
- **Calendar times are written in UTC**, converted from the configured timezone, so the file is right in any calendar app. Times on the page are the court's local time.
- **The throttle is honest about its limit:** it counts inside one running instance. On Vercel several instances can run, so the real fences are the invite key and Resend's own daily cap on the free plan.
- **No stored bookings, no cancel button.** Changing a game is a reply to the email.
- **Light theme only, English only, no analytics.**
- **Finishing:** the finisher merges `feat/tennis-booking` into local `main` with `--ff-only` in `/home/justin/tennis-booking`. Nothing is pushed or deployed unless you say so.

## Risks

- **She gets nothing until you forward it.** A booking you miss in your inbox is one she never hears back about. The page tells her the invite is sent by hand. A Gmail filter that stars mail from the test sender helps (auto-forwarding by filter may also work, but it needs her to confirm the forwarding address; not checked here).
- **`OWNER_EMAIL` must be the Resend account's own address.** With any other value Resend answers 403 and every booking shows "The email didn't go out". The first live check proves the real setting.
- **`reply_to` with the test sender is expected to work, but is only proven live.** Resend words its limit as one on recipients ("You can only send testing emails to your own email address"); `reply_to` is a header, not a recipient. If the first live booking is refused because of it, the fix is removing that one field: her address is still in the body.
- **The test sender can land in your spam.** `onboarding@resend.dev` is a shared address. The first live check says to look there; mark that email "not spam" once.
- **Vercel differs from the local server.** The local adapter stands in for Vercel's runtime, so the import of `public/shared/*.js` from the function and the `fetch` export are only proven on the real deploy (the first live check). If the shared files don't get bundled, the fix is one `includeFiles` line in `vercel.json`.
- **A leaked invite link** lets its holder put booking emails in your inbox (never anyone else's: `to` is always you), each with a reply-to address of their choosing, up to the throttle and Resend's daily cap. The cure is a new `BOOKING_KEY` in Vercel and a new link.
- **Calendar files show differently per mail app** (Gmail, Apple Mail, Outlook). The second live check covers hers.
- **Humour is a matter of taste.** Every line is in `public/shared/copy.js` and listed above; strike or change any before "go" or after.
- **Her address goes to Resend** (their logs keep it) and into the email you receive. The site itself stores nothing and logs no addresses.
- **Browser tests need system libraries this PC lacks** (step 1 of your list). Without them the builder stops at task 2.

## Skills

- Builder: `engineering-best-practices`, `test-driven-development`, `mutation-testing-discipline` (the key guard, the validation, the throttle), `build-validate-apis`, `security-best-practices` (and its JavaScript frontend and backend reference files), `ux-frontend-workbench`, `frontend-testing-workflow`, `git-commit-rules`.
- Reviewer: `requesting-code-review`, `code-review-practice`, `security-best-practices`, `frontend-accessibility-audit`.
- Fixer: `receiving-code-review`, `test-driven-development`.
- Verifier and auditor: `adversarial-verification-loop`, `frontend-testing-workflow`.

## Files it touches

Only new files, all inside the new repo `/home/justin/tennis-booking` (the tree under "Approach"), plus receipts in `~/.hermes/plans/tennis-booking/evidence/tennis-booking/`. No existing repo, skill or setup file changes. No overlap with any running job.

## Docs & records (last task)

- `README.md`: what the site is, the five environment variables and what each is set to, how to run it locally (`npm run dev`), how to run the tests, the Resend steps with no domain (the test sender, and why `OWNER_EMAIL` must be the account's own address), the forward step (Forward, not Reply), the Vercel deploy steps, how to make the invite link, how to change the slots, the timezone and the words, "Adding a domain later" (what changes, from the paragraph above), and the honest limits (she gets the invite only when you forward it, throttle per instance, no stored bookings).
- `.env.example`: the five names with placeholder values (checked by the AC12 test).
- `.gitignore`: `node_modules/`, `.env*` with `!.env.example`, `test-results/`, `playwright-report/`, `.vercel/`.
- `.git/info/exclude`: add `CLAUDE.md` if anyone creates one in this repo. None is planned; never commit it.
- `~/.hermes/plans/tennis-booking/evidence/tennis-booking/`: one log and one screenshot per agent-checked AC, the guard-sensitivity table from task 10, and `follow-ups.md` if the review leaves any.
- Done 2026-11-21: Justin chose Q1 = C and this plan was amended for it (see "Amendments" at the top). The builder builds this version. Any later change of answer (above all Q4 option C) goes back to a planner first.

## Other things found (not fixed, not part of this job)

- **The Chrome for Testing on this PC can't start.** `/home/justin/.cache/chrome-for-testing/chrome-linux64/chrome --version` fails with `libnspr4.so: cannot open shared object file`; `ldd` lists `libnspr4.so`, `libnss3.so`, `libnssutil3.so`, `libsmime3.so` and `libasound.so.2` as not found (Ubuntu 26.04; the packages `libnss3`, `libnspr4`, `libasound2t64` are available). Severity: medium. It blocks browser tests here, and may affect any other project on this desktop that launches that browser without its own library path (not checked).

## Justin's answers (2026-11-21)
- Go, with every recommended answer except Q1.
- Q1: **C, no domain.** Emails only reach the Resend account owner (Justin), and he forwards them to her. Her-inbox AC13 must be amended to fit this.
- Q2 A, Q3 A, Q4 A, Q5 A, Q6 A, Q7 A.
- Q8: **A, Full pipeline.**
- Amended for Q1 = C on 2026-11-21 by the planner: see "Amendments" at the top.
