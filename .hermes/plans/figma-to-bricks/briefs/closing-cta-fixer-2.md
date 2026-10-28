# FIXER 2: closing-cta → section rhythm (FigmaToBricksV2)

You are the fixer for reviewer 2's findings. Verify each finding yourself first, fix the valid ones test first, and push
back with evidence on any you find wrong. Don't re-plan.

## Where
- Worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/closing-cta`, branch `worktree-closing-cta`,
  head `8259f2e`, base `main` (`5e2f98b`). Work only there; never edit the main folder.
- Approved plan (read only, amended 2026-10-28; its "Amendments" list says what changed):
  `~/.hermes/plans/figma-to-bricks/evidence/closing-cta/plan-approved.md` (AC1–AC12, AC12 Justin's live check).
  Don't edit the plan; if a fix needs an AC's text changed, stop and say so in `open_questions`.
- Reviewer 2's report: `~/.hermes/plans/figma-to-bricks/evidence/closing-cta/reviewer-2/review.json`, its probes
  (`chrome-probe-hills.txt`, `chrome-probe-cards.txt`, `payload-probe-cards.txt`, `chrome-probe-dividers.txt`,
  `mutants-r2.txt`) and scripts in `scripts/` (`r2-probe.test.ts`). Start your failing tests from its probe fixtures.
- Fixer 1's report and evidence: `../fixer-1/`. Ledger `.superpowers/sdd/2026-10-28-closing-cta/progress.md` (add a
  "Review 2 fixes" section). Your evidence: `~/.hermes/plans/figma-to-bricks/evidence/closing-cta/fixer-2/`.
- Scratch: your own `fixer-2/` folder under the session scratchpad
  (`/tmp/claude-1000/-home-justin-Documents-FigmaToBricksV2--claude-worktrees-closing-cta/ecf5994f-8276-4f04-b9c6-a00ab4b226ac/scratchpad`);
  never re-extract into another role's tree. Copy every scratch script into `<your evidence>/scripts/` as soon as you
  write it: a session restart empties the scratchpad and kills background runs.

## Findings (reviewer 2, verdict request-changes; AC4, AC6, AC7 not accepted)
- **R2-F1 (medium):** J2's landing check (`rhythm-buttons.ts` `lands`, via `rhythm.ts` `sinks`) runs only at the design
  width. Hills 80px tall under buttons drawn 120 above the bottom (`{inset:false, wave:80, own:[0,120], gapBelow:0}`):
  S clears them at 1440, but at 1100/1024/992 they land 6 / 10.9 / 13px on the buttons (the padding has slid to S's
  tablet step while compose shrinks the drawing only from 991 down); base keeps 120 → 84 and never lands. Also judge
  a bottom-pinned layer at 992 against the tablet step of the new value (`spaceStep` is pure) and keep today's spacing
  where it would land there. Add the case to J2's unit list and to the AC7 hills Chrome test at 1100/1024/992.
- **R2-F2 (medium):** an unpainted inset card holding placed layers keeps its padding (`carried().held`), but the
  arithmetic ignores it at the top and steps it on the box scale at the bottom: `{own:[40,40], wave:32}` (the plan's
  "padded card holding hills") shows Work→closing 136 / 120.5 / 107 / 80 where S is 96 / 80.5 / 67 / 48, and under
  its buttons 96 / 87.4 / 80 / 64. Count the held padding as the neighbour's kept space on both edges, stepped as it
  actually shows (e.g. a `Beside` with `keeps = held`), or hold only the edge its layers are pinned to, without
  moving the card's box under its layers. Add Chrome checks with the rhythm measure on.
- **R2-F3 (medium):** `rhythm.ts:27` `lineOnly`: a divider drawn as a 1px frame with a fill, or a 1px rectangle with a
  gradient, isn't "line only", so it stays as a painted section with S on both sides: 2S + 1 between the words, and the
  line shows (base the same; Q1 A and Q3 A fail for this class). Treat any full-width section at most 2px tall with no
  flowing content as line only; add these dividers to AC4. Probe the blast radius on all five real files and every
  zero-argument fixture: list any real page that changes, before → after at 1440/768/390.
- **R2-F4 (low):** mutant F2-card-zero isn't equivalent: `inCard > 0` also means "the card paints nothing and has no
  outline". Add a painted and an outlined inset card with `own:[40,40]` to AC8 (they keep their 40, 39 inside a 1px
  outline, per Q4 A), show it kills F2-card-zero, R2-painted and R2-outlined, relabel fixer 1's receipt in the ledger
  and correct HANDOFF's "1 equivalent".
- **R2-F5 (low):** R13 (a strip whose row sits in one box, the common section → container-row shape), R24 (the note
  when only free space went) and L-radius (an inset card keeps its corners when its divider sides go) are killable:
  add a case for each (reviewer's `r2-probe.test.ts`). R4 is narrow: add it only if cheap.
- **R2-F6 (low, ruling):** a kept footer that paints nothing counts as paint, so its own top adds to S (160 / 112 / 80
  at 1440 / 992 / 390; base 174 / 96 / 64). This follows the plan's "R above a kept footer: S": don't change the code;
  record it in HANDOFF and the ledger as a known behaviour for Justin (the footer is usually the site's own, ticked
  off the paste).
- **Comment (found_else, this feature's code):** `widgets.ts` `ctaAt`'s comment says the rhythm reads what `markCtas`
  marks, but at rhythm time `n.list` and `n.flip` aren't set yet. Make the comment say so.

## Skills (load first, say so in one line each)
1. Project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (FIXER role;
   `references/rules-summary.md` first; worktree CLAUDE.md sections via grep + offset/limit). Note its lines on section
   rhythm (kept padding on a carrier counts on both edges), `size.unpin`, `room()`, `place.ts` constraints and the 992
   landing check.
2. `engineering-best-practices`, 3. `receiving-code-review`, 4. `test-driven-development` (a failing test before each
   change), 5. `mutation-testing-discipline` (every new or changed guard; probe each folded condition before calling a
   mutant equivalent), 6. `systematic-debugging` when anything fails unexpectedly.

## Done means
- Every valid finding fixed test first (red on 8259f2e, green after), each new guard mutation-proved, each rejected
  finding answered with evidence. AC4, AC6 and AC7's tests (unit and Chrome, `skipped 0`) cover R2-F1/F2/F3.
- `npm run check` green; the full browser suite compared by test name with base 5e2f98b (no new failures); corpus-backed
  unit tests in scratch `git archive` trees (head and base, `corpus.json` re-pointed, `node_modules` linked, a scratch
  `bin/tsc` link first on PATH) compared by test name.
- AC9: GRO and brainstorm byte-identical to base at all four tick settings; golden `convert-sample.json` unchanged;
  Home/Services/Repairs either byte-identical to 8259f2e or every changed element listed before → after with why. AC10
  green. AC11: re-run the lint receipt (five files × off/both × the plan's widths, base vs head) if any real page's
  output changed.
- Ledger and HANDOFF updated (rulings marked "not yet confirmed"); committed per passing fix; worktree clean at the end.

## This machine
- Chrome: your own wrapper script containing
  `exec /home/justin/.cache/chrome-for-testing/chrome-f2b --disable-software-rasterizer "$@"` as `CHROME_PATH`, with
  `/home/justin/.local/node-v22.23.3/bin` first on PATH; the same for base and head; record it in the ledger.
  `npm run corpus` finds no files here; never edit `corpus/corpus.json` in the worktree. A headless Chrome (PID 232915)
  from 03:10 isn't yours: leave it alone.
- Five real files: Home `corpus/files/hydraulics-home.json`, GRO `corpus/files/gro-home.json`, Repairs repo-root
  `figma-to-bricks-debug-page-1.json`, brainstorm `figma-to-bricks-debug-design-inspo-brainstorm.json`, Services
  `~/.hermes/plans/figma-to-bricks/evidence/closing-cta/planner-revise/services.json` (never in the worktree).
- Worktree guard: this session refuses Bash it can't prove stays in the worktree (shell variables or loops around
  `node`/`git`, heredoc then node, the word git inside a grep pattern). Write scratch scripts with Write and run
  `node <absolute script> <absolute args>`, one plain command per call. Long gates to a log ending in
  `echo EXIT=$? >> log`, then wait on it.

## Rules
- Commit to the branch after each passing fix: plain `git commit -m "…"`, no author override, no `Co-Authored-By` or AI
  lines. Check `git diff --cached --name-only` before each commit: CLAUDE.md must never be staged. Don't push. Don't
  bump `BUILD`. Don't edit the worktree's CLAUDE.md. Never bare `git stash`.
- Keep files under about 300 lines (`style/style.ts` is at 300). Don't weaken any existing test; any test you change,
  old → new and why, in the ledger. "Build general logic, never one-file fixes": no names, ids, Home numbers or order.
- You can't ask Justin anything. Justin's standing guidance for edge cases (2026-10-28): "put it in a way where it looks
  more aesthetic": even spacing, buttons never cramped, nothing landing on words or buttons. On a real trade-off, rule
  and write "My ruling, not yet confirmed" in `rulings[]` and the ledger. Don't narrow a rule to make a number pass.
- If you run low on steps, commit what passes and stop with `status: stopped`, naming the last commit and what's left.
- Other bugs: `found_else`. Reusable lessons: `skill_lessons[{skill, lesson, evidence}]` only; never edit skills or
  memory; empty is normal. Don't start other agents.

## Return (your final message)
`{status: ready-for-review|stopped, summary, findings_resolution[{id, valid, action, test, commit, evidence}], rulings[],
open_questions[], real_page_changes[], gates[], last_commit, ac_evidence[{ac, test, screenshot}], found_else[],
skill_lessons[]}`. End with the line `MAIN SESSION: check and save these skill_lessons now.`
