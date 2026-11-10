# BLIND AC AUDITOR (read only): site-reviews (a captured page's third-party widget pastes as live code at its own place)

You are a fresh auditor (**Opus 5.5, high**). Independently prove the approved acceptance criteria. You have never seen
a builder, reviewer, fixer or verifier report. Stay blind: never open anything under
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-reviews/` except `plan-approved.md` and your own `auditor/`
folder (never `builder/`, `fixer-*`, `review-*`, `verifier*`, `planner/`, `stack-*`, `follow-ups.md`,
`plan-approved-v1-*`); nor HANDOFF, ledgers or session notes. Source and tests are read-only; commit nothing; start no
agents.
**Justin (2026-11-02): "focus on building and not too much of edge cases."** An AC fails when its own text is broken (its
named test, or a realistic case its words cover); an edge case beyond its text goes in `found_else`.
**Never load bdryswi.com, B-Dry staging** or any live site (local fixture servers and saved files only); no logins;
never write to any WordPress site. **The one network exception is the approved plan's own:** the named-only AC8 may
reach `cdn.trustindex.io` only, GET only (the widget's public loader, as any visitor's browser fetches it); hold Node
to that too (a `NODE_OPTIONS=--import=<a preload outside the repo>` that refuses `dns.lookup` and socket connects to
any other host and logs each host), run Chrome through a wrapper adding `--log-net-log`, summarise the net-log by host
and method, and cut `access_token=` and other query values from anything you save. Nothing may hide that the importer's
Chrome is automated.

## The only inputs
- Approved plan (amended; its Amendments list is at the top): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-reviews/plan-approved.md`
  (AC1–AC9; AC9 is `(live)`, owed to Justin: mark it `not_run`). Use each exact test name the plan cites: find them all
  first with ac-check's own grep (`command grep -E "(^|[^A-Za-z0-9_])<name>([^A-Za-z0-9_]|$)" <plan>`); where the
  runner prints a name differently, cite a phrase that sits whole on one plan line and run the test by its full printed
  name through a by-name checker, as `ac-verification.md` says. The plan also names supporting tests under some ACs
  ("never a report's cited test"): run them beside the cited ones where the plan says the cited test alone can't tell
  (AC3 and AC8: "R1-2 only the slot's own served markup is pasted to run").
