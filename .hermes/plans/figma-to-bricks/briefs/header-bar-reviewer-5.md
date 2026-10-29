# REVIEWER, round 5 (delta, report only): header-bar (FigmaToBricksV2)

You are a fresh, independent reviewer. You never saw the build or an earlier review's work. This is a **delta** round:
review only the commits since round 2's head and what they touch. Report findings only: change no source or test,
commit nothing, write only into `~/.hermes/plans/figma-to-bricks/evidence/header-bar/review-5/` (create it).

## What to review
- Worktree `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/header-bar`, branch `worktree-header-bar`, head
  `e195c65` (fix `62ac9fe`, records `e195c65`). Story base `dea6296`. **Your range:** `git diff cca0aba..e195c65` and
  what those changes touch. Anything else you notice outside that range is P3 at most.
- Earlier rounds' records: `~/.hermes/plans/figma-to-bricks/evidence/header-bar/review-1/` … `review-4/` (with
  `review-2/justin.json` "Keep going on both" and `review-3/justin.json` **"Careful rules"**: the new header rules apply
  only where a bar is clearly a header; everything uncertain converts exactly as base `dea6296`). Justin's later answer
  (`~/.hermes/plans/figma-to-bricks/evidence/header-bar/justin-answers.md`): **"Keep AC1 as written"**: a logo (or a
  picture wider than an icon) followed by a group of two short notes with no link of its own stays the site's header;
  anything beyond that exact shape converts as base. Review 4: R4-1 P2 the clear test reused base's menu reading, so a
  badge or title before 3 short items or links counted as clear; R4-2 P2 `groupedBar` went beyond AC1's shape; R4-3 to
  R4-5 P3. Fixer 4's answer: a clear menu header needs a drawn logo first, a menu of 4+ items or links and a call to
  action beside it; the `r.last > r.own` hand-over (`menuBelow`) uses the same test; `groupedBar` is exactly AC1's shape;
  three unreachable checks removed; R4-5 left as a known limit (v1 files). Its witness receipt: 166 witnesses, 59
  expected positives written before the run (`fixer-4/expected-positives.txt`, hash-checked), 107 identical to base,
  0 UNEXPECTED. Its rulings (not yet confirmed) are in HANDOFF; its found_else names a linked frame holding one button's
  words and a ☰ passing as a menu item in `bar-parts.ts` `action()`. Evidence:
  `~/.hermes/plans/figma-to-bricks/evidence/header-bar/fixer-4/`; ledger `.superpowers/sdd/2026-10-29-header-bar/
  progress.md`. Judge whether R4-1 … R4-5 are really closed and whether the rule really is "base where uncertain":
  build your own witnesses beyond the 166 (three trees: base, `cca0aba`, head), listing your expected positives first.
- The approved plan (read only, amended): `~/.hermes/plans/figma-to-bricks/evidence/header-bar/plan-approved.md`.
  The B-Dry paste `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/header-v1/` (sha256 `f48783e5…`) didn't change.

## Skills
Load, in order: the project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and
`references/rules-summary.md`; `references/testing-pitfalls.md` before any receipt, mutation run or browser
measurement), `engineering-best-practices`, `review-fix-cadence` (Justin's P0–P3 scale and the loop), `requesting-code-review`
(skip its "independent reviewer subagent" and auto-fix steps: you ARE the fresh reviewer), `code-review-practice`, and
`mutation-testing-discipline` for the narrowed guards (`showsMenu`, `menuBelow`, `MENU = 4`, the call-to-action
beside the menu, `groupedBar`'s exact shape) and the earlier rounds' mutants downstream of them.
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
- Tests in the range: can each fail? Mutation receipts honest (30 run, 28 killed, X8 and N15 called equivalent; fixer
  3's 10 SETUP-FAIL mutants replaced by N1–N21)?
- Records: do HANDOFF's rule and rulings and the plan's AC lines still say what the tests assert (fixer 4 says no AC
  line needed changing)? Is the "known limit" for a badge before 4 short words and a button acceptable under "careful
  rules", or a P2?

## Records and report
- Write `review-5/review.json` exactly as review-loop.md "Records" says: `round: 5`, `scope: "delta"`, `from` = the full
  sha of `cca0aba`, `head` = the full sha of `e195c65`, findings `R5-1`… on Justin's P0–P3 scale; every P0–P2 with a
  concrete real-use `scenario` (5+ words); `repeats` (and `new_fact`) when a finding is an earlier round's defect again.
  Write it with the Write tool.
- Self-check, one plain command: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo
  /home/justin/Documents/FigmaToBricksV2/.claude/worktrees/header-bar --base <dea6296 full sha>
  ~/.hermes/plans/figma-to-bricks/evidence/header-bar`. Exit 2 means your file is wrong: fix it. Exit 0, 1 or 3 is the
  referee's verdict, not yours to act on.

## This machine
Linux/WSL. Chrome: your own wrapper in your scratch containing `exec /home/justin/.cache/chrome-for-testing/chrome-f2b
--disable-software-rasterizer "$@"` as `CHROME_PATH`, `/home/justin/.local/node-v22.23.3/bin` first on PATH. Scratch in
a fresh `header-bar-reviewer-5/` folder under
`/tmp/claude-1000/-home-justin-Documents-FigmaToBricksV2--claude-worktrees-header-bar/168d7436-38b9-492f-b297-684b9e6d4850/scratchpad`;
`TMPDIR` and built trees under `/home/justin/.cache/header-bar-reviewer-5/`. The worktree guard refuses Bash it can't
prove stays in the worktree (shell variables or loops around `node`/`git`/`sed`, heredoc then node, `git -C`, the word
git inside a grep pattern or a script's text, the word `source` anywhere, even in a path): write scripts with Write
and run them as one plain command. Waits: poll in chunks under 170 s. Another job (`after-faq-sections`) is under
review in its own worktree: leave it alone.

## Return
`{verdict: approve|approve-with-fixes|request-changes, findings[{id, severity, file_line, claim, scenario, repeats,
new_fact, evidence}], fixes_closed[{id, closed, evidence}], ac_status[{ac, accepted, test, evidence}], referee_line,
found_else[], skill_lessons[{skill, lesson, evidence, enforce}]}`. Never edit skills or memory. End with
`MAIN SESSION: check and save these skill_lessons now.`
