# Brief: FIXER 3 for figma-to-bricks feature "after-faq-sections" (Full pipeline, review loop)

You are a fresh fixer. The review referee said `REVIEW AGAIN: 1 P0-P2 finding(s) in review-3 at ca26c83`. Verify each
finding first, fix the valid ones test-first, push back with evidence on any that are wrong, and stop
`ready-for-next-review`. Don't re-plan and don't widen the job.

## Step 0: your copy
You start in your own throwaway worktree (`isolation: worktree`, made from `main` at dea6296, on its own branch
`worktree-agent-<your id>`). The job's head is `ca26c83` on branch `worktree-agent-ae26414264555729c` (never write or
run commands in another worktree). In **your own** worktree run `git merge --ff-only ca26c83` and check
`git rev-parse HEAD`. Work and commit there, on your own branch, and leave the worktree in place when you finish. If
CLAUDE.md or node_modules is missing, copy them from the main folder (`cp /home/justin/Documents/FigmaToBricksV2/
CLAUDE.md <your worktree>/`, `cp -a /home/justin/Documents/FigmaToBricksV2/node_modules <your worktree>/`; never stage
CLAUDE.md). If any of this is refused, stop with the exact message.

## The referee's lines (verbatim)
```
R3-1  P1  src/core/understand/footer-stack.ts:197  The final check only asks whether leaveOut, run on the split list, finds exactly the tail; both calls run siteFooter on the parts, whose thin-bar look-back (site-footer.ts:102) counts the part above a (c) bar as the footer's top only with 2+ columns of short lines and no heading of 1.6x the body size. A footer frame whose links part is a logo and a one-row menu (no columns), or link columns under a big heading, above a (c) bar is therefore split: both calls find the bar alone, the check passes, the links part is 'Kept' on the page and only the bar is left out, while base's whole-frame call (legal at the foot and links = columns or a menu) left the whole frame out. AC3's claim 'footers that don't stack page parts above their links convert as before' is false for these frames; AC3's test lists no menu-row or titled-columns variant. Evidence: review-3/probe-shapes.log and probe-plain-menu.log (head and 8fa172b: Kept "Footer top" / Kept "Columns", left out "Bottom bar" 48px, the menu words in the paste; base: Left out the footer ("Footer", 211/228/363px), no words); probe-apart.log shows base's siteFooter keeps such parts only when they are drawn as separate sections. Fix direction: keep the split only when the tail holds the links the whole frame was found by (columns or a menu), else start the footer at the kept part holding them (whole) or return entries  (repeats R2-1)
R3-2  P3  src/core/understand/rhythm.ts:156  R11's guard has an untested widening direction: mutant R3S1w (subtract SectionInfo.held from the bottom space too) survives both unit files (review-3/mutants.txt, mutant-R3S1w.log); every other mutant of the range's guards (final check off, accept on j < 0, narrow-frame rule off, held not subtracted, view repaints the frame's fills, held not recorded, whole dropped) is killed by its intended test
REVIEW AGAIN: 1 P0-P2 finding(s) in review-3 at ca26c83: fix them, then review the fix commits
```

## Where
- The review records: `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/review-1/`, `review-2/` (with
  `justin.json`), `review-3/` (its `review.json`, probes `probe-shapes.log`, `probe-plain-menu.log`, `probe-apart.log`,
  `mutants.txt`, `scripts/`). Reuse its probe fixtures rather than retyping them, and build them inside a function
  called after `resetIds()` (fixtures built at module load cause false "duplicate id" refusals).
- Approved plan (read only, amended): `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/plan-approved.md`.
  Earlier fixers' evidence: `fixer-1/`, `fixer-2/`. Ledger `.superpowers/sdd/2026-10-29-after-faq-sections/progress.md`.
- Your evidence: `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/fixer-3/`.

