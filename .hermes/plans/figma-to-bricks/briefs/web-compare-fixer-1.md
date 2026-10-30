# Fixer brief: web-compare, fix pass 1 (after review round 1)

**Role:** fixer (fresh Opus 5.5, xhigh). Justin is asleep under an away grant
(`~/.hermes/plans/figma-to-bricks/away-2026-10-29-website-importer.md`): never stop to ask; decide, and record rulings
(not yet confirmed) in the ledger and your report.

**Skills:** load `receiving-code-review`, `test-driven-development` and `engineering-best-practices` with the Skill
tool; read the project skill with Read: `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its
`references/testing-pitfalls.md` and `references/rendering-validation.md`.

## Start

Your agent worktree starts at `main` (`3ea33bb`). Bring it up to the reviewed head:
`git merge --ff-only 6f4761664de8d1d1c3acda6a7dd5bc1651086f1f` (branch `worktree-agent-ac72814ffff3e6cce`). If
`main` moved and that fails, cherry-pick `3ea33bb..6f47616` onto your copy instead and say so. Approved plan:
`~/.hermes/plans/figma-to-bricks/evidence/web-compare/plan-approved.md`; the ledger is
`.superpowers/sdd/2026-10-29-web-compare/progress.md` in your copy.

## The findings (the referee's lines, verbatim)

Review record: `~/.hermes/plans/figma-to-bricks/evidence/web-compare/review-1/review.json`, its probe logs in
`review-1/logs/`. Fix the four P2s; **verify each first** (reproduce it with the reviewer's probe or your own). Fix the
valid ones test-first: a failing test that reproduces it (a same-look/different-build or different-look pair, as the
reviewer probed), then the fix. Push back with evidence on any that doesn't hold. The P3s (R1-5…R1-12) are follow-ups:
leave them unless a P2 fix naturally covers one, and say which.

```
R1-1  P2  test/web/lib/diff.ts:54  Sideways scrolling is read as scrollWidth > clientWidth + 1 without the viewport's own overflow-x, so a page that hides its sideways overflow (overflow-x: hidden or clip on body/html, which the viewport takes over) counts as scrolling. […] Fix: treat the page as scrolling only when the viewport's effective overflow-x (html's, else body's when html's is visible) is visible/auto/scroll.
R1-2  P2  test/web/lib/freeze.ts:210  The freeze's late-reveal step calls scrollIntoView({block:'center'}) on every still-hidden box, which scrolls every clipping ancestor (overflow hidden boxes are scroll containers), vertically too; nothing restores those offsets […] Fix: record every element's scrollTop/scrollLeft before step 6 and put them back after it (or scroll the window to the box instead of scrollIntoView).
R1-3  P2  test/web/lib/measure-content.ts:113  An inline SVG's fingerprint is drawn from its markup alone (only `color` is carried, and setAttribute('style', …) also overwrites the root's own style attribute), so fills and strokes the page's CSS gives it are lost […] Fix: inline each descendant's computed fill, stroke, stroke-width, opacity/fill-opacity/stroke-opacity (and keep the root's style) before serialising, or fingerprint a screenshot clip of the drawn box.
R1-4  P2  test/web/lib/compare.ts:55  Noise keys are kind|width|section (timing alone adds el and field), so a noise finding with no section (fixed, fonts, sideways) mutes every finding of that kind at that width, and one box/arrangement noise finding mutes every box/arrangement finding in its section. […] Fix: match noise on el too for every kind that has one (box, arrangement, fixed, fonts, embeds), as timing already does.
```

(The full lines, with the probes, are in `review.json`.)

## Rules

- Commit each fix to your branch (plain `git commit -m`, no author override, no AI lines; no CLAUDE.md staged). Batch
  ledger/record updates into the fix commits. Don't push, don't bump `BUILD`, don't edit CLAUDE.md, never bare `git
  stash`, don't rebase.
- Re-run the gates after the fixes and compare by test name with the base `3ea33bb` (the builder's receipts are in
  `evidence/web-compare/builder/gates/`): `npm run check`, `npm run test:web` (`skipped 0`), the story's browser tests,
  and renderer byte identity if you touch the renderer. **This machine (WSL):** `CHROME_PATH` =
  `~/.hermes/plans/figma-to-bricks/evidence/web-compare/planner/scripts/chrome-cpu.sh`; long gates as a script with
  `exec > <log> 2>&1` and `trap 'echo EXIT=$?' EXIT`, waiting for `EXIT=`. If a fix changes what the live noise floor
  would show, re-take it (read-only GETs) and save it beside the old one.
- General logic only; `src/` stays untouched.

## Output

- `~/.hermes/plans/figma-to-bricks/evidence/web-compare/fixer-1/answers.md`: for each of R1-1…R1-4, **fixed** (test
  name, RED log, commit) or **rejected** (the evidence), plus any P3 a fix covered. Logs and receipts beside it.
- Report (`ready-for-next-review`): branch, head SHA, the commits, the answers one line each, the gate tallies, then
  `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; `enforce` `none` or a one-line check proposal;
  empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
