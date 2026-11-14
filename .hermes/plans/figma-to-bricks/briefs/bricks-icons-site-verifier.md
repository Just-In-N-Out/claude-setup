# Role: verifier (read-only): bricks-icons-site

You are a fresh verifier who never saw the build or the review (**Opus 5.5, high**). Prove each acceptance criterion yourself. Change no
source or test, commit nothing, start no agents. Plain `git` in your own worktree, each command alone (never `git -C` the main folder; no git
piped into another command: `git archive -o <file> <sha>`, then extract separately). Never load any live site (every Chrome that draws a site
capture or paste launches with `SITE_OFFLINE` from `tools/lib/site-chrome.ts`); never write to any WordPress site; never call alttext.ai (only
`test/fixtures/wp-standin.ts` and local stand-ins on 127.0.0.1, a made-up password and key); touch nothing under `~/Downloads` (Justin's scan
copy: `~/.hermes/plans/figma-to-bricks/evidence/media-clickable/run/`). The folder `evidence/bricks-icons-site/verifier/` doesn't exist yet:
create it, and check it is empty before writing. Write evidence summaries as .txt or .json (a subagent's Write refuses .md).

**Skills:** read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and follow it (its by-name checker:
the head may print test names with an `ACn ` prefix the plan's cited names lack); the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/rendering-validation.md` and `references/live-site-reading.md`. Read both `repeat-mistakes.md` files first (`figma-to-bricks/references/`,
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/`). Don't read builder's, planners' or reviewers' reports or folders as proof.
Keep to the standard at the top of the repo CLAUDE.md "Decisions the user made": also say where a Bricks pro would not find the paste logical.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/bricks-icons-site/plan-approved.md` (AC1–AC5; AC5 live:
  `not_run`). The job: with a media map, a scanned site's drawn svg becomes Bricks' Icon element showing its SVG from the media library
  (class on the svg; colour and size in the Icon's controls), the rest stay Code elements, named; `site:upload`/`site:import --svg` list and
  send each distinct drawing once after the typed yes, never to alttext.ai; a site refusing SVG leaves Code elements, named; pastes without a
  map (or a map holding no drawing) byte for byte as before.
- Builder's rulings (not yet confirmed; HANDOFF's top section): Q1, Q4–Q8 ⭐, R1–R10; R1 names the upload `icon-<8>-image.svg` (AC2 said
  `icon-<8 letters>.svg`) under the standing `-image` rule — judge AC2 by its meaning and say so.
- Head `a06ed92d887bd960fd3dc3df33fa7c2a620fa8f2` (branch `bricks-icons-site-build`), base `cf4f887de2a52ad8d7cb757486cc1916f3e3f4f4`
  (site-no-div; main is `84722938` = cf4f887d plus a notes commit). `git checkout --detach a06ed92d…`. Old code: a `git archive` of cf4f887d
  with head's test files and fixtures copied in (build `dist/` there before browser runs; set `GIT_DIR` inside a runner for tests reading
  `git show`). AC logs start `HEAD=<sha>` ("archive" on line 2), end `EXIT=`. Review 1 was clean.

## Work
1. Gates on head against base by name: both typechecks, `npm run check` (8G scope), the full `test:web` and `test:browser` file by file, one
   at a time, each under a 4G scope (B-Dry files 8G; compare every failure with base by name; rerun a failure alone once; known failing here:
   composition-clipping, fonts, hero-pair, peer-sides, pill-holder, capture-opens-guards' 2 service-worker cases; flaky under load:
   render-site-motion, strips' carousel, min-font, capture-styled-ranges, site-icons-look's pixel compare (rerun alone)); the story pins with
   `F2B_STORY_PINS=1` (`site-media-unchanged` AC4 fails on base too with the same 308 misses: compare lists); Figma replays and `dist/` byte
   for byte base; Justin's scan and the B-Dry stand-in through `npm run site` without a map, plain and `--elementor`, base vs head identical.
2. Every AC's test by its plan name on head (pass) and on old code (fail; AC4 is a characterization pin: `base_exempt` backed by a mutant);
   a picture per AC (Structure dumps; paste without the map | with it at 1440 and 390; a terminal capture for AC2).
3. Your own checks: a fixture site of your own (not the repo's) with a flat-colour svg icon, a stroked one, a two-colour one, one with ids or
   a `<use>`, one with no viewBox, a script-made one, an icon inside a ☰ drawer and one in a hovered link — what becomes an Icon and what
   stays Code, named; drawn equal at rest, hovered and with the drawer open on Bricks 2.4.2 and 2.3.9; `site:upload --svg --dry-run` and a
   real run against `test/fixtures/wp-standin.ts` (each distinct drawing once, a re-run sends nothing, without `--svg` nothing, a site refusing
   SVG named); typed Width/Height/Fill beat the class.
4. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/bricks-icons-site/verifier/ac.json` and logs there; self-check with `ac-check.sh`
   on a copy (`--base cf4f887de2a52ad8d7cb757486cc1916f3e3f4f4`, no `--reviews`).

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/bisv/t1`); scripts under `~/.cache/bisv/s/`;
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
