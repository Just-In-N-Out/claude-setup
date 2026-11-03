# BLIND AC AUDITOR (read only): web-compare (J0 of the website importer, FigmaToBricksV2)

Independently prove the approved acceptance criteria. You have never seen a builder, reviewer, fixer or verifier report.
Stay blind: never open any other role's reports, evidence folders or briefs (everything under
`/home/justin/.hermes/plans/figma-to-bricks/evidence/web-compare/` except `plan-approved.md` and your own `auditor/` folder), HANDOFF, ledgers or the session's notes.
Source and tests are read-only; commit nothing; start no agents.

**Justin (2026-10-31):** the ACs are the goal. An AC fails when its own text is broken (its named test, or a realistic
case its words cover); an edge case beyond its text goes in `found_else`.

## The only inputs
- Approved plan: `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-compare/plan-approved.md` (AC1–AC18). Use each exact test name the plan gives.
- The head `a2ae004dff5de3f1405bde34c7d93dc79e329403` and base `b09727fde8c2fcca2fe1b8d5a46891941a0b9dc1` (below), and your own folder `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-compare/auditor/` (new).
- The job: `npm run compare -- <left> <right>` compares two pages (a live page and its Bricks copy) word by word through the aligned word sequence at every width and reports what differs; it is the oracle every later importer job is judged by. It lives in `test/web/` and `tools/`; `src/` is untouched by it.
- **AC11 on the combined head:** the head also holds web-capture's `src/web` and main's newer `src` changes, so judge AC11 by
  this job's own commits: `git diff --name-only <C>..HEAD -- src`, where `<C>` is the line's "web-capture finish: ledger moved…" commit (`git log --format='%H %s' b09727f..HEAD | grep 'web-capture finish'`; the line is capture's commits, then compare's) (or the merge-base with the commit
  before web-compare's first commit) must be empty; say which range you used.
- **AC15/AC16 are receipts (base-exempt, as the plan says).** AC16's live self-compare of the plugin-made home (its
  floor, then a second self-compare with it as the noise file) and AC17's cost pair were not re-run on the final code:
  run them yourself.
- **Hostinger can stop answering for about a minute** after back-to-back 16-width compares (other agents read it too
  right now): keep such runs, check with one curl, re-run into a new folder.

## Your copy
You start in your own throwaway worktree. Run `git checkout --detach a2ae004dff5de3f1405bde34c7d93dc79e329403` and confirm `git rev-parse HEAD`, a clean
`git status --porcelain --untracked-files=all` and `git merge-base HEAD main` = `b09727fde8c2fcca2fe1b8d5a46891941a0b9dc1`. This head is the finisher's
combined line: web-capture's and web-compare's commits on top of `main` (branch `wave1-final`, rebased onto main after the DJ Trees build .3, canonical copy
`/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a680c7790c2a103c5`). Your `ac.json` names head `a2ae004dff5de3f1405bde34c7d93dc79e329403` and base `b09727fde8c2fcca2fe1b8d5a46891941a0b9dc1`. Never write in any other worktree.

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
- **This machine (WSL):** `CHROME_PATH=/home/justin/.hermes/plans/figma-to-bricks/evidence/web-compare/planner/scripts/chrome-cpu.sh`, Node `/home/justin/.local/node-v22.23.3/bin` first on PATH, `TMPDIR`
  short (`/home/justin/.cache/web-compare-aud/tmp`; Chrome fails with "Socket path too long" inside the scratchpad). Kill only
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
