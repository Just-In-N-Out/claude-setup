# Role: planner (a bug, Mini pipeline): capture-refused-styles — a site refuses its stylesheet (403) partway through a scan, every run, so nothing is captured

You are a fresh planner for FigmaToBricksV2 (**Opus 5.5, high**). Plan only: find the root cause with evidence and
write the plan. Change no source or test in any worktree or the main folder, commit nothing, start no agents. **Never
load bdryswi.com** (no Chrome, no curl, no fetch: it has a bot check and Justin's rule is "never without me"; the one
read he allowed is done and saved, below), B-Dry staging or any other live site of his. No logins; never write to any
WordPress site. Nothing paid. **Nothing may hide that the importer's Chrome is automated** (CLAUDE.md: no
`AutomationControlled` flag, no `navigator.webdriver` patch, no new user agent, no stealth script, nothing that clicks
or types into a site's check): a fix that works by disguise is not a fix.

**Skills to load:** the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (with
`references/testing-pitfalls.md` and `references/live-site-reading.md`), `engineering-best-practices`,
`implementation-planning`, `systematic-debugging` (prove the root cause before proposing any fix; where the real site
is the only proof, say exactly which fact is proven and which is a suspicion, and plan how Justin's next run proves
it). Read the repo `CLAUDE.md` in full ("Build general logic": a general rule for every scanned site, never keyed on
bdryswi.com or WordPress.com by name) and HANDOFF's sections for staging-fit-capture (Build 2026-11-09.4: the re-read
and the stop this job's failure line comes from), capture-speed (Build 2026-11-08.2: ranges read in separate Chrome
windows, "asks the site for the page once per kind of visitor", the retry on a lost connection), web-human-check and
"Capturing a live page"; the code: `tools/capture.ts`, `src/web/capture*.ts`, `src/web/human-run.ts`, `src/web/human.ts`,
`src/web/read/*`, `test/browser/chrome.ts`, and wherever the stylesheet check and its 3 tries live.

## The report (Justin's real runs, 2026-11-10, Build 2026-11-10.7, main `7ec16d60`)
Both runs: he passed the site's "I am human" check in the visible window ("Check passed: capturing bdryswi.com in that
window"), the tool printed "Switch points found: 1366, 1024, 1023, 991, 921, 834, 768, 767, 600, 576, 479, 440, 412,
393, 360 (32 boundaries checked)", then:
- 4 windows (the default): "Failed: https://bdryswi.com/: The page loads for widths 769–834 px never got the site's
  stylesheet https://bdryswi.com/_jb_static/ (answered 403) in 3 tries, so those widths would be read without the
  site's styles and nothing was captured. Press Capture to try again."
- `--windows 1`: the same line for widths 1025–1366 px.
His words: "again did not work at all." Until this is fixed there is no clean scan of that site to paste, upload or
measure, and the one-command job being built (site-one-command) stops at its scan step the same way.

Older runs of the same family (input files, read-only):
- `~/Downloads/bdryswi-com-home.f2b-capture.json` (2026-11-07, 445 KB): `npm run capture:check` says "page reloaded
  itself: the 1024-1024 page load reloaded itself while it was read … page answered HTTP 403: the server answered the
  1024-1024 page load with an error". Read what it recorded of that 403.
- Justin's 2026-11-09 capture read 768–991 without the site's stylesheets (find it and its analysis under
  `~/.hermes/plans/figma-to-bricks/evidence/staging-fit-capture/` and `staging-fit/`): what did that run record about
  the stylesheets that failed (addresses, statuses)?
- The clean captures of that site that exist (`~/.hermes/plans/figma-to-bricks/evidence/bdryswi-com-home-2026-11-04-*.f2b-capture.json`;
  B-Dry's stand-in under `evidence/site-native-structure/inputs/`): what was different about those runs (build, number
  of page loads, windows, the order of loads)?

