# Brief: BUILDER (Mini) for figma-to-bricks paste job "services-band-speed"

Build the approved plan. Don't re-plan. Justin is asleep under an away grant
(`~/.hermes/plans/figma-to-bricks/away-2026-10-29.md`: "keep the agents running and going and go with recommended
stuff… if an agent is lost then it will have to do research to figure it out"): take the plan's ⭐ answers, research
when lost, and record your calls as "My ruling, not yet confirmed". **Mini pipeline:** if the fix needs a plugin code
change, more than about 3 paste areas, or a design decision the plan didn't settle, stop with `status: stopped`,
`stop_reason: escalate to full`.

## The plan
Approved, read-only copy: `~/.hermes/plans/figma-to-bricks/evidence/services-band-speed/plan-approved.md` (working copy
`~/.hermes/plans/figma-to-bricks/services-band-speed.md`). Its questions take the ⭐ answers. One evidence: the planner's probes in
`~/.hermes/plans/figma-to-bricks/evidence/services-band-speed/planner/`.

## The rule for all five B-Dry paste jobs (overrides the plan where they differ)
Five jobs change the same B-Dry Home paste in parallel (`services-band-speed`, `sixty-years-marker`, `fee-band-photo`,
`quote-button-hover`, `hero-logo-size`). So:
- **You write only your own edit module:** `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/v5/edits/services-band-speed.ts`, a pure
  function taking the v4 Home paste JSON (`~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/v4/home-paste-v4.json`,
  read only) and returning the edited JSON, touching only your own elements and the classes you add or swap. Export
  the list of element ids and class ids/names it touches, so the integrator can refuse overlaps.
- **Your tests, oracle, scripts, shots and a job-only preview** go under
  `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/v5/services-band-speed/` (the preview = header-v1 + your edit applied to v4,
  combined the way Justin's current file was made: `C:\Users\Admin\Downloads\bdry-home-with-header.json` is
  `header-v1/header-paste.json`'s content followed by v4's, header classes first then v4's new ids). Write your tests
  so they can also run against a combined file passed as an argument (the integrator will run them on the final v5).
- **Don't write** `v5/scripts/build-v5.ts`, `home-paste-v5.json`, `bdry-home-with-header-v5.json`, `manifest.json` or
  anything in Downloads: one integrator agent does that after all five builders. Never edit v3/, v4/ or header-v1/.

## Skills (load first, say so in one line each)
1. Project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (paste pitfalls: "Hand-built
   paste CSS") and `references/rules-summary.md`; `references/testing-pitfalls.md` before any receipt or browser
   measurement. Memory notes `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/bdry-home-copy.md` and
   `corpus-paths-on-desktop.md`.
2. `engineering-best-practices`, 3. `test-driven-development` (a failing test before each change: run it against v4 /
   the current combined file first and show it fails).

## Done means
Every AC except the `(live)` ones proven by its named test against your job-only preview, with one screenshot each
(the rendered band, or a Chrome capture of the test log), listed in `ac_evidence[]`; the payload checks clean on your
preview; nothing outside your elements differs from v4 (byte-compare). Stop with `status: ready-for-review`.

## This machine
You start in your own throwaway worktree (`isolation: worktree`, made from `main`): use the repo there read-only for
its renderer, payload checks and Chrome driver; change nothing in it and commit nothing. Chrome: your own wrapper in
your scratch containing `exec /home/justin/.cache/chrome-for-testing/chrome-f2b --disable-software-rasterizer "$@"` as
`CHROME_PATH`, `/home/justin/.local/node-v22.23.3/bin` first on PATH; TMPDIR and profiles under
`/home/justin/.cache/services-band-speed-builder/`. Live pages (read only, never log in or change anything): https://bdryswi.com/ and
https://bdry.staging.growithgro.com/homev2/?bricks_preview=1793276386 . The worktree guard refuses Bash it can't prove
stays in your worktree (shell variables or loops around `node`/`git`/`sed`, heredoc then node, `git -C`, the word git
inside a grep pattern or a script's text, the word `source` anywhere, even in a path): write scripts with Write and run
them as one plain command. Waits: poll in chunks under 170 s. Other jobs run at the same time: leave their folders
alone.

## Rules
- Other bugs: `found_else` (one line each, evidence, severity); don't fix them.
- Lessons: `skill_lessons[{skill, lesson, evidence, enforce}]` (`enforce` is `none` or a one-line check proposal);
  normally empty. Never edit skills or memory. Don't start other agents.

## Return (your final message)
`{name, status: ready-for-review|stopped, edit_module, touches{elements[], classes[]}, preview_path, rulings[],
ac_evidence[{ac, test, screenshot}], found_else[], skill_lessons[]}`. End with the line
`MAIN SESSION: check and save these skill_lessons now.`
