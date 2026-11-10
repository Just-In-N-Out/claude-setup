# Role: planner (a feature, Mini pipeline): site-one-command — one command that asks for WordPress first, then scans, uploads and writes the paste

You are a fresh planner for FigmaToBricksV2 (**Opus 5.5, high**). Plan only: write the plan. Change no source or test
in any worktree or the main folder, commit nothing, start no agents. Never load bdryswi.com (it has a bot check; never
without Justin), B-Dry staging or any live site. No logins; never write to any WordPress site; never run `npm run
site:upload` against anything but the local stand-in (`test/fixtures/wp-standin.ts`, 127.0.0.1). Never ask for, hold
or invent a real password. Nothing paid. Nothing may hide that the importer's Chrome is automated.

**Skills to load:** the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (with
`references/testing-pitfalls.md` and `references/live-site-reading.md`), `engineering-best-practices`,
`implementation-planning`, `authorized-write-safety`. Read the repo `CLAUDE.md` in full (the standing rules "One tool
writes to WordPress: `npm run site:upload`", "The importer never hides that its Chrome is automated", "`npm run
site:live` only reads a published page", the decision bullet "A scanned page's pictures go to WordPress from the
command line" with Q1–Q12) and HANDOFF's sections "A scanned page's pictures go to WordPress's media library"
(site-media-upload, Build 2026-11-10.5), "Capturing a live page" and web-human-check; the merged plan
`docs/plans/2026-11-10-site-media-upload.md`; the tools `tools/capture.ts`, `tools/capture-check.ts`,
`tools/site.ts`, `tools/site-upload.ts` and `tools/lib/site-upload/*` (`ask.ts`, `guard.ts`, `pictures.ts`,
`record.ts`, `sent.ts`, `stop.ts`, `args.ts`), `src/web/human-run.ts`, `src/web/owned.ts`.

## What Justin asked (2026-11-10, his words)
He ran `npm run capture -- https://bdryswi.com/ --out ~/Downloads/bdry-test`, passed the "I am human" check, and
wrote: "it did nto ask", then "but i expected it to ask me for the applicaiton password to check for media", and "i
want to put it in Wp to see how it is tho and all on the live site". Told that the scan (`capture`) and the upload
(`site:upload`) are two commands today (site-media-upload's Q1 A, a choice made on his behalf, never confirmed), he
chose in a question: **"One command, Mini (Recommended)"** — one command that asks for his WordPress site, username
and Application Password first, then scans, checks his media library, uploads the pictures and writes the paste, like
the plugin's panel (connect WordPress first, then everything in one go). The two separate commands stay too.

## What the plan must settle (with evidence from the code, not taste)
1. **The command and its order.** One new command (propose its name and arguments; for example `npm run site:import
   -- <old page address> <https://your-wordpress-site> [--user <name>] [--dry-run] [--elementor] [--out <folder>] …`)
   that reuses the existing tools' own modules, never a copy of them: (a) reads the typed WordPress site with no
   password (`guard.ts` `readIndex`: redirects and a WordPress naming another site refused, as today); (b) asks the
   username and the Application Password at the hidden prompt (`ask.ts`) and tests the connection (`wordpress.ts`
   `testConnection`: a read) **before the scan starts**, so a wrong password stops in seconds with one plain line and
   nothing is scanned; (c) scans the page (`capture`'s own flow: the owned-site question, the visible window for a
   person check, the same file written); (d) refuses an unclean capture as `capture:check` does; (e) says plainly
   what it found in his media library (how many of the page's pictures are already there by the record and by the
   site's answer, how many would go up, their alt text: what the dry run prints today); (f) waits for the typed `yes`
   (no flag skips it; `--dry-run` stops before it and sends nothing); (g) uploads with the same uploader, record,
   stop handling and scrubbed lines; (h) writes `media.json` and the pastes, and says where they are and what to do
   next in numbered plain steps (paste where, Regenerate code signatures, purge the cache).
2. **The password is held through the scan (about 4 minutes, a Chrome running beside it).** Prove from the code where
   the password lives today and what the new command must guarantee: never in an argument, an environment variable, a
   file, the record, the capture, the paste, a log or a printed line; never in the Chrome child's command line or
   environment, never reachable from a page; cleared when the run ends, fails or is stopped (Ctrl+C during the scan
   and during the upload). Say whether asking it at the start (Justin's expectation) or again right before the upload
   is safer, recommend one with a one-line plain-words trade-off, and put it as a ⭐ question if it is a real
   trade-off.
3. **What a failure in the middle does.** A failed person check, a lost connection, an unclean capture, a refused
   picture type (Q12 is still open: plan with what is built), Ctrl+C at each stage: nothing uploaded before the typed
   `yes`; after it, exactly what `site:upload` does today (a re-run sends no file twice). Can a second run reuse the
   capture just made instead of scanning again (propose the flag or the rule)?
4. **No person at the terminal:** refused for any site but this computer's own stand-in, as `site:upload` is.
5. **The standing rule's new wording** for the after-merge finisher: CLAUDE.md says "One tool writes to WordPress:
   `npm run site:upload`". With this job there is still one uploader and the same limits (only adds media items; only
   the typed site; a typed yes; the hidden prompt; only Justin runs it, in his own terminal; agents only against the
   stand-in), reached by two commands. Write the exact replacement lines in the plan.
6. **The existing commands stay as they are:** `capture`, `capture:check`, `site`, `site:upload` behave and print
   byte for byte as before; the Figma plugin and panel are untouched (`dist/` unchanged unless you prove a shared
   module must move; if one must, say why).

## The plan
- Write `~/.hermes/plans/figma-to-bricks/site-one-command.md` (the builder copies it to
  `docs/plans/2026-11-10-site-one-command.md` as its Task 0), a plan a fresh agent with no context can build from: the
  playback in plain words; the current flow with file:line evidence; **numbered acceptance criteria AC1, AC2…, each
  with one named test, each test name whole on one plan line** (a line that isn't an AC's definition never starts
  with a list marker, table pipe or heading followed by `AC<n>`); proposed ACs marked **(proposed)**; an AC only
  Justin can check tagged `(live)` right after its id (his own run: bdryswi.com → B-Dry staging, in his terminal);
  tasks test-first with RED on base; open questions at the top with a ⭐ answer each. The pipeline is **Mini**
  (`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/mini-pipeline.md`; Justin chose it): keep the
  plan the size of the job (a thin command over modules that exist; export what it needs from the tools, move as
  little as possible), and say plainly if you find it can't be Mini (a design change).
- The ACs must include: the order of the questions and the connection test before any scan (a wrong password: one
  plain line, exit 2, no Chrome started, no request but reads of the typed site); the password in no argument,
  variable, file, record, capture, paste, log, printed line or child process (a test that greps every artefact and the
  Chrome child's argv and environment for a made-up password); nothing sent that isn't a read before the typed `yes`
  (the stand-in's request log); `--dry-run` sends nothing and prints the list with the alts; a failed or unclean scan
  uploads nothing; a stop at each stage; no person at the terminal refused; the pastes and `media.json` equal to what
  `capture` then `site:upload` write for the same page and stand-in (byte for byte, after the addresses' ports are
  normalised); the four existing commands unchanged; the Figma route unchanged. Tests run only against local fixture
  sites and `test/fixtures/wp-standin.ts`.
- Base: `main` `7ec16d6060a76b441e42581b78ad3a502461fd66` (Build 2026-11-10.7; check `git rev-parse main`). Jobs moving
  beside it, not merged (say where this job would conflict and keep its changes out of their files where it can):
  site-menu (`site-menu-fix6`: the capture's press step, and it adds an opened box's own pictures to
  `tools/lib/site-upload/pictures.ts`' upload list), footer-icon-list (the capture's reader: `src/web/read/code*.ts`),
  control-weight (`src/core/site/inline-own.ts`, `convert.ts`), site-native-structure (`convert.ts`, `parts.ts`,
  `elementor-fold.ts`).
- You may run tests and probes on `git archive` scratch copies (never in the main folder's tree beyond reading);
  scratch under `~/.cache/site-one-command-planner/`; evidence under
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-one-command/planner/`.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters
(`~/.cache/soc-p/t1`); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; one Chrome job at a time,
closed after (stop it by the PIDs of its own profile path; never `pkill -f <pattern>`); a `git archive` scratch tree
has neither `tsc` nor `node_modules` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and
symlink the main folder's `node_modules` in; a piped, chained or redirected git command may be refused: one plain git
command per call, `git -C <absolute path>`). Heavy runs under `systemd-run --user --scope -p MemoryMax=4G -p
MemorySwapMax=0` (export variables first, no `--setenv=PATH`). SIGTERM / 143 / 137 or "Killed" may be earlyoom
(`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`). Waits under 115 s. The PC restarted three
times this week and agents can be stopped by a usage limit: keep notes and results on disk; when resumed, read them
first. Justin may be running his own capture and upload in his terminal while you work: touch nothing under
`~/Downloads`.

## Report (as text)
The plan's path; the playback in three plain sentences; the command line Justin will type and what it asks, in order;
the ACs one line each (the `(live)` ones named); the questions with their ⭐ answers, and whether one is a decision
for Justin; whether it stays Mini; where it conflicts with the moving jobs; then `skill_lessons[{skill, lesson,
evidence, enforce}]` (reusable only; empty is normal; `enforce` is `none` or a one-line check proposal; never edit
skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
