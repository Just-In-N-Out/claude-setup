# Role: verifier 3 (read-only, after the rebase onto main with source conflicts): shared-palette

You are a fresh verifier who never saw the build or the review (**Opus 5.5, high**). Prove each acceptance criterion yourself. Change no
source or test, commit nothing, start no agents. Plain `git` in your own worktree, each command alone (never `git -C` the main folder; no git
piped into another command: `git archive -o <file> <sha>`, then extract separately). Never load any live site; never write to any WordPress
site; run any test that captures the B-Dry stand-in or draws Justin's scan only with no outside network (`unshare -rn sh -c 'ip link set lo up && ip link add d0 type dummy && ip addr add 10.255.0.2/24 dev d0 && ip link set d0 up && ip route add unreachable default && exec unshare --user --map-user=1000 --map-group=1000 <cmd>'`); touch nothing under `~/Downloads`. The folder `evidence/shared-palette/verifier-3/` doesn't exist yet: create it, and check it is
empty before writing.

**Skills:** read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and follow it (its by-name checker:
the head may print test names with an `ACn ` prefix the plan's cited names lack); the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/rendering-validation.md`. Read both `repeat-mistakes.md` files first (`figma-to-bricks/references/`,
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/`). Don't read builder's, planners' or reviewers' reports or folders as proof.
Keep to the standard at the top of the repo CLAUDE.md "Decisions the user made": also say where a Bricks pro would not find the paste logical.

## Inputs
- Approved plan (read-only, amendment 2: AC4, AC5, AC8, AC11 reworded, and a section "Rulings of the fix rounds [amended 2]"): `/home/justin/.hermes/plans/figma-to-bricks/evidence/shared-palette/plan-approved.md` (AC1–AC11; AC11
  live: `not_run`). The job: one colour palette for both tools — a colour has one id and one variable across pages and tools; the site's
  own palette exports (`--colours a.json,b.json`, the panel's "Colours already on the site") are reused, so the palette file each tool writes
  holds only colours the site lacks; bad files stop with one line; no site colours = byte for byte as before.
- The fix rounds' rulings you check against the plan (not yet confirmed by Justin, written in HANDOFF's shared-palette section): a `--colours`
  file is never removed or overwritten (new colours go to `palette-2.json`); the importer links a site colour of its own id whatever its value
  or variable; the plugin links one only at the same value, else keeps the design's value as `<name>-2` with one note per colour; a
  see-through site colour is read with its alpha and links only at the same value (alpha to 3 places); a skipped site colour (a raw with a
  fallback or no variable, an unreadable light, no id) is counted and its id and variable stay reserved (`SiteColours.unread`).
- The first verifier's F1 (`evidence/shared-palette/verifier/finding-F1-seethrough.log`: Justin's real Figma file re-listed its 73
  see-through colours when its own palette was given back) is the one earlier report you may read, only to rerun F1 yourself on head.
- Head **`00aff255cdd2d0b6b6210ecf4e72ec6e925f44fb`** (branch `shared-palette-final`), base **main `fe29b65d94da2c6f4e1ecb881354b9e9b9842cef`**
  (Build 2026-11-14.4: site-shared-styles' shared classes and `palette.json`, bricks-icons-site, importer-app, the Figma-route Icons). The job
  was accepted on an older base and rebased with source conflicts (convert.ts, site/convert.ts, plugin/{convert,main}.ts, messages.ts,
  ui/main.ts, replay.ts, site-import/next.ts); review 6 of that resolution is clean. `git checkout --detach 00aff255…`. Old code: a
  `git archive` of fe29b65d with head's test files and fixtures copied in (where a new module doesn't import, prove with a one-line mutant of
  head). AC logs start `HEAD=<sha>` ("archive" on line 2), end `EXIT=`.

## Work
1. Gates on head against base by name: both typechecks, `npm run check` (8G scope), the full `test:web` and `test:browser` file by file, one
   at a time, each under a 4G scope (B-Dry files 8G; compare every failure with base by name; rerun a failure alone once; known failing here:
   composition-clipping, fonts, hero-pair, peer-sides, pill-holder, site-live 3 of 6, icon-elements renderer@600/390, site-motion-bdry's Elementor hover-look test, site-media-unchanged's 308 misses, media-avif-as-served's 31 lines; site-upload-icons needs the network (AVIF encoder); flaky under load: capture-opens-guards' service-worker cases,
   render-site-motion, strips' carousel, `site-upload-stop` R1-1); the story pins with `F2B_STORY_PINS=1` and the base pins with `F2B_PIN_BASE=1`; Figma replays of `corpus/files/*` and
   `figma-to-bricks-debug-page-1.json` base vs head byte for byte without site colours; B-Dry's real capture copy
   (`~/.hermes/plans/figma-to-bricks/evidence/media-clickable/run/`) through `npm run site`, plain and `--elementor`, base vs head identical
   without `--colours`.
2. Every AC's test by its plan name on head (pass) and on old code (fail), named-only ones with the plan's variables; a picture per AC
   (the panel's chooser and reused line in Chrome; a terminal capture for a command AC).
3. Your own checks: a palette export of your own (two palettes, an hsl colour, a see-through one, a colour under a hand-made name, a raw with a fallback) given to
   `npm run site`, `site:upload --dry-run` against `test/fixtures/wp-standin.ts`, `replay` and the panel: links, the written file, the notes;
   run the same command three times with the `--colours` file in the out folder; change a value in the export keeping id and name (importer
   links; plugin exact with its note).
4. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/shared-palette/verifier-3/ac.json` and logs there; self-check with `ac-check.sh` on a
   copy (`--base fe29b65d94da2c6f4e1ecb881354b9e9b9842cef`, no `--reviews`).

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/spv2/t1`); scripts under `~/.cache/spv2/s/`;
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