## What to do
- **R3-1 (P1):** tests first, from the reviewer's shapes: a footer frame whose links part is a logo plus a one-row menu
  above a © bar; link columns under a big (≥1.6× body) heading above a © bar; each with a CTA band above, with both
  ticks, with a 1px rule. Each must give base's outcome (the whole frame left out, base's note and height) unless a real
  page part stacks above the footer's links, where the split keeps that part and leaves out the whole footer (links
  part and bar together). Pin them in AC3's test (the AC3 test name stays the same). Follow the reviewer's direction:
  the split stands only when the tail holds the links the whole frame was found by (columns or a menu), else the footer
  starts at the kept part holding them, else `entries`. Compare against base's whole-frame `siteFooter` answer, not
  only against a second call on the parts. Probe every alternative the whole-frame test accepts (columns, a menu, a
  titled part) on both sides of each threshold.
- **R3-2 (P3):** add a test that kills mutant R3S1w (held subtracted from the bottom space too).
- Keep every earlier fix green (rounds 1–3), and fold your records (ledger, HANDOFF) into your fix commits to keep the
  next review's range small.

## Done means
R3-1 fixed test-first (a failing test committed or shown before the change), each new guard's test proven to fail
without it, R3-2's mutant killed, `npm run check` green, the footer-stack browser tests green with `skipped 0`, the
full browser suite compared by test name with a **built** base `dea6296` (no new failures), the AC4 receipt re-run (five
real files × four tick settings byte-identical; only the splitting variants differ), the v4 paste tests green (bounded
runs) with the paste files unchanged, committed. Stop with `status: ready-for-next-review`: no merge, no BUILD. Report
your worktree, branch and last commit.

## Skills (load first, say so in one line each)
1. Project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its
   `references/rules-summary.md`; `references/testing-pitfalls.md` before any receipt, mutation run or browser
   measurement; only the CLAUDE.md sections you need.
2. `engineering-best-practices`, 3. `receiving-code-review`, 4. `test-driven-development`,
5. `mutation-testing-discipline`, 6. `systematic-debugging` whenever a test fails unexpectedly, 7. `git-commit-rules`.

## This machine and the guard
Linux/WSL. Chrome: your own wrapper in your scratch containing `exec /home/justin/.cache/chrome-for-testing/chrome-f2b
--disable-software-rasterizer "$@"` as `CHROME_PATH`, `/home/justin/.local/node-v22.23.3/bin` first on PATH. Scratch in
a fresh `after-faq-sections-fixer-3/` folder under
`/tmp/claude-1000/-home-justin-Documents-FigmaToBricksV2--claude-worktrees-header-bar/168d7436-38b9-492f-b297-684b9e6d4850/scratchpad`;
`TMPDIR` and built trees under `/home/justin/.cache/after-faq-sections-fixer-3/`. `npm run corpus` measures nothing
here; corpus-backed unit tests need scratch `git archive` trees with `corpus.json` re-pointed (memory note
`~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`). The worktree guard
refuses Bash it can't prove stays in your worktree (shell variables or loops around `node`/`git`/`sed`, heredoc then
node, `git -C`, the word git inside a grep pattern or a script's text, the word `source` anywhere, even in a path):
write scripts with Write and run them as one plain command. Never commit in the same batch of tool calls as the gate
it depends on. Waits: poll in chunks under 170 s. Another job (`header-bar`) is under review in its own worktree: leave
it alone.

## Rules
- Plain `git commit -m "…"`, no author override, no `Co-Authored-By` or AI lines; check `git diff --cached --name-only`
  (never CLAUDE.md). Don't push, don't bump BUILD, never bare `git stash`. Files under about 300 lines.
- You can't ask Justin anything. A real trade-off becomes "My ruling, not yet confirmed" in `rulings[]` and the ledger.
- Other bugs: `found_else`; don't fix them. Lessons: `skill_lessons[{skill, lesson, evidence, enforce}]` (normally
  empty). Never edit skills or memory. Don't start other agents.

## Return (your final message)
`{name, status: ready-for-next-review|stopped, worktree, branch, last_commit, findings[{id, verdict: fixed|rejected|
partly, commit, test, evidence}], rulings[], ac_status[{ac, accepted, test, evidence}], paste_sha256, shots[],
found_else[], skill_lessons[]}`. End with the line `MAIN SESSION: check and save these skill_lessons now.`
