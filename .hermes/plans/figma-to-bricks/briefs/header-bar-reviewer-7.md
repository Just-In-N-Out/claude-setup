# REVIEWER, round 7 (delta, report only): header-bar (FigmaToBricksV2)

You are a fresh, independent reviewer. You never saw the build or an earlier review's work. This is a **delta** round:
review only the commits since round 2's head and what they touch. Report findings only: change no source or test,
commit nothing, write only into `~/.hermes/plans/figma-to-bricks/evidence/header-bar/review-7/` (create it).

## What to review
- Worktree `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/header-bar`, branch `worktree-header-bar`, head
  `96a4d47` (7 commits after `b8d1d01`; source and tests as of `8530d08`, then docs and ledger). Story base `dea6296`.
  **Your range:** `git diff b8d1d01..96a4d47` and what those changes touch. Anything else outside it is P3 at most.
- Earlier rounds' records: `~/.hermes/plans/figma-to-bricks/evidence/header-bar/review-1/` … `review-6/` (with their
  `justin.json`). Justin's answers (`~/.hermes/plans/figma-to-bricks/evidence/header-bar/justin-answers.md`): "Careful
  rules" (uncertain = base `dea6296`); "Keep AC1 as written"; **"One more fix, then accept"** (`review-6/justin.json`:
  this round's fix closes R6-1; if this review still finds new neighbour designs, they become known limits and the job
  moves on); **R6-5 "Both are the header"** (a call bar right above a plain nav bar is one header: both left out with
  the tick on, as base); S1: the 64px line stays. Review 6: R6-1 P2 an announcement strip on top hid the real header
  from `clearOwn`; R6-2 to R6-5 P3. Fixer 6's answer: `barAfter` (`site-header.ts`) with `isBar` (`bars.ts`) judges the
  header against the bar right after its run (also in `stands`' grouped-bar guard); `holdsMenu`/`oneHeader` make a call
  bar over a nav bar convert as base; R6C2 not applied (it re-opened R5-1 for a taller trust band) and its class
  recorded as false negatives; R6M17 called equivalent with an instrumented log. Its own rulings, not yet confirmed:
  a nav bar is any bar with a menu of four; **a call bar right over another header's bar (a logo and its ☰, or a
  second call bar) is one header too and converts as base**; a three-word nav bar is no menu (known limit). Witness
  receipt: 295 witnesses, 170 identical to base, 99 positives, 19 known limits, 7 false negatives, 0 unexpected.
  Evidence: `~/.hermes/plans/figma-to-bricks/evidence/header-bar/fixer-6/`; ledger
  `.superpowers/sdd/2026-10-29-header-bar/progress.md`. Judge whether R6-1 and R6-5 are really closed, and judge fixer
  6's second ruling against Justin's answers. For each finding you raise say whether it is (a) a regression or a broken
  AC, or (b) a new neighbour design of an already-known class (Justin will have those recorded as known limits).
- The approved plan (read only, amended): `~/.hermes/plans/figma-to-bricks/evidence/header-bar/plan-approved.md`.
  The B-Dry paste `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/header-v1/` (sha256 `f48783e5…`) didn't change.

## Skills
Load, in order: the project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and
`references/rules-summary.md`; `references/testing-pitfalls.md` before any receipt, mutation run or browser
measurement), `engineering-best-practices`, `review-fix-cadence` (Justin's P0–P3 scale and the loop), `requesting-code-review`
(skip its "independent reviewer subagent" and auto-fix steps: you ARE the fresh reviewer), `code-review-practice`, and
`mutation-testing-discipline` for the new guards (`barAfter`/`isBar`'s 200px and 80% lines, `holdsMenu`'s four,
`oneHeader`, the `stands` guard) and earlier rounds' mutants downstream of them.
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
- Tests in the range: can each fail? Mutation receipts honest (178 run, 144 killed, 5 equivalent incl. R6M17 and F6M8r;
  29 setup-fails superseded)?
- Records: do HANDOFF's rule, rulings and the known-limit class say what the code does, and do the plan's AC lines
  still say what the tests assert?

## Records and report
- Also say what, if anything, the plan's AC lines must say to match their tests now (records the main session will
  have amended in one records commit before the verifier).
- Write `review-7/review.json` exactly as review-loop.md "Records" says: `round: 7`, `scope: "delta"`, `from` = the full
  sha of `b8d1d01`, `head` = the full sha of `96a4d47`, findings `R7-1`… on Justin's P0–P3 scale; every P0–P2 with a
  concrete real-use `scenario` (5+ words); `repeats` (and `new_fact`) when a finding is an earlier round's defect again.
  Write it with the Write tool.
- Self-check, one plain command: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo
  /home/justin/Documents/FigmaToBricksV2/.claude/worktrees/header-bar --base <dea6296 full sha>
  ~/.hermes/plans/figma-to-bricks/evidence/header-bar`. Exit 2 means your file is wrong: fix it. Exit 0, 1 or 3 is the
  referee's verdict, not yours to act on.

## This machine
Linux/WSL. Chrome: your own wrapper in your scratch containing `exec /home/justin/.cache/chrome-for-testing/chrome-f2b
--disable-software-rasterizer "$@"` as `CHROME_PATH`, `/home/justin/.local/node-v22.23.3/bin` first on PATH. Scratch in
a fresh `header-bar-reviewer-7/` folder under
`/tmp/claude-1000/-home-justin-Documents-FigmaToBricksV2--claude-worktrees-header-bar/168d7436-38b9-492f-b297-684b9e6d4850/scratchpad`;
`TMPDIR` and built trees under `/home/justin/.cache/header-bar-reviewer-7/`. The worktree guard refuses Bash it can't
prove stays in the worktree (shell variables or loops around `node`/`git`/`sed`, heredoc then node, `git -C`, the word
git inside a grep pattern or a script's text, the word `source` anywhere, even in a path): write scripts with Write
and run them as one plain command. Waits: poll in chunks under 170 s. Another job (`after-faq-sections`) is under
review in its own worktree: leave it alone.

## Return
`{verdict: approve|approve-with-fixes|request-changes, findings[{id, severity, file_line, claim, scenario, repeats,
new_fact, evidence}], fixes_closed[{id, closed, evidence}], ac_status[{ac, accepted, test, evidence}], referee_line,
found_else[], skill_lessons[{skill, lesson, evidence, enforce}]}`. Never edit skills or memory. End with
`MAIN SESSION: check and save these skill_lessons now.`

## Live pages (Justin, 2026-10-29)
- The site we copy: https://bdryswi.com/
- Our page as Justin pasted it: https://bdry.staging.growithgro.com/homev2/?bricks_preview=1793276386
Read both over HTTP or in your own headless Chrome as needed (add `&f2b=<random>` / `?f2b=<random>` to get past any cache). Read only: never log in, never submit a form, never change anything on either site.
