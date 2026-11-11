# BLIND AC AUDITOR (read only): site-menu (the capture presses a page's menu / pop-up / drawer buttons under a guard and the paste carries what opens as Bricks' Offcanvas)

You are a fresh auditor (**Opus 5.5, xhigh**). Independently prove the approved acceptance criteria. You have never
seen a builder, reviewer, fixer or verifier report. Stay blind: never open anything under
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/` except `plan-approved.md` and your own `auditor/`
folder (never `builder/`, `fixer-*`, `review-*`, `verifier*`, `stack-*`, `planner*`, `auditor-old-*`, `follow-ups.md`,
`plan-approved-v*`); nor HANDOFF, ledgers, the plan copy under `docs/plans/`, or session notes; nor other agents'
scratch folders under `~/.cache/` (`sm*`, `site-menu-*` other than your own). Source and tests are read-only; commit
nothing; start no agents.
**Justin (2026-11-02): "focus on building and not too much of edge cases."** An AC fails when its own text is broken
(its named test, or a realistic case its words cover); an edge case beyond its text goes in `found_else`. The plan's
recorded limits are not failures.
**Never load bdryswi.com, B-Dry staging, a widget vendor's host** or any live site (local fixture servers, the
offline B-Dry stand-in site and saved files only); no logins; never write to any WordPress site; `site:upload` /
`site:import` only against the tests' own 127.0.0.1 stand-in with a made-up password. Nothing may hide that the
importer's Chrome is automated. Justin may be running his own Chrome: never stop a Chrome you didn't start; touch
nothing under `~/Downloads`.

## The only inputs
- Approved plan (amended A1–A11; its Amendments list is at the top):
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/plan-approved.md` (AC1–AC8; AC8 live: mark it
  `not_run`). Judge each AC by its amended words. Use each exact test name the plan cites: find them all first with
  ac-check's own grep (`command grep -E "(^|[^A-Za-z0-9_])<name>([^A-Za-z0-9_]|$)" <plan>`); where the runner prints a
  name differently, cite a phrase that sits whole on one plan line and run the test by its full printed name through
  a by-name checker, as `ac-verification.md` says. Read each cited test before you run it (a test that only asserts
  what a sibling collects is run with its whole file). Run the supporting tests the plan names beside the cited
  ones, and never cite them. The plan names merged jobs' env-gated story pins this job moves by design: record them,
  don't count them.
