# icon-buttons — Reviewer round 3 (delta; the last round under the project cap)

**Role:** fresh delta reviewer. You never saw the build. **Report only:** change no source, commit nothing; write only `~/.hermes/plans/figma-to-bricks/evidence/icon-buttons/review-3/review.json`.

**Copy (read-only):** `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a3a2e06255dbe9262`, HEAD `45d3e8c1a9242408a6e7b667864020e67d5b07b1`. Base `31321bb48bebdc217d24e9fb65bf734b4fd65e2a`.

**History:** round 1 (full) R1-1 P2 (Button's own CSS wrote `display`, beating tier hides) fixed in 8683e982; round 2 (full) R2-1 P2 (`.tap-area::after` hijacked a small icon Button's `::after` arrow from 991 down) — Justin chose "Fix it" (`review-2/justin.json`). Fixer 2 (commit 45d3e8c1): the tap area goes on the pseudo-element the icons leave free (new class `tap-area-before` when the icon is after the words; `tap-area` when before); a pill under 44px with icons on both sides stays the base pill Div (fixer's ruling, not yet confirmed); `adapt/rules/tap.ts` writes each class's hit area on its own pseudo; a guard in `behaviours.ts`. Records: `review-1/`, `review-2/` (review.json, referee.txt), `fixer-2/`.

**Scope:** `git diff 8683e982..45d3e8c1` and what it touches: the `tap-area` rule and every element that gets `tap-area`/`tap-area-before` (plain Buttons, links, icons, menu toggles, linked Divs — did any of them change?), the new class in classes/global class emit (deterministic names, `settings: []` for empty classes), AC2's measuring helper change (does skipping absolute pseudos hide a real icon move?), the fixer's both-sides ruling. Probe real files (corpus copies, `figma-to-bricks-debug-page-1.json`, `git show 2199895:figma-to-bricks-debug-page-1.json`) at 990/768/390 vs 8683e982 and base. Judge whether R2-1's fix holds (`repeats` + `new_fact` if not). Anything outside the scope is P3. `round` 3, `scope` "delta", `from` 8683e982a03c65f22ce19a019fbe3a6ed8afefa5, `head` 45d3e8c1a9242408a6e7b667864020e67d5b07b1.

**Skills:** `requesting-code-review`, `code-review-practice`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` (three trees per probe: base, previous head, head). P0–P2 only with a concrete 5+ word real-use scenario; edge cases P3. Probes in a fresh scratch folder named for your role and round (e.g. `~/.cache/ibr3/`), `git -C <copy> archive <sha> | tar -x -C <folder>`, `node_modules` linked; never write into the copy. Corpus/Chrome: `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md` (compare logs with `grep -a`).

Self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <copy> --base 31321bb4 ~/.hermes/plans/figma-to-bricks/evidence/icon-buttons` (exit 2 = fix your file).

**Memory rule:** big runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`; SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first.

**Return:** `verdict`, findings, your view on the both-sides ruling, `ac_status`, `skill_lessons[{skill, lesson, evidence, enforce}]` (usually empty; never edit skills or memory). End with: `MAIN SESSION: check and save these skill_lessons now.`
