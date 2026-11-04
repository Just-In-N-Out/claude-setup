# icon-buttons — Fixer 1 (review round 1)

**Role:** fixer. Load `receiving-code-review`, `engineering-best-practices`, `test-driven-development` (+ `mutation-testing-discipline`: prove the new test fails without the fix).

**Copy:** `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a3a2e06255dbe9262`, branch `worktree-agent-a3a2e06255dbe9262`, HEAD `170d3d7f0dd19eea85139fda68ca2a2a37634f69`. Don't rebase, fetch or push; don't bump BUILD; don't edit the main folder or CLAUDE.md; never bare `git stash`; never stage CLAUDE.md; plain `git commit -m`, no author override, no Co-Authored-By.

**Approved plan:** `~/.hermes/plans/figma-to-bricks/evidence/icon-buttons/plan-approved.md`. Review record: `~/.hermes/plans/figma-to-bricks/evidence/icon-buttons/review-1/review.json` (probe scripts in `review-1/scripts/`).

**Referee output — fix the P2 (the P3s are follow-ups, don't fix them):**
```
R1-1  P2  src/core/emit/button-icons.ts:17  An icon Button's own custom CSS writes `#brxe-<id> { display: inline-flex }`, which Bricks (and the renderer) print after the element's control CSS, so it beats every tier `_display: none` a rule writes on the Button itself (phone.swap's hidden originals, compose.hide, menu fold's hidden items, list/site hides). Probe (scripts/probe-hero.ts + disp.ts): a hero with a photo behind its words and one 'Get a quote →' pill straight in its column: head shows the original Button on the photo at 700 and 390 (165x60 at 16,240) AND its phone-band copy under it; base hides the original (display none). The corpus files hide it only because their hero CTAs sit inside a parent that is hidden too.
```
Reviewer's hint: the renderer's `.brxe-button` rule is already `display:inline-flex; align-items:center`, so writing only `gap` (+ `align-items` if needed) without `display` may suffice — first check Bricks' own front-end CSS for `.brxe-button` (Bricks 2.3.9 on darksalmon: `frontend-light-layer.min.css` / per-page `post-<id>.min.css`, or GPL source per memory `bricks-source-research`) so the renderer matches Bricks. A general fix is better than only dropping `display`: no custom CSS on any element should out-rank a rule's tier `display: none` (check other emitters for the same pattern).

**Do:** verify the finding (run the reviewer's probe on head), write a failing test first (a hero whose icon CTA sits straight in its column: the original is hidden at 767/478 and only the phone-band copy shows; plus a unit check that nothing the Button's own CSS writes overrides a tier `display:none`), fix, keep AC2's 1px geometry. Then `npm run check` and the icon-buttons browser tests; `npm run corpus` vs base (Chrome/corpus on this desktop: `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`; compare logs with `grep -a`). Batch any record updates (HANDOFF/ledger) into the fix commit. Stop `ready-for-next-review`.

**Memory rule:** big runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`; SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first.

**Return:** status, new HEAD SHA, per finding: fixed (test + commit) or rejected (evidence), gates vs base, `skill_lessons[{skill, lesson, evidence, enforce}]` (usually empty; never edit skills or memory). End with: `MAIN SESSION: check and save these skill_lessons now.`
