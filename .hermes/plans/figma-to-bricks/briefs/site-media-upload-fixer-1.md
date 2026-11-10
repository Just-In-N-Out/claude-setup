# Role: fixer (round 1: review 1's R1-1, plus the cheap P3 steps named below): site-media-upload

You are a fresh fixer for FigmaToBricksV2 (**Opus 5.5, high**). Fix review 1's one P2 test-first, plus the small steps
named below, then stop at `ready-for-review`. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`,
never bare `git stash`, never push or merge, don't bump `BUILD`, don't rebase (`main` is at `7eeca437`; a later step
moves the job), leave other worktrees alone, start no agents. Nothing paid.

## The one rule above all others in this job
This job builds the first tool that writes to WordPress (`npm run site:upload`). **You never run it, or any upload,
against a real site: not Justin's staging, not bdryswi.com, not any host that isn't 127.0.0.1 / localhost.** Every run
of the uploader, in tests and by hand, talks only to the local WordPress stand-in (`test/fixtures/wp-standin.ts`).
**You use no login, no Application Password and no key of any kind, and you never ask for, look for, read or print
one** (not from the environment, the repo, `.git/config`, a credential helper, a file under the home folder, or the
panel's storage): tests use made-up passwords that exist only inside the test. Never load bdryswi.com, B-Dry staging or
any live site; read-only GETs of WordPress's or Bricks' public source code are fine. Justin's standing rule — "Never
write to any WordPress site; GET/read only, and ask me before using any login." — binds you fully; only Justin, in his
own terminal, ever runs the finished tool against his site (the plan's live ACs). **No fix may weaken a guard:** the
password in no file, output, command line or environment; requests only to the typed origin with no redirect
followed; only GET and the media upload; the typed `yes`, the login check and the terminal check never skippable; a
dry run sends and writes nothing.

**Skills to load:** `receiving-code-review`, `engineering-best-practices`, `test-driven-development`,
`mutation-testing-discipline`, `security-best-practices`, `git-commit-rules`. Read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md`, and the repo `CLAUDE.md` (the upload, picture and WordPress rules; "Photos as AVIF:
never fall back silently").

## Your copy (you start in your own worktree)
`git checkout -B site-media-upload-fix1 ff35a890590549d922da07ec3402d5aa003237b4` (the reviewed head, branch
`site-media-upload-build`, on `2879e496`), confirm `git rev-parse HEAD` and a clean status. Report your branch.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-media-upload/plan-approved.md`
  (AC1–AC16; AC15, AC16 live; Q1–Q11 ⭐ taken).
- Review 1: `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-media-upload/review-1/review.json`; its probes
  under `~/.cache/smu-r1/` (read only; they hold only a made-up password). The builder's receipts:
  `evidence/site-media-upload/builder/`. Deferred items: `evidence/site-media-upload/follow-ups.md`.

## The finding
**R1-1 (P2, `tools/site-upload.ts:88`):** Ctrl+C (or closing the window) while pictures are going up kills the tool
with up to 3 uploads in flight. WordPress finishes them, but the record never gets them, so the next run uploads them
again. The reviewer's probe (a slow stand-in, SIGINT after the first picture, then a rerun): 8 POSTs for 6 files; two
files are in the library twice, named `-1` / `-2`. Real use: Justin stops a slow upload of B-Dry's 33 pictures and
reruns; two or three pictures end up in his media library twice.
- Fix as a rule: **a stop the tool can hear never loses an upload it has sent.** On SIGINT / SIGTERM / SIGHUP during
  the upload: start no new upload, wait for the ones in flight to answer (bounded: say how long, and what is printed
  while waiting; a second Ctrl+C must still end the tool at once), save the record with every answer that came back,
  write the pastes for what went up as a stopped-half-way run does (AC11), restore the terminal, exit 130 (or the
  signal's code). Say in one plain line what happened ("Stopped. N of M pictures are in your media library; run the
  same command again to finish.").
- **And for a stop the tool can't hear** (SIGKILL, a power cut, a lost connection after the request was sent): the
  rerun must not upload a file the library already holds from the earlier run. Decide how the rerun can know with
  reads only (for instance: before uploading a picture the record doesn't have, a GET search of the site's media for
  the name this tool gives it — the `-image` rule — and a match by a property the tool itself set or can verify, such
  as the file's size or a hash kept in a field WordPress stores), and say what it costs in requests. It must stay
  GET-only on a rerun that has nothing to upload (AC9), must never adopt a media item that isn't this picture (a
  different file with the same name), and must never change or delete an existing item. If no honest reads-only way
  exists, say so, keep the signal fix, and write the limit and its cure (delete the `-1` copy by hand) plainly in
  HANDOFF and in the tool's own stopped-run line.
- Test first (RED on `ff35a890`): the slow stand-in, a stop by each signal after the first answer and while three are
  in flight, then a rerun: the stand-in's log holds each file's POST exactly once across both runs, the record holds
  every item the site created, the pastes work after the stopped run, exit codes as the plan says, the terminal's echo
  is back; and the kill -9 case with whatever the rule above gives.

## Small, each a few lines with a test, else leave recorded
- **R1-2 (`src/ui/wordpress.ts:48`; do this one):** WordPress's error message is printed word for word; a site whose
  error answer echoes the Authorization header would put the encoded login in the terminal. Before any text from the
  site is printed or written by `site:upload` (a login failure, a picture's reason, an exception's message or stack),
  take out the password as typed, with its spaces removed, and the Basic `user:password` base64, and anything shaped
  `Basic <base64>` / an `Authorization:` header line. Do it in the tool's own output path (one place every line goes
  through), without changing what the panel prints (AC12: the panel sends the same requests and behaves as on main).
  Test: the stand-in echoes the header in a 401, a 403, a 500 and a picture's refusal; nothing password-shaped in
  stdout, stderr or any file.
- **R1-5:** a test for exit 1 when a picture fails without stopping the run (a 413, a refused type); the reviewer's
  mutant `ok: !o.stopped` must die.
- **R1-7 (`convert.ts:203`):** in section mode with `--media`, a background already moved to the library no longer
  gets the note "the capture doesn't hold its file".
- **R1-8 (`guard.ts:296`):** a redirect on `users/me` or on an upload is reported as a redirect (naming where it
  goes), not with the "Couldn't reach the site… firewall" sentence; an index answered by a bot-check page gets the
  advice the panel gives for it.
- **R1-4 (HANDOFF):** the live check's numbered steps start with the re-capture (paste check 3do: `npm run capture --
  https://bdryswi.com/` with this build, `capture:check`), because the tool refuses the saved 2026-11-09 capture
  ("capture the page again"); then the dry run, the upload, the second run, the paste. One action a step, naming
  exactly what he types and sees.
- **R1-3 (wording only; the behaviour is Q6 as taken: a refused AVIF stops the run and says why):** the stop's line
  tells Justin what to do (WordPress 6.5 or later takes AVIF; else allow the type on the site), and that a rerun stops
  at the same picture until then. Record for the planner and Justin, don't build: whether a refused type should stop
  the run or be skipped and named.
- Leave R1-6 alone (a note for the later stack step onto site-native-structure: its fold writes a linked picture's
  Image itself, bypassing `imageSettings` and the picture list); it is recorded.

## Work
1. Verify each finding yourself first (the reviewer's probes, then your own). Push back with evidence if one is wrong.
2. Each fix test-first, one commit each; mutate what you add (each new condition removed in turn is killed by a named
   assertion, never a crash; the signal handling and the scrubbing above all) under `systemd-run --user --scope -p
   MemoryMax=4G -p MemorySwapMax=0` (export variables first; no `--setenv=PATH`).
3. Records batched into your commits: HANDOFF's site-media-upload section (a stopped run; the scrubbing; known limits)
   and the ledger ("Fix pass 1"; the plan lines that need amending: Q6 / AC1's AVIF words as the builder's deviation 1
   and the reviewer found them); append what you defer to `evidence/site-media-upload/follow-ups.md`. The paste check
   stays `<site-media-upload id at merge>`.
4. Gates: both typechecks (`tsconfig.sandbox.json` too), `npm run check`, the job's unit tests, the story pins
   (`F2B_STORY_PINS=1`: AC4, AC12, AC13), `test/web/site-upload-page.test.ts` (AC14, alone under the cap),
   `test/unit/plugin-convert.test.ts`, the panel's upload tests, every AC's log starting `HEAD=` and ending `EXIT=`;
   `gitleaks` (or a grep for token-shaped values) over your evidence folder and your branch's diff. Commit after each
   passing step (plain `git commit -m`, or `-F <file>`; no author override, no AI or Co-Authored-By lines; `git diff
   --cached --name-only` without CLAUDE.md). Evidence in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-media-upload/fixer-1/` (terminal captures with no
   password in them).

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/smu-f1/t1`, a
separate one per script started at the same time); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close
every Chrome you start (stop it by the PIDs of its own profile path; never `pkill -f <pattern>`: it kills the tool's
own shell); a worktree's `node_modules` may lack `.bin`, and a `git archive` scratch tree has neither `tsc` nor
`node_modules` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's
`node_modules` in). Scripts written with Write under `~/.cache/smu-f1/` (a restart empties `/tmp`); one `bash <file>`
per Bash call. The tool's record file belongs under a scratch `HOME` / config folder in tests, never the real
`~/.config/figma-to-bricks/`. SIGTERM / 143 / 137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30
min" -o short-iso | grep sending`): say so, find what grew, rerun under the cap. Waits under 115 s. The PC lost power
twice this week and agents can be stopped by a usage limit: write each log's `EXIT=` line; when resumed, check `git
status` for half-written tracked files (exactly 8388608 bytes), read your finished logs first and never start a second
driver on a suite.

## Report (as text; don't write report files)
`status: ready-for-review`, branch, last commit (full SHA); R1-1: verified?, the rule for a heard stop and for an
unheard one (what the rerun reads, what it costs, what it can never adopt), tests, RED/GREEN paths, mutation table;
each small step done or left; the guards re-proven (which tests); gates; the plan lines for the planner; `found_else`;
a line confirming you ran the uploader against nothing but the 127.0.0.1 stand-in and used no real login; then
`skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; `enforce` is `none` or a one-line
check proposal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