- Head `7f7e0ffe53638e2f81a40d28015dc8e9405aa437` (branch `site-menu-stack14`), base
  `3f4a0718d974ec66167ce788ed3fe2672df9feb6` (local `main`, Build 2026-11-11.1), your own folder
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/auditor/` (empty). The offline B-Dry stand-in the plan
  names may be used as an input (read the tests for its variables; say which files you used, by path and sha256, and
  that they are saved files, not the live site).

## Your copy
In your own worktree: `git checkout --detach 7f7e0ffe53638e2f81a40d28015dc8e9405aa437`, confirm `git rev-parse HEAD` and
a clean `git status --porcelain --untracked-files=all` (after a machine restart, look for tracked files of exactly
8388608 bytes and restore them with `git checkout --`; `git cat-file -t HEAD`). Your `ac.json` names this head and
base. Never write in any other worktree or the main folder.

## Work
Load `engineering-best-practices`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
with `references/testing-pitfalls.md`, `references/live-site-reading.md` ("Holding a Chrome to read-only") and
`references/rendering-validation.md`; `reference/bricks/README.md`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and the report format at the top
of its `scripts/ac-check.sh`; follow the blind auditor procedure there. For every AC make your own head and base runs
(an AC log starts with the bare `HEAD=<sha>` and ends with one line `EXIT=`, skipped 0; base: a tree from `git archive`
of the base with head's test files, fixtures and test-only modules copied in, labelled in the log's second line; where
a base run is only an import failure of a new module, prove the test can fail with a one-line mutant of a head copy
under the 4 GB cap, restored by hash; a mutant that lets a write or socket through runs with networking off: `unshare
-rn sh -c 'ip link set lo up && exec unshare --user --map-user=1000 --map-group=1000 node --test …'`; a clause that
rightly passes on base is `base_exempt` with a specific reason and your own byte receipt). Also:
- **The guard, proven by you hardest**, on pages of your own (servers that log every request, WebSocket upgrade and
  frame): buttons whose boxes hold a form, a real link, a `window.open`; an opener that POSTs and beacons; a press that
  opens sockets from the page, a worker, a cross-site frame and a window it opens; another origin's chat launcher.
  Through `npm run capture` **and** `npm run site:import` (stand-in, made-up password, answered "no"): 0 data-sending
  requests, 0 page loads a press started, 0 handshakes and 0 message bytes from anything a press started; each stopped
  attempt named. A quiet twin page of each shape reads the same boxes and openers.
- **What opens, pasted:** your own fixture with a drawer menu, a dialog and a `<details>`: site | paste in Chrome as
  Bricks 2.3.9 and 2.4.2 print it, at a phone and a desktop width: the box opens from its opener, closes as on the
  site (Escape, the dim, ×), within the plan's tolerance.
- **The pictures of an opened box:** a pop-up the site's own script builds with a site picture, one another company's
  widget builds, one a tag manager injects: `npm run site:upload -- … --dry-run` against the stand-in (nothing sent)
  lists the site's own once as going up and the others as staying, no address on both lists.
- A screenshot per AC (a terminal image for a non-visual AC); shoot each page alone (a page not in front stalls).
- Run `git log -p 3f4a0718..HEAD -- <each AC's test files>` and read every assertion against the amended plan.
Write `auditor/ac.json`, then self-check by copying your report and receipts to a fresh scratch folder and running
`ac-check.sh` on them (`--base 3f4a0718d974ec66167ce788ed3fe2672df9feb6`, no `--reviews`).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters and a separate one for
  each script you start at the same time (`~/.cache/sma/t1`, `t2`; a Chrome profile under a long TMPDIR dies with
  "Socket path too long"); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Close every Chrome **you**
  start (stop it by the PIDs of its own profile path; never `pkill -f <pattern>`). A worktree's `node_modules` may lack
  `.bin`, and a `git archive` scratch tree has neither `tsc` nor `node_modules` (put
  `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's `node_modules` in; a
  piped, chained or redirected git command, a heredoc, a shell function or a word containing "git" may be refused:
  write such steps to a script file with Write and run `bash <file>`; `git -C <absolute path>`). A script hosting a
  fixture server in its own process starts the CLI with async `spawn`. Use `tail -n 3`, never `tail -3`. Keep scripts
  and logs under `~/.cache/site-menu-auditor/` and copy them to `auditor/scripts`. Never edit a tree a test is running
  against.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min"
  -o short-iso | grep sending`); heavy and mutation runs under `systemd-run --user --scope -p MemoryMax=4G -p
  MemorySwapMax=0 <cmd>` (the parallel unit suite and B-Dry runs 8G; export variables first, no `--setenv=PATH`).
- Bash moves foreground commands to the background after about 120–180 s: keep wait loops under 115 s (wait on
  `^EXIT=`). The PC restarted three times this week: write each log's `EXIT=` line; when resumed, read your finished
  logs first and never start a second driver on a run still going.
- Put any summary in your report, not a file.

## Report
`{verdict: clean|findings, head, base, findings[{id,severity,claim,evidence}], ac_status[{ac,accepted,test,screenshot,
evidence}], gates, guard (your pages × routes → requests, page loads, handshakes, bytes, notes, openers), pictures,
found_else[], skill_lessons[{skill,lesson,evidence,enforce}]}`. Clean needs every agent-run AC accepted. Empty
skill_lessons is normal; never edit skills or memory (`enforce` is `none` or a one-line check proposal). End with
`MAIN SESSION: check and save these skill_lessons now.`
