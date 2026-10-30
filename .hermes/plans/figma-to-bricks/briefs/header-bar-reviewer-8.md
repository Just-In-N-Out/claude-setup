# REVIEWER, round 8 (delta, report only): header-bar (FigmaToBricksV2)

You are a fresh, independent reviewer. You never saw the build or an earlier review's work. This is a **delta** round:
review only the commits since round 7's head and what they touch. Report findings only: change no source or test,
commit nothing, write only into `~/.hermes/plans/figma-to-bricks/evidence/header-bar/review-8/` (create it).

## What to review
- Worktree `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/header-bar`, branch `worktree-header-bar`, head
  `4663e65` (4 commits after `96a4d47`; source and tests as of `9842d9e`, then HANDOFF and ledger). Story base
  `dea6296`. **Your range:** `git diff 96a4d47..4663e65` and what those changes touch. Anything else outside it is P3
  at most.
- Earlier rounds' records: `~/.hermes/plans/figma-to-bricks/evidence/header-bar/review-1/` … `review-7/` (with their
  `justin.json`). Justin's answers (`~/.hermes/plans/figma-to-bricks/evidence/header-bar/justin-answers.md`): "Careful
  rules" (uncertain = base `dea6296`); "Keep AC1 as written"; **"One more fix, then accept"** (new neighbour designs of
  an already-known class become known limits and the job moves on); **R6-5 "Both are the header"** (a call bar right
  above a plain nav bar is one header: both left out with the tick on, as base); S1: the 64px line stays.
- Review 7 (from `b8d1d01` to `96a4d47`): R7-1 P2 a band of four selling points, tabs, crumbs or stats under a call bar
  was taken as a nav bar and left the paste with it (a regression against `b8d1d01`); R7-2 P2 R6-5 not done literally
  (a call bar's plain nav bar didn't leave with it); R7-3/R7-4 P3 new neighbour shapes; R7-5 P3 isBar's 200px/1152px
  lines untested. Fixer 7's answer (`c47508e`, `2e4c648`, `9842d9e`, records `4663e65`): `site-header.ts` `joins` with
  a new `clear-header.ts` `navBar`: the nav bar right under a call bar joins its run (the third section too), so the
  tick leaves both out wherever base finds a header or none; a nav bar is four+ linked words, or four+ menu items after
  a small icon, or four+ one-word items (alone or after a picture, before a button); other bands of four under a call
  bar stay in the page as at `b8d1d01`; a second call bar gets `b8d1d01`'s outcome; `oneHeader` keeps base only for a
  call bar over a logo and its ☰ (or a shop's header). Its rulings, not yet confirmed: (1) without a home icon a nav
  bar's unlinked items must be one word each, with known limits both ways (two-word items with no icon stay in the
  page; four one-word selling points or tabs, a one-word title with its tabs, or a small icon before selling points
  leave with the call bar); (2) a second call bar is not plainly one header; (3) a call bar over a logo and its ☰ keeps
  base; (4) only the bar right under the call bar joins, a third-section bar only as four linked words; (5) a nav bar
  holding a heading, a sentence, a form or a photo stays. Witness receipt: 352 witnesses, 168 identical to base, 147
  positives, 30 known limits, 7 false negatives, 0 unexpected; 46 moved against `96a4d47`, none to base. Mutation: 223
  run, 174 killed (F7M16/F7M25 are crash kills of null guards), 6 equivalent (S6, X8, R5M5br, R6M17, R7M6, F7M22), 43
  setup-fails superseded. Evidence: `~/.hermes/plans/figma-to-bricks/evidence/header-bar/fixer-7/`; ledger
  `.superpowers/sdd/2026-10-29-header-bar/progress.md`.
- Judge whether R7-1, R7-2 and R7-5 are really closed and whether fixer 7's rulings fit Justin's answers. For each
  finding say whether it is (a) a regression (a design that converted right at `96a4d47`, at `b8d1d01` or at base and
  converts wrong at head), a broken AC or a test that can't fail, or (b) a new neighbour design of an already-known
  class. Check ruling (1)'s "wrongly taken bands" in particular against `b8d1d01` and base: say which they are.
