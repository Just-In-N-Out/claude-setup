# Brief: PLANNER (Mini) for figma-to-bricks job "fee-band-photo"

You are the PLANNER for one small job. Write a plan Justin will approve; don't build anything, don't start agents.
**Mini mode:** load the project skill and only the code/docs sections this touches; skip the full Step 1 context load;
finish within about 15 steps. If this is bigger or riskier than a Mini job, say so in `summary` and recommend Full.
(`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/mini-pipeline.md`.)

## The ask (rewritten)
In the **Fee Construction band** of our B-Dry Home paste (navy band with a faint photo behind; eyebrow "Basement
Contractors in Southwest Indiana", orange heading "BDry Is Now Proudly Owned And Operated by Fee Construction!", a
paragraph, and on the right the "Stronger Together – Fee Construction & BDry have merged!" picture), **the picture is
too small** compared with bdryswi.com. Make the band match bdryswi.com at every width.
Screenshots (open each with Read), in `~/.hermes/plans/figma-to-bricks/evidence/fee-band-photo/screens/`:
- `1-ours.png` (our staging page, ~1166px wide shot): the text column starts about 33px from the left; the picture is
  about 272×247 at x 751; the band is about 410px tall.
- `2-bdryswi.png` (bdryswi.com, ~1253px wide shot): the text column starts about 102px in; the picture fills the right
  column, about 494×451 at x 708, as tall as the text block or taller; the band is about 560px tall.
(Shot widths differ, so measure both pages yourself at the same widths: 1920, 1440, 1366, 1024, 767, 390.)

## What exists
- The paste Justin pasted: `C:\Users\Admin\Downloads\bdry-home-with-header.json` (= the header paste
  `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/header-v1/header-paste.json` followed by the Home paste
  `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/v4/home-paste-v4.json`, classes merged). The Home paste's lineage:
  v1 hand-built from the source capture (`dchafl` "Fee Construction" section; the picture is media 103), v2/v3 adding
  plugin output, v4 the after-FAQ sections (`v4/build-v4.ts`). Find why the picture is small (its own width cap, the
  column split, the Container's width or gutters, an aspect-ratio box).
- The real site: read-only capture `~/.hermes/plans/figma-to-bricks/evidence/bdry-source/` (`home.html` with Elementor's
  inline CSS, `tree-*.json` boxes at 1440/1024/767/390, `body-*.png`, `s1440-*.png`). You may read
  `https://bdryswi.com/` over HTTP (`?f2b=<random>`); never log in, never change anything.
- Context: memory note `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/bdry-home-copy.md`.
- **Two other jobs change the same paste** and are being planned now: `services-band-speed` (the "Our Services" band's
  gradient too fast) and `sixty-years-marker` (the "60 Years" circle animation missing). Say how all three land in one
  next paste version without clashing (each touches different sections).

## Must settle
- **Root cause** with evidence: our band's layout and picture box vs bdryswi.com's, measured at the same widths.
- **The fix in the paste** (a new paste version built from v4 and the header, never editing v3/v4 in place): the
  picture's size and the band's columns, padding and height matching bdryswi.com at each width, phones included. Plugin
  code changes only if the plugin produced this band (it didn't, as far as known: v1 was hand-built); say so if it did.
- The output Justin pastes: one file with the header and the whole Home page, as he now pastes it.

## ACs
Justin gave none: write proposed ones, numbered AC1, AC2…, each with one named test whole on one line; tag `(live)`
right after the id any AC only Justin can check. At least: the picture's box and the text column's box match
bdryswi.com's within a small tolerance at 1440, 1366, 1024, 767 and 390; the picture keeps its shape (no stretch, no
crop beyond bdryswi.com's); nothing else in the paste changes (byte-compare the rest); the paste stays valid (payload
checks, no class clash).

## Where to write
Write the plan to `~/.hermes/plans/figma-to-bricks/fee-band-photo.md`. Your scratch and probes:
`~/.hermes/plans/figma-to-bricks/evidence/fee-band-photo/planner/`. You start in your own throwaway worktree (made from
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
"The first image is what we have on our website. The second image is what's on the official website. You can see the
photo, the image itself on our site is a bit small, so we need to fix that compared to the official website."
(Earlier: "Whatever the planner agent says, just go with the recommended stuff, all right.")

## Live pages (Justin, 2026-10-29)
- The site we copy: https://bdryswi.com/
- Our page as Justin pasted it: https://bdry.staging.growithgro.com/homev2/?bricks_preview=1793276386
Read both over HTTP or in your own headless Chrome as needed (add `&f2b=<random>` / `?f2b=<random>` to get past any cache). Read only: never log in, never submit a form, never change anything on either site.
