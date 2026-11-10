# BLIND AC AUDITOR (read only): site-media-upload (`npm run site:upload`: a scanned page's own pictures go to the user's WordPress media library, from the command line)

You are a fresh auditor (**Opus 5.5, high**). Independently prove the approved acceptance criteria. You have never seen
a builder, reviewer, fixer or verifier report. Stay blind: never open anything under
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-media-upload/` except `plan-approved.md` and your own
`auditor/` folder (never `builder/`, `fixer-*`, `review-*`, `verifier*`, `stack-*`, `follow-ups.md`,
`plan-approved-v*`); nor HANDOFF, ledgers, the plan copy under `docs/plans/`, or session notes. Source and tests are
read-only; commit nothing; start no agents.
**Justin (2026-11-02): "focus on building and not too much of edge cases."** An AC fails when its own text is broken (its
named test, or a realistic case its words cover); an edge case beyond its text goes in `found_else`.

## The one rule above all others in this job
This job builds the first tool that writes to WordPress. **You never run `site:upload`, or any upload, against a real
site: not Justin's staging, not bdryswi.com, not any host that isn't 127.0.0.1 / localhost.** Every run talks only to
the local WordPress stand-in the tests start (`test/fixtures/wp-standin.ts`) or a stand-in of your own on 127.0.0.1 (a
second 127.0.0.1 port stands for "another site"). **You use no login, no Application Password and no key of any kind,
and you never ask for, look for, read or print one** (not from the environment, the repo, `.git/config`, a credential
helper, a file under the home folder, or the panel's storage): runs use made-up passwords that exist only in the run.
Never load bdryswi.com, B-Dry staging or any live site. Justin's standing rule — "Never write to any WordPress site;
GET/read only, and ask me before using any login." — binds you fully; only Justin, in his own terminal, ever runs the
finished tool against his site. A mutant that removes a refusal can reach out: run such mutants with networking off
(`unshare -rn`, or a preload that throws on `net.connect` and `fetch`).

## The only inputs
- Approved plan (amended A1–A7; its Amendments list is at the top):
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-media-upload/plan-approved.md` (AC1–AC16; AC15 and AC16
  are `(live)`, owed to Justin: mark them `not_run`). Judge each AC by its amended words. Use each exact test name the
  plan cites: find them all first with ac-check's own grep (`command grep -E
  "(^|[^A-Za-z0-9_])<name>([^A-Za-z0-9_]|$)" <plan>`); where the runner prints a name differently, cite a phrase that
  sits whole on one plan line and run the test by its full printed name through a by-name checker, as
  `ac-verification.md` says. Run the supporting tests the plan's "Also (supporting…)" lines name beside the cited
  ones, and never cite them. The story pins (AC4, AC12, AC13) run only with `F2B_STORY_PINS=1`.
- Head `c1b52ce2751fe18229d5ac7484e69ec9efff3114` (branch `site-media-upload-stack8`), base
  `7eeca437ea100c821bcfb82cdbbe516a023ff097` (`main`, Build 2026-11-10.4), your own folder
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-media-upload/auditor/` (empty).

## Your copy
In your own worktree: `git checkout --detach c1b52ce2751fe18229d5ac7484e69ec9efff3114`, confirm `git rev-parse HEAD` and
a clean `git status --porcelain --untracked-files=all` (after a machine restart, look for tracked files of exactly
8388608 bytes and restore them with `git checkout --`; `git cat-file -t HEAD`). Your `ac.json` names this head and
base. Never write in any other worktree or the main folder.

