# rich-text — Reviewer round 3 (delta; last round under the project cap)

**Role:** fresh delta reviewer. You never saw the build. **Report only:** change no source, commit nothing; write only `~/.hermes/plans/figma-to-bricks/evidence/rich-text/review-3/review.json`.

**Copy (read-only):** `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a4bddf14ed2da3ed7`, HEAD `b42ae24ded781d4b68b6c5903ec47718e2e840f9`. Base `27e69d18f53ae6b90e46f5700586b2462efa4788`.

**History:** round 2 (full, 27e69d18→e4949974; `review-2/review.json`, `referee.txt`) found R2-1 (P2): the phone card's `.list-dot::before` dot landed on its own line above the Rich Text's `<p>` (Services' 78 cards +19px at 390). Fixer 2 (b42ae24d): `adapt/rules/list.ts` part now `" p:first-child::before"` (typed CSS); **plus a second fix the review didn't list**: `emit/lists.ts` `leaves()` treats a lone `<p>` leaf as its parent element (the search field was being put inside the text). Tests: browser "R2-1" in `test/browser/rich-text-boxes.test.ts` (three list shapes vs main's paste, dot inline, search field position), real-file probe `evidence/rich-text/fixer-2/boxes.ts` (0 moves on 5 files).

**Scope:** `git diff e4949974..b42ae24ded781d4b68b6c5903ec47718e2e840f9` and what it touches: the list dot rule (does `p:first-child::before` match every value shape — linked value (Block > Rich Text > p), a value that is a Heading or Button, a value Div holding several texts?), the `leaves()` change (pills, row cells, count, search across list shapes; a list whose cell holds a linked text; the list script must name no `brxe-`), whether R2-1's fix holds on the real Services list (`git show 2199895:figma-to-bricks-debug-page-1.json`) at 390/768/1440 — three trees (base, e4949974, head). Anything outside scope P3. `round` 3, `scope` "delta", `from` e49499746fc97715bc143ea2ff50d4fcca4d95f4, `head` b42ae24ded781d4b68b6c5903ec47718e2e840f9.

**Skills:** `requesting-code-review`, `code-review-practice`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`. P0–P2 only with a concrete 5+ word real-use scenario. Scratch trees in a fresh folder (e.g. `~/.cache/rtr3/`), `node_modules` linked; never write into the copy. Corpus/Chrome: `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md` (`grep -a`).

Self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <copy> --base 27e69d18 ~/.hermes/plans/figma-to-bricks/evidence/rich-text` (exit 2 = fix your file).

**Memory rule:** big runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`; SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first.

**Return:** `verdict`, findings, `ac_status`, `skill_lessons[{skill, lesson, evidence, enforce}]` (usually empty; never edit skills or memory). End with: `MAIN SESSION: check and save these skill_lessons now.`
