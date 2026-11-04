# cta-names — Builder (Mini pipeline)

**Role:** Builder. Build the approved plan test-first and stop at `ready-for-review`.

**Plan (approved: Justin's auto-go and "just go with whatever it recommends"; ⭐ answers taken):** `docs/plans/2026-11-04-cta-names.md` on branch `worktree-agent-a0fa55c43b8bec638`, commit `3ef240840693e4af973c020e778e9d0400d18537`. Read-only copy: `~/.hermes/plans/figma-to-bricks/evidence/cta-names/plan-approved.md`. ACs AC1–AC6 are the contract (AC6 is live: prepare the paste file and Justin's numbered steps only).

**Your copy:** your own git worktree. First: `git reset --hard 3ef240840693e4af973c020e778e9d0400d18537`. Do not fetch, pull or push. Read the copy's `CLAUDE.md` and `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`.

**Parallel jobs (don't build their work):** rich-text (paragraphs → Rich Text), element-link (whole-link texts → element Link to, helper `elementLink(ir)`), icon-buttons (icon pills → Buttons; rebases on you). You share `emit/elements.ts`: keep your change there small (ariaLabel inside the link object, one `_attributes` entry), ideally in a helper in its own file.

**Skills:** `engineering-best-practices`, `test-driven-development` (+ `mutation-testing-discipline` for the AC4 invariant).

**Rules:** ledger `.superpowers/sdd/2026-11-04-cta-names/progress.md`; `npm run corpus` before Task 1 and at the close; each task failing test first, `npm run check` green, commit (plain `git commit -m`, no author override, no Co-Authored-By, never stage CLAUDE.md; check `git diff --cached --name-only`); don't bump BUILD, don't edit the main folder or the copy's CLAUDE.md, never bare `git stash`. One test and one receipt per AC in `~/.hermes/plans/figma-to-bricks/evidence/cta-names/builder/` (terminal captures; a screenshot where visual). HANDOFF section per the plan (paste check "id at merge"). Mutation and big browser runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`; SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first. If it needs much more than planned: stop, `stop_reason: escalate to full`.

**Return:** `status`, branch + HEAD SHA, base (31321bb4), per-AC test + receipt path, corpus before/after, `found_else`, `skill_lessons[{skill, lesson, evidence, enforce}]` (usually empty; never edit skills or memory). End with: `MAIN SESSION: check and save these skill_lessons now.`
