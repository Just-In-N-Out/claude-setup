# Role: reviewer + verifier (Mini round 1, report only): web-photo-crop

You are a fresh reviewer who never saw the build. Review only: change no source or test, commit nothing, start no
agents. Never touch the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees.

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"):** one review per job; report
as P0–P2 only bugs a real site or normal use hits (a captured site's pictures pasted into Bricks; any Figma design
converting as before), each with a concrete real-use scenario. Edge cases go in as P3 (follow-ups). A P0–P2 with no
concrete real-use scenario is a P3.

## Inputs

- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-photo-crop/plan-approved.md`
  (AC1–AC6; AC6 `(live)`, Justin's: `not_run`). The job: a captured picture whose boxes keep one shape across widths
  pastes with `height: auto` + `aspect-ratio` instead of a fixed px height with `cover` (bdryswi.com's three cards were
  cut at the bottom); Figma designs convert byte for byte as before.
- Head `6dfca9c2909efc41d4d72ab595967e7629a83f3a` (branch `web-photo-crop-build`), base
  `39d96c98a3a171de4733115dca8e4386a808d1ca` (main, Build 2026-11-04.1). In your own worktree: `git checkout --detach
  6dfca9c2909efc41d4d72ab595967e7629a83f3a`, confirm `git rev-parse HEAD` and a clean `git status --porcelain
  --untracked-files=all`. Review `git diff 39d96c98...HEAD`.
- The builder's receipts (read, don't trust): `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-photo-crop/builder/`
  (note: AC4's unit test checks only that Figma scenes carry no `keepsShape`; byte identity rests on receipts, so prove it
  yourself). The real capture: `/home/justin/Downloads/bdryswi-com-home.f2b-capture.json` (read-only; never load
  bdryswi.com).

## Work

Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and the repo
`CLAUDE.md` architecture rules (stages, typed CSS, rules write breakpoints); read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` (the `review.json` format) and
`references/ac-verification.md` (the verifier's AC work and `ac.json` format).
1. **Review** the whole diff for real bugs: false marks (a picture the site crops or sizes by height marked as
   shape-keeping, so it would now distort or overflow), pictures in rows/grids/sliders/heroes, the inline-Div mode, the
   tiers (`adapt/site/looks.ts`, `site.tiers`) and any rule that reads a picture's height, architecture rules (no stage
   editing an earlier one's output; typed CSS). Write
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-photo-crop/review-1/review.json`.
2. **Verify every AC** (the verifier's work): each AC's named test on head and on base (a base tree from `git archive -o
   <scratch>/base.tar 39d96c98`, then `tar -xf`, with head's test files and test-only modules copied in; a hybrid tree if
   base only fails at import), a terminal image per AC (AC3 a real render shot), `HEAD=` first and `EXIT=` last in each
   log, skipped 0. Gates by test name against base: both typechecks, `npm run check`, the five Figma replays and the
   fixtures in both picture modes byte-identical, the capture-converting web files (`site-tiers-fixture`, `-split`,
   `capture-embeds`), and the bdryswi.com Page converted on base and head (only the shape-keeping pictures change). Write
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-photo-crop/verifier/ac.json` (AC6 `not_run`, owed), then
   self-check with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh` (no `--reviews`) on a copy.

## Machine

- This machine (WSL): Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters
  (`~/.cache/wpc-r/tmp`); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b` or the CPU wrapper
  `~/.hermes/plans/figma-to-bricks/evidence/web-capture/planner/scripts/chrome-cpu.sh`. One Chrome job of your own at a
  time, closed after each step. The worktree's `node_modules` may lack `.bin`: see testing-pitfalls.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.
- Write multi-step scripts with Write and run `bash <file>` / `python3 -I <script>`; git commands as separate plain calls;
  no redirects, heredocs or the bare word `source` in a command. Never load bdryswi.com; never write to any WordPress
  site. Put any summary in your report.

## Report

`{verdict: clean|findings, head, base, findings[{id,severity,claim,scenario,evidence}], ac_status[{ac,accepted,test,
screenshot,evidence}], gates, found_else[], skill_lessons[{skill,lesson,evidence,enforce}]}`. Empty skill_lessons is
normal; never edit skills or memory. End with `MAIN SESSION: check and save these skill_lessons now.`
