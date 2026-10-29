# REVIEWER, round 6 (delta, report only): header-bar (FigmaToBricksV2)

You are a fresh, independent reviewer. You never saw the build or an earlier review's work. This is a **delta** round:
review only the commits since round 2's head and what they touch. Report findings only: change no source or test,
commit nothing, write only into `~/.hermes/plans/figma-to-bricks/evidence/header-bar/review-6/` (create it).

## What to review
- Worktree `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/header-bar`, branch `worktree-header-bar`, head
  `b8d1d01` (fixes `4413d5a`, `631628f`, `4bbbfb7`; records `b8d1d01`). Story base `dea6296`. **Your range:**
  `git diff e195c65..b8d1d01` and what those changes touch. Anything else outside that range is P3 at most.
- Earlier rounds' records: `~/.hermes/plans/figma-to-bricks/evidence/header-bar/review-1/` … `review-5/` (with
  `review-2/justin.json` "Keep going on both", `review-3/justin.json` **"Careful rules"**: the new header rules apply
  only where a bar is clearly a header; everything uncertain converts exactly as base `dea6296`). Justin's answer in
  `~/.hermes/plans/figma-to-bricks/evidence/header-bar/justin-answers.md`: **"Keep AC1 as written"** (a logo or picture
  wider than an icon followed by a group of two short notes with no link of its own stays a header; anything beyond
  that exact shape converts as base). Review 5: R5-1 P2 a strip read as clear by its menu over a clear header took the
  real logo's link; R5-2 to R5-4 P3. Fixer 5's answer: `clear-header.ts` `clearOwn` (a bar read by its menu is clear
  only while no clear header bar sits in the run under it or right after it; call bars and a logo with its ☰ stay
  clear); `menuIn` finds a menu row inside a group before counting links; a menu's links are words (`links(n,
  menuItem)`); AC1's notes are fewer than eight words; a bar linked as a whole converts as base; R5-2's lone-band class
  recorded as a known limit with an open question for Justin (the 64px size line). Its witness receipt: 242 witnesses,
  99 expected ids written and hashed before the run, 143 identical to base, 80 positives, 17 known limits, 2 false
  negatives as base, 0 unexpected. Its rulings (not yet confirmed) are in HANDOFF; its found_else names a call bar over
  a clear menu header (F5-A5: ticked, only the call bar leaves). Evidence:
  `~/.hermes/plans/figma-to-bricks/evidence/header-bar/fixer-5/`; ledger `.superpowers/sdd/2026-10-29-header-bar/
  progress.md`. Judge whether R5-1, R5-3, R5-4 are really closed and whether the rule really is "base where uncertain":
  build your own witnesses (three trees: base, `e195c65`, head), listing your expected positives with outcomes first.
  Judge F5-A5 too: is a call bar over a clear menu header a P2 under the careful rule?
- The approved plan (read only, amended): `~/.hermes/plans/figma-to-bricks/evidence/header-bar/plan-approved.md`.
  The B-Dry paste `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/header-v1/` (sha256 `f48783e5…`) didn't change.

## Skills
Load, in order: the project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and
`references/rules-summary.md`; `references/testing-pitfalls.md` before any receipt, mutation run or browser
measurement), `engineering-best-practices`, `review-fix-cadence` (Justin's P0–P3 scale and the loop), `requesting-code-review`
(skip its "independent reviewer subagent" and auto-fix steps: you ARE the fresh reviewer), `code-review-practice`, and
`mutation-testing-discipline` for the new guards (`clearOwn`, `menuIn`'s group search, the words-only menu links,
the eight-word note line, the whole-bar link test via `src.clicks`) and earlier rounds' mutants downstream of them.
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
- Tests in the range: can each fail? Mutation receipts honest (125 run, 103 killed, 3 equivalent: S6, X8, R5M5b; 19
  not applicable and superseded by killed re-ports)?
- Records: do HANDOFF's rule, rulings and the known-limit class say what the code does, and do the plan's AC lines
  still say what the tests assert?

## Records and report
- Write `review-6/review.json` exactly as review-loop.md "Records" says: `round: 6`, `scope: "delta"`, `from` = the full
  sha of `e195c65`, `head` = the full sha of `b8d1d01`, findings `R6-1`… on Justin's P0–P3 scale; every P0–P2 with a
  concrete real-use `scenario` (5+ words); `repeats` (and `new_fact`) when a finding is an earlier round's defect again.
  Write it with the Write tool.
- Self-check, one plain command: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo
  /home/justin/Documents/FigmaToBricksV2/.claude/worktrees/header-bar --base <dea6296 full sha>
  ~/.hermes/plans/figma-to-bricks/evidence/header-bar`. Exit 2 means your file is wrong: fix it. Exit 0, 1 or 3 is the
  referee's verdict, not yours to act on.

## This machine
Linux/WSL. Chrome: your own wrapper in your scratch containing `exec /home/justin/.cache/chrome-for-testing/chrome-f2b
--disable-software-rasterizer "$@"` as `CHROME_PATH`, `/home/justin/.local/node-v22.23.3/bin` first on PATH. Scratch in
a fresh `header-bar-reviewer-6/` folder under
`/tmp/claude-1000/-home-justin-Documents-FigmaToBricksV2--claude-worktrees-header-bar/168d7436-38b9-492f-b297-684b9e6d4850/scratchpad`;
`TMPDIR` and built trees under `/home/justin/.cache/header-bar-reviewer-6/`. The worktree guard refuses Bash it can't
prove stays in the worktree (shell variables or loops around `node`/`git`/`sed`, heredoc then node, `git -C`, the word
git inside a grep pattern or a script's text, the word `source` anywhere, even in a path): write scripts with Write
and run them as one plain command. Waits: poll in chunks under 170 s. Another job (`after-faq-sections`) is under
review in its own worktree: leave it alone.

## Return
`{verdict: approve|approve-with-fixes|request-changes, findings[{id, severity, file_line, claim, scenario, repeats,
new_fact, evidence}], fixes_closed[{id, closed, evidence}], ac_status[{ac, accepted, test, evidence}], referee_line,
found_else[], skill_lessons[{skill, lesson, evidence, enforce}]}`. Never edit skills or memory. End with
`MAIN SESSION: check and save these skill_lessons now.`
