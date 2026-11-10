# Finisher (step 1, in a copy): staging-fit-renderer — rebase onto the stack's top

You are a fresh finisher (**Opus 5.5, high**). Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never
bare `git stash`, never push or merge, don't bump `BUILD`, leave other worktrees alone, start no agents. Never load
bdryswi.com, B-Dry staging or any live site (local stand-in servers and saved files only); no logins; never write to any
WordPress site. Nothing paid.

**Skills:** `git-commit-rules`, `engineering-best-practices`; read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Step 4: Merge into main", the stacking
lines) with `references/testing-pitfalls.md`, and the repo `CLAUDE.md` "Finish" step 1.

## Where things are
`main` is `3cfc54acdc3326b4c0e8f1439aee6921d3e35fc1` (Build 2026-11-09.4, staging-fit-capture). Three other
website-importer jobs sit on it as a stack that merges before this job, in this order:

    main 3cfc54ac ← site-faq-stack1 (143a4e19) ← site-reviews-stack1 (dec9452c) ← site-slider-stack1-fix3 (7d9754ed8adb5308bd525b309e7ba4672e284104)

This job (`staging-fit-renderer`: the test renderer prints what real Bricks prints; `npm run site:live`, a read-only
tool that measures a published Bricks page against its paste; `site:check --whole` and friends) is on the **old** main
`fd1986dc`: branch `staging-fit-renderer-fix3`, head `04392a14209a2b6cee756c49cbb6bfc2a3e6108b`. Reviews 1–3 covered it
up to `b6bccfac`; the last six commits (`b6bccfac..04392a14`, a small hardening of the read-only guard) are not reviewed
yet: a reviewer takes them and your rebase together after you.

## Your copy (you start in your own worktree)
`git checkout -B staging-fit-renderer-stack1 04392a14209a2b6cee756c49cbb6bfc2a3e6108b`, then
`git rebase --onto 7d9754ed8adb5308bd525b309e7ba4672e284104 fd1986dcdbc8cf35f114b80be456e94279346743`.

## Rules for the rebase
- Keep both sides' meaning on every conflict. Expect them in `tools/site-check.ts` (this job: `--whole`, other-host
  pictures, `--bricks`; staging-fit-capture: the refusal of a styleless capture; site-reviews: a live widget's
  stand-in), `test/web/lib/site-check.ts` (site-slider: a looping slider's real slide; site-reviews: a locator line),
  `test/browser/chrome.ts` (this job: `Browser.on`, `Browser.kill()`/`killNow()`, `launchChrome({ group, started })`;
  staging-fit-capture and the others may have touched it), `test/browser/render*.ts` (this job's selector order; the
  slider's renderer changes for Bricks' slider CSS and checkbox reading), `package.json` scripts and `docs/HANDOFF.md`
  (all sections stay: this job's first, then the stack's as it has them; each job's `<… id at merge>` placeholders
  stay). Never drop the capture fix's refusal, a job's guard, or this job's read-only guard.
- After the rebase count each `package.json` script key (a script line added in two places merges into a duplicate key
  with no conflict). When both sides added a member with the same name, grep the name across the tree and typecheck at
  the conflicted commit before `git rebase --continue`.
- Record every conflict and its resolution in this job's ledger (`docs/plans/2026-11-09-staging-fit-renderer-ledger.md`),
  committed as the branch's last commit ("staging-fit-renderer stack 1: the rebase onto … and the gates"). Confirm with
  `git range-diff fd1986dc..04392a14 7d9754ed..HEAD` that the job's patches are unchanged apart from the resolved hunks;
  list every commit whose patch changed and, per file outside `docs/`, whether its added and removed lines are the same
  before and after.
- Commits: plain `git commit -m` (or `-F <file>` when the message holds a backslash or parentheses with colons), no
  author override, no AI or Co-Authored-By lines, `git diff --cached --name-only` without CLAUDE.md.

## Gates (on a `git archive` scratch copy of the rebased head, `dist/` built there by `npm run check`)
- Both typechecks and `npm run check` (the parallel unit suite may need an 8G scope).
- This job's test files, each alone under the 4 GB cap with a log starting `HEAD=` and ending `EXIT=`: the story's
  files named in `evidence/staging-fit-renderer/fixer-3/gates/summary.txt` (the 8 story files plus
  `test/web/site-live-reports.test.ts` and `test/unit/read-only-switches.test.ts`; `site-live.test.ts` has a known
  5.09 px load flake: rerun it alone once before reporting it).
- **Because this job changes the renderer every browser test of the stack draws with:** the stacked jobs' AC web files on
  your head — site-faq `test/web/site-elementor-open-item.test.ts`; site-reviews `site-widget-codes`,
  `site-widget-places`, `site-live-widget`, `site-check-live-widget`; site-slider `site-elementor-slider`,
  `site-elementor-carousels`, `site-elementor-swiper8`, `site-slider-reset`, `site-check-settle`; staging-fit-capture
  `site-cli`. A failure there that passes on `7d9754ed` is a stack interaction: report it exactly (test, numbers, both
  heads), don't fix it.
- The five Figma replays byte-identical to main, on the rebased head.
- Don't run the full `test:web` / `test:browser` suites: the verifier does.

## Evidence
`/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-renderer/stack-1/` (`range-diff.txt`,
`changed-commits.txt`, `changed-lines.txt`, `conflicts.txt`, `logs/`), scripts under `~/.cache/sfr-s1/` copied there.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sfr-s1/tmp`,
its own per concurrent Chrome job); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Other agents run
Chrome too: close every Chrome you start, and never signal a process group other agents' Chromes are in. A worktree's
`node_modules` may lack `.bin` and a scratch tree has no `tsc` (put
`/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH). Multi-step commands from a script file written with
Write. SIGTERM / 143 / 137 may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`);
heavy runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. Waits under 115 s.

## Report (as text)
Branch, the new HEAD (full SHA), its base, conflicts and resolutions file by file (or "none"), the commits whose patch
changed, each gate's result, any stack interaction, `found_else`, then `skill_lessons[{skill, lesson, evidence,
enforce}]` (reusable only; empty is normal; never edit skills or memory), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
