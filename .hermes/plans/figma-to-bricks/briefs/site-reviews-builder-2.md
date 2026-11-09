# Role: builder (continuation, Mini): site-reviews (website importer)

You are a fresh builder (**Fable 5.2, high**; Justin asked on 2026-11-09 that these jobs run on Fable 5.2) taking over a
build whose agent was cut off when the machine restarted at 14:40 on 2026-11-09 (a restart, not a memory kill). Its
work is committed; finish it and stop at `ready-for-review`.

**First read the original brief `/home/justin/.hermes/plans/figma-to-bricks/briefs/site-reviews-builder.md`: every rule,
skill, input, gate, machine note and the report format in it apply to you** (where it says Opus 5.5, read Fable 5.2).
In short: never edit the main folder, never bare `git stash`, never push or merge, don't bump `BUILD`, start no agents,
never load bdryswi.com, no logins, never write to any WordPress site, nothing paid, plain `git commit -m` with no AI or
Co-Authored-By lines and CLAUDE.md never staged.

## Where the build stands
- The cut-off builder's branch `site-reviews-build`, last commit `2837727293a91b929d03ca1ff0fea8f85cef5f42`. In your own worktree (you start in it):
  `git checkout -B site-reviews-build2 2837727293a91b929d03ca1ff0fea8f85cef5f42`, confirm `git rev-parse HEAD` and a clean status; look for tracked files of
  exactly 8388608 bytes (a restart can cut files) and restore them with `git checkout --`. Report your branch.
- Its uncommitted changes, left in `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a468d8dff4cbdf4ba` (you can't run
  git there or write there; read the files by absolute path): ` M docs/plans/2026-11-09-site-reviews-ledger.md`. Compare each with your copy; take what is
  finished and right (a ledger entry, a test and its code together), leave what is half-done, and say what you did.
- What is done and what is left: read the ledger `docs/plans/2026-11-09-site-reviews-ledger.md` (and that uncommitted copy of
  it, if listed), the plan `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-reviews/plan-approved.md`, and the
  evidence folder `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-reviews/builder/`. A log without a last `EXIT=` /
  `FILE_EXIT=` line was cut: its run doesn't count. Any input file written just before 14:40 may be truncated: check it
  (size, or `git hash-object` against its source) before reusing it.

## Work
1. Finish any task the plan lists that the ledger doesn't show done (test first, one commit each).
2. Finish the mutation runs the ledger shows unfinished (under the cap, bytes restored and hash-checked).
3. Run or re-run every gate the original brief's step 3 lists that has no complete receipt on the final head (logs
   `HEAD=` first, `EXIT=` last; `test:web` and `test:browser` file by file compared by name with base `fd1986dc`; a
   screenshot per AC). New evidence goes beside the old in `evidence/site-reviews/builder/` (a `cont/` subfolder is fine).
4. HANDOFF section and ledger complete and committed; `main` is still `fd1986dcdbc8cf35f114b80be456e94279346743`
   (check; if it moved, say so — don't rebase).

## Machine (as the original brief, with)
- `TMPDIR` `~/.cache/srv-c/tmp` (its own per concurrent Chrome job); seven agents are running Chrome jobs: close every
  Chrome you start. One `bash <file>` per Bash call (scripts written with Write); wait on a driver's final marker.

## Report (as text)
As the original brief says (status, branch, base, last commit's full SHA, per AC: test, RED/GREEN paths, screenshot;
mutation; gates vs base; deviations; `found_else`), plus what you took over and what you redid, then
`skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
