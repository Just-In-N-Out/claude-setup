# rich-text — Fixer 1 (review round 1)

**Role:** fixer. Load `receiving-code-review`, `engineering-best-practices`, `test-driven-development` (+ `mutation-testing-discipline`).

**Copy:** `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a4bddf14ed2da3ed7`, HEAD `794386223c53a20f7bfbb86de324b59f373c9e68`. Don't rebase, fetch or push; don't bump BUILD; don't edit the main folder or CLAUDE.md; never bare `git stash`; never stage CLAUDE.md; plain `git commit -m`, no author override, no Co-Authored-By.

**Plan:** `~/.hermes/plans/figma-to-bricks/evidence/rich-text/plan-approved.md` ("the page must look exactly as before"; AC6/AC8). Review record: `~/.hermes/plans/figma-to-bricks/evidence/rich-text/review-1/review.json`; full referee lines in `review-1/referee.txt` (read them).

**Findings to fix (both P2; R1-3 is a P3 follow-up — fix only if your R1-1/R1-2 fix covers it for free):**
- **R1-1:** Bricks' Rich Text prints its words through `Helpers::parse_editor_content` (GPL Bricks 2.2 `includes/helpers.php:2732-2803`, called from `elements/text.php:85`; source: `gh api repos/saqib6571/bricksbuilder/contents/<path> -H "Accept: application/vnd.github.raw" > <scratch file>`, one plain call per file): it strips our outer `<p>`, then runs wptexturize and wpautop. wpautop turns `<br>\s*<br>` (a typed blank line, from `style/typography.ts:69`) into a paragraph break: two `<p>` with Bricks' 1.2em margin instead of one line's height — the section ends shorter than drawn.
- **R1-2:** wptexturize changes punctuation in every Rich Text: straight `'` `"` → curly, ` - `/`--` → en/em dash, `...` → …, `4x8` → 4×8. It hits every real file (Repairs "We'll…", brainstorm "Let's GRO"). The plan requires the page to look as before, so keep the designer's characters exactly (e.g. write them as numeric entities `&#39;` `&#34;` `&#45;` etc. in Rich Text's HTML so wptexturize leaves them; verify against WordPress's wptexturize source which forms it skips — `formatting.php`, read it, don't guess), and make sure wpautop can't split a typed blank line (e.g. break the `<br><br>` adjacency) while the line still shows at one line's height.

**Also:** add a minimal `parse_editor_content` stand-in to `test/browser/render.ts` for Rich Text (strip the outer `<p>`, wpautop's `<br><br>` split, wptexturize's character changes, read from the real source) so the browser receipts see what the live page shows; prove the new tests fail on the current head (R1-1: a text with a typed blank line keeps its box height ±0.5px vs main; R1-2: a text with `We'll - "x" ... 4x8` shows those exact characters after the stand-in). Keep `escapeText`/the inner HTML otherwise byte-identical to today (AC2): if entities change AC2's expected bytes, update AC2's expectation only for those characters and say so — that is a plan-level change, so list it clearly in your report.

**Gates:** `npm run check`; rich-text + nearby browser tests (Chrome per `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`; compare logs with `grep -a`); `npm run corpus` vs base. Batch HANDOFF/ledger updates into the fix commit. Stop `ready-for-next-review`.

**Memory rule:** big runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`; SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first.

**Return:** status, new HEAD SHA, per finding fixed (tests + commit) or rejected (evidence), any AC expectation you changed, gates vs base, `skill_lessons[{skill, lesson, evidence, enforce}]` (usually empty; never edit skills or memory). End with: `MAIN SESSION: check and save these skill_lessons now.`
