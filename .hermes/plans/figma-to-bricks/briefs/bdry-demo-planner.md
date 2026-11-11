# Role: planner (Mini, time-boxed): bdry-demo — a hand-built, one-to-one Bricks paste of B-Dry's home page for a demo

You are a fresh planner for FigmaToBricksV2 (**Fable 5.2, high**). Plan only: change no source or test, commit nothing,
start no agents. **Never load bdryswi.com** in any way (its bot check; Justin's rule), B-Dry staging or any live site;
no logins; never write to any WordPress site. Nothing paid.

**Time box (Justin, 2026-11-11): the whole job — plan, build, check — must be done in 2 h to 2 h 30 max.** Your plan is
due in **20 minutes**. Write a short Mini plan (`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/mini-pipeline.md`),
take the recommended answer to every question yourself (mark it ⭐; Justin's standing auto-go runs the builder at
once), and size the build to fit about 75 minutes of one builder, leaving ~40 minutes for one review and one check.

## What Justin asked (his words, 2026-11-11)
"something that I'm worried about is like, what if the plugin or the importer, it doesn't work like properly? … can you
make it so that you can copy paste, or you build a planner that copy pastes like the B-Drive page for phone, for
desktop, for mobile landscape, for tablet, just so I can copy paste it onto bricks, and it will be a one-to-one, just so
something I can show my manager Nicholas, something that doesn't have to do with the importer now."
His answers (in questions): **"One paste, all sizes"** (one page, header + page + footer together, pasted once,
responsive on desktop, tablet ≤991, phone sideways ≤767, phone upright ≤478 — Bricks' default breakpoints);
**"Saved copy"** (build from the saved copy of bdryswi.com's home on this PC); **"Old site's pictures"** (pictures point
at bdryswi.com's own addresses so they show the moment he pastes); and the 2–2.5 h limit.

So: a **deliverable for a demo, not a plugin change** — it must not depend on the website importer's tools being right
(`npm run capture`/`site`/`site:import` don't produce it). It is pasted into **B-Dry staging, Bricks 2.4.2**
(`https://bdry.staging.growithgro.com`).

## Inputs (read; all saved files on this PC)
- The saved served home of 2026-10-29 with its two `_jb_static` CSS bundles:
  `~/.hermes/plans/figma-to-bricks/evidence/web-code-proof/planner/inputs/bdry-2026-10-29/` (served from files with
  scripts dropped and Google's Roboto added, it redraws the site: x and width equal to the 11-04 capture at 45 widths).
- `~/.hermes/plans/figma-to-bricks/evidence/bdry-source/` (`README.md`, `home.html`, `tree-{390,767,1024,1440}.json`,
  body screenshots at 390/767/1024/1440, section shots at 1440).
- **Earlier hand-built pastes of this page** (Justin's memory "B-Dry home copy": a v3 paste with slider, flip boxes and
  dots on 2026-10-29): `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/` (`home-paste-v1.json`, `-v2.json`,
  `header-v1/`, `v3/`, `v4/`, `v5/`, `check.ts`, `overnight-log.md` — read the log: what was built, what was off, why).
  Reuse the newest that is closest, if that is the fastest path to one-to-one.
- Saved captures (input files only): `~/.hermes/plans/figma-to-bricks/evidence/bdryswi-com-home-2026-11-04-*.f2b-capture.json`.
- Bricks element shapes come only from the repo's `reference/bricks/*.json` samples (never from memory); the repo's
  `CLAUDE.md` "Working in this repo" Bricks facts (pictures swapped for a placeholder only when the image has an `id`;
  every element capped at its parent's width; Section/Container/Block wrap from 767 down; no `_alignSelf: stretch`;
  layout keys by element; an empty global class is `settings: []`; ids rewritten on paste — never name another
  element's id in CSS or a script; `payloadProblems` refuses known bad shapes). Justin wants native structure
  (Section/Container/Block, Heading, Button…, not div div div: memory "importer native structure") and editable
  settings over custom CSS where it doesn't cost the one-to-one look.
- The test renderer draws a paste as Bricks prints it (`test/browser/render.ts`, Bricks 2.4.2's front-end CSS since
  staging-fit-renderer) — the way to check "one-to-one" against the saved page at the four widths.

## The plan must settle
1. **The fastest honest route to one-to-one in the time box**, with evidence from the inputs: start from the best
   earlier paste and fix what differs, or build fresh from the saved page. Name what stays out if it doesn't fit (a
   slider's motion, a reviews widget that needs another company's script, the FAQ's open/close, the menu pop-up):
   static but looking right beats missing; say each in one plain line for Justin.
2. **"One-to-one" made measurable:** the saved page served locally against the paste drawn by the renderer at 1440,
   1024, 768, 767, 600, 479, 390 (each section's height and top within a tolerance you set, e.g. 2–4 px, plus a
   side-by-side picture per width); the four Bricks tiers.
3. **The deliverable:** one JSON file (header, page and footer in one paste) at
   `~/.hermes/plans/figma-to-bricks/evidence/bdry-demo/bdry-home-demo.json`, `payloadProblems` clean, pictures at
   bdryswi.com's addresses, fonts as the site has them; plus side-by-side pictures per width for Justin to show; plus
   Justin's numbered paste steps (empty page on B-Dry staging, paste, Save, Regenerate code signatures if any code,
   purge cache, check the four sizes).
4. **Numbered ACs, AC1, AC2…, each with one named check** (a script or test the builder adds under the repo's
   `test/` or a script in the evidence folder; each check's name whole on one line; a line that isn't an AC's
   definition never starts with a list marker followed by `AC<n>`), all marked **proposed**; one `(live)` AC: Justin
   pastes it on staging and it looks like the site at the four sizes.
5. **Where it lives:** the builder works in its own worktree; nothing changes the plugin's code (a demo, not a plugin
   change), so `npm run check` and `dist/` stay as main's; anything it adds to the repo (a check script, the paste as
   a test fixture) is optional and must not touch `src/`.

## Write
`~/.hermes/plans/figma-to-bricks/bdry-demo.md` (the builder copies it to `docs/plans/2026-11-11-bdry-demo.md` if it
commits anything): playback in 3 plain lines, the route and why, the ACs, tasks sized in minutes, what stays out,
questions with ⭐ answers. Evidence under `/home/justin/.hermes/plans/figma-to-bricks/evidence/bdry-demo/planner/`.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/bdp/t1`);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close every Chrome you start (by the PIDs of its own
profile path; never `pkill -f`; other agents and Justin run Chrome too). One plain git command per call, `git -C
<absolute path>`. Use `tail -n 3`. Waits under 115 s.

## Report (as text)
The plan's path; the playback; the route; the ACs one line each (the live one named); what stays out; the time
estimate per step; then `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never edit skills or
memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
