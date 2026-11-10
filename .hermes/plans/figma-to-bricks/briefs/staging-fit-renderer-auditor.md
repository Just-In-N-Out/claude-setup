# BLIND AC AUDITOR (read only): staging-fit-renderer (the test renderer prints what real Bricks prints; `site:live`, a read-only tool that measures a published Bricks page)

You are a fresh auditor (**Opus 5.5, high**). Independently prove the approved acceptance criteria. You have never seen
a builder, reviewer, fixer or verifier report. Stay blind: never open anything under
`/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-renderer/` except `plan-approved.md` and your own
`auditor/` folder (never `builder/`, `fixer-*`, `review-*`, `verifier*`, `stack-*`, `follow-ups.md`,
`plan-approved-v*`); nor HANDOFF, ledgers, the plan copy under `docs/plans/`, or session notes. Source and tests are
read-only; commit nothing; start no agents.
**Justin (2026-11-02): "focus on building and not too much of edge cases."** An AC fails when its own text is broken (its
named test, or a realistic case its words cover); an edge case beyond its text goes in `found_else`.
**Never load bdryswi.com, B-Dry staging** or any live site (local stand-in servers and saved files only); no logins;
never write to any WordPress site. Nothing may hide that the tools' Chrome is automated.

## The only inputs
- Approved plan (amended 1–3; its Amendments list is at the top):
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-renderer/plan-approved.md` (AC1–AC5; AC5 is
  `(live)`, owed to Justin: mark it `not_run`). Judge each AC by its amended words. Use each exact test name the plan
  cites: find them all first with ac-check's own grep (`command grep -E "(^|[^A-Za-z0-9_])<name>([^A-Za-z0-9_]|$)"
  <plan>`); where the runner prints a name differently, cite a phrase that sits whole on one plan line and run the test
  by its full printed name through a by-name checker, as `ac-verification.md` says. Run the supporting tests the plan's
  amendments name beside the cited ones.
- Head `8a8ec104bdad91635bfbb0732a0ebc1a0673d9b5` (branch `staging-fit-renderer-stack4`), base
  `2879e4968438e7a442594d1021cb024dd85b3976` (`main`, Build 2026-11-10.3), your own folder
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-renderer/auditor/` (empty).
- Saved inputs the plan's named-only clauses use (read the tests for their variables; search the plan and the repo
  docs for the paths): Justin's saved paste and capture under `/home/justin/f2b-test/` (read only; since Build
  2026-11-09.4 `npm run site`, `site:check` and — on this head — `site:live` refuse the capture
  `bdryswi-com-home.f2b-capture.json`, styleless at 768–991: never weaken that refusal), and the saved staging GET the
  planner kept under `~/.hermes/plans/figma-to-bricks/evidence/staging-fit/planner/` (another job's folder: read it
  only to find the saved files, index in its `README.md`). Say which files you used, by path and sha256, and that they
  are saved files, not the live site.

## Your copy
In your own worktree: `git checkout --detach 8a8ec104bdad91635bfbb0732a0ebc1a0673d9b5`, confirm `git rev-parse HEAD` and a
clean `git status --porcelain --untracked-files=all` (after a machine restart, look for tracked files of exactly 8388608
bytes and restore them with `git checkout --`). Your `ac.json` names this head and base. Never write in any other
worktree or the main folder.

