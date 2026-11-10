# Role: reviewer (round 2: fix round 1 and what it touches; report only): site-media-upload

You are a fresh reviewer who never saw the build or the fix (**Opus 5.5, high**). Review only: change no source or
test, commit nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other
worktrees (read them with `git show`).

## The one rule above all others in this job
This job builds the first tool that writes to WordPress (`npm run site:upload`). **You never run it, or any upload,
against a real site: not Justin's staging, not bdryswi.com, not any host that isn't 127.0.0.1 / localhost.** Every run
of the uploader talks only to the local WordPress stand-in (`test/fixtures/wp-standin.ts`) or stand-ins of your own on
127.0.0.1 (a second "other host" is another 127.0.0.1 port or a `*.test` name mapped to 127.0.0.1). **You use no login,
no Application Password and no key of any kind, and you never ask for, look for, read or print one** (not from the
environment, the repo, `.git/config`, a credential helper, a file under the home folder, or the panel's storage):
probes use made-up passwords that exist only in the probe. Never load bdryswi.com, B-Dry staging or any live site;
read-only GETs of WordPress's or Bricks' public source code are fine. Justin's standing rule — "Never write to any
WordPress site; GET/read only, and ask me before using any login." — binds you fully; only Justin, in his own
terminal, ever runs the finished tool against his site.

**Importer rule (Justin, 2026-11-02; a second review only to check a major fix):** report as P0–P2 only bugs a real
site or normal use hits (Justin running `npm run site:upload` on a real capture against his own WordPress, stopping
and re-running it, then pasting into Bricks), each with a concrete real-use scenario. Edge cases are P3. **This job's
guards are P0/P1 when they fail:**
- the password reaching any file, output, log, error text, command line, environment, record, `media.json` or paste,
  or being sent anywhere but the typed site's REST API over https;
- any write other than adding media on the typed site: a PUT/PATCH/DELETE, a POST to anything else, a change to an
  item the run didn't create, an alt Justin edited overwritten on a re-run;
- **any request, with or without the password, to a host other than the typed one**;
- a path that skips the typed `yes`, the login check or the terminal check; a dry run that sends or writes anything;
- the tool adopting, as its own upload, a media item that isn't the picture it sent.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-media-upload/plan-approved.md`
  (AC1–AC16; AC15, AC16 live). **Known, not findings:** the plan lines a planner amends after this review are listed
  in the ledger ("Fix pass 1"): Q6 / AC1's AVIF words; AC11's killed-run sentence (the fix removes the duplicate that
  sentence allowed); R1-3's decision (stop on a refused AVIF, or skip and name it).
- Branch `site-media-upload-fix1`, head `c66ded408ca965502ec0f2f7c3038645cf364532` (code head `5abb8510`; the last
  commit is docs), base `2879e4968438e7a442594d1021cb024dd85b3976` (`main` has since moved to `7eeca437`: a later step
  moves the job). In your own worktree: `git checkout --detach c66ded408ca965502ec0f2f7c3038645cf364532`, confirm HEAD
  and a clean status. **Your scope: `git diff ff35a890..HEAD` (12 commits) and what it touches**, read against `git
  diff 2879e496...HEAD` where the fix meets the rest of the story.
- Review 1: `evidence/site-media-upload/review-1/review.json`, its probes `~/.cache/smu-r1/`. The fixer's receipts
  (read, don't trust): `evidence/site-media-upload/fixer-1/` (`r1-*-red.log` / `-green*.log`, `mutation/`). Recorded
  limits: `evidence/site-media-upload/follow-ups.md` and HANDOFF's "Known limits" in the job's section (don't
  re-report what is recorded unless you rate it higher, with a scenario).
- The fixer's words, each for you to check:
  - **A heard stop** (SIGINT / SIGTERM / SIGHUP; `tools/lib/site-upload/stop.ts`): no new upload starts (the
    uploader's new `stop()`), the tool waits at most 65 s for the uploads in flight, saves every answer in the record,
    writes `media.json` and the pastes as a half-way run does, prints "Stopped. N of M pictures are in your media
    library; run the same command again to finish.", exits 130 / 143 / 129; a second stop ends it at once and still
    saves the record.
  - **An unheard stop** (kill -9, a power cut, a lost connection): just before each file is sent its name and type go
    into a new `sent` list in the record (the uploader's new `onSend` hook; the panel leaves it out); the next run,
    after the login and before the `yes`, reads the library's 100 newest items once (`GET wp/v2/media?per_page=100`),
    then **reads, with no login, the file of each item named the way WordPress names that file** (x.png, x-1.png; a
    -scaled or -rotated item through its `original_image`) and takes an item only when that file holds the very bytes
    it sent (`tools/lib/site-upload/sent.ts`).
  - **Scrubbing** (`tools/lib/site-upload/scrub.ts`): every line the tool prints loses the password as typed and
    without spaces, `user:password` in base64 (also JSON-escaped, base64url and URL-encoded), and anything shaped
    `Basic <b64>` or an `Authorization:` header.
  - **`guardFetch` now requests with `redirect: "manual"`** (was `"error"`) and refuses any 3xx itself, naming the
    route and where it goes; a bot-check page on the REST index gets the panel's advice.
  - R1-5's exit-1 test; R1-7's false note gone; HANDOFF's live steps start with the re-capture.

## Check hardest (your own stand-ins on 127.0.0.1 that log every request with its headers and body; drive the tool
through a pseudo-terminal; a made-up password)
1. **Where the new reads go — the guard this fix could break.** The rerun reads "the file of each item" to compare
   bytes: from which address? A media item whose `source_url`, `guid`, `media_details.sizes[].source_url` or
   `original_image` address is on **another host** (an offload-to-CDN plugin; a stand-in answering with a second
   127.0.0.1 port or a mapped name), on http, on another port, a protocol-relative or relative address, a
   `user:pass@` address, a redirecting address, `file:` / `data:`: is any request sent off the typed origin; **is the
   Authorization header ever on a file read** (the fixer says no login: prove it on every one); does the read go
   through `guardFetch`; is the size bounded (a 2 GB answer, a slow drip: can a hostile or broken site hang or fill
   the tool?); how many GETs can one rerun send at most (100 items × sizes × copies)?
2. **`redirect: "manual"`.** With `"error"` a redirect could never be followed; now the code must refuse it. Every
   call site of `guardFetch` (the index, `users/me`, the list GET, the file reads, the upload POST, the alt): a 301,
   302, 303, 307, 308 and a 300 with a `Location` to another origin, to http, to the same origin: is the body or the
   `Location` ever requested, does the password ever travel again, is the refusal one plain line? Node's fetch with
   `manual` returns the 3xx itself: does any caller treat a 3xx as success (`res.ok` is false, but a caller reading
   `status < 400`)? An upload POST answered 307: is the picture counted as sent, and does the `sent` list then adopt
   anything on the rerun?
3. **Adoption is exact.** The rerun takes an item only when its file holds the very bytes sent: try two different
   pictures with one file name; the same bytes uploaded earlier by Justin by hand under that name (adopted: is that
   right and harmless? it only reads); a picture WordPress scaled (`-scaled`, `original_image`), rotated, or converted
   (a host that turns uploads into WebP / AVIF: bytes differ → a duplicate, the recorded limit); an item deleted from
   the library since; a `sent` entry whose upload never reached the site; a record edited or half-written by a power
   cut (the record's own write: atomic? a truncated JSON on the next run: a plain line, or a crash, or a silent fresh
   start that re-uploads everything?); `sent` entries never pruned; a second site typed with the first site's record.
   A rerun with nothing waiting still sends GETs only and the same count as review 1 saw (AC9).
4. **A heard stop.** Each signal after the first answer and with three in flight: every finished upload is in the
   record, each file's POST exactly once across the stopped run and the rerun, the pastes written by the stopped run
   work (`sourceUrl`, the mapped pictures, the rest on old addresses, named), exit codes, the terminal's echo back
   (pty), nothing printed after the prompt returns, no orphan process; Ctrl+C at each earlier moment (while the
   password is typed, at the `yes`, during the login check, during the list GET, during the file reads); a stop when
   the terminal is already gone (SIGHUP: are the files still written?); the 65 s wait against a site that never
   answers; a second Ctrl+C: the record saved, nothing lost that had answered.
5. **Scrubbing.** Is there any print path that does not pass through it (a stack trace from an unexpected throw — the
   fixer's own mutant S11 is "not reached by any test": write the probe that reaches it; Node's own warning or
   unhandled-rejection output; the panel's shared modules printing through `console`)? Does it ever eat a line Justin
   needs (a site named "Basic …", a picture address holding a long base64 run) or corrupt `media.json` / the pastes
   (it must touch output lines only, never files it writes for Bricks)? Evidence logs of the fixer hold no
   password-shaped text (`gitleaks` or a grep over `fixer-1/`).
6. **The panel is unchanged** (AC12): the uploader's new `stop()` and `onSend` are inert when the panel doesn't use
   them; `guardFetch`'s change is the tool's own; `BROWSER_CHECK` / `LOWER_PROTECTION` exported, their text
   unchanged; `src/ui` still builds for the plugin and `tsconfig.sandbox.json` is clean; the story pins (AC4, AC12,
   AC13) pass and stay out of the default suite.
7. The amended test oracles are honest (AC11's killed-run case: "6 minus what the library holds, each file in the
   library once"; the guard unit test's `"manual"`): no assertion narrowed beyond what the fix changes (read `git
   diff ff35a890..HEAD -- test/`). The tests can fail (read the mutant receipts; two mutants of your own on the stop
   and the file reads under the 4 GB cap).

## Work
Load `requesting-code-review`, `code-review-practice` and `security-best-practices`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md`, the repo `CLAUDE.md` (the upload, picture and WordPress rules) and
`reference/bricks/README.md` ("Paste rules"); read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.
1. Review the fix for real bugs.
2. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-media-upload/review-2/review.json`, then self-check:
   `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
   2879e4968438e7a442594d1021cb024dd85b3976 /home/justin/.hermes/plans/figma-to-bricks/evidence/site-media-upload` (exit
   2 means your file is wrong: fix it). Put nothing password-shaped in any file you write. Say whether R1-1 is closed.

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/smu-r2/t1`,
  a separate one for each script you start at the same time); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`
  (one Chrome job of your own at a time, closed after; stop it by the PIDs of its own profile path; never `pkill -f
  <pattern>`). A worktree's `node_modules` may lack `.bin`, and a `git archive` scratch tree has neither `tsc` nor
  `node_modules` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's
  `node_modules` in). Scripts written with Write; probes and logs under `~/.cache/smu-r2/` (a restart empties `/tmp`).
  The tool's record file belongs under a scratch `HOME` / config folder in your probes, never the real
  `~/.config/figma-to-bricks/`.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0` (export
  variables first; no `--setenv=PATH`). Waits under 115 s. The PC lost power twice this week: keep notes and finished
  probe results on disk; when resumed, read them first.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario), R1-1 closed or not, `verdict`, `ac_status` (per AC:
what the review saw), a line confirming you ran the uploader against nothing but 127.0.0.1 stand-ins and used no real
login, then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; `enforce` is `none` or
a one-line check proposal; never edit skills or memory), ending with: `MAIN SESSION: check and save these
skill_lessons now.`
