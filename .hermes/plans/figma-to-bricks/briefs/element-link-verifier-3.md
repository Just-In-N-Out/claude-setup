# element-link — blind AC auditor

**Role:** fresh read-only VERIFIER (ac-verification.md role 1) after review-3 printed MOVE ON. You never saw the build. Re-run the gates (`npm run check`, the full browser suite by name vs base, `npm run corpus` vs base) and prove every AC on head and base. Read-only on the worktree; write only into `~/.hermes/plans/figma-to-bricks/evidence/element-link/verifier/`. Don't read the auditor folders.

- **Approved plan:** `~/.hermes/plans/figma-to-bricks/evidence/element-link/plan-approved.md` (AC1–AC10; AC10 is `(live)`: mark it `not_run`, owed to Justin).
- **Worktree:** `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a7f58956799bac1e2`, head `27e69d18f53ae6b90e46f5700586b2462efa4788`.
- **Base:** `10a5dc2c (local main, Build 2026-11-04.5; full SHA via git rev-parse 10a5dc2c; the story was rebased onto it)`.
- **Your folder:** `~/.hermes/plans/figma-to-bricks/evidence/element-link/verifier/` → write `ac.json` there.

**How:** follow `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (the AC auditor role, `ac.json` format, base/head runs, base_exempt rules, by-name checker for wrapped test names). Run tests in a scratch copy (`git -C <worktree> archive <sha> | tar -x -C <scratch>`, symlink `node_modules`), never writing into the worktree. Chrome/corpus on this desktop: `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`. Read the worktree's `CLAUDE.md` for context.

Self-check at the end (it will also need the reviews, which you may run but not read for judgement):
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh --repo <worktree> --base 10a5dc2c --plan ~/.hermes/plans/figma-to-bricks/evidence/element-link/plan-approved.md <your ac.json>` (single-report form for your own file's validity).

**Memory rule:** big browser/mutation runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`; SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first. Remove your scratch copies when done.

**Return:** `verdict`, `ac_status`, per-AC result with evidence path, and `skill_lessons[{skill, lesson, evidence, enforce}]` (usually empty; never edit skills or memory). End with: `MAIN SESSION: check and save these skill_lessons now.`