## Work
Load `engineering-best-practices`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
with `references/testing-pitfalls.md` and `references/live-site-reading.md`; `reference/bricks/README.md` ("Paste
rules"); the repo `CLAUDE.md`'s upload, picture and WordPress rules; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and the report format at the top
of its `scripts/ac-check.sh`; follow the blind auditor procedure there. For every runnable AC make your own head and
base runs (an AC log starts with the bare `HEAD=<sha>` and ends with one line `EXIT=`, skipped 0; the named assertion
must run, pass on head and fail on base for new behaviour; a setup or import failure of a new module is weak RED: add
a supporting base run with head's new-only source files so the test fails on its own assertion — **and where that
hybrid tree passes because the AC's guarantee lives wholly in new files (the tool's own guards), prove the test can
fail with a one-line mutant of a head copy instead**; preservation that rightly passes on base is `base_exempt` with a
specific reason, backed by your own byte-identity probe). Also:
- **The guards, proven by you — the thing to prove hardest.** Your own logging stand-in WordPress on 127.0.0.1 (every
  request's method, path, headers and body kept; a second port as "another site"), the tool driven through a
  pseudo-terminal (Python's `pty`, or `script -qec`), a made-up password with spaces, non-ASCII letters and signs
  (so its base64 holds `/`, `+` and padding):
  - the password, as typed, without spaces, as `user:password` in base64 (plain, URL-safe, JSON-escaped, URL-encoded)
    is in no file the tool wrote (the record, `media.json`, the pastes, the out folder, the scratch `HOME`), no output
    on any ending (success; a wrong password; a 401, 403 and 500 whose body echoes the Authorization header, on the
    login check and on an upload; a lost connection; Ctrl+C; an unexpected exception), and not in `/proc/<pid>/cmdline`
    or `environ` of the tool or its children while it runs;
  - before the password is asked or sent the tool refuses: plain http to a non-loopback name, a login inside the
    address, an index that redirects (301, 302, 307, 308; to another origin and to the same one), an index naming
    another host or another folder, and a run with no terminal; no flag or answer but a typed `yes` uploads (`--yes`,
    `-y`, `--force`, `y`, `YES`, an empty line); a dry run sends no request (run it with networking off) and writes
    nothing (an existing record's bytes and mtime unchanged);
  - over a first run, a second run, a run stopped by Ctrl+C with uploads in flight and its rerun, and a run killed
    with SIGKILL with uploads in flight and its rerun: the stand-in saw only GETs and `POST wp/v2/media`; each file's
    POST exactly once across a stopped or killed run and its rerun; nothing at all on the second port, also when the
    library's list names a file address there; no Authorization header on the rerun's file reads; a 307 on the login
    check and on an upload is named and never followed; a picture never counted as uploaded after a refused upload;
    the terminal's echo is back after Ctrl+C;
  - a rerun never takes as its own a library item whose file isn't the bytes it sent (the same name, other bytes);
  - `npm run site … --media <file>` opens no socket (run it with networking off) and writes the same pastes as the
    upload did; without `--media` every paste is byte for byte base's.
  Show your harness can see a leak: for three guards, a control on a scratch head copy with the guard removed
  (networking off) turns the harness red.
- Your own mutation proof for the rule's guards under the 4 GB cap (each on a scratch copy, restored by hash; a
  mutant is killed when the AC's named test fails on its own assertion): the redirect refusal, the origin check, the
  typed `yes`, the terminal check, the dry run's early return, `syncAlts: false`, the `sent` list (`onSend`), the
  byte comparison before adopting an item, the scrubber's forms, the media map reaching Image elements and CSS
  backgrounds, `sourceUrl` set only on a part that shows a library picture.
- AC14: your own run and pictures (site | paste of the fixture page with its uploaded pictures, at 1440 and 390).
- Preservation: every paste of five saved captures or fixtures of your choice without `--media`, both routes, byte
  for byte between base and head; the five Figma replays of the repo's real files and `dist/code.js` byte-identical;
  the panel's upload requests the same on both trees (AC12: run each tree's own uploader against your stand-in).
- A screenshot per AC (a terminal image for a non-visual AC, with nothing password-shaped in it).
- Run `git log -p 7eeca437..HEAD -- <each AC's test files>` and read every assertion against the amended plan.
Write `auditor/ac.json`, then self-check by copying your report and receipts to a fresh scratch folder and running
`ac-check.sh` on them (`--base 7eeca437ea100c821bcfb82cdbbe516a023ff097`, no `--reviews`). Before you finish, grep your
`auditor/` folder for anything password-shaped (your made-up password in every form) and redact it.

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters and a separate one for
  each script you start at the same time (`~/.cache/smu-a/t1`, `t2`); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`.
  Other agents run Chrome too: close every Chrome you start (stop it by the PIDs of its own profile path; never `pkill
  -f <pattern>`: it kills the tool's own shell). Every run of the tool uses a scratch `HOME` (link
  `.cache/chrome-for-testing` and `.cache/chrome-libs` into it when a run needs Chrome), never the real
  `~/.config/figma-to-bricks/`. A browser or web run counts only with `skipped 0` for the AC's tests. A worktree's
  `node_modules` may lack `.bin`, and a `git archive` scratch tree has neither `tsc` nor `node_modules` (put
  `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's `node_modules` in; a
  piped, chained or redirected git command is refused: `git archive -o <file> <sha>` in its own call, then untar in
  the next). Run multi-step commands from a script file written with Write, paths spelled out; keep scripts and logs
  under `~/.cache/smu-a/` and copy them to `auditor/scripts` (a restart empties `/tmp`). Never edit a script a
  background run is executing.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min"
  -o short-iso | grep sending`); heavy and mutation runs under `systemd-run --user --scope -p MemoryMax=4G -p
  MemorySwapMax=0 <cmd>` (the parallel unit suite may need 8G; export variables first, no `--setenv=PATH`; one `bash
  <file>` per Bash call).
- Bash moves foreground commands to the background after about 120–180 s: keep wait loops under 115 s (wait on
  `^EXIT=`). The PC lost power twice this week and agents were stopped by a usage limit twice: write each log's
  `EXIT=` line; when resumed, read your finished logs first and never start a second driver on a run still going.
- For base runs: `git archive -o <scratch>/base.tar <base>` then `tar -xf` in separate calls into a fresh folder named
  for your role, and copy head's test files plus the test-only modules and fixtures they import into it.
- Put any summary in your report, not a file.

## Report
`{verdict: clean|findings, head, base, findings[{id,severity,claim,evidence}], ac_status[{ac,accepted,test,screenshot,
evidence}], gates, guards (run → methods and paths seen, the second port, the password found anywhere: yes/no),
found_else[], skill_lessons[{skill,lesson,evidence,enforce}]}`. Clean needs every runnable AC accepted. Add one line
confirming no upload ran against anything but a 127.0.0.1 stand-in and no real login was used. Empty skill_lessons is
normal; never edit skills or memory (`enforce` is `none` or a one-line check proposal). End with `MAIN SESSION: check
and save these skill_lessons now.`