- The approved plan (read only, amended): `~/.hermes/plans/figma-to-bricks/evidence/header-bar/plan-approved.md`.
  The B-Dry paste `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/header-v1/` (sha256 `f48783e5…`) didn't change.

## Skills
Load, in order: the project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and
`references/rules-summary.md`; `references/testing-pitfalls.md` before any receipt, mutation run or browser
measurement), `engineering-best-practices`, `review-fix-cadence` (Justin's P0–P3 scale and the loop), `requesting-code-review`
(skip its "independent reviewer subagent" and auto-fix steps: you ARE the fresh reviewer), `code-review-practice`, and
`mutation-testing-discipline` for the new guards (`navBar`'s four and one-word lines, `joins`, `oneHeader`, the
third-section join) and earlier rounds' mutants downstream of them.
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
- Tests in the range: can each fail? Mutation receipts honest (223 run, 174 killed incl. 2 crash kills, 6 equivalent,
  43 setup-fails superseded)? The R6-5 pins fixer 7 changed (`test/unit/header-stacked.test.ts`): right per Justin?
- Records: do HANDOFF's rule, rulings and the known-limit class say what the code does, and do the plan's AC lines
  still say what the tests assert?

## Records and report
- Also say what, if anything, the plan's AC lines must say to match their tests now (records the main session will
  have amended in one records commit before the verifier).
- Write `review-8/review.json` exactly as review-loop.md "Records" says: `round: 8`, `scope: "delta"`, `from` = the full
  sha of `96a4d47`, `head` = the full sha of `4663e65`, findings `R8-1`… on Justin's P0–P3 scale; every P0–P2 with a
  concrete real-use `scenario` (5+ words); `repeats` (and `new_fact`) when a finding is an earlier round's defect again.
  Write it with the Write tool.
- Self-check, one plain command: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo
  /home/justin/Documents/FigmaToBricksV2/.claude/worktrees/header-bar --base <dea6296 full sha>
  ~/.hermes/plans/figma-to-bricks/evidence/header-bar`. Exit 2 means your file is wrong: fix it. Exit 0, 1 or 3 is the
  referee's verdict, not yours to act on.

## This machine
Linux/WSL. Chrome: your own wrapper in your scratch containing `exec /home/justin/.cache/chrome-for-testing/chrome-f2b
--disable-software-rasterizer "$@"` as `CHROME_PATH`, `/home/justin/.local/node-v22.23.3/bin` first on PATH. Scratch in
a fresh `header-bar-reviewer-8/` folder under
`/tmp/claude-1000/-home-justin-Documents-FigmaToBricksV2--claude-worktrees-header-bar/168d7436-38b9-492f-b297-684b9e6d4850/scratchpad`;
`TMPDIR` and built trees under `/home/justin/.cache/header-bar-reviewer-8/`. The worktree guard refuses Bash it can't
prove stays in the worktree (shell variables or loops around `node`/`git`/`sed`, heredoc then node, `git -C`, the word
git inside a grep pattern or a script's text, the word `source` anywhere, even in a path): write scripts with Write
and run them as one plain command. Waits: poll in chunks under 170 s. Another job (`after-faq-sections`) is being
audited in its own worktree: leave it alone.

## Return
`{verdict: approve|approve-with-fixes|request-changes, findings[{id, severity, file_line, claim, scenario, repeats,
new_fact, evidence}], fixes_closed[{id, closed, evidence}], ac_status[{ac, accepted, test, evidence}], referee_line,
found_else[], skill_lessons[{skill, lesson, evidence, enforce}]}`. Never edit skills or memory. End with
`MAIN SESSION: check and save these skill_lessons now.`

## Live pages (Justin, 2026-10-29)
- The site we copy: https://bdryswi.com/
- Our page as Justin pasted it: https://bdry.staging.growithgro.com/homev2/?bricks_preview=1793276386
Read both over HTTP or in your own headless Chrome as needed (add `&f2b=<random>` / `?f2b=<random>` to get past any cache). Read only: never log in, never submit a form, never change anything on either site.
