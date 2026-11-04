# element-link — Planner (Mini pipeline)

**Role:** Planner, Mini pipeline. You write the plan only: no code and no tests. Read-only on the source; you write only the plan file.

**Repo:** FigmaToBricksV2. You run in your own git worktree copy (started from origin/main; do NOT fetch or pull. Bring the copy to local main first: if your branch has no commits of its own, run `git reset --hard main` inside your copy). Read the copy's `CLAUDE.md` first (standing rules, especially "Build general logic", the architecture rules, "Every link kind … goes through `emit/page-addresses.ts` and the panel's `ui/site-pages.ts` `relink`", "A link never sits inside another link", and "Bricks element shapes come from `reference/bricks/*.json`").

**Request (designer Niklas, passed on by Justin as a general rule):**
> "Do you know if it's possible for the app to not use a href in the text, and instead use the link to option further down?"

His screenshot: a Bricks text element (the Basic Text panel, HTML tag `div`) whose text holds `<a href="mailto:d.tuckeralltypehydraulic@gmail.com" style="color:inherit;text-decoration:inherit">d.tuckeralltypehydraulic@gmail.com</a>`, with the element's own **Link to** control (Select link type) empty below it. Asked which link type, he said: "Depends on where it's navigating to. Is it internal, or external etc".

So: where a text element's whole text is one link (an email, a phone number, a page link, an outside address), the plugin should set the element's own **Link to** control with the right link type (internal page, external URL, email/tel as Bricks stores them) instead of an `<a href>` inside the text. Find out from Bricks' own data shapes (the samples in `reference/bricks/`, `ExampleBricks`, and the GPL Bricks source if no sample shows the link control's shape for each type, see memory `bricks-source-research`) exactly how `settings.link` is stored per type (`type: "external"` + `url`, `type: "internal"` + `postId`, etc.); never write it from memory. Decide what happens when only part of the text is linked (a link inside a sentence stays an inline `<a>`, since one element can hold only one link), and whether internal page links can name a `postId` (the panel's site check knows the site's pages) or stay `external` with the address.

**IMPORTANT overlap with a parallel job:** another planner ("rich-text", plan `docs/plans/2026-11-04-rich-text.md`) is changing paragraphs from Basic Text (`text-basic`) to Rich Text (`text`), per the designer's other note: "one more thing to not use is the 'basic text' element. Instead it should always use 'rich text' for paragraphs". Check whether Bricks' Rich Text element has a **Link to** control at all (Basic Text and Heading do; read Bricks' element controls). If Rich Text has none, say how the two rules fit together (e.g. a whole-link text stays an element with a link control, or the link moves to a wrapper) and put it as a question with a ⭐ answer. Keep your touched files separate from that job where you can and list the shared files.

**Skills to load:** `engineering-best-practices`, `implementation-planning`. Mini mode: load only the code/docs sections this touches; finish within about 15–25 steps. If this is bigger or riskier than a Mini job, say so in `summary` and recommend Full.

**Write the plan** to `docs/plans/2026-11-04-element-link.md` in your copy and commit it (plain `git commit -m "…"`, no author override, no Co-Authored-By lines, never stage CLAUDE.md). Contents (short Mini plan):
- Questions at the top, each with a ⭐ recommended answer (Justin has a standing auto-go).
- Playback in plain words.
- Where text links are emitted today, with file:line evidence.
- The fix: the general rule and Bricks' link shape per type, with the source of each shape.
- Numbered ACs `AC1, AC2…`, each with one named test; mark them **(proposed)**; tag `(live)` right after the id for an AC only Justin can check (a paste into Bricks), e.g. `- AC5 (proposed) (live): …`.
- Touched files (and those shared with rich-text), tasks (test-first), a one-line Docs & records task.

**Desktop memory rule:** a command dying with SIGTERM/exit 143/137/"Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before reading it as a result.

**Return:** the plan path, branch name and commit SHA, a short summary, the AC list, the questions with ⭐ answers, and `skill_lessons[{skill, lesson, evidence, enforce}]` (usually empty; never edit skills or memory yourself). End the report with: `MAIN SESSION: check and save these skill_lessons now.`
