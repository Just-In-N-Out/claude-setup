# Finisher (step 1, in a copy): elementor-footer-fit — ledger, commit, rebase onto phone-fit's rebased head

You are a fresh finisher (Opus 5.5, high). Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare
`git stash`, never push or merge, don't bump `BUILD`, leave other worktrees alone, start no agents. Never load any live
site; no logins; never write to any WordPress site.

**Skills:** `git-commit-rules`, `engineering-best-practices`; read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Merging", the `.superpowers` line) with
`references/testing-pitfalls.md`, and the repo `CLAUDE.md` "Finish" step 1.

## Your copy (you start in your own worktree)
`git checkout -B elementor-footer-fit-final 4c9f8214b08a9242dc4d7d401116c5469d46f6c1` (the reviewed head of
`elementor-footer-fit-build`, on phone-fit's old head `dab961f9`). The builder's ledger was never committed: copy it from
`/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a740b0814dd254239/.superpowers/sdd/2026-11-08-elementor-footer-fit/progress.md`
(read by absolute path; don't write there) to `docs/plans/2026-11-08-elementor-footer-fit-ledger.md`.

## Steps
1. Commit the ledger (`elementor-footer-fit: the ledger`), then
   `git rebase --onto e94e0311603a70ec35b9b6348cab52747dd97d23 dab961f9c30755b1890adc478ee9fdf3d5431516`
   (phone-fit rebased onto main `103cbb37`, Build 2026-11-09.1, branch `elementor-phone-fit-final`, in its final checks).
   Expected overlaps: HANDOFF top sections and end-of-run list; `src/core/site/elementor-fold.ts` (site-motion's AC15
   refusal in `foldable`'s first loop; this job moved rule 8 to `elementor-measured.ts` and ends `foldable` with
   `marginBoxes(…) ?? filledBoxes(…)`); the AC1 test `test/web/site-elementor-page-bdry.test.ts` (phone-fit's rebase
   kept it; this job drops the known row). Keep both sides' meaning; record each conflict and resolution in the ledger.
2. On the rebased head run: both typechecks, `npm run check`, `npm run corpus` (same as main; v1's Mac files missing),
   `test/unit/site-elementor-fold.test.ts`, `site-elementor-unchanged.test.ts`, `test/web/site-elementor-stretch.test.ts`,
   `site-elementor-pull`, the elementor web tests, `test/web/site-motion-proof.test.ts`,
   `test/browser/site-motion-flat.test.ts`; and the named B-Dry AC1 test with a stand-in written by this rebased head's
   capture (code version 3; capture afresh from the saved 2026-10-29 files, about 7 min under an 8G scope) — every row
   within 2 px, f2bd68b named; and site-motion's AC11 named (`test/web/site-motion-bdry.test.ts`, both routes). Find the
   variables' paths in `evidence/elementor-phone-fit/finisher-1/` and `evidence/site-motion/verifier/` logs. Stop and
   report if anything new fails.
3. Evidence in `/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-footer-fit/finisher-1/` (logs `HEAD=` first,
   `EXIT=` last). Commits: plain `git commit -m`, no author override, no AI or Co-Authored-By lines, `git diff --cached
   --name-only` without CLAUDE.md.

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/ef-f/tmp`, its
  own per concurrent Chrome job); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Other agents run
  Chrome too: close every Chrome you start. Run multi-step commands from a script file written with Write.
- Runaway memory: SIGTERM, 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso |
  grep sending`) or a scope oom-kill (`journalctl --user`); heavy runs under `systemd-run --user --scope -p MemoryMax=4G
  -p MemorySwapMax=0 <cmd>` (B-Dry captures 8G). `compare-corpus.test.ts` needs a 3600000 ms cap. Waits under 115 s.

## Report (as text)
Branch, the new HEAD (full SHA), the conflicts and resolutions, each test's result, `found_else`, then
`skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
