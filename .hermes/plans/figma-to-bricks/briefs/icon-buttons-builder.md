# icon-buttons — Builder (Full pipeline)

**Role:** Builder. Build the approved plan test-first and stop at `ready-for-review`.

**Plan (approved: Justin's auto-go and "just go with whatever it recommends"; ⭐ answers taken):** `docs/plans/2026-11-04-icon-buttons.md` on branch `worktree-agent-a0fa55c43b8bec638`, commit `3ef240840693e4af973c020e778e9d0400d18537`. Read-only copy: `~/.hermes/plans/figma-to-bricks/evidence/icon-buttons/plan-approved.md`. ACs AC1–AC8 are the contract (AC8 is live: prepare the hydraulics-hero paste file and Justin's numbered steps only).

**Your copy:** your own git worktree. First: `git reset --hard 3ef240840693e4af973c020e778e9d0400d18537`. Do not fetch, pull or push. Read the copy's `CLAUDE.md` (especially Native Buttons, Call-to-action buttons, nested links, layout plan rules, "A size change made after Figma must reach the layout plan") and `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`.

**Parallel jobs (don't build their work):** cta-names (aria names on CTAs; you rebase on it after it merges), rich-text (paragraphs → Rich Text), element-link (whole-link texts → element Link to, helper `elementLink(ir)`; if it hasn't merged when you need it, write the smallest local equivalent and note it for the rebase). Expect conflicts in `emit/elements.ts`, `understand/node.ts`, `understand/widgets.ts`: keep your changes in clearly separate functions/files.

**Skills:** `engineering-best-practices`, `test-driven-development` (+ `mutation-testing-discipline` for the nested-link and fallback guards).

**Rules:** ledger `.superpowers/sdd/2026-11-04-icon-buttons/progress.md`; `npm run corpus` before Task 1 and at the close; each task failing test first, `npm run check` green, commit (plain `git commit -m`, no author override, no Co-Authored-By, never stage CLAUDE.md; check `git diff --cached --name-only`); don't bump BUILD, don't edit the main folder or the copy's CLAUDE.md, never bare `git stash`. One test and one receipt per AC in `~/.hermes/plans/figma-to-bricks/evidence/icon-buttons/builder/`: screenshots for the browser ACs (base vs branch at 1440/1024/768/390), terminal captures otherwise. HANDOFF section per the plan (paste check "id at merge"). Mutation and big browser runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`; SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first. A design decision the plan doesn't cover: stop and report it as a question with a ⭐ answer.

**Return:** `status`, branch + HEAD SHA, base (31321bb4), per-AC test + receipt path, corpus before/after, `found_else`, `skill_lessons[{skill, lesson, evidence, enforce}]` (usually empty; never edit skills or memory). End with: `MAIN SESSION: check and save these skill_lessons now.`
