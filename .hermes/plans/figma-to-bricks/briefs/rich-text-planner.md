# rich-text — Planner (Mini pipeline)

**Role:** Planner, Mini pipeline. You write the plan only: no code and no tests. Read-only on the source; you write only the plan file.

**Repo:** FigmaToBricksV2. You run in your own git worktree copy (started from origin/main; first run `git fetch` is NOT allowed. Instead bring the copy to local main: `git -C <your copy> log -1 main` and `git reset --hard main` inside your copy if your branch has no commits of its own). Read the copy's `CLAUDE.md` first (the standing rules, especially "Build general logic", the architecture rules, and "Bricks element shapes come from `reference/bricks/*.json`").

**Request (from the designer, passed on by Justin as a general rule the plugin should follow from now on):**
> "Oh, one more thing to not use is the 'basic text' element. Instead it should always use 'rich text' for paragraphs"

So: the plugin should stop emitting Bricks' Basic Text element (`text-basic`) for paragraphs and use Rich Text (`text`) instead. Work out from the code what counts as a "paragraph" today vs. headings, button labels, list items, etc., and propose where the line goes. Check the Bricks samples in `reference/bricks/` and `ExampleBricks` (the user's hand-built target) for the exact Rich Text shape (`settings.text` holds HTML, e.g. `<p>…</p>`); never write the shape from memory. Consider: text runs with links/colours/weights (spans, `<a>`), typed line breaks (`style/rag.ts`), call/email links, `emit/page-addresses.ts` relinking, phone copies, `payloadProblems`, `test/browser/render.ts` (the renderer must draw Rich Text the way Bricks prints it: a `div.brxe-text` around the `<p>`, so margins of `<p>` matter), byte-identical replay, and the corpus.

**Skills to load:** `engineering-best-practices`, `implementation-planning`. Mini mode: load only the code/docs sections this touches; skip a full context load; finish within about 15–25 steps. If this is bigger or riskier than a Mini job (more than ~3 source files of real logic, or a design decision), say so in `summary` and recommend Full.

**Write the plan** to `docs/plans/2026-11-04-rich-text.md` in your copy and commit it (plain `git commit -m "…"`, no author override, no Co-Authored-By lines, never stage CLAUDE.md). Contents (short Mini plan):
- Questions at the top, each with a ⭐ recommended answer (Justin has a standing auto-go: the ⭐ answers are taken unless he says stop).
- Playback in plain words.
- Where Basic Text is emitted today, with file:line evidence.
- The fix: the general rule (what becomes Rich Text, what doesn't and why).
- Numbered ACs `AC1, AC2…`, each with one named test; mark them **(proposed)**; tag `(live)` right after the id for an AC only Justin can check (a paste into Bricks), e.g. `- AC5 (proposed) (live): …`.
- Touched files, tasks (test-first), and a one-line Docs & records task (HANDOFF section).

**Desktop memory rule:** a command dying with SIGTERM/exit 143/137/"Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before reading it as a result.

**Return:** the plan path, your branch name and commit SHA, a short summary, the AC list, the questions with ⭐ answers, and `skill_lessons[{skill, lesson, evidence, enforce}]` (usually empty; never edit skills or memory yourself; `enforce` is `none` or a one-line check proposal). End the report with: `MAIN SESSION: check and save these skill_lessons now.`
