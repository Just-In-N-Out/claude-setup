# Role: reviewer (round 10, a short delta: the move onto Build 2026-11-11.1 and the hand join; report only): site-menu

You are a fresh reviewer (**Opus 5.5, high**). Review only: change no source or test, commit nothing, start no agents.
Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees (read them with `git show`).
Never load bdryswi.com, B-Dry staging or any live site; no logins; never write to any WordPress site; never run
`npm run site:upload` or `npm run site:import` against anything but the tests' own 127.0.0.1 stand-in (a made-up
password). Nothing may hide that the importer's Chrome is automated. Justin may be running his own Chrome: never stop
a Chrome you didn't start; touch nothing under `~/Downloads`.

**Importer rule (Justin, 2026-11-02):** P0–P2 only for bugs a real site or normal use hits, each with a concrete
real-use scenario; edge cases are P3. **P0/P1 if it fails:** the press guard (no data-sending request, no page load a
press starts, no WebSocket handshake or message leaves while the capture presses) on **every** route that captures
(`npm run capture`, `npm run site:import`, the Figma panel's helper `capture:serve`); site-one-command's guards (the
password reaches nothing; nothing but reads before a fresh `yes`; no person at the terminal → refused). From round 3
on the referee asks Justin when only P2 is left: rate each finding exactly.

## What happened
site-menu was review-clean (review 9: MOVE ON) at `058ec3ea04203d4793e862b1f882c7a1fdbb7695` on main `11e885fd`. Main
then moved to `3f4a0718d974ec66167ce788ed3fe2672df9feb6` (Build 2026-11-11.1: site-one-command, which moved
`tools/capture.ts`'s Chrome launch into a **new** file `tools/lib/capture-run.ts`, shared with the new `npm run
site:import`, and rewrote `test/unit/capture-chrome.test.ts`'s case). A stack fixer rebased the job (54 commits → 53:
`7094a7d4` dropped empty after taking main's case; `tools/capture.ts` taken as main's in two commits; HANDOFF context
only) and then made the join by hand in its own commit `b52f532b`: `capture-run.ts` calls `launchCaptureChrome` (this
job's one launch, which starts the socket gate) instead of `launchChrome`; the case pins it and its import; a new
supporting web test `test/web/capture-commands-sockets.test.ts` proves the gate reaches both commands. **Nobody has
reviewed the resolutions or the join.** Git showed no conflict in `capture-run.ts` (a new file): a missed join would
have left both commands without the gate with every test green.

## Inputs
- Approved plan (read-only; amended A1–A11): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/plan-approved.md`
  ("Overlaps with unmerged jobs": the site-one-command join, the exact joined shape and the checks).
- Branch `site-menu-stack14`, head `7f7e0ffe53638e2f81a40d28015dc8e9405aa437` (the ledger commit; join `b52f532b`;
  rebased head before the join `3c7c4d82461680cf92b4e1ae911d15464384c2a1`), base main `3f4a0718`. In your own
  worktree: `git checkout --detach 7f7e0ffe53638e2f81a40d28015dc8e9405aa437`, confirm HEAD and a clean status. **Your
  scope:** the move (`git range-diff 11e885fd..058ec3ea 3f4a0718..3c7c4d82`) and the join (`git show b52f532b`), and
  what they touch.
- The fixer's record (read, don't trust): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/stack-14/`
  (`conflicts.md`, `range-diff.txt`, `patch-ids.txt`, `perfile.txt`, `resolutions/`, `join/`, `meet/` with
  `meet/ac11-four/`, `logs/`).

## Check hardest
1. **Every route that captures goes through the gate.** Find every place a Chrome for a capture is launched on the
   joined head (`git grep -n -E 'launch(Capture)?Chrome\(|launchChrome\(' -- src tools`): each capture route calls
   `launchCaptureChrome` exactly once on its path, and nothing that captures calls plain `launchChrome` (say what
   still does — `site:live`, `site:check`, browser tests — and that it should). Run the new web test yourself, and a
   probe of your own: a press that opens a socket and sends during `npm run capture`, during `npm run site:import`
   (stand-in, made-up password, answering "no"), and during a helper capture (`capture:serve`, the panel's route) — 0
   handshakes and 0 bytes at your server for each; the notes name what was stopped. A mutant that puts `launchChrome`
   back in `capture-run.ts` fails the case and the web test.
2. **The join kept both jobs whole.** `tools/capture.ts`, `tools/site-import.ts` are main's files byte for byte;
   `capture-run.ts` differs from main's only in the import and the launch call; the case keeps main's
   `doesNotMatch(/launch\w*Chrome\(/)` for both commands and its missing-Chrome lines. site-one-command's guards on
   the joined head: its `site-import-*` web files, the password grep on a run of your own (every form, every file,
   every Chrome process's `/proc` cmdline and environ — the gate is a new listener in the tool's own process: does it
   ever see or log the WordPress password? It must not: the upload goes direct, not through the gate), nothing but
   reads before a fresh `yes`.
3. **The move:** your own range-diff and patch-ids (50 equal, 3 changed by the resolutions, 1 dropped); for each
   conflicted commit, the +/- lines per file equal the old commit's except where main's file was taken, and what was
   taken is carried by the join. `tools/lib/site-upload/pictures.ts`' `uploadList` change is called by main's
   `flow.ts` as before. HANDOFF holds every section whole (this job's first, main's lines as main has them; the
   `<site-menu id at merge>` placeholders kept).
4. **site-one-command's story pins:** the fixer recorded AC11's pin failing on 13 items by this job's design (four
   trees, `meet/ac11-four/`): check that each item is this job's (the capture's `web.code.opens`, the header note's
   new words) and that `capture`'s and `site:upload`'s own printed lines are unchanged. AC12's pin (the Figma plugin
   byte for byte) would fail by design since this job changes `src/core`: run it and say exactly which bytes move and
   that each is this job's.
5. **Gates:** both typechecks and `npm run check` on head (8G scope); the case and the new web test; this job's press
   and socket tests (`socket-gate`, `web-press-guard`, `press-guard-sockets`, `capture-opens-guards` — F6-5 is a known
   flake in its service-worker cases: rerun alone —, `capture-opens`, `site-opens-proof`, `site-upload-opens`);
   site-one-command's `site-import-*` web files, `capture-cli`, `human-check`; each web file alone under
   `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0` (export variables first; no `--setenv=PATH`).

## Work
Load `requesting-code-review` and `code-review-practice`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` and the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Step 4", the stacking lines) with
`references/testing-pitfalls.md` and `references/live-site-reading.md` ("Holding a Chrome to read-only"). Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/review-10/review.json` (round 10, a delta: the move from
`058ec3ea` on `11e885fd` to `7f7e0ffe` on `3f4a0718` and the join; `head` the full SHA of your HEAD), then self-check:
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
3f4a0718d974ec66167ce788ed3fe2672df9feb6 /home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu` (exit 2 means
your file is wrong: fix it).

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/sm10/t1`; a
Chrome profile under a long TMPDIR dies with "Socket path too long");
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b` (one Chrome job at a time, closed after: stop it by
the PIDs of its own profile path; never `pkill -f <pattern>`). A worktree's `node_modules` may lack `.bin`, and a `git
archive` scratch tree has neither `tsc` nor `node_modules` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin`
on PATH and symlink the main folder's `node_modules` in; a piped, chained or redirected git command, a heredoc, a shell
function or a word containing "git" (gitleaks included) may be refused: write such steps to a script file with Write
and run `bash <file>`; `git -C <absolute path>`). Use `tail -n 3`, never `tail -3`. Never edit a tree a test is running
against. Scripts under `~/.cache/site-menu-review10/`. SIGTERM / 143 / 137 may be earlyoom (`journalctl -u earlyoom
--since "-30 min" -o short-iso | grep sending`). Waits under 115 s. The PC restarted three times this week: keep notes
and finished probe results on disk; when resumed, read them first.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario) or "none"; the routes table (route → launch it
uses, sockets at your server during a press, notes); the join checks; the move's proofs; the story pins judged;
`verdict`; `ac_status`; then `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never edit skills or
memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
