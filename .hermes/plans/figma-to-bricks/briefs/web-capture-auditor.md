# BLIND AC AUDITOR (read only): web-capture (J1 of the website importer, FigmaToBricksV2)

Independently prove the approved acceptance criteria. You have never seen a builder, reviewer, fixer or verifier report.
Stay blind: never open any other role's reports, evidence folders or briefs (everything under
`/home/justin/.hermes/plans/figma-to-bricks/evidence/web-capture/` except `plan-approved.md` and your own `auditor/` folder), HANDOFF, ledgers or the session's notes.
Source and tests are read-only; commit nothing; start no agents.

**Justin (2026-10-31):** the ACs are the goal. An AC fails when its own text is broken (its named test, or a realistic
case its words cover); an edge case beyond its text goes in `found_else`.

## The only inputs
- Approved plan: `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-capture/plan-approved.md` (AC1–AC14). Use each exact test name the plan gives.
- The head `@HEAD@` and base `@BASE@` (below), and your own folder `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-capture/auditor/` (new).
- The job: `npm run capture -- <url>` reads a live web page (header, page, footer as tagged parts, every switch point, stretchy values, pictures, fonts, links, floating extras) into one capture file the plugin's `loadSnapshot` replays like a Figma debug file; `src/web/` is never imported by `src/core`, `src/plugin`, `src/shared` or `src/ui`; Figma replays stay byte-identical.
- **AC14 and bdryswi.com:** bdryswi.com serves a bot-check page to automated Chrome. **Never load it** and never try to
  hide automation (Justin owes the allow-list). Prove AC14 on the reachable homes (`https://www.letsgro.ai/` and the
  plugin-made Bricks site) with `F2B_WEB_SITES=letsgro,plugin-bricks` and fresh captures, `skipped 0`; name the
  bdryswi.com part as owed to Justin in `ac_status` (`not_run: live: ...`) and judge the rest by the plan's text.
- **AC7/AC8 blast radius:** the five real Figma files (`corpus/files/hydraulics-home.json`, `corpus/files/gro-home.json`,
  repo-root `figma-to-bricks-debug-page-1.json`, `figma-to-bricks-debug-design-inspo-brainstorm.json`, Services via
  `git show 2199895:figma-to-bricks-debug-page-1.json`) replay byte-identical (payload and warnings) on head and base.

## Your copy
You start in your own throwaway worktree. Run `git checkout --detach @HEAD@` and confirm `git rev-parse HEAD`, a clean
`git status --porcelain --untracked-files=all` and `git merge-base HEAD main` = `@BASE@`. This head is the finisher's
combined line: web-capture's and web-compare's commits on top of `main` (branch `wave1-final`, rebased onto main after the DJ Trees build .3, canonical copy
`@WT@`). Your `ac.json` names head `@HEAD@` and base `@BASE@`. Never write in any other worktree.

## Work
Load `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, its `references/rules-summary.md` and
`engineering-best-practices`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`
and the report format at the top of its `scripts/ac-check.sh`; follow the blind auditor procedure there. For every
runnable AC make your own head and base runs (log `HEAD=` first and `EXIT=` last; the named assertion must run, pass on
head and fail on base for changed behaviour; a setup failure is not RED; preservation that correctly passes on base is
`base_exempt` with a specific reason) and a screenshot (a real terminal image for a non-visual AC). Receipts are yours,
never copied from another role. Write `auditor/ac.json`, then self-check by copying your report and receipts to a fresh
scratch folder and running `ac-check.sh` on them (no `--reviews`).

## Machine
- **This machine (WSL):** `CHROME_PATH=/home/justin/.hermes/plans/figma-to-bricks/evidence/web-capture/planner/scripts/chrome-cpu.sh`, Node `/home/justin/.local/node-v22.23.3/bin` first on PATH, `TMPDIR`
  short (`/home/justin/.cache/web-capture-aud/tmp`; Chrome fails with "Socket path too long" inside the scratchpad). Kill only
  processes with your own profile. A browser or web run counts only with `skipped 0`. Corpus-backed tests: scratch
  `git archive` trees with `corpus.json` re-pointed to local files (memory note
  `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`); never edit
  `corpus/corpus.json` in any worktree. Three other checkers run Chrome at the same time: a timing-sensitive failure gets
  one re-run before it counts, and you say so.
- Worktree guard: write multi-step scripts with Write and run `bash <script>` or `node <absolute script>` in their own
  call; long runs with `exec > <log> 2>&1` and `trap 'echo EXIT=$?' EXIT`, waiting for `EXIT=`; git commands as separate
  plain calls; `node --test` options go before file paths. For a base run, copy head's test files into a base tree
  (running a test by path from another tree imports that tree's code).
- **Live reads GET only** of `https://darksalmon-badger-335429.hostingersite.com/` (add `?f2b=<random>`) and
  `https://www.letsgro.ai/`. Never load bdryswi.com; never try to hide automation; never write to any WordPress site.

## Machine rules added 2026-11-02 (these win over older lines above)
- Chrome: Justin lifted the shared slots ("open chrome test for everything"): run at most one Chrome job of your own at a time and close Chrome after each step. If the main session sends "back to N slots", hold one of `~/.cache/f2b-chrome.lock`, `-2`, `-3` (first N only) for your whole Chrome sequence. Run long suites file by file (testing-pitfalls), so a restart costs one file.
- Runaway memory (global CLAUDE.md "Windows Desktop: Runaway Memory"): a command that dies with SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill, not a result: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`; if killed, say so, find what grew, rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. Mutation runs always use that cap.
- Justin (2026-11-02): "focus on building and not too much of edge cases": accept or reject the ACs; edge cases beyond an AC's text go in `found_else`.
- A command holding the bare word `source` is refused in your worktree; read such files with Read. Put any summary in your report, not a separate summary file.

## Report
`{verdict: clean|findings, head, base, findings[{id,severity,claim,evidence}], ac_status[{ac,accepted,test,screenshot,
evidence}], gates, found_else[], skill_lessons[{skill,lesson,evidence,enforce}]}`. Clean needs every runnable AC
accepted. Empty skill_lessons is normal; never edit skills or memory. End with
`MAIN SESSION: check and save these skill_lessons now.`
