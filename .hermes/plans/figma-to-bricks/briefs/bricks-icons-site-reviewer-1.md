# Role: reviewer (round 1, FULL review of the whole story; report only): bricks-icons-site

You are a fresh reviewer who never saw the build (**Fable 5.2, high**). Review only: change nothing, commit nothing, start no agents. Plain
`git` in your own worktree, each command alone (never `git -C` the main folder; no git piped into another command: `git archive -o <file>`,
extract separately; scripts with the Write tool, no heredocs). Never load any live site (every Chrome that draws a site capture or paste
launches with `SITE_OFFLINE` from `tools/lib/site-chrome.ts`); never write to any WordPress site; never call alttext.ai; touch nothing under
`~/Downloads` (Justin's scan copy: `~/.hermes/plans/figma-to-bricks/evidence/media-clickable/run/`). **Importer rule:** one review per job,
P0–P2 only for bugs a real paste or normal use hits (a scenario and a measured number); edge cases P3.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/bricks-icons-site/plan-approved.md` (AC1–AC5; AC5 live).
  The job: with a media map, a scanned site's drawn svg becomes Bricks' Icon element showing its SVG from the media library (class on the
  svg, colour and size in the Icon's controls), the rest stay Code elements, named; `site:upload`/`site:import --svg` list and send each
  distinct drawing once after the typed yes, never to alttext.ai; a site refusing SVG leaves Code elements, named; pastes without a map (or a
  map holding no drawing) byte for byte as before.
- Branch `bricks-icons-site-build`, head `a06ed92d` (resolve the full SHA with `git rev-parse bricks-icons-site-build`), base
  `cf4f887de2a52ad8d7cb757486cc1916f3e3f4f4` (site-no-div; main is now `84722938`, cf4f887d plus a Build/notes commit): `git checkout
  --detach <head>`; review `git diff cf4f887d...HEAD`. Builder's evidence: `~/.hermes/plans/figma-to-bricks/evidence/bricks-icons-site/builder/`
  (a head start, not proof); HANDOFF's new top section lists rulings Q1, Q4–Q8 (⭐) and R1–R10.
- Builder's found_else to judge: its look test reached live hosts until a06ed92d (now SITE_OFFLINE; check every other new test/web file
  too); uploader.ts L253 `first` undefined only if flow.ts's order changes; R3 (the Background setting branch) has no test; header Icons
  compared only with the Offcanvas closed; `reference/bricks/README.md` says render_svg cuts the first id, but it cuts every id in the svg
  root tag.
- Read the standard at the top of the main folder's CLAUDE.md "Decisions the user made" ("would a Bricks pro find this logical and easy to
  change?"), and the standing rules on the Icon (`icon.svg.id` from the media library; an Icon's box rules never out-weigh its Width and
  Height controls) and the uploader (only adds media items; a typed yes; the password never printed).

## Check hardest
1. The Icon shape against `reference/bricks/icon-svg.json` and Bricks' GPL code (render_svg, the Icon element; memory
   `bricks-source-research`): a paste Bricks would refuse, rewrite or draw blank is P1.
2. Looks stay true: the fixture, the B-Dry stand-in and Justin's scan, both routes, at 1440 and 390 on Bricks 2.4.2 and 2.3.9, at rest,
   hovered and with the ☰ drawer open (header Icons inside the Offcanvas); typed Width/Height/Fill in Bricks beat the class.
3. The upload: each distinct drawing once, never twice on a re-run, only with `--svg`, only after the typed yes, never to alttext.ai, a
   refusing site named; the record keyed so earlier uploads aren't sent again (`test/fixtures/wp-standin.ts` only).
4. Without a map byte for byte the base; Figma replays and `dist/` byte for byte; every merged job's pins (incl. `F2B_STORY_PINS=1`) hold.

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/bricks-icons-site/review-1/review.json` (round 1, **scope full**, from `cf4f887d…`; full
SHA `head`), self-checked with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
cf4f887de2a52ad8d7cb757486cc1916f3e3f4f4 /home/justin/.hermes/plans/figma-to-bricks/evidence/bricks-icons-site`. Load `requesting-code-review`
and `code-review-practice`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (read it directly; not
linked) with `references/testing-pitfalls.md`; read both `repeat-mistakes.md` files first (`figma-to-bricks/references/`,
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/`).

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/bisr1/t1`); scripts under `~/.cache/bisr1/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start; one Chrome suite at a time (B-Dry files 8G)
under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`.
A git-archive base tree has no `dist/`: build it there before base browser runs. Use `tail -n 3`. Waits under 115 s in foreground poll
chunks (never end your turn to wait). After SIGTERM/143/137/"Killed" check both earlyoom's log and `journalctl --user | grep -E
'oom-kill|OOM killer'`.

## Report (as text; only review.json is written)
Findings one line each (id, P0–P3, file:line, scenario, measured) or "none"; each ruling and found_else: holds or not; Bricks-pro notes;
`verdict`; `ac_status`; `skill_lessons[{skill, lesson, evidence, enforce}]`, ending with: `MAIN SESSION: check and save these skill_lessons now.`
