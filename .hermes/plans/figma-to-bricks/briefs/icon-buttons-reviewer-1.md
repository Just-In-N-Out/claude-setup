# icon-buttons — Reviewer round 1 (Full pipeline: full review, report only)

**Role:** fresh reviewer. You never saw the build. **Report only:** change no source, commit nothing; write only `~/.hermes/plans/figma-to-bricks/evidence/icon-buttons/review-1/review.json`.

**Worktree (read-only):** `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a3a2e06255dbe9262`, branch `worktree-agent-a3a2e06255dbe9262`, head `170d3d7f0dd19eea85139fda68ca2a2a37634f69`. Base `31321bb48bebdc217d24e9fb65bf734b4fd65e2a`. Review `git diff 31321bb4..HEAD`. Probes/checks in a scratch copy (`git -C <worktree> archive <sha> | tar -x -C <scratch>`, link `node_modules`), never writing into the worktree.

**Approved plan:** `~/.hermes/plans/figma-to-bricks/evidence/icon-buttons/plan-approved.md` (AC1–AC8; AC8 live). Builder receipts in `.../icon-buttons/builder/` — don't trust them.

**What it does:** a painted pill with words plus an SVG icon (most CTAs) becomes Bricks' Button with no children, the icon drawn as its `::before`/`::after` (SVG data URL) at drawn size and gap; Buttons inside a link/hover copy/linked flip back get no own link; a label wholly a designer's link becomes a linked Button (replacing the F4 Div ruling); listed fallbacks stay Divs. The builder added rulings the plan didn't spell out (HANDOFF "Icon Buttons", not yet confirmed): **R1** a pill ≥44px ignores its own hover when choosing Button vs Div (CTAs never hover); **case 4 widened** (any hover CSS can't draw or any icon change keeps a Div); **R4** an icon Button widens on tablets like the pill Div did (`reflowWidens`); overlay copies now carry the instance's words and min size; R3 trailing letter-spacing taken from the gap before a trailing icon. Judge each on real designs.

**Look hard at (real designs, normal use):** the Button's icon in both picture modes (inline JSON and WordPress uploads), icon colour vs the drawn colour (currentColor? a recoloured SVG on hover?), `cta-motion` lift/fade still applying, phone full-width + `cta.center` centring with the icon, `min-font` 13px floor, `give-way`/`least`/layout plan reading the Button's width (CLAUDE.md "A size change made after Figma must reach the layout plan"), wrapped words with an icon, the panel's site check relinking a Button, Bricks' Button shape vs `reference/bricks/` samples (keys allowed on `button`: `_flexDirection`/`_gap` not `_direction`; `payloadProblems`), SVG data URL escaping in CSS, nested links, hover-layer copies, flip backs. Read the worktree's `CLAUDE.md`.

Note the parallel jobs (not findings): cta-names (aria names, merging first), element-link (whole-text links → Link to, `elementLink(ir)`; this job has a local stand-in `widgets.ts labelLink` to reconcile at the rebase), rich-text.

**Skills:** `requesting-code-review`, `code-review-practice`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`. Severity: P0–P2 only with a concrete 5+ word real-use scenario; edge cases P3 (project cap: at most 3 review rounds, so prioritise what a real design hits). Corpus/Chrome: `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md` (compare logs with `grep -a`).

Round 1, `scope` full, `from` 31321bb48bebdc217d24e9fb65bf734b4fd65e2a, `head` 170d3d7f0dd19eea85139fda68ca2a2a37634f69. Self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <worktree> --base 31321bb4 ~/.hermes/plans/figma-to-bricks/evidence/icon-buttons` (exit 2 = fix your file).

**Memory rule:** big runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`; SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first.

**Return:** `verdict`, findings (id, severity, file:line, claim, scenario), your view on R1/R4/case-4 rulings, `ac_status`, `skill_lessons[{skill, lesson, evidence, enforce}]` (usually empty; never edit skills or memory). End with: `MAIN SESSION: check and save these skill_lessons now.`
