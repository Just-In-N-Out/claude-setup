# rich-text — Builder (Mini pipeline)

**Role:** Builder. Build the approved plan test-first and stop at `ready-for-review`.

**Plan (approved under Justin's standing auto-go, ⭐ answers taken):** `docs/plans/2026-11-04-rich-text.md` on branch `worktree-agent-a51db68eccab1e2e6`, commit `8719182f47c69d12e4e4b10d77f2fcc7c4316591`. Read-only copy: `~/.hermes/plans/figma-to-bricks/evidence/rich-text/plan-approved.md`. Its ACs AC1–AC8 are the contract (AC8 is live: Justin's paste; you only prepare the paste file for it).

**Your copy:** you start in your own git worktree. First bring it to the plan's commit: `git reset --hard 8719182f47c69d12e4e4b10d77f2fcc7c4316591` (your branch has no commits of its own yet). Do not fetch, pull or push. Read the copy's `CLAUDE.md` (standing rules, "Working in this repo", checks) and the memory note `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md` (corpus paths and Chrome on this desktop).

**Parallel job:** "element-link" (being planned) moves whole-link texts to the element's Link to control. Your plan's Q2 (⭐A: a wholly-linked text stays Basic Text with Link to) is the bridge. Keep inline links in sentences as they are; don't build element-link's work.

**Skills to load:** `engineering-best-practices`, `test-driven-development` (+ `mutation-testing-discipline` for the AC4 invariant guard: prove it fails when broken).

**Rules:**
- Ledger in `.superpowers/sdd/2026-11-04-rich-text/progress.md`. Run `npm run corpus` before Task 1 and at the close.
- Each task: failing test first, then the code; `npm run check` green; commit to your branch (plain `git commit -m`, no author override, no Co-Authored-By, never stage CLAUDE.md; check `git diff --cached --name-only`). Don't bump BUILD, don't edit the main folder or the copy's CLAUDE.md, never bare `git stash`.
- One test and one receipt per AC in `~/.hermes/plans/figma-to-bricks/evidence/rich-text/builder/`: a screenshot where there is something visual (AC5/AC6: browser shots before/after at 390/768/1440), a terminal capture of the test run otherwise. For AC8 put a paste file there (`npm run replay` of `figma-to-bricks-debug-page-1.json`) and the numbered steps Justin follows.
- HANDOFF section per the plan's Docs & records task (the paste check id is given at the merge; write "id at merge").
- Mutation runs and any big browser run: under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. A command dying with SIGTERM/143/137/"Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first.
- If the fix needs much more than the plan says, a design decision, or other areas: stop with `status: stopped`, `stop_reason: escalate to full`.

**Return:** `status` (ready-for-review / stopped), branch name and HEAD SHA, base commit (31321bb4), per-AC test name + receipt path, corpus before/after numbers, `found_else`, and `skill_lessons[{skill, lesson, evidence, enforce}]` (usually empty; never edit skills or memory). End with: `MAIN SESSION: check and save these skill_lessons now.`
