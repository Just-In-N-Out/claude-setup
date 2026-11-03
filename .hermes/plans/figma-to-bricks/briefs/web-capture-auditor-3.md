# BLIND AC AUDITOR (read only): web-capture (J1 of the website importer, FigmaToBricksV2)

Independently prove the approved acceptance criteria. You have never seen a builder, reviewer, fixer or verifier report.
Stay blind: never open any other role's reports, evidence folders or briefs (everything under
`/home/justin/.hermes/plans/figma-to-bricks/evidence/web-capture/` except `plan-approved.md` and your own `auditor-3/` folder), HANDOFF, ledgers or the session's notes.
Source and tests are read-only; commit nothing; start no agents.

**Justin (2026-10-31):** the ACs are the goal. An AC fails when its own text is broken (its named test, or a realistic
case its words cover); an edge case beyond its text goes in `found_else`.

**Final check (2026-11-03):** this head is wave 1's line (`wave1-final` + fix 1 + fix 2) rebased onto main `6cfd3e6`. Since your earlier round it gained fix 2 (`bb7f5aa`..`38dc0ca`: fixed boxes only other widths show are read in the range that shows them, a phone-only full-window dim layer is the page's backdrop, the compare FE-1 test's short temp folder). The capture plan is amended (AC4 part-own fixed content; AC14 letsgro + plugin home; AC15 live). Prove every AC on this head yourself; earlier receipts don't count.

## The only inputs
- Approved plan: `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-capture/plan-approved.md` (AC1–AC15 (amendment 1: AC15 is `(live)`, owed to Justin; mark it `not_run`)). Use each exact test name the plan gives.
- The head `0f9e870be571a961f4b363f72069e0370324d378` and base `6cfd3e6681b7d0e121173ed746ab49206c672c4e` (below), and your own folder `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-capture/auditor-3/` (new).
- The job: `npm run capture -- <url>` reads a live web page (header, page, footer as tagged parts, every switch point, stretchy values, pictures, fonts, links, floating extras) into one capture file the plugin's `loadSnapshot` replays like a Figma debug file; `src/web/` is never imported by `src/core`, `src/plugin`, `src/shared` or `src/ui`; Figma replays stay byte-identical.
- **AC14 and AC15:** AC14 now covers the two other homes (`https://www.letsgro.ai/` and the plugin-made Bricks
  site): prove it with `F2B_WEB_SITES=letsgro,plugin-bricks` and fresh captures, `skipped 0`. AC15 (live) is bdryswi.com:
  **never load it** (bot check; Justin owes the allow-list), mark it `not_run`.
- **AC7/AC8 blast radius:** the five real Figma files (`corpus/files/hydraulics-home.json`, `corpus/files/gro-home.json`,
  repo-root `figma-to-bricks-debug-page-1.json`, `figma-to-bricks-debug-design-inspo-brainstorm.json`, Services via
  `git show 2199895:figma-to-bricks-debug-page-1.json`) replay byte-identical (payload and warnings) on head and base.

## Your copy
You start in your own throwaway worktree. Run `git checkout --detach 0f9e870be571a961f4b363f72069e0370324d378` and confirm `git rev-parse HEAD`, a clean
`git status --porcelain --untracked-files=all` and `git merge-base HEAD main` = `6cfd3e6681b7d0e121173ed746ab49206c672c4e`. This head is the finisher's
combined line: web-capture's and web-compare's commits on top of `main` (branch `wave1-merge`, canonical copy
`/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a8728f5f7b81a8fe9`). Your `ac.json` names head `0f9e870be571a961f4b363f72069e0370324d378` and base `6cfd3e6681b7d0e121173ed746ab49206c672c4e`. Never write in any other worktree.

## Work
Load `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, its `references/rules-summary.md` and
`engineering-best-practices`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`
and the report format at the top of its `scripts/ac-check.sh`; follow the blind auditor procedure there. For every
runnable AC make your own head and base runs (log `HEAD=` first and `EXIT=` last; the named assertion must run, pass on
head and fail on base for changed behaviour; a setup failure is not RED; preservation that correctly passes on base is
`base_exempt` with a specific reason) and a screenshot (a real terminal image for a non-visual AC). Receipts are yours,
never copied from another role. Write `auditor-3/ac.json`, then self-check by copying your report and receipts to a fresh
scratch folder and running `ac-check.sh` on them (no `--reviews`).

## Machine
- **This machine (WSL):** `CHROME_PATH=/home/justin/.hermes/plans/figma-to-bricks/evidence/web-capture/planner/scripts/chrome-cpu.sh`, Node `/home/justin/.local/node-v22.23.3/bin` first on PATH, `TMPDIR` at most 38 characters (`~/.cache/wca3/tmp`; Chrome fails with "Socket path too long" inside the scratchpad). Kill only
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
