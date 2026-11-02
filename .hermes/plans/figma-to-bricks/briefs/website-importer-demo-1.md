# Demo brief: website importer, first look (what Justin can see in the morning)

**Role:** demo runner (fresh Opus 5.5, xhigh). Justin (2026-10-31, going to sleep): "I do not want continuous building, I
want this to actually get working and can see it … just keep going." Your job is not to build features: it is to run
what wave 1 built, end to end, on real sites, and leave him something he can look at and paste. Never stop to ask;
decide and record.

**Skills:** load `engineering-best-practices` with the Skill tool; read the project skill with Read:
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its `references/live-site-reading.md` and
`references/testing-pitfalls.md`.

## The code

Wave 1 (J1 capture + J0 compare) is combined and rebased onto local main as branch `wave1-final` at
`7a0ac6a` (its last gate run is in progress elsewhere; leave that worktree alone). In your agent worktree:
`git checkout --detach 7a0ac6a` and confirm `git rev-parse HEAD`. Read `docs/specs/web-capture.md`, HANDOFF's
web-capture and web-compare sections, `tools/capture.ts`, `tools/capture-check.ts`, `tools/replay.ts` and
`tools/site-compare.ts` to learn the commands (`npm run capture`, `capture:check`, `replay`, `compare`).

## What to produce

For each of the two sites you may read, **the home page plus up to two more pages** from `npm run capture -- <site>
--list` (pick pages with different layouts: one with a form or a grid if there is one):
- `https://darksalmon-badger-335429.hostingersite.com/` (Justin's own Bricks site; add `?f2b=<random>` to every address)
- `https://www.letsgro.ai/`

1. **Capture** each page (`npm run capture`), keeping the tool's own progress lines.
2. **Turn each capture into the Bricks paste** the way the plugin's back half does (`npm run replay` on the capture, or
   whatever the spec names): keep `bricks.json` and the warnings.
3. **See it side by side:** the capture's check page and/or `npm run compare` (paste vs live) at 390, 768, 1024, 1440
   and the page's own design width. Save, per page and width, the live shot, the copy's shot and one side-by-side image
   (live left, copy right, both labelled), PNG, at most ~1600px wide each, so they can go on a web page.
4. **A plain-words verdict per page:** what already looks the same, what doesn't (from the compare report's numbers
   and your own look at the shots), and for each difference which later job is meant to fix it (the job list is in
   `~/.hermes/plans/figma-to-bricks/website-importer-brainstorm.md` §9: J2 per-tier layout, J3 ranges and stretchy
   sizes, J4 panel, J5 embeds/maps/floating extras, J6 hover, J7 motion, J8 sliders/accordions, J9 forms, J10 flip/
   hotspots/pop-ups), or "not covered by any job" when none is. Be honest: this is wave 1 only.
5. **The paste file for Justin:** the home page's `bricks.json` of his own Hostinger site, ready to paste into an empty
   Bricks test page, plus 4–6 numbered plain steps for doing it and seeing it (the project CLAUDE.md "Phone checks for
   the user" style; photos: say whether they show or are stand-ins).

Don't change source code. If a command fails or a page can't be captured, record the exact error and try the next
page; a bug you find goes in your report as a finding (file:line, the command, what happened), not a fix.

**Reuse (demo-1, 2026-11-02):** `evidence/website-importer-demo-1/scripts/` (`page.sh` capture → check → replay → compare; `demo-compare.mts` labelled shots with the site's own pictures; `make-paste.mts` fills `fill:<hash>` from the capture's `web.pictures[hash].url`, `node:` renders and `svg:` markup, so the paste shows real photos with nothing uploaded). Put the summary in your report, not in a `summary.md` (Claude Code refuses subagent report files).

## Rules

- **bdryswi.com serves a bot-check page to automated Chrome: don't load it**, and never try to hide automation. Live
  reads only of the two sites above, GET only. Never write to any WordPress site; never paste anything into Bricks.
- **This machine (WSL):** `CHROME_PATH` = `~/.hermes/plans/figma-to-bricks/evidence/web-capture/planner/scripts/chrome-cpu.sh`,
  Node `/home/justin/.local/node-v22.23.3/bin` first on PATH, `TMPDIR` short (`~/.cache/demo1/tmp`). Long runs as a
  script with `exec > <log> 2>&1` and `trap 'echo EXIT=$?' EXIT`; wait inside tool calls, never by ending your turn.
  Write multi-step scripts with the Write tool and run `bash <file>`. Four other agents run browser tests on this
  machine: run one Chrome job at a time and kill only your own Chromes, by PID.
- No commits needed; if you commit anything, plain `git commit -m`, no AI lines, no CLAUDE.md.
- Everything in `~/.hermes/plans/figma-to-bricks/evidence/website-importer-demo-1/` (`<site>/<page>/` for shots,
  `bricks.json`, reports; `summary.md` for the verdicts and the paste steps; `scripts/`, `logs/`).

## Report

Per page: captured or not, element count, the widths compared, the verdict in 2–4 lines, the paths of its side-by-side
images; the paste file's path and the steps; any findings (bugs) one line each; then
`skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; `enforce` `none` or a one-line check proposal; empty
is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
