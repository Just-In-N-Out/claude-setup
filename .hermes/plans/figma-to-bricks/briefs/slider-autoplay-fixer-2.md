# FIXER 2 — slider-autoplay (FigmaToBricksV2)

Fix the valid findings of reviewer 2 (verdict: request-changes) on
`/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/slider-autoplay` (branch `worktree-slider-autoplay`, head
160caa3, base f46f8a2). Note: main has since moved to 45b02d3 (flip-cards merged); don't rebase (the finisher does).
Approved plan (read-only): `~/.hermes/plans/figma-to-bricks/evidence/slider-autoplay/plan-approved.md`; Justin's answers
of 2026-10-27 are in the plan copy and HANDOFF. Review, probes and mutants:
`~/.hermes/plans/figma-to-bricks/evidence/slider-autoplay/reviewer-2/` (review.json, probe1–5, mutation tooling).

## Role and skills
FIXER. Load: the project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` + its
`references/rules-summary.md`), `engineering-best-practices`, `receiving-code-review`, `test-driven-development`,
`mutation-testing-discipline`, `git-commit-rules`.

## Findings (test first, one commit each)
- **R2-F1 (high):** slides 2…N of a set drawn without auto layout skip layout inference: `inferLayouts(slide)` skips a
  root that `page-frame.ts` `pageLike()` judges a page (3+ edge-to-edge layers, or 2 if tall), so on tablets/phones
  slides 2…N keep absolute layers while slide 1 flows. Never treat a slide's own root as a page frame; infer it as its
  instance is inferred. Check whether slide 1's page-only passes (`rebaseSections`, `pairOverlays`, `groupPastEdge`)
  are needed for slides 2…N too. Turn probe4's 3-layer free-drawn fixture into a scene test and a browser test at 390
  and 768 (all slides lay out alike). AC9 isn't accepted until this holds.
- **R2-F2 (medium):** slides added as pages make the call pass's page-wide tallies (`contact-links.ts` `main()`,
  `spelling()`) count a slider's number once per slide, so a Call button outside the slider can dial the slider's
  number. Count each slider's numbers once in those tallies; keep the nearest-number search across all slides (AC11).
  Turn probe3 into a fixture test first.
- **R2-F3 (low, tests):** the surviving mutants R1, R2, R3, R5, R6, R7, R8, R10, R11, R13, R14, R16 (suggested tests in
  review.json): one small test each; re-run the reviewer's in-memory mutants and record each kill.
- **R2-F4 (low):** (a) a narrow (non-band) slider keeps its drawn side padding on phones, so the 24px arrows cover the
  last 4px of a full-width button at 320–390: extend the phone clearance to narrow sliders' slides (my ruling, replacing
  "band slides only"); (b) from 768 to 991 Bricks' 50px arrows lie 14px into a band Container's 36px gutter: give band
  slides enough side clearance on tablets too, or record it as a limit if the fix would fight the plugin's gutters. Test
  with elementFromPoint at 320, 390, 768 and 991.
- Record in HANDOFF as found_else (not this feature's): the same page-frame skip hits hover looks (`hoverOf` → `look()` →
  `inferLayouts` on a variant root) and hidden-layer trees, on main too.

## Gates
`npm run check` (0 fail); `test/browser/carousel.test.ts` alone (`skipped 0`); the full browser suite by name against
main f46f8a2's; AC5's five user files (hydraulics, GRO, Repairs, brainstorm, Services) with bricks.json and warnings
byte-identical to f46f8a2; the corpus-skipped unit tests in scratch git-archive trees (memory
`corpus-paths-on-desktop.md`). `export CHROME_PATH=$HOME/.cache/chrome-for-testing/chrome-f2b`. Long gates: log with
`echo EXIT=$? >> log`, wait with `until grep -q '^EXIT=' log; do sleep 2; done`. Source files under ~300 lines. Update
HANDOFF, the plan copy and the ledger for every changed ruling.
**Scratch:** work only in `<scratchpad>/slider-autoplay-fixer-2/`, created fresh with `mkdir` (no `-p`); never extract
into a folder you didn't create. Copy probes that prove something into your evidence folder at once.

## Rules
Commit (plain `git commit -m`, no AI lines, no author override, no CLAUDE.md staged). Never push, never bump BUILD, never
edit the main folder, never bare `git stash`. Justin is away: when unsure, take the recommended option and record it as
"My ruling, not yet confirmed"; when you don't know how, research it and implement your best rather than stopping.

## Report
Return `{name, status: ready-for-verify|stopped, summary, findings[{id, verdict: fixed|pushed-back, evidence, commit}],
rulings[], gates, last_commit, ac_status[{ac, accepted, test, evidence}], found_else[], skill_lessons[{skill, lesson, evidence}]}`
and end with `MAIN SESSION: check and save these skill_lessons now.` Don't edit skills or memory yourself.

## Resume note (2026-10-28)
The earlier fixer 2 was stopped mid-work when Justin paused everything. **Its uncommitted work is still in the
worktree** (head still `160caa3`): `git -C <worktree> diff` shows about 66 lines in
`src/core/normalise/{carousel,content-box,infer,normalise,pairs,past-edge,wrappers}.ts`, `test/browser/carousel.test.ts`
and `test/fixtures/carousel.ts`, plus the new untracked `test/unit/normalise-carousel-pages.test.ts`. Most of it is
R2-F1. Main has moved on to `70d5408` since; still don't rebase (the finisher does).
1. Read that work first and keep what's right; never stash, reset or check out those files (fix them in place).
2. Finish **R2-F1 test-first**: prove the new scene and browser tests fail without the fix (e.g. a scratch copy of the
   worktree with the source changes reverted, never a revert in the worktree itself), then pass with it.
3. Then R2-F2, R2-F3 and R2-F4 as above, one commit each.
4. Run the gates above and record them in the ledger (`.superpowers/sdd/2026-10-26-slider-autoplay/progress.md`) and
   HANDOFF; the ledger's last line says "ready-for-verify". Leave the worktree committed and clean (`git status
   --porcelain` empty).
- **Scratch:** `/tmp/claude-1000/-home-justin-Documents-FigmaToBricksV2/a9c7f93c-51b3-4315-acc0-a1d6d3c9361a/scratchpad/slider-autoplay-fixer-2b/`,
  created fresh with `mkdir` (no `-p`). Evidence: `~/.hermes/plans/figma-to-bricks/evidence/slider-autoplay/fixer-2/`.
- Two other chats are finishing headline-marker and photo-hotspots at the same time: never touch their worktrees,
  evidence or scratch. If a browser test fails from a Chrome port or profile clash, rerun it before judging it.
- You can't start agents: any skill step that says "spawn a subagent" is the main session's job; note it in your report.

### Codex continuation (2026-10-28)
Justin explicitly resumed this feature through the merge using `2-slider-autoplay.md`. The existing resume note
above remains in force; the current dirty file list matches it. Keep and assess all unfinished work, prove R2-F1
RED in a separate scratch copy, then complete R2-F2, R2-F3 and R2-F4. You own this feature's worktree and its
`fixer-2` evidence only. You are not alone in this repository: never revert another session's changes, and adapt
to concurrent changes at the later integration boundary. Never touch headline-marker or photo-hotspots worktrees.
Use a newly created agent-specific `/tmp/slider-autoplay-fixer-2-XXXXXX` scratch folder rather than the historical
scratch path above. Read the approved plan's AC1–AC14 and the current plan's Justin's answers and Rulings;
AC13 and AC14 are live paste check 3bm, and AC14's interval is now 5800 (delay + speed), replacing 5000.
Return all AC statuses and `skill_lessons`, commit the finished work, and end the ledger with `ready-for-verify`.
