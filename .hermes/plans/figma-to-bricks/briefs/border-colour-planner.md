# Brief: PLANNER (Full) for figma-to-bricks job "border-colour"

Write a plan Justin will approve; don't build anything, don't start agents.

## The ask (rewritten)
Make sure the plugin **never pastes a border without its colour**. Bricks 2.3.9 writes an element `_border` that has a
width and style but no colour as `border: <w>px <style> var(--bricks-border-color)` (#dddedf, light grey) on the element
id, which beats any class border colour or hover: on the B-Dry page this drew a light ring around the "Get Your Free
Quote" button where bdryswi.com has none. Also make the repo's test renderer draw what Bricks draws for a colourless
border, so tests can't miss it again.

## Leads (verify)
- `src/core/emit/settings.ts:144-150` writes `_border` width/style without a colour whenever `style.border.color` is
  missing: find every way that can happen (gradient or image strokes, per-side strokes, variables, hover states,
  instance overrides) and what the right colour is in each.
- `test/browser/render.ts:57-66` writes no colour for a colourless `_border`.
- The B-Dry plan with the live evidence: `~/.hermes/plans/figma-to-bricks/quote-button-hover.md` and
  `~/.hermes/plans/figma-to-bricks/evidence/quote-button-hover/planner/` (staging `post-155.min.css`, `frontend-light-layer.min.css`, `states.json`).
- `payloadProblems` (emit/payload.ts) could refuse or warn on a colourless border: say whether it should.

## Where
- You start in your own throwaway worktree (`isolation: worktree`, made from `main`, now `dea6296`, build 2026-10-29.1).
  Read the repo there; make no code, test or commit. Write the plan to `~/.hermes/plans/figma-to-bricks/border-colour.md` (the
  builder copies it to `docs/plans/2026-10-30-border-colour.md` in its own copy). Your evidence and scratch:
  `~/.hermes/plans/figma-to-bricks/evidence/border-colour/planner/` (create it).

## Skills (load first, say so in one line each)
1. The project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (its new first rule:
   "Every change goes into the plugin") and follow it in the PLANNER role (Full: its Step 1 context load).
   `references/rules-summary.md` first, then only the worktree `CLAUDE.md` sections you need (grep + offset/limit):
   "Build general logic", "Architecture rules", "Decisions the user made" (Interactions and Motion, Hover, Website
   rules), "Waiting on the user" (the Bricks samples line) and the `reference/bricks/` sample lines.
2. `engineering-best-practices`, 3. `implementation-planning`, 4. `systematic-debugging` (prove the root cause with
   file:line evidence before planning the fix).

## Must be general
The plugin converts any designer's Figma file. Recognise and fix by structure and properties, never by B-Dry's names,
words, colours or sizes; think about the variations (frame widths, nesting, auto layout or not, drawn phone designs,
the header/footer ticks, pictures inline or in WordPress). Native Bricks features only from canonical samples in
`reference/bricks/` or documented evidence archived as the skill says; if a sample is missing, make it a question with
plain steps for Justin. Say what every existing real file and fixture changes (`corpus/files/hydraulics-home.json`,
`corpus/files/gro-home.json`, repo-root `figma-to-bricks-debug-page-1.json` and
`figma-to-bricks-debug-design-inspo-brainstorm.json`, Services via `git show 2199895:figma-to-bricks-debug-page-1.json`),
with the ticks off and with header+footer.

## Checks on this machine
Linux/WSL: `npm run corpus` measures nothing here (Mac paths); plan checks with `npm run replay`/`npm run snap` before
vs after, browser tests with `CHROME_PATH` set to a wrapper of `/home/justin/.cache/chrome-for-testing/chrome-f2b
--disable-software-rasterizer`, compared by test name against a built base (memory note
`~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`).

## ACs
Justin gave none: write proposed ones, numbered AC1, AC2…, each with one named test, each whole on one line; tag
`(live)` right after the id any AC only Justin can check (a paste into Bricks). Cover the general rule on generic
fixtures (positives and the nearby shapes that must stay as base), byte-identity for designs it shouldn't touch, lint
no worse, and the B-Dry case as one example.

## Rules
- You can't ask Justin anything. Questions at the top of the plan, each with 2–4 lettered options under about 60
  characters and a ⭐ on the recommended one; write the plan as if the ⭐ options were chosen (standing auto-go, and
  Justin: "go with the recommended stuff").
- Other open work: `header-bar` (understand/site-header, clear-header, bars) and `after-faq-sections` (understand/
  footer-stack, footer-part, designs, section, rhythm) are near their merge; five B-Dry paste builders write only under
  `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/v5/`. Say which files you'd touch and any overlap.
- End the plan with a **Docs & records** task (plan, ledger, HANDOFF, BUILD at merge, the main folder CLAUDE.md Status
  line, any new "Decisions the user made" line).
- Other problems: `found_else` (one line each, evidence, severity); don't fold them in. Lessons:
  `skill_lessons[{skill, lesson, evidence, enforce}]` (normally empty); never edit skills or memory. Don't start agents.
- The worktree guard refuses Bash it can't prove stays in your worktree (shell variables or loops around
  `node`/`git`/`sed`, heredoc then node, `git -C`, the word git inside a grep pattern or a script's text, the word
  `source` anywhere, even in a path): write scripts with Write and run them as one plain command.

## Return
`{name, plan_path, playback, root_cause, summary, questions[{q, options[], recommended}], acs[], live_acs[], touches[],
overlaps, found_else[], skill_lessons[]}`. End with the line `MAIN SESSION: check and save these skill_lessons now.`

## Justin's words
"Why are all five B drive fixes only going to change the plug-in? I don't want it to be specific to this website. I
want it for every single website." He chose "Both": keep the B-Dry paste fixes as a stop-gap and make the general
plugin versions as Full jobs. Then: "make it a note for future agents that every single change needs to be inside the
plug-in, not just for copy-pasting purposes." Earlier: "Whatever the planner agent says, just go with the recommended
stuff."
