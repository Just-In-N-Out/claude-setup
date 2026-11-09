# Role: fixer (round 1: R1-1): site-faq

You are a fresh fixer for FigmaToBricksV2 (**Fable 5.2, high**). Fix review 1's P2 finding R1-1 test-first, then stop at
`ready-for-review`. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push
or merge, don't bump `BUILD`, leave other worktrees alone, start no agents. **Never load bdryswi.com** or any live site;
no logins; never write to any WordPress site. Nothing paid.

**Skills to load:** `receiving-code-review` (verify the finding before fixing), `engineering-best-practices`,
`test-driven-development`, `mutation-testing-discipline`, `git-commit-rules`. Read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` and `references/rendering-validation.md`, the repo `CLAUDE.md` and
`reference/bricks/README.md`.

## Your copy (you start in your own worktree)
`git checkout -B site-faq-fix1 5e6cf9af3507a591aec32cb00f1e1bfbdfc3dcae` (branch `site-faq-build2`, on local `main`
`fd1986dcdbc8cf35f114b80be456e94279346743`); confirm HEAD and a clean status (after a restart, restore tracked files of
exactly 8388608 bytes). Check `git rev-parse main` is still `fd1986dc` (if it moved, say so; don't rebase).

## Inputs
- Plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-faq/plan-approved.md` (AC1, AC2, Q1 A).
- Review: `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-faq/review-1/review.json` (R1-1 P2; R1-2…R1-5 P3; the
  recipes are in it — the reviewer's probe scripts were lost in a restart).

## Work
1. **R1-1 (`src/core/site/elementor-accordion.ts:61`, called from `elementor-fold.ts:264`):** an accordion the site hides
   at the design width (Elementor's Hide on desktop: a phone FAQ beside a desktop one) reads "none open" from the design
   range, because every panel is unshown where the whole widget is; head writes no `expandItem` and no `.brx-open` look,
   where base wrote `expandItem "0"` and moved the look — a regression: on phones every answer loads closed and the first
   question stays orange. General rule: the open item(s) are judged at the widest range where the accordion itself is
   shown (the design width's when it shows there); ranges where the accordion isn't shown say nothing about which item
   is open and never count as "none open" (so R1-2's false note goes too, if the same rule covers it — say so). Test
   first with the review's recipe (`elementorCode()` with every node at or under the accordion given `shown` filtered to
   `["0-767"]`, and to `["768-1024","0-767"]`): a unit case and a browser proof at 390 with Bricks' own script (loads
   "open, orange, answer shown"; a click on the third moves the look) — RED on `5e6cf9af`, then GREEN; mutate the guard
   under the cap.
2. Put R1-3, R1-4, R1-5 (and R1-2 if not covered) in HANDOFF's site-faq "Deferred" list (they are in
   `evidence/site-faq/follow-ups.md`); for R1-5 add the review's stronger witness (B-Dry's 2026-11-09 capture with the
   panels of cards 2–5 given `shown: []`, base vs head byte-identical) to AC6's witness script if it is cheap.
3. Gates before stopping: both typechecks, `npm run check`, AC1–AC7's tests (AC7 named with
   `F2B_BDRY_CAPTURE_1109=/home/justin/f2b-test/bdryswi-com-home.f2b-capture.json`, 8G scope), the witness
   (`evidence/site-faq/builder/scripts/witness.ts`), `test:web` file by file under the 4 GB cap compared by name with the
   builder's `evidence/site-faq/builder/cont/files-head/` (a `git archive` scratch copy whose logs start `HEAD=<sha>
   (archive)`; rerun only differing files on main).
4. Commit after each passing step (plain `git commit -m`, no author override, no AI or Co-Authored-By lines,
   `git diff --cached --name-only` without CLAUDE.md). Evidence in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-faq/fixer-1/` (logs `HEAD=` first, `EXIT=` last). Keep probe
   scripts under `~/.cache/sfq-f/`, never the `/tmp` scratchpad (a restart empties it).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sfq-f/tmp`,
  its own per concurrent Chrome job); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Several agents run
  Chrome: close every Chrome you start. One `bash <file>` per Bash call (scripts written with Write); start long drivers
  with `setsid --fork` and wait on their final marker.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`) or a scope oom-kill (`journalctl --user`); heavy and mutation runs under `systemd-run --user
  --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (B-Dry 8G). Waits under 115 s. The machine has restarted three times
  today: commit often.

## Report (as text)
`status: ready-for-review`, branch, base, last commit (full SHA), R1-1: verified?, the rule, fix, tests, RED/GREEN paths,
mutation, gates, `found_else`, then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal;
never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
