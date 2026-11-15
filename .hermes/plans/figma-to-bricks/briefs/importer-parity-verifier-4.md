# Role: verifier 3 (read-only, after the rebase onto main with source conflicts and the gate fix): importer-parity

You are a fresh verifier who never saw the build or the review (**Opus 5.5, high**). Prove each acceptance criterion yourself. Change no
source or test, commit nothing, start no agents. Plain `git` in your own worktree, each command alone (never `git -C` the main folder; no git
piped into another command: `git archive -o <file> <sha>`, then extract separately). Never load any live site (every Chrome that draws a site
capture or paste launches with `SITE_OFFLINE` from `tools/lib/site-chrome.ts`); run any test that captures the B-Dry stand-in or draws Justin's scan only with no outside network (`unshare -rn sh -c 'ip link set lo up && ip link add d0 type dummy && ip addr add 10.255.0.2/24 dev d0 && ip link set d0 up && ip route add unreachable default && exec unshare --user --map-user=1000 --map-group=1000 <cmd>'`, inside the memory scope); never write to any WordPress site; never call alttext.ai (only
`test/fixtures/wp-standin.ts` and local stand-ins on 127.0.0.1, a made-up password and key); touch nothing under `~/Downloads` (Justin's scan
copy: `~/.hermes/plans/figma-to-bricks/evidence/media-clickable/run/`). The folder `evidence/importer-parity/verifier-4/` doesn't exist yet:
create it, and check it is empty before writing. Write evidence summaries as .txt or .json (a subagent's Write refuses .md).

**Skills:** read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and follow it (its by-name checker:
the head may print test names with an `ACn ` prefix the plan's cited names lack); the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/rendering-validation.md` and `references/live-site-reading.md`. Read both `repeat-mistakes.md` files first (`figma-to-bricks/references/`,
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/`). Don't read builder's, planners' or reviewers' reports or folders as proof.
Keep to the standard at the top of the repo CLAUDE.md "Decisions the user made": also say where a Bricks pro would not find the paste logical.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-parity/plan-approved.md` (AC1–AC22; AC22 live:
  `not_run`). The job: the importer's paste uses Bricks' own settings and elements like a Bricks pro would — named elements, settings before
  custom CSS (controls, Button Style), native Accordion, Slider, Video, Nav (Nestable), Form, lines; the switch off = base byte for byte;
  Figma untouched.
- Rulings (not yet confirmed; HANDOFF's top section): the builder's (1)–(10) and fixer 1's 11–14 (a Swiper's per view from
  `originalParams`, an older capture with breakpoints static; `slidesPerView: "auto"` static; Vimeo byline/title/portrait, a background film
  a Code element; a Form's shared looks in its own controls, per-field looks keyed by kind or the field's id).
- The first verifier (`evidence/importer-parity/verifier/`, on b232c9de) accepted every agent-run AC but AC13 (Splide arrows drew 0×0; the
  test compared only boxes). Fix 2 gives bare svg sizes px, an svg with no declared fill its inherited fill, and extends AC13's cited test
  to compare each arrow's drawing (size, colour) site vs paste; it also splits the earlier story's `site-shared-styles-off` pin (Milestone
  1's 608 with `parity: false`, plus a golden of the on-state). Review 3 clean (P3s: a stroked `fill="none"` chevron pastes black; a
  shape's own fill attribute loses to an ancestor's — follow-ups). You may read the first verifier's `support/probe-slider-arrows.log`
  only to rerun that probe yourself. Look at the pictures each AC's test writes, not only its rows.
- Head **`a049bb4baa7329b8184cb3777e3ffabf47e1252a`** (branch `importer-parity-final`), base **main `fe29b65d94da2c6f4e1ecb881354b9e9b9842cef`**
  (Build 2026-11-14.4: site-shared-styles' shared classes and `palette.json`, bricks-icons-site's Icons, importer-app). Verifier 2 proved
  AC1–AC21 on the pre-rebase head 74557888 but one gate was red (site-page-bdry's bare-name test: `site-accordion` on the plain route); the
  job was then rebased with source conflicts (convert.ts, kinds.ts, parts.ts, structure.ts, render.ts) and the gate fixed test-only with one
  shared list (`test/unit/lib/site-shared-classes.ts`); review 4 of that resolution is clean. `git checkout --detach a049bb4b…`. Old code: a
  `git archive` of fe29b65d with head's test files and fixtures copied in (where a new module doesn't import, prove with a one-line mutant
  of head; build `dist/` there before browser runs; set `GIT_DIR` and `F2B_SERVICES_FILE` inside a runner for tests reading `git show`). AC
  logs start `HEAD=<sha>` ("archive" on line 2), end `EXIT=`.
- Known on main itself, not this job: `icon-elements` renderer@600/390 "11 icons shown"; `site-motion-bdry`'s Elementor hover-look test;
  `site-media-unchanged`'s 308 misses; `site-live` 3 of 6; `site-upload-icons` needs the network (AVIF encoder download: run it with network,
  local fixtures only).

## Work
1. Gates on head against base by name: both typechecks, `npm run check` (8G scope), the full `test:web` and `test:browser` file by file, one
   at a time, each under a 4G scope (B-Dry files 8G; compare every failure with base by name; rerun a failure alone once; known failing here:
   composition-clipping, fonts, hero-pair, peer-sides, pill-holder, capture-opens-guards' 2 service-worker cases; flaky under load:
   render-site-motion, strips' carousel, min-font, capture-styled-ranges, marquee, site-controls' hover (rerun alone)); the pins with
   `F2B_PIN_BASE=1` and the story pins with `F2B_STORY_PINS=1` (`site-media-unchanged` AC4 fails on base too with the same 308 misses:
   compare lists); Figma replays and `dist/` byte for byte base; Justin's scan and the B-Dry stand-in through `npm run site`, plain and
   `--elementor`, base vs head drawn in Chrome at 1440, 1024, 768 and 390 (0 px moved beyond the plan's tolerance).
2. Every AC's test by its plan name on head (pass) and on old code (fail; a characterization pin is `base_exempt` backed by a mutant); a
   picture per AC (Structure dumps; base | head at 1440 and 390; a terminal capture otherwise).
3. Your own checks: a fixture site of your own (not the repo's) with a plain menu with a sub-list, a details FAQ, a Swiper slider with
   mobile-first breakpoints, a YouTube and an unlisted Vimeo frame, a simple contact form with a select, a textarea and a focus look, a
   bordered card with a hover, a divider line — each becomes the plan's Bricks element, draws as the site at rest, hovered, focused and
   opened on Bricks 2.4.2 and 2.3.9; edit the pasted Form (delete, add and move a field; set Field background in its control) and say what
   holds; the form's mail goes to the WordPress admin only. Also on Justin's scan both routes: every `var(--color-…)` the pastes use is in `palette.json`, one writer per property (site-shared-styles' AC4), and an Icon's class writes no Bricks control.
4. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-parity/verifier-4/ac.json` and logs there; self-check with `ac-check.sh`
   on a copy (`--base fe29b65d94da2c6f4e1ecb881354b9e9b9842cef`, no `--reviews`).

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/ipv4/t1`); scripts under `~/.cache/ipv4/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`** (without it browser tests skip and exit 0); close every Chrome you start
(`pgrep -f '[u]ser-data-dir=<path>'`); one Chrome suite at a time; memory scopes `systemd-run --user --scope -p MemoryMax=<n>G -p
MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`. Write scripts with the Write tool. Use
`tail -n 3`. Waits under 115 s; long suites with `setsid --fork`, waiting on `^EXIT=`; a suite driver skips files already in its log (delete
logs with no `# tests` line before resuming). SIGTERM/143/137/"Killed" may be earlyoom or the scope's own OOM: check `journalctl -u earlyoom`
and `journalctl --user | grep -E 'oom-kill|OOM killer'` first. Finish every gate before reporting (don't hand back "incomplete"). Away rule:
if you need to figure something out, research it; if nothing is found, take your best-reasoned answer and say so.

## Report (as text; only ac.json and logs are written)
Per AC: test, head, old code (or mutant), evidence; gates by name; own checks; Bricks-pro notes; `verdict`; `ac_status`;
`skill_lessons[{skill, lesson, evidence, enforce}]`, ending with: `MAIN SESSION: check and save these skill_lessons now.`


## Update for this run (main session, 2026-11-15) — overrides the head, base and folders above
- Head **`34e02b9062596891d33377e2eb829c1ffebee046`** (branch `importer-parity-fix4`), base **main `e2fc35aaa6b7e3a662d0c3cce37ec636495a5405`** (Build 2026-11-15.1: shared-palette's site colours on top of fe29b65d). Wherever the text above says `a049bb4b…` read `34e02b90…`, and `fe29b65d…` read `e2fc35aa…` (the old code is a `git archive` of e2fc35aa with head's tests copied in; `ac-check.sh --base e2fc35aaa6b7e3a662d0c3cce37ec636495a5405`).
- Since the last checks: fixer 4 moved the job onto e2fc35aa (conflicts with shared-palette, keep-both) and fixed AC2 (a folded wrapper's by-id names counted in a notes line), AC13 (a Swiper that is its section's only box becomes a Slider inside the Section; a slider that is a part's top box stays static, named), AC12 (a details FAQ gets `independentToggle` unless its details share one name) and AC16 (the capture keeps `type` on buttons, `name` on details; a form whose button is type=button/reset stays as it is, named; an older capture as before plus one note). Review 5 clean.
- Also run `test/browser` with the network on (Splide, Google Fonts) and person-check web tests with `DISPLAY=:0`; B-Dry/scan files in the namespace.
- Known on main itself, not this job: also `importer-app-notes` (styles.txt listed), `panel-embed-unchanged` and `site-scroll-lock-base` story pins.
- Write to `evidence/importer-parity/verifier-4/` (create it; it must be empty).
- The blind auditor works on the same head at the same time; never read its folder.