The one read Justin allowed (the main session, 2026-11-10T23:18Z; files
`~/.hermes/plans/figma-to-bricks/evidence/capture-refused-styles/planner/one-read*`): a single curl GET of
`https://bdryswi.com/_jb_static/` answered HTTP 400 (the bare address carries no file list), `server: nginx`,
`host-header: WordPress.com`, `x-ac: 32.jfk _atomic_dca MISS`, IP 192.0.78.25. So the site is hosted on WordPress.com
(Atomic) and `/_jb_static/` is its combined-files endpoint (page-optimize / Jetpack Boost), answered by WordPress.com's
edge. Public documentation of that host's protections (its "defensive mode" challenge, rate limits on the edge, what
the combined-files endpoint refuses) may be read on the web; the site itself may not.

## The questions the plan must answer with evidence
1. **What exactly does the capture ask the site for, and how often?** Count, from the code and from a run against a
   local fixture site that logs every request: page loads and stylesheet requests per scan (switch-point finding, each
   range, each "kind of visitor", each retry, each window), whether Chrome's HTTP cache is on or off for those loads
   and whether windows share a profile and its cache and cookies (the person check's cookie included), the pacing
   between loads, and what the 3 tries do (how long apart; the same connection; the same address). Why does the failure
   line show the address without its query (`/_jb_static/`): is the query dropped only in the printed line, or in what
   the tool asks for? A browser a person resizes asks for that stylesheet once; how many times does one scan ask?
2. **The root cause, as far as it can be proven without the site:** which of these explains "the first loads get the
   stylesheet, a later load is refused 403, the range differs run to run": a rate limit on the edge by request count
   or burst; the check's cookie not sent on a later load (a new window, a new profile, a stripped header); the tool's
   own repeat request differing from Chrome's (headers, a dropped query, a HEAD); the cache disabled so every load
   re-asks for a file a browser would have kept. Reproduce each candidate's shape on a local fixture server (one that
   refuses a stylesheet after N requests in M seconds; one that refuses without a cookie; one that refuses an address
   without its query) and say which shapes the current code survives and which it doesn't.
3. **The fix, as general rules for any site whose protection turns a scan away partway (never by disguise):**
   candidates to judge with evidence, not taste: (a) ask for less: keep Chrome's cache on across a scan's loads, or
   read ranges by resizing one loaded page where that gives the same reading, so a stylesheet the site already gave
   this run isn't asked for again; (b) reuse, for a refused stylesheet, the bytes the site itself gave this run for
   that exact address (and only that), saying so in the capture; (c) pace and back off: on a refusal wait and retry on
   a schedule a rate limit forgives (how long? what does the host document?), one window, saying what it is doing;
   (d) when the site still refuses: keep what was read (the ranges that did load) for a later run to finish, and print
   what answered (status, the server's headers that name the protection, the first bytes of the body) with what the
   person can do in plain words (wait N minutes and run again; ask the site's owner to allow this computer or turn the
   protection off for the scan). For each: what it changes for sites that work today (captures byte for byte as before
   but for the fields you name), what it costs in time, and how a local fixture proves it.
4. **The diagnostic for Justin's next run:** whatever the fix, his next real run must leave evidence: a log beside the
   capture (or in the failure output) of every request the site refused (address with its query, status, the response
   headers, the first 300 bytes), and the scan's count of loads, with nothing private in it. Plan it as part of this
   job.
5. **The wording:** the terminal's failure line says "Press Capture to try again" (the Figma panel's words). The CLI
   says what to type; the panel keeps its own words.
6. **Does it need a decision from Justin?** If the honest answer is "this host refuses automated visitors after N
   loads and only the site's owner can allow the scan", say so plainly at the top with a ⭐ recommended answer and the
   one-line trade-off; if a candidate changes what a capture is (reused bytes), put that as a ⭐ question too.

