# Role: verifier (read-only): site-menu

You are a fresh verifier who never saw the build, the reviews or the fixes (**Opus 5.5, high**). Prove each acceptance
criterion yourself. Change no source or test, commit nothing, start no agents. Never edit the main folder or other
worktrees (read them with `git show`). **Never load bdryswi.com, B-Dry staging, a widget vendor's host** or any live
site (local fixture servers, the offline B-Dry stand-in site and saved files only); no logins; never write to any
WordPress site; `site:upload` / `site:import` only against the tests' own 127.0.0.1 stand-in with a made-up password.
Nothing may hide that the importer's Chrome is automated. Justin may be running his own Chrome: never stop a Chrome you
didn't start; touch nothing under `~/Downloads`.

**Skills to load:** read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (your job
and the `ac.json` format at the top of `scripts/ac-check.sh`) and follow it; the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` ("Holding a Chrome to read-only": the socket gate, how a refusal is charged; the
embeds line) and `references/rendering-validation.md`; `reference/bricks/README.md`.

## Inputs
- Approved plan (read-only; amended A1–A11, the Amendments list at its top):
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/plan-approved.md` (AC1–AC8; AC8 live: mark it
  `not_run`, owed). The job: the capture presses a page's menu / pop-up / drawer buttons under a guard (no
  data-sending request, no page load a press starts, no WebSocket handshake or message leaves while it presses —
  sockets through a gate in the capture's own process, a refusal charged only to the pressing page whose own sessions
  reported it), reads what opens, and the paste carries it as Bricks' Offcanvas; a picture the site itself put in an
  opened box goes up with `site:upload` (Justin's "Upload them too"). Find every cited test name with ac-check's own
  grep first (`command grep -E "(^|[^A-Za-z0-9_])<name>([^A-Za-z0-9_]|$)" <plan>`); read each cited test before you run
  it (a test that only asserts what a sibling collects is run with its whole file); run the "Also" tests beside, never
  cite them.
- Head `7f7e0ffe53638e2f81a40d28015dc8e9405aa437` (branch `site-menu-stack14`; the last commit is the ledger; the join
  is `b52f532b`), base (old code) main `3f4a0718d974ec66167ce788ed3fe2672df9feb6` (Build 2026-11-11.1). In your own
  worktree: `git checkout --detach 7f7e0ffe53638e2f81a40d28015dc8e9405aa437`, confirm `git rev-parse HEAD` and a clean
  status. Old code: a tree from `git archive` of `3f4a0718` with head's test files, fixtures and test-only modules
  copied in (a new module that doesn't import on base is weak RED: prove the test can fail with a one-line mutant of a
  head copy; a mutant that lets a socket or a write through runs with networking off: `unshare -rn sh -c 'ip link set lo
  up && exec unshare --user --map-user=1000 --map-group=1000 node --test …'`; preservation ACs that rightly pass on base
  are `base_exempt` with a reason and your own byte receipt). An AC log cited in `ac.json` starts with the bare
  `HEAD=<sha>` (say "archive" on its second line) and ends with one line `EXIT=`, skipped 0.
- **Known, not this job's failures:** merged jobs' env-gated story pins (`F2B_STORY_PINS=1`): site-one-command's AC11
  and AC12 fail on this job's design (four trees in `evidence/site-menu/stack-14/meet/ac11-four/`; record, don't
  count); the named-only B-Dry files fail on main by the footer's 69 px (footer-icon-list); five browser files fail
  on main on this desktop (composition-clipping, fonts, hero-pair, peer-sides, pill-holder). Known flakes: F6-5 in
  `capture-opens-guards`' service-worker cases; `site-upload-cli` / `site-upload-stop` timing tests under load;
  `capture-entrances` R7-2/R8-1; `capture-windows` AC7; the code-page fixture's 5.09 px: rerun alone before judging.
- Don't read the builder's, fixers' or reviewers' reports or folders as proof.

