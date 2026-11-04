# element-link — Reviewer round 2 (delta, after a rebase)

**Role:** fresh delta reviewer. You never saw the build. **Report only:** change no source, commit nothing; write only `~/.hermes/plans/figma-to-bricks/evidence/element-link/review-2/review.json`.

**Copy (read-only):** `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a7f58956799bac1e2`, HEAD `ea333d5f9db0582e2010d826f0e3330fb13e9d06`.

**History:** round 1 (full, `from` 31321bb48bebdc217d24e9fb65bf734b4fd65e2a, `head` b21acaac02c3f682ac2e7febc0147a752d5ba121) was clean (`~/.hermes/plans/figma-to-bricks/evidence/element-link/review-1/review.json`, three P3s). Then the finisher moved the ledger and rebased with no conflicts onto local `main` `fb143824` ("Build 2026-11-04.4: general structure recognition"), and `npm run check` failed on main's new test `test/unit/recognition-footer-safety.test.ts:177`, which pinned the old inline-`<a>` form for a footer phone/email entry. Fixer 1 changed only that assertion to the approved Link to form (commit ea333d5f), proved it can fail, and checked main's new structure-recognition readers still see run links (element-link keeps runs and adds `ir.textLink`).

**Scope (review-loop.md, rebase inside the loop):** review `git range-diff 31321bb4..b21acaac fb143824..f713ab94` (did the rebase change any patch?) plus `git diff f713ab94..ea333d5f` (the fix), plus how element-link interacts with main's new code that came in between 31321bb4 and fb143824 (structure recognition: footer/header/navigation/review readers): any place where moving a whole-text link to `textLink`/Link to changes behaviour or output of that new code beyond the intended form change. Anything else is P3. `round` 2, `scope` "delta", `from` b21acaac02c3f682ac2e7febc0147a752d5ba121, `head` ea333d5f9db0582e2010d826f0e3330fb13e9d06.

**Skills:** `requesting-code-review`, `code-review-practice`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`. Severity: P0–P2 only with a concrete 5+ word real-use scenario (a real design or normal use); edge cases P3. Run probes in a scratch copy (`git archive` + linked `node_modules`), never writing into the copy. Corpus/Chrome: `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`.

Self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <copy> --base fb143824 ~/.hermes/plans/figma-to-bricks/evidence/element-link` (exit 2 = fix your file).

**Memory rule:** big runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`; SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first.

**Return:** `verdict`, findings, `ac_status` (your read of whether the ACs still hold on the new head), `skill_lessons[{skill, lesson, evidence, enforce}]` (usually empty; never edit skills or memory). End with: `MAIN SESSION: check and save these skill_lessons now.`
