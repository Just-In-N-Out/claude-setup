# Brief: PLANNER (Mini) for figma-to-bricks job "hero-logo-size"

You are the PLANNER for one small job. Write a plan Justin will approve; don't build anything, don't start agents.
**Mini mode:** load the project skill and only the code/docs sections this touches; skip the full Step 1 context load;
finish within about 15 steps. If this is bigger or riskier than a Mini job, say so in `summary` and recommend Full.
(`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/mini-pipeline.md`.)

## The ask (rewritten)
In the **hero slider** of our B-Dry Home paste (a basement photo with a fireplace; a big blue "BDry" logo at the top
left; a translucent navy band with the eyebrow "Basement Contractors in Southwest Indiana" and the heading "The
Tri-State's Waterproofing Experts"; under it the buttons "Schedule An Inspection" and "View Our Services"), **the
"BDry" logo is much smaller than on bdryswi.com**. Make it match bdryswi.com's size and place on every slide and at
every width; the navy band and buttons follow wherever the logo's size moves them on bdryswi.com.
Screenshots (open each with Read), in `~/.hermes/plans/figma-to-bricks/evidence/hero-logo-size/screens/`:
- `1-ours.png` (~1070px wide shot): the logo about 190×70 at the top left, the navy band from y≈157.
- `2-bdryswi.png` (~1108px wide shot): the logo about 360×140, the navy band from y≈218.
(Shot widths differ, so measure both pages yourself at the same widths: 1920, 1440, 1366, 1024, 767, 390.)

## What exists
- The hero is the plugin's slider output spliced into the paste in v3 (job `slider-autoplay`, build 28.3; three slides,
  `v3/scripts/build-v3.ts`), on top of v1's hand-built content. Check every slide: does each carry the logo, and how is
  its size set (a width cap, the column, a figure box, the picture's own size)?
- The paste Justin pasted: `C:\Users\Admin\Downloads\bdry-home-with-header.json` (= the header paste
  `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/header-v1/header-paste.json` followed by
  `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/v4/home-paste-v4.json`, classes merged).
- The real site: read-only capture `~/.hermes/plans/figma-to-bricks/evidence/bdry-source/` (`home.html` with Elementor's
  inline CSS, `tree-*.json` boxes at 1440/1024/767/390, `body-*.png`, `s1440-*.png`). You may read
  `https://bdryswi.com/` and `https://bdry.staging.growithgro.com/` over HTTP (`?f2b=<random>`); never log in, never
  change anything.
- Context: memory note `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/bdry-home-copy.md`.
- **Four other jobs change the same paste** and are being planned now: `services-band-speed`, `sixty-years-marker`,
  `fee-band-photo`, `quote-button-hover`. Say how all of them land in one next paste version without clashing.

## Must settle
- **Root cause** with evidence: our logo's box and what sets it vs bdryswi.com's, measured at the same widths and on
  each slide.
- **The fix in the paste** (a new paste version, never editing v3/v4 in place): the logo's size and place, and the band
  and buttons below it, matching bdryswi.com at each width, phones included; the slider's own behaviour (autoplay,
  arrows, height) unchanged unless bdryswi.com's height differs because of the logo. Plugin code changes only if the
  plugin produced the logo's size (say so with file:line and recommend Full).
- The output Justin pastes: one file with the header and the whole Home page, as he now pastes it.

## ACs
Justin gave none: write proposed ones, numbered AC1, AC2…, each with one named test whole on one line; tag `(live)`
right after the id any AC only Justin can check. At least: the logo's box matches bdryswi.com's within a small tolerance
on every slide at 1440, 1366, 1024, 767 and 390; the band and buttons sit where bdryswi.com's do; the logo keeps its
shape; nothing else in the paste changes (byte-compare the rest); the paste stays valid (payload checks, no class
clash).

## Where to write
Write the plan to `~/.hermes/plans/figma-to-bricks/hero-logo-size.md`. Your scratch and probes:
`~/.hermes/plans/figma-to-bricks/evidence/hero-logo-size/planner/`. You start in your own throwaway worktree (made from
`main`); read the repo there, and change nothing in it.

## Rules
- You can't ask Justin anything. Questions go at the top of the plan with 2–4 lettered options and a ⭐ on the
  recommended one; write the plan as if the ⭐ options were chosen (Justin: "whatever the planner says, go with the
  recommended").
- End the plan with a **Docs & records** task (paste version, its manifest, the B-Dry memory note's paste status).
- Other problems: `found_else` (one line each, evidence, severity); don't fold them in.
- Lessons: `skill_lessons[{skill, lesson, evidence, enforce}]` (`enforce` is `none` or a one-line check proposal);
  normally empty. Never edit skills or memory.
- The worktree guard refuses Bash it can't prove stays in your worktree (shell variables or loops around
  `node`/`git`/`sed`, heredoc then node, `git -C`, the word git inside a grep pattern or a script's text, the word
  `source` anywhere, even in a path): write scripts with Write and run them as one plain command.

## Return
`{name, plan_path, playback, root_cause, summary, questions[{q, options[], recommended}], acs[], live_acs[], touches[],
mini_ok, found_else[], skill_lessons[]}`. End with the line `MAIN SESSION: check and save these skill_lessons now.`

## Justin's words
"I don't know if you want to also give it to the agent working on the stuff or the whatchall it. For the images, you
can see the B dry logo on the official website is much bigger compared to what we have on our website, so we need to
fix that." (Image 1 = ours, image 2 = bdryswi.com. Earlier: "Whatever the planner agent says, just go with the
recommended stuff, all right.")

## Live pages (Justin, 2026-10-29)
- The site we copy: https://bdryswi.com/
- Our page as Justin pasted it: https://bdry.staging.growithgro.com/homev2/?bricks_preview=1793276386
Read both over HTTP or in your own headless Chrome as needed (add `&f2b=<random>` / `?f2b=<random>` to get past any cache). Read only: never log in, never submit a form, never change anything on either site.
