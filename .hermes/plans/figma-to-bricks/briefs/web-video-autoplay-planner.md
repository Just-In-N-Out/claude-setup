# Role: Mini-pipeline planner — web-video-autoplay (website importer, demo-1 finding 2)

You are a fresh Mini-pipeline planner for FigmaToBricksV2. You plan only: no product code, no tests committed beyond
the plan file, no BUILD bump, no merge, no push, never start other agents. Other agents work in other copies of this
repo (wave 1's rebase finisher; web-tiers, web-panel and web-embeds builders; DJ Trees jobs from another session):
never touch the main folder `/home/justin/Documents/FigmaToBricksV2` (read it only), never use bare `git stash`, never
revert anything you didn't write, leave every other worktree alone.

## Your copy

You start in your own worktree at `main` (`1aef12f`). The code this job fixes is wave 1 of the website importer, which
is combined and about to merge: `git checkout --detach 7a0ac6a` (branch `wave1-final`'s head), then
`git switch -c web-video-autoplay`. Write the plan as `docs/plans/2026-11-02-web-video-autoplay.md`, commit it (plain
`git commit -m`, no author override, no AI lines; `git diff --cached --name-only` must not list CLAUDE.md), and copy it
to `E/planner/plan.md`. Report your branch and commit SHA.

## The request

Justin (2026-10-31): "I want this to actually get working and can see it." The first end-to-end run of the importer
(demo-1, 2026-11-02) captured his Hostinger home: its hero has a background video that plays by itself, muted, on a
loop. In the copy it shows a player bar and doesn't play: `src/core/understand/video.ts:7-17` decides `plays: false`
for the captured video, so `src/core/emit/video.ts:15` writes `fileControls: true` with no autoplay, mute or loop.

The standing rule (repo CLAUDE.md "Videos"): a video "muted and looping where it is a background behind words". It must
be a general rule for any captured site (the site's own `autoplay`/`muted`/`loop`/`playsinline`/`controls`, a
background video behind words, a video a visitor starts), never a fix for this one.

## Inputs (pinned)

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-video-autoplay` (yours: `E/planner/`).
- Demo-1: `/home/justin/.hermes/plans/figma-to-bricks/evidence/website-importer-demo-1/` — `hostinger/{home,contact,gallery}/`
  with `capture/` (the capture files), `replay/` (`bricks.json`, `bricks.html`, `warnings.txt`), `compare/` (side-by-side
  PNGs, `report.json`, `digest.txt`), `home/paste-home.json` (ticks on), `scripts/` (`page.sh`, `make-paste.mts`,
  `demo-compare.mts`). Reuse these; don't re-capture unless you need a fact they lack.
- Code: `docs/specs/web-capture.md` (what the capture records for `<video>`), HANDOFF's web-capture section, `src/web/`
  (the media reader), `src/core/understand/video.ts`, `src/core/emit/video.ts`, `reference/bricks/` video samples
  (`hero-video-buttons.json` and any `video` element sample), and how Figma designs reach `plays` today.

## Skills

`engineering-best-practices` first, then `implementation-planning`, `systematic-debugging` and the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/live-site-reading.md`.
Read the repo `CLAUDE.md`. Mini mode: read only the code and docs this touches.

## What to do

1. Reproduce from the demo home's capture and replay, and find the root cause with file:line evidence: what the
   capture records about the hero video and where `plays` is decided.
2. Write the general rule: what the capture must record about a video (its attributes and whether it was playing
   when read), how understand decides background-and-playing vs a player, what Bricks' Video element needs for each
   (from the samples, never from memory), the still frame shown before it plays, and what must not change (Figma
   designs' videos, a video with its own controls on the site, reduced motion).
3. Numbered ACs (AC1…, **proposed**), one named test each, on generic fixtures in `test/fixtures/web/` (a muted looping
   background video, a click-to-play video with controls, a video without autoplay), plus the demo home as a real-site
   check (replay: the hero's Video element plays muted on a loop with no controls; Figma replays byte-identical). A
   `(live)` AC for Justin's paste.
4. Questions with ⭐ answers where there is a choice. Mini scope check: if the fix needs more than ~3 source files or a
   design decision, say so and recommend Full.

## Rules

- bdryswi.com serves a bot-check page to automated Chrome: don't load it. Live reads only of
  `https://darksalmon-badger-335429.hostingersite.com/` (add `?f2b=<random>`) and `https://www.letsgro.ai/`, GET only.
  Never write to any WordPress site.
- This machine (WSL): `CHROME_PATH` = `~/.hermes/plans/figma-to-bricks/evidence/web-capture/planner/scripts/chrome-cpu.sh`,
  Node `/home/justin/.local/node-v22.23.3/bin` first on PATH, `TMPDIR` short (`~/.cache/wva-plan/tmp`). One Chrome job
  at a time; kill only your own Chromes, by PID. Write multi-step scripts with the Write tool and run `bash <file>`.
- Put any summary in your report, not in a separate summary file.

## Report

Branch, commit SHA, plan path; root cause in 2–3 lines with file:line; the ACs one line each; questions with ⭐
answers; Mini or Full; then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; `enforce` `none` or a
one-line check proposal; empty is normal; never edit skills or memory), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
