# rich-text — Fixer 2 (review round 2)

**Role:** fixer. Load `receiving-code-review`, `engineering-best-practices`, `test-driven-development` (+ `mutation-testing-discipline`).

**Copy:** `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a4bddf14ed2da3ed7`, HEAD `e49499746fc97715bc143ea2ff50d4fcca4d95f4` (base 27e69d18). Don't rebase, fetch or push; don't bump BUILD; don't edit the main folder or CLAUDE.md; never bare `git stash`; never stage CLAUDE.md; plain `git commit -m`, no author override, no Co-Authored-By.

**Plan (frozen, amended):** `~/.hermes/plans/figma-to-bricks/evidence/rich-text/plan-approved.md`. Review record: `~/.hermes/plans/figma-to-bricks/evidence/rich-text/review-2/review.json` + `referee.txt` (read the full R2-1 line), probes `review-2/list.ts`, `boxes.ts`, PNGs `R2-1-list-dot-390-{base,head}.png`. This is the last review round under the project cap, so fix it completely.

**Fix R2-1 (P2), `src/core/adapt/rules/list.ts:160`:** a searchable list's phone card puts a dot between values with `.list-dot::before{content:"·"}` on each value column; that column is now Rich Text (`div.brxe-text.list-dot > p`), so the dot sits alone on a line above the `<p>`. On Services Page Final (`git show 2199895:figma-to-bricks-debug-page-1.json`) at 390 each dot cell grows 20→40px, each card 114→133px (78 cards). 768/1440 unchanged. Fix so the dot sits before the words again (e.g. target `> p::before`, or keep the dot inline with the `<p>` — your call, but CSS stays typed; the rule writes it through the normal rule/part path, never string-matched CSS), and **check every other place that styles or scripts a text element's inline content** for the same pattern now that words sit in a `<p>` (`::before`/`::after` content, `display:inline`/`inline-flex` assumptions, `text-overflow`/`line-clamp`, scripts finding leaf nodes — the reviewer found the list dot is the only generated pseudo content, re-confirm). P3s R2-2/R2-3 are follow-ups; don't fix.

**Tests first:** a browser test converting a Services-like list (a generic fixture with a searchable list in Compact card mode — don't copy the user's file) at 390: dot beside the first value's words, card height equal to main's ±0.5px; plus a real-file check: convert Services from git `2199895` with base (27e69d18) and head, compare every text box by id at 390/768/1440 (0 moves >0.5px). Prove the new test fails on e4949974.

**Gates:** `npm run check`; the rich-text + list browser tests; `npm run corpus` vs base (`~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`; scratch trees in a fresh folder e.g. `~/.cache/rtf2/`; compare with `grep -a`). Batch HANDOFF/ledger updates into the fix commit. Stop `ready-for-next-review`.

**Memory rule:** big runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`; SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first.

**Return:** status, new HEAD SHA, fixed (tests + commit) or rejected (evidence), other spots checked, gates vs base, `skill_lessons[{skill, lesson, evidence, enforce}]` (usually empty; never edit skills or memory). End with: `MAIN SESSION: check and save these skill_lessons now.`
