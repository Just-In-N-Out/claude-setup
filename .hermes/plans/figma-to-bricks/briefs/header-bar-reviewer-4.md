# REVIEWER, round 4 (delta, report only): header-bar (FigmaToBricksV2)

You are a fresh, independent reviewer. You never saw the build or an earlier review's work. This is a **delta** round:
review only the commits since round 2's head and what they touch. Report findings only: change no source or test,
commit nothing, write only into `~/.hermes/plans/figma-to-bricks/evidence/header-bar/review-4/` (create it).

## What to review
- Worktree `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/header-bar`, branch `worktree-header-bar`, head
  `cca0aba` (fix commits `1b2d9fb`, `6c05b3c`; records `cca0aba`). Story base `dea6296`. **Your range:**
  `git diff 11dfd5e..cca0aba` and what those changes touch. Anything else you notice outside that range is P3 at most.
- Earlier rounds' records: `~/.hermes/plans/figma-to-bricks/evidence/header-bar/review-1/`, `review-2/` (with
  `justin.json`: "Keep going on both") and `review-3/` (with `justin.json`: Justin chose **"Careful rules"**: the
  plugin's new header rules apply only where a bar is clearly a header; everything uncertain converts exactly as base
  `dea6296`). Fixer 3's answer: `site-header.ts` now reads the bars twice, base's reading kept byte for byte and the
  story's wider reading, and keeps the wider one only where it agrees with base or finds a clear header (new
  `src/core/understand/clear-header.ts`; the rule is one paragraph in HANDOFF); the logo link, the menu note and the
  wide Container go only with a clear header; `menuShape` reads exactly three bars, with a 40% rule for bars on a
  button's fill, an SVG size cap and a memo. Its rulings (not yet confirmed) are in its report's evidence. Its witness
  probe classified 89 witnesses: 49 byte-identical to base, 39 clear headers, 1 AC1 case, 0 unexpected
  (`fixer-3/classify.txt`). Evidence: `~/.hermes/plans/figma-to-bricks/evidence/header-bar/fixer-3/`; ledger entries in
  `.superpowers/sdd/2026-10-29-header-bar/progress.md`. Judge whether R3-1 … R3-7 are really closed, and whether the
  careful rule really is "base where uncertain": build your own witnesses beyond the 89 (three trees: base, `11dfd5e`,
  head).
- The approved plan (read only, amended): `~/.hermes/plans/figma-to-bricks/evidence/header-bar/plan-approved.md`
  (AC14 deferred to the header-menu job by Justin; H1 = A in AC4). The B-Dry paste
  `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/header-v1/` didn't change in this range.

## Skills
Load, in order: the project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and
`references/rules-summary.md`; `references/testing-pitfalls.md` before any receipt, mutation run or browser
measurement), `engineering-best-practices`, `review-fix-cadence` (Justin's P0–P3 scale and the loop), `requesting-code-review`
(skip its "independent reviewer subagent" and auto-fix steps: you ARE the fresh reviewer), `code-review-practice`, and
`mutation-testing-discipline` for the new guards (`clear-header.ts`'s predicate, the two-reading agreement, the
40% backdrop rule, `menuShape`'s three bars, cap and memo).
Then read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` ("The reviewer's duties",
"Records").

## What to check in the range
- "Uncertain = base": for every shape that isn't clearly a header (strips, bands under a header, badges first,
  titles with icons or words, headers without a readable ☰, icons on backdrops, bars drawn without auto layout, drawn
  phone designs, 1280–1920-wide designs, ticks off/header/footer/both), head must equal base byte for byte (payload and
  notes). For clear headers, the plan's ACs must hold. Probe each threshold on both sides (the 40% backdrop rule, three
  bars vs two or four, the 64px logo line, 3 links vs 2, "thinner").
- The architecture rules (CLAUDE.md "Architecture rules"): no stage edits an earlier stage's output, typed CSS until
  emit, deterministic ids, files under ~300 lines, Figma-sandbox-safe code in src/core.
- Tests in the range: can each fail? Mutation receipts honest (43 run, 42 killed, S6 called equivalent)?
- Records: do HANDOFF's careful-rule paragraph and the plan's AC lines still say what the tests assert (fixer 3 says
  no AC line needed changing; AC7's fixture set now has 5 that differ instead of 6)?

## Records and report
- Write `review-4/review.json` exactly as review-loop.md "Records" says: `round: 4`, `scope: "delta"`, `from` = the full
  sha of `11dfd5e`, `head` = the full sha of `cca0aba`, findings `R4-1`… on Justin's P0–P3 scale; every P0–P2 with a
  concrete real-use `scenario` (5+ words); `repeats` (and `new_fact`) when a finding is an earlier round's defect again.
  Write it with the Write tool.
- Self-check, one plain command: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo
  /home/justin/Documents/FigmaToBricksV2/.claude/worktrees/header-bar --base <dea6296 full sha>
  ~/.hermes/plans/figma-to-bricks/evidence/header-bar`. Exit 2 means your file is wrong: fix it. Exit 0, 1 or 3 is the
  referee's verdict, not yours to act on.

## This machine
Linux/WSL. Chrome: your own wrapper in your scratch containing `exec /home/justin/.cache/chrome-for-testing/chrome-f2b
--disable-software-rasterizer "$@"` as `CHROME_PATH`, `/home/justin/.local/node-v22.23.3/bin` first on PATH. Scratch in
a fresh `header-bar-reviewer-4/` folder under
`/tmp/claude-1000/-home-justin-Documents-FigmaToBricksV2--claude-worktrees-header-bar/168d7436-38b9-492f-b297-684b9e6d4850/scratchpad`;
`TMPDIR` and built trees under `/home/justin/.cache/header-bar-reviewer-4/`. The worktree guard refuses Bash it can't
prove stays in the worktree (shell variables or loops around `node`/`git`/`sed`, heredoc then node, `git -C`, the word
git inside a grep pattern or a script's text, the word `source` anywhere, even in a path): write scripts with Write
and run them as one plain command. Waits: poll in chunks under 170 s. Another job (`after-faq-sections`) is under
review in its own worktree: leave it alone.

## Return
`{verdict: approve|approve-with-fixes|request-changes, findings[{id, severity, file_line, claim, scenario, repeats,
new_fact, evidence}], fixes_closed[{id, closed, evidence}], ac_status[{ac, accepted, test, evidence}], referee_line,
found_else[], skill_lessons[{skill, lesson, evidence, enforce}]}`. Never edit skills or memory. End with
`MAIN SESSION: check and save these skill_lessons now.`
