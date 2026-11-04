# cta-names — Reviewer round 2 (delta, after a rebase)

**Role:** fresh delta reviewer. You never saw the build. **Report only:** change no source, commit nothing; write only `~/.hermes/plans/figma-to-bricks/evidence/cta-names/review-2/review.json`.

**Copy (read-only):** `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a521d809739b08a2d`, HEAD `f78fef988ee74e4f60097de7f42529b19e943fa9`.

**History:** round 1 (full, `from` 31321bb48bebdc217d24e9fb65bf734b4fd65e2a, `head` 86cd55dd8e14294ded4e4f37b8df88e313597228) was clean (three P3s, `review-1/review.json`). Then the finisher rebased with no conflicts onto local `main` `fb143824` ("Build 2026-11-04.4: general structure recognition") and added one commit moving the ledger to `docs/plans/2026-11-04-cta-names-ledger.md`. `npm run check` and corpus pass, equal to main.

**What cta-names does:** every CTA gets an accessible name: linked → `settings.link.ariaLabel`; unlinked → one `_attributes` `aria-label`; inside a linked card → none; vague words → "<words> about <card title>" (title from the card, else the nearest section box with bigger words).

**Scope:** `git range-diff 31321bb4..86cd55dd fb143824..b7ff6885` (did any patch change?), `git show f78fef98` (the ledger move), and how cta-names interacts with main's new code between 31321bb4 and fb143824 (structure recognition: header/footer/navigation/review/footer-column destinations; e.g. does main now make CTAs or links that get no name or a wrong title, or a link object that `markCtas`/`nameCtas` misreads). Probe the real files (corpus copies, `figma-to-bricks-debug-page-1.json`, `git show 2199895:figma-to-bricks-debug-page-1.json`) with the rebased head. Anything else is P3. `round` 2, `scope` "delta", `from` 86cd55dd8e14294ded4e4f37b8df88e313597228, `head` f78fef988ee74e4f60097de7f42529b19e943fa9.

**Skills:** `requesting-code-review`, `code-review-practice`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`. P0–P2 only with a concrete 5+ word real-use scenario; edge cases P3. Probes in a scratch copy (`git -C <copy> archive <sha> | tar -x -C <scratch>` + linked `node_modules`), never writing into the copy. Corpus/Chrome: `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`.

Self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <copy> --base fb143824 ~/.hermes/plans/figma-to-bricks/evidence/cta-names` (exit 2 = fix your file).

**Memory rule:** big runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`; SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first.

**Return:** `verdict`, findings, `ac_status`, `skill_lessons[{skill, lesson, evidence, enforce}]` (usually empty; never edit skills or memory). End with: `MAIN SESSION: check and save these skill_lessons now.`
