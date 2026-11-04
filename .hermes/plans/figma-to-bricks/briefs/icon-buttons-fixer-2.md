# icon-buttons — Fixer 2 (review round 2)

**Role:** fixer. Load `receiving-code-review`, `engineering-best-practices`, `test-driven-development` (+ `mutation-testing-discipline`).

**Copy:** `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a3a2e06255dbe9262`, HEAD `8683e982a03c65f22ce19a019fbe3a6ed8afefa5`. Don't rebase, fetch or push; don't bump BUILD; don't edit the main folder or CLAUDE.md; never bare `git stash`; never stage CLAUDE.md; plain `git commit -m`, no author override, no Co-Authored-By.

**Justin chose "Fix it"** after the referee's ASK JUSTIN (`review-2/justin.json`). Records: `~/.hermes/plans/figma-to-bricks/evidence/icon-buttons/review-2/review.json`, probes in `review-2/scripts/` (`probe-tap.ts`, `probe-tap-browser.ts`). This is the last review round under the project cap, so make the fix complete and well tested.

**Finding to fix:**
```
R2-1  P2  src/core/emit/button-icons.ts:12  An icon Button's icon after its words is drawn as its ::after, but every Button under 44px tall (or wide) that isn't crowded also gets the tap-area class (style/behaviours.ts:49: role === "button"), whose rule (adapt/rules/tap.ts:14, from 991 down) is `.tap-area::after { content: ""; position: absolute; inset: min(0px, calc(50% - 22px)) }`. The Button's own `#brxe-<id>::after` sets no position, so the class's position: absolute applies to the arrow. Probe: a 40px painted pill 'Learn more' + 16px SVG arrow, 8px gap → Button with classes tap-area + cta-motion; in Chrome at 1440 the ::after is static (144.5 wide), at 990/768/390 it is position absolute at top -2px left 0 (over the pill's left edge and its words) and the Button shrinks to 120.5 wide; the finger-sized hit area is lost too. Base kept the arrow as the pill Div's own child. ::before (icon left) is not hit.
```
Reviewer's options: give the icon pseudo `position: static; inset: auto`; keep `tap-area` off an icon Button with an `::after`; or move the tap area to a free pseudo. Pick the one that keeps **both** the arrow in place **and** the finger-sized tap area on small icon Buttons — think about icon before, after and both sides. Also check any other class/rule writing `::before`/`::after` on elements that can now be icon Buttons (`cta-motion`, flip, hotspot, focus ring, product-card glare) for the same collision.

**Do:** verify with the probe; failing tests first (unit: a <44px icon Button keeps its icon static and still has a tap area from 991 down; browser: at 990/768/390 the arrow stays after the words and the Button keeps its width; cover before/after/both); fix; keep AC2's 1px test and R1-1's hide test green. `npm run check`; icon-buttons + nearby browser tests; `npm run corpus` vs base (`~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`; compare logs with `grep -a`). Batch HANDOFF/ledger updates into the fix commit. Stop `ready-for-next-review`.

**Memory rule:** big runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`; SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first.

**Return:** status, new HEAD SHA, fixed (tests + commit) or rejected (evidence), gates vs base, `skill_lessons[{skill, lesson, evidence, enforce}]` (usually empty; never edit skills or memory). End with: `MAIN SESSION: check and save these skill_lessons now.`
