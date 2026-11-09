# Finisher (step 1, in a copy): elementor-footer-fit — rebase onto main (round 2)

You are a fresh finisher (Opus 5.5, high). Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare
`git stash`, never push or merge, don't bump `BUILD`, leave other worktrees alone, start no agents. Never load any live
site; no logins; never write to any WordPress site.

**Skills:** `git-commit-rules`, `engineering-best-practices`; read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Merging", the `.superpowers` line) with
`references/testing-pitfalls.md`, and the repo `CLAUDE.md` "Finish" step 1.

## Your copy (you start in your own worktree)
`git checkout -B elementor-footer-fit-final2 40e740fdfd025779038deb884220b29e5c1c8d9a` (the verified head of
`elementor-footer-fit-final`, on elementor-phone-fit's `e94e0311`; its ledger is already committed).

## Steps
1. `git rebase main` (local `main` = `b06d8267d4a3f26ee8ec9b3b0f7f2b45d0a594c9`, Build 2026-11-09.2: elementor-phone-fit
   merged with its build commit on top of `e94e0311`; check `git rev-parse main`). The build commit touched only
   `src/shared/build.ts`, `docs/HANDOFF.md` (phone-fit's heading and end-of-run entry got paste check 3dl and the build;
   site-motion's limits line) and phone-fit's ledger. Expect a HANDOFF conflict at most; keep both sides' meaning (this
   job's section first, main's lines as main has them). Record each conflict and resolution in this job's ledger and
   commit it. Confirm with `git range-diff e94e0311..40e740fd b06d8267..HEAD` that the job's patches are unchanged.
2. On the rebased head: both typechecks, `npm run check`, `test/unit/site-elementor-fold.test.ts`,
   `site-elementor-unchanged.test.ts`, `test/web/site-elementor-stretch.test.ts`, and the named B-Dry AC1 test with the
   verifier's stand-in `/home/justin/.cache/ef-v/` (find `standin-capture.json` there or in
   `evidence/elementor-footer-fit/verifier/`; check `web.code.version` 3 and that main's capture code is unchanged since
   it was made — `git diff 40e740fd HEAD -- src/web` empty — else capture afresh, ~7 min under 8G). Stop and report if
   anything new fails.
3. Evidence in `/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-footer-fit/finisher-2/` (logs `HEAD=` first,
   `EXIT=` last). Commits: plain `git commit -m`, no author override, no AI or Co-Authored-By lines, `git diff --cached
   --name-only` without CLAUDE.md.

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/ef-f2/tmp`, its
  own per concurrent Chrome job); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Other agents run
  Chrome too: close every Chrome you start. Run multi-step commands from a script file written with Write.
- Runaway memory: SIGTERM, 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso |
  grep sending`) or a scope oom-kill (`journalctl --user`); heavy runs under `systemd-run --user --scope -p MemoryMax=4G
  -p MemorySwapMax=0 <cmd>` (B-Dry captures 8G). `compare-corpus.test.ts` needs a 3600000 ms cap. Waits under 115 s.

## Report (as text)
Branch, the new HEAD (full SHA), the conflicts and resolutions, each test's result, `found_else`, then
`skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
