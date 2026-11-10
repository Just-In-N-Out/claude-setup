# Role: verifier (read-only): site-media-upload

You are a fresh verifier who never saw the build or the reviews (**Opus 5.5, high**). Prove each acceptance criterion
yourself. Change no source or test, commit nothing, start no agents. Never edit the main folder or other worktrees
(read them with `git show`).

## The one rule above all others in this job
This job builds the first tool that writes to WordPress (`npm run site:upload`). **You never run it, or any upload,
against a real site: not Justin's staging, not bdryswi.com, not any host that isn't 127.0.0.1 / localhost.** Every run
of the uploader talks only to the local WordPress stand-in the tests start (`test/fixtures/wp-standin.ts`) or a
stand-in of your own on 127.0.0.1. **You use no login, no Application Password and no key of any kind, and you never
ask for, look for, read or print one** (not from the environment, the repo, `.git/config`, a credential helper, a file
under the home folder, or the panel's storage): runs use made-up passwords that exist only in the run. Never load
bdryswi.com, B-Dry staging or any live site. Justin's standing rule — "Never write to any WordPress site; GET/read
only, and ask me before using any login." — binds you fully; only Justin, in his own terminal, ever runs the finished
tool against his site (the plan's two live ACs: mark them `not_run`, owed).

**Skills to load:** read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (your job
and the `ac.json` format) and follow it; the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md`; the repo `CLAUDE.md` (the upload, picture and WordPress rules).

## Inputs
- Approved plan (read-only; amended A1–A7, the Amendments list is at its top):
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-media-upload/plan-approved.md` (AC1–AC16; AC15 and AC16
  live, Justin's: `not_run`, owed). Find every cited test name with ac-check's own grep first (`command grep -E
  "(^|[^A-Za-z0-9_])<name>([^A-Za-z0-9_]|$)" <plan>`); a name the runner prints with a prefix goes through a by-name
  checker citing a phrase that sits whole on one plan line. Judge each AC against the amended words; where an "Also
  (supporting…)" line names tests beside the cited one (the heard stop, the scrubber, an upload redirect, the R1-7
  note), **run those too, never cite them**.
- Head `c1b52ce2751fe18229d5ac7484e69ec9efff3114` (branch `site-media-upload-stack8`; the last commit is the ledger,
  code head `31a17fae`); base (old code) `7eeca437ea100c821bcfb82cdbbe516a023ff097` (local `main`, Build 2026-11-10.4).
  In your own worktree: `git checkout --detach c1b52ce2751fe18229d5ac7484e69ec9efff3114`, confirm `git rev-parse HEAD`
  and a clean status (after a restart: restore tracked files of exactly 8388608 bytes; `git cat-file -t HEAD`). Old
  code: a tree from `git archive` of `7eeca437` with head's test files, fixtures and test-only modules copied in (the
  tool is new: where base only fails at import, that is weak RED — add a labelled supporting run so the test fails on
  its own assertion, or say why none exists; AC4, AC12 and AC13 are preservation pins: `base_exempt` with a reason and
  your own byte receipt). An AC log cited in `ac.json` starts with the bare `HEAD=<sha>` (say "archive" on its second
  line) and ends with one line `EXIT=`, skipped 0 (the story pins run only with `F2B_STORY_PINS=1`).
- Don't read the builder's, fixer's or reviewers' reports as proof. Receipts the plan's Amendments list names as
  encoding an old expectation are not proof either.

## Work
1. Gates on head: both typechecks (`tsconfig.sandbox.json` too), `npm run check`, `npm run corpus` (same output as
   base; v1's Mac files are missing here), `test:web` and `test:browser` file by file under the 4 GB cap, compared
   with base by test name (the job adds one web file; it changes `src/core/site/{media,kinds,convert,parts}.ts`,
   `src/ui/uploader.ts` and `src/ui/wordpress.ts` exports: run base's side yourself for every file whose result
   differs by name; pre-existing failures are fine only if they also fail on base by name: five browser files fail on
   main on this desktop — composition-clipping, fonts, hero-pair, peer-sides, pill-holder — and the named-only
   `site-elementor-page-bdry` fails on main by the footer's 69 px, another job's; rerun a differing file alone before
   calling a regression; known flakes: the code-page fixture's 5.09 px load flake, `capture-windows` AC7,
   `capture-entrances` R8-1, `site-elementor-button` pixels-at-rest). The five Figma replays byte-identical to base;
   `test/unit/plugin-convert.test.ts`.
2. Every AC's named test on head (must pass) and on old code; a picture or terminal capture per AC (no password in
   it; AC14: site | paste of the fixture page with its uploaded pictures at 1440 and 390).
3. **The guards, proven by you through a pseudo-terminal against your own logging stand-in** (every request with its
   method, path, headers and body kept; a second 127.0.0.1 port as "another site"):
   - the made-up password (as typed, without spaces, and inside the Basic `user:password` base64) is in no file the
     tool wrote (record, `media.json`, pastes, the out folder, the scratch `HOME`), no output on any ending (success,
     wrong password, a 401 / 403 / 500 whose body echoes the Authorization header, a lost connection, Ctrl+C), and not
     in `/proc/<pid>/cmdline` or `environ` of the tool or its children;
   - before the password is asked or sent the tool refuses plain http to a non-loopback name, a login inside the
     address, an index that redirects or names another host or folder, and a run with no terminal; the typed `yes`
     can't be skipped by any flag; a dry run sends no request and writes nothing;
   - across a first run, a second run, a run stopped by Ctrl+C with uploads in flight and its rerun, and a run killed
     with SIGKILL and its rerun: the stand-in saw only GETs and `POST wp/v2/media`, each file's POST exactly once
     across a stopped run and its rerun, no request at all on the second port, no Authorization header on the rerun's
     file reads, no redirect followed (a 307 on the login check and on the upload);
   - `npm run site … --media <file>` reads only the local file (no socket opened: run it with networking refused, e.g.
     under a preload that throws on `net.connect` / `fetch`, or `unshare -n` if available) and without `--media` every
     paste is byte for byte base's.
4. **Where this job meets main's newest merge** (staging-fit-renderer): AC14's numbers under the new renderer; the
   read-only guard's own tests (`site-live.test.ts`, the read-only unit tests) pass by name as on base.
5. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-media-upload/verifier/ac.json` and logs in that
   folder (nothing password-shaped in any of them: grep before you finish); self-check it with
   `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh` on a copy (`--base
   7eeca437ea100c821bcfb82cdbbe516a023ff097`), as the reference says.

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/smu-v/t1`,
  `t2`, …: a separate one for each script started at the same time); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`.
  Other agents run Chrome too; close every Chrome you start (stop it by the PIDs of its own profile path; never `pkill
  -f <pattern>`: it kills the tool's own shell). Every run of the tool uses a scratch `HOME` (link
  `.cache/chrome-for-testing` and `.cache/chrome-libs` into it when a run needs Chrome), never the real
  `~/.config/figma-to-bricks/`. A worktree's `node_modules` may lack `.bin`, and a `git archive` scratch tree has
  neither `tsc` nor `node_modules` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink
  the main folder's `node_modules` in). Point `corpus.json` at the repo's copies as testing-pitfalls says (in a
  scratch copy, never the worktree). Run multi-step commands from a script file written with Write, paths spelled
  out. A pseudo-terminal from node: Python's `pty` (the repo's `test/fixtures/pty-run.py`) or `script -qec`.
- Runaway memory: SIGTERM, 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso |
  grep sending`); heavy runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (the parallel
  unit suite may need 8G; export variables first, no `--setenv=PATH`); `compare-corpus.test.ts` needs
  `--test-timeout=3600000`. The PC lost power twice this week and agents were stopped by a usage limit twice: keep
  scripts and logs under `~/.cache/smu-v/`, never the `/tmp` scratchpad, write each log's `EXIT=` line (wait on
  `^EXIT=`) so finished runs count after a restart, start long drivers with `setsid --fork`, and when resumed read
  your finished logs first and never start a second driver on a suite one is still working through.
- Bash moves foreground commands to the background after about 120–180 s: keep wait loops under 115 s.

## Report (as text; only ac.json and logs are written)
Per AC: test, head result, old-code result, evidence path; the guards' table (run → methods and paths seen, the second
port, the password found anywhere: yes/no); gates; `verdict`; `ac_status`; a line confirming no upload ran against
anything but a 127.0.0.1 stand-in and no real login was used; then `skill_lessons[{skill, lesson, evidence, enforce}]`
(empty is normal; `enforce` is `none` or a one-line check proposal; never edit skills or memory), ending with
`MAIN SESSION: check and save these skill_lessons now.`
