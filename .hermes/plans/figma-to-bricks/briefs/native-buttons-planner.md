# native-buttons — Planner (Mini pipeline)

**Role:** Planner, Mini pipeline. Plan only: no code, no tests. You write only the plan file.

**Repo:** FigmaToBricksV2. You run in your own git worktree copy. Do NOT fetch or pull; first run `git reset --hard main` inside your copy (your branch has no commits yet). Read the copy's `CLAUDE.md` first: especially "Native Buttons by shape alone", "Call-to-action buttons" (`understand/widgets.ts` `markCtas`, `IRNode.cta`, `cta-motion`), "A link never sits inside another link", the review-F4 note ("a pill whose label carries [a designer's link] is a Div with a linked text, not a Button"), "Unverified in Bricks: … `_attributes` … `aria-*`", and "Bricks element shapes come from `reference/bricks/*.json`".

**Request (designer, passed on by Justin as a general rule):**
> "We also need to make so the app is not creating divs as buttons. Instead it should use button elements, also add aria label to CTA."

Two parts:
1. Find every case where the plugin emits a button-looking thing (a painted pill/box around a short label, a CTA, an icon button, hover-state buttons, phone copies, flip-card backs, slider arrows, the phone menu toggle, form send buttons…) as a Div/Block instead of Bricks' Button element (`button`, sample `reference/bricks/` + `ExampleBricks`). Explain with file:line why each case is a Div today (nested links, hover states built as overlays, icon+label layouts, inline pictures mode…), and propose a general rule that makes them Buttons wherever Bricks' Button can carry the look and behaviour, with a fallback named for what truly can't.
2. Add an accessible name (`aria-label`) to every CTA. Work out how Bricks stores custom attributes (`settings._attributes`, shape `[{id, name, value}]`?) from Bricks' own source (memory `bricks-source-research`: GPL Bricks 2.2 at `saqib6571/bricksbuilder`, fetch one file per plain `gh api … -H "Accept: application/vnd.github.raw" > <scratch file>` call) and whether a pasted `_attributes` survives (it's listed unverified: make the live round trip an AC tagged `(live)`). Decide the label's text: WCAG says an aria-label must contain the visible words (2.5.3 Label in Name); propose e.g. the visible label plus context only where the visible label is vague ("Learn more" → "Learn more about <card title>"), else the visible words; icon-only buttons get a name from their link/purpose. Put that as a question with a ⭐ answer.

**Parallel jobs (don't build their work; list shared files):**
- "rich-text" (being built): non-heading texts without an element link become Rich Text (`text`, `<p>`); whole-link texts stay Basic Text with Link to.
- "element-link" (being built): a text wholly one link gets the element's Link to (`settings.link`) instead of an inline `<a>`; helper `elementLink(ir)`.

**Skills to load:** `engineering-best-practices`, `implementation-planning`. Mini mode: only the code/docs this touches; about 15–25 steps. If this is bigger or riskier than Mini, say so in `summary`, recommend Full, and if the two parts split cleanly, say whether they should be two jobs.

**Write the plan** to `docs/plans/2026-11-04-native-buttons.md` in your copy and commit it (plain `git commit -m`, no author override, no Co-Authored-By, never stage CLAUDE.md). Short Mini plan: questions at the top with ⭐ answers (Justin: "just go with whatever it recommends"); playback; today's Div-as-button cases with file:line; the rule; Bricks shapes with their source; numbered ACs `AC1…` each with one named test, marked **(proposed)**, `(live)` right after the id where only Justin can check; touched/shared files; tasks (test-first); a one-line Docs & records task.

**Desktop memory rule:** SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first.

**Return:** plan path, branch, commit SHA, summary, AC list, questions with ⭐ answers, `skill_lessons[{skill, lesson, evidence, enforce}]` (usually empty; never edit skills or memory). End with: `MAIN SESSION: check and save these skill_lessons now.`