## The plan
- Write `~/.hermes/plans/figma-to-bricks/capture-refused-styles.md` (the builder copies it to
  `docs/plans/2026-11-10-capture-refused-styles.md` as its Task 0), a plan a fresh agent with no context can build
  from: the playback in plain words; the root cause with file:line evidence, proven facts and suspicions told apart;
  **numbered acceptance criteria AC1, AC2…, each with one named test, each test name whole on one plan line** (a line
  that isn't an AC's definition never starts with a list marker, table pipe or heading followed by `AC<n>`); proposed
  ACs marked **(proposed)**; an AC only Justin can check tagged `(live)` right after its id (his own scan of
  bdryswi.com ends with a clean capture, or with the plain line naming what refused it and what to do); tasks
  test-first with RED on base (prove each planned RED by applying only the test to a clean export of the base); open
  questions at the top with a ⭐ answer each. The pipeline is **Mini**
  (`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/mini-pipeline.md`; Justin chose it): keep the fix
  the size of the cause; say plainly if it can't be Mini.
- The ACs must include: on a generic local fixture that refuses a stylesheet the way you proved (after N requests;
  the range that fails differing run to run), the scan ends with a clean capture whose styled ranges equal a capture
  of the same fixture with the refusal off; a fixture that refuses for good ends with the plain line (what answered,
  what to do, the CLI's own words) and the refused-requests log, exit 1, no capture a later tool would accept as
  clean; a scan of a site that refuses nothing is byte for byte as before but for the fields you name, and no slower
  than base beyond a margin you measure; nothing hides the automation (the existing guard test still passes; name
  it); the panel's helper route behaves the same way with its own words.
- Base: `main` `7ec16d6060a76b441e42581b78ad3a502461fd66` (Build 2026-11-10.7; check `git rev-parse main`). Jobs moving
  beside it, not merged (say where this job would conflict and keep its changes out of their lines where it can):
  site-menu (`site-menu-fix6`: the capture's press step and its request guard; the Chrome launch lines in
  `tools/capture.ts`), site-one-command (`site-one-command-build`: moves the launch line of `tools/capture.ts` into a
  new `tools/lib/capture-run.ts` and calls the capture's flow from a new command: this job's fix must reach that
  command too, through the shared code), footer-icon-list (the capture's reader `src/web/read/code*.ts`).
- You may run tests and probes on `git archive` scratch copies against local fixture servers only (never in the main
  folder's tree beyond reading); scratch under `~/.cache/capture-refused-styles-planner/`; evidence under
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/capture-refused-styles/planner/`.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters
(`~/.cache/crs-p/t1`); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; one Chrome job at a time,
closed after (stop it by the PIDs of its own profile path; never `pkill -f <pattern>`, never a Chrome you didn't
start: Justin may be running his own); a `git archive` scratch tree has neither `tsc` nor `node_modules` (put
`/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's `node_modules` in; one
plain git command per call, `git -C <absolute path>`). A probe that serves a fixture site in its own process spawns
the CLI with async `execFile`, never `execFileSync`. Heavy runs under `systemd-run --user --scope -p MemoryMax=4G -p
MemorySwapMax=0` (export variables first, no `--setenv=PATH`). SIGTERM / 143 / 137 or "Killed" may be earlyoom
(`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`). Waits under 115 s. The PC restarted three
times this week and agents can be stopped by a usage limit: keep notes and results on disk; when resumed, read them
first. Touch nothing under `~/Downloads` (read the one capture file there, change nothing).

## Report (as text)
The plan's path; the root cause in three plain sentences (proven facts, then suspicions); how many times one scan asks
the site for the page and for that stylesheet; the fix in plain words and what Justin does differently, if anything;
the ACs one line each (the `(live)` ones named); the questions with their ⭐ answers, and whether one is a decision
for Justin; whether it stays Mini; where it conflicts with the moving jobs; then `skill_lessons[{skill, lesson,
evidence, enforce}]` (reusable only; empty is normal; `enforce` is `none` or a one-line check proposal; never edit
skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
