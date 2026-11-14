# Role: fixer (fix round 4, test and docs only): shared-palette — AC8's cited test asserts the amended AC8; the plan copy and HANDOFF follow amendment 2

You are a fresh fixer (**Opus 5.5, high**). Load `receiving-code-review`, `test-driven-development`, `mutation-testing-discipline`. Read both
`repeat-mistakes.md` files first (`~/.hermes/skills/software-development/figma-to-bricks/references/`,
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/`). **Change nothing under `src/` or `tools/`.** Never load any live site;
never write to any WordPress site; touch nothing under `~/Downloads`. Commit to your branch only; don't push; don't bump BUILD; don't edit the
main folder or CLAUDE.md; never bare `git stash`. Plain `git` in your own worktree, each command alone; scripts with the Write tool, run with
`bash <file>`; no heredocs.

## Inputs
- Installed plan (amendment 2): `/home/justin/.hermes/plans/figma-to-bricks/evidence/shared-palette/plan-approved.md` (sha256 `5a4e05c2…`).
- The planner's paste for AC8's cited test: `/home/justin/.hermes/plans/figma-to-bricks/evidence/shared-palette/planner-amend-2/ac8-rows.ts.txt`
  (19 lines for the end of the cited test, under its unchanged name; proof: `rows-red-green.log`, `mutants-rows-34502f9.log`; mutant script
  and the 14 one-line mutants of the reworded AC8 beside it, see its `README.md`).

## Do
1. Your own worktree: `git checkout -B shared-palette-fix4 34502f913215347ec66ddeb8f829bf7616e238fe`.
2. Paste the rows into AC8's cited test in `test/unit/site-colours.test.ts` (no other edit to the test); prove: the test is green on head,
   red on `7fa1c0e7` with the head's test file, and each of the planner's 14 mutants fails it (rerun them yourself, 4G scope; list each).
3. Replace `docs/plans/2026-11-11-shared-palette.md` with the installed plan (`cmp`-equal). Fix HANDOFF's stale bullet ("The rule → The site's
   colours (Q2 A)": a colour is used only when its `light` is "one opaque colour") to match fix 3, and add one line naming amendment 2.
4. Gates: `npm run check` (8G scope); AC1–AC10 by name (AC3 with `F2B_PIN=1`). Ledger "Fixer 4". Stop at `ready-for-next-review` with the
   head SHA; say plainly the diff touches only `test/unit/site-colours.test.ts`, `docs/plans/…`, `docs/HANDOFF.md` and the ledger.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/spf4/t1`); scripts under `~/.cache/spf4/s/`;
memory scope `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash <file>`. Use `tail -n 3`. Waits under 115 s in
foreground poll chunks.

## Report (as text)
Branch, head; the paste's proof (green, red, mutants); gates; `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal), ending
with: `MAIN SESSION: check and save these skill_lessons now.`