## Work
Load `engineering-best-practices`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
with `references/testing-pitfalls.md`, `references/live-site-reading.md` ("Holding a Chrome to read-only"; "Measure a
published Bricks page against its paste by structure") and `references/rendering-validation.md`;
`reference/bricks/README.md`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and the report format at the top
of its `scripts/ac-check.sh`; follow the blind auditor procedure there. For every runnable AC make your own head and
base runs (an AC log starts with the bare `HEAD=<sha>` and ends `EXIT=`, skipped 0; the named assertion must run, pass
on head and fail on base for new behaviour; a setup or import failure of a new module is weak RED: add a supporting base
run with head's new-only source files or a labelled stand-in so the test fails on its own assertion; preservation that
rightly passes on base is `base_exempt` with a specific reason, backed by your own byte-identity probe; a test with a
known load flake — `site-live.test.ts` and anything running `site:check --all` on the code-page fixture can read
5.09 px once in a while — is rerun alone before it is judged). Also:
- **The read-only guard, proven by you — the thing to prove hardest (AC2 as amended: "every other request … is refused
  before it leaves"; Justin's rule: "Never write to any WordPress site; GET/read only"):** run `site:live` on your own
  local stand-in "published" page that beacons and keepalive-POSTs on `visibilitychange`, `pagehide`, `beforeunload`,
  `unload` and on a timer, from the page, a cross-site frame, a service worker, a shared worker and a dedicated worker,
  and opens WebSockets; through every ending — OK, no paste on the page, a login page, an error mid-run, Ctrl+C
  mid-run and while Chrome is still starting, Ctrl+\, SIGTERM, SIGHUP, output cut by `| head` — and read the stand-in
  server at least 3 s after the tool's process is gone: nothing but GET/HEAD/OPTIONS arrived and no process of the
  tool's Chrome is left (count by its profile path; never signal a process group other agents' Chromes are in). Show
  your probe can see a leak (a control with the guard's closing step or its refusal removed on a scratch copy). A
  local https page naming a reports endpoint and breaking its own report-only CSP gets no report upload in 70 s.
- Your own mutation proof for the rule's guards (the renderer's `.cls.brxe-<element>` selectors and order; the page
  mapping by structure, a library's copies skipped; the 5 px failure threshold; the plain lines for "no paste on the
  page" and a login page; the live widget's stand-in and its "drew nothing" line; the styleless-capture refusal).
- AC3's `--whole` and other-host pictures: your own run and picture.
- Preservation: `site:check`'s stdout byte-identical between base and head on the repo's elementor-swiper8,
  elementor-slider (`--elementor`), live-widget and live-widget-places fixtures, and its `report.json` equal in every
  value both trees write (the plan adds report keys: say which, from the plan's own text); the five Figma replays of
  the repo's real files and `dist/code.js` byte-identical; every other browser test's result by name unchanged for the
  files you run.
- A screenshot per AC (a terminal image for a non-visual AC).
- Run `git log -p 2879e496..HEAD -- <each AC's test files>` and read every changed assertion against the plan.
Write `auditor/ac.json`, then self-check by copying your report and receipts to a fresh scratch folder and running
`ac-check.sh` on them (`--base 2879e4968438e7a442594d1021cb024dd85b3976`, no `--reviews`).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters and a separate one for
  each script you start at the same time (`~/.cache/sfr-a/t1`, `t2`: a clean-up that kills Chromes by profile path
  closes another job's Chrome sharing its TMPDIR); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`.
  Other agents run Chrome too: close every Chrome you start. A browser or web run counts only with `skipped 0` for the
  AC's tests. A worktree's `node_modules` may lack `.bin`, and a `git archive` scratch tree has neither `tsc` nor
  `node_modules` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's
  `node_modules` in). Run multi-step commands from a script file written with Write, paths spelled out; keep scripts
  and logs under `~/.cache/sfr-a/` and copy them to `auditor/scripts` (a restart empties `/tmp`). Never edit a script a
  background run is executing.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min"
  -o short-iso | grep sending`); heavy and mutation runs under `systemd-run --user --scope -p MemoryMax=4G -p
  MemorySwapMax=0 <cmd>` (the parallel unit suite may need 8G; one `bash <file>` per Bash call).
- Bash moves foreground commands to the background after about 120–180 s: keep wait loops under 115 s. If you are
  stopped by a usage limit and resumed, read your finished logs first and never start a second driver on a run still
  going.
- For base runs: `git archive -o <scratch>/base.tar <base>` then `tar -xf` in separate calls into a fresh folder named
  for your role, and copy head's test files plus the test-only modules, fixtures and new reference assets they import
  into it.
- Put any summary in your report, not a file.

## Report
`{verdict: clean|findings, head, base, findings[{id,severity,claim,evidence}], ac_status[{ac,accepted,test,screenshot,
evidence}], gates, guard (ending → what arrived, Chrome left), found_else[], skill_lessons[{skill,lesson,evidence,
enforce}]}`. Clean needs every runnable AC accepted. Empty skill_lessons is normal; never edit skills or memory
(`enforce` is `none` or a one-line check proposal). End with `MAIN SESSION: check and save these skill_lessons now.`
