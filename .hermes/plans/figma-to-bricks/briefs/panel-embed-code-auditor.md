# BLIND AC AUDITOR (read only): panel-embed-code (on both website-importer routes a pasted Code element runs only a widget's own code)

You are a fresh auditor (**Opus 5.5, high**). Independently prove the approved acceptance criteria. You have never seen
a builder, reviewer, fixer or verifier report. Stay blind: never open anything under
`/home/justin/.hermes/plans/figma-to-bricks/evidence/panel-embed-code/` except `plan-approved.md` and your own
`auditor/` folder (never `builder/`, `planner/`, `fixer-*`, `review-*`, `verifier*`, `stack-*`, `follow-ups.md`,
`plan-approved-v*`); nor HANDOFF, ledgers, the plan copy under `docs/plans/`, or session notes. Source and tests are
read-only; commit nothing; start no agents.
**Justin (2026-11-02): "focus on building and not too much of edge cases."** An AC fails when its own text is broken (its
named test, or a realistic case its words cover); an edge case beyond its text goes in `found_else`. The plan's own
"Known limits" and its "Open: to be confirmed with Justin" items are not failures: say what you saw for them.
**Never load bdryswi.com, B-Dry staging, a widget vendor's host** or any live site (local servers and saved files
only); no logins; never write to any WordPress site; never run `npm run site:upload` against anything. Nothing may
hide that the importer's Chrome is automated.

## The only inputs
- Approved plan (amended A1–A8; its Amendments list is at the top):
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/panel-embed-code/plan-approved.md` (AC1–AC11; AC11 is `(live)`,
  owed to Justin: mark it `not_run`). Judge each AC by its amended words. Use each exact test name the plan cites:
  find them all first with ac-check's own grep (`command grep -E "(^|[^A-Za-z0-9_])<name>([^A-Za-z0-9_]|$)" <plan>`);
  where the runner prints a name differently, cite a phrase that sits whole on one plan line and run the test by its
  full printed name through a by-name checker, as `ac-verification.md` says. Run the supporting tests the plan's
  "Also (supporting…)" lines name beside the cited ones, and never cite them. The "unchanged sums" test runs only with
  `F2B_UNCHANGED_SUMS=1`.
- Head `f961b365ee7305b2a48e459051f8cf4e282bd382` (branch `panel-embed-code-stack11`), base
  `56a9379faf207c2bfa76211dff1365db7d74be37` (`main`, Build 2026-11-10.6), your own folder
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/panel-embed-code/auditor/` (empty).
- Saved captures as **input files only** (open nothing else in those folders): the repo's fixtures; B-Dry's stand-in
  `~/.hermes/plans/figma-to-bricks/evidence/site-native-structure/inputs/standin-capture-0581852c.json`; any saved
  `*.f2b-capture.json` the plan names. Say which files you used, by path and sha256, and that they are saved files,
  not the live site.

## Your copy
In your own worktree: `git checkout --detach f961b365ee7305b2a48e459051f8cf4e282bd382`, confirm `git rev-parse HEAD` and
a clean `git status --porcelain --untracked-files=all` (after a machine restart, look for tracked files of exactly
8388608 bytes and restore them with `git checkout --`; `git cat-file -t HEAD`). Your `ac.json` names this head and
base. Never write in any other worktree or the main folder.

