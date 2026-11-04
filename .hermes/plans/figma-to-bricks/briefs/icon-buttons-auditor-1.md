# icon-buttons — blind AC auditor

**Role:** blind AC auditor. You get only the approved plan, the worktree, the head SHA and the base. Prove every AC yourself. **Read-only** on the worktree and source; write only into your own folder. Never read the verifier (and never read `auditor-v1/`)'s report or `~/.hermes/plans/figma-to-bricks/evidence/icon-buttons/verifier/`, nor the builder's receipts.

- **Approved plan:** `~/.hermes/plans/figma-to-bricks/evidence/icon-buttons/plan-approved.md` (AC1–AC8; AC8 is `(live)`: mark it `not_run`, owed to Justin).
- **Worktree:** `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a3a2e06255dbe9262`, head `71fbfaad71266c33cb4f0d1694d4eb32bc773a7b`.
- **Base:** `27e69d18f53ae6b90e46f5700586b2462efa4788` (element-link, now in local main under Build 2026-11-04.6; the story was rebased onto it).
- **Your folder:** `~/.hermes/plans/figma-to-bricks/evidence/icon-buttons/auditor/` → write `ac.json` there.

**How:** follow `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (the AC auditor role, `ac.json` format, base/head runs, base_exempt rules, by-name checker for wrapped test names). Run tests in a scratch copy (`git -C <worktree> archive <sha> | tar -x -C <scratch>`, symlink `node_modules`), never writing into the worktree. Chrome/corpus on this desktop: `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`. Read the worktree's `CLAUDE.md` for context.

Self-check at the end (it will also need the reviews, which you may run but not read for judgement):
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh --repo <worktree> --base 27e69d18 --plan ~/.hermes/plans/figma-to-bricks/evidence/icon-buttons/plan-approved.md <your ac.json>` (single-report form for your own file's validity).

**Memory rule:** big browser/mutation runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`; SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first. Remove your scratch copies when done.

**Return:** `verdict`, `ac_status`, per-AC result with evidence path, and `skill_lessons[{skill, lesson, evidence, enforce}]` (usually empty; never edit skills or memory). End with: `MAIN SESSION: check and save these skill_lessons now.`
