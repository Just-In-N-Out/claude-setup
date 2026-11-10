# BLIND AC AUDITOR (read only): site-slider (a captured Elementor carousel pastes as Bricks' Slider (Nestable) that moves like the site's)

You are a fresh auditor (**Opus 5.5, high**). Independently prove the approved acceptance criteria. You have never seen
a builder, reviewer, fixer or verifier report. Stay blind: never open anything under
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-slider/` except `plan-approved.md` and your own `auditor/`
folder (never `builder/`, `fixer-*`, `review-*`, `verifier*`, `planner/`, `stack-*`, `follow-ups.md`,
`plan-approved-v*`); nor HANDOFF, ledgers, the plan copy under `docs/plans/`, or session notes. Source and tests are
read-only; commit nothing; start no agents.
**Justin (2026-11-02): "focus on building and not too much of edge cases."** An AC fails when its own text is broken (its
named test, or a realistic case its words cover); an edge case beyond its text goes in `found_else`.
**Never load bdryswi.com, B-Dry staging** or any live site (local fixture servers and saved files only); no logins;
never write to any WordPress site. Nothing may hide that the importer's Chrome is automated.

## The only inputs
- Approved plan (amended 1–11; its Amendments list is at the top):
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-slider/plan-approved.md` (AC1–AC10; AC10 is `(live)`, owed
  to Justin: mark it `not_run`). Judge each AC by its amended words. Use each exact test name the plan cites: find them
  all first with ac-check's own grep (`command grep -E "(^|[^A-Za-z0-9_])<name>([^A-Za-z0-9_]|$)" <plan>`); where the
  runner prints a name differently, cite a phrase that sits whole on one plan line and run the test by its full printed
  name through a by-name checker, as `ac-verification.md` says. Run the supporting tests the plan names beside the
  cited ones.
