# Brief: PLANNER (Mini) for figma-to-bricks job "services-band-speed"

You are the PLANNER for one small job. Write a plan Justin will approve; don't build anything, don't start agents.
**Mini mode:** load the project skill and only the code/docs sections this touches; skip the full Step 1 context load;
finish within about 15 steps. If this is bigger or riskier than a Mini job, say so in `summary` and recommend Full.
(`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/mini-pipeline.md`.)

## The ask (rewritten)
On the B-Dry Home page Justin pasted (staging `bdry.staging.growithgro.com`, page homev3; our paste), the **"Our
Services" heading band** (a full-width bar with a dark-navy-to-bright-blue gradient and the white words "Our
Services") has a moving gradient/shimmer that runs **too fast**. On the real site, bdryswi.com, the same band moves more
slowly. Make ours match bdryswi.com's speed (and its other animation settings, if they differ too).
Screenshot: `~/.hermes/plans/figma-to-bricks/evidence/services-band-speed/screens/our-services-band.png` (ours; open it
with Read).

## What exists
- The paste Justin pasted: `C:\Users\Admin\Downloads\bdry-home-with-header.json` (= the header paste
  `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/header-v1/header-paste.json` followed by the Home paste
  `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/v4/home-paste-v4.json`, classes merged). The Home paste's lineage:
  v1 hand-built from the source capture, v2/v3 adding plugin output, v4 the after-FAQ sections (`v4/build-v4.ts`, append
  only). The header paste has its own shimmer (`.bg:after`, 8s); find which element and class animate the "Our
  Services" band and where its timing comes from.
- The real site: read-only capture `~/.hermes/plans/figma-to-bricks/evidence/bdry-source/` (`home.html` with Elementor's
  inline CSS; `tree-*.json`). You may read `https://bdryswi.com/` over HTTP (`?f2b=<random>`); never log in, never change
  anything. Measure the real animation: its keyframes, duration, timing function, delay, iteration and direction.
- Context: memory note `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/bdry-home-copy.md` (class
  prefix `home-`, the site's own class names to avoid).

## Must settle
- **Root cause** with evidence: our paste's animation settings vs bdryswi.com's, side by side.
- **Where the fix goes:** in the paste only (a new paste version built from v4 and the header, never editing v3/v4 in
  place), or also in the plugin (only if the plugin produced this band's animation; say so with file:line). If the
  same animation runs elsewhere on our page (the header's shimmer, other bands), say whether they share the timing and
  whether bdryswi.com's differ.
- **Reduced motion** must stay respected.
- The output Justin pastes: one file with the header and the whole Home page, as he now pastes it.

## ACs
Justin gave none: write proposed ones, numbered AC1, AC2…, each with one named test whole on one line; tag `(live)`
right after the id any AC only Justin can check (e.g. watching the band beside bdryswi.com after pasting). At least: the
band's animation timing equals bdryswi.com's measured values; nothing else in the paste changes (byte-compare the rest);
reduced motion still stops it; the paste stays valid (payload checks, no class clash).

## Where to write
Write the plan to `~/.hermes/plans/figma-to-bricks/services-band-speed.md` (and, if a plugin change is needed, say the
builder will copy it to `docs/plans/2026-10-29-services-band-speed.md` in its own copy). Your scratch and probes:
`~/.hermes/plans/figma-to-bricks/evidence/services-band-speed/planner/`. You start in your own throwaway worktree (made
from `main`); read the repo there, and change nothing in it.

## Rules
- You can't ask Justin anything. Questions go at the top of the plan with 2–4 lettered options and a ⭐ on the
  recommended one; write the plan as if the ⭐ options were chosen (Justin: "whatever the planner says, go with the
  recommended").
- End the plan with a **Docs & records** task (paste version, its manifest, HANDOFF if the plugin changes, the B-Dry
  memory note's paste status).
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
"Okay, there are a couple of issues I need you to give to an orchestrator agent… pass them to planner agents… Whatever
the planner agent says, just go with the recommended stuff, all right. The first one here is that the animation on the
service one is too fast. We need to slow it down a bit. It doesn't match what we have on the official site."

## Live pages (Justin, 2026-10-29)
- The site we copy: https://bdryswi.com/
- Our page as Justin pasted it: https://bdry.staging.growithgro.com/homev2/?bricks_preview=1793276386
Read both over HTTP or in your own headless Chrome as needed (add `&f2b=<random>` / `?f2b=<random>` to get past any cache). Read only: never log in, never submit a form, never change anything on either site.
