# Role: verifier (read-only): site-shared-styles

You are a fresh verifier who never saw the build or the review (**Opus 5.5, high**). Prove each acceptance criterion yourself. Change no
source or test, commit nothing, start no agents. Plain `git` in your own worktree, each command alone (never `git -C` the main folder; no git
piped into another command: `git archive -o <file> <sha>`, then extract separately). Never load any live site (every Chrome that draws a site
capture or paste launches with `SITE_OFFLINE` from `tools/lib/site-chrome.ts`); never write to any WordPress site; never call alttext.ai (only
`test/fixtures/wp-standin.ts` and local stand-ins on 127.0.0.1, a made-up password and key); touch nothing under `~/Downloads` (Justin's scan
copy: `~/.hermes/plans/figma-to-bricks/evidence/media-clickable/run/`). The folder `evidence/site-shared-styles/verifier/` doesn't exist yet:
create it, and check it is empty before writing. Write evidence summaries as .txt or .json (a subagent's Write refuses .md).

**Skills:** read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and follow it (its by-name checker:
the head may print test names with an `ACn ` prefix the plan's cited names lack); the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/rendering-validation.md` and `references/live-site-reading.md`. Read both `repeat-mistakes.md` files first (`figma-to-bricks/references/`,
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/`). Don't read builder's, planners' or reviewers' reports or folders as proof.
Keep to the standard at the top of the repo CLAUDE.md "Decisions the user made": also say where a Bricks pro would not find the paste logical.

## Inputs
- Approved plan (read-only, amendment 1): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-shared-styles/plan-approved.md`
  (AC1–AC15; AC15 live: `not_run`). The job: a website paste's repeated looks live in shared purpose-named classes (text styles, buttons,
  cards and boxes, rows), same-looking elements share one, a one-off tweak sits on the element, never two classes writing one property; the
  site's colours go to one palette (palette.json, Style Manager → Colors) and settings name them; looks stay true; the switch off and Figma
  designs byte for byte as before.
- Rulings (not yet confirmed; HANDOFF's site-shared-styles section): the builder's, fixer 1's (em line heights kept as written), and the
  rebase fixer's ruling 5 (a section paste carries no fonts class, so its classes name families bare as on main; review 3's R3-1 says AC5
  still holds as worded — judge it).
- Head `7977b8f892339a8d8725bf67cbd30b9a69317171` (branch `site-shared-styles-final`), base main `84722938b32c82e2dc5041bda6383ac12bf7793d`
  (Build 2026-11-14.1). `git checkout --detach 7977b8f8…`. Old code: a `git archive` of 84722938 with head's test files and fixtures copied
  in (where a new module doesn't import, prove with a one-line mutant of head; build `dist/` there before browser runs; set `GIT_DIR` inside
  a runner for tests reading `git show`). AC logs start `HEAD=<sha>` ("archive" on line 2), end `EXIT=`. Reviews 1–3 clean.

## Work
1. Gates on head against base by name: both typechecks, `npm run check` (8G scope), the full `test:web` and `test:browser` file by file, one
   at a time, each under a 4G scope (B-Dry files 8G; compare every failure with base by name; rerun a failure alone once; known failing here:
   composition-clipping, fonts, hero-pair, peer-sides, pill-holder, capture-opens-guards' 2 service-worker cases; flaky under load:
   render-site-motion, strips' carousel, min-font, capture-styled-ranges, marquee, site-opens-proof (rerun alone)); the pins with
   `F2B_PIN_BASE=1` and the story pins with `F2B_STORY_PINS=1` (`site-media-unchanged` AC4 and `panel-embed-unchanged` fail on base too:
   compare lists); Figma replays and `dist/` byte for byte base; Justin's scan and the B-Dry stand-in through `npm run site`, plain and
   `--elementor`, base vs head drawn in Chrome at 1440, 1024, 768 and 390.
2. Every AC's test by its plan name on head (pass) and on old code (fail; a characterization pin is `base_exempt` backed by a mutant); a
   picture per AC (the class list and palette.json; base | head at 1440 and 390; a terminal capture otherwise).
3. Your own checks: a fixture site of your own (not the repo's) with three same-looking headings declared three ways, two buttons that differ
   only in words, two cards one with a different radius, a colour used in 4 places and a see-through one, and a page carrying its own font
   — what shares a class and what doesn't, no two classes write one property (read every element's class stack), palette ids and names;
   change one shared class and one palette colour in a copy of the paste and see exactly the right elements change; two pages of one site
   pasted in turn: the same class name and id with the same settings (Bricks' class comparison `test/fixtures/bricks-paste.ts` asks nothing).
4. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-shared-styles/verifier/ac.json` and logs there; self-check with `ac-check.sh`
   on a copy (`--base 84722938b32c82e2dc5041bda6383ac12bf7793d`, no `--reviews`).

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/sssv/t1`); scripts under `~/.cache/sssv/s/`;
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