- Head `8a13b71c46b26864e2b29ab08fae5f941c7b040e` (branch `site-slider-stack3`), base
  `f708dfb659049db50bb45df8026faabee2ee0ad7` (`main`, Build 2026-11-10.2), your own folder
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-slider/auditor/` (empty).
- **AC9 (named-only, B-Dry):** the plan (amendment 11) names the capture to use until Justin's re-capture exists:
  `~/.hermes/plans/figma-to-bricks/evidence/elementor-phone-fit/planner/bdry-standin.f2b-capture.json`, sha256
  `3c238957cea09ba6ac78027600d76eea53f29cd2981a85a3a9cdcbf774686dda` (check the hash; it is the saved 2026-10-29 home
  served locally, not the live site). `F2B_BDRY_BASE` and `F2B_BDRY_BASE_REPORT` must be made by you from that same
  file with the base commit's code (`f708dfb6`): read the test for its variables. 8G scope. Record the file's sha256.
  Justin's own capture `/home/justin/f2b-test/bdryswi-com-home.f2b-capture.json` is refused by `npm run site` /
  `site:check` since Build 2026-11-09.4 (styleless widths 768–991): don't use it through the tools, and never weaken
  that refusal.

## Your copy
In your own worktree: `git checkout --detach 8a13b71c46b26864e2b29ab08fae5f941c7b040e`, confirm `git rev-parse HEAD` and a
clean `git status --porcelain --untracked-files=all` (after a machine restart, look for tracked files of exactly 8388608
bytes and restore them with `git checkout --`). Your `ac.json` names this head and base. Never write in any other
worktree or the main folder.

## Work
Load `engineering-best-practices`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
with `references/testing-pitfalls.md`, `references/live-site-reading.md` ("Site sliders") and
`references/rendering-validation.md`; `reference/bricks/README.md` and the slider sample under `reference/bricks/`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and the report format at the top
of its `scripts/ac-check.sh`; follow the blind auditor procedure there. For every runnable AC make your own head and
base runs (an AC log starts with the bare `HEAD=<sha>` and ends `EXIT=`, skipped 0; the named assertion must run, pass
on head and fail on base for new behaviour; a setup or import failure of a new module is weak RED: add a supporting base
run with head's new-only source files or a labelled stand-in so the test fails on its own assertion; preservation that
rightly passes on base is `base_exempt` with a specific reason, backed by your own byte-identity probe). Also:
- **In Chrome with Bricks' own slider script through the repo's renderer, your own readings and pictures:** the pasted
  slider at load, after Next, after Previous on the first slide (a loop), after a click on a dot; that it plays on the
  site's timing and pauses under the mouse; at the widths the ACs name. A hero whose slides size by a declared height
  (Elementor Pro's Slides) is as tall as the site's; a default Image Carousel is as tall as the site's; arrows and dots
  sit where the site puts them (the plan's rule says when).
- Your own mutation proof for the rule's guards (the settings mapping per the amended rule: per view and gap by tier,
  loop / rewind / fade, autoplay with pause keys written only when true, arrows and dots from either key family; the
  restore class and its `:where()` scoping; `site:check` holding a slider on its first slide; a slide's own height).
- AC8: your own byte receipt, base against head (saved captures and fixture sites without an Elementor slider through
  both routes and both picture modes; the plain route on captures that hold one; the five Figma replays; `dist/code.js`).
- Because three other jobs sit under this one on `main` (a width range read without the site's stylesheets is read
  again; a pasted Elementor FAQ; a third-party widget pasted as one live Code element): a page holding a slider and a
  live widget converts to one Slider (Nestable) and one live Code element, and `site:check --all --elementor` is OK on
  it.
- A screenshot per AC (a terminal image for a non-visual AC).
- Run `git log -p f708dfb6..HEAD -- <each AC's test files>` and read every changed assertion against the plan.
Write `auditor/ac.json`, then self-check by copying your report and receipts to a fresh scratch folder and running
`ac-check.sh` on them (`--base f708dfb659049db50bb45df8026faabee2ee0ad7`, no `--reviews`).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters and a separate one for
  each script you start at the same time (`~/.cache/ssl-a/t1`, `t2`: a clean-up that kills Chromes by profile path
  closes another job's Chrome sharing its TMPDIR); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`.
  Other agents run Chrome too: close every Chrome you start. A browser or web run counts only with `skipped 0` for the
  AC's tests. A worktree's `node_modules` may lack `.bin`, and a `git archive` scratch tree has neither `tsc` nor
  `node_modules` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's
  `node_modules` in). Run multi-step commands from a script file written with Write, paths spelled out; keep scripts
  and logs under `~/.cache/ssl-a/` and copy them to `auditor/scripts` (a restart empties `/tmp`). Never edit a script a
  background run is executing.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min"
  -o short-iso | grep sending`); heavy and mutation runs under `systemd-run --user --scope -p MemoryMax=4G -p
  MemorySwapMax=0 <cmd>` (B-Dry 8G; the parallel unit suite may need 8G; one `bash <file>` per Bash call).
- Bash moves foreground commands to the background after about 120–180 s: keep wait loops under 115 s. If you are
  stopped by a usage limit and resumed, read your finished logs first and never start a second driver on a run still
  going.
- For base runs: `git archive -o <scratch>/base.tar <base>` then `tar -xf` in separate calls into a fresh folder named
  for your role, and copy head's test files plus the test-only modules, fixtures and new reference assets they import
  into it.
- Put any summary in your report, not a file.

## Report
`{verdict: clean|findings, head, base, findings[{id,severity,claim,evidence}], ac_status[{ac,accepted,test,screenshot,
evidence}], gates, found_else[], skill_lessons[{skill,lesson,evidence,enforce}]}`. Clean needs every runnable AC accepted.
Empty skill_lessons is normal; never edit skills or memory (`enforce` is `none` or a one-line check proposal). End with
`MAIN SESSION: check and save these skill_lessons now.`
