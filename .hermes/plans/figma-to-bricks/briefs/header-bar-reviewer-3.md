# REVIEWER, round 3 (delta, report only): header-bar (FigmaToBricksV2)

You are a fresh, independent reviewer. You never saw the build or an earlier review's work. This is a **delta** round:
review only the commits since round 2's head and what they touch. Report findings only: change no source or test,
commit nothing, write only into `~/.hermes/plans/figma-to-bricks/evidence/header-bar/review-3/` (create it).

## What to review
- Worktree `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/header-bar`, branch `worktree-header-bar`, head
  `11dfd5e` (records `5ad18c1`, plan amendment `11dfd5e`). Story base `dea6296`. **Your range:**
  `git diff e630f4d..11dfd5e` (fixer 2's commits `8973345` … `44d87b3`, its records `5ad18c1`, the plan amendment) and
  what those changes touch. Anything else you notice outside that range is P3 at most.
- Earlier rounds' records: `~/.hermes/plans/figma-to-bricks/evidence/header-bar/review-1/review.json` and
  `review-2/review.json` (with `review-2/justin.json`: Justin chose "Keep going on both"). Fixer 2's answers to round
  2: R2-1 and R2-2 fixed in `c656abd`/`449393c` (a strip hands the header over only when it shows no menu, is thinner
  than the bar under it, and that bar is a logo bar that shows its menu); R2-3 fixed in `acaafd8` (a typed logo counts
  only with a contact line and a possible menu icon at the end, never an arrow); R2-4 a follow-up in HANDOFF (base the
  same); R2-5 partly fixed in `ad8a494` (a new `normalise/menu-shape.ts` reads an icon's drawing; a lone end icon with
  no drawing to read is still named); R2-6 fixed in `44d87b3` (a unit test on `_widthMax`); plus `15b8c21` (a call band
  with a big illustration comes out as base) and `449393c` (a short word is never a header's icon). Its evidence:
  `~/.hermes/plans/figma-to-bricks/evidence/header-bar/fixer-2/`; its ledger entries in
  `.superpowers/sdd/2026-10-29-header-bar/progress.md`. Judge whether each fix really closes its finding, and judge
  any P0–P2 the fixer rejected (none were; R2-4 and R2-5 were P3).
- The approved plan (read only, amended): `~/.hermes/plans/figma-to-bricks/evidence/header-bar/plan-approved.md`
  (AC14 deferred to the header-menu job by Justin; H1 = A in AC4). The B-Dry paste
  `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/header-v1/` didn't change in this range.

## Skills
Load, in order: the project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and
`references/rules-summary.md`; `references/testing-pitfalls.md` before any receipt, mutation run or browser
measurement), `engineering-best-practices`, `review-fix-cadence` (Justin's P0–P3 scale and the loop), `requesting-code-review`
(skip its "independent reviewer subagent" and auto-fix steps: you ARE the fresh reviewer), `code-review-practice`, and
`mutation-testing-discipline` for the new guards (`handsOver`, `showsMenu`, `menuLike`, `menu-shape.ts`, `icon()`).
Then read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` ("The reviewer's duties",
"Records").

## What to check in the range
- Each new rule's general behaviour: header bars with small marks, badges, typed logos, contact strips, promo, trust
  and title bands, shop headers, menus of words, icons with and without drawings, bars drawn without auto layout, 1280
  to 1920-wide designs, ticks off/header/footer/both. Does the fix break anything round 1 or 2 fixed, or anything base
  did right? Probe the thresholds and look-backs on both sides (the line between "thinner" and not, 3 links vs 2,
  `menu-shape.ts`'s bar count and thinness).
- The architecture rules (CLAUDE.md "Architecture rules"): `normalise/menu-shape.ts` is a normalise-stage reader:
  check that no stage edits an earlier stage's output, typed CSS until emit, deterministic ids, files under ~300 lines,
  Figma-sandbox-safe code in src/core.
- Tests in the range: can each fail? Mutation receipts honest?
- The plan amendment and records commit: do the amended AC lines say what the tests assert?

## Records and report
- Write `review-3/review.json` exactly as review-loop.md "Records" says: `round: 3`, `scope: "delta"`, `from` = the full
  sha of `e630f4d`, `head` = the full sha of `11dfd5e`, findings `R3-1`… on Justin's P0–P3 scale; every P0–P2 with a
  concrete real-use `scenario` (5+ words); `repeats` (and `new_fact`) when a finding is an earlier round's defect again.
  Write it with the Write tool.
- Self-check, one plain command: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo
  /home/justin/Documents/FigmaToBricksV2/.claude/worktrees/header-bar --base <dea6296 full sha>
  ~/.hermes/plans/figma-to-bricks/evidence/header-bar`. Exit 2 means your file is wrong: fix it. Exit 0, 1 or 3 is the
  referee's verdict, not yours to act on.

## This machine
Linux/WSL. Chrome: your own wrapper in your scratch containing `exec /home/justin/.cache/chrome-for-testing/chrome-f2b
--disable-software-rasterizer "$@"` as `CHROME_PATH`, `/home/justin/.local/node-v22.23.3/bin` first on PATH. Scratch in
a fresh `header-bar-reviewer-3/` folder under
`/tmp/claude-1000/-home-justin-Documents-FigmaToBricksV2--claude-worktrees-header-bar/168d7436-38b9-492f-b297-684b9e6d4850/scratchpad`;
`TMPDIR` and built trees under `/home/justin/.cache/header-bar-reviewer-3/`. The worktree guard refuses Bash it can't
prove stays in the worktree (shell variables or loops around `node`/`git`/`sed`, heredoc then node, `git -C`, the word
git inside a grep pattern or a script's text, the word `source` anywhere, even in a path): write scripts with Write
and run them as one plain command. Waits: poll in chunks under 170 s. Another job (`after-faq-sections`) is under
review in its own worktree: leave it alone.

## Return
`{verdict: approve|approve-with-fixes|request-changes, findings[{id, severity, file_line, claim, scenario, repeats,
new_fact, evidence}], fixes_closed[{id, closed, evidence}], ac_status[{ac, accepted, test, evidence}], referee_line,
found_else[], skill_lessons[{skill, lesson, evidence, enforce}]}`. Never edit skills or memory. End with
`MAIN SESSION: check and save these skill_lessons now.`
