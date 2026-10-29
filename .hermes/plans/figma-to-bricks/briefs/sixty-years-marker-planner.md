# Brief: PLANNER (Mini) for figma-to-bricks job "sixty-years-marker"

You are the PLANNER for one small job. Write a plan Justin will approve; don't build anything, don't start agents.
**Mini mode:** load the project skill and only the code/docs sections this touches; skip the full Step 1 context load;
finish within about 15 steps. If this is bigger or riskier than a Mini job, say so in `summary` and recommend Full.
(`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/mini-pipeline.md`.)

## The ask (rewritten)
On bdryswi.com, the band "Over **60 Years** Of Trust" (white words on a navy band, "60 Years" in orange) has a red
hand-drawn circle around "60 Years" that **draws itself** as an animation. On our B-Dry Home paste (staging
`bdry.staging.growithgro.com`, page homev3) that animation is missing. Make ours match bdryswi.com's: the circle, its
look and the way it draws (timing, start, repeat or not, reduced motion).
Screenshot: `~/.hermes/plans/figma-to-bricks/evidence/sixty-years-marker/screens/sixty-years.png` (Justin's crop of the
band with the red circle; open it with Read). Justin's words are below: the first sentence mentions "the C has an
animation issue that the site doesn't have" and then corrects itself: the official site has the animation and ours
doesn't. Treat the correction as the ask; also check that our band has no stray animation bdryswi.com lacks.

## What exists
- **The plugin already has this feature:** "headline-marker" (a stroke drawn around styled words), merged into `main` as
  build `2026-10-29.1` (HANDOFF's headline-marker section, paste check 3br; its known open issues: drawn-phone and
  exact-design-width ring overflow). It was built for exactly this B-Dry band, but the B-Dry paste kept the band still.
  Read its HANDOFF section and plan (`docs/plans/*headline-marker*`) for how its output is made.
- The paste Justin pasted: `C:\Users\Admin\Downloads\bdry-home-with-header.json` (= the header paste
  `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/header-v1/header-paste.json` followed by the Home paste
  `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/v4/home-paste-v4.json`, classes merged). The Home paste's lineage:
  v1 hand-built from the source capture, v2/v3 adding the plugin's own output for features (slider, flip boxes, photo
  dots: see `v3/scripts/build-v3.ts` for how plugin output was spliced in), v4 the after-FAQ sections. Find the "60
  Years band" section in it.
- The real site: read-only capture `~/.hermes/plans/figma-to-bricks/evidence/bdry-source/` (`home.html` with Elementor's
  inline CSS, the animated-headline widget's settings in `tree-*.json`). You may read `https://bdryswi.com/` over HTTP
  (`?f2b=<random>`); never log in, never change anything. Measure the real animation (its SVG path, stroke, colour,
  width, timing, delay, loop, how it's triggered).
- Context: memory note `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/bdry-home-copy.md`.
- **Another job is open on the same paste:** `services-band-speed` (the "Our Services" band's moving gradient is too
  fast) is being planned now. Say how both changes land in one next paste version without clashing.

## Must settle
- **Root cause** with evidence: what our band has vs what bdryswi.com has.
- **How to bring it in:** the plugin's own headline-marker output spliced into the paste (preferred, as v3 did for
  other features), or a hand-built copy of bdryswi.com's SVG; say which matches bdryswi.com better and why. Plugin code
  changes only if the plugin's output can't match (then say so with file:line and recommend Full).
- **Every screen:** the circle must fit "60 Years" at desktop, tablet and phone widths (headline-marker's known ring
  overflow issues: check they don't hit this band) and respect reduced motion.
- The output Justin pastes: one file with the header and the whole Home page, as he now pastes it.

## ACs
Justin gave none: write proposed ones, numbered AC1, AC2…, each with one named test whole on one line; tag `(live)`
right after the id any AC only Justin can check (watching the band beside bdryswi.com after pasting). At least: the
circle draws around "60 Years" as on bdryswi.com (measured timing); it fits at 1440/1024/767/390 without covering other
words; reduced motion shows it drawn and still; nothing else in the paste changes (byte-compare the rest); the paste
stays valid (payload checks, no class clash).

## Where to write
Write the plan to `~/.hermes/plans/figma-to-bricks/sixty-years-marker.md`. Your scratch and probes:
`~/.hermes/plans/figma-to-bricks/evidence/sixty-years-marker/planner/`. You start in your own throwaway worktree (made
from `main`); read the repo there (it holds headline-marker), and change nothing in it.

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
"Another thing we need to work on is the sixty. It has an animation that doesn't match what we have on the official
website. The C has an animation issue that the site doesn't have, so we need to fix that. Sorry, the official website
has an animation for the sixty that we don't have here." (Earlier: "Whatever the planner agent says, just go with the
recommended stuff, all right.")
