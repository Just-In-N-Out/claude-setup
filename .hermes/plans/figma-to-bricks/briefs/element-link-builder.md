# element-link — Builder (Mini pipeline)

**Role:** Builder. Build the approved plan test-first and stop at `ready-for-review`.

**Plan (approved under Justin's standing auto-go, ⭐ answers taken; Justin: "just go with whatever it recommends"):** `docs/plans/2026-11-04-element-link.md` on branch `worktree-agent-a7ee435126f6aee8b`, commit `2d97e3d8386c920f9afec42c4f6b10c0c507b1fd`. Read-only copy: `~/.hermes/plans/figma-to-bricks/evidence/element-link/plan-approved.md`. ACs AC1–AC10 are the contract (AC10 is live: you only prepare the paste file and steps).

**Your copy:** you start in your own git worktree. First: `git reset --hard 2d97e3d8386c920f9afec42c4f6b10c0c507b1fd` (your branch has no commits yet). Do not fetch, pull or push. Read the copy's `CLAUDE.md` and `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`.

**Parallel job:** "rich-text" (plan on branch `worktree-agent-a51db68eccab1e2e6`, commit 8719182f, being built now) turns non-heading texts without an element link into Rich Text (`text`, `<p>…</p>`); texts with an element link stay Basic Text with Link to. Shared files: `understand/node.ts`, `understand/ir.ts`, `style/style.ts`, `emit/elements.ts`, `test/browser/render.ts`. Keep your changes there small and in clearly separate functions (e.g. `elementLink(ir)` in one place) so the later rebase is easy. Don't build rich-text's work.

**Skills to load:** `engineering-best-practices`, `test-driven-development` (+ `mutation-testing-discipline` for the no-nested-links guard: prove it fails when broken).

**Rules:**
- Ledger in `.superpowers/sdd/2026-11-04-element-link/progress.md`. Run `npm run corpus` before Task 1 and at the close.
- Each task: failing test first, then code; `npm run check` green; commit to your branch (plain `git commit -m`, no author override, no Co-Authored-By, never stage CLAUDE.md; check `git diff --cached --name-only`). Don't bump BUILD, don't edit the main folder or the copy's CLAUDE.md, never bare `git stash`.
- One test and one receipt per AC in `~/.hermes/plans/figma-to-bricks/evidence/element-link/builder/`: screenshots for AC8 (390/768/1440, main vs branch), terminal captures otherwise; for AC10 a paste file (`npm run replay` of a design holding an email line, e.g. `figma-to-bricks-debug-page-1.json` if it has one) and numbered steps for Justin.
- HANDOFF section per the plan's Docs & records task (paste check id "id at merge").
- Mutation runs and big browser runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first.
- If it needs much more than the plan says or a design decision: stop with `status: stopped`, `stop_reason: escalate to full`.

**Return:** `status`, branch and HEAD SHA, base commit (31321bb4), per-AC test name + receipt path, corpus before/after, `found_else`, `skill_lessons[{skill, lesson, evidence, enforce}]` (usually empty; never edit skills or memory). End with: `MAIN SESSION: check and save these skill_lessons now.`
