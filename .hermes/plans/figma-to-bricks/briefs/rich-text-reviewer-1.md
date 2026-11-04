# rich-text — Reviewer round 1 (Mini: full review + verifier AC work)

**Role:** fresh reviewer and AC verifier. You never saw the build. **Report only:** change no source, commit nothing; write only into the evidence folders named below.

**Worktree (read-only):** `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a4bddf14ed2da3ed7`, branch `worktree-agent-a4bddf14ed2da3ed7`, head `794386223c53a20f7bfbb86de324b59f373c9e68`. Base `31321bb48bebdc217d24e9fb65bf734b4fd65e2a`. Review `git diff 31321bb4..HEAD`. Run checks in a scratch copy (`git -C <worktree> archive <sha> | tar -x -C <scratch>`, link `node_modules`), never writing into the worktree.

**Approved plan:** `~/.hermes/plans/figma-to-bricks/evidence/rich-text/plan-approved.md` (AC1–AC8; AC8 is live, owed to Justin). Builder receipts: `~/.hermes/plans/figma-to-bricks/evidence/rich-text/builder/` — don't trust them; re-run.

**What it does:** every non-heading text with no element link of its own becomes Bricks' Rich Text (`text`) with its HTML wrapped in one `<p>`; a text wholly one link (`ir.link`) stays Basic Text with Link to; headings and Buttons unchanged; the renderer gets Bricks' real `p` margins (`:where(p){margin-block:0 1.2em}`, last-of-type 0). Bricks facts from the plan: Rich Text has no Link to/tag control. Judge especially: does the `<p>` wrapper change real layout anywhere (a text whose margin collapses, inline/flex contexts, line-height/`::first-line`, custom CSS or rules that target the words element's text — `text-balance`, `text-pretty`, typography classes, phone-number spans, marquees/loop copies, hover copies, flip cards, form labels, list rows and their script, FAQ/accordion titles and answers, slider copies, CSS selectors like `.brxe-text-basic` left anywhere in src or emitted CSS/scripts); does anything in `src/` (scripts in Code elements, lists' search script, card arrows, header spacer) look up `.brxe-text-basic` or the text's first child; does `payloadProblems` or a Bricks key the plugin writes on text elements not exist on Rich Text (e.g. `tag`, `link`, `_cssCustom` paths). A parallel job (element-link) will switch the rule to `elementLink(ir)`; that's expected, not a finding.

Read the worktree's `CLAUDE.md` for the standing rules.

**Skills:** `requesting-code-review`, `code-review-practice`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` (records) and `references/ac-verification.md` (verifier AC work, `ac.json`).

**Severity (project rule, "built fast"):** P0–P2 only with a concrete 5+ word real-use scenario (a real design, normal use); edge cases P3.

**Do:**
1. Full review (round 1, `scope` full, `from` 31321bb48bebdc217d24e9fb65bf734b4fd65e2a, `head` 794386223c53a20f7bfbb86de324b59f373c9e68). Write `~/.hermes/plans/figma-to-bricks/evidence/rich-text/review-1/review.json`.
2. Verifier AC work: `npm run check` and the browser suite on base and head compared by test name (CHROME_PATH per `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`); every non-live AC on head and base. Write `~/.hermes/plans/figma-to-bricks/evidence/rich-text/verifier/ac.json`; set `ac_status`.
3. Self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <worktree> --base 31321bb4 ~/.hermes/plans/figma-to-bricks/evidence/rich-text` (exit 2 = fix your file).

**Memory rule:** big runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`; SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first. Other agents use Chrome too: wait rather than kill others' processes.

**Return:** `verdict`, findings (id, severity, file:line, claim, scenario), `ac_status`, per-AC result, `skill_lessons[{skill, lesson, evidence, enforce}]` (usually empty; never edit skills or memory). End with: `MAIN SESSION: check and save these skill_lessons now.`
