# Brief: PLANNER (Mini) for figma-to-bricks job "quote-button-hover"

You are the PLANNER for one small job. Write a plan Justin will approve; don't build anything, don't start agents.
**Mini mode:** load the project skill and only the code/docs sections this touches; skip the full Step 1 context load;
finish within about 15 steps. If this is bigger or riskier than a Mini job, say so in `summary` and recommend Full.
(`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/mini-pipeline.md`.)

## The ask (rewritten)
The **"Get Your Free Quote"** button in the "Schedule A Consultation" band of our B-Dry Home paste: when Justin points
at it or clicks it ("when highlighted"), ours shows a light/white border around the orange pill; on bdryswi.com the
same button is just the orange pill with no visible border. Make ours match bdryswi.com in every state (rest, hover,
focus, active/clicked), keeping a keyboard-only focus ring if the project's website rules require one (CLAUDE.md
"Website rules": extras Figma never shows only where mouse and touch users can't see them, e.g. `:focus-visible`).
Screenshots (open each with Read), in `~/.hermes/plans/figma-to-bricks/evidence/quote-button-hover/screens/`:
`1-ours-hover.png` (ours: orange pill with a light border, dark blue words) and `2-bdryswi-hover.png` (bdryswi.com:
orange pill, no border, dark words).

## What exists
- This band came in with the job `after-faq-sections` (its paste `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/
  v4/` built by `v4/build-v4.ts`; its Q4 A: "the quote button turns orange under the pointer, as on bdryswi.com"; the
  button's resting colours live in the class `home-quote`; earlier checks measured the hover as rgb(255,179,86) with a
  rgb(0,71,116) border). That job is in final verification now: don't touch its branch or evidence; your fix goes in
  the next paste version.
- The paste Justin pasted: `C:\Users\Admin\Downloads\bdry-home-with-header.json` (= the header paste
  `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/header-v1/header-paste.json` followed by `v4/home-paste-v4.json`,
  classes merged). Find every rule that can draw that border: the class's own border, a hover/focus/active state, the
  plugin's focus ring class, Bricks' button defaults, the site's Theme Style.
- The real site: read-only capture `~/.hermes/plans/figma-to-bricks/evidence/bdry-source/` (`home.html` with Elementor's
  inline CSS). You may read `https://bdryswi.com/` and `https://bdry.staging.growithgro.com/` over HTTP
  (`?f2b=<random>`); never log in, never change anything. Measure both buttons in Chrome in every state (computed
  border, outline, box-shadow, background, colour, transition).
- Context: memory note `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/bdry-home-copy.md`.
- **Three other jobs change the same paste** and are being planned now: `services-band-speed`, `sixty-years-marker`,
  `fee-band-photo`. Say how all of them land in one next paste version without clashing.

## Must settle
- **Root cause** with evidence: which rule draws the border on ours (and in which state), and what bdryswi.com does.
- **The fix in the paste** (a new paste version, never editing v4 in place). If the border comes from the site
  (Theme Style) rather than the paste, say so and give Justin the Bricks steps instead. Plugin code changes only if the
  plugin produced the rule.
- The output Justin pastes: one file with the header and the whole Home page, as he now pastes it.

## ACs
Justin gave none: write proposed ones, numbered AC1, AC2…, each with one named test whole on one line; tag `(live)`
right after the id any AC only Justin can check. At least: in rest, hover and active states the button's border,
outline and shadow match bdryswi.com's computed values; keyboard focus still shows a visible ring only for keyboard
users (or matches bdryswi.com if the website rules allow); nothing else in the paste changes (byte-compare the rest);
the paste stays valid (payload checks, no class clash).

## Where to write
Write the plan to `~/.hermes/plans/figma-to-bricks/quote-button-hover.md`. Your scratch and probes:
`~/.hermes/plans/figma-to-bricks/evidence/quote-button-hover/planner/`. You start in your own throwaway worktree (made
from `main`); read the repo there, and change nothing in it.

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
"You can see the first photo is what we have on our official website, while the second photo is what we have on the
actual website we want to copy. On our site, the call‑to‑action button, when highlighted, has a white border around
it, which the official website doesn't have." (Image 1 = ours on staging; image 2 = bdryswi.com, the site we copy.
Earlier: "Whatever the planner agent says, just go with the recommended stuff, all right.")

## Live pages (Justin, 2026-10-29)
- The site we copy: https://bdryswi.com/
- Our page as Justin pasted it: https://bdry.staging.growithgro.com/homev2/?bricks_preview=1793276386
Read both over HTTP or in your own headless Chrome as needed (add `&f2b=<random>` / `?f2b=<random>` to get past any cache). Read only: never log in, never submit a form, never change anything on either site.
