# Role: fixer (test-only step 3): site-no-div — AC5's cited-test rows from plan amendment 3

You are a fresh fixer (**Opus 5.5, high**). Load `test-driven-development`, `mutation-testing-discipline`, the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`. Read both `repeat-mistakes.md`
files first. Never load any live site; never write to any WordPress site. Commit to your branch only; don't push; don't bump BUILD; don't edit
the main folder or CLAUDE.md; never bare `git stash`. Plain `git` in your own worktree, each command alone (never `git -C` the main folder; no
git piped into another command; `git archive -o <file> <sha>` then extract separately). **Change no file under `src/` or `tools/`.**

## Do
1. Your own worktree: `git checkout -B site-no-div-fix3 d915f7dc83e5edb14b7f6006e78714a92e9fac1c`.
2. Paste `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-no-div/planner-amend-3/ac5-rows.txt` into `test/unit/site-fold-boxes.test.ts`
   with its `apply-rows.py` (block A: 7 helper lines before the `cases` table; block B: 37 rows before `["a box of its own", …`); test name
   unchanged. Prove: green on head (cited test alone by its plan name, the whole file, `tsc --noEmit -p .`); red on a `git archive` export of
   `374ea2ce` with the new test file; red on a handful of the planner's clause mutants (`planner-amend-3/mutants.py`; at least the 7 that
   nothing caught before and M1).
3. Copy the installed plan `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-no-div/plan-approved.md` (amendment 3, sha 40770b68…) to
   `docs/plans/2026-11-11-site-no-div.md`. One commit for both: "site-no-div: AC5's cited test gets plan amendment 3's rows; repo plan copy =
   amendment 3 (test and docs only)". `npm run check` (8G scope). Stop with the head SHA.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/sdf3/t1`); scripts under `~/.cache/sdf3/s/`;
memory scopes `systemd-run --user --scope -p MemoryMax=<n>G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`.
Write scripts with the Write tool. Use `tail -n 3`. Waits under 115 s.

## Report (as text)
Branch, head; green/red/mutant logs; `npm run check`; `skill_lessons[]`, ending with: `MAIN SESSION: check and save these skill_lessons now.`