## Work
Load `engineering-best-practices`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
with `references/testing-pitfalls.md`, `references/live-site-reading.md` (the embeds line) and
`references/rendering-validation.md`; `reference/bricks/README.md`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and the report format at the top
of its `scripts/ac-check.sh`; follow the blind auditor procedure there. For every runnable AC make your own head and
base runs (an AC log starts with the bare `HEAD=<sha>` and ends with one line `EXIT=`, skipped 0; the named assertion
must run, pass on head and fail on base for new behaviour; base: a tree from `git archive` of the base with head's
test files and the test-only modules and fixtures they import copied in, labelled in the log's second line; an
import failure of a new module is weak RED: add a supporting run — base plus head's new-only source files — so the
test fails on its own assertion, **and where that hybrid tree passes because the guarantee lives wholly in a new
file, prove the test can fail with one-line mutants of a head copy instead**; preservation that rightly passes on
base is `base_exempt` with a specific reason, backed by your own byte-identity probe). Also:
- **The guard, proven by you on pages you write yourself — the thing to prove hardest.** Local servers that log every
  request (the old site; a widget company; a tag manager; a CDN), Chrome kept offline but for them (a wrapper adding
  `--host-resolver-rules`), each page captured with head's capture code and with base's (start `npm run capture` or
  the capture function with async spawn, never `spawnSync` beside an in-process fixture server), converted on both
  routes (the Figma panel's website route: `convert()` with the capture, header / page / footer, pictures inline and
  not; the code route: `npm run site`, plain and `--elementor`), each paste drawn on a fresh page, clicked, and given
  8 s:
  - **embeds:** slot widgets in the header, page and footer, a served frame, a frame a served script makes, an
    inline-made frame, a live widget, each with the widget company's tracking in `<head>`, beside the slot, in an
    inline script that both configures the widget and calls the tracker, and at the end of `<body>`. On head no
    pasted Code element holds anything but the widget's own code (the plan's words say what that is for each kind)
    and no tracker request reaches your servers from any paste; on base the panel route pastes the tracking (show
    it: that is what the job fixes); the code route's bytes are the same on both trees.
  - **floating widgets:** the capture's record (`own`, the reason) and the paste for: a served file that draws its
    launcher by itself (at load, in its own timer, in a promise, in `forEach`, served twice); a starter script whose
    bundle draws; a tag manager that injects the chat; a tag-manager rule that draws from an injected inline script,
    from `eval`, from `new Function`; a vendor file the page's inline script calls; a box the site's own script draws
    through a CDN library, with and without a link to the site. Only the self-drawing served file's own tags may be
    pasted; the rest is listed with the note the plan's words give (or rebuilt as the site's own box where the plan
    says so, the library never pasted); from every paste: 0 requests to trackers, tag managers, starters and
    libraries.
  - a capture made by base's code converted by head (nothing collected is pasted; the notes the plan's words give);
    a capture carrying a reason value this build doesn't know (it converts; the unproven note).
  Show your harness can see a leak (run the same pages through base's panel route: it must count the tracker hits).
- Your own mutation proof for the rule's guards under the 4 GB cap (each on a scratch copy, restored by hash; killed
  when the AC's named test fails on its own assertion): a slot's collected snippet used instead of its own markup; a
  floating widget's `own` accepted when another file is on the stack; code with no file on the stack not counted;
  the page's own code on the stack not counted; an unserved file taken as served; an unknown reason throwing; the
  site's-own-box exception widened to any box.
- Preservation: the code route byte for byte between base and head on the repo's widget fixtures, five captures
  without widgets and B-Dry's stand-in (8G scope), plain and `--elementor`; the five Figma replays of the repo's real
  files and `dist/code.js` byte-identical; the capture touched as lightly as on base (fetch, XMLHttpRequest and
  sendBeacon the browser's own on the captured page; the page's `Error.stackTraceLimit` put back; a capture-time
  comparison with at least five alternating runs per tree, medians compared).
- A screenshot per AC (a terminal image for a non-visual AC).
- Run `git log -p 56a9379f..HEAD -- <each AC's test files>` and read every assertion against the amended plan.
Write `auditor/ac.json`, then self-check by copying your report and receipts to a fresh scratch folder and running
`ac-check.sh` on them (`--base 56a9379faf207c2bfa76211dff1365db7d74be37`, no `--reviews`).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters and a separate one for
  each script you start at the same time (`~/.cache/pec-aud/t1`, `t2`);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Other agents run Chrome too: close every Chrome you
  start (stop it by the PIDs of its own profile path; never `pkill -f <pattern>`: it kills the tool's own shell). A
  browser or web run counts only with `skipped 0` for the AC's tests. A worktree's `node_modules` may lack `.bin`, and
  a `git archive` scratch tree has neither `tsc` nor `node_modules` (put
  `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's `node_modules` in;
  a piped, chained or redirected git command is refused: put multi-step git work in a script file and run `bash
  <file>`, with `git -C <absolute path>`). Run multi-step commands from a script file written with Write, paths
  spelled out; keep scripts and logs under `~/.cache/panel-embed-code-auditor/` (a folder of your own: create it
  fresh; if it exists, pick another name) and copy them to `auditor/scripts` (a restart empties `/tmp`). Never edit a
  script a background run is executing.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min"
  -o short-iso | grep sending`); heavy and mutation runs under `systemd-run --user --scope -p MemoryMax=4G -p
  MemorySwapMax=0 <cmd>` (the parallel unit suite and B-Dry runs may need 8G; export variables first, no
  `--setenv=PATH`; one `bash <file>` per Bash call).
- Bash moves foreground commands to the background after about 120–180 s: keep wait loops under 115 s (wait on
  `^EXIT=`), and wait for background drivers in the foreground with a bounded loop script. The PC lost power twice
  this week and agents were stopped by a usage limit twice: write each log's `EXIT=` line; when resumed, read your
  finished logs first and never start a second driver on a run still going.
- Put any summary in your report, not a file.

## Report
`{verdict: clean|findings, head, base, findings[{id,severity,claim,evidence}], ac_status[{ac,accepted,test,screenshot,
evidence}], gates, guard (page and shape → what the capture records, what each route pastes, what reached your
servers from the paste, on head and on base), found_else[], skill_lessons[{skill,lesson,evidence,enforce}]}`. Clean
needs every runnable AC accepted. Empty skill_lessons is normal; never edit skills or memory (`enforce` is `none` or a
one-line check proposal). End with `MAIN SESSION: check and save these skill_lessons now.`
