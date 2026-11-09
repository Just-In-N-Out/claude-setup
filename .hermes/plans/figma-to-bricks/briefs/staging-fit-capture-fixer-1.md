# Role: fixer (round 1: R1-1): staging-fit-capture

You are a fresh fixer for FigmaToBricksV2 (**Fable 5.2, high**). Fix review 1's P2 finding R1-1 test-first, then stop at
`ready-for-review`. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push
or merge, don't bump `BUILD`, leave other worktrees alone, start no agents. **Never load bdryswi.com**; no logins; never
write to any WordPress site. Nothing paid. Nothing may hide that the importer's Chrome is automated.

**Skills to load:** `receiving-code-review` (verify the finding before fixing), `engineering-best-practices`,
`test-driven-development`, `mutation-testing-discipline`, `git-commit-rules`. Read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md`, and the repo `CLAUDE.md`.

## Your copy (you start in your own worktree)
`git checkout -B staging-fit-capture-fix1 5fa9eb82936855eafc41f1b84b8c54f8105bb84f` (the builder's head, branch
`staging-fit-capture-build`, on local `main` `fd1986dcdbc8cf35f114b80be456e94279346743`); confirm HEAD and a clean status
(after a restart, restore tracked files of exactly 8388608 bytes). Check `git rev-parse main` is still `fd1986dc` (if it
moved, say so; don't rebase). Report your branch.

## Inputs
- Plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-capture/plan-approved.md` (AC1, AC2).
- Review: `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-capture/review-1/review.json` (R1-1 P2;
  R1-2…R1-7 P3) and its probes beside it (`probe-a.ts`, `probe-d.ts`, `probe-pure.ts`, `probes-output.txt`).

## Work
1. **R1-1:** the design width's own page load is trusted as the reference with no check (`src/web/capture.ts:170`,
   `src/core/site/styled-ranges.ts:140`): when it is the load that lacks a stylesheet, the capture exits 0 and saves that
   range (and ranges that failed beside it) styleless, and `unstyledRanges` flags nothing. General rule: **no page load
   is trusted unchecked** — the reference must itself be proven styled (e.g. a sheet its own HTML asks for that errored,
   answered ≥ 400 or never applied makes the reference load fail the same way as any range: read again alone, 30 s, up to
   twice, then the one plain line; and/or the reference agrees with another load's sheets before it is trusted), and the
   saved-capture check flags a reference range whose recorded sheets failed. If the same rule covers R1-2 (the
   switch-point search's load, `capture.ts:79`) at no real extra cost, cover it and say so; otherwise leave it deferred.
   Test first: the review's probe A as a web test (503 for the stylesheet in the 2nd page load only: the capture is
   styled at every range, equal to a clean capture) and AC1's words read literally (503 in the 2nd–4th page loads) —
   RED on `5fa9eb82`, then GREEN; a never-arriving sheet on the reference stops with AC2's plain line. Mutate the guard.
2. Put R1-2…R1-7 (those you don't fix) in HANDOFF's staging-fit-capture "Deferred" list (they are in
   `evidence/staging-fit-capture/follow-ups.md`), and correct HANDOFF's "the new capture can't have a styleless range"
   to what is now true.
3. Gates before stopping: both typechecks, `npm run check`, AC1–AC5's tests, `test:web` file by file under the 4 GB cap
   compared by name with the builder's `evidence/staging-fit-capture/builder/gates/` (rerun only differing files on main).
4. Commit after each passing step (plain `git commit -m`, no author override, no AI or Co-Authored-By lines,
   `git diff --cached --name-only` without CLAUDE.md). Evidence in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-capture/fixer-1/` (logs `HEAD=` first, `EXIT=` last).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sfa-f/tmp`,
  its own per concurrent Chrome job); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Seven agents run
  Chrome: close every Chrome you start. One `bash <file>` per Bash call (scripts written with Write).
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`) or a scope oom-kill (`journalctl --user`); heavy and mutation runs under `systemd-run --user
  --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. Waits under 115 s.

## Report (as text)
`status: ready-for-review`, branch, base, last commit (full SHA), R1-1: verified?, the rule, fix, tests, RED/GREEN paths,
mutation, gates, `found_else`, then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal;
never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
