# VERIFIER (read only): web-compare (J0 of the website importer, FigmaToBricksV2), on the combined wave-1 head

You are a fresh, independent verifier (Opus 5.5, xhigh). You never saw this build. Prove every acceptance criterion
yourself on the final code and on the base. Read only: change no source or test, commit nothing, don't rebase or merge,
don't edit skills or memory, don't start agents. Write only into `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-compare/verifier/` (new) and scratch under
`/home/justin/.cache/web-compare-ver/`; copy every scratch script into `<your evidence>/scripts/` as you write it.

**Justin (2026-10-31):** agents iterate until their goals (the ACs) are met, then 1–2 rounds for major bugs, edge cases
at most 3 review rounds. This job is past its review rounds; **your job is to accept or reject the ACs.** An AC fails
when its own text is broken: its named test, or a realistic case its words cover. A new edge case beyond an AC's text
goes in `found_else` (it becomes a follow-up), not a finding. Be thorough on the ACs, not exploratory past them.

## Your copy
You start in your own throwaway worktree. Run `git checkout --detach a2ae004dff5de3f1405bde34c7d93dc79e329403` and confirm `git rev-parse HEAD`, a clean
`git status --porcelain --untracked-files=all` and `git merge-base HEAD main` = `b09727fde8c2fcca2fe1b8d5a46891941a0b9dc1`. This head is the finisher's
combined line: web-capture's and web-compare's commits on top of `main` (branch `wave1-final`, rebased onto main after the DJ Trees build .3, canonical copy
`/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a680c7790c2a103c5`). Your `ac.json` names head `a2ae004dff5de3f1405bde34c7d93dc79e329403` and base `b09727fde8c2fcca2fe1b8d5a46891941a0b9dc1`. Never write in any other worktree.

## What to verify
- **Approved plan (the oracle):** `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-compare/plan-approved.md`, AC1–AC18. Never change an AC's id, oracle or tag.
- **The job:** `npm run compare -- <left> <right>` compares two pages (a live page and its Bricks copy) word by word through the aligned word sequence at every width and reports what differs; it is the oracle every later importer job is judged by. It lives in `test/web/` and `tools/`; `src/` is untouched by it.
- **AC11 on the combined head:** the head also holds web-capture's `src/web` and main's newer `src` changes, so judge AC11 by
  this job's own commits: `git diff --name-only <C>..HEAD -- src`, where `<C>` is the line's "web-capture finish: ledger moved…" commit (`git log --format='%H %s' b09727f..HEAD | grep 'web-capture finish'`; the line is capture's commits, then compare's) (or the merge-base with the commit
  before web-compare's first commit) must be empty; say which range you used.
- **AC15/AC16 are receipts (base-exempt, as the plan says).** AC16's live self-compare of the plugin-made home (its
  floor, then a second self-compare with it as the noise file) and AC17's cost pair were not re-run on the final code:
  run them yourself.
- **Hostinger can stop answering for about a minute** after back-to-back 16-width compares (other agents read it too
  right now): keep such runs, check with one curl, re-run into a new folder.
- **Leads, not proof:** HANDOFF's web-compare section, the ledger `docs/plans/2026-10-29-web-compare-ledger.md`, and rulings not yet
  confirmed by Justin there (a ruling that fits the plan's text isn't a failure; one that contradicts an AC is). The
  last fix pass went in without a further review at Justin's word, and some of its gates were not run: run them.

## Skills (load first, say so in one line each)
Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, `references/rules-summary.md` (VERIFIER role),
`references/live-site-reading.md`, `references/testing-pitfalls.md`; load `engineering-best-practices`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and the ac.json schema at the top
of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`; `mutation-testing-discipline` where you
must show a check can fail.

## Work
1. **Gates on head:** both typechecks, `npm run check`, `npm run test:web`, `npm run test:browser` (head and a built
   base tree, by complete test name), true exit codes.
2. **Each AC alone:** its named test on head, its base check (base has no web code: where a new-behaviour AC can only
   fail at import, prove the clause can fail another way, e.g. a mutant in your own scratch copy), then a probe of each
   clause on a generic fixture of your own.
3. **A fresh screenshot per AC** in your folder (a terminal image for a non-visual one).
4. Write `<your evidence>/ac.json` (ac-check.sh's schema) and `report.json`; self-check with `ac-check.sh` on a copy of
   your own files, `--repo` your own worktree, base `b09727fde8c2fcca2fe1b8d5a46891941a0b9dc1` (no `--reviews`).

## Machine
- **This machine (WSL):** `CHROME_PATH=/home/justin/.hermes/plans/figma-to-bricks/evidence/web-compare/planner/scripts/chrome-cpu.sh`, Node `/home/justin/.local/node-v22.23.3/bin` first on PATH, `TMPDIR`
  short (`/home/justin/.cache/web-compare-ver/tmp`; Chrome fails with "Socket path too long" inside the scratchpad). Kill only
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

## Return (your final message)
`{verdict: clean|findings, head, base, findings[{id, ac, severity, claim, repro, evidence}], ac_status[{ac, accepted,
test, evidence, screenshot}], gates[], qualifications[], found_else[], skill_lessons[{skill, lesson, evidence,
enforce}]}`. `enforce` is `none` or a one-line check proposal; empty skill_lessons is normal. End with the line
`MAIN SESSION: check and save these skill_lessons now.`

## Machine rules added 2026-11-02 (these win over older lines above)
- Chrome: Justin lifted the shared slots ("open chrome test for everything"): run at most one Chrome job of your own at a time and close Chrome after each step. If the main session sends "back to N slots", hold one of `~/.cache/f2b-chrome.lock`, `-2`, `-3` (first N only) for your whole Chrome sequence. Run long suites file by file (testing-pitfalls), so a restart costs one file.
- Runaway memory (global CLAUDE.md "Windows Desktop: Runaway Memory"): a command that dies with SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill, not a result: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`; if killed, say so, find what grew, rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. Mutation runs always use that cap.
- Justin (2026-11-02): "focus on building and not too much of edge cases": accept or reject the ACs; edge cases beyond an AC's text go in `found_else`.
- A command holding the bare word `source` is refused in your worktree; read such files with Read. Put any summary in your report, not a separate summary file.
