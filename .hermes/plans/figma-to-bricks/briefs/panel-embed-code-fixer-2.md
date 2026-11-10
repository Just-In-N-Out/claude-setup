# Role: fixer (round 2: Justin's "Safe rule" for floating widgets; review 2's R2-1, R2-2, R2-3): panel-embed-code

Review 2 ended `ASK JUSTIN: review-2: 3 P0-P2, no fewer than review-1's 2`. Justin answered in a question on
2026-11-10 (recorded in `evidence/panel-embed-code/review-2/justin.json`): **"Safe rule (Recommended)": paste a
floating widget's code only when the exact file that drew it is a tag the old page served. Anything started by a
starter script, a tag manager or the page's own script is listed with a plain note: add its install code by hand in
one Code element. No tracker can ride along; most chats need that one hand step.** He chose it over "Try one more fix
round" (watch more loading tricks) and "Keep it as it is now". `review-check.sh` now says REVIEW AGAIN.

You are a fresh fixer for FigmaToBricksV2 (**Opus 5.5, high**). Carry that rule out test-first, then stop at
`ready-for-review`. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never
push or merge, don't bump `BUILD`, don't rebase (`main` is at `7eeca437`; a later step moves the job), leave other
worktrees alone, start no agents. **Never load bdryswi.com, B-Dry staging, a widget vendor's host** or any live site
(local fixture servers and saved files only); no logins; never write to any WordPress site. Nothing paid. Nothing may
hide that the importer's Chrome is automated.

**This job's guard:** a pasted Code element runs only a widget's own code. A tracking tag, a tag manager, a loader, a
shared library, another widget's script or a page script in a paste is P0/P1. Where the capture can't prove what a
widget's own code is, nothing is pasted to run.

**Skills to load:** `receiving-code-review`, `engineering-best-practices`, `test-driven-development`,
`mutation-testing-discipline`, `git-commit-rules`. Read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md` (the embeds line: "An embed's snippet is not only its slot…", which ends with reviews
1 and 2's lessons), the repo `CLAUDE.md` ("Build general logic": nothing keyed on a vendor's or library's name or
host; "Code Figma runs uses only the language's built-ins"; "Website captures") and `reference/bricks/README.md`.

## Your copy (you start in your own worktree)
`git checkout -B panel-embed-code-fix2 4cfc700313821a96ffce78e026bdf5cf04529015` (the reviewed head, branch
`panel-embed-code-fix1`, on `f708dfb6`), confirm `git rev-parse HEAD` and a clean status. Report your branch.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/panel-embed-code/plan-approved.md`
  (AC1–AC11; Q4 A and AC7 as written: "the very file that made the box"; Justin's answer returns to them and adds
  "and nothing else started it").
- Review 2: `evidence/panel-embed-code/review-2/review.json`; its probes and outputs `~/.cache/pec-r2/` (`scripts/probe.ts`,
  `out/`: tag managers C1, C2; hidden-channel loaders A2–A9; page-called vendors B1–B4). Review 1:
  `review-1/review.json`, `~/.cache/pec-r1/`. Fix round 1's receipts: `evidence/panel-embed-code/fixer-1/`, its fixture
  site `embeds-chained`. Deferred items: `evidence/panel-embed-code/follow-ups.md`.

## The findings (all three come from fix round 1's two rules)
- **R2-1 (P1, `src/web/read/floating.ts:202`):** a tag manager served as a tag that injects a vendor SDK and calls its
  init from the script's onload is pasted as the widget's own code (the SDK "never acts alone", so the library rule
  skips it and the tag manager becomes a one-step root); drawing the paste sent the tracker's hit.
- **R2-2 (P1, `floating.ts:185`):** the bootstrap check only proves absence of what the tracker saw: loaders that
  track through `document.write`, `import()`, a Worker, a frame's own fetch, a WebSocket, a CSS `@import`, a 45 s timer
  or a click handler were all pasted (8 of 8).
- **R2-3 (P2, `floating.ts:203`):** a vendor's file that does nothing until the page's own script calls it (a served
  SDK plus inline `Vendor.init()`; an inline loader calling init on onload; a badge started on window load) reads as a
  "library", so its launcher is rebuilt as a still copy noted as the old site's own box.

## The rule to carry out
1. **Code is pasted for a floating widget only when both hold:** (a) the file that drew the box is itself a script tag
   the old page's server sent (kept exactly as served; served twice: as now), and (b) **that file drew it by itself**:
   no other script (another file of any host, the page's own inline or site script, an event handler another file
   registered) is on the stack when the box is made. No chain is followed, no "does nothing else" is inferred, no file
   is skipped as a "library". Everything else pastes no code.
2. **What then becomes of a box that fails (a) or (b):** it is never pasted as code. Decide, by structure only, between
   - **listed, with one plain sentence** that says why and what to do ("add the widget's install code from <host> in a
     Code element by hand"): a box another company's file drew that something else started (a starter script, a tag
     manager, the page's own script calling a vendor's file), and
   - **the site's own box, rebuilt as every other site-own fixed box is on base:** a box whose making the site's own
     script started through another host's file (a back-to-top button or cookie bar drawn through a CDN library).
   You can't read which it is from "the file never acts alone" (R2-3 proves it). Read it from **what the box is**:
   for instance a box that holds or loads another host's content (a frame, a script, a picture or a stylesheet from a
   host that isn't the site's) is another company's and is listed; one holding only the site's own content, drawn
   through another host's file by the site's own script, is the site's own. Choose the test, prove it on B1–B3 (each:
   never a still copy noted as the site's own; say what Justin sees), on shape A (the library is never pasted; the
   site's own button is not lost if it can honestly be kept), and say plainly which real shapes still fall on the
   wrong side and what the note tells Justin then. **When in doubt the note must not call another company's widget
   the site's own.**
