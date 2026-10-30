# Fixer brief: web-compare, fix pass 4 (after review round 4)

**Role:** fixer (fresh Opus 5.5, xhigh). Justin is asleep under an away grant
(`~/.hermes/plans/figma-to-bricks/away-2026-10-29-website-importer.md`): never stop to ask; decide, and record rulings
(not yet confirmed) in the ledger and your report.

**Skills:** load `receiving-code-review`, `test-driven-development` and `engineering-best-practices` with the Skill
tool; read the project skill with Read: `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its
`references/testing-pitfalls.md` and `references/rendering-validation.md`.

## Start

`main` is at `61bb5fc` (build 29.3), so your agent worktree starts there, not on the story. Put your copy on the
reviewed head without rebasing: `git checkout --detach f136bb0a7605d1d74ca59c12d5c8373c97cffa99` then
`git switch -c web-compare-fix-4` (fix pass 3's branch is `web-compare-fix-3`). Fixers don't rebase: your commits go
on top of `f136bb0`, and the story's base stays `3ea33bb`. Approved plan:
`~/.hermes/plans/figma-to-bricks/evidence/web-compare/plan-approved.md`; the ledger is
`.superpowers/sdd/2026-10-29-web-compare/progress.md` in your copy.

## The finding

Round 4 (a delta review of fix pass 3) left one P2 and tripped the review brake; **Justin chose "Fix it"**
(`review-4/justin.json`). The referee's line: `~/.hermes/plans/figma-to-bricks/evidence/web-compare/review-4/referee.txt`;
the record `review-4/review.json`; the reviewer's probes K1–K8 with the word-by-word ground truth in
`review-4/probes/`, `review-4/scripts/`, `review-4/logs/` (`probe-r4.log`, `probe-r4b.log`).
Fix **R4-1**: ruling R21 (pair only blocks that draw the same words) has no stand-in for a block whose own words sit
on both sides of a **block-level or blockified** box (a heading's `display:block` middle line, a flex or grid row of
text runs and a link, a float, an inline-flex button's inner span), so those words are never paired or measured: a
557px heading move or a centred-vs-left heading exits 0, and the exact one-line flex-row pairs 334066d had are gone.
The reviewer's suggestion, mirroring what fix 3 did for inline-level boxes: a stand-in block covering every word of
such a span (its ink, lines and cut), whose parts are the block and its nested blocks, pairing in the second pass
like a joined block. **Verify it first** with K1, K1.m, K2.m/K2.w, K3, K3.m and K8.m, fix it test-first as general
logic, both directions (same look gives no finding and no unmatched blocks; each real move, width or alignment
change is reported), judging every finding against the ground truth. Keep R3-1's and R3-2's behaviour (their tests
stay green). Earlier P3s stay follow-ups.

## Rules

- Commit each fix to your branch (plain `git commit -m`, no author override, no AI lines; no CLAUDE.md staged). Batch
  ledger/record updates into the fix commits. Don't push, don't bump `BUILD`, don't edit CLAUDE.md, never bare `git
  stash`, don't rebase.
- Re-run the gates after the fixes and compare by test name with the base `3ea33bb` (the builder's receipts are in
  `evidence/web-compare/builder/gates/`, fix passes 1–3 in `evidence/web-compare/fixer-1/` … `fixer-3/`): `npm run check`, `npm run test:web` (`skipped 0`), the story's browser tests,
  and renderer byte identity if you touch the renderer. **This machine (WSL):** `CHROME_PATH` =
  `~/.hermes/plans/figma-to-bricks/evidence/web-compare/planner/scripts/chrome-cpu.sh`; long gates as a script with
  `exec > <log> 2>&1` and `trap 'echo EXIT=$?' EXIT`, waiting for `EXIT=`. If a fix changes what the live noise floor
  would show, re-take it on the plugin-made Bricks site `https://darksalmon-badger-335429.hostingersite.com/` (add
  `?f2b=<random>`, read-only GETs). **Don't load bdryswi.com** (it serves a bot-check page to automated Chrome) and never
  try to hide automation.
- General logic only; `src/` stays untouched.

## Output

- `~/.hermes/plans/figma-to-bricks/evidence/web-compare/fixer-4/answers.md`: for R4-1, **fixed** (test
  name, RED log, commit) or **rejected** (the evidence), plus any P3 a fix covered. Logs and receipts beside it.
- Report (`ready-for-next-review`): branch, head SHA, the commits, the answers one line each, the gate tallies, then
  `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; `enforce` `none` or a one-line check proposal;
  empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