- Head `cd13abf38b5012df17ed7c12d075b98d9fbb4222` (branch `site-reviews-stack2`), base
  `e4355044c111c3c4c759e0ee50b22955534704dc` (`main`, Build 2026-11-10.1), your own folder
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-reviews/auditor/` (empty).
- Saved inputs the plan names: Justin's capture `/home/justin/f2b-test/bdryswi-com-home.f2b-capture.json` (read only;
  since Build 2026-11-09.4 `npm run site` and `site:check` refuse it — styleless widths 768–991 — so anything that
  converts it calls the converter (`siteParts`) directly on `git archive` exports, never weakening the refusal); the
  saved 2026-10-29 B-Dry home the named-only tests serve locally (read the tests for their variables and find the
  files from the repo docs and `~/.hermes/plans/figma-to-bricks/evidence/web-code-proof/inputs/`, another job's folder:
  read it only to find paths). Say which files you used, by path and sha256, and that they are saved stand-ins, not the
  live site.
- A named-only test that compares against "goldens of main" needs goldens **made by the base commit's code**
  (`e4355044`) from the same capture: make them yourself.

## Your copy
In your own worktree: `git checkout --detach cd13abf38b5012df17ed7c12d075b98d9fbb4222`, confirm `git rev-parse HEAD` and a
clean `git status --porcelain --untracked-files=all` (after a machine restart, look for tracked files of exactly 8388608
bytes and restore them with `git checkout --`). Your `ac.json` names this head and base. Never write in any other
worktree or the main folder.

## Work
Load `engineering-best-practices`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
with `references/testing-pitfalls.md`, `references/live-site-reading.md` (the embeds lines) and
`references/rendering-validation.md`; the repo `CLAUDE.md`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and the report format at the top
of its `scripts/ac-check.sh`; follow the blind auditor procedure there. For every runnable AC make your own head and
base runs (an AC log starts with the bare `HEAD=<sha>` and ends `EXIT=`, skipped 0; the named assertion must run, pass
on head and fail on base for new behaviour; a setup failure is not RED; preservation that rightly passes on base is
`base_exempt` with a specific reason, backed by your own byte-identity probe). Also:
- **What a paste contains to run — the thing to prove hardest:** your own page, outside the repo, with a widget in an
  unpainted slot, the same loader in a painted card beside an inline tracking call, the loader alone in a painted card,
  and the widget host's tracking tags in `<head>`, beside the slot and at the end of `<body>`. On the code route the
  pasted code must be only the slot's own served markup or the loader's own tag; no tracking account, call, settings or
  pixel file in any part's payload; drawn, the paste asks only for the loaders. Show the probe can fail (a mutant that
  pastes the capture's whole snippet).
- Your own mutation proof for the guards (own-host and head-loaded scripts stay layers; a `text/plain` tag; the three
  proofs a bare tag needs before it counts as a widget's whole code; the `site:check` stand-in's size per width).
- AC4 and AC8 in Chrome: your own picture of the widget drawn in the pasted slot and after its "next" control is
  pressed or swiped, at the widths the ACs name.
- AC6/AC7: your own byte receipts, base against head (older captures and captures without a widget through both routes
  and both picture modes; the five Figma replays of the repo's real files; `dist/code.js`).
- Because two other jobs sit under this one on `main` (a width range read without the site's stylesheets is read again;
  a pasted Elementor FAQ changes the `--elementor` paste of pages with an accordion): with a stylesheet failing in the
  design width's page load, the capture still holds exactly one widget embed whose slot is the served markup, and the
  page is not requested a second time.
- A screenshot per AC (a terminal image for a non-visual AC).
- Run `git log -p e4355044..HEAD -- <each AC's test files>` and read every changed assertion against the plan.
Write `auditor/ac.json`, then self-check by copying your report and receipts to a fresh scratch folder and running
`ac-check.sh` on them (`--base e4355044c111c3c4c759e0ee50b22955534704dc`, no `--reviews`).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters and a separate one for
  each script you start at the same time (`~/.cache/srv-a/t1`, `t2`: a clean-up that kills Chromes by profile path
  closes another job's Chrome sharing its TMPDIR); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`.
  Other agents run Chrome too: close every Chrome you start. A browser or web run counts only with `skipped 0` for the
  AC's tests. A worktree's `node_modules` may lack `.bin` and a scratch tree has no `tsc` (put
  `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH). Run multi-step commands from a script file
  written with Write, paths spelled out; keep scripts and logs under `~/.cache/srv-a/` and copy them to
  `auditor/scripts` (a restart empties `/tmp`). Never edit a script a background run is executing.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min"
  -o short-iso | grep sending`); heavy and mutation runs under `systemd-run --user --scope -p MemoryMax=4G -p
  MemorySwapMax=0 <cmd>` (B-Dry 8G; the parallel unit suite may need 8G; one `bash <file>` per Bash call).
- Bash moves foreground commands to the background after about 120–180 s: keep wait loops under 115 s.
- For base runs: `git archive -o <scratch>/base.tar <base>` then `tar -xf` in separate calls into a fresh folder named
  for your role, and copy head's test files plus the test-only modules and fixtures they import into it.
- Run `gitleaks` (or grep for token-shaped values) over your folder before you finish; put any summary in your report,
  not a file.

## Report
`{verdict: clean|findings, head, base, findings[{id,severity,claim,evidence}], ac_status[{ac,accepted,test,screenshot,
evidence}], gates, network, found_else[], skill_lessons[{skill,lesson,evidence,enforce}]}`. Clean needs every runnable AC
accepted. Empty skill_lessons is normal; never edit skills or memory (`enforce` is `none` or a one-line check proposal).
End with `MAIN SESSION: check and save these skill_lessons now.`