3. **Take out what the rule no longer needs:** the chain following (`chainOf` / `originOf`'s chain), the "library"
   skip, the per-file `acts` record and the wrapping of `fetch`, `XMLHttpRequest` and `sendBeacon` on the captured
   page (R2-5: a captured page should be touched as little as it was on `4d6c6403`), unless a kept behaviour provably
   needs one of them — then say which and why. Keep what is still right from round 1: the deeper stack read with the
   page's own `Error.stackTraceLimit` put back (rule (b) needs the whole stack), the `unread` record for a served page
   that couldn't be read, the consumer pasting `own` only where the capture proved it, the reworded notes that still
   apply (no "your <cdn host> account"; "capture the page again (a new capture may paste it)" for unread), the
   fixture fix in `notesCapture`. R2-4: a note that says a pasted file "also loads other files" names what it loads
   truthfully (any host), or goes if the record it needs is gone.
4. **Saved captures:** a capture made with fix round 1's fields (`ownWhy`, `ownLoads`) exists only in tests; a capture
   made before this job converts as on `4d6c6403` (byte for byte except note words). The capture's format stays
   readable by the panel's sandbox (`src/core` uses only the language's built-ins).

## Work
1. Verify each finding yourself first on the reviewer's probes.
2. Test first (RED on `4cfc7003`, GREEN on your fix), on fixture shapes of your own (extend `embeds-chained`; generic,
   no vendor's or library's name): the tag manager with onload init, with the tracker at once and on first click
   (C1, C2); three hidden-channel loaders at least (`document.write`, `import()`, a click handler) plus the plain
   bootstrap → bundle chain; B1, B2, B3; shape A; and the positive case that must still paste: a served file that
   draws its launcher by itself (at load, from a timer, from its own `DOMContentLoaded` handler), served once and
   twice. For each: what the capture records, what both routes paste to run, what the fixture servers received when
   the pasted footer is drawn on a fresh page and clicked (tracker and tag manager asked 0 times), and the note's
   words.
3. Mutate what you add or keep (each condition removed in turn is killed by a named assertion, never a crash), under
   `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`.
4. Records batched into your commits: HANDOFF's panel-embed-code section (the rule as Justin chose it, in his words;
   what is listed and why; what is rebuilt as the site's own box; known limits: a chat started by a starter script
   needs one hand-added Code element; the wrong-side shapes) and the ledger ("Fix pass 2"; and the exact plan lines
   that now read false or true again, for the planner: Q4 A, AC7, lines 188–189, the code sketch, R1-7's
   `e.how === undefined ? "older"`); `docs/specs/web-capture.md`; append what you defer to
   `evidence/panel-embed-code/follow-ups.md`.
5. Gates: both typechecks (`tsconfig.sandbox.json` too), `npm run check`, the job's tests and the floating / embeds /
   tracker web tests your change touches (each web file alone under the 4 GB cap, one Chrome job at a time), the
   "unchanged sums" test (`F2B_UNCHANGED_SUMS=1`), `test/unit/plugin-convert.test.ts`, `sandbox-convert`, the code
   route byte for byte against base and against `4d6c6403` on the widget fixtures and the saved captures, review 1's
   probe (`~/.cache/pec-r1`: what the footer pastes now — its `boot.js` chat is listed again, by Justin's choice) and
   review 2's probes re-run on your head; every AC's log starting `HEAD=` and ending `EXIT=`. Commit after each
   passing step (plain `git commit -m`, or `-F <file>`; no author override, no AI or Co-Authored-By lines; `git diff
   --cached --name-only` without CLAUDE.md). Evidence in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/panel-embed-code/fixer-2/`.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/pec-f2/t1`, a
separate one per script started at the same time); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close
every Chrome you start (stop it by the PIDs of its own profile path; never `pkill -f <pattern>`: it kills the tool's
own shell); a worktree's `node_modules` may lack `.bin`, and a `git archive` scratch tree has neither `tsc` nor
`node_modules` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's
`node_modules` in). Scripts written with Write under `~/.cache/pec-f2/` (a restart empties `/tmp`); one `bash <file>`
per Bash call. SIGTERM / 143 / 137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso
| grep sending`): say so, find what grew, rerun under the cap. Known flake: `capture-entrances` "R8-1 a page whose
motion never stops…" under load. Waits under 115 s. The PC lost power twice this week and agents can be stopped by a
usage limit: write each log's `EXIT=` line; when resumed, check `git status` for half-written tracked files (exactly
8388608 bytes), read your finished logs first and never start a second driver on a suite.

## Report (as text; don't write report files)
`status: ready-for-review`, branch, last commit (full SHA); the rule as built ((a) and (b)); how a box that fails them
is told between "listed" and "the site's own", with B1–B3 and A, and the shapes still on the wrong side; what was
taken out and what was kept from round 1, with why; per finding: verified?, tests, RED/GREEN paths; mutation table;
the notes as they now read; gates; what changed for saved captures and for `npm run site`; the plan lines for the
planner; `found_else`; then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal;
`enforce` is `none` or a one-line check proposal; never edit skills or memory), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
