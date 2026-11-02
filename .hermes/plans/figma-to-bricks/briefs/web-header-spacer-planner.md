# Role: Mini-pipeline planner — web-header-spacer (website importer, demo-1 finding 1)

You are a fresh Mini-pipeline planner for FigmaToBricksV2. You plan only: no product code, no tests committed beyond
the plan file, no BUILD bump, no merge, no push, never start other agents. Other agents work in other copies of this
repo (wave 1's rebase finisher; web-tiers, web-panel and web-embeds builders; DJ Trees jobs from another session):
never touch the main folder `/home/justin/Documents/FigmaToBricksV2` (read it only), never use bare `git stash`, never
revert anything you didn't write, leave every other worktree alone.

## Your copy

You start in your own worktree at `main` (`1aef12f`). The code this job fixes is wave 1 of the website importer, which
is combined and about to merge: `git checkout --detach 7a0ac6a` (branch `wave1-final`'s head), then
`git switch -c web-header-spacer`. Write the plan as `docs/plans/2026-11-02-web-header-spacer.md`, commit it (plain
`git commit -m`, no author override, no AI lines; `git diff --cached --name-only` must not list CLAUDE.md), and copy it
to `E/planner/plan.md`. Report your branch and commit SHA.

## The request

Justin (2026-10-31): "I want this to actually get working and can see it." The first end-to-end run of the importer
(demo-1, 2026-11-02) captured three pages of his Hostinger site and turned each into a Bricks paste. On every page:

- The live site has a fixed header with an 88px spacer box under it (the site was itself pasted by this plugin, which
  writes a header spacer; other builders do the same with an empty box or `padding-top`). The capture copies that
  spacer as page content: the home paste's second top-level section (element `ywytlx`) is an empty 88px white section.
- With the panel's header tick on (header left out, the site's own header shows), the plugin also adds its own room
  for the site's header, so the room is given twice: a white strip under the header in the copy.

It must be a general rule for any captured site, never a fix for this one (repo CLAUDE.md "Build general logic").

## Inputs (pinned)

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-header-spacer` (yours: `E/planner/`).
- Demo-1: `/home/justin/.hermes/plans/figma-to-bricks/evidence/website-importer-demo-1/` — `hostinger/{home,contact,gallery}/`
  with `capture/` (the capture files), `replay/` (`bricks.json`, `bricks.html`, `warnings.txt`), `compare/` (side-by-side
  PNGs, `report.json`, `digest.txt`), `home/paste-home.json` (ticks on), `scripts/` (`page.sh`, `make-paste.mts`,
  `demo-compare.mts`). Reuse these; don't re-capture unless you need a fact they lack.
- Code: `docs/specs/web-capture.md`, HANDOFF's web-capture section, `src/web/` (parts, floating, layout readers), the
  plugin's header handling (`designs.ts` `keepBeside`, the site-header-room script/marker, header tick in the panel),
  memory `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/reading-the-live-site.md`.

## Skills

`engineering-best-practices` first, then `implementation-planning`, `systematic-debugging` and the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/live-site-reading.md`.
Read the repo `CLAUDE.md`. Mini mode: read only the code and docs this touches.

## What to do

1. Reproduce from the demo captures (replay with the ticks on and off) and find the root cause with file:line
   evidence: where the spacer enters the capture as page content, and where the plugin adds its own room.
2. Write the general rule: what marks a box as room reserved for a fixed or sticky header (empty, at the page's top,
   height matching the header, no words or pictures; an equivalent `padding-top`/`margin-top` on body or the first
   wrapper), on WordPress/Bricks, Elementor, Divi and plain sites; which part it belongs to; what happens with the
   header tick on and off; and what must not change (a real first section, a painted band, a hero that sits under a
   transparent header, Figma designs).
3. Numbered ACs (AC1…, **proposed**), one named test each, on generic fixtures in `test/fixtures/web/` (both
   directions: a spacer removed once, a real empty-looking first section kept), plus the demo pages as a real-site
   check (`npm run compare` at 1440 and 390: no white strip, nothing else moved). A `(live)` AC for Justin's paste.
4. Questions with ⭐ answers where there is a choice. Mini scope check: if the fix needs more than ~3 source files or a
   design decision, say so and recommend Full.

## Rules

- bdryswi.com serves a bot-check page to automated Chrome: don't load it. Live reads only of
  `https://darksalmon-badger-335429.hostingersite.com/` (add `?f2b=<random>`) and `https://www.letsgro.ai/`, GET only.
  Never write to any WordPress site.
- This machine (WSL): `CHROME_PATH` = `~/.hermes/plans/figma-to-bricks/evidence/web-capture/planner/scripts/chrome-cpu.sh`,
  Node `/home/justin/.local/node-v22.23.3/bin` first on PATH, `TMPDIR` short (`~/.cache/whs-plan/tmp`). One Chrome job
  at a time; kill only your own Chromes, by PID. Write multi-step scripts with the Write tool and run `bash <file>`.
- Put any summary in your report, not in a separate summary file.

## Report

Branch, commit SHA, plan path; root cause in 2–3 lines with file:line; the ACs one line each; questions with ⭐
answers; Mini or Full; then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; `enforce` `none` or a
one-line check proposal; empty is normal; never edit skills or memory), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