## Work
1. **Gates on head against base by name:** both typechecks (`tsconfig.sandbox.json` too), `npm run check` (8G scope),
   `npm run corpus` (same output as base; v1's Mac files are missing here), the **full** `npm run test:browser` and
   `npm run test:web`, file by file, each alone under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`
   (B-Dry files 8G; export variables first; no `--setenv=PATH`; a separate TMPDIR of about 24 characters per script
   started at the same time), compared with base by test name; run base's side yourself for every file whose result
   differs. The five Figma replays and `dist/code.js` against base's build: say exactly which bytes move (this job
   changes the Offcanvas emit in `src/core`) and that each is this job's. `test/unit/plugin-convert.test.ts`,
   `test/unit/sandbox-convert.test.ts`.
2. Every AC's named test on head (must pass) and on old code; a picture or terminal capture per AC (AC1–AC7: a fixture
   page's opened menu / pop-up / drawer, site | paste, at a phone and a desktop width, both Bricks samples where the
   test draws).
3. **The guard, proven by you on pages of your own** (local servers that log every request and every WebSocket
   upgrade and frame): a menu button whose drawer holds a form, a real link and a `window.open`; a pop-up whose button
   POSTs and beacons; a chat-like launcher of another origin; a same-site socket opened at load beating every 15 s; a
   press that opens sockets from the page, a running dedicated worker, a new worker, a cross-site frame and a window it
   opens. Through `npm run capture` **and** `npm run site:import` (stand-in, made-up password, answering "no"): 0
   data-sending requests, 0 page loads a press started, 0 handshakes and 0 message bytes from anything a press
   started; each stopped attempt named in the notes; the boxes and their openers read as on a quiet page of the same
   shape (other windows' sockets blame no press); what the paste holds (Offcanvas, the opener linked). Recorded limits
   (F6-*, F7-*, R8-2…R8-4, R9-1…R9-6, R10-1, R10-2 in the plan) are not failures: say what you saw for them.
4. **The pictures of an opened box** (Justin's "Upload them too"): on captures of your own (a pop-up built by the
   site's own script with a site picture; by another company's widget; by a tag manager), `npm run site:upload --
   … --dry-run` (stand-in, nothing sent) lists the site's own once as going up and the others as staying, no address
   on both lists; a real run against the stand-in POSTs each going-up file once.
5. **The offline B-Dry stand-in** (8G scope): the dry run reads the same five boxes the plan names, 0 requests that
   aren't a GET, 0 socket handshakes; the paste's header holds its Offcanvas.
6. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/verifier/ac.json` (move any older content of
   that folder aside to `verifier-old-<date>/` first, saying so) and logs in that folder; self-check it with
   `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh` on a copy (`--base
   3f4a0718d974ec66167ce788ed3fe2672df9feb6`, no `--reviews`), as the reference says.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/smv/t1`,
`t2`, …; a Chrome profile under a long TMPDIR dies with "Socket path too long");
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Close every Chrome **you** start (stop it by the PIDs
of its own profile path; never `pkill -f <pattern>`). A worktree's `node_modules` may lack `.bin`, and a `git archive`
scratch tree has neither `tsc` nor `node_modules` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on
PATH and symlink the main folder's `node_modules` in; a piped, chained or redirected git command, a heredoc, a shell
function or a word containing "git" may be refused: write such steps to a script file with Write and run `bash
<file>`; `git -C <absolute path>`). A script hosting a fixture server in its own process starts the CLI with async
`spawn`. Use `tail -n 3`, never `tail -3`. Never edit a tree a test is running against. Scripts and logs under
`~/.cache/site-menu-verifier/`. SIGTERM / 143 / 137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30
min" -o short-iso | grep sending`). `compare-corpus.test.ts` needs `--test-timeout=3600000`. Waits under 115 s; start
long drivers with `setsid --fork` and wait on `^EXIT=` in bounded loops. The PC restarted three times this week: write
each log's `EXIT=` line; when resumed, read your finished logs first and never start a second driver on a suite one
is still working through.

## Report (as text; only ac.json and logs are written)
Per AC: test, head result, old-code result (or the mutant), evidence path; the guard table (shape × route → requests,
handshakes, bytes, notes, openers); the pictures table; the B-Dry dry run; gates (the dist bytes that move, each
explained); `verdict`; `ac_status`; then `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal;
`enforce` is `none` or a one-line check proposal; never edit skills or memory), ending with `MAIN SESSION: check and
save these skill_lessons now.`
